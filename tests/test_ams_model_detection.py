import mqtt_bambulab


def test_identifies_ams_lite_module():
    module = {"name": "ams_f1/0", "product_name": "AMS Lite"}
    assert mqtt_bambulab.identify_ams_model_from_module(module) == "AMS Lite"


def test_identifies_ams_2_pro_module():
    module = {"name": "n3f/1", "product_name": "AMS 2 Pro (2)"}
    assert mqtt_bambulab.identify_ams_model_from_module(module) == "AMS 2 Pro"


def test_identifies_ams_ht_module():
    module = {"name": "ams_ht/0", "product_name": "AMS HT"}
    assert mqtt_bambulab.identify_ams_model_from_module(module) == "AMS HT"


def test_falls_back_to_ams_when_name_matches():
    module = {"name": "ams/3", "product_name": "AMS (3)"}
    assert mqtt_bambulab.identify_ams_model_from_module(module) == "AMS"


def test_detects_multiple_modules():
    modules = [
        {"name": "ams_f1/0", "product_name": "AMS Lite"},
        {"name": "n3f/0", "product_name": "AMS 2 Pro (1)"},
        {"name": "ams/0", "product_name": "AMS"},
    ]
    results = mqtt_bambulab.identify_ams_models_from_modules(modules)
    assert results["ams_f1/0"]["model"] == "AMS Lite"
    assert results["n3f/0"]["model"] == "AMS 2 Pro"
    assert results["ams/0"]["model"] == "AMS"


def test_detects_models_by_numeric_id():
    modules = [
        {"name": "ams_f1/0", "product_name": "AMS Lite"},
        {"name": "n3f/1", "product_name": "AMS 2 Pro (2)"},
    ]
    results = mqtt_bambulab.identify_ams_models_by_id(modules)
    assert results[0] == "AMS Lite"
    assert results[1] == "AMS 2 Pro"
