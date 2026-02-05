

import json
import os
import ssl
import traceback
from pathlib import Path
from threading import Thread
from typing import Any, Iterable

import paho.mqtt.client as mqtt

from config import (
    PRINTER_ID,
    PRINTER_CODE,
    PRINTER_IP,
    AUTO_SPEND,
    EXTERNAL_SPOOL_ID,
    TRACK_LAYER_USAGE,
    CLEAR_ASSIGNMENT_WHEN_EMPTY,
)
from messages import GET_VERSION, PUSH_ALL, AMS_FILAMENT_SETTING
from spoolman_service import spendFilaments, setActiveTray, fetchSpools, clear_active_spool_for_tray
from tools_3mf import getMetaDataFrom3mf
import time
import copy
from collections.abc import Mapping
from logger import append_to_rotating_file, log
from print_history import insert_print, insert_filament_usage
from filament_usage_tracker import FilamentUsageTracker
from bambu_state import (
  Features,
  MODEL_FEATURES,
  PRINT_RUN_REGISTRY,
  extract_gcode_state,
  extract_prepare_percent,
  extract_print_status,
  get_job_label,
  get_printer_model_name,
  is_prepare_ready_for_early_download,
  is_print_active,
  is_print_final,
  normalize_prepare_percent,
)
MQTT_CLIENT = {}  # Global variable storing MQTT Client
MQTT_CLIENT_CONNECTED = False
MQTT_KEEPALIVE = 60
LAST_AMS_CONFIG = {}  # Global variable storing last AMS configuration

PRINTER_STATE = {}
PRINTER_STATE_LAST = {}

PENDING_PRINT_METADATA = {}
FILAMENT_TRACKER = FilamentUsageTracker()
LAST_LAN_PROJECT = {}
LOG_FILE = os.getenv("OPENSPOOLMAN_MQTT_LOG_PATH", "/home/app/logs/mqtt.log")
_LOG_WRITE_FAILED = False
PENDING_PRINT_REFERENCE = {}
PRINTER_MODEL_NAME = get_printer_model_name(PRINTER_ID)
LAST_PREPARE_LOGGED = object()

def getPrinterModel():
    global PRINTER_ID
    model_code = PRINTER_ID[:3]

    model_map = {
      # H2-Serie
      "093": "H2S",
      "094": "H2D",
      "239": "H2D Pro",
      "109": "H2C",

      # X1-Serie
      "00W": "X1",
      "00M": "X1 Carbon",
      "03W": "X1E",

      # P1-Serie
      "01S": "P1P",
      "01P": "P1S",

      # P2-Serie
      "22E": "P2S",

      # A1-Serie
      "039": "A1",
      "030": "A1 Mini"
    }

    model_name = model_map.get(model_code, f"Unknown model ({model_code})")

    numeric_tail = ''.join(filter(str.isdigit, PRINTER_ID))
    device_id = numeric_tail[-3:] if len(numeric_tail) >= 3 else numeric_tail

    device_name = f"3DP-{model_code}-{device_id}"

    return {
        "model": model_name,
        "devicename": device_name
    }

def identify_ams_model_from_module(module: dict[str, Any]) -> str | None:
    """Guess the AMS variant that a version module represents."""

    product_name = (module.get("product_name") or "").strip().lower()
    module_name = (module.get("name") or "").strip().lower()

    if "ams lite" in product_name or module_name.startswith("ams_f1"):
        return "AMS Lite"
    if "ams 2 pro" in product_name or module_name.startswith("n3f"):
        return "AMS 2 Pro"
    if "ams ht" in product_name or module_name.startswith("ams_ht"):
        return "AMS HT"
    if module_name == "ams" or module_name.startswith("ams/"):
        return "AMS"

    return None


def identify_ams_models_from_modules(modules: Iterable[dict[str, Any]]) -> dict[str, dict[str, Any]]:
  """Return per-module metadata, including the detected model when available."""

  results: dict[str, dict[str, Any]] = {}
  for module in modules or []:
    name = module.get("name")
    if not name:
      continue

    results[name] = {
      "model": identify_ams_model_from_module(module),
      "product_name": module.get("product_name"),
      "serial": module.get("sn"),
      "hw_ver": module.get("hw_ver"),
    }

  return results


