# <img alt="logo" src="static/logo.png" height="36" /> OpenSpoolMan 
Use any filament like Bambu filaments with automatic recognition and filament usage updates in your AMS!

No need for cloud or any special hardware, just your phone and some NFC tags!

Similar functionality to https://github.com/spuder/OpenSpool using only your phone, server and NFC tags integrated with SpoolMan

Everything works locally without cloud access, you can use scripts/init_bambulab.py script to access your PRINTER_ID and PRINTER_CODE if it is not available on your printer.

Docker: https://ghcr.io/drndos/openspoolman

### News
- 0.1.3 - 22.12.2024 - Added manual assignment for empty slots
- 0.1.4 - 09.02.2025 - Bugfixes, issue fixing WIP
- 0.1.7 - 17.04.2025 - https://github.com/drndos/openspoolman/releases/tag/v0.1.7
- 0.1.8 - 20.04.2025 - https://github.com/drndos/openspoolman/releases/tag/v0.1.8

### Main features

<table>
    <tbody>
        <tr>
            <td><b>Information about your AMS</b></td>
            <td><b>Fill tray directly from overview</b></td>
            <td><b>Print history</b></td>
        </tr>
        <tr>
            <td><img alt="Information about your AMS" src="docs/img/info.PNG" width="250"/></td>
            <td><img alt="Fill tray directly from overview" src="docs/img/fill_tray.PNG" width="250"/></td>
            <td><img alt="Print history" src="docs/img/print_history.PNG" width="250"/></td>
        <tr>
            <td><b>Assign NFC tags to your spools in SpoolMan</b></td>
            <td><b>Write the URL of the Spool detail to NFC tag directly from the browser</b></td>
            <td></td>
        </tr>
            <td><img alt="Assign NFC tags to your spools in SpoolMan" src="docs/img/assign_nfc.jpeg" width="250"/></td>
            <td><img alt="NFC write success" src="docs/img/nfc_write_success.jpeg" width="250"/></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="2"><b>Bring Phone close to the NFC tag and open the spool detail</b></td>
            <td><b>Pick the AMS slot where you want the spool to be loaded</b></td>
        </tr>
        <tr>
            <td><img alt="Open NFC link" src="docs/img/open_link.jpeg" width="250"/></td>
            <td><img alt="Spool info" src="docs/img/spool_info.jpeg" width="250"/></td>
            <td><img alt="Pick tray" src="docs/img/pick_tray.jpeg" width="250"/></td>
        </tr>
        <tr>
            <td><b>Automatically track the usage of your filaments based on the slicer estimates in SpoolMan</b></td>
            <td><b>Track Bambu filaments without additional NFC Tags</b></td>
            <td><b>Resolve issues with few clicks (soon)</b></td>
        </tr>
        <tr>
            <td><img alt="Slicer estimate" src="docs/img/slicer_estimate.jpg" width="250"/></td>
            <td><img alt="Bambu filament usgae tracking" src="docs/img/bambu_tracking.jpg" width="250"/></td>
            <td><img alt="Resolve issues" src="docs/img/resolve_issues.jpeg" width="250"/></td>
        </tr>
    </tbody>
</table>

### Seeded demo & screenshots
- Set `OPENSPOOLMAN_TEST_DATA=1` to load a reproducible dummy dataset for the overview, tray fill, print history, and NFC flows via runtime monkeypatching (no alternate imports needed).
- Install the app dependencies (including Playwright with `greenlet==1.1.2`) via `pip install -r requirements.txt`.
- Install the Chromium browser once via `make playwright-install` (or `python -m playwright install chromium`).
- Run `make screenshots` (or `python scripts/generate_screenshots.py`) to start the app in test mode, open the key routes (`/`, `/fill`, `/print_history`, `/spool_info?spool_id=1`, `/write_tag`) in headless Chromium, and refresh the images under `docs/img/`.
- To generate pictures from real printer/Spoolman data, either point the generator at your running instance (`python scripts/generate_screenshots.py --mode live --base-url http://<host>:<port>`) or snapshot a live session once with `python scripts/export_live_snapshot.py --output data/live_snapshot.json` and then reuse it via `OPENSPOOLMAN_TEST_DATA=1 OPENSPOOLMAN_TEST_SNAPSHOT=data/live_snapshot.json make screenshots`. When talking to live services, set `OPENSPOOLMAN_LIVE_READONLY=1` to block actions that would change your printer or Spoolman data (the screenshot generator enforces this by default unless you pass `--allow-live-actions`). When live data is used or captured, the app and scripts automatically load `config.env` from the repository root (if present) so credentials and URLs are available even when running tools from subfolders.
- The script can be called in CI after UI changes to automatically regenerate and version the example screenshots.
- For unit tests, you can reuse the same seeded dataset without environment variables: add `--use-seeded-data` to your pytest command for auto-mocking, request the `seeded_data_overrides` fixture in a test, or wrap your test body in `with test_data.apply_test_overrides(): ...`.
- To generate documentation screenshots inside pytest, run `pytest -m screenshots --generate-screenshots` (optionally pass `--screenshot-output <dir>` or `--screenshot-mode live`); the test will spin up Flask in seeded mode by default and reuse the same capture logic as `scripts/generate_screenshots.py`.

