# Assembly Guide

This guide walks through assembling the Jetson Orin NX Super case. The design uses a **pillar + brass hex column + bottom-anchor screw** mechanism so the board is locked vertically and laterally without any glue.

## Parts you need

See [bom.md](bom.md). In short:

- 1x printed `base`
- 1x printed `cover`
- 4x M3 brass hex columns (~22mm, 5mm across flats)
- 4x long M3 screws (~30mm, from below)
- 4x medium M3 screws (~10-12mm, from top, to clamp the board)
- 4x short M3 screws (~10mm, for the cover sides)
- 1x Jetson Orin NX Super board

## Step 1: Install the brass columns into the base

Each of the 4 pillars in the base has a deep hex recess (22mm) sized for a 5mm across-flats brass hex column.

1. Drop a brass hex column into each pillar's recess, hex-end down. The hex shape prevents it from rotating once seated.
2. The column should sit flush with the top of the slimmed pillar section. If it sits proud, the column is too long; if it sits deep, it's too short. Adjust by changing `hex_depth` in the SCAD and re-rendering if needed.

## Step 2: Lock the columns from below (the bottom anchor)

1. Flip the base over.
2. From the bottom of the base, insert a long M3 screw through the counterbore under each pillar. The screw head sits in the counterbore (flush with or slightly below the bottom of the base).
3. Thread the screw up into the lower end of the brass hex column.
4. Tighten. This pulls the brass column **down** against the recess floor and locks it against vertical lift. Do all 4.

At this point the brass columns are permanently locked into the base and cannot fall out or push up.

## Step 3: Mount the board

1. Orient the Jetson Orin NX Super board so the IO edge (USB / Ethernet / DC jack) aligns with the IO cutout on the +X side of the base.
2. Lower the board onto the 4 slimmed pillar tops. The 4 mounting holes in the board should land on the 4 brass column tops.
3. From the top, insert a medium M3 screw through each board mounting hole and thread it into the brass column.
4. Tighten gradually in an X pattern (1 -> 3 -> 2 -> 4) to seat the board evenly. The screw head clamps the board down onto the pillar top.

The board is now locked vertically (between the pillar top and the screw head) and laterally (by the 4 pillar tops).

## Step 4: Attach the cover

1. Place the cover over the base. The cover's skirt drops down around the outside of the base with a small fit clearance (`fit_clear = 0.2mm`).
2. Align the 4 side screw holes in the cover skirt with the 4 bosses on the base.
   - 2 bosses on the +Y wall (at X = 40 and X = 80)
   - 2 bosses on the -X wall (at Y = 40 and Y = 80)
3. Drive a short M3 screw through each cover-side hole into the base boss.
4. Tighten. The cover is now clamped to the base.

## Step 5: Mount to the Lekiwi

The front wall (-Y, the wall without the IO cutout) has an M3 grid of pilot holes at 20mm pitch. Use these to bolt the assembled case to the Lekiwi chassis with user-supplied M3 hardware that matches your Lekiwi's mounting pattern.

## Disassembly

- To remove the cover: unscrew the 4 side screws and lift.
- To remove the board: unscrew the 4 top screws and lift the board.
- To remove the brass columns: unscrew the 4 bottom anchor screws from below, then push the columns up out of the recess.

## Tips

- **Enable supports for the base.** The long horizontal bridge across the top of the IO fanout will sag / split like spaghetti without supports. Tree supports work well. The cover needs no supports.
- If the M3 pilot holes are too tight (printer-dependent), run a 2.5mm or 3mm drill bit through them by hand.
- If the cover skirt is too tight on the base, increase `fit_clear` in the SCAD and re-render.
- The IO cutout is sized for the reComputer Jetson Orin NX Super IO cluster. If you are using a different carrier board, adjust `io_w`, `io_h`, and `io_z0` in the SCAD.
