# AMS Mapping / Print History Fix

## Root cause
- Print history stored `filament_id` from the 3MF, but the filament usage tracker wrote updates using tool index + 1.
- AMS mapping indices are tool indices, not 3MF filament IDs. The mapping between tool index and filament ID was inconsistent.
- Negative AMS mapping values (e.g., `-1` placeholders) were parsed as real AMS targets, which can produce wrong tray/spool resolution.

## Changes
- `tools_3mf.py`
  - Build `tool_index_to_filament_id` / `filament_id_to_tool_index` mappings based on tool indices (contiguous) or usage order only when gaps exist.
- `spoolman_service.py`
  - Resolve AMS mapping by tool index using `filament_id_to_tool_index`.
  - Treat negative AMS mapping values as `unused`.
- `filament_usage_tracker.py`
  - Resolve the 3MF `filament_id` from the tool index before writing history.
  - Skip history updates when a filament ID cannot be resolved (avoid wrong assignments).
- `mqtt_bambulab.py`
  - Local tray mapping now stores AMS mappings by tool index consistently.
- `tests/test_printhistory_spool_assignment_from_replay.py`
  - Expected spool assignment now derives the tool index mapping from 3MF metadata.

## Tests
- `python -m pytest -s tests/test_printhistory_spool_assignment_from_replay.py`
- `python -m pytest -s tests/test_printhistory_accounting.py tests/test_ams_mapping_from_replay.py`
