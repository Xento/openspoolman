import pytest

import mqtt_bambulab


@pytest.mark.parametrize(
    "module, expected",
    [
        ({"name": "ams_f1/0", "product_name": "AMS Lite"}, "AMS Lite"),
        ({"name": "n3f/1", "product_name": "AMS 2 Pro (2)"}, "AMS 2 Pro"),
        ({"name": "ams_ht/0", "product_name": "AMS HT"}, "AMS HT"),
        ({"name": "ams/3", "product_name": "AMS (3)"}, "AMS"),
    ],
    ids=["lite", "2pro", "ht", "ams"],
)
def test_returns_expected_model_when_module_signature_matches(module, expected):
    assert mqtt_bambulab.identify_ams_model_from_module(module) == expected


def test_returns_models_when_multiple_modules_are_present():
    modules = [
        {"name": "ams_f1/0", "product_name": "AMS Lite"},
        {"name": "n3f/0", "product_name": "AMS 2 Pro (1)"},
        {"name": "ams/0", "product_name": "AMS"},
    ]
    results = mqtt_bambulab.identify_ams_models_from_modules(modules)
    assert results["ams_f1/0"]["model"] == "AMS Lite"
    assert results["n3f/0"]["model"] == "AMS 2 Pro"
    assert results["ams/0"]["model"] == "AMS"


def test_returns_models_by_id_when_modules_have_numeric_suffixes():
    modules = [
        {"name": "ams_f1/0", "product_name": "AMS Lite"},
        {"name": "n3f/1", "product_name": "AMS 2 Pro (2)"},
    ]
    results = mqtt_bambulab.identify_ams_models_by_id(modules)
    assert results[0] == "AMS Lite"
    assert results[1] == "AMS 2 Pro"
