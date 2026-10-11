# Bill of Materials

All hardware is M3 metric. Quantities are for one case (one board).

## Fasteners and standoffs

| Qty | Item | Spec | Notes |
|---|---|---|---|
| 4 | Brass hex column (standoff), double-female | M3, ~22mm length, hex across-flats 5mm | Sits in the deep hex recess in each pillar. The hex shape prevents rotation. |
| 4 | M3 screw, long | ~30mm | Inserted from below the base. Threads into the lower end of the brass column. Tightening pulls the column down against the recess floor and locks it against vertical lift. |
| 4 | M3 screw, medium | ~10-12mm | From the top, threads into the upper end of the brass column. Clamps the board down onto the pillar top. |
| 4 | M3 screw, short | ~10mm | Side screws through the cover skirt into the base bosses. |
| 4 | M3 nut (optional) | Standard | Only if your side screws go through the boss and need a nut on the far side. The base has 8mm bosses with a 4mm depth; a self-tapping option or threaded insert also works. |

## Tools

- 2.5mm drill bit (for cleaning up the M3 pilot holes if your printer oversizes them)
- 5mm hex key (for the brass columns, if they have a hex socket)
- 2.5mm Allen key (for M3 screws)

## Sourcing suggestions

- Brass M3 hex columns: any standard hardware supplier (McMaster-Carr, AliExpress, Amazon, etc.). Look for "M3 double female brass standoff 22mm hex".
- M3 screws: standard M3 stainless screws. Lengths above are approximate; measure your actual brass column length and pillar height to confirm.
- The hex recess in the pillar is sized for a 5mm across-flats hex column. If your column is a different size, adjust `hex_af` at the top of [`cad/Jetson_Orin_NX_Case.scad`](../cad/Jetson_Orin_NX_Case.scad) and re-render.

## Filament

- ~50-80g for the base (depending on infill)
- ~15-20g for the cover
- PLA works for desktop use; PETG or ABS recommended if the case will be in a warm enclosure or under load.
