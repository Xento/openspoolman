import argparse
import asyncio
import os
import subprocess
import sys
import time
from pathlib import Path

import requests
from playwright.async_api import async_playwright


SCREENSHOT_TARGETS = {
    "docs/img/info.PNG": "/",
    "docs/img/fill_tray.PNG": "/fill?ams=0&tray=0",
    "docs/img/print_history.PNG": "/print_history",
    "docs/img/spool_info.jpeg": "/spool/1",
    "docs/img/assign_nfc.jpeg": "/write_tag?spool_id=1",
}


async def capture_pages(base_url: str, output_paths: dict[str, str], viewport: tuple[int, int]) -> None:
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page(viewport={"width": viewport[0], "height": viewport[1]})

        for output, route in output_paths.items():
            url = f"{base_url}{route}"
            print(f"Capturing {url} -> {output}")
            await page.goto(url, wait_until="networkidle")
            await page.wait_for_timeout(1000)
            Path(output).parent.mkdir(parents=True, exist_ok=True)
            await page.screenshot(path=output, full_page=True)

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


def start_server(port: int) -> subprocess.Popen:
    env = os.environ.copy()
    env.setdefault("FLASK_APP", "app")
    env["FLASK_RUN_PORT"] = str(port)
    env["OPENSPOOLMAN_TEST_DATA"] = "1"
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
    parser = argparse.ArgumentParser(description="Generate UI screenshots using a seeded dataset")
    parser.add_argument("--port", type=int, default=5001, help="Port to run the Flask app on")
    parser.add_argument("--viewport", type=int, nargs=2, default=(1280, 720), metavar=("WIDTH", "HEIGHT"))
    parser.add_argument("--base-url", dest="base_url", help="Override base URL instead of starting a local server")
    args = parser.parse_args()

    server_process = None
    base_url = args.base_url or f"http://127.0.0.1:{args.port}"

    try:
        if not args.base_url:
            server_process = start_server(args.port)
            wait_for_server(f"{base_url}/health")

        asyncio.run(capture_pages(base_url, SCREENSHOT_TARGETS, tuple(args.viewport)))
        return 0
    finally:
        if server_process is not None:
            stop_server(server_process)


if __name__ == "__main__":
    raise SystemExit(main())
