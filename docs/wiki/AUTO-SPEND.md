# AUTO SPEND

Automatic filament usage updates based on slicer estimates.

## How it works
When enabled (`AUTO_SPEND=True`), OpenSpoolMan reads slicer estimates for filament weight usage and updates the associated spool in SpoolMan. Future updates will correlate usage with printer progress to refine estimates.

## Current limitations
- Spending occurs at the start of the print.
- Spends the full filament weight even if the print fails.
- LAN-only mode may not work because the 3MF file is downloaded from the cloud.
- Not tested with multiple AMS systems.
- Does not handle mismatches between SpoolMan and AMS (if Active Tray information is wrong, results will be incorrect).

## Recommendations
- Keep AUTO SPEND disabled until you verify it fits your workflow.
- Ensure Active Tray information is accurate in SpoolMan before enabling.
- Monitor the first few prints to confirm spending aligns with expectations.
