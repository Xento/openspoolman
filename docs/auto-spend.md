# AUTO SPEND notes

`AUTO_SPEND` enables consumption tracking from printer telemetry so matched spools display precise remaining weights.

## How it works
- When `AUTO_SPEND=True`, matched spools show remaining grams based on printer feedback instead of percentage estimates.
- Unmatched trays continue to show percentage values until a spool is assigned.
- The feature relies on a healthy connection to your Bambu printer and SpoolMan API.

## Enabling
1. Set `AUTO_SPEND=True` in `config.env`.
2. Restart the application or redeploy the container.
3. Verify remaining weights update during prints; fall back to percentage views by setting `AUTO_SPEND=False`.

## Tips
- Pair AUTO SPEND with `SPOOL_SORTING` to keep the best candidates at the top of tray searches.
- If prints are running in read-only environments, disable AUTO SPEND to avoid stale or incomplete telemetry.
