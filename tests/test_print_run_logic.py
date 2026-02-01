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


def test_print_start_detected_by_state_not_prepare_percent(monkeypatch):
  _reset_state()

  calls = []
  monkeypatch.setattr(mqtt_bambulab, "insert_print", lambda *args, **kwargs: calls.append(args) or 1)
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", lambda _url: _mock_metadata())
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "PREPARE", "gcode_file_prepare_percent": "99", "gcode_file": "Testprint.3mf"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is None
  assert calls == []

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "RUNNING", "gcode_file": "Testprint.3mf", "print_type": "local"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is not None
  assert len(calls) == 1


def test_prepare_percent_99_allows_early_download_when_supported(monkeypatch):
  _reset_state()

  calls = []
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", lambda _url: calls.append(_url) or _mock_metadata())
  monkeypatch.setattr(mqtt_bambulab, "insert_print", lambda *args, **kwargs: 1)
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setitem(mqtt_bambulab.MODEL_FEATURES, mqtt_bambulab.PRINTER_MODEL_NAME, {Features.SUPPORTS_EARLY_FTP_DOWNLOAD})
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "PREPARE", "gcode_file_prepare_percent": "99", "url": "ftp://printer/Testprint.3mf"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is None
  assert len(calls) == 1

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "RUNNING", "url": "ftp://printer/Testprint.3mf", "print_type": "local"}}
  )
  assert PRINT_RUN_REGISTRY.get_active_run(PRINTER_ID) is not None
  assert len(calls) == 1


def test_prepare_percent_99_does_not_trigger_early_download_when_not_supported(monkeypatch):
  _reset_state()

  calls = []
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", lambda _url: calls.append(_url) or _mock_metadata())
  monkeypatch.setattr(mqtt_bambulab, "insert_print", lambda *args, **kwargs: 1)
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setitem(mqtt_bambulab.MODEL_FEATURES, mqtt_bambulab.PRINTER_MODEL_NAME, set())
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)

  mqtt_bambulab.processMessage(
    {"print": {"gcode_state": "PREPARE", "gcode_file_prepare_percent": "99", "url": "ftp://printer/Testprint.3mf"}}
  )
  assert calls == []


def test_url_preferred_over_gcode_file_for_label():
  payload = {"print": {"url": "ftp://printer/Testprint.3mf", "gcode_file": "Other.3mf"}}
  assert get_job_label(payload) == "ftp://printer/Testprint.3mf"

  payload = {"print": {"gcode_file": "Only.3mf"}}
  assert get_job_label(payload) == "Only.3mf"


def test_no_double_start_while_active(monkeypatch):
  _reset_state()

  calls = []
  monkeypatch.setattr(mqtt_bambulab, "insert_print", lambda *args, **kwargs: calls.append(args) or 1)
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", lambda _url: _mock_metadata())
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)

  payload = {"print": {"gcode_state": "RUNNING", "gcode_file": "Testprint.3mf", "print_type": "local"}}
  mqtt_bambulab.processMessage(payload)
  mqtt_bambulab.processMessage(payload)

  assert len(calls) == 1


def test_same_label_can_run_twice_after_final(monkeypatch):
  _reset_state()

  calls = []
  monkeypatch.setattr(mqtt_bambulab, "insert_print", lambda *args, **kwargs: calls.append(args) or 1)
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", lambda _url: _mock_metadata())
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)

  start_payload = {"print": {"gcode_state": "RUNNING", "gcode_file": "Testprint.3mf", "print_type": "local"}}
  finish_payload = {"print": {"gcode_state": "FINISH", "gcode_file": "Testprint.3mf", "print_type": "local"}}

  mqtt_bambulab.processMessage(start_payload)
  mqtt_bambulab.processMessage(finish_payload)
  mqtt_bambulab.processMessage(start_payload)

  assert len(calls) == 2
