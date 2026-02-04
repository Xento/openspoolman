import json
from pathlib import Path

import pytest

import print_history
import spoolman_service
import conftest


LOG_ROOT = Path(__file__).resolve().parent / "MQTT"


def _max_print_id() -> int:
    prints, _ = print_history.get_prints_with_filament()
    return max((print_row["id"] for print_row in prints), default=0)


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


def _get_print_by_id(print_id: int):
    prints, _ = print_history.get_prints_with_filament()
    for print_row in prints:
        if print_row["id"] == print_id:
            return print_row
    return None


def _filament_info_by_slot(print_row: dict) -> dict[int, dict]:
    filament_info = json.loads(print_row["filament_info"])
    return {entry["filament_id"]: entry for entry in filament_info}


def _iter_cases():
    for log_path in conftest.iter_mqtt_logs():
        expected = _load_expected(log_path)
        if expected is None:
            continue
        yield pytest.param(log_path, expected, id=log_path.name)


@pytest.mark.parametrize("track_layer_usage", [False, True], ids=["no_layer_tracking", "layer_tracking"])
@pytest.mark.parametrize("log_path, expected", list(_iter_cases()))
def test_assigns_spools_when_replaying_ams_mapping(
    mqtt_replay,
    fake_spoolman,
    monkeypatch,
    log_path,
    expected,
    track_layer_usage,
):
    mapping_root = expected.get("mapping") or {}
    mapping_no = mapping_root.get("no_layer_tracking")
    mapping_layer = mapping_root.get("layer_tracking")
    if not mapping_no and not mapping_layer:
        pytest.skip(f"No mapping expectations for {log_path.name}")

    if mapping_no and mapping_layer:
        assert mapping_no.get("expected_spool_ids") == mapping_layer.get(
            "expected_spool_ids"
        ), "Spool mapping must be identical with and without layer tracking"

    mapping_cfg = mapping_layer if track_layer_usage else mapping_no
    if mapping_cfg is None:
        mapping_cfg = mapping_layer or mapping_no

    model_path = _resolve_model_path(log_path, expected)
    if not model_path.exists():
        pytest.skip(f"Missing 3MF model for replay: {model_path}")

    logs = []
    monkeypatch.setattr(spoolman_service, "log", lambda msg: logs.append(msg))

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
    expected_spools = mapping_cfg.get("expected_spool_ids") or {}
    for slot_raw, expected_spool_id in expected_spools.items():
        slot = int(slot_raw)
        actual = filament_info.get(slot)
        assert actual is not None, f"Missing filament slot {slot} in {log_path.name}"
        assert actual["spool_id"] == expected_spool_id

    if mapping_cfg.get("expect_ams_mapping2_mismatch") and not track_layer_usage:
        assert any("AMS mapping mismatch" in msg for msg in logs)
