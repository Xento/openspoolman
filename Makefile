.PHONY: screenshots playwright-install snapshot screenshots-live

playwright-install:
	python -m playwright install chromium

screenshots:
	OPENSPOOLMAN_TEST_DATA=1 python scripts/generate_screenshots.py

screenshots-live:
	python scripts/generate_screenshots.py --mode live

snapshot:
	python scripts/export_live_snapshot.py
