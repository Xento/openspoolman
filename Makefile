.PHONY: screenshots

screenshots:
	OPENSPOOLMAN_TEST_DATA=1 python scripts/generate_screenshots.py
