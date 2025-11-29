import argparse
import json
import os
import time
from pathlib import Path

from mqtt_bambulab import getLastAMSConfig, getPrinterModel, init_mqtt, isMqttClientConnected
from print_history import get_prints_with_filament
from spoolman_service import getSettings
from spoolman_client import fetchSpoolList


DEFAULT_OUTPUT = Path("data/live_snapshot.json")


def wait_for_mqtt_ready(timeout: int = 30) -> bool:
    start = time.time()
    while time.time() - start < timeout:
        if isMqttClientConnected():
            return True
        time.sleep(0.5)
    return False


def export_snapshot(path: Path, include_prints: bool = True) -> None:
    init_mqtt()

    if not wait_for_mqtt_ready():
        print("⚠️ MQTT connection not ready; continuing without AMS tray data")

    spools = fetchSpoolList()
    settings = getSettings()
    last_ams_config = getLastAMSConfig() or {}
    printer = getPrinterModel()

    prints: list[dict] = []
    if include_prints:
        prints, _ = get_prints_with_filament(limit=None, offset=None)

    snapshot = {
        "spools": spools,
        "last_ams_config": last_ams_config,
        "settings": settings,
        "prints": prints,
        "printer": printer,
    }

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(snapshot, f, ensure_ascii=False, indent=2)

    print(f"✅ Wrote live snapshot to {path}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Export live spool/AMS data for reuse as test snapshots")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT, help="Where to write the snapshot JSON")
    parser.add_argument("--skip-prints", action="store_true", help="Exclude print history from the snapshot")
    args = parser.parse_args()

    if os.getenv("OPENSPOOLMAN_TEST_DATA") == "1":
        print("⚠️ OPENSPOOLMAN_TEST_DATA is set; run against a live instance to snapshot real data")
        return 1

    export_snapshot(args.output, include_prints=not args.skip_prints)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
