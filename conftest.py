import pytest

import test_data


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
        "--screenshot-viewport",
        default="1280x720",
        help="Viewport WIDTHxHEIGHT for screenshot tests",
    )
    group.addoption(
        "--screenshot-snapshot",
        default=None,
        help="Snapshot JSON to load when generating seeded screenshots",
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

