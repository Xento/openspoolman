import os
import time
from pathlib import Path

import print_history


def test_versioned_target_path_uses_v2_suffix(tmp_path: Path) -> None:
    base_path = tmp_path / "3d_printer_logs.db"
    target = print_history._versioned_target_path(base_path)
    assert target.name == "3d_printer_logs.v2.db"


def test_find_latest_versioned_ignores_migrated(tmp_path: Path) -> None:
    base_path = tmp_path / "3d_printer_logs.db"
    legacy = tmp_path / "3d_printer_logs.migrated.db"

    legacy.write_text("legacy")
    now = int(time.time())
    os.utime(legacy, (now, now))

    assert print_history._find_latest_versioned(base_path) is None
