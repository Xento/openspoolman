# <img alt="logo" src="static/logo.png" height="36" /> OpenSpoolMan

Use any filament like Bambu filaments with automatic recognition and filament usage updates in your AMS — no cloud connection required.

![Desktop home view](docs/img/desktop_home.PNG)

## Inhalt
- [Überblick](#überblick)
- [Setup & Deployment](#setup--deployment)
- [SpoolMan-Felder](#spoolman-felder)
- [Funktions-Überblick mit Popovers](#funktions-%C3%9Cberblick-mit-popovers)
- [AUTO SPEND](#auto-spend)
- [Demo & Screenshots](#demo--screenshots)
- [Kompatibilität](#kompatibilit%C3%A4t)
- [Release Notes](#release-notes)
- [License](#license)

## Überblick
- NFC-Unterstützung ist **optional** – die App funktioniert auch ohne NFC-Smartphone.
- Bambu-Cloud-Konten sind nicht nötig und werden nicht hinterlegt. Erforderlich sind nur **Seriennummer** und **Access Code** des Druckers.
- Spools lassen sich automatisch erkennen, sortieren (`SPOOL_SORTING`) und nach einem Druck manuell zuordnen, falls keine automatische Erkennung möglich war.

## Setup & Deployment
Richte die Umgebung ein und starte den Container – alles in einem Durchgang.

### Voraussetzungen
- Erreichbare **SpoolMan**-Instanz (`/api/v1`-Endpoint).
- Bambu Lab Drucker mit **Seriennummer**, **Access Code**, **lokaler IP** und einem Anzeigenamen.
- Öffentliche Basis-URL, unter der OpenSpoolMan erreichbar sein soll (`OPENSPOOLMAN_BASE_URL`).

### Konfiguration vorbereiten
1. `cp config.env.template config.env`
2. Fülle die wichtigsten Variablen in `config.env` aus:
   - `OPENSPOOLMAN_BASE_URL` – öffentlicher Basis-Pfad der App.
   - `PRINTER_ID`, `PRINTER_ACCESS_CODE`, `PRINTER_IP`, `PRINTER_NAME` – Druckerkennung ohne Cloud-Login.
   - `SPOOLMAN_BASE_URL` – Basis-URL Deiner SpoolMan-Instanz.
3. Optional anpassen:
   - `AUTO_SPEND=True` für exakte Restgewichte aus Druckertelemetrie.
   - `SPOOL_SORTING` für eigene Sortierreihenfolge (Standard: `filament.material:asc,filament.vendor.name:asc,filament.name:asc`).
   - `TZ` für korrekte Zeitzonenstempel.

### Docker-Start
1. Starte den Container (nutzt `config.env` automatisch):
   ```bash
   docker compose -f compose.yaml up -d
   ```
2. Öffne die UI unter `http://localhost:8000` (oder dem gemappten Host/Port).
3. Prüfe die Verbindung über `http://localhost:8000/health` – sowohl SpoolMan als auch der Drucker müssen **OK** melden.

> Tipp: `docker-compose.yaml` mountet `logs/`, `data/` und `prints/` für persistente Daten. Passe Ports oder Volumes bei Bedarf an.

### Entwicklung direkt aus dem Quellcode
```bash
pip install -r requirements.txt
python app.py
```
Verwende dieselbe `config.env`, um die Umgebung auch lokal bereitzustellen.

## SpoolMan-Felder
Diese Felder solltest Du beim Anlegen einer Spule pflegen, damit OpenSpoolMan sie sauber zuordnen und schreiben kann:

| SpoolMan-Feld | Beispiel | Verwendung in OpenSpoolMan |
| --- | --- | --- |
| **Filament → Name** | Bambu PLA Matte Grau | Beschriftet Buttons und Tray-Auswahl. |
| **Filament → Material** | PLA | Filtert und sortiert (abhängig von `SPOOL_SORTING`). |
| **Filament → Vendor/Marke** | Bambu Lab | Wird in Listen und Tag-Infos angezeigt. |
| **Filament → Nozzle Temperature** | 210 | In Tag-Writes für Bambu kompatible Daten genutzt. |
| **Filament → Filament ID** | BBL-PLA-GRAY | Eindeutiger Identifikator, der auf NFC/AMS geschrieben wird. |
| **Spool → Tags** | `bambu`, `ams` | Kennzeichnet Spulen für AMS/NFC-Flows. |
| **Spool → Aktiver Tray** | AMS 1 / Slot A | Verknüpft Spulen mit Slots für automatische Auswahl. |
| **Spool → Gewichte** | Leer- & Vollgewicht | Basis für Restmengen, wenn `AUTO_SPEND` deaktiviert ist. |

## Funktions-Überblick mit Popovers
Die Startseitenansicht ist oben sichtbar. Weitere Screenshots kannst Du direkt hier aufklappen, ohne die Seite zu verlassen.

<details>
  <summary>Desktop: Tray füllen und Druckhistorie</summary>

  ![Fill tray modal](docs/img/desktop_fill_tray.PNG)
  
  ![Desktop print history](docs/img/desktop_print_history.PNG)
</details>

<details>
  <summary>Mobile: Dashboard, NFC und Tray-Wechsel</summary>

  ![Mobile home](docs/img/mobile_home.PNG)
  
  ![Mobile NFC assignment](docs/img/mobile_assign_nfc.jpeg)
  
  ![NFC write success](docs/img/nfc_write_success.jpeg)
  
  ![Mobile change spool](docs/img/mobile_change_spool.PNG)
</details>

<details>
  <summary>Spulendetails, Tracking & Slicer-Schätzungen</summary>

  ![Desktop spool details](docs/img/desktop_spool_info.jpeg)
  
  ![Mobile spool details](docs/img/mobile_spool_info.jpeg)
  
  ![Bambu tracking](docs/img/bambu_tracking.jpg)
  
  ![Slicer estimate](docs/img/slicer_estimate.jpg)
</details>

<details>
  <summary>Workflow-Helfer</summary>

  ![Resolve issues](docs/img/resolve_issues.jpeg)
  
  ![Pick tray](docs/img/pick_tray.jpeg)
  
  ![Open in SpoolMan](docs/img/open_link.jpeg)
</details>

## AUTO SPEND
- `AUTO_SPEND=True` ersetzt Prozentanzeigen durch exakte Restgewichte aus der Druckertelemetrie.
- Deaktiviere die Option, wenn der Drucker nur lesend erreichbar ist oder Telemetrie unzuverlässig ist.
- Kombiniere sie mit `SPOOL_SORTING`, um passende Spulen oben anzuzeigen.

## Demo & Screenshots
- Mit Seed-Daten starten: `OPENSPOOLMAN_TEST_DATA=1 python app.py`
- Screenshots automatisch erzeugen: `python scripts/generate_screenshots.py --mode seed --port 5001`
- Playwright-Browser falls nötig installieren: `playwright install`

## Kompatibilität
- Funktioniert lokal ohne Bambu-Cloud; Zugriff zum Drucker erfolgt direkt per IP, Seriennummer und Access Code.
- NFC-Workflows erfordern HTTPS auf der Server-URL, sind aber optional.
- Bambu Studio **2.x** wird unterstützt.

## Release Notes
- 0.1.9 — 25.05.2025 — <https://github.com/drndos/openspoolman/releases/tag/v0.1.9>
- 0.1.8 — 20.04.2025 — <https://github.com/drndos/openspoolman/releases/tag/v0.1.8>
- 0.1.7 — 17.04.2025 — <https://github.com/drndos/openspoolman/releases/tag/v0.1.7>
- 0.1.4 — 09.02.2025 — Bug fixes
- 0.1.3 — 22.12.2024 — Added manual assignment for empty slots

## License
[Apache 2.0](LICENSE.txt)
