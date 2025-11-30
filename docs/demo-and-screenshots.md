# Seeded demo & screenshot generation

Use the built-in seeded dataset to preview OpenSpoolMan or to generate consistent screenshots.

## Quick demo with seeded data
1. Ensure dependencies for UI tests are installed: `pip install -r requirements-screenshots.txt`.
2. Start the app in seeded mode:
   ```bash
   OPENSPOOLMAN_TEST_DATA=1 python app.py
   ```
3. Open the UI and explore without connecting to live printers or SpoolMan.

## Generate screenshots
1. Install Playwright browsers if you have not already:
   ```bash
   playwright install
   ```
2. Run the capture script (seeded mode by default):
   ```bash
   python scripts/generate_screenshots.py --mode seed --port 5001
   ```
3. Outputs are written to the directories defined in `scripts/screenshot_config.json`. Use `--output-dir` to override.
4. To capture against a live server, point `--base-url` to your deployment and pass `--mode live`. Add `--allow-live-actions` if you intentionally want state changes during capture.

## Using snapshots
The script can load a saved dataset with `--snapshot data/live_snapshot.json` and attach a print history database via `--print-history-db` for richer history screenshots.
