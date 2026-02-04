import json
from pathlib import Path

import pytest

import conftest
import print_history
import spoolman_service
import tools_3mf
from config import EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID


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


def _iter_payloads(log_path: Path):
    with log_path.open() as handle:
        for line in handle:
            if "::" not in line:
                continue
            try:
                payload = json.loads(line.split("::", 1)[1].strip())
            except Exception:
                continue
            yield payload


def _extract_ams_mapping(log_path: Path) -> list | None:
    for payload in _iter_payloads(log_path):
        print_block = payload.get("print") or {}
        if print_block.get("command") == "project_file":
            mapping = print_block.get("ams_mapping")
            if isinstance(mapping, list) and mapping:
                return mapping
    return None


def _tray_uid_to_spool_id(fake_spoolman: dict) -> dict[str, int]:
    mapping: dict[str, int] = {}
    for spool in fake_spoolman.get("spools", []):
        extra = spool.get("extra") or {}
        active_tray = extra.get("active_tray")
        if not active_tray:
            continue
        try:
            tray_uid = json.loads(active_tray)
        except (TypeError, json.JSONDecodeError):
            tray_uid = active_tray
        if tray_uid:
            mapping[tray_uid] = int(spool["id"])
    return mapping


def _expected_spool_for_filament(
    filament_id: int,
    ams_mapping: list,
    tray_to_spool: dict[str, int],
    metadata: dict,
) -> int | None:
    if not ams_mapping:
        return None

    if ams_mapping[0] == EXTERNAL_SPOOL_ID:
        tray_uid = spoolman_service.trayUid(EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID)
        return tray_to_spool.get(tray_uid)

    index = spoolman_service._resolve_tool_index_for_filament(metadata, filament_id)
    if index is None:
        return None
    entry = (
        spoolman_service.parse_ams_mapping_value(ams_mapping[index])
        if 0 <= index < len(ams_mapping)
        else {"source_type": "unknown", "ams_id": None, "slot_id": None}
    )

    if entry.get("source_type") == "external":
        tray_uid = spoolman_service.trayUid(EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID)
        return tray_to_spool.get(tray_uid)
    if entry.get("source_type") == "ams":
        tray_uid = spoolman_service.trayUid(entry.get("ams_id"), entry.get("slot_id"))
        return tray_to_spool.get(tray_uid)
    return None


def _iter_cases():
    for log_path in conftest.iter_mqtt_logs():
        yield pytest.param(log_path, _load_expected(log_path), id=log_path.name)


@pytest.mark.parametrize("log_path, expected", list(_iter_cases()))
def test_replay_printhistory_spool_assignment_matches_ams_mapping(
    mqtt_replay,
    fake_spoolman,
    log_path,
    expected,
):
    ams_mapping = _extract_ams_mapping(log_path)
    if not ams_mapping:
        pytest.skip(f"No ams_mapping found in replay: {log_path.name}")

    model_path = _resolve_model_path(log_path, expected)
    if not model_path.exists():
        pytest.skip(f"Missing 3MF model for replay: {model_path}")

    metadata = tools_3mf.getMetaDataFrom3mf(f"local:{model_path}")
    if expected.get("metadata_overrides"):
        metadata.update(expected["metadata_overrides"])

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
    tray_to_spool = _tray_uid_to_spool_id(fake_spoolman)

    for entry in filament_info:
        filament_id = int(entry["filament_id"])
        expected_spool_id = _expected_spool_for_filament(
            filament_id, ams_mapping, tray_to_spool, metadata
        )
        assert entry.get("spool_id") == expected_spool_id
