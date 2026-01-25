import copy
import json
import logging
import os
import shutil
import tempfile
from pathlib import Path
import pytest

import mqtt_bambulab
import filament_usage_tracker
from filament_usage_tracker import FilamentUsageTracker
import tools_3mf
import spoolman_client
import spoolman_service


LOG_ROOT = Path(__file__).resolve().parent / "MQTT"


def _build_mock_spools():
  return [
    {
      "id": 3,
      "filament": {
        "name": "PLA Sample Filament",
        "vendor": {"name": "OpenSpoolMan"},
        "material": "PLA",
        "color_hex": "FF5733",
        "extra": {"type": "PLA Basic"},
      },
      "initial_weight": 1000,
      "price": 30,
      "remaining_weight": 995,
      "extra": {
        "active_tray": json.dumps(spoolman_service.trayUid(0, 3)),
      },
    },
  ]


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
  monkeypatch.setattr("filament_usage_tracker.consumeSpool", lambda *args, **kwargs: None)
  monkeypatch.setattr(spoolman_service, "setActiveTray", lambda *args, **kwargs: None)
  monkeypatch.setattr(spoolman_service, "spendFilaments", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "fetchSpools", lambda *args, **kwargs: copy.deepcopy(_build_mock_spools()))
  monkeypatch.setattr(mqtt_bambulab, "setActiveTray", lambda *args, **kwargs: None)
  monkeypatch.setattr(mqtt_bambulab, "spendFilaments", lambda *args, **kwargs: None)
  monkeypatch.setattr(spoolman_client, "fetchSpoolList", lambda *args, **kwargs: copy.deepcopy(_build_mock_spools()))


def _stub_history(monkeypatch, insert_calls=None):
  # Keep DB untouched.
  def _record_insert(*args, **kwargs):
    if insert_calls is not None:
      insert_calls.append((args, kwargs))
    return 1

  monkeypatch.setattr("print_history.insert_print", _record_insert)
  monkeypatch.setattr("mqtt_bambulab.insert_print", _record_insert)
  monkeypatch.setattr("print_history.insert_filament_usage", lambda *args, **kwargs: None)
  monkeypatch.setattr("print_history.update_filament_spool", lambda *args, **kwargs: None)
  monkeypatch.setattr("print_history.update_filament_grams_used", lambda *args, **kwargs: None)
  monkeypatch.setattr("print_history.update_layer_tracking", lambda *args, **kwargs: None)


def _build_fake_get_meta(model_path: Path):
  original_get_meta = tools_3mf.getMetaDataFrom3mf
  def _fake(_url: str):
    if not model_path.exists():
      raise FileNotFoundError(f"Test 3MF not found: {model_path}")
    metadata = original_get_meta(f"local:{model_path}")
    if _url:
      _, filename = tools_3mf.filename_from_url(_url)
      metadata["file"] = filename or _url
      metadata.setdefault("model_url", _url)
    return metadata
  return _fake


def _build_fake_metadata():
  def _fake(url: str):
    model_url = url or ""
    _, filename = tools_3mf.filename_from_url(url)
    model_name = filename or "unknown.3mf"
    return {
      "image": "test.png",
      "filaments": {
        1: {
          "type": "PLA",
          "color": "#000000",
          "used_g": "0",
          "used_m": "0",
          "tray_info_idx": "FAKE",
        }
      },
      "usage": {1: "0"},
      "file": model_name,
      "model_path": model_url,
      "model_url": model_url,
    }
  return _fake


def _is_model_url(value: str) -> bool:
  if value.startswith("file:"):
    return True
  return "://" in value


def _model_name_from_url(url: str | None) -> str | None:
  _, filename = tools_3mf.filename_from_url(url)
  return filename


def test_print_mode_classification():
  assert mqtt_bambulab._classify_project_source(
    "https://or-cloud-upload-prod.s3.us-west-2.amazonaws.com/model.3mf",
    None,
    False,
  ) == "cloud"
  assert mqtt_bambulab._classify_project_source(
    "file:///data/Metadata/plate_1.gcode",
    "local",
    True,
  ) == "lan_only"
  assert mqtt_bambulab._classify_project_source(
    "file:///data/Metadata/plate_1.gcode",
    "local",
    False,
  ) == "local"


