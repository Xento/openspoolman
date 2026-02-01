import copy
import json
import shutil
import tempfile
from pathlib import Path

import pytest

import mqtt_bambulab
import print_history
import spoolman_client
import spoolman_service
import tools_3mf
import filament_usage_tracker
from filament_usage_tracker import FilamentUsageTracker
from config import EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID


LOG_ROOT = Path(__file__).resolve().parent / "MQTT"
FIXTURE_ROOT = Path(__file__).resolve().parent / "fixtures" / "mqtt_replays"
LOG_ROOTS = (LOG_ROOT, FIXTURE_ROOT)


def _base_model_from_log(log_path: Path) -> Path:
    base_name = log_path.stem
    for suffix in ("_local", "_cloud"):
        idx = base_name.find(suffix)
        if idx != -1:
            base_name = base_name[:idx]
            break
    return LOG_ROOT / f"{base_name}.gcode.3mf"


def _copy_model_to_temp(model_path: Path) -> Path:
    temp_file = tempfile.NamedTemporaryFile(suffix=".3mf", delete=False)
    temp_file.close()
    temp_model_path = Path(temp_file.name)
    shutil.copy2(model_path, temp_model_path)
    return temp_model_path


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


def _make_spool(spool_id: int, tray_uid: str, color_hex: str = "FFFFFF") -> dict:
    return {
        "id": spool_id,
        "filament": {
            "name": f"Test spool {spool_id}",
            "vendor": {"name": "OpenSpoolMan"},
            "material": "PLA",
            "color_hex": color_hex,
            "diameter": 1.75,
            "density": 1.24,
            "extra": {"type": "PLA Basic"},
        },
        "initial_weight": 1000,
        "price": 30,
        "remaining_weight": 995,
        "extra": {"active_tray": json.dumps(tray_uid)},
    }


def _default_spools() -> list[dict]:
    return [
        _make_spool(100, spoolman_service.trayUid(0, 0), "FFFFFF"),
        _make_spool(101, spoolman_service.trayUid(0, 1), "FFFF00"),
        _make_spool(102, spoolman_service.trayUid(0, 2), "FF0000"),
        _make_spool(103, spoolman_service.trayUid(0, 3), "0000FF"),
        _make_spool(110, spoolman_service.trayUid(EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID), "CCCCCC"),
        _make_spool(1280, spoolman_service.trayUid(128, 0), "AAAAAA"),
    ]


def iter_mqtt_logs():
    for root in LOG_ROOTS:
        if not root.exists():
            continue
        for log_path in sorted(root.rglob("*.log")):
            yield log_path


@pytest.fixture()
def tmp_storage(tmp_path):
    db_path = tmp_path / "print_history.db"
    print_history.db_config["db_path"] = str(db_path)
    print_history.create_database()
    return db_path


@pytest.fixture()
def fake_spoolman(monkeypatch):
    state = {
        "spools": _default_spools(),
        "consume_calls": [],
        "patch_calls": [],
    }

    def _set_spools(spools: list[dict]) -> None:
        state["spools"] = spools
        spoolman_service.SPOOLS = []

    def _fetch_spool_list():
        return copy.deepcopy(state["spools"])

    def _consume_spool(spool_id, use_weight=None, use_length=None):
        state["consume_calls"].append(
            {
                "spool_id": spool_id,
                "use_weight": use_weight,
                "use_length": use_length,
            }
        )

    def _patch_extra_tags(spool_id, old_extras, new_extras):
        state["patch_calls"].append(
            {
                "spool_id": spool_id,
                "payload": new_extras,
            }
        )

    monkeypatch.setattr(spoolman_client, "fetchSpoolList", _fetch_spool_list)
    monkeypatch.setattr(spoolman_client, "consumeSpool", _consume_spool)
    monkeypatch.setattr(filament_usage_tracker, "consumeSpool", _consume_spool)
    monkeypatch.setattr(spoolman_client, "patchExtraTags", _patch_extra_tags)

    spoolman_service.SPOOLS = []
    spoolman_service.SPOOLMAN_SETTINGS = {}
    state["set_spools"] = _set_spools
    return state


@pytest.fixture()
def mqtt_replay(monkeypatch, tmp_storage, fake_spoolman):
    def _replay(
        log_path: Path,
        *,
        model_path: Path | None = None,
        metadata_overrides: dict | None = None,
        track_layer_usage: bool = False,
    ):
        log_path = Path(log_path)
        if not log_path.exists():
            pytest.skip(f"Missing MQTT replay log: {log_path}")

        model_path = Path(model_path) if model_path else _base_model_from_log(log_path)
        if not model_path.exists():
            pytest.skip(f"Missing 3MF model for replay: {model_path}")

        temp_model_path = _copy_model_to_temp(model_path)

        original_get_meta = tools_3mf.getMetaDataFrom3mf

        def _fake_get_meta(_url: str):
            metadata = original_get_meta(f"local:{temp_model_path}")
            if metadata_overrides:
                metadata.update(metadata_overrides)
            return metadata

        monkeypatch.setattr(mqtt_bambulab, "getMetaDataFrom3mf", _fake_get_meta)
        monkeypatch.setattr(
            FilamentUsageTracker,
            "_retrieve_model",
            lambda self, _url: str(temp_model_path),
        )

        monkeypatch.setattr(mqtt_bambulab, "AUTO_SPEND", True)
        monkeypatch.setattr(mqtt_bambulab, "TRACK_LAYER_USAGE", track_layer_usage)
        monkeypatch.setattr(filament_usage_tracker, "TRACK_LAYER_USAGE", track_layer_usage)

        mqtt_bambulab.PRINTER_STATE = {}
        mqtt_bambulab.PRINTER_STATE_LAST = {}
        mqtt_bambulab.PENDING_PRINT_METADATA = {}
        mqtt_bambulab.FILAMENT_TRACKER = FilamentUsageTracker()
        spoolman_service.SPOOLS = []
        filament_usage_tracker.clear_checkpoint()

        prints_dir = Path("static") / "prints"
        prints_dir.mkdir(parents=True, exist_ok=True)
        existing_prints = {p.name for p in prints_dir.iterdir() if p.is_file()}

        try:
            for payload in _iter_payloads(log_path):
                msg = type("FakeMsg", (), {"payload": json.dumps(payload).encode("utf-8")})()
                mqtt_bambulab.on_message(None, None, msg)
        finally:
            temp_model_path.unlink(missing_ok=True)
            current_prints = {p.name for p in prints_dir.iterdir() if p.is_file()}
            for added in current_prints - existing_prints:
                (prints_dir / added).unlink(missing_ok=True)

    return _replay
