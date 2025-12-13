import json
import os
import traceback
from typing import Any, Dict, List, Optional, Tuple

from flask import Blueprint, jsonify, request

import mqtt_bambulab
import spoolman_client
import spoolman_service
import test_data
from config import EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID, PRINTER_ID, PRINTER_NAME

api_bp = Blueprint("api", __name__, url_prefix="/api")

READ_ONLY_MODE = (not test_data.test_data_active()) and os.getenv("OPENSPOOLMAN_LIVE_READONLY") == "1"
ACTIVE_PRINTER_ID = (PRINTER_ID or "").upper() or "PRINTER_1"


def json_success(data: Any, status: int = 200):
  return jsonify({"success": True, "data": data}), status


def json_error(code: str, message: str, status: int = 400):
  return jsonify({"success": False, "error": {"code": code, "message": message}}), status


def _printer_matches(printer_id: str) -> bool:
  return str(printer_id or "").upper() == ACTIVE_PRINTER_ID


def _clean_json_value(value: Any) -> Any:
  if isinstance(value, str):
    try:
      return json.loads(value)
    except Exception:
      return value
  return value


def _serialize_spool(spool: Dict[str, Any]) -> Dict[str, Any]:
  filament = spool.get("filament", {}) or {}
  extra = spool.get("extra", {}) or {}

  tag = _clean_json_value(extra.get("tag"))

  assigned_ams_id = None
  assigned_tray_index = None
  active_tray = extra.get("active_tray")
  if active_tray:
    try:
      tray_uid = json.loads(active_tray)
      parts = tray_uid.split("_")
      if len(parts) >= 2:
        assigned_tray_index = int(parts[-1])
        assigned_ams_id = int(parts[-2])
    except Exception:
      assigned_ams_id = None
      assigned_tray_index = None

  return {
      "id": str(spool.get("id")),
      "name": filament.get("name") or spool.get("name") or f"Spool {spool.get('id')}",
      "material": filament.get("material") or "",
      "color": filament.get("multi_color_hexes") or filament.get("color_hex") or "",
      "diameter_mm": filament.get("diameter"),
      "weight_g": spool.get("initial_weight") or filament.get("weight"),
      "remaining_g": spool.get("remaining_weight"),
      "tag": tag,
      "location": spool.get("location"),
      "ams_id": assigned_ams_id,
      "tray_index": assigned_tray_index,
  }


def _find_spool_for_tray(spools: List[Dict[str, Any]], ams_id: int, tray_id: int) -> Optional[Dict[str, Any]]:
  tray_uid = spoolman_service.trayUid(ams_id, tray_id)
  for spool in spools:
    active = _clean_json_value((spool.get("extra") or {}).get("active_tray"))
    if active and active == tray_uid:
      return spool
  return None


def _serialize_tray(tray: Dict[str, Any], spools: List[Dict[str, Any]], ams_id: int) -> Dict[str, Any]:
  tray_id = int(tray.get("id") or 0)
  matched_spool = _find_spool_for_tray(spools, ams_id, tray_id)

  filament = matched_spool.get("filament", {}) if matched_spool else {}
  spool_name = filament.get("name") if matched_spool else None
  spool_id = matched_spool.get("id") if matched_spool else None
  vendor = (filament.get("vendor") or {}).get("name")
  material = filament.get("material") or tray.get("tray_type") or ""

  tray_color_raw = tray.get("tray_color") or ""
  tray_color = spoolman_service.normalize_color_hex(tray_color_raw)
  tray_color_value = f"#{tray_color}" if tray_color else ""

  spool_color_value = ""
  color_mismatch = False
  color_mismatch_message = ""
  has_multi_color = False
  raw_multi_color = filament.get("multi_color_hexes")
  if raw_multi_color:
    has_multi_color = True
    first_color = None
    if isinstance(raw_multi_color, list):
      first_color = raw_multi_color[0] if raw_multi_color else None
    else:
      first_color = str(raw_multi_color).split(",")[0]
    normalized = spoolman_service.normalize_color_hex(first_color or "")
    if normalized:
      spool_color_value = f"#{normalized}"
  else:
    normalized = spoolman_service.normalize_color_hex(filament.get("color_hex") or "")
    if normalized:
      spool_color_value = f"#{normalized}"

  if not has_multi_color and tray_color_value and spool_color_value:
    distance = spoolman_service.color_distance(tray_color_value, spool_color_value)
    if distance is not None and distance > spoolman_service.COLOR_DISTANCE_TOLERANCE:
      color_mismatch = True
      color_mismatch_message = "Colors are not similar."

  color_value = spool_color_value or tray_color_value
  active = bool(tray.get("state") == 3 or matched_spool)
  is_loaded = bool(tray.get("remain")) or bool(matched_spool)
  remaining_g = None
  if matched_spool:
    remaining_g = matched_spool.get("remaining_weight")
    if remaining_g is None:
      remaining_g = matched_spool.get("remain")
  else:
    remaining_g = tray.get("remain")

  return {
      "index": tray_id,
      "ams_id": ams_id,
      "spool_id": spool_id,
      "spool_name": spool_name,
      "material": material,
      "color": color_value,
      "tray_color": tray_color_value,
      "spool_color": spool_color_value,
      "color_mismatch": color_mismatch,
      "color_mismatch_message": color_mismatch_message,
      "spool_vendor": vendor,
      "remaining_g": remaining_g,
      "active": active,
      "is_loaded": is_loaded,
  }


