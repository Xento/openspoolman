

import json
import ssl
import traceback
from threading import Thread
from typing import Any, Iterable
from urllib.parse import urlparse

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
from spoolman_service import (
    spendFilaments,
    setActiveTray,
    fetchSpools,
    clear_active_spool_for_tray,
    normalize_ams_mapping2,
    normalize_ams_mapping_entry,
    tray_uid_from_mapping_entry,
    get_spool_id_for_tray_uid,
)
from tools_3mf import getMetaDataFrom3mf
import time
import copy
from collections.abc import Mapping
from logger import append_to_rotating_file, log
from print_history import insert_print, insert_filament_usage, update_filament_spool
from filament_usage_tracker import FilamentUsageTracker
MQTT_CLIENT = {}  # Global variable storing MQTT Client
MQTT_CLIENT_CONNECTED = False
MQTT_KEEPALIVE = 60
LAST_AMS_CONFIG = {}  # Global variable storing last AMS configuration

PRINTER_STATE = {}
PRINTER_STATE_LAST = {}
ACTIVE_PRINT_ID = None

PENDING_PRINT_METADATA = {}
FILAMENT_TRACKER = FilamentUsageTracker()
LOG_FILE = "/home/app/logs/mqtt.log"

def _load_project_metadata(url: str) -> dict | None:
  metadata = getMetaDataFrom3mf(url)
  if not metadata or not metadata.get("filaments"):
    log("[filament-tracker] No metadata/filaments found in 3MF; skipping tracking for this job")
    return None
  metadata["metadata_loaded"] = True
  return metadata


def _classify_project_source(
  url: str | None,
  incoming_type: str | None,
  has_ams_mapping: bool,
) -> str:
  scheme = (urlparse(url).scheme or "").lower()
  if scheme in ("http", "https"):
    return "cloud"
  if incoming_type == "cloud":
    return "cloud"
  if incoming_type == "local":
    return "lan_only" if has_ams_mapping else "local"
  if incoming_type:
    return incoming_type
  return "local"

def _insert_filament_usage_entries(print_id, filaments: dict) -> None:
  log(f"[print-history] Preparing to insert {len(filaments)} filament rows for print {print_id}")
  for id, filament in filaments.items():
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


def _link_spools_to_print(print_id: int | None, ams_mapping: list | None) -> None:
  if not print_id or not ams_mapping:
    return
  for filament_index, mapping_entry in enumerate(ams_mapping):
    if not mapping_entry:
      continue
    tray_uid = tray_uid_from_mapping_entry(mapping_entry)
    if not tray_uid:
      continue
    spool_id = get_spool_id_for_tray_uid(tray_uid)
    if spool_id is None:
      continue
    update_filament_spool(print_id, filament_index + 1, spool_id)

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

def _supports_early_ftp_download() -> bool:
  model_name = (getPrinterModel() or {}).get("model", "")
  return model_name in {"A1", "A1 Mini", "P1P", "P1S"}

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

def _mask_serial(serial: str | None, keep_chars: int = 3) -> str:
  if not serial:
    return ""
  visible = serial[:keep_chars]
  if len(serial) <= keep_chars:
    return visible
  return f"{visible}...[redacted]"

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

