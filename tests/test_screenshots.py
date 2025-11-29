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
    viewport = gs.parse_viewport(request.config.getoption("--screenshot-viewport"))
    max_height = request.config.getoption("--screenshot-max-height")
    targets = gs.build_output_targets(output_dir)

    port = unused_tcp_port_factory()
    server_process = None

    try:
        if not base_url:
            server_process = gs.start_server(
                port,
                use_test_data=mode == "seed",
                snapshot_path=snapshot,
                live_read_only=mode != "seed",
            )
            gs.wait_for_server(f"http://127.0.0.1:{port}/health")
            base_url = f"http://127.0.0.1:{port}"
        elif mode == "live" and not os.environ.get("OPENSPOOLMAN_LIVE_READONLY"):
            pytest.skip("Set OPENSPOOLMAN_LIVE_READONLY=1 for safe live captures")

        asyncio.run(gs.capture_pages(base_url, targets, viewport, max_height=max_height))
    finally:
        if server_process is not None:
            gs.stop_server(server_process)

    for output in targets:
        assert Path(output).exists(), f"Screenshot missing: {output}"
