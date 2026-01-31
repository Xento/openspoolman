import copy
import json
from pathlib import Path

import mqtt_bambulab
import pytest
from datetime import datetime
import spoolman_client
import spoolman_service
import filament_usage_tracker
from filament_usage_tracker import FilamentUsageTracker
import print_history
import tools_3mf


def _build_spools(printer_id: str):
  spools = []
  for slot in range(4):
    spools.append(
      {
        "id": slot + 1,
        "filament": {"diameter": 1.75, "density": 1.24},
        "extra": {"active_tray": json.dumps(f"{printer_id}_0_{slot}")},
      }
    )
  return spools


def _replay_log(log_path: Path):
  with log_path.open() as handle:
    for line in handle:
      if "::" not in line:
        continue
      payload = json.loads(line.split("::", 1)[1].strip())
      mqtt_bambulab.processMessage(payload)
      mqtt_bambulab.FILAMENT_TRACKER.on_message(payload)


def _load_billing_cases():
  config_path = Path(__file__).resolve().parent / "fixtures" / "print_history_billing_config.json"
  config = json.loads(config_path.read_text())
  return config.get("cases") or {}

def _install_test_logger(prefix: str, monkeypatch, sink: list[str]) -> None:
  def _prefixed_log(*args, **kwargs):
    sep = kwargs.get("sep", " ")
    message = sep.join(str(arg) for arg in args)
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{timestamp}] [{prefix}] {message}"
    sink.append(line)

  for module in (
    mqtt_bambulab,
    filament_usage_tracker,
    print_history,
    tools_3mf,
    spoolman_service,
    spoolman_client,
  ):
    monkeypatch.setattr(module, "log", _prefixed_log)