def map_filament(tray_tar):
  global PENDING_PRINT_METADATA
  # Prüfen, ob ein Filamentwechsel aktiv ist (stg_cur == 4)
  # if stg_cur == 4 and tray_tar is not None:
  if PENDING_PRINT_METADATA:
    existing_mapping = normalize_ams_mapping2(
      PENDING_PRINT_METADATA.get("ams_mapping2"),
      PENDING_PRINT_METADATA.get("ams_mapping"),
    )
    if existing_mapping:
      filament_order = PENDING_PRINT_METADATA.get("filamentOrder") or {}
      target_filaments = {int(fid) for fid in filament_order.keys() if str(fid).isdigit()}
      assigned_filaments = {
        idx for idx, tray in enumerate(existing_mapping) if tray is not None
      }
      if (
        (target_filaments and target_filaments.issubset(assigned_filaments))
        or (not target_filaments and all(entry is not None for entry in existing_mapping))
      ):
        log("Skipping tray-change mapping because AMS mapping is already complete")
        return None
    filament_changes = PENDING_PRINT_METADATA.setdefault("filamentChanges", [])
    filament_changes.append(tray_tar)  # Jeder Wechsel zählt, auch auf das gleiche Tray
    log(f'Filamentchange {len(filament_changes)}: Tray {tray_tar}')

    # Anzahl der erkannten Wechsel
    change_count = len(filament_changes) - 1  # -1, weil der erste Eintrag kein Wechsel ist

    filament_order = PENDING_PRINT_METADATA.get("filamentOrder") or {}
    ordered_filaments = sorted(filament_order.items(), key=lambda entry: entry[1])
    assigned_trays = PENDING_PRINT_METADATA.setdefault("assigned_trays", [])
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
      mapping_entry = normalize_ams_mapping_entry(tray_tar)
      tray_uid = tray_uid_from_mapping_entry(mapping_entry)
      mapping = PENDING_PRINT_METADATA.setdefault("ams_mapping", [])
      mapping2 = PENDING_PRINT_METADATA.setdefault("ams_mapping2", [])
      filament_idx = int(filament_assigned)
      while len(mapping) <= filament_idx:
        mapping.append(None)
        mapping2.append(None)
      mapping[filament_idx] = mapping_entry
      mapping2[filament_idx] = mapping_entry
      log(f"✅ Tray {tray_uid or tray_tar} assigned to Filament {filament_assigned}")

      for filament, tray in enumerate(mapping):
        if tray is None:
          continue
        log(f"  Filament pos: {filament} → Tray {tray_uid_from_mapping_entry(tray) or tray}")

    target_filaments = set(filament_order.keys())
    if target_filaments:
      assigned_filaments = {
        idx for idx, tray in enumerate(PENDING_PRINT_METADATA.get("ams_mapping", []))
        if tray is not None
      }
      if target_filaments.issubset(assigned_filaments):
        log("\n✅ All trays assigned:")
        return True
  
  return False
  
