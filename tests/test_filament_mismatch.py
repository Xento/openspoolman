import json

import pytest

import spoolman_service as svc


def _make_tray(tray_type, tray_sub_brands, tray_id="tray-1"):
    return {
        "tray_type": tray_type,
        "tray_sub_brands": tray_sub_brands,
        "tray_color": "FFFFFF",
        "id": tray_id,
    }


def _make_spool(material, extra_type, ams_id=0, tray_id="tray-1", spool_id=1, spool_extra_type=None):
    return {
        "id": spool_id,
        "remaining_weight": 1000,
        # SpoolMan may carry a type in spool.extra; include it when provided.
        "extra": {
            "active_tray": json.dumps(svc.trayUid(ams_id, tray_id)),
            **({"type": spool_extra_type if spool_extra_type is not None else extra_type} if (spool_extra_type is not None or extra_type) else {}),
        },
        "filament": {
            "name": "Test",
            "vendor": {"name": "Vendor"},
            "material": material,
            "extra": {"type": extra_type} if extra_type is not None else {},
            "color_hex": "FFFFFF",
        },
    }


def _run_case(tray, spool, ams_id=0, tray_id="tray-1", log_stub=None):
    spool_list = [spool]
    # avoid file writes during tests
    original_log_fn = svc._log_filament_mismatch
    svc._log_filament_mismatch = log_stub or (lambda *args, **kwargs: None)
    try:
        svc.augmentTrayDataWithSpoolMan(spool_list, tray, ams_id, tray_id)
    finally:
        svc._log_filament_mismatch = original_log_fn
    return tray


def test_match_with_extra_type():
    tray = _make_tray("PLA", "PLA CF")
    spool = _make_spool("PLA", "CF")
    result = _run_case(tray, spool)

    assert result["matched"] is True
    assert result["mismatch"] is False
    assert result["tray_sub_brand"] == "CF"
    assert result["spool_sub_brand"] == "CF"


def test_match_when_material_contains_subtype():
    tray = _make_tray("PLA", "PLA CF")
    spool = _make_spool("PLA CF", "-")
    result = _run_case(tray, spool)

    assert result["matched"] is True
    assert result["mismatch"] is False
    assert result["tray_sub_brand"] == "CF"
    assert result["spool_sub_brand"] == "CF"


def test_mismatch_when_subtype_missing_on_spool():
    tray = _make_tray("PLA", "PLA CF")
    spool = _make_spool("PLA", "")
    result = _run_case(tray, spool)

    assert result["matched"] is True
    assert result["mismatch"] is True
    assert result["tray_sub_brand"] == "CF"
    assert result["spool_sub_brand"] == ""


def test_material_mismatch_even_if_subtype_matches():
    tray = _make_tray("PLA", "PLA CF")
    spool = _make_spool("ABS CF", "CF")
    result = _run_case(tray, spool)

    assert result["matched"] is True
    assert result["mismatch"] is True
    assert result["tray_sub_brand"] == "CF"
    assert result["spool_sub_brand"] == "CF"


def test_variant_type_requires_exact_material_match():
    tray = _make_tray("PLA-S", "Support for PLA")
    spool = _make_spool("PLA", "Support for PLA")
    result = _run_case(tray, spool)

    assert result["matched"] is True
    assert result["mismatch"] is True  # main type differs because tray expects PLA-S


def test_variant_type_matches_when_spool_material_exact():
    tray = _make_tray("PLA-S", "Support for PLA")
    spool = _make_spool("PLA-S", "Support for PLA")
    result = _run_case(tray, spool)

    assert result["matched"] is True
    assert result["mismatch"] is False


def test_mismatch_warning_can_be_disabled(monkeypatch):
    monkeypatch.setattr(svc, "DISABLE_MISMATCH_WARNING", True)
    tray = _make_tray("PLA", "PLA CF")
    spool = _make_spool("PLA", "")
    result = _run_case(tray, spool)

    assert result["mismatch_detected"] is True
    assert result["mismatch"] is False  # hidden in UI


def test_color_mismatch_logs_distance():
    tray = _make_tray("PLA", "")
    tray["tray_color"] = "FFFFFF"
    spool = _make_spool("PLA", "")
    spool["filament"]["color_hex"] = "000000"

    captured = {}

    def _capture_log(tray_logged, spool_logged, color_distance=None, reason="material_mismatch"):
        captured["color_distance"] = color_distance
        captured["reason"] = reason

    result = _run_case(tray, spool, log_stub=_capture_log)

    assert result["color_mismatch"] is True
    assert captured["reason"] == "color_mismatch"
    assert captured["color_distance"] is not None
    assert captured["color_distance"] > svc.COLOR_DISTANCE_TOLERANCE