def extract_ams_id_from_module_name(name: str) -> int | None:
  parts = name.split("/")
  if len(parts) != 2:
    return None
  try:
    return int(parts[1])
  except ValueError:
    return None


def identify_ams_models_by_id(modules: Iterable[dict[str, Any]]) -> dict[str, str]:
  """Return the detected AMS model per numeric AMS ID (module suffix)."""

  results: dict[str, str] = {}
  for module in modules or []:
    name = module.get("name")
    if not name:
      continue

    ams_id = extract_ams_id_from_module_name(name)
    if ams_id is None:
      continue

    model = identify_ams_model_from_module(module)
    if model:
      results[str(ams_id)] = model
      results[ams_id] = model

  return results


def num2letter(num):
  return chr(ord("A") + int(num))
  
def update_dict(original: dict, updates: dict) -> dict:
    for key, value in updates.items():
        if isinstance(value, Mapping) and key in original and isinstance(original[key], Mapping):
            original[key] = update_dict(original[key], value)
        else:
            original[key] = value
    return original


def _parse_grams(value):
  try:
    return float(value)
  except (TypeError, ValueError):
    return None

def _is_lan_project_url(url: str | None) -> bool:
  if not url:
    return False
  return not url.startswith("http")

def _is_valid_print_id(value: Any) -> bool:
  if value is None:
    return False
  if isinstance(value, str) and not value.strip():
    return False
  try:
    return int(value) != 0
  except (TypeError, ValueError):
    return True

def _matches_print_identity(print_state: dict, identity: dict) -> bool:
  if not print_state or not identity:
    return False
  if _is_valid_print_id(identity.get("task_id")) and _is_valid_print_id(print_state.get("task_id")):
    if str(identity.get("task_id")) == str(print_state.get("task_id")):
      return True
  if _is_valid_print_id(identity.get("subtask_id")) and _is_valid_print_id(print_state.get("subtask_id")):
    if str(identity.get("subtask_id")) == str(print_state.get("subtask_id")):
      return True
  identity_file = identity.get("file") or identity.get("gcode_file") or identity.get("subtask_name")
  state_file = print_state.get("gcode_file") or print_state.get("subtask_name")
  return bool(identity_file and state_file and identity_file == state_file)

def _lan_project_is_active(identity: dict) -> bool:
  if not identity:
    return False
  timestamp = identity.get("timestamp")
  if not timestamp:
    return False
  return (time.time() - timestamp) < (6 * 60 * 60)

def _mask_serial(serial: str | None, keep_chars: int = 3) -> str:
  if not serial:
    return ""
  visible = serial[:keep_chars]
  if len(serial) <= keep_chars:
    return visible
  return f"{visible}..."

def _mask_sn_values(value):
  if isinstance(value, dict):
    for key, item in value.items():
      if key.lower() == "sn" and isinstance(item, str):
        value[key] = _mask_serial(item)
      else:
        _mask_sn_values(item)
  elif isinstance(value, list):
    for elem in value:
      _mask_sn_values(elem)

def _mask_mqtt_payload(payload: str) -> str:
  try:
    data = json.loads(payload)
    _mask_sn_values(data)
    masked = json.dumps(data, separators=(",", ":"))
  except ValueError:
    masked = payload

  masked_serial = _mask_serial(PRINTER_ID)
  if masked_serial:
    masked = masked.replace(PRINTER_ID, masked_serial)

  return masked


def iter_mqtt_payloads_from_lines(lines: Iterable[str]) -> Iterable[dict[str, Any]]:
  """Yield decoded MQTT payloads from log lines (format: '<timestamp> :: <json>')."""
  for line in lines:
    if "::" not in line:
      continue
    payload_raw = line.split("::", 1)[1].strip()
    if not payload_raw:
      continue
    try:
      payload = json.loads(payload_raw)
    except (TypeError, ValueError):
      continue
    if isinstance(payload, dict):
      yield payload


def iter_mqtt_payloads_from_log(log_path: str | Path) -> Iterable[dict[str, Any]]:
  """Yield decoded MQTT payloads from a saved mqtt.log file."""
  path = Path(log_path)
  with path.open("r", encoding="utf-8") as handle:
    yield from iter_mqtt_payloads_from_lines(handle)


def replay_mqtt_payloads(payloads: Iterable[dict[str, Any]]) -> None:
  """Replay decoded MQTT payloads through the on_message handler."""
  for payload in payloads:
    msg = type("ReplayMsg", (), {"payload": json.dumps(payload).encode("utf-8")})()
    on_message(None, None, msg)


