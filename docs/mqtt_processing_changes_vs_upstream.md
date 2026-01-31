# MQTT/Print Processing Changes vs `drndos/openspoolman` (upstream/main)

> Scope: Code-only logic changes that affect MQTT message handling, print detection/metadata, AMS mapping, and billing/spool linking. Tests are explicitly excluded.

## Executive summary
This fork significantly refactors the MQTT → print‑metadata pipeline. The processing is now **unified across cloud/LAN/local prints**, adds **explicit print‑type classification**, normalizes AMS mappings via `ams_mapping2`, and **defers/updates mapping** until trays are known. It also adds **spool linking to print history** and **length-aware billing**, and improves 3MF handling (FTP, filenames, plate selection). The filament tracker is more deeply integrated with print history and AMS mapping, and now normalizes filament indices to 0‑based when gcode doesn’t include `S0`.

---

## mqtt_bambulab.py (MQTT handling / print detection)

### 1) Project file handling is unified and type‑aware
**Upstream**: `project_file` handling was focused on a cloud‑print assumption and directly inserted a print as `cloud`, using `ams_mapping` or external spool; local print flow was separate and triggered later in `push_status`.

**This version**:
- Introduces `_classify_project_source(url, incoming_type, has_ams_mapping)`:
  - `http/https` ⇒ **cloud**
  - `print_type=local` + `ams_mapping` ⇒ **lan_only**
  - `print_type=local` without mapping ⇒ **local**
  - fallback to incoming type or `local`
- `project_file` is now the **single entry point** for metadata regardless of origin.
- Adds `_load_project_metadata(url, gcode_path)` which enforces presence of filament metadata and tracks `metadata_loaded`.
- Normalizes AMS mapping (`ams_mapping2` preferred) and falls back to external spool **only if `use_ams` is false**.

Impact: metadata is now consistent across all print origins and the code no longer assumes a “cloud‑only” shape for `project_file`.

### 2) Print start timing is more nuanced for LAN/local
**Upstream**: local print tracking started only when `gcode_state` transitioned PREPARE→RUNNING and `gcode_file` was available; no early download path, no print resume.

**This version**:
- Adds `_supports_early_ftp_download()` and allows **early tracking** during PREPARE if `gcode_file_prepare_percent >= 99` for supported models (A1/A1 Mini/P1P/P1S).
- Tracks **local‑like prints** not just by `print_type=local`, but also by `(project_id in {0/"0"/None} and not cloud)`.
- Handles **RUNNING without PREPARE** (local prints started directly at the printer).

Impact: local/LAN prints are recognized more reliably and earlier, reducing missed tracking.

### 3) Mapping and completion logic now defers until trays are known
**Upstream**: mapping via `map_filament()` simply appended tray IDs; completion was triggered once mapping existed; no structured normalization.

**This version**:
- Uses `normalize_ams_mapping_entry()` + `normalize_ams_mapping2()` for consistent mapping entries (`{ams_id, slot_id}`), including AMS HT and external spool.
- `map_filament()` now **skips** mapping if AMS mapping is already complete.
- Maintains `filamentChanges`, `assigned_trays`, and uses `filamentOrder` to decide when mapping is complete.
- Sets `complete_handled` to prevent double processing and only clears `PENDING_PRINT_METADATA` when safe.

Impact: mapping accuracy is improved for local prints and avoids premature “complete” state when only partial mapping is known.

### 4) Print insertion and spool linking are now coordinated
**Upstream**: print insert and filament usage rows were created directly in the `project_file` path (cloud) and in local flow separately; no immediate spool linking.

**This version**:
- Centralizes filament usage insertion (`_insert_filament_usage_entries`) with **estimated grams/length** plus zeroing if layer tracking is enabled.
- Adds `_link_spools_to_print(print_id, ams_mapping)` which resolves trays to SpoolMan spool IDs via `get_spool_id_for_tray_uid`.
- Uses `ACTIVE_PRINT_ID` to reduce duplicate insertions across partial flows.

Impact: print history now reflects spool assignments and expected usage earlier in the lifecycle.

### 5) Additional operational/logging changes
- MQTT payloads are **masked more aggressively** (serial redaction).
- Adds structured logging when metadata completion happens via tray mapping.

---

## filament_usage_tracker.py (layer tracking & print history integration)

### 1) AMS mapping normalization is now used end‑to‑end
**Upstream**: mapping was handled with raw tray indexes; external spool was treated differently.

**This version**:
- Uses `normalize_ams_mapping2` and `normalize_ams_mapping_entry` from `spoolman_service`.
- `apply_ams_mapping()` accepts mapping entries, not just ints.
- `_resolve_tray_mapping()` returns normalized entries; `_tray_uid_from_mapping()` converts entries to `trayUid`.

