import json
from pathlib import Path

import pytest

import print_history
import conftest


LOG_ROOT = Path(__file__).resolve().parent / "MQTT"


def _max_print_id() -> int:
    prints, _ = print_history.get_prints_with_filament()
    return max((print_row["id"] for print_row in prints), default=0)


def _get_print_by_id(print_id: int):
    prints, _ = print_history.get_prints_with_filament()
    for print_row in prints:
        if print_row["id"] == print_id:
            return print_row
    return None


def _load_expected(log_path: Path) -> dict | None:
    expected_path = log_path.with_suffix(".expected.json")
    if not expected_path.exists():
        return None
    return json.loads(expected_path.read_text())


def _resolve_model_path(log_path: Path, expected: dict) -> Path:
    model_override = expected.get("model_path")
    if model_override:
        return Path(model_override)

    base_name = log_path.stem
    for suffix in ("_local", "_cloud"):
        idx = base_name.find(suffix)
        if idx != -1:
            base_name = base_name[:idx]
            break
    return LOG_ROOT / f"{base_name}.gcode.3mf"


def _filament_info_by_slot(print_row: dict) -> dict[int, dict]:
    filament_info = json.loads(print_row["filament_info"])
    return {entry["filament_id"]: entry for entry in filament_info}


def _sum_consume_calls(calls: list[dict]) -> dict[int, dict[str, float]]:
    totals: dict[int, dict[str, float]] = {}
    for call in calls:
        spool_id = int(call["spool_id"])
        totals.setdefault(spool_id, {"use_weight": 0.0, "use_length": 0.0})
        if call.get("use_weight") is not None:
            totals[spool_id]["use_weight"] += float(call["use_weight"])
        if call.get("use_length") is not None:
            totals[spool_id]["use_length"] += float(call["use_length"])
    return totals


def _iter_cases():
    for log_path in conftest.iter_mqtt_logs():
        expected = _load_expected(log_path)
        if expected is None:
            continue
        yield pytest.param(log_path, expected, id=log_path.name)


@pytest.mark.parametrize("track_layer_usage", [False, True], ids=["no_layer_tracking", "layer_tracking"])
@pytest.mark.parametrize("log_path, expected", list(_iter_cases()))
def test_replay_accounts_filament_consumption_correctly(
    mqtt_replay,
    fake_spoolman,
    log_path,
    expected,
    track_layer_usage,
):
    mode_key = "layer_tracking" if track_layer_usage else "no_layer_tracking"
    accounting_cfg = (expected.get("accounting") or {}).get(mode_key)
    if not accounting_cfg:
        pytest.skip(f"No accounting expectations for {log_path.name} ({mode_key})")

    model_path = _resolve_model_path(log_path, expected)
    if not model_path.exists():
        pytest.skip(f"Missing 3MF model for replay: {model_path}")

    before_id = _max_print_id()
    mqtt_replay(
        log_path,
        model_path=model_path,
        metadata_overrides=expected.get("metadata_overrides"),
        track_layer_usage=track_layer_usage,
    )

    after_id = _max_print_id()
    assert after_id == before_id + 1
    print_row = _get_print_by_id(after_id)
    assert print_row is not None

    filament_info = _filament_info_by_slot(print_row)
    expected_filaments = accounting_cfg.get("filaments") or {}
    for slot_raw, expected_entry in expected_filaments.items():
        slot = int(slot_raw)
        actual = filament_info.get(slot)
        assert actual is not None, f"Missing filament slot {slot} in {log_path.name}"
        assert actual["spool_id"] == expected_entry.get("spool_id")
        if "grams_used" in expected_entry:
            assert actual["grams_used"] == pytest.approx(expected_entry["grams_used"], abs=0.01)
        if "length_used" in expected_entry:
            assert actual["length_used"] == pytest.approx(expected_entry["length_used"], abs=1e-5)

    expected_totals = accounting_cfg.get("consume_totals")
    if expected_totals is None:
        pytest.skip(f"Missing consume totals for {log_path.name} ({mode_key})")

    totals = _sum_consume_calls(fake_spoolman["consume_calls"])
    if not expected_totals:
        assert not fake_spoolman["consume_calls"]
        return

    for spool_raw, expected_usage in expected_totals.items():
        spool_id = int(spool_raw)
        actual = totals.get(spool_id)
        assert actual is not None, f"Missing consume calls for spool {spool_id}"
        if "use_weight" in expected_usage:
            assert actual["use_weight"] == pytest.approx(expected_usage["use_weight"], abs=0.01)
        if "use_length" in expected_usage:
            assert actual["use_length"] == pytest.approx(expected_usage["use_length"], abs=1e-5)
