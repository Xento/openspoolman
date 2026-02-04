import pytest
from jinja2 import Environment, FileSystemLoader


def _render_tray(*, tray_data, ams_models_by_id):
    env = Environment(loader=FileSystemLoader("templates"))
    env.globals.update(
        AUTO_SPEND=False,
        AMS_MODELS_BY_ID=ams_models_by_id,
        SPOOLMAN_BASE_URL="http://spoolman",
        color_is_dark=lambda _: False,
        url_for=lambda endpoint, **_kwargs: f"/{endpoint}",
    )
    template = env.get_template("fragments/tray.html")
    return template.render(tray_data=tray_data, ams_id=0, pick_tray=False, tray_id=0)


def _unmapped_tray_data():
    return {
        "id": 0,
        "tray_type": "PLA",
        "tray_color": "FFFFFF",
        "bambu_material": "PLA",
        "bambu_color": "FFFFFF",
        "bambu_sub_brand": "Matte",
        "remain": 42,
        "unmapped_bambu_tag": "C0FFEE",
        "last_used": "-",
    }


@pytest.mark.parametrize(
    "ams_models_by_id, expect_visible",
    [
        ({0: "AMS Lite"}, False),
        ({0: "AMS"}, True),
    ],
    ids=["ams_lite", "ams"],
)
def test_unmapped_remaining_visibility_when_ams_model_changes(
    ams_models_by_id, expect_visible
):
    html = _render_tray(tray_data=_unmapped_tray_data(), ams_models_by_id=ams_models_by_id)
    if expect_visible:
        assert "Remaining" in html
        assert "42%" in html
    else:
        assert "Remaining" not in html