BAMBULAB_BASE_MAPPINGS = [
    # tray_type, tray_sub_brands, spool_material, spool_type, expected_match
    ("ABS", "", "ABS", "", True),
    ("ABS-GF", "", "ABS-GF", "", True),
    ("ASA", "", "ASA", "", True),
    ("ASA-AERO", "", "ASA-AERO", "", True),
    ("ASA-CF", "", "ASA-CF", "", True),
    ("PA-CF", "", "PA-CF", "", True),
    ("PA6-CF", "", "PA6-CF", "", True),
    ("PA-GF", "", "PA-GF", "", True),
    ("PA-CF", "", "PA-CF", "", True),  # PAHT-CF uses PA-CF
    ("PC", "", "PC", "", True),
    ("PC", "PC FR", "PC FR", "", True),
    ("PET-CF", "", "PET-CF", "", True),
    ("PETG", "PETG Basic", "PETG Basic", "", True),
    ("PETG", "PETG HF", "PETG HF", "", True),
    ("PETG", "PETG Translucent", "PETG Translucent", "", True),
    ("PETG-CF", "", "PETG-CF", "", True),
    
    # tray value variants
    ("PLA", "PLA Basic", "PLA Basic", "", True),
    ("PLA", "PLA Basic", "PLA", "", True),
    ("PLA", "PLA Basic", "PLA", "Basic", True),
    ("PLA", "PLA Basic", "PLA", "-", True),
    ("PLA", "", "PLA", "Basic", True),
    ("PLA", "", "PLA", "-", True),
    ("PLA", "", "PLA", "", True),

    ("PLA", "PLA Aero", "PLA Aero", "", True),
    ("PLA", "PLA Dynamic", "PLA Dynamic", "", True),
    ("PLA", "PLA Galaxy", "PLA Galaxy", "", True),
    ("PLA", "PLA Glow", "PLA Glow", "", True),
    ("PLA", "PLA Impact", "PLA Impact", "", True),
    ("PLA", "PLA Lite", "PLA Lite", "", True),
    ("PLA", "PLA Marble", "PLA Marble", "", True),
    ("PLA", "PLA Matte", "PLA Matte", "", True),
    ("PLA", "PLA Metal", "PLA Metal", "", True),
    ("PLA", "PLA Silk", "PLA Silk", "", True),
    ("PLA", "PLA Silk+", "PLA Silk+", "", True),
    ("PLA", "PLA Sparkle", "PLA Sparkle", "", True),
    ("PLA", "PLA Tough", "PLA Tough", "", True),
    ("PLA", "PLA Tough+", "PLA Tough+", "", True),
    ("PLA", "PLA Translucent", "PLA Translucent", "", True),
    ("PLA", "PLA Wood", "PLA Wood", "", True),
    ("PLA-CF", "", "PLA-CF", "", True),
    ("PPA-CF", "", "PPA-CF", "", True),
    ("PPA-GF", "", "PPA-GF", "", True),
    ("PPS-CF", "", "PPS-CF", "", True),
    ("PVA", "", "PVA", "", True),

    # variant type matches (Support)
    ("PLA-S", "Support For PLA", "PLA-S", "Support For PLA", True),
    ("PLA-S", "Support For PLA", "PLA-S", "-", True),
    ("PLA-S", "Support For PLA", "PLA-S", "", True),
    
    ("ABS-S", "Support for ABS", "ABS-S", "Support for ABS", True),
    ("Support", "Support For PA PET", "Support For PA PET", "", True),
    ("Support", "Support For PLA-PETG", "Support For PLA-PETG", "", True),
    ("Support", "Support G", "Support G", "", True),
    ("Support", "Support W", "Support W", "", True),
    ("TPU", "TPU 85A", "TPU 85A", "", True),
    ("TPU", "TPU 90A", "TPU 90A", "", True),
    ("TPU", "TPU 95A", "TPU 95A", "", True),
    ("TPU", "TPU 95A HF", "TPU 95A HF", "", True),
    ("TPU-AMS", "", "TPU-AMS", "", True),
    # Example mismatch: wrong subtype despite matching main
    ("PLA", "PLA CF", "PLA CF", "Wood", False),
]


def test_bambu_base_profiles_match_tray_expectations():
    failures = []
    for tray_type, tray_sub_brands, spool_material, spool_type, expected_match in BAMBULAB_BASE_MAPPINGS:
        tray = _make_tray(tray_type, tray_sub_brands)
        spool = _make_spool(spool_material, spool_type, spool_extra_type=spool_type)

        result = _run_case(tray, spool)

        ctx = f"(tray_type={tray_type!r}, tray_sub_brands={tray_sub_brands!r}, spool_material={spool_material!r}, spool_type={spool_type!r})"
        if result["matched"] is not True:
            failures.append(f"{ctx} did not match tray/spool assignment")
            continue

        if expected_match and result.get("mismatch_detected"):
            failures.append(f"{ctx} unexpectedly triggered mismatch")
        if not expected_match and not result.get("mismatch_detected"):
            failures.append(f"{ctx} should trigger mismatch but did not")

    if failures:
        pytest.fail("\n".join(failures))
