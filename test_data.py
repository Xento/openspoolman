import json
import os
import time
from copy import deepcopy
from datetime import datetime, timedelta
from contextlib import ExitStack, contextmanager
import importlib
from pathlib import Path
from unittest.mock import patch

from config import (
    EXTERNAL_SPOOL_AMS_ID,
    EXTERNAL_SPOOL_ID,
)
from spoolman_service import augmentTrayDataWithSpoolMan, trayUid

TEST_MODE_FLAG = os.getenv("OPENSPOOLMAN_TEST_DATA") == "1"
SNAPSHOT_PATH = os.getenv("OPENSPOOLMAN_TEST_SNAPSHOT") or os.path.join("data", "live_snapshot.json")

_TEST_PRINTER_ID = os.getenv("PRINTER_ID", "TEST-PRINTER")
_PATCH_ACTIVE = False


def _now_iso(hours_ago: int = 0) -> str:
    return (datetime.utcnow() - timedelta(hours=hours_ago)).strftime("%Y-%m-%dT%H:%M:%SZ")


DEFAULT_DATASET = {
    "spools": [
    {
        "id": 1,
        "remaining_weight": 735.5,
        "remaining_length": 24300,
        "cost_per_gram": 0.05,
        "registered": "2024-01-10T12:00:00Z",
        "last_used": _now_iso(5),
        "filament": {
            "name": "Sunset Orange",
            "material": "PLA",
            "vendor": {"name": "OpenMaker"},
            "color_hex": "FF6B35",
            "extra": {
                "type": "Basic",
                "nozzle_temperature": "[200,215]",
                "filament_id": "PLA-OM-ORANGE",
            },
        },
        "extra": {
            "tag": json.dumps("NFC-TAG-PLA-01"),
            "active_tray": json.dumps(trayUid(0, 0)),
        },
    },
    {
        "id": 2,
        "remaining_weight": 910.2,
        "remaining_length": 27600,
        "cost_per_gram": 0.07,
        "registered": "2024-02-15T08:30:00Z",
        "last_used": _now_iso(30),
        "filament": {
            "name": "Midnight Black",
            "material": "PETG",
            "vendor": {"name": "ProtoPrint"},
            "color_hex": "0F0F0F",
            "extra": {
                "type": "Matte",
                "nozzle_temperature": "[230,245]",
                "filament_id": "PETG-PP-BLACK",
            },
        },
        "extra": {
            "tag": json.dumps("NFC-TAG-PETG-02"),
            "active_tray": json.dumps(trayUid(EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID)),
        },
    },
    {
        "id": 3,
        "remaining_weight": 520.0,
        "remaining_length": 18000,
        "cost_per_gram": 0.06,
        "registered": "2024-03-21T15:45:00Z",
        "last_used": _now_iso(48),
        "filament": {
            "name": "Sky Blue",
            "material": "PLA",
            "vendor": {"name": "ColorWorks"},
            "color_hex": "7EC8E3",
            "extra": {
                "type": "Silk",
                "nozzle_temperature": "[205,220]",
                "filament_id": "PLA-CW-BLUE",
            },
        },
        "extra": {
            "tag": json.dumps("NFC-TAG-PLA-03"),
            "active_tray": json.dumps(trayUid(0, 1)),
        },
    },
    ],
    "last_ams_config": {
    "ams": [
        {
            "id": 0,
            "humidity": 25,
            "tray": [
                {
                    "id": 0,
                    "tray_type": "PLA",
                    "tray_sub_brands": "Basic",
                    "tray_color": "FF6B35",
                    "tray_info_idx": "PLA-OM-ORANGE",
                    "remain": 82,
                    "active": True,
                },
                {
                    "id": 1,
                    "tray_type": "PLA",
                    "tray_sub_brands": "Silk",
                    "tray_color": "7EC8E3",
                    "tray_info_idx": "PLA-CW-BLUE",
                    "remain": 55,
                    "active": True,
                },
                {
                    "id": 2,
                    "tray_type": "PETG",
                    "tray_sub_brands": "Matte",
                    "tray_color": "0F0F0F",
                    "tray_info_idx": "PETG-PP-BLACK",
                    "remain": 0,
                    "active": False,
                },
                {
                    "id": 3,
                    "tray_type": "PETG",
                    "tray_sub_brands": "Basic",
                    "tray_color": "8CC84B",
                    "tray_info_idx": "PETG-PP-GREEN",
                    "remain": 0,
                    "active": False,
                },
            ],
        }
    ],
        "vt_tray": {
            "id": EXTERNAL_SPOOL_ID,
            "tray_type": "PETG",
            "tray_sub_brands": "Matte",
            "tray_color": "0F0F0F",
            "tray_info_idx": "PETG-PP-BLACK",
            "remain": 64,
            "active": True,
        },
    },
    "settings": {
        "currency": "USD",
        "currency_symbol": "$",
    },
    "prints": [
    {
        "id": 1001,
        "print_date": (datetime.utcnow() - timedelta(days=2)).strftime("%Y-%m-%d %H:%M:%S"),
        "file_name": "AMS_cover.gcode",
        "print_type": "cloud",
        "image_file": None,
        "filament_info": json.dumps(
            [
                {
                    "spool_id": 1,
                    "filament_type": "PLA",
                    "color": "Sunset Orange",
                    "grams_used": 48.5,
                    "ams_slot": 1,
                }
            ]
        ),
    },
    {
        "id": 1002,
        "print_date": (datetime.utcnow() - timedelta(days=1, hours=3)).strftime("%Y-%m-%d %H:%M:%S"),
        "file_name": "Spool_hook.gcode",
        "print_type": "cloud",
        "image_file": None,
        "filament_info": json.dumps(
            [
                {
                    "spool_id": 2,
                    "filament_type": "PETG",
                    "color": "Midnight Black",
                    "grams_used": 36.2,
                    "ams_slot": 255,
                }
            ]
        ),
    },
    {
        "id": 1003,
        "print_date": (datetime.utcnow() - timedelta(hours=6)).strftime("%Y-%m-%d %H:%M:%S"),
        "file_name": "Calibration_cube.gcode",
        "print_type": "local",
        "image_file": None,
        "filament_info": json.dumps(
            [
                {
                    "spool_id": 3,
                    "filament_type": "PLA",
                    "color": "Sky Blue",
                    "grams_used": 12.0,
                    "ams_slot": 2,
                }
            ]
        ),
    },
    ],
    "printer": {
        "model": "X1 Carbon (test mode)",
        "devicename": _TEST_PRINTER_ID,
    },
}