### What you need:
 - Android Phone with Chrome web browser or iPhone (manual process much more complicated if using NFC Tags)
 - Server to run OpenSpoolMan with https (optional when not using NFC Tags) that is reachable from your Phone and can reach both SpoolMan and Bambu Lab printer on the network
 - Active Bambu Lab Account or PRINTER_ID and PRINTER_CODE on your printer
 - Bambu Lab printer https://eu.store.bambulab.com/collections/3d-printer
 - SpoolMan installed https://github.com/Donkie/Spoolman
 - NFC Tags (optional) https://eu.store.bambulab.com/en-sk/collections/nfc/products/nfc-tag-with-adhesive https://www.aliexpress.com/item/1005006332360160.html

### How to setup:
 - Rename config.env.template to config.env or set environment properies and: 
   - set OPENSPOOLMAN_BASE_URL - that is the URL where OpenSpoolMan will be available on your network. Must be https for NFC write to work. without trailing slash
   - set PRINTER_ID - On your printer clicking on Setting -> Device -> Printer SN
   - set PRINTER_ACCESS_CODE - On your printer clicking on Setting -> Lan Only Mode -> Access Code (you _don't_ need to enable the LAN Only Mode)
   - set PRINTER_IP - On your printer clicking on Setting -> Lan Only Mode -> IP Address (you _don't_ need to enable the LAN Only Mode)
   - set SPOOLMAN_BASE_URL - according to your SpoolMan installation without trailing slash
   - set AUTO_SPEND - to True if you want for system to track your filament spending (check AUTO_SPEND issues below) default to False
 - Run the server (wsgi.py)
 - Run Spool Man
 - Add following extra Fields to your SpoolMan:
   - Filaments
     - "type","Type","Choice","Basic","Silk, Basic, High Speed, Matte, Plus, Flexible, Translucent","No"
     - "nozzle_temperature","Nozzle Temperature","Integer Range","°C","190 – 230"
	 - "filament_id","Filament ID", "Text"
   - Spools
     - "tag","tag","Text"
     - "active_tray","Active Tray","Text
 - Add your Manufacturers, Filaments and Spools to Spool Man (when adding filament you can try "Import from External" for faster workflow)
 - The filament id can be found in the json files in C:\Users\USERNAME\AppData\Roaming\BambuStudio\user\USERID\filament\base
   It is the same for each printer and nozzle.
 - Open the server base url in browser on your mobile phone
 - Optionally add Bambu Lab RFIDs to extra tag on your Bambu Spools so they will be matching. You can get the tag id from logs or from browser in AMS info.

 With NFC Tags:
 - For non Bambu Lab filaments click on the filament and click Write and hold empty NFC tag to your phone (allow NFC in popup if prompted)
 - Attach NFC tag to your filament
 - Load filament to your AMS by loading it and then putting your phone near NFC tag and allowing your phone to open the website
 - On the website pick the slot you put your filament in

 Without NFC Tags:
 - Click fill on the tray and select the desired spool
 - Done

### Deployment
Run locally in venv by configuring environment properties and running wsgi.py, supports adhoc ssl.

Run in docker by configuring config.env and running compose.yaml, you will need more setup/config to run ssl.

Run in kubernetes using helm chart, where you can configure the ingress with SSL. https://github.com/truecharts/public/blob/master/charts/library/common/values.yaml

### AUTO SPEND - Automatic filament usage based on slicer estimate
You can turn this feature on to automatically update the spool usage in SpoolMan. 
This feature is using slicer information about predicted filament weight usage (and in future correlating it with the progress of the printer to compute the estimate of filament used).

This feature has currently following issues/drawbacks:
 - Spending on the start of the print
 - Not spending according to print process and spending full filament weight even if print fails
 - Don't know if it works with LAN mode, since it downloads the 3MF file from cloud
 - Not tested with multiple AMS systems
 - Not handling the mismatch between the SpoolMan and AMS (if you don't have the Active Tray information correct in spoolman it won't work properly)

### Notes:
 - If you change the BASE_URL of this app, you will need to reconfigure all NFC TAGS

### TBD:
 - Filament remaining in AMS (I have only AMS lite, if you have AMS we can test together)
 - Filament spending based on printing
   - TODO: handle situation when the print doesn't finish
   - TODO: test with multiple AMS
 - Code cleanup
 - Video showcase
 - Docker compose SSL
 - Logs
 - TODOs
 - Click to resolve issue - WIP
 - Reduce the amount of files in docker container
 - Cloud service for controlled redirect so you don't have to reconfigure NFC tags
 - QR codes
 - Add search to list of spools
