from collections import defaultdict
from pathlib import Path

import pytest

import filament_usage_tracker
import tools_3mf


TEST_ROOT = Path(__file__).resolve().parent / "MQTT"


def _data_path(name: str) -> Path:
    return TEST_ROOT / name


def test_metadata_from_3mf_includes_image_and_filaments(tmp_path, monkeypatch):
    model_path = _data_path("Testqube_Multicolor.gcode.3mf")
    if not model_path.exists():
        pytest.skip(f"Missing test model: {model_path}")

    (tmp_path / "static" / "prints").mkdir(parents=True)
    monkeypatch.chdir(tmp_path)

    metadata = tools_3mf.getMetaDataFrom3mf(f"local:{model_path}")

    assert metadata
    assert metadata.get("file") == model_path.name
    assert metadata.get("plateID") == "1"
    assert metadata.get("gcode_path") == "Metadata/plate_1.gcode"

    image_name = metadata.get("image")
    assert image_name
    assert image_name.endswith(".png")
    image_path = tmp_path / "static" / "prints" / image_name
    assert image_path.exists()
    assert image_path.stat().st_size > 0
    image_path.unlink()

    filaments = metadata.get("filaments")
    assert isinstance(filaments, dict)
    assert filaments
    assert filaments[1]["tray_info_idx"] == "GFL99"
    assert filaments[1]["type"] == "PLA"
    assert filaments[1]["color"] == "#FFFFFF"
    assert filaments[1]["used_g"] == "0.22"
    assert filaments[2]["color"] == "#FFFF00"
    assert filaments[2]["used_g"] == "0.15"
    assert filaments[3]["color"] == "#FF0000"
    assert filaments[3]["used_g"] == "0.27"
    assert filaments[4]["color"] == "#0000FF"
    assert filaments[4]["used_g"] == "0.07"

    usage = metadata.get("usage")
    assert isinstance(usage, dict)
    assert usage == {
        1: "0.22",
        2: "0.15",
        3: "0.27",
        4: "0.07",
    }

    assert metadata.get("filamentOrder") == {0: 0, 1: 1, 3: 4, 2: 5}


def test_extract_and_parse_gcode_from_3mf():
    model_path = _data_path("Testqube_Multicolor.gcode.3mf")
    if not model_path.exists():
        pytest.skip(f"Missing test model: {model_path}")

    gcode = filament_usage_tracker.extract_gcode_from_3mf(str(model_path), None)
    assert gcode

    operations = filament_usage_tracker._parse_gcode(gcode)
    op_names = {op.operation for op in operations}
    assert "M620" in op_names
    assert "M73" in op_names

    layer_map = filament_usage_tracker.evaluate_gcode(gcode)
    assert sorted(layer_map.keys()) == list(range(51))

    totals = defaultdict(float)
    for filaments in layer_map.values():
        for filament, amount in filaments.items():
            totals[filament] += amount

    assert totals == pytest.approx(
        {
            0: 188.36933,
            1: 54.18832,
            2: 93.27441,
            3: 27.09416,
        },
        rel=1e-6,
    )