def _compute_cost_per_gram(spool: dict) -> dict:
    if "cost_per_gram" in spool:
        return spool

    initial_weight = spool.get("initial_weight") or spool.get("filament", {}).get("weight")
    price = spool.get("price") or spool.get("filament", {}).get("price")

    if initial_weight and price:
        try:
            spool["cost_per_gram"] = float(price) / float(initial_weight)
        except (TypeError, ValueError, ZeroDivisionError):
            spool["cost_per_gram"] = 0
    else:
        spool["cost_per_gram"] = 0

    return spool


def _load_snapshot(path: str | Path):
    snapshot_path = Path(path)
    if not snapshot_path.exists():
        return None

    try:
        with snapshot_path.open("r", encoding="utf-8") as f:
            data = json.load(f)
    except (OSError, json.JSONDecodeError):
        return None

    spools = [_compute_cost_per_gram(spool) for spool in data.get("spools", [])]

    return {
        "spools": spools,
        "last_ams_config": data.get("last_ams_config") or {},
        "settings": data.get("settings") or {},
        "prints": data.get("prints", []),
        "printer": data.get("printer") or {},
    }


_DATASET = deepcopy(DEFAULT_DATASET)
_SNAPSHOT_DATA = _load_snapshot(SNAPSHOT_PATH)
if _SNAPSHOT_DATA:
    _DATASET.update({k: deepcopy(v) for k, v in _SNAPSHOT_DATA.items()})

TEST_SPOOLS = _DATASET["spools"]
TEST_LAST_AMS_CONFIG = _DATASET["last_ams_config"]
TEST_SETTINGS = _DATASET["settings"]
TEST_PRINTS = _DATASET["prints"]
TEST_PRINTER = _DATASET["printer"] or {
    "model": "X1 Carbon (test mode)",
    "devicename": _TEST_PRINTER_ID,
}


def current_dataset() -> dict:
    """Return a deep copy of the active dataset (seeded or snapshot-backed)."""

    return deepcopy(_DATASET)


def isMqttClientConnected():
    return True


def getPrinterModel():
    return deepcopy(TEST_PRINTER)


def fetchSpools():
    return deepcopy(TEST_SPOOLS)


def getLastAMSConfig():
    config = deepcopy(TEST_LAST_AMS_CONFIG)
    spool_list = fetchSpools()
    augmentTrayDataWithSpoolMan(spool_list, config["vt_tray"], trayUid(EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID))
    for ams in config.get("ams", []):
        for tray in ams.get("tray", []):
            augmentTrayDataWithSpoolMan(spool_list, tray, trayUid(ams["id"], tray["id"]))
    return config


def getSettings():
    return deepcopy(TEST_SETTINGS)


