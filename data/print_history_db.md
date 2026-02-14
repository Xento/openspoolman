Demo print history database
===========================

- Default location: `data/3d_printer_logs.db`. If a schema migration is needed, OpenSpoolMan copies the database to a `.migrated` filename, migrates that copy, and will prefer the migrated file afterward so the original remains available for rollback.
- For screenshots or demos, override with `OPENSPOOLMAN_PRINT_HISTORY_DB=/path/to/data/demo.db` or pass `--print-history-db` to `scripts/generate_screenshots.py`/`pytest -m screenshots`.
- Schema matches `print_history.py` (`prints` + `filament_usage`). Populate it from your own data or via a live snapshot export; demo rows are no longer bundled by default.