def processMessage(data):
  global LAST_AMS_CONFIG, PRINTER_STATE, PRINTER_STATE_LAST, PENDING_PRINT_METADATA, ACTIVE_PRINT_ID

   # Prepare AMS spending estimation
  if "print" in data:    
    update_dict(PRINTER_STATE, data)
    
    # Handle project_file events (3MF metadata load) uniformly regardless of origin.
    if data["print"].get("command") == "project_file" and data["print"].get("url"):
      ACTIVE_PRINT_ID = None
      url = data["print"].get("url")
      incoming_type = PRINTER_STATE["print"].get("print_type")
      metadata = _load_project_metadata(url)
      if metadata is None:
        log(
          "[filament-tracker] Failed to parse 3MF metadata for project "
          f"{url or 'unknown'}; skipping tracking."
        )
        PENDING_PRINT_METADATA = {}
        PRINTER_STATE_LAST = copy.deepcopy(PRINTER_STATE)
        return

      PENDING_PRINT_METADATA = metadata
      # check if ams_mapping is available
      normalized = normalize_ams_mapping2(
        PRINTER_STATE["print"].get("ams_mapping2"),
        PRINTER_STATE["print"].get("ams_mapping"),
      )
      has_ams_mapping = any(entry is not None for entry in normalized)
      source_type = _classify_project_source(url, incoming_type, has_ams_mapping)
      scheme = (urlparse(url).scheme or "").lower()
      log(
        f"[filament-tracker] project_file url={url!r} scheme={scheme or 'none'} "
        f"classified={source_type}"
      )
      PENDING_PRINT_METADATA["task_id"] = PRINTER_STATE["print"].get("task_id")
      PENDING_PRINT_METADATA["subtask_id"] = PRINTER_STATE["print"].get("subtask_id")
      PENDING_PRINT_METADATA["print_type"] = source_type
      use_ams_flag = PRINTER_STATE["print"].get("use_ams")
      use_ams = bool(use_ams_flag) if use_ams_flag is not None else bool(normalized)

      # If no AMS mapping is present fall back to external spool 
      if not use_ams:
        normalized = [normalize_ams_mapping_entry(EXTERNAL_SPOOL_ID)]

      start_immediately = source_type == "cloud"

      if normalized:
        PENDING_PRINT_METADATA["ams_mapping"] = normalized
        PENDING_PRINT_METADATA["ams_mapping2"] = normalized

        if not start_immediately:
          PRINTER_STATE_LAST = copy.deepcopy(PRINTER_STATE)
          return

        print_name = (
          PRINTER_STATE["print"].get("subtask_name")
          or PENDING_PRINT_METADATA.get("file")
          or PENDING_PRINT_METADATA.get("model_path")
          or "print"
        )
        print_type = PENDING_PRINT_METADATA["print_type"]
        print_id = insert_print(print_name, print_type, PENDING_PRINT_METADATA["image"])
        PENDING_PRINT_METADATA["print_id"] = print_id
        ACTIVE_PRINT_ID = print_id
        _link_spools_to_print(print_id, normalized)
        PENDING_PRINT_METADATA["complete"] = True

        _insert_filament_usage_entries(print_id, PENDING_PRINT_METADATA["filaments"])
        if TRACK_LAYER_USAGE:
          FILAMENT_TRACKER.set_print_metadata(PENDING_PRINT_METADATA)
        return

      PRINTER_STATE_LAST = copy.deepcopy(PRINTER_STATE)
      return
  
    #if ("gcode_state" in data["print"] and data["print"]["gcode_state"] == "RUNNING") and ("print_type" in data["print"] and data["print"]["print_type"] != "local") \
    #  and ("tray_tar" in data["print"] and data["print"]["tray_tar"] != "255") and ("stg_cur" in data["print"] and data["print"]["stg_cur"] == 0 and PRINT_CURRENT_STAGE != 0):
    
    # Local/SD print flow: start tracking once download is complete (>=99%) or the job is RUNNING.
    print_state = PRINTER_STATE.get("print", {})
    print_type = print_state.get("print_type")
    project_id = print_state.get("project_id")
    is_local_like = print_type == "local" or (
      (project_id in (None, 0, "0")) and print_type != "cloud"
    )
    if is_local_like and PRINTER_STATE_LAST.get("print"):
      gcode_state = print_state.get("gcode_state")
      prev_gcode_state = PRINTER_STATE_LAST["print"].get("gcode_state")
      previously_idle = prev_gcode_state in ("IDLE", "FAILED", "FINISH")
      try:
        gcode_file_prepare_percent = int(print_state.get("gcode_file_prepare_percent", "-1"))
      except (TypeError, ValueError):
        gcode_file_prepare_percent = -1

      download_ready = (
        _supports_early_ftp_download()
        and gcode_state == "PREPARE"
        and gcode_file_prepare_percent >= 99
      )
      ran_without_download = gcode_state == "RUNNING" and (
        previously_idle or prev_gcode_state == "PREPARE"
      )
      should_attempt_tracking = (
        print_state.get("gcode_file")
        and (
          download_ready
          or ran_without_download
          or (
            PENDING_PRINT_METADATA
            and PENDING_PRINT_METADATA.get("metadata_loaded")
            and not PENDING_PRINT_METADATA.get("tracking_started")
          )
        )
      )
      if should_attempt_tracking:

        # Ensure metadata is loaded from the 3MF before starting tracking.
        if not PENDING_PRINT_METADATA or not PENDING_PRINT_METADATA.get("metadata_loaded"):
          existing_metadata = PENDING_PRINT_METADATA or {}
          existing_print_id = existing_metadata.get("print_id")
          existing_print_type = existing_metadata.get("print_type")
          PENDING_PRINT_METADATA = getMetaDataFrom3mf(PRINTER_STATE["print"]["gcode_file"])
          if PENDING_PRINT_METADATA and PENDING_PRINT_METADATA.get("filaments"):
            PENDING_PRINT_METADATA["metadata_loaded"] = True
            if existing_print_id and not PENDING_PRINT_METADATA.get("print_id"):
              PENDING_PRINT_METADATA["print_id"] = existing_print_id
            if existing_print_type and not PENDING_PRINT_METADATA.get("print_type"):
              PENDING_PRINT_METADATA["print_type"] = existing_print_type
        if PENDING_PRINT_METADATA and PENDING_PRINT_METADATA.get("filaments"):
          if not PENDING_PRINT_METADATA.get("print_type"):
            PENDING_PRINT_METADATA["print_type"] = print_type or "local"
          PENDING_PRINT_METADATA["task_id"] = PRINTER_STATE["print"].get("task_id")
          PENDING_PRINT_METADATA["subtask_id"] = PRINTER_STATE["print"].get("subtask_id")

          if gcode_state == "RUNNING":
            print_id = PENDING_PRINT_METADATA.get("print_id")
            if not print_id and ACTIVE_PRINT_ID:
              print_id = ACTIVE_PRINT_ID
              PENDING_PRINT_METADATA["print_id"] = print_id
            if not print_id:
              print_name = (
                PENDING_PRINT_METADATA.get("file")
                or PENDING_PRINT_METADATA.get("model_path")
                or PRINTER_STATE["print"].get("subtask_name")
                or "print"
              )
              print_id = insert_print(
                print_name,
                print_type or "local",
                PENDING_PRINT_METADATA.get("image"),
              )
              PENDING_PRINT_METADATA["print_id"] = print_id
              ACTIVE_PRINT_ID = print_id
              _link_spools_to_print(print_id, PENDING_PRINT_METADATA.get("ams_mapping"))

          # Start tracking once per job, using AMS mapping when available.
          if not PENDING_PRINT_METADATA.get("tracking_started"):
            if FILAMENT_TRACKER.active_model is not None:
              PENDING_PRINT_METADATA["tracking_started"] = True
            else:
              print_id = PENDING_PRINT_METADATA.get("print_id")
              if not print_id and ACTIVE_PRINT_ID:
                print_id = ACTIVE_PRINT_ID
                PENDING_PRINT_METADATA["print_id"] = print_id
              if not print_id:
                print_id = insert_print(
                  PENDING_PRINT_METADATA["file"],
                  print_type or "local",
                  PENDING_PRINT_METADATA["image"],
                )
                ACTIVE_PRINT_ID = print_id

              normalized = normalize_ams_mapping2(
                PRINTER_STATE["print"].get("ams_mapping2"),
                PRINTER_STATE["print"].get("ams_mapping"),
              )
              use_ams_flag = PRINTER_STATE["print"].get("use_ams")
              has_mapping = any(entry is not None for entry in normalized)
              use_ams = bool(use_ams_flag) if use_ams_flag is not None else has_mapping
              if use_ams and normalized:
                PENDING_PRINT_METADATA["ams_mapping"] = normalized
                PENDING_PRINT_METADATA["ams_mapping2"] = normalized
              else:
                PENDING_PRINT_METADATA.setdefault("ams_mapping", [])
                PENDING_PRINT_METADATA.setdefault("ams_mapping2", [])

              PENDING_PRINT_METADATA["filamentChanges"] = []
              PENDING_PRINT_METADATA["assigned_trays"] = []

              filament_order = PENDING_PRINT_METADATA.get("filamentOrder") or {}
              target_filaments = set()
              for filament_id in filament_order.keys():
                try:
                  target_filaments.add(int(filament_id))
                except (TypeError, ValueError):
                  continue
              assigned_filaments = {
                idx for idx, tray in enumerate(PENDING_PRINT_METADATA.get("ams_mapping") or [])
                if tray is not None
              }
              if target_filaments:
                mapping_complete = target_filaments.issubset(assigned_filaments)
              else:
                mapping_complete = any(
                  tray is not None for tray in (PENDING_PRINT_METADATA.get("ams_mapping") or [])
                )
              PENDING_PRINT_METADATA["complete"] = mapping_complete
              PENDING_PRINT_METADATA["print_id"] = print_id
              _link_spools_to_print(print_id, PENDING_PRINT_METADATA.get("ams_mapping"))
              FILAMENT_TRACKER.start_local_print_from_metadata(PENDING_PRINT_METADATA)

              _insert_filament_usage_entries(print_id, PENDING_PRINT_METADATA["filaments"])

              PENDING_PRINT_METADATA["tracking_started"] = True

        #TODO 
    
      # Update AMS mapping once the printer reports concrete tray assignments.
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

    # Finalize or spend once metadata is complete.
    if PENDING_PRINT_METADATA and PENDING_PRINT_METADATA.get("complete"):
      if not PENDING_PRINT_METADATA.get("complete_handled"):
        if TRACK_LAYER_USAGE:
          if PENDING_PRINT_METADATA.get("print_type") == "local":
            FILAMENT_TRACKER.apply_ams_mapping(PENDING_PRINT_METADATA.get("ams_mapping") or [])
          else:
            FILAMENT_TRACKER.set_print_metadata(PENDING_PRINT_METADATA)
          # Per-layer tracker will handle consumption; skip upfront spend.
        else:
          spendFilaments(PENDING_PRINT_METADATA)
        PENDING_PRINT_METADATA["complete_handled"] = True

      should_clear = True
      if PENDING_PRINT_METADATA.get("print_type") in ("local", "lan_only") and not PENDING_PRINT_METADATA.get("tracking_started"):
        should_clear = False
      if should_clear:
        PENDING_PRINT_METADATA = {}
  
    gcode_state = PRINTER_STATE.get("print", {}).get("gcode_state")
    prev_gcode_state = PRINTER_STATE_LAST.get("print", {}).get("gcode_state")
    if gcode_state in ("FINISH", "FAILED", "IDLE") and prev_gcode_state not in (None, "FINISH", "FAILED", "IDLE"):
      ACTIVE_PRINT_ID = None

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
      append_to_rotating_file("/home/app/logs/mqtt.log", _mask_mqtt_payload(msg.payload.decode()))

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