Impact: layer tracking and spool lookup are consistent with MQTT mapping semantics (including AMS HT / external).

### 2) 0‑based normalization of filament indices
**Upstream**: M620 `S` values were taken as‑is, which is often 1‑based in Bambu gcode.

**This version**:
- `evaluate_gcode()` tracks seen filament IDs and **normalizes to 0‑based** if no `S0` is observed.
- Prevents off‑by‑one spool/filament mapping errors during tracking.

### 3) Print history gets updated per‑layer usage
**Upstream**: usage was tracked for spool consumption but didn’t always update print history in sync.

**This version**:
- `_apply_usage_for_filament()` now updates `print_history.update_filament_spool()` and `update_filament_grams_used()` when spool IDs are known.
- Tracks cumulative length (mm) and grams, logging updates.

Impact: print history now matches per‑layer tracking, not just SpoolMan consumption.

### 4) Tracking lifecycle improvements
- `set_print_metadata()` aborts prior run if a new print ID arrives while tracking.
- `_attempt_print_resume()` uses checkpoint metadata to resume tracking after restarts.
- `_start_layer_tracking_for_model()` sets `total_layers`, `predicted_total`, `start_time`, and writes checkpoints.

Impact: more robust tracking across disconnects/restarts.

---

## tools_3mf.py (3MF metadata used by MQTT flows)

### 1) FTP handling rewritten
**Upstream**: used `pycurl` with a fixed path list, less robust in FTPS scenarios.

**This version**:
- Adds an **implicit FTPS** implementation (`ImplicitFTP_TLS`) and explicit retry logic.
- Probes multiple filename variants (`.3mf`, `.gcode.3mf`) and directories (`/cache`, `/`, `/sdcard`).

Impact: improves 3MF retrieval reliability, especially for LAN prints.

### 2) Filename parsing and URL handling
- Adds `filename_from_url()` to extract both path and basename from URLs (http/ftp/file).
- Enables correct file naming in metadata regardless of URL scheme.

### 3) Correct plate selection
**Upstream**: always used the last plate in `slice_info.config`.

**This version**:
- Accepts `gcode_path` from MQTT (`print.param`) and selects the matching plate.
- Falls back to last plate if the requested one is missing, but logs the mismatch.

Impact: fixes wrong‑plate metadata for multi‑plate 3MFs (directly affects print history usage/filaments).

### 4) Filament order normalization
- Normalizes filament order to 0‑based if gcode doesn’t include filament 0 (`S0`).

Impact: aligns with AMS mapping and per‑layer usage logic.

---

## spoolman_service.py (spool matching & billing)

### 1) Normalized AMS mapping utilities
Adds:
- `parse_tray_uid()`
- `normalize_ams_mapping_entry()`
- `normalize_ams_mapping2()`
- `tray_uid_from_mapping_entry()`
- `get_spool_id_for_tray_uid()` (with AMS/slot fallback)

Impact: consistent mapping across MQTT flows, local mapping, and billing.

### 2) `spendFilaments()` now uses mapping2 + length
**Upstream**: used basic AMS mapping and grams only.

**This version**:
- Uses normalized `ams_mapping2` first, falls back to external spool.
- Calculates and forwards **length (mm)** from `used_m` when available.
- Updates print history (`update_filament_spool` + `update_filament_grams_used`) for each tray.

Impact: print history stays aligned with SpoolMan consumption and length‑based tracking.

### 3) Spool lookup now tolerates printer‑ID mismatches
- `get_spool_id_for_tray_uid()` now falls back to **AMS/slot** matching if tray UIDs don’t match the current printer serial.

Impact: reduces “No spool assigned” due to serial mismatches in SpoolMan tags.

---

## print_history.py (supporting changes)

- Adds **logging** around print insertion and filament usage updates.
- `update_filament_spool()` now logs when no row exists vs when it links a spool.
- `update_filament_grams_used()` logs grams/length when updates happen.

Impact: greatly improves observability of MQTT → billing flows.

---

## Net effect on MQTT/print processing

1. **Print origin classification** is more accurate and explicit (cloud vs LAN vs local).
2. **Local prints** are detected sooner and in more cases (PREPARE ≥99%, direct RUNNING).
3. **AMS mapping** is normalized and preserved across flows, reducing off‑by‑one and partial‑mapping issues.
4. **3MF metadata** uses the correct plate, making filament usage and mapping consistent with the print.
5. **Spool linking and billing** are integrated with both upfront usage and layer tracking.

These changes collectively improve correctness for local/LAN prints and reduce mismatches between AMS trays, SpoolMan spools, and print history entries.
