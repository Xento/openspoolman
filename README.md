# <img alt="logo" src="static/logo.png" height="36" /> OpenSpoolMan

Use any filament like Bambu filaments with automatic recognition and filament usage updates in your AMS — no cloud connection required.

![Desktop home view](docs/img/desktop_home.PNG)

## Quick links
- [Documentation home](https://drndos.github.io/openspoolman/)
- [Feature tour & screenshots](https://drndos.github.io/openspoolman/features.html)
- [Setup guide](https://drndos.github.io/openspoolman/setup.html)
- [Deployment options](https://drndos.github.io/openspoolman/deployment.html)
- [Seeded demo & screenshot generation](https://drndos.github.io/openspoolman/demo-and-screenshots.html)
- [AUTO SPEND notes](https://drndos.github.io/openspoolman/auto-spend.html)

Full documentation is published via GitHub Pages (see the links above or the repository’s **Pages** site).

### Documentation via GitHub Pages
- Documentation lives in the `docs/` folder and is served by GitHub Pages.
- Edit or add Markdown files under `docs/` and submit a pull request; Pages will update automatically after merge once the repo’s Pages settings point to `/docs` on the default branch.
- For details on configuring or mirroring the site, see `docs/pages-maintenance.md`.

## Highlights
- NFC-driven workflow to identify, assign, and load spools directly from your phone.
- Automatic usage tracking, including Bambu filaments without extra tags.
- Works locally with your SpoolMan instance and Bambu Lab printers.
- Web app optimized for both desktop and mobile devices.
- Customizable spool sorting for tray views and searches (via `SPOOL_SORTING`).
- Fallback spool assignment after prints when automatic detection fails.

## Compatibility
- Requires a server that can reach both SpoolMan and your Bambu Lab printer.
- NFC features require HTTPS on the server URL and a phone with NFC support.
- SpoolMan fields for filament type, nozzle temperature, filament ID, spool tags, and active trays are expected (see the [setup guide](https://drndos.github.io/openspoolman/setup.html) for details).

## Release notes
- 0.1.9 — 25.05.2025 — <https://github.com/drndos/openspoolman/releases/tag/v0.1.9>
- 0.1.8 — 20.04.2025 — <https://github.com/drndos/openspoolman/releases/tag/v0.1.8>
- 0.1.7 — 17.04.2025 — <https://github.com/drndos/openspoolman/releases/tag/v0.1.7>
- 0.1.4 — 09.02.2025 — Bug fixes
- 0.1.3 — 22.12.2024 — Added manual assignment for empty slots

## License
[Apache 2.0](LICENSE.txt)
