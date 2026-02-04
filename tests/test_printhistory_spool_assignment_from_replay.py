import json
from pathlib import Path

import pytest

import conftest
import print_history


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


def _load_expected(log_path: Path) -> dict:
    expected_path = log_path.with_suffix(".expected.json")
    if not expected_path.exists():
        return {}
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


def _expected_spool_ids(expected: dict) -> dict[int, int | None]:
    mapping_root = expected.get("mapping") or {}
    mapping_cfg = mapping_root.get("no_layer_tracking") or mapping_root.get("layer_tracking")
    if not mapping_cfg:
        return {}
    expected_spools = mapping_cfg.get("expected_spool_ids") or {}
    normalized: dict[int, int | None] = {}
    for slot, spool_id in expected_spools.items():
        slot_id = int(slot)
        if spool_id is None:
            normalized[slot_id] = None
        else:
            normalized[slot_id] = int(spool_id)
    return normalized


def _iter_cases():
    for log_path in conftest.iter_mqtt_logs():
        yield pytest.param(log_path, _load_expected(log_path), id=log_path.name)


@pytest.mark.parametrize("log_path, expected", list(_iter_cases()))
def test_assigns_spools_when_replaying_print_history(
    mqtt_replay,
    log_path,
    expected,
):
    expected_spools = _expected_spool_ids(expected)
    if not expected_spools:
        pytest.skip(f"No expected spool mapping for {log_path.name}")

    model_path = _resolve_model_path(log_path, expected)
    if not model_path.exists():
        pytest.skip(f"Missing 3MF model for replay: {model_path}")

    before_id = _max_print_id()
    mqtt_replay(
        log_path,
        model_path=model_path,
        metadata_overrides=expected.get("metadata_overrides"),
    )

    after_id = _max_print_id()
    assert after_id == before_id + 1
    print_row = _get_print_by_id(after_id)
    assert print_row is not None

    filament_info = json.loads(print_row["filament_info"])
    actual_spools = {int(entry["filament_id"]): entry.get("spool_id") for entry in filament_info}
    observed_spools = {filament_id: actual_spools.get(filament_id) for filament_id in expected_spools}
    assert observed_spools == expected_spools
