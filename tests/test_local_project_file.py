import mqtt_bambulab


class _DummyTracker:
  def __init__(self):
    self.active_model = None
    self.started = False

  def start_local_print_from_metadata(self, metadata):
    self.started = True

  def set_print_metadata(self, metadata):
    pass

  def apply_ams_mapping(self, mapping):
    pass


def test_local_project_file_not_cloud(monkeypatch):
  def fake_get_meta(url, gcode_path=None):
    return {
      "filaments": {
        1: {
          "type": "PLA",
          "color": "#000000",
          "used_g": "0",
          "used_m": "0",
        }
      },
      "image": "test.png",
      "file": "demo.gcode.3mf",
      "model_path": url,
      "filamentOrder": {2: 0},
    }

  calls = []
  def fake_insert_print(name, print_type, image):
    calls.append((name, print_type))
    return 123

  monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", fake_get_meta)
  monkeypatch.setattr(mqtt_bambulab, "insert_print", fake_insert_print)
  monkeypatch.setattr(mqtt_bambulab, "insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "spendFilaments", lambda *args, **kwargs: None)
  dummy_tracker = _DummyTracker()
  monkeypatch.setattr(mqtt_bambulab, "FILAMENT_TRACKER", dummy_tracker)

  mqtt_bambulab.PRINTER_STATE = {}
  mqtt_bambulab.PRINTER_STATE_LAST = {}
  mqtt_bambulab.PENDING_PRINT_METADATA = {}

  mqtt_bambulab.processMessage({
    "print": {
      "command": "project_file",
      "url": "file:///sdcard/demo.gcode.3mf",
      "ams_mapping": [-1, -1, 2, -1],
    }
  })

  assert mqtt_bambulab.PENDING_PRINT_METADATA.get("metadata_loaded") is True
  assert calls == []

  mqtt_bambulab.processMessage({
    "print": {
      "command": "push_status",
      "print_type": "local",
      "gcode_state": "RUNNING",
      "gcode_file": "demo.gcode.3mf",
    }
  })

  assert any(call[1] == "local" for call in calls)
  assert dummy_tracker.started is True
