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
def test_replay_creates_printhistory_entry_and_detects_type(
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


def test_replay_detects_filaments_and_maps_to_spools(mqtt_replay, fake_spoolman):
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

    for entry in filament_info:
        ams_slot = entry["ams_slot"]
        assert entry["spool_id"] == expected_spool_ids[ams_slot]
        assert entry["color"].upper() == expected_colors[ams_slot]

    consumed_spools = {call["spool_id"] for call in fake_spoolman["consume_calls"]}
    assert consumed_spools == set(expected_spool_ids.values())


def test_replay_appends_history_entry_on_repeat(mqtt_replay, fake_spoolman):
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
