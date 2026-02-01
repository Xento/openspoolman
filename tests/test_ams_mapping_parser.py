import spoolman_service


def test_parse_ht_direct_with_mapping2_match(monkeypatch):
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


def test_parse_ams_mapping_cases():
    parsed = spoolman_service.parse_ams_mapping([1, 512, 3, 0, 2])
    assert [entry["ams_id"] for entry in parsed] == [0, 128, 0, 0, 0]
    assert [entry["slot_id"] for entry in parsed] == [1, 0, 3, 0, 2]

    unload = spoolman_service.parse_ams_mapping_value(255)
    assert unload["source_type"] == "unload"
    assert unload["ams_id"] is None
    assert unload["slot_id"] is None

    external = spoolman_service.parse_ams_mapping_value(254)
    assert external["source_type"] == "external"
    assert external["ams_id"] is None
    assert external["slot_id"] is None

    # Deterministic handling for values between 256 and 511 (encoded standard)
    encoded = spoolman_service.parse_ams_mapping_value(500)
    assert encoded["source_type"] == "ams"
    assert encoded["ams_id"] == 125
    assert encoded["slot_id"] == 0
