import pytest

import spoolman_service


def test_returns_mapping_when_mapping2_matches(monkeypatch):
    logs = []
    monkeypatch.setattr(spoolman_service, "log", lambda msg: logs.append(msg))

    parsed = spoolman_service.parse_ams_mapping(
        [128],
        [{"ams_id": 128, "slot_id": 0}],
    )

    assert parsed[0]["source_type"] == "ams"
    assert parsed[0]["ams_id"] == 128
    assert parsed[0]["slot_id"] == 0
    assert not any("AMS mapping mismatch" in msg for msg in logs)


def test_parses_ams_mapping_when_values_provided():
    parsed = spoolman_service.parse_ams_mapping([1, 512, 3, 0, 2])
    assert [entry["ams_id"] for entry in parsed] == [0, 128, 0, 0, 0]
    assert [entry["slot_id"] for entry in parsed] == [1, 0, 3, 0, 2]


@pytest.mark.parametrize(
    "value, expected",
    [
        (255, {"source_type": "unload", "ams_id": None, "slot_id": None}),
        (254, {"source_type": "external", "ams_id": None, "slot_id": None}),
        (500, {"source_type": "ams", "ams_id": 125, "slot_id": 0}),
    ],
    ids=["unload", "external", "encoded"],
)
def test_parses_mapping_value_when_code_provided(value, expected):
    assert spoolman_service.parse_ams_mapping_value(value) == expected
