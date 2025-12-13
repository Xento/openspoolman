# OpenSpoolman JSON API

Alle Endpoints liegen unter `/api` und geben folgendes Schema zurück:

```json
// Erfolg
{ "success": true, "data": { ... } }

// Fehler
{ "success": false, "error": { "code": "CODE", "message": "Details" } }
```

## Endpoints

### GET /api/printers
Liefert die bekannte Druckerinstanz.
```json
{
  "success": true,
  "data": [
    { "id": "PRINTER_ID", "name": "Friendly Name", "online": true, "last_seen": null }
  ]
}
```

### GET /api/printers/{printer_id}/ams
AMS-/Tray-Status für den Drucker.
```json
{
  "success": true,
  "data": {
    "printer_id": "PRINTER_ID",
    "ams_slots": [
      {
        "index": 1,
        "ams_id": 0,
        "spool_id": 123,
        "spool_name": "PLA White",
        "material": "PLA",
        "color": "FFFFFF",
        "active": true,
        "is_loaded": true
      }
    ]
  }
}
```

### GET /api/spools
Liste aller Spulen aus Spoolman.
```json
{
  "success": true,
  "data": [
    {
      "id": "123",
      "name": "PLA White",
      "material": "PLA",
      "color": "FFFFFF",
      "diameter_mm": 1.75,
      "weight_g": 1000,
      "remaining_g": 750,
      "tag": "RFID1234",
      "location": "Rack 1 / Bin 3"
    }
  ]
}
```

### POST /api/printers/{printer_id}/ams/{tray_index}/assign
Spule einem Tray zuweisen. Optional `ams_id` im Body mitgeben, wenn mehrere AMS existieren.

Request-Body:
```json
{ "spool_id": "123", "ams_id": 0 }
```

Antwort:
```json
{
  "success": true,
  "data": { "printer_id": "PRINTER_ID", "ams_id": 0, "tray_index": 1, "spool_id": "123" }
}
```

Fehlerbeispiele:
- 403 `READ_ONLY_MODE` wenn `OPENSPOOLMAN_LIVE_READONLY=1`
- 404 `PRINTER_NOT_FOUND` oder `TRAY_NOT_FOUND`
- 404 `SPOOL_NOT_FOUND`
- 503 `PRINTER_OFFLINE` wenn MQTT-Verbindung fehlt

### POST /api/printers/{printer_id}/ams/{tray_index}/unassign
Zuweisung einer Spule von einem Tray entfernen. Optional `spool_id` angeben, sonst wird die aktive Spule anhand `active_tray` gesucht.

Request-Body:
```json
{ "spool_id": "123" }
```

Antwort:
```json
{
  "success": true,
  "data": { "printer_id": "PRINTER_ID", "tray_index": 1, "spool_id": "123", "unassigned": true }
}
```

Fehlerbeispiele:
- 404 `SPOOL_NOT_FOUND` wenn keine Spule gefunden wurde
- 403 `READ_ONLY_MODE` wenn `OPENSPOOLMAN_LIVE_READONLY=1`