def replay_mqtt_log(log_path: str | Path) -> None:
  """Replay an mqtt.log file through the on_message handler."""
  replay_mqtt_payloads(iter_mqtt_payloads_from_log(log_path))

def _maybe_download_metadata(source: str | None, reason: str) -> dict | None:
  if not source:
    log(f"[DEBUG] Metadata download skipped: no source ({reason}).")
    return None
  try:
    metadata = getMetaDataFrom3mf(source)
    if metadata:
      log(f"[DEBUG] Metadata downloaded for {reason} from {source}")
    return metadata
  except Exception as exc:
    log(f"[WARNING] Metadata download failed ({reason}): {exc}")
    return None

def map_filament(tray_tar):
  global PENDING_PRINT_METADATA
  # Prüfen, ob ein Filamentwechsel aktiv ist (stg_cur == 4)
  #if stg_cur == 4 and tray_tar is not None:
  if PENDING_PRINT_METADATA:
    PENDING_PRINT_METADATA["filamentChanges"].append(tray_tar)  # Jeder Wechsel zählt, auch auf das gleiche Tray
    log(f'Filamentchange {len(PENDING_PRINT_METADATA["filamentChanges"])}: Tray {tray_tar}')

    # Anzahl der erkannten Wechsel
    change_count = len(PENDING_PRINT_METADATA["filamentChanges"]) - 1  # -1, weil der erste Eintrag kein Wechsel ist

    filament_order = PENDING_PRINT_METADATA.get("filamentOrder") or {}
    ordered_filaments = sorted(filament_order.items(), key=lambda entry: entry[1])
    assigned_trays = PENDING_PRINT_METADATA.setdefault("assigned_trays", [])
    filament_order_keys = {int(key) for key in filament_order.keys() if str(key).isdigit()}
    filament_assigned = None
    if tray_tar not in assigned_trays:
      assigned_trays.append(tray_tar)
      unique_index = len(assigned_trays) - 1
      if unique_index < len(ordered_filaments):
        filament_assigned = ordered_filaments[unique_index][0]
      else:
        for filamentId, usage_count in filament_order.items():
          if usage_count == change_count:
            filament_assigned = filamentId
            break

    if filament_assigned is not None:
      mapping = PENDING_PRINT_METADATA.setdefault("ams_mapping", [])
      try:
        filament_idx = int(filament_assigned)
      except (TypeError, ValueError):
        filament_idx = None
      mapping_index = filament_idx
      while len(mapping) <= mapping_index:
        mapping.append(None)
      mapping[mapping_index] = tray_tar
      log(f"✅ Tray {tray_tar} assigned to Filament {filament_assigned}")

      for filament, tray in enumerate(mapping):
        if tray is None:
          continue
        log(f"  Filament pos: {filament} → Tray {tray}")

    target_filaments_raw = set(filament_order.keys())
    if target_filaments_raw and all(str(key).isdigit() for key in target_filaments_raw):
      target_filaments = {int(key) for key in target_filaments_raw}
    else:
      target_filaments = target_filaments_raw
    if target_filaments:
      assigned_filaments = {
        idx
        for idx, tray in enumerate(PENDING_PRINT_METADATA.get("ams_mapping", []))
        if tray is not None
      }
      if target_filaments.issubset(assigned_filaments):
        log("\n✅ All trays assigned:")
        return True
  
  return False
  
