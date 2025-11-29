Demo print history database
===========================

- Default location: `data/demo.db`
- Override path for the Flask app/screenshot generator: set `OPENSPOOLMAN_PRINT_HISTORY_DB=/path/to/demo.db` or pass `--print-history-db` to `scripts/generate_screenshots.py`/`pytest -m screenshots`.
- Schema matches `print_history.py` (`prints` + `filament_usage`). The bundled demo carries a few seeded jobs so the `/print_history` view renders without extra setup.
