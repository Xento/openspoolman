import json
import os
import time
from copy import deepcopy
from contextlib import ExitStack, contextmanager
import importlib
from pathlib import Path
from unittest.mock import patch
import pytest

from config import (
    EXTERNAL_SPOOL_AMS_ID,
    EXTERNAL_SPOOL_ID,
)
from spoolman_service import augmentTrayDataWithSpoolMan, trayUid

TEST_MODE_FLAG = os.getenv("OPENSPOOLMAN_TEST_DATA") == "1"
SNAPSHOT_PATH = Path(os.getenv("OPENSPOOLMAN_TEST_SNAPSHOT") or Path("data") / "live_snapshot.json")

_TEST_PRINTER_ID = os.getenv("PRINTER_ID", "TEST-PRINTER")
_PATCH_ACTIVE = False
_DATASET: dict | None = None


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

    try:
        with snapshot_path.open("r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        return None
    except (OSError, json.JSONDecodeError):
        return None

    spools = [_compute_cost_per_gram(spool) for spool in data.get("spools", [])]

    snapshot = {
        "spools": spools,
        "last_ams_config": data.get("last_ams_config") or {},
        "settings": data.get("settings") or {},
        "prints": data.get("prints", []),
        "printer": data.get("printer") or {},
    }

    snapshot.setdefault("last_ams_config", {})
    snapshot.setdefault("settings", {})
    snapshot.setdefault("prints", [])
    snapshot.setdefault("printer", {})

    return snapshot


def _ensure_dataset_loaded() -> dict:
    global _DATASET

    if _DATASET is not None:
        return _DATASET

    snapshot_path = SNAPSHOT_PATH
    if not snapshot_path.exists():
        raise FileNotFoundError(
            f"Snapshot not found at {snapshot_path}. Create one with 'python scripts/export_live_snapshot.py --output {snapshot_path}'."
        )

    snapshot = _load_snapshot(snapshot_path)
    if snapshot is None:
        raise RuntimeError(
            f"Snapshot at {snapshot_path} could not be loaded. Recreate it with 'python scripts/export_live_snapshot.py --output {snapshot_path}'."
        )

    _DATASET = deepcopy(snapshot)
    return _DATASET


if TEST_MODE_FLAG:
    _ensure_dataset_loaded()


def current_dataset() -> dict:
    """Return a deep copy of the active snapshot-backed dataset."""

    return deepcopy(_ensure_dataset_loaded())


def isMqttClientConnected():
    return True


def getPrinterModel():
    printer = deepcopy(_ensure_dataset_loaded().get("printer") or {})
    printer.setdefault("devicename", _TEST_PRINTER_ID)
    printer.setdefault("model", "Snapshot printer")
    return printer


def fetchSpools():
    return deepcopy(_ensure_dataset_loaded().get("spools", []))


def getLastAMSConfig():
    config = deepcopy(_ensure_dataset_loaded().get("last_ams_config") or {})
    spool_list = fetchSpools()

    vt_tray = config.get("vt_tray")
    if vt_tray:
        augmentTrayDataWithSpoolMan(spool_list, vt_tray, trayUid(EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID))

    for ams in config.get("ams", []):
        for tray in ams.get("tray", []):
            augmentTrayDataWithSpoolMan(spool_list, tray, trayUid(ams.get("id"), tray.get("id")))
    return config


def getSettings():
    return deepcopy(_ensure_dataset_loaded().get("settings", {}))


def patchExtraTags(spool_id, _, new_tags):
    dataset = _ensure_dataset_loaded()
    for spool in dataset.get("spools", []):
        if spool["id"] == int(spool_id):
            spool.setdefault("extra", {}).update(new_tags)
            return spool
    return None


def getSpoolById(spool_id):
    for spool in _ensure_dataset_loaded().get("spools", []):
        if spool["id"] == int(spool_id):
            return deepcopy(spool)
    return None


def setActiveTray(spool_id, spool_extra, ams_id, tray_id):
    dataset = _ensure_dataset_loaded()
    active_tray = json.dumps(trayUid(int(ams_id), int(tray_id)))
    for spool in dataset.get("spools", []):
        if spool["id"] == int(spool_id):
            spool.setdefault("extra", {}).update(spool_extra or {})
            spool["extra"]["active_tray"] = active_tray
            break
    return active_tray


def consumeSpool(spool_id, grams):
    dataset = _ensure_dataset_loaded()
    for spool in dataset.get("spools", []):
        if spool["id"] == int(spool_id):
            spool["remaining_weight"] = max(spool.get("remaining_weight", 0) - grams, 0)
            break


def get_prints_with_filament(limit=50, offset=0):
    dataset = _ensure_dataset_loaded()
    prints = deepcopy(dataset.get("prints", []))
    if offset:
        prints = prints[offset:]
    if limit is not None:
        prints = prints[:limit]
    return prints, len(dataset.get("prints", []))


def get_filament_for_slot(print_id, ams_slot):
    dataset = _ensure_dataset_loaded()
    for print_job in dataset.get("prints", []):
        if int(print_job.get("id")) != int(print_id):
            continue
        for filament in json.loads(print_job.get("filament_info", "[]")):
            if int(filament.get("ams_slot")) == int(ams_slot):
                return filament
    return None


def update_filament_spool(print_id, ams_slot, spool_id):
    dataset = _ensure_dataset_loaded()
    for print_job in dataset.get("prints", []):
        if int(print_job.get("id")) != int(print_id):
            continue
        filaments = json.loads(print_job.get("filament_info", "[]"))
        for filament in filaments:
            if int(filament.get("ams_slot")) == int(ams_slot):
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
    "mqtt_bambulab.fetchSpools": fetchSpools,
    "mqtt_bambulab.getLastAMSConfig": getLastAMSConfig,
    "mqtt_bambulab.isMqttClientConnected": isMqttClientConnected,
    "mqtt_bambulab.getPrinterModel": getPrinterModel,
    "mqtt_bambulab.setActiveTray": setActiveTray,
}


def test_data_active():
    """Return True when the test-data patches or flag are enabled."""

    if not (TEST_MODE_FLAG or _PATCH_ACTIVE):
        # During pytest runs, skip to keep the test suite green when seeded data is off.
        if os.getenv("PYTEST_CURRENT_TEST"):
            pytest.skip("Seeded data is not enabled (set OPENSPOOLMAN_TEST_DATA=1 or apply test overrides).")
        # In production imports (e.g., app startup), just report False without raising.
        return False
    return True


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