def _load_printer_summary() -> Dict[str, Any]:
  model = mqtt_bambulab.getPrinterModel()
  name = PRINTER_NAME or model.get("devicename") or "Printer"

  return {
      "id": ACTIVE_PRINTER_ID,
      "name": name,
      "online": mqtt_bambulab.isMqttClientConnected(),
      "last_seen": None,
  }


def _load_trays() -> Tuple[List[Dict[str, Any]], Dict[str, Any]]:
  config = mqtt_bambulab.getLastAMSConfig() or {}
  spools = mqtt_bambulab.fetchSpools()

  trays: List[Dict[str, Any]] = []

  vt_tray = config.get("vt_tray")
  if vt_tray:
    trays.append(_serialize_tray(vt_tray, spools, EXTERNAL_SPOOL_AMS_ID))

  for ams in config.get("ams", []):
    ams_id = int(ams.get("id", 0))
    for tray in ams.get("tray", []):
      trays.append(_serialize_tray(tray, spools, ams_id))

  return trays, config


def _resolve_tray_context(tray_index: int) -> Tuple[Optional[int], Optional[int]]:
  config = mqtt_bambulab.getLastAMSConfig() or {}

  vt_tray = config.get("vt_tray")
  if vt_tray and int(vt_tray.get("id", -1)) == tray_index:
    return EXTERNAL_SPOOL_AMS_ID, tray_index

  for ams in config.get("ams", []):
    ams_id = int(ams.get("id", -1))
    for tray in ams.get("tray", []):
      if int(tray.get("id", -1)) == tray_index:
        return ams_id, tray_index

  return None, None


@api_bp.route("/printers", methods=["GET"])
def api_list_printers():
  try:
    printer = _load_printer_summary()
    return json_success([printer])
  except Exception as exc:
    traceback.print_exc()
    return json_error("PRINTER_FETCH_FAILED", f"Failed to load printer info: {exc}", 500)


@api_bp.route("/printers/<printer_id>/ams", methods=["GET"])
def api_get_ams(printer_id: str):
  if not _printer_matches(printer_id):
    return json_error("PRINTER_NOT_FOUND", f"Printer '{printer_id}' not found", 404)

  try:
    trays, _ = _load_trays()
    payload = {"printer_id": ACTIVE_PRINTER_ID, "ams_slots": trays}
    return json_success(payload)
  except Exception as exc:
    traceback.print_exc()
    return json_error("AMS_FETCH_FAILED", f"Failed to fetch AMS data: {exc}", 500)


@api_bp.route("/spools", methods=["GET"])
def api_get_spools():
  try:
    spools = spoolman_service.fetchSpools()
    return json_success([_serialize_spool(spool) for spool in spools])
  except Exception as exc:
    traceback.print_exc()
    return json_error("SPOOL_FETCH_FAILED", f"Failed to fetch spools: {exc}", 500)


