import json
import logging
import os
import shutil
import tempfile
from pathlib import Path

import pytest

import mqtt_bambulab
from filament_usage_tracker import FilamentUsageTracker
import tools_3mf
import spoolman_client
import spoolman_service
from config import TRACK_LAYER_USAGE


LOG_ROOT = Path(__file__).resolve().parent / "MQTT"


def _iter_log_files():
  env_file = os.getenv("MQTT_LOG_FILE")
  if env_file:
    candidate = Path(env_file)
    if not candidate.is_absolute():
      candidate = LOG_ROOT / candidate
    return [candidate]

  printer = os.getenv("MQTT_LOG_PRINTER")
  firmware = os.getenv("MQTT_LOG_FIRMWARE")
  search_root = LOG_ROOT
  if printer:
    search_root = search_root / printer
  if firmware:
    search_root = search_root / firmware
  if printer or firmware:
    return sorted(search_root.glob("*.log"))

  return sorted(LOG_ROOT.glob("*/*/*.log"))


def _load_expected(log_path: Path) -> dict:
  expected_path = log_path.with_suffix(".expected.json")
  if not expected_path.exists():
    pytest.skip(f"Missing expected result file: {expected_path}")
  return json.loads(expected_path.read_text())


def _base_model_from_log(log_path: Path) -> Path:
  base_name = log_path.stem
  for suffix in ("_local", "_cloud"):
    idx = base_name.find(suffix)
    if idx != -1:
      base_name = base_name[:idx]
      break
  gcode_candidate = LOG_ROOT / f"{base_name}.gcode.3mf"
  return gcode_candidate


def _stub_spoolman(monkeypatch):
  # Disable any real billing/network calls.
  monkeypatch.setattr(spoolman_client, "consumeSpool", lambda *args, **kwargs: None)
  monkeypatch.setattr(spoolman_service, "consumeSpool", lambda *args, **kwargs: None)
  monkeypatch.setattr("filament_usage_tracker.consumeSpool", lambda *args, **kwargs: None)
  monkeypatch.setattr(spoolman_service, "fetchSpools", lambda *args, **kwargs: [])
  monkeypatch.setattr(spoolman_service, "setActiveTray", lambda *args, **kwargs: None)
  monkeypatch.setattr(spoolman_service, "spendFilaments", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "fetchSpools", lambda *args, **kwargs: [])
  monkeypatch.setattr(mqtt_bambulab, "setActiveTray", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "spendFilaments", lambda *args, **kwargs: None)