def patchExtraTags(spool_id, _, new_tags):
    for spool in TEST_SPOOLS:
        if spool["id"] == int(spool_id):
            spool.setdefault("extra", {}).update(new_tags)
            return spool
    return None


def getSpoolById(spool_id):
    for spool in TEST_SPOOLS:
        if spool["id"] == int(spool_id):
            return deepcopy(spool)
    return None


def setActiveTray(spool_id, spool_extra, ams_id, tray_id):
    active_tray = json.dumps(trayUid(int(ams_id), int(tray_id)))
    for spool in TEST_SPOOLS:
        if spool["id"] == int(spool_id):
            spool.setdefault("extra", {}).update(spool_extra or {})
            spool["extra"]["active_tray"] = active_tray
            break
    return active_tray


def consumeSpool(spool_id, grams):
    for spool in TEST_SPOOLS:
        if spool["id"] == int(spool_id):
            spool["remaining_weight"] = max(spool["remaining_weight"] - grams, 0)
            break


def get_prints_with_filament(limit=50, offset=0):
    prints = deepcopy(TEST_PRINTS)
    if offset:
        prints = prints[offset:]
    if limit is not None:
        prints = prints[:limit]
    return prints, len(TEST_PRINTS)


def get_filament_for_slot(print_id, ams_slot):
    for print_job in TEST_PRINTS:
        if int(print_job["id"]) != int(print_id):
            continue
        for filament in json.loads(print_job["filament_info"]):
            if int(filament["ams_slot"]) == int(ams_slot):
                return filament
    return None


def update_filament_spool(print_id, ams_slot, spool_id):
    for print_job in TEST_PRINTS:
        if int(print_job["id"]) != int(print_id):
            continue
        filaments = json.loads(print_job["filament_info"])
        for filament in filaments:
            if int(filament["ams_slot"]) == int(ams_slot):
                filament["spool_id"] = int(spool_id)
        print_job["filament_info"] = json.dumps(filaments)
    return True


def setActiveSpool(*_args, **_kwargs):
    # No-op in test mode
    return None


def wait_for_seed_ready(timeout=10):
    start = time.time()
    while time.time() - start < timeout:
        time.sleep(0.1)
    return True


_PATCH_TARGETS = {
    "spoolman_client.fetchSpoolList": fetchSpools,
    "spoolman_client.getSpoolById": getSpoolById,
    "spoolman_client.consumeSpool": consumeSpool,
    "spoolman_client.patchExtraTags": patchExtraTags,
    "print_history.get_prints_with_filament": get_prints_with_filament,
    "print_history.get_filament_for_slot": get_filament_for_slot,
    "print_history.update_filament_spool": update_filament_spool,
    "spoolman_service.fetchSpools": fetchSpools,
    "spoolman_service.setActiveTray": setActiveTray,
    "spoolman_service.consumeSpool": consumeSpool,
    "mqtt_bambulab.fetchSpools": fetchSpools,
    "mqtt_bambulab.getLastAMSConfig": getLastAMSConfig,
    "mqtt_bambulab.isMqttClientConnected": isMqttClientConnected,
    "mqtt_bambulab.getPrinterModel": getPrinterModel,
    "mqtt_bambulab.setActiveTray": setActiveTray,
}


def test_data_active():
    """Return True when the test-data patches or flag are enabled."""

    return TEST_MODE_FLAG or _PATCH_ACTIVE


@contextmanager
def patched_test_data():
    """
    Patch production modules with the in-memory test dataset for unit tests.

    Usage:
        with patched_test_data():
            # imports inside the block will use the seeded functions
            ...
    """

    global _PATCH_ACTIVE
    previous_state = _PATCH_ACTIVE
    _PATCH_ACTIVE = True

    with ExitStack() as stack:
        for target, replacement in _PATCH_TARGETS.items():
            stack.enter_context(patch(target, replacement))
        try:
            yield
        finally:
            _PATCH_ACTIVE = previous_state


def apply_test_overrides(monkeypatch=None):
    """
    Apply the test-data mocks either via pytest's monkeypatch or as a context manager.

    If ``monkeypatch`` is provided, overrides are applied immediately for the
    duration of the test. Without it, a context manager is returned so tests can
    control the lifetime explicitly:

        with apply_test_overrides():
            ...
    """

    if monkeypatch is not None:
        global _PATCH_ACTIVE
        _PATCH_ACTIVE = True
        for target, replacement in _PATCH_TARGETS.items():
            module_name, attr = target.rsplit(".", 1)
            module = importlib.import_module(module_name)
            monkeypatch.setattr(module, attr, replacement)
        return None

    return patched_test_data()


def activate_test_data_patches():
    """Apply the test-data patches for the lifetime of the process."""

    ctx = patched_test_data()
    ctx.__enter__()
    return ctx
