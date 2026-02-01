import os
import time
from dataclasses import dataclass
from typing import Any


class Features:
  SUPPORTS_EARLY_FTP_DOWNLOAD = "supports_early_ftp_download"


MODEL_CODE_TO_NAME = {
  # H2 series
  "093": "H2S",
  "094": "H2D",
  "239": "H2D Pro",
  "109": "H2C",
  # X1 series
  "00W": "X1",
  "00M": "X1 Carbon",
  "03W": "X1E",
  # P1 series
  "01S": "P1P",
  "01P": "P1S",
  # P2 series
  "22E": "P2S",
  # A1 series
  "039": "A1",
  "030": "A1 Mini",
}


MODEL_FEATURES = {
  "H2S": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "H2D": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "H2D Pro": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "H2C": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "X1": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "X1 Carbon": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "X1E": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "P1P": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "P1S": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "P2S": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "A1": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
  "A1 Mini": {Features.SUPPORTS_EARLY_FTP_DOWNLOAD},
}


PRINTING_GCODE_STATES = {"RUNNING", "PAUSE", "PAUSED"}
FINAL_GCODE_STATES = {
  "FINISH",
  "FAILED",
  "STOP",
  "STOPPED",
  "CANCEL",
  "CANCELLED",
  "CANCELED",
  "ABORT",
  "ABORTED",
  "ERROR",
  "IDLE",
}

PRINTING_STATUS_STATES = {"RUNNING", "PAUSE", "PAUSED"}
FINAL_STATUS_STATES = {
  "FINISH",
  "FAILED",
  "STOP",
  "STOPPED",
  "CANCEL",
  "CANCELLED",
  "CANCELED",
  "ABORT",
  "ABORTED",
  "ERROR",
  "IDLE",
}


def get_printer_model_name(printer_id: str | None) -> str:
  if not printer_id:
    return "Unknown"
  model_code = printer_id[:3]
  return MODEL_CODE_TO_NAME.get(model_code, f"Unknown model ({model_code})")


def get_print_block(payload: dict) -> dict:
  if not payload:
    return {}
  return payload.get("print") or {}


def extract_gcode_state(payload: dict) -> str | None:
  return get_print_block(payload).get("gcode_state")


def extract_print_status(payload: dict) -> str | None:
  return get_print_block(payload).get("print_status")


def extract_prepare_percent(payload: dict) -> int | None:
  return get_print_block(payload).get("gcode_file_prepare_percent")


def normalize_prepare_percent(value: Any) -> int | None:
  if value is None:
    return None
  if isinstance(value, str):
    if not value.strip():
      return None
  try:
    numeric = float(value)
  except (TypeError, ValueError):
    return None
  percent = int(numeric)
  if percent < 0:
    percent = 0
  if percent > 100:
    percent = 100
  return percent


def is_prepare_ready_for_early_download(p_norm: int | None) -> bool:
  if p_norm is None:
    return False
  return p_norm >= 99


def is_print_active(gcode_state: str | None, print_status: str | None) -> bool:
  if gcode_state and gcode_state.upper() in PRINTING_GCODE_STATES:
    return True
  if print_status and print_status.upper() in PRINTING_STATUS_STATES:
    return True
  return False


def is_print_final(gcode_state: str | None, print_status: str | None) -> bool:
  if gcode_state and gcode_state.upper() in FINAL_GCODE_STATES:
    return True
  if print_status and print_status.upper() in FINAL_STATUS_STATES:
    return True
  return False


def get_job_label(payload: dict) -> str | None:
  block = get_print_block(payload)
  url = block.get("url")
  if isinstance(url, str) and url.strip():
    return url
  gcode_file = block.get("gcode_file")
  if isinstance(gcode_file, str) and gcode_file.strip():
    return gcode_file
  return None


@dataclass
class PrintRun:
  job_label: str | None
  started_at: float
  last_payload: dict | None = None
  early_download_started: bool = False


class PrintRunRegistry:
  def __init__(self) -> None:
    self._active_runs: dict[str, PrintRun] = {}
    self._pending_early: dict[str, str] = {}

  def get_active_run(self, printer_id: str) -> PrintRun | None:
    return self._active_runs.get(printer_id)

  def can_start_new_run(self, printer_id: str) -> bool:
    return self._active_runs.get(printer_id) is None

  def start_run(self, printer_id: str, job_label: str | None, payload: dict | None) -> PrintRun:
    run = PrintRun(job_label=job_label, started_at=time.time(), last_payload=payload)
    pending_label = self._pending_early.get(printer_id)
    if pending_label and pending_label == job_label:
      run.early_download_started = True
      self._pending_early.pop(printer_id, None)
    self._active_runs[printer_id] = run
    return run

  def update_run(self, printer_id: str, payload: dict | None) -> None:
    run = self._active_runs.get(printer_id)
    if run:
      run.last_payload = payload

  def finalize_run(self, printer_id: str, payload: dict | None) -> None:
    run = self._active_runs.get(printer_id)
    if run:
      run.last_payload = payload
    self._active_runs.pop(printer_id, None)
    pending_label = self._pending_early.get(printer_id)
    if run and pending_label and pending_label == run.job_label:
      self._pending_early.pop(printer_id, None)

  def mark_early_download_started(self, printer_id: str, job_label: str | None) -> bool:
    if not job_label:
      return False
    run = self._active_runs.get(printer_id)
    if run and run.job_label == job_label:
      if run.early_download_started:
        return False
      run.early_download_started = True
      return True
    existing = self._pending_early.get(printer_id)
    if existing == job_label:
      return False
    self._pending_early[printer_id] = job_label
    return True

  def reset(self) -> None:
    self._active_runs.clear()
    self._pending_early.clear()


PRINT_RUN_REGISTRY = PrintRunRegistry()
