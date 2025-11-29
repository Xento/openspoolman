.PHONY: screenshots playwright-install

playwright-install:
	python -m playwright install chromium

screenshots:
	OPENSPOOLMAN_TEST_DATA=1 python scripts/generate_screenshots.py