@api_bp.route("/printers/<printer_id>/ams/<int:tray_index>/assign", methods=["POST"])
def api_assign_tray(printer_id: str, tray_index: int):
  if not _printer_matches(printer_id):
    return json_error("PRINTER_NOT_FOUND", f"Printer '{printer_id}' not found", 404)

  if READ_ONLY_MODE:
    return json_error("READ_ONLY_MODE", "Live read-only mode: assigning spools to trays is disabled.", 403)

  if not mqtt_bambulab.isMqttClientConnected():
    return json_error("PRINTER_OFFLINE", "MQTT is disconnected. Is the printer online?", 503)

  body = request.get_json(silent=True) or {}
  spool_id = body.get("spool_id")

  if not spool_id:
    return json_error("INVALID_REQUEST", "Field 'spool_id' is required.", 400)

  ams_id = body.get("ams_id")
  if ams_id is None:
    ams_id, resolved_tray = _resolve_tray_context(tray_index)
    if resolved_tray is None:
      return json_error("TRAY_NOT_FOUND", f"Tray '{tray_index}' not found", 404)
  else:
    try:
      ams_id = int(ams_id)
    except (TypeError, ValueError):
      return json_error("INVALID_REQUEST", "ams_id must be an integer when provided.", 400)
    resolved_tray = tray_index

  try:
    spool_data = spoolman_client.getSpoolById(spool_id)
  except Exception as exc:
    traceback.print_exc()
    return json_error("SPOOL_FETCH_FAILED", f"Failed to fetch spool '{spool_id}': {exc}", 502)

  if not spool_data or spool_data.get("id") is None:
    return json_error("SPOOL_NOT_FOUND", f"Spool '{spool_id}' not found", 404)

  try:
    mqtt_bambulab.setActiveTray(spool_id, spool_data.get("extra"), ams_id, resolved_tray)

    # Reuse the existing assignment logic from app.setActiveSpool to keep behavior aligned with /fill.
    from app import setActiveSpool  # Local import to avoid circular dependency at module load time
    setActiveSpool(ams_id, resolved_tray, spool_data)
  except Exception as exc:
    traceback.print_exc()
    return json_error("ASSIGN_FAILED", f"Failed to assign spool '{spool_id}' to tray '{tray_index}': {exc}", 500)

  return json_success({"printer_id": ACTIVE_PRINTER_ID, "tray_index": tray_index, "ams_id": ams_id, "spool_id": spool_id})


@api_bp.route("/printers/<printer_id>/ams/<int:tray_index>/unassign", methods=["POST"])
def api_unassign_tray(printer_id: str, tray_index: int):
  if not _printer_matches(printer_id):
    return json_error("PRINTER_NOT_FOUND", f"Printer '{printer_id}' not found", 404)

  if READ_ONLY_MODE:
    return json_error("READ_ONLY_MODE", "Live read-only mode: assigning spools to trays is disabled.", 403)

  body = request.get_json(silent=True) or {}
  spool_id = body.get("spool_id")

  try:
    spool: Optional[Dict[str, Any]] = None
    if spool_id:
      spool = spoolman_client.getSpoolById(spool_id)
    else:
      spools = spoolman_service.fetchSpools()
      ams_id, _ = _resolve_tray_context(tray_index)
      if ams_id is None:
        return json_error("TRAY_NOT_FOUND", f"Tray '{tray_index}' not found", 404)
      spool = _find_spool_for_tray(spools, ams_id, tray_index)

    if not spool or spool.get("id") is None:
      return json_error("SPOOL_NOT_FOUND", "No spool assigned to this tray", 404)

    extras = spool.get("extra") or {}
    spoolman_client.patchExtraTags(spool["id"], extras, {"active_tray": ""})
    return json_success(
        {
            "printer_id": ACTIVE_PRINTER_ID,
            "tray_index": tray_index,
            "spool_id": spool["id"],
            "unassigned": True,
        }
    )
  except Exception as exc:
    traceback.print_exc()
    return json_error("UNASSIGN_FAILED", f"Failed to unassign tray: {exc}", 500)
