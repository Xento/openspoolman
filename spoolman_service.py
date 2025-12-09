import os
import math
import re
from config import PRINTER_ID, EXTERNAL_SPOOL_AMS_ID, EXTERNAL_SPOOL_ID, DISABLE_MISMATCH_WARNING
from datetime import datetime
from zoneinfo import ZoneInfo
from pathlib import Path
from print_history import update_filament_spool
import json

from spoolman_client import consumeSpool, patchExtraTags, fetchSpoolList, fetchSettings

SPOOLS = {}
SPOOLMAN_SETTINGS = {}

COLOR_DISTANCE_TOLERANCE = 80

currency_symbols = {
    "AED": "د.إ", "AFN": "؋", "ALL": "Lek", "AMD": "դր.", "ANG": "ƒ", "AOA": "Kz", 
    "ARS": "$", "AUD": "$", "AWG": "Afl.", "AZN": "₼", "BAM": "KM", "BBD": "$", 
    "BDT": "৳", "BGN": "лв", "BHD": "د.ب", "BIF": "Fr", "BMD": "$", "BND": "$", 
    "BOB": "$b", "BRL": "R$", "BSD": "$", "BTN": "Nu.", "BWP": "P", "BYN": "Br", 
    "BZD": "$", "CAD": "$", "CDF": "Fr", "CHF": "CHF", "CLP": "$", "CNY": "¥", 
    "COP": "$", "CRC": "₡", "CUP": "$", "CVE": "$", "CZK": "Kč", "DJF": "Fr", 
    "DKK": "kr", "DOP": "RD$", "DZD": "دج", "EGP": "ج.م", "ERN": "Nfk", "ETB": "ታማ", 
    "EUR": "€", "FJD": "$", "FKP": "£", "GBP": "£", "GEL": "₾", "GHS": "₵", 
    "GIP": "£", "GMD": "D", "GNF": "Fr", "GTQ": "Q", "GYD": "$", "HKD": "$", 
    "HNL": "L", "HRK": "kn", "HTG": "G", "HUF": "Ft", "IDR": "Rp", "ILS": "₪", 
    "INR": "₹", "IQD": "د.ع", "IRR": "﷼", "ISK": "kr", "JMD": "$", "JOD": "د.أ", 
    "JPY": "¥", "KES": "Sh", "KGS": "с", "KHR": "៛", "KMF": "Fr", "KRW": "₩", 
    "KWD": "د.ك", "KYD": "$", "KZT": "₸", "LAK": "₭", "LBP": "ل.ل", "LKR": "Rs", 
    "LRD": "$", "LSL": "L", "LTL": "Lt", "LVL": "Ls", "LYD": "د.ل", "MAD": "د.م.", 
    "MDL": "lei", "MGA": "Ar", "MKD": "ден", "MMK": "K", "MNT": "₮", "MOP": "MOP", 
    "MRO": "UM", "MRU": "MRU", "MUR": "Rs", "MVR": "Rf", "MWK": "MK", "MXN": "$", 
    "MYR": "RM", "MZN": "MT", "NAD": "$", "NGN": "₦", "NIO": "C$", "NOK": "kr", 
    "NPR": "₨", "NZD": "$", "OMR": "ر.ع.", "PAB": "B/.", "PEN": "S/", "PGK": "K", 
    "PHP": "₱", "PKR": "₨", "PLN": "zł", "PYG": "₲", "QAR": "ر.ق", "RON": "lei", 
    "RSD": "дин.", "RUB": "₽", "RWF": "Fr", "SAR": "ر.س", "SBD": "$", "SCR": "₨", 
    "SEK": "kr", "SGD": "$", "SHP": "£", "SLL": "Le", "SOS": "Sh", "SRD": "$", 
    "SSP": "£", "STD": "Db", "STN": "STN", "SYP": "ل.س", "SZL": "L", "THB": "฿", 
    "TJS": "ЅМ", "TMT": "m", "TND": "د.ت", "TOP": "T$", "TRY": "₺", "TTD": "$", 
    "TWD": "NT$", "TZS": "Sh", "UAH": "₴", "UGX": "Sh", "UYU": "$", "UZS": "лв", 
    "VES": "Bs.S", "VND": "₫", "VUV": "Vt", "WST": "T", "XAF": "XAF", "XAG": "XAG", 
    "XAU": "XAU", "XCD": "XCD", "XDR": "XDR", "XOF": "XOF", "XPF": "XPF", "YER": "ر.ي", 
    "ZAR": "R", "ZMW": "ZK", "ZWL": "$"
}