def _stub_history(monkeypatch):
  # Keep DB untouched.
  monkeypatch.setattr("print_history.insert_print", lambda *args, **kwargs: 1)
  monkeypatch.setattr("print_history.insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr("print_history.update_filament_spool", lambda *args, **kwargs: None)
  monkeypatch.setattr("print_history.update_filament_grams_used", lambda *args, **kwargs: None)
  monkeypatch.setattr("print_history.update_layer_tracking", lambda *args, **kwargs: None)


def _build_fake_get_meta(model_path: Path):
  original_get_meta = tools_3mf.getMetaDataFrom3mf
  def _fake(_url: str):
    if not model_path.exists():
      raise FileNotFoundError(f"Test 3MF not found: {model_path}")
    return original_get_meta(f"local:{model_path}")
  return _fake


@pytest.mark.parametrize("log_path", _iter_log_files(), ids=lambda p: p.name)
def test_mqtt_log_tray_detection(log_path, monkeypatch, caplog):
  expected = _load_expected(log_path)
  expected_assignments_raw = expected.get("expected_assignments") or {}
  expected_assignments = {str(k): str(v) for k, v in expected_assignments_raw.items()}
  expected_assignments_by_index = {int(k): str(v) for k, v in expected_assignments_raw.items()}

  model_path = _base_model_from_log(log_path)
  if not model_path.exists():
    pytest.skip(f"Missing test model: {model_path}")

  temp_file = tempfile.NamedTemporaryFile(suffix=".3mf", delete=False)
  temp_file.close()
  temp_model_path = Path(temp_file.name)
  shutil.copy2(model_path, temp_model_path)

  _stub_spoolman(monkeypatch)
  _stub_history(monkeypatch)

  monkeypatch.setattr("mqtt_bambulab.getMetaDataFrom3mf", _build_fake_get_meta(temp_model_path))

  # Reset MQTT state to get a clean replay.
  mqtt_bambulab.PRINTER_STATE = {}
  mqtt_bambulab.PRINTER_STATE_LAST = {}
  mqtt_bambulab.PENDING_PRINT_METADATA = {}

  assignments = {}
  last_tracker_mapping: list[int] | None = None

  mqtt_bambulab.FILAMENT_TRACKER = FilamentUsageTracker()

  original_map_filament = mqtt_bambulab.map_filament

  def _record_map(tray_tar):
    result = original_map_filament(tray_tar)
    metadata = mqtt_bambulab.PENDING_PRINT_METADATA or {}
    for idx, tray in enumerate(metadata.get("ams_mapping", [])):
      assignments[str(idx)] = str(tray)
    return result
  
  monkeypatch.setattr(mqtt_bambulab, "map_filament", _record_map)
  original_resolve = FilamentUsageTracker._resolve_tray_mapping

  def _record_resolve(self, filament_index):
    result = original_resolve(self, filament_index)
    if result is not None:
      assignments[str(filament_index)] = str(result)
    return result
  
  monkeypatch.setattr(FilamentUsageTracker, "_resolve_tray_mapping", _record_resolve)
  monkeypatch.setattr(FilamentUsageTracker, "_retrieve_model", lambda self, _: str(temp_model_path))

  try:
    with log_path.open() as handle:
      for line in handle:
        if "::" not in line:
          continue
        try:
          payload = json.loads(line.split("::", 1)[1].strip())
        except Exception:
          continue

        mqtt_bambulab.processMessage(payload)
        mqtt_bambulab.FILAMENT_TRACKER.on_message(payload)
        metadata = mqtt_bambulab.PENDING_PRINT_METADATA
        if metadata:
          for idx, tray in enumerate(metadata.get("ams_mapping", [])):
            assignments[str(idx)] = str(tray)
        tracker_mapping = mqtt_bambulab.FILAMENT_TRACKER.ams_mapping
        if tracker_mapping:
          last_tracker_mapping = list(tracker_mapping)
  finally:
    temp_model_path.unlink(missing_ok=True)

  if expected_assignments:
    missing = {
      filament: expected_tray
      for filament, expected_tray in expected_assignments.items()
      if assignments.get(filament) != expected_tray
    }
    extra = {
      filament: tray
      for filament, tray in assignments.items()
      if filament not in expected_assignments
    }
    assert not missing and not extra, (
        f"{log_path.name}: assignment mismatch missing={missing} extra={extra} "
        f"vs expected={expected_assignments} actual={assignments}")

  if TRACK_LAYER_USAGE and expected_assignments_by_index:
    tracker_mapping = last_tracker_mapping or []
    tracker_mapping_str = [str(value) for value in tracker_mapping]
    missing_tracker = {
      str(idx): expected_tray
      for idx, expected_tray in expected_assignments_by_index.items()
      if idx >= len(tracker_mapping_str) or tracker_mapping_str[idx] != expected_tray
    }
    assert not missing_tracker, (
        f"{log_path.name}: filament tracker mapping mismatch missing={missing_tracker} "
        f"tracker_mapping={tracker_mapping_str} expected={expected_assignments}")

  caplog.set_level(logging.INFO)
  logging.getLogger(__name__).info(
      "Log %s -> assignments=%s expected_assignments=%s",
      log_path.name,
      assignments,
      expected_assignments,
  )
