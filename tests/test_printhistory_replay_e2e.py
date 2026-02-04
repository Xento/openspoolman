import json
from pathlib import Path

import pytest

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


@pytest.mark.parametrize(
    "log_name, expected_type",
    [
        ("Testqube_cloud.log", "cloud"),
        ("Testqube_local.log", "local"),
    ],
)
def test_creates_printhistory_entry_when_replaying_log(
    mqtt_replay, log_name, expected_type
):
    log_path = LOG_ROOT / "A1" / "01.07.00.00" / log_name
    before_id = _max_print_id()
    mqtt_replay(log_path)

    after_id = _max_print_id()
    assert after_id == before_id + 1
    print_row = _get_print_by_id(after_id)
    assert print_row is not None
    assert print_row["print_type"] == expected_type


def test_maps_filaments_to_spools_when_replaying_log(mqtt_replay, fake_spoolman):
    log_path = LOG_ROOT / "A1" / "01.07.00.00" / "Testqube_Multicolor_cloud.log"
    before_id = _max_print_id()
    mqtt_replay(log_path)

    after_id = _max_print_id()
    assert after_id == before_id + 1
    print_row = _get_print_by_id(after_id)
    assert print_row is not None
    filament_info = json.loads(print_row["filament_info"])
    assert len(filament_info) == 4

    expected_spool_ids = {
        1: 103,
        2: 100,
        3: 102,
        4: 101,
    }
    expected_colors = {
        1: "#FFFFFF",
        2: "#FFFF00",
        3: "#FF0000",
        4: "#0000FF",
    }

    actual_spool_ids = {entry["filament_id"]: entry["spool_id"] for entry in filament_info}
    actual_colors = {entry["filament_id"]: entry["color"].upper() for entry in filament_info}
    assert actual_spool_ids == expected_spool_ids
    assert actual_colors == expected_colors

    consumed_spools = {call["spool_id"] for call in fake_spoolman["consume_calls"]}
    assert consumed_spools == set(expected_spool_ids.values())


def test_appends_history_entry_when_replaying_log_twice(mqtt_replay, fake_spoolman):
    log_path = LOG_ROOT / "A1" / "01.07.00.00" / "Testqube_cloud.log"

    before_id = _max_print_id()
    mqtt_replay(log_path)
    first_id = _max_print_id()
    assert first_id == before_id + 1
    first_consume_count = len(fake_spoolman["consume_calls"])
    assert first_consume_count == 1

    mqtt_replay(log_path)
    second_id = _max_print_id()
    assert second_id == first_id + 1
    assert len(fake_spoolman["consume_calls"]) == first_consume_count * 2
