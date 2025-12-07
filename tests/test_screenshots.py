import asyncio
import os
from pathlib import Path

import pytest

from scripts import generate_screenshots as gs


@pytest.mark.screenshots
def test_seeded_screenshots(request, unused_tcp_port_factory):
    """Optionally generate the documentation screenshots via pytest.

    Run with ``pytest -m screenshots --generate-screenshots`` to avoid writing
    files during normal unit test runs. Screenshots default to ``docs/img`` but
    can be redirected via ``--screenshot-output`` when running pytest.
    """

    if not request.config.getoption("--generate-screenshots"):
        pytest.skip("Enable --generate-screenshots to write UI captures")

    pytest.importorskip("playwright.async_api", reason="Playwright is not installed")

    mode = request.config.getoption("--screenshot-mode")
    base_url = request.config.getoption("--screenshot-base-url")
    output_dir = request.config.getoption("--screenshot-output")
    snapshot = request.config.getoption("--screenshot-snapshot")
    max_height = request.config.getoption("--screenshot-max-height")
    print_history_db = request.config.getoption("--screenshot-print-history-db")
    color_scheme = request.config.getoption("--screenshot-color-scheme")

    config_path = request.config.getoption("--screenshot-config")
    devices = request.config.getoption("--screenshot-devices")

    config = gs.load_config(config_path)
    jobs = gs.build_jobs(
        config,
        devices=[device.strip() for device in devices.split(",") if device.strip()] if devices else None,
        output_dir=output_dir,
        default_max_height=max_height,
    )

    port = unused_tcp_port_factory()
    server_process = None

    try:
        if not base_url:
            server_process = gs.start_server(
                port,
                use_test_data=mode == "seed",
                snapshot_path=snapshot,
                live_read_only=mode != "seed",
                print_history_db=print_history_db,
            )
            gs.wait_for_server(f"http://127.0.0.1:{port}/health")
            base_url = f"http://127.0.0.1:{port}"
        elif mode == "live" and not os.environ.get("OPENSPOOLMAN_LIVE_READONLY"):
            pytest.skip("Set OPENSPOOLMAN_LIVE_READONLY=1 for safe live captures")

        asyncio.run(gs.capture_pages(base_url, jobs, color_scheme=color_scheme))
    finally:
        if server_process is not None:
            gs.stop_server(server_process)

    for job in jobs:
        assert Path(job.output).exists(), f"Screenshot missing: {job.output}"