def get_currency_symbol(code):
    return currency_symbols.get(code, code)

def trayUid(ams_id, tray_id):
  return f"{PRINTER_ID}_{ams_id}_{tray_id}"

def getAMSFromTray(n):
    return n // 4


def normalize_color_hex(color_hex):
  if not color_hex or isinstance(color_hex, list):
    return ""

  color = color_hex.strip().upper()
  if color.startswith("#"):
    color = color[1:]

  if len(color) == 8:
    color = color[:6]

  if len(color) < 6:
    return ""

  return color[:6]


def color_distance(color1, color2):
  c1 = normalize_color_hex(color1)
  c2 = normalize_color_hex(color2)

  if not c1 or not c2:
    return None

  r1, g1, b1 = (int(c1[i:i+2], 16) for i in (0, 2, 4))
  r2, g2, b2 = (int(c2[i:i+2], 16) for i in (0, 2, 4))

  return math.sqrt((r1 - r2) ** 2 + (g1 - g2) ** 2 + (b1 - b2) ** 2)

def _log_filament_mismatch(tray_data: dict, spool: dict) -> None:
  try:
    data_path = Path("data/filament_mismatch.json")
    data_path.parent.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.utcnow().isoformat() + "Z"
    
    with data_path.open("w", encoding="utf-8") as f:
      json.dump({
        "timestamp": timestamp,
        "tray": tray_data,
        "spool": spool,
      }, f)
  except Exception:
    pass

