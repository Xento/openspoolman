import pytest

import mqtt_bambulab
from bambu_state import Features, PRINT_RUN_REGISTRY, get_job_label
from filament_usage_tracker import FilamentUsageTracker
from config import PRINTER_ID


def _reset_state():
  mqtt_bambulab.PRINTER_STATE = {}
  mqtt_bambulab.PRINTER_STATE_LAST = {}
  mqtt_bambulab.PENDING_PRINT_METADATA = {}
  mqtt_bambulab.PENDING_PRINT_REFERENCE = {}
  mqtt_bambulab.FILAMENT_TRACKER = FilamentUsageTracker()
  mqtt_bambulab.PRINT_RUN_REGISTRY.reset()


def _mock_metadata():
  return {
    "file": "Testprint.3mf",
    "image": None,
    "filaments": {
      1: {"type": "PLA", "color": "#FFFFFF", "used_g": "1.0", "used_m": "1.0"},
    },
  }


@pytest.fixture
def print_run_env(monkeypatch):
  _reset_state()

  insert_calls = []
  metadata_calls = []

  def _get_metadata(url):
    metadata_calls.append(url)
    return _mock_metadata()

  monkeypatch.setattr(
    mqtt_bambulab,
    "insert_print",
    lambda *args, **kwargs: insert_calls.append(args) or 1,
  )
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", _get_metadata)
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)
  monkeypatch.setitem(mqtt_bambulab.MODEL_FEATURES, mqtt_bambulab.PRINTER_MODEL_NAME, set())

  return {"insert_calls": insert_calls, "metadata_calls": metadata_calls}


def test_starts_run_when_state_running_not_prepare_percent(print_run_env):
  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "PREPARE", "gcode_file_prepare_percent": "99", "gcode_file": "Testprint.3mf"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is None
  assert print_run_env["insert_calls"] == []

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "RUNNING", "gcode_file": "Testprint.3mf", "print_type": "local"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is not None
  assert len(print_run_env["insert_calls"]) == 1


def test_triggers_early_download_when_prepare_99_and_supported(monkeypatch, print_run_env):
  monkeypatch.setitem(
    mqtt_bambulab.MODEL_FEATURES,
    mqtt_bambulab.PRINTER_MODEL_NAME,
    {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  )

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "PREPARE", "gcode_file_prepare_percent": "99", "url": "ftp://printer/Testprint.3mf"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is None
  assert len(print_run_env["metadata_calls"]) == 1

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "RUNNING", "url": "ftp://printer/Testprint.3mf", "print_type": "local"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is not None
  assert len(print_run_env["metadata_calls"]) == 1


def test_skips_early_download_when_prepare_99_and_unsupported(print_run_env):
  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "PREPARE", "gcode_file_prepare_percent": "99", "url": "ftp://printer/Testprint.3mf"}}
  )
  assert print_run_env["metadata_calls"] == []


def test_prefers_url_when_present_in_payload():
  payload = {"print": {"url": "ftp://printer/Testprint.3mf", "gcode_file": "Other.3mf"}}
  assert get_job_label(payload) == "ftp://printer/Testprint.3mf"

  payload = {"print": {"gcode_file": "Only.3mf"}}
  assert get_job_label(payload) == "Only.3mf"


def test_does_not_start_new_run_when_active(print_run_env):
  payload = {"print": {"gcode_state": "RUNNING", "gcode_file": "Testprint.3mf", "print_type": "local"}}
  mqtt_bambulab.processMessage(payload)
  mqtt_bambulab.processMessage(payload)

  assert len(print_run_env["insert_calls"]) == 1


def test_allows_same_label_after_finish(print_run_env):
  start_payload = {"print": {"gcode_state": "RUNNING", "gcode_file": "Testprint.3mf", "print_type": "local"}}
  finish_payload = {"print": {"gcode_state": "FINISH", "gcode_file": "Testprint.3mf", "print_type": "local"}}

  mqtt_bambulab.processMessage(start_payload)
  mqtt_bambulab.processMessage(finish_payload)
  mqtt_bambulab.processMessage(start_payload)

  assert len(print_run_env["insert_calls"]) == 2