@pytest.mark.parametrize(
  "track_layer_usage",
  [False, True],
  ids=lambda value: "layer_tracking_on" if value else "layer_tracking_off",
)
@pytest.mark.parametrize("log_path", _iter_log_files(), ids=lambda p: p.name)
def test_mqtt_log_tray_detection(log_path, track_layer_usage, tmp_path, monkeypatch, caplog):
  # Use a stable printer serial in tests to make tray IDs deterministic.
  monkeypatch.setattr(spoolman_service, "PRINTER_ID", "PRINTER_SERIAL")
  monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", track_layer_usage)
  monkeypatch.setattr(filament_usage_tracker, "TRACK_LAYER_USAGE", track_layer_usage)
  monkeypatch.setattr(filament_usage_tracker, "CHECKPOINT_DIR", tmp_path / "checkpoint")

  expected = _load_expected(log_path)
  expected_assignments_raw = expected.get("expected_assignments") or {}
  expected_assignments = {str(k): str(v) for k, v in expected_assignments_raw.items()}
  expected_assignments_by_index = {int(k): str(v) for k, v in expected_assignments_raw.items()}
  expected_models_raw = expected.get("expected_models") or expected.get("expected_model") or []
  expected_models = [expected_models_raw] if isinstance(expected_models_raw, str) else list(expected_models_raw)
  expected_print_type = expected.get("expected_print_type")
  skip_3mf_download = bool(
    expected.get("skip_model_download")
  )

  temp_model_path = None
  if not skip_3mf_download:
    model_path = _base_model_from_log(log_path)
    if not model_path.exists():
      # Only verify the file name/model URL when no local 3MF is available.
      skip_3mf_download = True
    else:
      temp_file = tempfile.NamedTemporaryFile(suffix=".3mf", delete=False)
      temp_file.close()
      temp_model_path = Path(temp_file.name)
      shutil.copy2(model_path, temp_model_path)
  if skip_3mf_download:
    # Provide a stub 3MF path so the filament tracker can initialize AMS mapping.
    temp_file = tempfile.NamedTemporaryFile(suffix=".3mf", delete=False)
    temp_file.close()
    temp_model_path = Path(temp_file.name)

  insert_calls = []
  _stub_spoolman(monkeypatch)
  _stub_history(monkeypatch, insert_calls)

  def _record_metadata_assignments(metadata):
    for idx, tray in enumerate((metadata or {}).get("ams_mapping", [])):
      if tray is None:
        continue
      assignments[str(idx)] = str(tray)

  if skip_3mf_download:
    monkeypatch.setattr("mqtt_bambulab.getMetaDataFrom3mf", _build_fake_metadata())
  else:
    monkeypatch.setattr("mqtt_bambulab.getMetaDataFrom3mf", _build_fake_get_meta(temp_model_path))

  # Reset MQTT state to get a clean replay.
  mqtt_bambulab.PRINTER_STATE = {}
  mqtt_bambulab.PRINTER_STATE_LAST = {}
  mqtt_bambulab.PENDING_PRINT_METADATA = {}

  assignments = {}
  last_tracker_mapping: list | None = None
  observed_model_urls = []
  observed_model_files = []
  observed_print_type = None

  mqtt_bambulab.FILAMENT_TRACKER = FilamentUsageTracker()

  original_map_filament = mqtt_bambulab.map_filament

  def _record_map(tray_tar):
    result = original_map_filament(tray_tar)
    _record_metadata_assignments(mqtt_bambulab.PENDING_PRINT_METADATA)
    return result
  
  monkeypatch.setattr(mqtt_bambulab, "map_filament", _record_map)
  original_resolve = FilamentUsageTracker._resolve_tray_mapping

  def _record_resolve(self, filament_index):
    result = original_resolve(self, filament_index)
    if result is not None:
      assignments[str(filament_index)] = str(result)
    return result
  
  monkeypatch.setattr(FilamentUsageTracker, "_resolve_tray_mapping", _record_resolve)
  original_spend = mqtt_bambulab.spendFilaments

  def _record_spend(metadata):
    _record_metadata_assignments(metadata)
    return original_spend(metadata)
  
  monkeypatch.setattr(mqtt_bambulab, "spendFilaments", _record_spend)
  original_set_metadata = FilamentUsageTracker.set_print_metadata

  def _record_set_metadata(self, metadata):
    _record_metadata_assignments(metadata)
    return original_set_metadata(self, metadata)
  
  monkeypatch.setattr(FilamentUsageTracker, "set_print_metadata", _record_set_metadata)
  original_start_model = FilamentUsageTracker._start_layer_tracking_for_model

  def _record_start_layer_tracking(self, model_path, gcode_file_name, use_ams, ams_mapping, task_id, subtask_id):
    metadata = getattr(self, "print_metadata", {}) or {}
    metadata_file = metadata.get("file")
    if metadata_file:
      observed_model_files.append(metadata_file)
    if gcode_file_name:
      observed_model_files.append(os.path.basename(gcode_file_name))
    return original_start_model(self, model_path, gcode_file_name, use_ams, ams_mapping, task_id, subtask_id)
  
  monkeypatch.setattr(FilamentUsageTracker, "_start_layer_tracking_for_model", _record_start_layer_tracking)

  def _record_retrieve(self, model_url):
    if model_url:
      observed_model_urls.append(model_url)
      model_name = _model_name_from_url(model_url)
      if model_name:
        observed_model_files.append(model_name)
    return str(temp_model_path)

  if skip_3mf_download:
    monkeypatch.setattr(FilamentUsageTracker, "_retrieve_model", _record_retrieve)
    # Avoid parsing a real model file; just provide an empty model structure.
    monkeypatch.setattr(FilamentUsageTracker, "_load_model", lambda self, *_: setattr(self, "active_model", {0: {}}))
    monkeypatch.setattr("filament_usage_tracker.save_checkpoint", lambda *_, **__: None)
  else:
    monkeypatch.setattr(FilamentUsageTracker, "_retrieve_model", _record_retrieve)

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
            if tray is None:
              continue
            assignments[str(idx)] = str(tray)
        candidate_types = []
        if metadata:
          metadata_type = metadata.get("print_type")
          if metadata_type:
            candidate_types.append(metadata_type)
        state_type = mqtt_bambulab.PRINTER_STATE.get("print", {}).get("print_type")
        if state_type:
          candidate_types.append(state_type)
        for candidate in candidate_types:
          if candidate != "idle":
            observed_print_type = candidate
            break
        tracker_mapping = mqtt_bambulab.FILAMENT_TRACKER.ams_mapping
        if tracker_mapping:
          last_tracker_mapping = list(tracker_mapping)
  finally:
    if temp_model_path is not None:
      temp_model_path.unlink(missing_ok=True)

  if expected_models:
    missing_models = []
    for expected_model in expected_models:
      if _is_model_url(expected_model):
        if expected_model not in observed_model_urls:
          missing_models.append(expected_model)
      else:
        if expected_model not in observed_model_files:
          missing_models.append(expected_model)
    assert not missing_models, (
      f"{log_path.name}: expected models not observed={missing_models} "
      f"observed_urls={observed_model_urls} observed_files={observed_model_files}"
    )
  elif expected_print_type == "cloud":
    assert any(url.startswith("https://") for url in observed_model_urls), (
      f"{log_path.name}: expected https model URL for cloud print "
      f"observed_urls={observed_model_urls}"
    )

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

  if track_layer_usage and expected_assignments_by_index:
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

  if expected_print_type is not None:
    assert observed_print_type == expected_print_type, (
      f"{log_path.name}: print type mismatch expected={expected_print_type} observed={observed_print_type}"
    )

  assert len(insert_calls) <= 1, (
    f"{log_path.name}: expected at most one print insert, got {len(insert_calls)}"
  )

  caplog.set_level(logging.INFO)
  logging.getLogger(__name__).info(
      "Log %s -> assignments=%s expected_assignments=%s",
      log_path.name,
      assignments,
      expected_assignments,
  )