def augmentTrayDataWithSpoolMan(spool_list, tray_data, tray_id):
  tray_data["matched"] = False
  tray_data["mismatch"] = False
  tray_data["issue"] = False
  tray_data["color_mismatch"] = False
  tray_data["color_mismatch_message"] = ""

  for spool in spool_list:
    if spool.get("extra") and spool["extra"].get("active_tray") and spool["extra"]["active_tray"] == json.dumps(tray_id):
      tray_data["name"] = spool["filament"]["name"]
      tray_data["vendor"] = spool["filament"]["vendor"]["name"]
      tray_data["spool_material"] = spool["filament"].get("material", "")
      tray_data["spool_sub_brand"] = (spool["filament"].get("extra", {}).get("type") or "").replace('"', '').strip()
      tray_data["remaining_weight"] = spool["remaining_weight"]


      if "last_used" in spool:
        try:
            dt = datetime.strptime(spool["last_used"], "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=ZoneInfo("UTC"))
        except ValueError:
            dt = datetime.strptime(spool["last_used"], "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=ZoneInfo("UTC"))

        local_time = dt.astimezone()
        tray_data["last_used"] = local_time.strftime("%d.%m.%Y %H:%M:%S")
      else:
          tray_data["last_used"] = "-"

      if "multi_color_hexes" in spool["filament"]:
        tray_data["spool_color"] = spool["filament"]["multi_color_hexes"]
        tray_data["spool_color_orientation"] = spool["filament"].get("multi_color_direction")
      else:
        tray_data["spool_color"] = normalize_color_hex(spool["filament"].get("color_hex") or "")
        tray_data.pop('spool_color_orientation', None)

      # --- Mismatch detection ---
      def _clean_basic(val: str) -> str:
        # Normalization for matching:
        # - drop anything in parentheses (e.g., "(Recycled)")
        # - drop the word "basic"
        # - replace dashes with spaces
        # - collapse whitespace
        val = re.sub(r"\([^)]*\)", "", val)
        return re.sub(r"\s+", " ", re.sub(r"\bbasic\b", "", val.replace("-", " ")).strip())

      # Normalize tray main type and keep a clean lower-case version for comparison.
      tray_material = (tray_data.get("tray_type") or "").replace('"', '').strip()
      tray_material_norm = tray_material.lower()
      tray_material_main = re.split(r"[\s-]+", tray_material_norm)[0] if tray_material_norm else ""
      tray_material_has_variant = bool(re.search(r"[\s-]", tray_material_norm))

      # Extract tray sub-brand: remove main type and "Basic", keep the remaining variant (e.g., "CF").
      tray_sub_brands_raw = (tray_data.get("tray_sub_brands") or "").replace('"', '').strip()
      tray_sub_full_cmp = _clean_basic(tray_sub_brands_raw.lower())
      tray_sub_norm = tray_sub_brands_raw.lower().replace("basic", "").strip()
      if tray_material_main and tray_sub_norm.startswith(tray_material_main):
        tray_sub_norm = tray_sub_norm[len(tray_material_main):].strip()

      # Split spool material into main and sub-parts.
      # Examples:
      #   "PLA CF"     -> parts=["pla","cf"], main="pla", sub="cf", sub_display="CF"
      #   "PLA-S"      -> parts=["pla","s"],  main="pla", sub="s",  sub_display="S"
      #   "PETG"       -> parts=["petg"],     main="petg", sub="",  sub_display=""
      #   (only sub removes 'basic': "PLA Basic" -> main="pla", sub="basic" -> sub="" after cleanup)
      spool_material_raw = (spool["filament"].get("material") or "").replace('"', '').strip()
      spool_material_parts = [p for p in re.split(r"[\s-]+", spool_material_raw.lower()) if p]
      spool_material_parts_display = [p for p in re.split(r"[\s-]+", spool_material_raw) if p]
      spool_material_sub = " ".join(spool_material_parts[1:]) if len(spool_material_parts) > 1 else ""
      spool_material_sub = spool_material_sub.replace("basic", "").strip()
      spool_material_sub_display = " ".join(spool_material_parts_display[1:]) if len(spool_material_parts_display) > 1 else ""
      spool_material_full_norm = spool_material_raw.lower().strip()

      # Prefer explicit extra.type unless it is empty/"-" /"basic"; otherwise fall back to material sub-part.
      spool_type_raw = (spool["filament"].get("extra", {}).get("type") or "").replace('"', '').strip()
      spool_type_norm = spool_type_raw.lower()
      if spool_type_norm in ("", "-"):
        spool_type_norm = ""

      spool_sub_display = spool_type_raw if spool_type_norm else spool_material_sub_display

      spool_material_full_norm_cmp = _clean_basic(spool_material_full_norm)
      spool_type_norm_cmp = _clean_basic(spool_type_norm) if spool_type_norm else ""

      tray_material_norm_cmp = _clean_basic(tray_material_norm)

      # Matching rules:
      # 1) tray_sub_brands empty: spool_material == tray_type
      # 2) tray_sub_brands present: spool_material == tray_sub_brands
      # 3) tray_sub_brands present: spool_material + spool_type == tray_sub_brands
      base_match = bool(not tray_sub_full_cmp and tray_material_norm_cmp and spool_material_full_norm_cmp == tray_material_norm_cmp)
      sub_match = False
      if tray_sub_full_cmp:
        if tray_sub_full_cmp == spool_material_full_norm_cmp and not spool_type_norm_cmp:
          sub_match = True
        if not sub_match and spool_type_norm_cmp and tray_sub_full_cmp == f"{spool_material_full_norm_cmp} {spool_type_norm_cmp}".strip():
          sub_match = True

      variant_ok = False
      if tray_material_has_variant:
        if tray_material_norm_cmp and tray_material_norm_cmp == spool_material_full_norm_cmp:
          variant_ok = True
        if tray_sub_full_cmp:
          if tray_sub_full_cmp == spool_material_full_norm_cmp and not spool_type_norm_cmp:
            variant_ok = True
          if spool_type_norm_cmp and tray_sub_full_cmp == f"{spool_material_full_norm_cmp} {spool_type_norm_cmp}".strip():
            variant_ok = True
      mismatch_detected = not (base_match or sub_match or variant_ok)

      tray_data["tray_sub_brand"] = tray_sub_brands_raw.replace(tray_material, '').replace("Basic", "").strip()
      tray_data["spool_sub_brand"] = spool_sub_display.replace("Basic", "").strip()

      # Always log detected mismatches; optionally hide the warning in the UI via config flag.
      tray_data["mismatch_detected"] = mismatch_detected
      tray_data["mismatch"] = mismatch_detected and not DISABLE_MISMATCH_WARNING
      tray_data["issue"] = tray_data["mismatch"]
      if mismatch_detected:
        _log_filament_mismatch(tray_data, spool)
      tray_data["matched"] = True

      if "multi_color_hexes" not in spool["filament"]:
        color_difference = color_distance(tray_data.get("tray_color"), tray_data["spool_color"] )
        if  color_difference is not None and color_difference > COLOR_DISTANCE_TOLERANCE:
          tray_data["color_mismatch"] = True
          tray_data["color_mismatch_message"] = "Colors are not similar."

      break

  if tray_data.get("tray_type") and tray_data["tray_type"] != "" and tray_data["matched"] == False:
    tray_data["issue"] = True

def spendFilaments(printdata):
  if printdata["ams_mapping"]:
    ams_mapping = printdata["ams_mapping"]
  else:
    ams_mapping = [EXTERNAL_SPOOL_ID]

  """
  "ams_mapping": [
            1,
            0,
            -1,
            -1,
            -1,
            1,
            0
        ],
  """
  tray_id = EXTERNAL_SPOOL_ID
  ams_id = EXTERNAL_SPOOL_AMS_ID
  
  ams_usage = []
  for filamentId, filament in printdata["filaments"].items():
    if ams_mapping[0] != EXTERNAL_SPOOL_ID:
      tray_id = ams_mapping[filamentId - 1]   # get tray_id from ams_mapping for filament
      ams_id = getAMSFromTray(tray_id)        # caclulate ams_id from tray_id
      tray_id = tray_id - ams_id * 4          # correct tray_id for ams
    
    #if ams_usage.get(trayUid(ams_id, tray_id)):
    #    ams_usage[trayUid(ams_id, tray_id)]["usedGrams"] += float(filament["used_g"])
    #else:
    ams_usage.append({"trayUid": trayUid(ams_id, tray_id), "id": filamentId, "usedGrams":float(filament["used_g"])})

  for spool in fetchSpools():
    #TODO: What if there is a mismatch between AMS and SpoolMan?
                 
    if spool.get("extra") and spool.get("extra").get("active_tray"):
      #filament = ams_usage.get()
      active_tray = json.loads(spool.get("extra").get("active_tray"))

      # iterate over all ams_trays and set spool in print history, at the same time sum the usage for the tray and consume it from the spool
      used_grams = 0
      for ams_tray in ams_usage:
        if active_tray == ams_tray["trayUid"]:
          used_grams += ams_tray["usedGrams"]
          update_filament_spool(printdata["print_id"], ams_tray["id"], spool["id"])
        
      if used_grams != 0:
        consumeSpool(spool["id"], used_grams)
        

def setActiveTray(spool_id, spool_extra, ams_id, tray_id):
  if spool_extra == None:
    spool_extra = {}

  if not spool_extra.get("active_tray") or json.loads(spool_extra.get("active_tray")) != trayUid(ams_id, tray_id):
    patchExtraTags(spool_id, spool_extra, {
      "active_tray": json.dumps(trayUid(ams_id, tray_id)),
    })

    # Remove active tray from inactive spools
    for old_spool in fetchSpools(cached=True):
      if spool_id != old_spool["id"] and old_spool.get("extra") and old_spool["extra"].get("active_tray") and json.loads(old_spool["extra"]["active_tray"]) == trayUid(ams_id, tray_id):
        patchExtraTags(old_spool["id"], old_spool["extra"], {"active_tray": json.dumps("")})
  else:
    print("Skipping set active tray")

# Fetch spools from spoolman
def fetchSpools(cached=False):
  global SPOOLS
  if not cached or not SPOOLS:
    SPOOLS = fetchSpoolList()
    
    for spool in SPOOLS:
      initial_weight = 0

      if "initial_weight" in spool and spool["initial_weight"] > 0 :
        initial_weight = spool["initial_weight"]
      elif "weight" in spool["filament"] and spool["filament"]["weight"] > 0:
        initial_weight = spool["filament"]["weight"]

      price = 0
      if "price" in spool and spool["price"] > 0:
        price = spool["price"]
      elif "price" in spool["filament"] and spool["filament"]["price"] > 0:
        price = spool["filament"]["price"]

      if initial_weight > 0 and price > 0:
        spool["cost_per_gram"] = price / initial_weight
      else:
        spool["cost_per_gram"] = 0

      if "multi_color_hexes" in spool["filament"]:
        spool["filament"]["multi_color_hexes"] = spool["filament"]["multi_color_hexes"].split(',')
        
  return SPOOLS

def getSettings(cached=False):
  global SPOOLMAN_SETTINGS
  if not cached or not SPOOLMAN_SETTINGS:
    SPOOLMAN_SETTINGS = fetchSettings()
    SPOOLMAN_SETTINGS['currency_symbol'] = get_currency_symbol(SPOOLMAN_SETTINGS["currency"])

  return SPOOLMAN_SETTINGS
