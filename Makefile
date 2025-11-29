.PHONY: screenshots playwright-install

playwright-install:
@python - <<'PY'
import importlib.util, sys

if importlib.util.find_spec("playwright") is None:
    sys.stderr.write("Playwright is not installed. Install optional dependencies via 'pip install -r requirements-screenshots.txt' (Python < 3.13).\n")
    sys.exit(1)
PY
python -m playwright install chromium

screenshots:
OPENSPOOLMAN_TEST_DATA=1 python scripts/generate_screenshots.py