def processMessage(data):
  global LAST_AMS_CONFIG, PRINTER_STATE, PRINTER_STATE_LAST, PENDING_PRINT_METADATA, LAST_LAN_PROJECT
  global PENDING_PRINT_REFERENCE
  global LAST_PREPARE_LOGGED

   # Prepare AMS spending estimation
  if "print" in data:    
    data = copy.deepcopy(data)
    update_dict(PRINTER_STATE, data)
    print_block = PRINTER_STATE.get("print", {})
    incoming_print = data.get("print", {})
    gcode_state = extract_gcode_state(data)
    print_status = extract_print_status(data)
    job_label = get_job_label(data)
    raw_prepare_percent = extract_prepare_percent(data)
    normalized_prepare_percent = normalize_prepare_percent(raw_prepare_percent)
    if "gcode_file_prepare_percent" in incoming_print:
      current_prepare = (raw_prepare_percent, normalized_prepare_percent)
      if current_prepare != LAST_PREPARE_LOGGED:
        log(f"[DEBUG] prepare_percent raw={raw_prepare_percent!r} normalized={normalized_prepare_percent}")
        LAST_PREPARE_LOGGED = current_prepare

    active_now = is_print_active(gcode_state, print_status)
    final_now = is_print_final(gcode_state, print_status)
    supports_early = Features.SUPPORTS_EARLY_FTP_DOWNLOAD in MODEL_FEATURES.get(PRINTER_MODEL_NAME, set())
    early_ready = active_now or is_prepare_ready_for_early_download(normalized_prepare_percent)

    if incoming_print.get("command") == "project_file" and incoming_print.get("url"):
      log(
        "[print] Incoming print command: "
        f"url={incoming_print.get('url')}, "
        f"gcode_file={incoming_print.get('gcode_file')}, "
        f"print_type={incoming_print.get('print_type')}, "
        f"task_id={incoming_print.get('task_id')}, "
        f"subtask_id={incoming_print.get('subtask_id')}, "
        f"use_ams={incoming_print.get('use_ams')}, "
        f"ams_mapping={incoming_print.get('ams_mapping')}"
      )
      is_lan_project = _is_lan_project_url(incoming_print.get("url"))
      history_print_type = "lan" if is_lan_project else "cloud"
      job_label = get_job_label(data)
      PENDING_PRINT_REFERENCE = {
        "url": incoming_print.get("url"),
        "gcode_file": incoming_print.get("gcode_file"),
        "task_id": incoming_print.get("task_id"),
        "subtask_id": incoming_print.get("subtask_id"),
        "print_type": incoming_print.get("print_type"),
        "use_ams": incoming_print.get("use_ams"),
        "ams_mapping": incoming_print.get("ams_mapping"),
        "subtask_name": incoming_print.get("subtask_name"),
        "history_print_type": history_print_type,
        "job_label": job_label,
      }
      if is_lan_project:
        LAST_LAN_PROJECT = {
          "task_id": incoming_print.get("task_id"),
          "subtask_id": incoming_print.get("subtask_id"),
          "file": incoming_print.get("gcode_file") or incoming_print.get("subtask_name"),
          "timestamp": time.time(),
        }

      if not PENDING_PRINT_METADATA:
        metadata = _maybe_download_metadata(incoming_print.get("url"), "project-file")
        if metadata:
          PENDING_PRINT_METADATA = metadata
          PENDING_PRINT_METADATA["print_type"] = history_print_type
          PENDING_PRINT_METADATA["task_id"] = incoming_print.get("task_id")
          PENDING_PRINT_METADATA["subtask_id"] = incoming_print.get("subtask_id")
          if TRACK_LAYER_USAGE:
            FILAMENT_TRACKER.set_print_metadata(PENDING_PRINT_METADATA)
          print_id = insert_print(
            incoming_print.get("subtask_name") or PENDING_PRINT_METADATA.get("file") or "Print",
            history_print_type,
            PENDING_PRINT_METADATA.get("image"),
          )
          PENDING_PRINT_METADATA["print_id"] = print_id
          if incoming_print.get("use_ams"):
            PENDING_PRINT_METADATA["ams_mapping"] = incoming_print.get("ams_mapping") or []
          else:
            PENDING_PRINT_METADATA["ams_mapping"] = [EXTERNAL_SPOOL_ID]
          PENDING_PRINT_METADATA["complete"] = True
          PENDING_PRINT_REFERENCE["print_id"] = print_id
          PENDING_PRINT_REFERENCE["history_created"] = True
          PENDING_PRINT_REFERENCE["accounted"] = True
          PENDING_PRINT_REFERENCE["metadata"] = PENDING_PRINT_METADATA

          for id, filament in PENDING_PRINT_METADATA.get("filaments", {}).items():
            parsed_grams = _parse_grams(filament.get("used_g"))
            parsed_length_m = _parse_grams(filament.get("used_m"))
            estimated_length_mm = parsed_length_m * 1000 if parsed_length_m is not None else None
            grams_used = parsed_grams if parsed_grams is not None else 0.0
            length_used = estimated_length_mm if estimated_length_mm is not None else 0.0
            if TRACK_LAYER_USAGE:
              grams_used = 0.0
              length_used = 0.0
            insert_filament_usage(
                print_id,
                filament["type"],
                filament["color"],
                grams_used,
                id,
                estimated_grams=parsed_grams,
                length_used=length_used,
                estimated_length=estimated_length_mm,
            )

    if supports_early and early_ready and job_label and not PENDING_PRINT_METADATA:
      if PRINT_RUN_REGISTRY.mark_early_download_started(PRINTER_ID, job_label):
        metadata = _maybe_download_metadata(job_label, "early-download")
        if metadata:
          PENDING_PRINT_METADATA = metadata
          if PENDING_PRINT_REFERENCE:
            PENDING_PRINT_REFERENCE["metadata"] = PENDING_PRINT_METADATA
          if PENDING_PRINT_REFERENCE:
            PENDING_PRINT_METADATA["task_id"] = PENDING_PRINT_REFERENCE.get("task_id")
            PENDING_PRINT_METADATA["subtask_id"] = PENDING_PRINT_REFERENCE.get("subtask_id")
            PENDING_PRINT_METADATA["print_type"] = PENDING_PRINT_REFERENCE.get("print_type")

    if active_now:
      if PRINT_RUN_REGISTRY.can_start_new_run(PRINTER_ID):
        PRINT_RUN_REGISTRY.start_run(PRINTER_ID, job_label, data)

        existing_print_id = None
        if PENDING_PRINT_REFERENCE and PENDING_PRINT_REFERENCE.get("print_id"):
          if _matches_print_identity(print_block, PENDING_PRINT_REFERENCE):
            existing_print_id = PENDING_PRINT_REFERENCE.get("print_id")
          elif not (print_block.get("task_id") or print_block.get("subtask_id")):
            existing_print_id = PENDING_PRINT_REFERENCE.get("print_id")

        source = (
          (PENDING_PRINT_REFERENCE or {}).get("url")
          or (PENDING_PRINT_REFERENCE or {}).get("gcode_file")
          or print_block.get("url")
          or print_block.get("gcode_file")
          or job_label
        )
        history_print_type = (
          (PENDING_PRINT_REFERENCE or {}).get("history_print_type")
          or print_block.get("print_type")
          or ("lan" if _is_lan_project_url(source) else "cloud")
        )
        if not PENDING_PRINT_METADATA:
          if PENDING_PRINT_REFERENCE and PENDING_PRINT_REFERENCE.get("metadata"):
            PENDING_PRINT_METADATA = PENDING_PRINT_REFERENCE.get("metadata") or {}
          else:
            PENDING_PRINT_METADATA = _maybe_download_metadata(source, "print-start") or {}

        if PENDING_PRINT_METADATA:
          PENDING_PRINT_METADATA["print_type"] = history_print_type
          PENDING_PRINT_METADATA["task_id"] = print_block.get("task_id")
          PENDING_PRINT_METADATA["subtask_id"] = print_block.get("subtask_id")

          use_ams = print_block.get("use_ams", (PENDING_PRINT_REFERENCE or {}).get("use_ams"))
          ams_mapping = print_block.get("ams_mapping") or (PENDING_PRINT_REFERENCE or {}).get("ams_mapping")

          if history_print_type == "local":
            PENDING_PRINT_METADATA.setdefault("ams_mapping", [])
            PENDING_PRINT_METADATA["filamentChanges"] = []
            PENDING_PRINT_METADATA["assigned_trays"] = []
            PENDING_PRINT_METADATA["complete"] = False
          else:
            if use_ams:
              PENDING_PRINT_METADATA["ams_mapping"] = ams_mapping or []
            else:
              PENDING_PRINT_METADATA["ams_mapping"] = [EXTERNAL_SPOOL_ID]
            PENDING_PRINT_METADATA["complete"] = True

          if not PENDING_PRINT_METADATA.get("tracking_started"):
            if existing_print_id:
              print_id = existing_print_id
              PENDING_PRINT_METADATA["print_id"] = print_id
              if PENDING_PRINT_REFERENCE and PENDING_PRINT_REFERENCE.get("accounted"):
                PENDING_PRINT_METADATA["skip_spend"] = True
            else:
              print_id = insert_print(
                PENDING_PRINT_METADATA.get("file") or print_block.get("subtask_name") or "Print",
                history_print_type,
                PENDING_PRINT_METADATA.get("image"),
              )
              PENDING_PRINT_METADATA["print_id"] = print_id

              for id, filament in PENDING_PRINT_METADATA.get("filaments", {}).items():
                parsed_grams = _parse_grams(filament.get("used_g"))
                parsed_length_m = _parse_grams(filament.get("used_m"))
                estimated_length_mm = parsed_length_m * 1000 if parsed_length_m is not None else None
                grams_used = parsed_grams if parsed_grams is not None else 0.0
                length_used = estimated_length_mm if estimated_length_mm is not None else 0.0
                if TRACK_LAYER_USAGE:
                  grams_used = 0.0
                  length_used = 0.0
                insert_filament_usage(
                    print_id,
                    filament["type"],
                    filament["color"],
                    grams_used,
                    id,
                    estimated_grams=parsed_grams,
                    length_used=length_used,
                    estimated_length=estimated_length_mm,
                )

            if history_print_type == "local":
              FILAMENT_TRACKER.start_local_print_from_metadata(PENDING_PRINT_METADATA)
            elif TRACK_LAYER_USAGE:
              FILAMENT_TRACKER.set_print_metadata(PENDING_PRINT_METADATA)

            PENDING_PRINT_METADATA["tracking_started"] = True

          PENDING_PRINT_REFERENCE = {}
      else:
        PRINT_RUN_REGISTRY.update_run(PRINTER_ID, data)

    if final_now:
      PRINT_RUN_REGISTRY.finalize_run(PRINTER_ID, data)
      if PENDING_PRINT_METADATA:
        PENDING_PRINT_METADATA = {}

    #if ("gcode_state" in data["print"] and data["print"]["gcode_state"] == "RUNNING") and ("print_type" in data["print"] and data["print"]["print_type"] != "local") \
    #  and ("tray_tar" in data["print"] and data["print"]["tray_tar"] != "255") and ("stg_cur" in data["print"] and data["print"]["stg_cur"] == 0 and PRINT_CURRENT_STAGE != 0):
    
    #TODO: What happens when printed from external spool, is ams and tray_tar set?
    if PRINTER_STATE.get("print", {}).get("print_type") == "local" and PRINTER_STATE_LAST.get("print"):
      # When stage changed to "change filament" and PENDING_PRINT_METADATA is set
      if (PENDING_PRINT_METADATA and 
          (
            (
              int(PRINTER_STATE["print"].get("stg_cur", -1)) == 4 and      # change filament stage (beginning of print)
              ( 
                PRINTER_STATE_LAST["print"].get("stg_cur", -1) == -1 or                                           # last stage not known
                (
                  int(PRINTER_STATE_LAST["print"].get("stg_cur")) != int(PRINTER_STATE["print"].get("stg_cur")) and
                  PRINTER_STATE_LAST["print"].get("ams", {}).get("tray_tar") == "255"             # stage has changed and last state was 255 (retract to ams)
                )
                or not PRINTER_STATE_LAST["print"].get("ams")                                               # ams not set in last state
              )
            )
            or                                                                                            # filament changes during printing are in mc_print_sub_stage
            (
              int(PRINTER_STATE_LAST["print"].get("mc_print_sub_stage", -1)) == 4  # last state was change filament
              and int(PRINTER_STATE["print"].get("mc_print_sub_stage", -1)) == 2                                                           # current state 
            )
            or (
              PRINTER_STATE["print"].get("ams", {}).get("tray_tar") == "254"
            )
            or 
            (
              int(PRINTER_STATE["print"].get("stg_cur", -1)) == 24 and int(PRINTER_STATE_LAST["print"].get("stg_cur", -1)) == 13
            )
            or (
              int(PRINTER_STATE["print"].get("stg_cur", -1)) == 4 and
              PRINTER_STATE["print"].get("ams", {}).get("tray_tar") not in (None, "255") and
              (PRINTER_STATE_LAST["print"].get("ams", {}).get("tray_tar") is None or PRINTER_STATE_LAST["print"].get("ams", {}).get("tray_tar") != PRINTER_STATE["print"].get("ams", {}).get("tray_tar"))
            )

          )
      ):
        if PRINTER_STATE["print"].get("ams"):
            mapped = False
            tray_tar_value = PRINTER_STATE["print"].get("ams").get("tray_tar")
            if tray_tar_value and tray_tar_value != "255":
                mapped = map_filament(int(tray_tar_value))
            FILAMENT_TRACKER.apply_ams_mapping(PENDING_PRINT_METADATA.get("ams_mapping") or [])
            if mapped:
                PENDING_PRINT_METADATA["complete"] = True

    if PENDING_PRINT_METADATA and PENDING_PRINT_METADATA.get("complete") and not PENDING_PRINT_METADATA.get("skip_spend"):
      if TRACK_LAYER_USAGE:
        if PENDING_PRINT_METADATA.get("print_type") == "local":
          FILAMENT_TRACKER.apply_ams_mapping(PENDING_PRINT_METADATA.get("ams_mapping") or [])
        else:
          FILAMENT_TRACKER.set_print_metadata(PENDING_PRINT_METADATA)
        # Per-layer tracker will handle consumption; skip upfront spend.
      else:
        spendFilaments(PENDING_PRINT_METADATA)

        PENDING_PRINT_METADATA = {}

    if _lan_project_is_active(LAST_LAN_PROJECT) and _matches_print_identity(PRINTER_STATE.get("print", {}), LAST_LAN_PROJECT):
      if (
        PRINTER_STATE.get("print", {}).get("gcode_state") == "IDLE"
        and PRINTER_STATE_LAST.get("print", {}).get("gcode_state") not in (None, "IDLE")
      ):
        LAST_LAN_PROJECT = {}
    elif LAST_LAN_PROJECT and not _lan_project_is_active(LAST_LAN_PROJECT):
      LAST_LAN_PROJECT = {}
  
    PRINTER_STATE_LAST = copy.deepcopy(PRINTER_STATE)

