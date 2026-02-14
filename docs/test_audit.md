# Test Audit – OpenSpoolMan

## Inventory
- `tests/test_ams_model_detection.py` -> `mqtt_bambulab.identify_ams_model_from_module`, `identify_ams_models_from_modules`, `identify_ams_models_by_id`
- `tests/test_ams_mapping_parser.py` -> `spoolman_service.parse_ams_mapping`, `parse_ams_mapping_value`
- `tests/test_ams_mapping_from_replay.py` -> `mqtt_bambulab` replay path via `mqtt_replay` fixture + spool assignment persisted in `print_history`
- `tests/test_printhistory_replay_e2e.py` -> `print_history` inserts via `mqtt_bambulab` replay
- `tests/test_printhistory_accounting.py` -> `print_history` + `filament_usage_tracker` consumption via `mqtt_replay`
- `tests/test_printhistory_spool_assignment_from_replay.py` -> `print_history` spool assignment via `mqtt_replay`
- `tests/test_mqtt_replay.py` -> `mqtt_bambulab.processMessage`, `FilamentUsageTracker.on_message` (replay of real payloads)
- `tests/test_print_run_logic.py` -> `mqtt_bambulab.processMessage`, `bambu_state` run tracking helpers
- `tests/test_filament_mismatch.py` -> `spoolman_service.augmentTrayDataWithSpoolMan` mismatch detection
- `tests/test_tray_remaining.py` -> Jinja template `templates/fragments/tray.html`
- `tests/test_screenshots.py` -> `scripts/generate_screenshots.py` (Playwright, optional)
- `tests/test_policy_no_test_logic.py` -> guard test to prevent log parsing in tests
- `test.py` (script) -> `mqtt_bambulab.processMessage` (manual replay helper, not pytest)

## Changes Applied
- Replaced test-owned MQTT log parsing with production helpers.
  - `tests/conftest.py`: now uses `mqtt_bambulab.replay_mqtt_log`.
  - `tests/test_mqtt_replay.py`: now uses `mqtt_bambulab.iter_mqtt_payloads_from_log`.
  - `test.py`: now uses `mqtt_bambulab.iter_mqtt_payloads_from_log`.
- Removed manual AMS mapping derivation in `tests/test_printhistory_spool_assignment_from_replay.py`.
  - The test now asserts against expected spool IDs from fixture JSON, using production replay output only.
- Added a guard test to catch direct MQTT log parsing in tests.

## Anti-Patterns Removed
- Direct parsing of MQTT log lines in tests (`split("::")`, manual JSON extraction).
- Manual reconstruction of AMS-to-spool mappings inside tests.

## New Production Entry Points
Added to `mqtt_bambulab.py`:
- `iter_mqtt_payloads_from_lines(lines)`
- `iter_mqtt_payloads_from_log(log_path)`
- `replay_mqtt_payloads(payloads)`
- `replay_mqtt_log(log_path)`

These are thin wrappers around the existing ingestion path and do not re-implement business rules.

## Rationale
- Tests now feed raw fixture data into production code and assert on production outputs or side effects.
- Mapping and parsing logic lives in production modules, eliminating test-owned business logic.
- The guard test prevents regressions toward log parsing in tests.
