import os

os.environ.setdefault("OPENSPOOLMAN_TEST_DATA", "1")
os.environ.setdefault("PRINTER_ID", "PRINTER_1")

import json

from app import app


def client():
  return app.test_client()


def test_get_printers_ok():
  resp = client().get("/api/printers")
  assert resp.status_code == 200
  payload = resp.get_json()
  assert payload["success"] is True
  assert payload["data"][0]["id"] == "PRINTER_1"


def test_get_ams_slots_ok():
  resp = client().get("/api/printers/PRINTER_1/ams")
  assert resp.status_code == 200
  payload = resp.get_json()
  assert payload["success"] is True
  assert "ams_slots" in payload["data"]
  assert len(payload["data"]["ams_slots"]) > 0


def test_spools_list_ok():
  resp = client().get("/api/spools")
  assert resp.status_code == 200
  payload = resp.get_json()
  assert payload["success"] is True
  assert isinstance(payload["data"], list)
  assert len(payload["data"]) > 0


def test_assign_and_unassign_roundtrip():
  c = client()

  spools = c.get("/api/spools").get_json()["data"]
  spool_id = spools[0]["id"]

  assign_resp = c.post(
      "/api/printers/PRINTER_1/ams/1/assign",
      data=json.dumps({"spool_id": spool_id, "ams_id": 0}),
      content_type="application/json",
  )
  assert assign_resp.status_code == 200
  assert assign_resp.get_json()["success"] is True

  unassign_resp = c.post(
      "/api/printers/PRINTER_1/ams/1/unassign",
      data=json.dumps({"spool_id": spool_id}),
      content_type="application/json",
  )
  assert unassign_resp.status_code == 200
  assert unassign_resp.get_json()["success"] is True
