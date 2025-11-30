# Setup guide

Follow these steps to connect OpenSpoolMan to your Bambu Lab printer and SpoolMan instance.

## Prerequisites
- A reachable SpoolMan server (the app expects `/api/v1` endpoints).
- Printer details: serial number, access code, local IP, and a friendly printer name.
- Bambu Studio 2.x is supported; NFC-assisted flows continue to work with that release.

## Configure environment
1. Copy `config.env.template` to `config.env` in the repository root.
2. Fill in the printer and SpoolMan values:
   - `OPENSPOOLMAN_BASE_URL` – public base URL where this app will be served.
   - `PRINTER_ID`, `PRINTER_ACCESS_CODE`, `PRINTER_IP`, `PRINTER_NAME` – printer credentials and IP.
   - `SPOOLMAN_BASE_URL` – base URL for your SpoolMan instance.
3. Optional tuning:
   - `AUTO_SPEND` – set `True` to display precise remaining weights for matched spools using printer telemetry.
   - `SPOOL_SORTING` – customize spool sort order for tray selection and searches (default: `filament.material:asc,filament.vendor.name:asc,filament.name:asc`).
   - `TZ` – set your server timezone for correct timestamps.

## Initialize printer metadata
Run `python scripts/init_bambulab.py` once to validate the printer connection and populate credentials.

## Health check
Start the app locally (see deployment options) and hit `/health` to confirm connectivity to both SpoolMan and the printer before enabling NFC or AUTO SPEND in production.