@pytest.mark.parametrize(
  "track_layer_usage",
  [False, True],
  ids=lambda value: "layer_tracking_on" if value else "layer_tracking_off",
)
@pytest.mark.parametrize("case_name, case", _load_billing_cases().items())
def test_print_history_billing_from_mqtt_replay(case_name, case, track_layer_usage, tmp_path, monkeypatch, request):
  output_lines: list[str] = []
  mode_label = "layer_tracking" if track_layer_usage else "no_layer_tracking"
  _install_test_logger(f"{case_name}/{mode_label}", monkeypatch, output_lines)
  try:
    output_lines.append(f"[billing-test] start case={case_name} mode={mode_label}")
    db_path = tmp_path / "print_history.db"
    print_history.db_config["db_path"] = str(db_path)
    print_history.create_database()

    monkeypatch.setattr(spoolman_service, "PRINTER_ID", "PRINTER_SERIAL")
    monkeypatch.setattr(mqtt_bambulab, "PRINTER_ID", "PRINTER_SERIAL")
    monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", track_layer_usage)
    monkeypatch.setattr(filament_usage_tracker, "TRACK_LAYER_USAGE", track_layer_usage)
    monkeypatch.setattr(filament_usage_tracker, "CHECKPOINT_DIR", tmp_path / "checkpoint")

    spools = _build_spools("PRINTER_SERIAL")
    monkeypatch.setattr(spoolman_service, "fetchSpools", lambda *args, **kwargs: copy.deepcopy(spools))
    monkeypatch.setattr(mqtt_bambulab, "fetchSpools", lambda *args, **kwargs: copy.deepcopy(spools))
    monkeypatch.setattr(filament_usage_tracker, "fetchSpools", lambda *args, **kwargs: copy.deepcopy(spools))
    monkeypatch.setattr(spoolman_service, "setActiveTray", lambda *args, **kwargs: None)
    monkeypatch.setattr(mqtt_bambulab, "setActiveTray", lambda *args, **kwargs: None)
    monkeypatch.setattr(spoolman_service, "clear_active_spool_for_tray", lambda *args, **kwargs: None)
    monkeypatch.setattr(spoolman_client, "patchExtraTags", lambda *args, **kwargs: None)

    consume_calls = []

    def _record_consume(spool_id, use_weight=None, use_length=None):
      consume_calls.append(
        {"spool_id": spool_id, "use_weight": use_weight, "use_length": use_length}
      )

    monkeypatch.setattr(spoolman_client, "consumeSpool", _record_consume)
    monkeypatch.setattr(filament_usage_tracker, "consumeSpool", _record_consume)

    model_path = Path(case.get("model_file") or "").resolve()

    def _download_from_cloud(_url, dest_file):
      dest_file.write(model_path.read_bytes())
      return True

    def _download_from_ftp(_name, dest_file):
      dest_file.write(model_path.read_bytes())
      return True

    monkeypatch.setattr(tools_3mf, "download3mfFromCloud", _download_from_cloud)
    monkeypatch.setattr(filament_usage_tracker, "download3mfFromCloud", _download_from_cloud)
    monkeypatch.setattr(tools_3mf, "download3mfFromFTP", _download_from_ftp)
    monkeypatch.setattr(filament_usage_tracker, "download3mfFromFTP", _download_from_ftp)

    mqtt_bambulab.PRINTER_STATE = {}
    mqtt_bambulab.PRINTER_STATE_LAST = {}
    mqtt_bambulab.PENDING_PRINT_METADATA = {}
    mqtt_bambulab.ACTIVE_PRINT_ID = None
    mqtt_bambulab.FILAMENT_TRACKER = FilamentUsageTracker()

    expected_length_by_spool = {
      int(spool_id): float(length)
      for spool_id, length in (case.get("expected_length_mm_by_spool") or {}).items()
    }
    expected_weight_by_spool = {
      int(spool_id): float(weight)
      for spool_id, weight in (case.get("expected_weight_g_by_spool") or {}).items()
    }

    log_path = Path(case.get("log_path") or "")
    _replay_log(log_path)

    prints, total = print_history.get_prints_with_filament()
    assert total == 1
    print_id = prints[0]["id"]

    usage = print_history.get_all_filament_usage_for_print(print_id)
    output_lines.append(f"[billing-test] case={case_name} mode={mode_label} print_id={print_id}")
    assert usage, "Expected filament usage rows to be updated"
    assert all(row.get("grams_used", 0) > 0 for row in usage.values())
    if track_layer_usage:
      assert all(row.get("length_used", 0) > 0 for row in usage.values())

    if track_layer_usage:
      assert expected_length_by_spool, "Expected billing config missing lengths"
    else:
      assert expected_weight_by_spool, "Expected billing config missing weights"
    assert consume_calls, "Expected Spoolman consumption calls"
    if track_layer_usage:
      assert all(call.get("use_length", 0) > 0 for call in consume_calls)
    else:
      assert all(call.get("use_weight", 0) > 0 for call in consume_calls)

    totals_by_spool = {}
    for call in consume_calls:
      spool_id = call.get("spool_id")
      used = call.get("use_length") if track_layer_usage else call.get("use_weight")
      amount = used or 0.0
      totals_by_spool[spool_id] = totals_by_spool.get(spool_id, 0.0) + amount

    for ams_slot, row in usage.items():
      filament_row = print_history.get_filament_for_slot(print_id, ams_slot)
      spool_id = filament_row.get("spool_id") if filament_row else None
      if track_layer_usage:
        expected_amount = expected_length_by_spool.get(spool_id, 0.0)
        actual_amount = row.get("length_used") or 0.0
      else:
        expected_amount = expected_weight_by_spool.get(spool_id, 0.0)
        actual_amount = row.get("grams_used") or 0.0
      assert expected_amount > 0
      assert actual_amount == pytest.approx(expected_amount, rel=1e-3, abs=0.01)

    expected_totals = expected_length_by_spool if track_layer_usage else expected_weight_by_spool
    for spool_id, expected_amount in expected_totals.items():
      actual_amount = totals_by_spool.get(spool_id, 0.0)
      assert actual_amount == pytest.approx(expected_amount, rel=1e-3, abs=0.01)
  finally:
    if output_lines:
      output_lines.append(f"[billing-test] end case={case_name} mode={mode_label}")
      request.node.add_report_section("call", "stdout", "\n".join(output_lines))
      print("\n".join(output_lines))
