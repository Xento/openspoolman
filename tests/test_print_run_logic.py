import mqtt_bambulab
from bambu_state import Features, PRINT_RUN_REGISTRY, get_job_label
from filament_usage_tracker import FilamentUsageTracker
from config import PRINTER_ID, EXTERNAL_SPOOL_ID


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

  assert len(print_run_env["insert_calls"]) == 2


def test_tracker_reuses_cached_model_file_without_second_retrieve(monkeypatch, tmp_path):
  tracker = FilamentUsageTracker()
  cached_model = tmp_path / "cached_model.3mf"
  cached_model.write_bytes(b"dummy")
  tracker.print_metadata = {"downloaded_model_path": str(cached_model)}

  retrieved_urls = []
  started = {}

  def _retrieve_model(self, model_url):
    retrieved_urls.append(model_url)
    return None

  def _start_layer_tracking_for_model(
      self,
      model_path,
      gcode_file_name,
      use_ams,
      ams_mapping,
      task_id,
      subtask_id,
  ):
    started["model_path"] = model_path
    started["gcode_file_name"] = gcode_file_name
    started["use_ams"] = use_ams
    started["ams_mapping"] = ams_mapping
    started["task_id"] = task_id
    started["subtask_id"] = subtask_id

  monkeypatch.setattr(FilamentUsageTracker, "_retrieve_model", _retrieve_model)
  monkeypatch.setattr(FilamentUsageTracker, "_start_layer_tracking_for_model", _start_layer_tracking_for_model)

  tracker._handle_print_start(
    {
      "url": "file:///sdcard/Testprint.gcode.3mf",
      "param": "Metadata/plate_1.gcode",
      "use_ams": True,
      "ams_mapping": [0],
      "task_id": "1",
      "subtask_id": "1",
    }
  )

  assert started["model_path"] == str(cached_model)
  assert retrieved_urls == []
  assert "downloaded_model_path" not in tracker.print_metadata


def test_pending_metadata_switch_keeps_same_cached_model_file(tmp_path):
  _reset_state()
  cached_model = tmp_path / "shared_model.3mf"
  cached_model.write_bytes(b"model")

  mqtt_bambulab.PENDING_PRINT_METADATA = {"downloaded_model_path": str(cached_model)}
  mqtt_bambulab._set_pending_print_metadata({"downloaded_model_path": str(cached_model), "file": "next"})

  assert cached_model.exists()

  mqtt_bambulab._set_pending_print_metadata({})
  assert not cached_model.exists()


def test_metadata_download_uses_fixed_cache_file_when_layer_tracking_enabled(monkeypatch):
  captured = {}

  def _get_metadata(source, keep_downloaded_file=False, downloaded_file_path=None):
    captured["source"] = source
    captured["keep_downloaded_file"] = keep_downloaded_file
    captured["downloaded_file_path"] = downloaded_file_path
    return {"file": "Testprint.3mf"}

  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", True)
  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", _get_metadata)

  metadata = mqtt_bambulab._maybe_download_metadata("file:///sdcard/Testprint.3mf", "test")

  assert metadata == {"file": "Testprint.3mf"}
  assert captured["source"] == "file:///sdcard/Testprint.3mf"
  assert captured["keep_downloaded_file"] is True
  assert captured["downloaded_file_path"] == str(mqtt_bambulab.MODEL_CACHE_PATH)


def test_map_filament_initializes_missing_change_list():
  _reset_state()
  mqtt_bambulab.PENDING_PRINT_METADATA = {
    "use_ams": True,
    "filamentOrder": {0: 0},
    "ams_mapping": [],
  }

  mapped = mqtt_bambulab.map_filament(3)

  assert mapped is True
  assert mqtt_bambulab.PENDING_PRINT_METADATA["filamentChanges"] == [3]
  assert mqtt_bambulab.PENDING_PRINT_METADATA["ams_mapping"] == [3]


def test_process_message_skips_local_ams_mapping_when_not_using_ams(monkeypatch):
  _reset_state()
  mqtt_bambulab.PENDING_PRINT_METADATA = {
    "use_ams": False,
    "complete": True,
    "print_type": "lan",
    "ams_mapping": [EXTERNAL_SPOOL_ID],
  }
  mqtt_bambulab.PRINTER_STATE_LAST = {"print": {"stg_cur": -1}}

  monkeypatch.setattr(mqtt_bambulab, "map_filament", lambda _tray: (_ for _ in ()).throw(AssertionError("map_filament must not be called")))
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", False)
  monkeypatch.setattr(mqtt_bambulab, "spendFilaments", lambda *_args, **_kwargs: None)

  mqtt_bambulab.processMessage(
    {
      "print": {
        "print_type": "local",
        "stg_cur": 4,
        "ams": {"tray_tar": "3"},
      }
    }
  )
