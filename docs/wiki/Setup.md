# Setup guide

Configure OpenSpoolMan to work with SpoolMan and your Bambu Lab printer.

## Requirements
- Phone with NFC support (Android Chrome recommended; iPhone works with manual steps for tags)
- Server reachable from both SpoolMan and the printer
- Active Bambu Lab account or PRINTER_ID and PRINTER_CODE from the printer
- SpoolMan instance: <https://github.com/Donkie/Spoolman>
- Optional NFC tags: <https://eu.store.bambulab.com/en-sk/collections/nfc/products/nfc-tag-with-adhesive> or compatible tags

## Prepare configuration
1. Copy `config.env.template` to `config.env` (or set the environment variables directly).
2. Set the following values:
   - `OPENSPOOLMAN_BASE_URL` — public HTTPS URL without trailing slash (required for NFC write).
   - `PRINTER_ID` — Settings → Device → Printer SN.
   - `PRINTER_ACCESS_CODE` — Settings → Lan Only Mode → Access Code (LAN mode does **not** need to be enabled).
   - `PRINTER_IP` — Settings → Lan Only Mode → IP Address (LAN mode does **not** need to be enabled).
   - `SPOOLMAN_BASE_URL` — SpoolMan base URL without trailing slash.
   - `AUTO_SPEND` — `True` to enable automatic spending (see [AUTO SPEND notes](AUTO-SPEND.md)). Defaults to `False`.
   - `SPOOL_SORTING` — optional override for the spool list/tray sorting (comma-separated `field:asc|desc` pairs; defaults to `filament.material:asc,filament.vendor.name:asc,filament.name:asc`).
   - `TZ` — server timezone for correct timestamps (e.g., `Europe/Berlin`).

## SpoolMan field additions
Add the following custom fields to SpoolMan:

- **Filaments**
  - `type`, display name `Type`, type `Choice`, default `Basic`, options `Silk, Basic, High Speed, Matte, Plus, Flexible, Translucent`, required `No`
  - `nozzle_temperature`, display name `Nozzle Temperature`, type `Integer Range`, unit `°C`, range `190 – 230`
  - `filament_id`, display name `Filament ID`, type `Text`
- **Spools**
  - `tag`, display name `tag`, type `Text`
  - `active_tray`, display name `Active Tray`, type `Text`

Filament IDs can be found in `C:\Users\USERNAME\AppData\Roaming\BambuStudio\user\USERID\filament\base` (shared across printers and nozzles).

## Start the server
- Run the server via `wsgi.py` (or `app.py`) with your configured environment.
- Ensure SpoolMan is running and reachable.
- Open the base URL on your phone or desktop browser.

## NFC workflow
- With NFC tags: choose a filament in OpenSpoolMan, tap **Write**, hold the NFC tag to your phone, attach the tag to the spool, then load the filament and tap the tag again to pick an AMS slot.
- Without NFC tags: tap **Fill** on a tray and pick a spool directly.

## Tips
- Changing the base URL requires reconfiguring all existing NFC tags.
- Optional: attach Bambu Lab RFIDs to Bambu spools for automatic matching; tag IDs are visible in the logs and AMS info.
- Bambu Studio 2.x is supported as of release 0.1.9; upgrade if you encountered earlier compatibility issues.