def publish(client, msg):
  result = client.publish(f"device/{PRINTER_ID}/request", json.dumps(msg))
  status = result[0]
  if status == 0:
    log(f"Sent {msg} to topic device/{PRINTER_ID}/request")
    return True

  log(f"Failed to send message to topic device/{PRINTER_ID}/request")
  return False


def clear_ams_tray_assignment(ams_id, tray_id):
  if not MQTT_CLIENT:
    return

  ams_message = copy.deepcopy(AMS_FILAMENT_SETTING)
  ams_message["print"]["ams_id"] = int(ams_id)
  ams_message["print"]["tray_id"] = int(tray_id)
  ams_message["print"]["tray_color"] = ""
  ams_message["print"]["nozzle_temp_min"] = None
  ams_message["print"]["nozzle_temp_max"] = None
  ams_message["print"]["tray_type"] = ""
  ams_message["print"]["setting_id"] = ""
  ams_message["print"]["tray_info_idx"] = ""

  publish(MQTT_CLIENT, ams_message)

# Inspired by https://github.com/Donkie/Spoolman/issues/217#issuecomment-2303022970
def on_message(client, userdata, msg):
  global LAST_AMS_CONFIG, PRINTER_STATE, PRINTER_STATE_LAST, PENDING_PRINT_METADATA, PRINTER_MODEL
  
  try:
    data = json.loads(msg.payload.decode())

    info = data.get("info")
    if info and info.get("command") == "get_version":
      modules = info.get("module", [])
      detected = identify_ams_models_from_modules(modules)
      models_by_id = identify_ams_models_by_id(modules)
      LAST_AMS_CONFIG["get_version"] = {
        "info": info,
        "modules": modules,
        "detected_models": detected,
        "models_by_id": models_by_id,
      }

    if "print" in data:
      global _LOG_WRITE_FAILED
      if LOG_FILE and not _LOG_WRITE_FAILED:
        try:
          append_to_rotating_file(LOG_FILE, _mask_mqtt_payload(msg.payload.decode()))
        except OSError as exc:
          _LOG_WRITE_FAILED = True
          log(f"[WARNING] Failed to write MQTT log to {LOG_FILE!r}: {exc}")

    #print(data)

    if AUTO_SPEND:
        processMessage(data)
        FILAMENT_TRACKER.on_message(data)
      
    # Save external spool tray data
    if "print" in data and "vt_tray" in data["print"]:
      LAST_AMS_CONFIG["vt_tray"] = data["print"]["vt_tray"]

    # Save ams spool data
    if "print" in data and "ams" in data["print"] and "ams" in data["print"]["ams"]:
      LAST_AMS_CONFIG["ams"] = data["print"]["ams"]["ams"]
      for ams in data["print"]["ams"]["ams"]:
        log(f"AMS [{num2letter(ams['id'])}] (hum: {ams['humidity']}, temp: {ams['temp']}ºC)")
        for tray in ams["tray"]:
          if "tray_sub_brands" in tray:
            log(
                f"    - [{num2letter(ams['id'])}{tray['id']}] {tray['tray_sub_brands']} {tray['tray_color']} ({str(tray['remain']).zfill(3)}%) [[ {tray['tray_uuid']} ]]")

            found = False
            tray_uuid = "00000000000000000000000000000000"

            for spool in fetchSpools(True):

              tray_uuid = tray["tray_uuid"]

              if not spool.get("extra", {}).get("tag"):
                continue
              tag = json.loads(spool["extra"]["tag"])
              if tag != tray["tray_uuid"]:
                continue

              found = True

              setActiveTray(spool['id'], spool["extra"], ams['id'], tray["id"])

              # TODO: filament remaining - Doesn't work for AMS Lite
              # requests.patch(f"http://{SPOOLMAN_IP}:7912/api/v1/spool/{spool['id']}", json={
              #  "remaining_weight": tray["remain"] / 100 * tray["tray_weight"]
              # })

            if not found and tray_uuid == "00000000000000000000000000000000":
              log("      - non Bambulab Spool!")
            elif not found:
              log("      - Not found. Update spool tag!")
              tray["unmapped_bambu_tag"] = tray_uuid
              tray["issue"] = True
              clear_active_spool_for_tray(ams['id'], tray['id'])
              clear_ams_tray_assignment(ams['id'], tray['id'])
          else:
            log(
                f"    - [{num2letter(ams['id'])}{tray['id']}]")
            log("      - No Spool!")

  except Exception:
    traceback.print_exc()

