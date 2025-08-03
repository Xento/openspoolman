import json
import os
import unittest
from glob import glob
from unittest.mock import patch, call
import tempfile
import base64
import zipfile

import spoolman_service
import test as message_replayer
from tools_3mf import getMetaDataFrom3mf

DATA_DIR = os.path.join(os.path.dirname(__file__), "data")


def load_cases():
    pattern = os.path.join(DATA_DIR, "**", "config.json")
    for cfg_path in glob(pattern, recursive=True):
        case_dir = os.path.dirname(cfg_path)
        with open(cfg_path, "r", encoding="utf-8") as fh:
            cfg = json.load(fh)
        yield case_dir, cfg


_real_namedtempfile = tempfile.NamedTemporaryFile


def _named_tempfile(*args, delete_on_close=True, **kwargs):
    kwargs["delete"] = delete_on_close
    return _real_namedtempfile(*args, **kwargs)


def create_dummy_3mf(path, filament_ids):
    slice_info = [
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "<config><plate><metadata key=\"index\" value=\"1\"/>",
    ]
    for fid in sorted(filament_ids):
        slice_info.append(
            f"<filament id=\"{fid}\" tray_info_idx=\"GFL99\" type=\"PLA\" color=\"#000000\" used_m=\"1.0\" used_g=\"1.0\" />"
        )
    slice_info.append("</plate></config>")
    slice_xml = "\n".join(slice_info)

    png_bytes = base64.b64decode(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMB/6X3nCkAAAAASUVORK5CYII="
    )
    gcode = "".join(f"M620 S{fid}\n" for fid in filament_ids)

    with zipfile.ZipFile(path, "w") as z:
        z.writestr("Metadata/slice_info.config", slice_xml)
        z.writestr("Metadata/plate_1.png", png_bytes)
        z.writestr("Metadata/plate_1.gcode", gcode)


class SpendFilamentsFromMQTTTest(unittest.TestCase):
    def test_spool_assignment_for_all_logs(self):
        for case_dir, cfg in load_cases():
            with self.subTest(case=case_dir):
                log_file = os.path.join(case_dir, cfg["log"])
                three_mf_path = os.path.join(case_dir, cfg["3mf"])
                # Ensure deterministic trayUid generation
                spoolman_service.PRINTER_ID = "PRINTER123"

                spools = []
                for spool in cfg["spools"]:
                    active_tray = json.dumps(
                        spoolman_service.trayUid(spool["ams"], spool["tray"]))
                    spools.append({"id": spool["id"], "extra": {"active_tray": active_tray}})

                expected_assignment = {int(k): v for k, v in cfg["expected_assignment"].items()}

                metadata = None
                mock_update = mock_consume = None
                remove_generated = False
                if not os.path.exists(three_mf_path):
                    create_dummy_3mf(three_mf_path, expected_assignment.keys())
                    remove_generated = True
                try:
                    with patch("tools_3mf.tempfile.NamedTemporaryFile", _named_tempfile):
                        metadata = getMetaDataFrom3mf(f"local:{three_mf_path}")
                        with patch("mqtt_bambulab.getMetaDataFrom3mf", return_value=metadata), \
                             patch("spoolman_service.fetchSpools", return_value=spools), \
                             patch("spoolman_service.update_filament_spool") as mock_update, \
                             patch("spoolman_service.consumeSpool") as mock_consume, \
                             patch("mqtt_bambulab.insert_print", return_value=1), \
                             patch("mqtt_bambulab.insert_filament_usage"):
                            message_replayer.replay_messages(log_file)
                finally:
                    if remove_generated and os.path.exists(three_mf_path):
                        os.remove(three_mf_path)
                    if metadata:
                        img_path = os.path.join(os.getcwd(), "static", "prints", metadata.get("image", ""))
                        if os.path.exists(img_path):
                            os.remove(img_path)
                    db_path = os.path.join(os.getcwd(), "data", "3d_printer_logs.db")
                    if os.path.exists(db_path):
                        os.remove(db_path)

                update_calls = [
                    call(1, filament_id, spool_id)
                    for filament_id, spool_id in expected_assignment.items()
                ]
                mock_update.assert_has_calls(update_calls, any_order=False)

                consume_calls = [
                    call(spool_id, float(metadata["filaments"][filament_id]["used_g"]))
                    for filament_id, spool_id in expected_assignment.items()
                ]
                mock_consume.assert_has_calls(consume_calls, any_order=False)


if __name__ == "__main__":
    unittest.main()
