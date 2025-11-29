import argparse
import asyncio
import os
import subprocess
import sys
import time
from pathlib import Path

import requests


SCREENSHOT_TARGETS = {
    "docs/img/info.PNG": "/",
    "docs/img/fill_tray.PNG": "/fill?ams=0&tray=0",
    "docs/img/print_history.PNG": "/print_history",
    "docs/img/spool_info.jpeg": "/spool_info?spool_id=1",
    "docs/img/assign_nfc.jpeg": "/write_tag?spool_id=1",
}


def build_output_targets(output_dir: str | os.PathLike | None = None) -> dict[str, str]:
    """Return the screenshot targets, optionally rewriting the output directory.

    When ``output_dir`` is provided, filenames are kept the same but written into
    the specified directory. By default, the original ``docs/img`` targets are
    used so CLI and pytest callers can share the same mapping.
    """

    if output_dir is None:
        return dict(SCREENSHOT_TARGETS)

    base = Path(output_dir)
    return {str(base / Path(path).name): route for path, route in SCREENSHOT_TARGETS.items()}


def parse_viewport(raw_viewport: str | tuple[int, int] | list[int]) -> tuple[int, int]:
    """Parse a viewport specification from CLI or pytest options."""

    if isinstance(raw_viewport, (tuple, list)) and len(raw_viewport) == 2:
        return int(raw_viewport[0]), int(raw_viewport[1])

    if isinstance(raw_viewport, str) and "x" in raw_viewport:
        width, height = raw_viewport.lower().split("x", 1)
        return int(width), int(height)

    raise ValueError("Viewport must be WIDTHxHEIGHT or two integers")


async def capture_pages(
    base_url: str,
    output_paths: dict[str, str],
    viewport: tuple[int, int],
    max_height: int | None = None,
) -> None:
    from playwright.async_api import async_playwright

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        viewport_width, viewport_height = viewport
        page_height = max(viewport_height, max_height) if max_height else viewport_height
        page = await browser.new_page(viewport={"width": viewport_width, "height": page_height})

        for output, route in output_paths.items():
            url = f"{base_url}{route}"
            print(f"Capturing {url} -> {output}")
            await page.goto(url, wait_until="networkidle")
            await page.wait_for_timeout(1000)
            Path(output).parent.mkdir(parents=True, exist_ok=True)

            screenshot_kwargs: dict = {"path": output}
            if max_height:
                screenshot_kwargs.update(
                    {
                        "full_page": False,
                        "clip": {"x": 0, "y": 0, "width": viewport_width, "height": max_height},
                    }
                )
            else:
                screenshot_kwargs["full_page"] = True

            await page.screenshot(**screenshot_kwargs)

        await browser.close()


def wait_for_server(url: str, timeout: int = 30) -> None:
    start = time.time()
    while time.time() - start < timeout:
        try:
            response = requests.get(url, timeout=5)
            if response.status_code < 500:
                return
        except requests.RequestException:
            pass
        time.sleep(0.5)
    raise RuntimeError(f"Server at {url} did not become ready in time")


def start_server(
    port: int,
    use_test_data: bool = True,
    snapshot_path: str | None = None,
    live_read_only: bool = True,
) -> subprocess.Popen:
    env = os.environ.copy()
    env.setdefault("FLASK_APP", "app")
    env["FLASK_RUN_PORT"] = str(port)
    if use_test_data:
        env["OPENSPOOLMAN_TEST_DATA"] = "1"
    if snapshot_path:
        env["OPENSPOOLMAN_TEST_SNAPSHOT"] = snapshot_path
    if live_read_only:
        env["OPENSPOOLMAN_LIVE_READONLY"] = "1"
    env.setdefault("OPENSPOOLMAN_BASE_URL", f"http://127.0.0.1:{port}")

    process = subprocess.Popen(
        [sys.executable, "-m", "flask", "run", "--port", str(port), "--host", "0.0.0.0"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
    )
    return process


def stop_server(process: subprocess.Popen) -> None:
    if process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            process.kill()


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate UI screenshots using a seeded dataset or live server")
    parser.add_argument("--port", type=int, default=5001, help="Port to run the Flask app on")
    parser.add_argument("--viewport", default="1280x720", help="Viewport WIDTHxHEIGHT for screenshots")
    parser.add_argument(
        "--max-height",
        type=int,
        default=None,
        help="Optional maximum screenshot height; crops long pages to the top section",
    )
    parser.add_argument("--output-dir", dest="output_dir", help="Directory to write screenshots (defaults to docs/img)")
    parser.add_argument("--base-url", dest="base_url", help="Use an already-running server instead of starting one")
    parser.add_argument("--mode", choices=["seed", "live"], default="seed", help="Start Flask in seeded test mode or against live data")
    parser.add_argument("--snapshot", dest="snapshot", help="Path to a snapshot JSON to load when using test data")
    parser.add_argument(
        "--test-data",
        action="store_true",
        help="Explicitly set OPENSPOOLMAN_TEST_DATA=1 when starting the Flask server",
    )
    parser.add_argument(
        "--live-readonly",
        action="store_true",
        help="Explicitly set OPENSPOOLMAN_LIVE_READONLY=1 when starting the Flask server",
    )
    parser.add_argument("--allow-live-actions", action="store_true", help="Permit live mode to make state changes instead of running read-only")
    args = parser.parse_args()

    server_process = None
    base_url = args.base_url or f"http://127.0.0.1:{args.port}"
    viewport = parse_viewport(args.viewport)
    targets = build_output_targets(args.output_dir)

    try:
        if not args.base_url:
            use_test_data = args.test_data or args.mode == "seed"
            live_read_only = args.live_readonly or (not args.allow_live_actions)
            server_process = start_server(
                args.port,
                use_test_data=use_test_data,
                snapshot_path=args.snapshot,
                live_read_only=live_read_only,
            )
            wait_for_server(f"{base_url}/health")
        elif args.mode == "live" and not args.allow_live_actions:
            print("Live mode reminder: set OPENSPOOLMAN_LIVE_READONLY=1 on the target server to avoid state changes.")

        asyncio.run(capture_pages(base_url, targets, viewport, max_height=args.max_height))
        return 0
    finally:
        if server_process is not None:
            stop_server(server_process)


if __name__ == "__main__":
    raise SystemExit(main())