def on_connect(client, userdata, flags, rc):
  global MQTT_CLIENT_CONNECTED
  MQTT_CLIENT_CONNECTED = True
  log("Connected with result code " + str(rc))
  client.subscribe(f"device/{PRINTER_ID}/report")
  publish(client, GET_VERSION)
  publish(client, PUSH_ALL)

def on_disconnect(client, userdata, rc):
  global MQTT_CLIENT_CONNECTED
  MQTT_CLIENT_CONNECTED = False
  log("Disconnected with result code " + str(rc))
  
def async_subscribe():
  global MQTT_CLIENT
  global MQTT_CLIENT_CONNECTED
  
  MQTT_CLIENT_CONNECTED = False
  MQTT_CLIENT = mqtt.Client()
  MQTT_CLIENT.username_pw_set("bblp", PRINTER_CODE)
  ssl_ctx = ssl.create_default_context()
  ssl_ctx.check_hostname = False
  ssl_ctx.verify_mode = ssl.CERT_NONE
  MQTT_CLIENT.tls_set_context(ssl_ctx)
  MQTT_CLIENT.tls_insecure_set(True)
  MQTT_CLIENT.on_connect = on_connect
  MQTT_CLIENT.on_disconnect = on_disconnect
  MQTT_CLIENT.on_message = on_message
  
  while True:
    while not MQTT_CLIENT_CONNECTED:
      try:
          log("🔄 Trying to connect ...", flush=True)
          MQTT_CLIENT.connect(PRINTER_IP, 8883, MQTT_KEEPALIVE)
          MQTT_CLIENT.loop_start()
          
      except Exception as exc:
          log(f"⚠️ connection failed: {exc}, new try in 15 seconds...", flush=True)

      time.sleep(15)

    time.sleep(15)

def init_mqtt(daemon: bool = False):
  # Start the asynchronous processing in a separate thread
  thread = Thread(target=async_subscribe, daemon=daemon)
  thread.start()

def getLastAMSConfig():
  global LAST_AMS_CONFIG
  return LAST_AMS_CONFIG


def getDetectedAmsModelsById():
  global LAST_AMS_CONFIG
  detected = LAST_AMS_CONFIG.get("get_version", {}).get("models_by_id") or {}
  return dict(detected)


def getMqttClient():
  global MQTT_CLIENT
  return MQTT_CLIENT

def isMqttClientConnected():
  global MQTT_CLIENT_CONNECTED

  return MQTT_CLIENT_CONNECTED
