# Pytest Best-Practices Audit – OpenSpoolMan

## Inventory (Tests and Entry Points)
- `tests/test_ams_model_detection.py` -> `mqtt_bambulab.identify_ams_model_from_module`, `identify_ams_models_from_modules`, `identify_ams_models_by_id`
- `tests/test_ams_mapping_parser.py` -> `spoolman_service.parse_ams_mapping`, `parse_ams_mapping_value`
- `tests/test_ams_mapping_from_replay.py` -> `mqtt_bambulab` replay path via `mqtt_replay`, `print_history` spool assignment
- `tests/test_printhistory_replay_e2e.py` -> `print_history` inserts via `mqtt_bambulab` replay
- `tests/test_printhistory_accounting.py` -> `print_history`, `filament_usage_tracker` consumption via `mqtt_replay`
- `tests/test_printhistory_spool_assignment_from_replay.py` -> `print_history` spool assignment via `mqtt_replay`
- `tests/test_mqtt_replay.py` -> `mqtt_bambulab.processMessage`, `FilamentUsageTracker.on_message` (replay of payloads)
- `tests/test_print_run_logic.py` -> `mqtt_bambulab.processMessage`, `bambu_state` run tracking helpers
- `tests/test_filament_mismatch.py` -> `spoolman_service.augmentTrayDataWithSpoolMan`
- `tests/test_tray_remaining.py` -> `templates/fragments/tray.html` (rendering behavior)
- `tests/test_screenshots.py` -> `scripts/generate_screenshots.py` (Playwright, optional)
- `tests/test_policy_no_test_logic.py` -> guard against test-owned log parsing

## Changes Applied
- `pytest.ini`
  - Added `addopts = -ra --strict-markers --strict-config` for stricter pytest defaults.
  - Added `testpaths = tests` and `python_files = test_*.py` to avoid collecting non-test helper modules.
- `requirements.txt`
  - Added `pytest-asyncio` to make the asyncio config explicit and avoid implicit plugin availability.
- `tests/test_ams_model_detection.py`
  - Converted repeated tests into parameterized cases for clarity and maintainability.
- `tests/test_ams_mapping_parser.py`
  - Split monolithic test into focused tests and added parameterized value parsing.
- `tests/test_tray_remaining.py`
  - Parameterized AMS model visibility check to reduce duplication.
- `tests/test_print_run_logic.py`
  - Added `print_run_env` fixture to centralize setup, reset global state, and ensure deterministic feature flags.
  - Renamed tests to clearer `test_<expected>_when_<condition>` style.
- `tests/test_filament_mismatch.py`
  - Renamed tests for clearer intent.
  - Replaced aggregated failure loop with parameterized cases for isolated, deterministic failures.
- `tests/test_mqtt_replay.py`
  - Wraps production `map_filament` and `_resolve_tray_mapping` to observe assignments before state is cleared (observation only, no logic duplication).
- `tests/test_printhistory_replay_e2e.py`
  - Simplified assertions to direct dict comparisons for clarity.
- `tests/test_printhistory_spool_assignment_from_replay.py`
  - Simplified expected-vs-actual comparisons using direct dict equality.

## Best-Practice Goals Covered
- Clear Arrange/Act/Assert flow with focused tests and fixtures.
- Extensive parameterization to reduce duplicate tests and improve failure granularity.
- Deterministic setup via fixture-managed global state and feature flags.
- Assertions compare direct outputs instead of re-implementing business rules.

## Anti-Patterns Removed
- Monolithic tests with multiple independent behaviors bundled together.

## New Fixtures and Parameterization
- `print_run_env` fixture in `tests/test_print_run_logic.py` for state reset and shared mocks.
- Parameterized test cases in `tests/test_ams_model_detection.py`, `tests/test_ams_mapping_parser.py`, `tests/test_tray_remaining.py`, and `tests/test_filament_mismatch.py`.
