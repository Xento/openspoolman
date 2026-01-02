import pytest

import test_data
import socket


@pytest.fixture
def unused_tcp_port_factory():
    """Return a factory that provides unique, currently unused TCP ports."""
    allocated = set()

    def factory():
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind(("", 0))
            port = s.getsockname()[1]
        # avoid immediate reuse in the same test run
        if port in allocated:
            return factory()
        allocated.add(port)
        return port

    return factory


def pytest_addoption(parser):
    group = parser.getgroup("openspoolman")
    group.addoption(
        "--use-seeded-data",
        action="store_true",
        help="Automatically apply the OpenSpoolMan seeded dataset mocks during tests",
    )
    group.addoption(
        "--generate-screenshots",
        action="store_true",
        help="Capture UI screenshots as part of the pytest run (writes to disk)",
    )
    group.addoption(
        "--screenshot-output",
        default="docs/img",
        help="Directory to write screenshots when --generate-screenshots is enabled",
    )
    group.addoption(
        "--screenshot-mode",
        choices=["seed", "live"],
        default="seed",
        help="Use seeded test data or connect to live services for screenshot tests",
    )
    group.addoption(
        "--screenshot-base-url",
        default=None,
        help="Use an already running server for screenshots instead of starting Flask",
    )
    group.addoption(
        "--screenshot-max-height",
        type=int,
        default=None,
        help="Cap screenshot height to the top N pixels for long pages",
    )
    group.addoption(
        "--screenshot-snapshot",
        default="data/live_snapshot.json",
        help="Snapshot JSON to load when generating seeded screenshots (defaults to data/live_snapshot.json)",
    )
    group.addoption(
        "--screenshot-config",
        default=None,
        help="Path to screenshot configuration JSON (defaults to scripts/screenshot_config.json)",
    )
    group.addoption(
        "--screenshot-devices",
        default=None,
        help="Comma-separated list of devices from the screenshot config to render (defaults to config default_devices)",
    )
    group.addoption(
        "--screenshot-print-history-db",
        default=None,
        help="Override the SQLite DB path for print history",
    )
    group.addoption(
        "--screenshot-color-scheme",
        choices=["auto", "light", "dark"],
        default=None,
        help="Force light or dark mode when generating screenshots (defaults to config or auto)",
    )


@pytest.fixture(autouse=True)
def auto_seeded_data(request):
    """Apply seeded data to all tests when ``--use-seeded-data`` is set."""

    if not request.config.getoption("--use-seeded-data"):
        yield
        return

    with test_data.apply_test_overrides():
        yield


@pytest.fixture
def seeded_data_overrides():
    """Patch production modules to use the seeded dataset for a single test."""

    with test_data.apply_test_overrides():
        yield


@pytest.fixture
def seeded_dataset():
    """A deep copy of the seeded dataset for assertions without mutation."""

    return test_data.current_dataset()

