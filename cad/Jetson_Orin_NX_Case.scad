// ============================================
// Jetson Orin NX Case v11 — base + cover (vertical mount)
// Inner: 120(X) x 120(Y) x 75(Z) mm
// Board mounts flat on BOTTOM via 4 solid pillars.
//   Spacing hs = 102mm (was 105mm, tightened 3mm both axes).
//   Pillars shifted toward IO side (+X) by shift_x.
//   Each pillar: bottom full-width (12mm) + top 1.8cm slimmed (8mm)
//   to clear big components under the board, with a DEEP hex recess
//   (22mm) for a long M3 brass hex column (strength).
//   Board sits ON the pillar top and is CLAMPED by the M3 screw head
//   (screw threads into the hex column) -> locked vertically.
// ============================================

ix = 120;
iy = 120;
iz = 75;
wall = 2.5;
corner_r = 3;

// --- Mounting pillars ---
hs = 102;          // pillar centre-to-centre spacing (tightened 3mm)
pillar_w = 12;     // pillar BOTTOM cross-section (full width, square)
slim_w = 7.5;      // pillar TOP cross-section (round, slimmed to clear board components)
slim_h = 18;       // slimmed section height (top 1.8cm)
pillar_h = 30;     // pillar total height (3cm)
shift_x = 3;       // shift pillars toward IO side (+X)
hex_af = 5;      // hex recess across-flats (mm)
hex_depth = 22;    // hex recess depth (for a 2-2.5cm M3 hex column)`
hex_circ = hex_af / cos(30);
// --- Bottom anchor (locks brass column against vertical lift) ---
// Uses a DOUBLE-FEMALE brass hex column + a long M3 screw from below.
// Screw head sits in the counterbore under the floor; shank passes up
// through the pillar bottom and threads into the column's lower end.
// Tightening pulls the column DOWN against the recess floor -> locked.
bot_screw_d = 3.2;   // M3 shank clearance
bot_head_d  = 6.5;   // M3 head clearance
bot_head_h  = 3.0;   // M3 head height (counterbore depth)

function pcx(x) = ox/2 + x*hs/2 + shift_x;
function pcy(y) = oy/2 + y*hs/2;

// --- IO opening ---
io_w = 105;
io_h = 40;
board_z = 45;
io_z0 = board_z - io_h + wall;

// --- Lekiwi mounting M3 grid (FRONT wall Y=0) ---
m3_d = 3.2;
m3_pitch = 20;

// --- Cover skirt + side screws ---
skirt_t = 2.5;
skirt_h = 8;
fit_clear = 0.2;
// screw axis = center of the skirt (z=oz-skirt_h .. oz), fully enclosed
screw_z = iz + 2*wall - skirt_h/2;
screw_d = 3.2;
pilot_d = 2.5;
boss_depth = 4;
boss_w = 8;

// --- Footings (on the +Y "standing" side; protrude past the skirt so the
// case stands on the feet, not the skirt edge) ---
foot_s = 8;
foot_h = skirt_t + 0.5;   // protrude 0.5mm beyond the skirt outer

// --- Ventilation ---
vd = 4;
vp = 9;
slot_w = 90;
slot_h = 4;

ox = ix + 2*wall;
oy = iy + 2*wall;
oz = iz + 2*wall;

module rrect(w, d, r) {
    translate([r, r]) offset(r = r) square([w - 2*r, d - 2*r]);
}

// single mounting pillar (x,y in {-1,1} pick the corner)
module pillar(x, y) {
    cx = pcx(x);
    cy = pcy(y);
    difference() {
        union() {
            // bottom section (full width, strong)
            translate([cx - pillar_w/2, cy - pillar_w/2, wall])
                cube([pillar_w, pillar_w, pillar_h - slim_h]);
            // top section (round, slimmed -> clears components on the bottom of the board)
            translate([cx, cy, wall + pillar_h - slim_h])
                cylinder(d = slim_w, h = slim_h, $fn = 32);
        }
        // deep hex recess (subtracted hole for the long M3 hex column)
        translate([cx, cy, wall + pillar_h - hex_depth + 0.1])
            cylinder(d = hex_circ, h = hex_depth + 0.2, $fn = 6);
    }
}

module base() {
    difference() {
        union() {
            linear_extrude(wall) rrect(ox, oy, corner_r);
            difference() {
                linear_extrude(oz) rrect(ox, oy, corner_r);
                translate([wall, wall, -0.1])
                    linear_extrude(oz + 0.2) rrect(ox - 2*wall, oy - 2*wall, corner_r - wall);
            }
            for (x = [-1,1]) for (y = [-1,1]) pillar(x, y);
            // 4 screw bosses
            translate([40-boss_w/2, iy+wall-boss_depth, screw_z-boss_w/2]) cube([boss_w, boss_depth, boss_w]);
            translate([80-boss_w/2, iy+wall-boss_depth, screw_z-boss_w/2]) cube([boss_w, boss_depth, boss_w]);
            translate([wall, 40-boss_w/2, screw_z-boss_w/2]) cube([boss_depth, boss_w, boss_w]);
            translate([wall, 80-boss_w/2, screw_z-boss_w/2]) cube([boss_depth, boss_w, boss_w]);
            // 4 feet on the +Y standing side; top pair sits BELOW the skirt
            translate([5, oy, 5]) cube([foot_s, foot_h, foot_s]);
            translate([ox-5-foot_s, oy, 5]) cube([foot_s, foot_h, foot_s]);
            translate([5, oy, oz - skirt_h - foot_s - 1]) cube([foot_s, foot_h, foot_s]);
            translate([ox-5-foot_s, oy, oz - skirt_h - foot_s - 1]) cube([foot_s, foot_h, foot_s]);
        }
        // IO opening
        translate([ix + wall - 0.1, oy/2 - io_w/2, io_z0])
            cube([wall + 0.2, io_w, io_h]);
        // Lekiwi M3 grid (front wall)
        for (x = [10:m3_pitch:ox-10]) for (z = [10:m3_pitch:oz-10]) {
            translate([x, -0.1, z]) rotate([-90,0,0]) cylinder(d = m3_d, h = wall + 0.2, $fn = 24);
        }
        // round vent holes (skip pillar bases)
        for (x = [10:vp:ox-10]) for (y = [10:vp:oy-10]) {
            near = (sqrt(pow(x-pcx(-1),2)+pow(y-pcy(-1),2)) < 16)
                || (sqrt(pow(x-pcx(1),2)+pow(y-pcy(-1),2)) < 16)
                || (sqrt(pow(x-pcx(-1),2)+pow(y-pcy(1),2)) < 16)
                || (sqrt(pow(x-pcx(1),2)+pow(y-pcy(1),2)) < 16);
            if (!near) translate([x, y, -1]) cylinder(d = vd, h = wall + 2, $fn = 24);
        }
        // 4 screw pilot holes
        translate([40, iy+wall-boss_depth-0.1, screw_z]) rotate([-90,0,0]) cylinder(d = pilot_d, h = wall + boss_depth + 0.2, $fn = 24);
        translate([80, iy+wall-boss_depth-0.1, screw_z]) rotate([-90,0,0]) cylinder(d = pilot_d, h = wall + boss_depth + 0.2, $fn = 24);
        translate([-0.1, 40, screw_z]) rotate([0,90,0]) cylinder(d = pilot_d, h = wall + boss_depth + 0.2, $fn = 24);
        translate([-0.1, 80, screw_z]) rotate([0,90,0]) cylinder(d = pilot_d, h = wall + boss_depth + 0.2, $fn = 24);
        // bottom anchors: through-hole + counterbore at each pillar (cuts floor AND pillar)
        for (x = [-1,1]) for (y = [-1,1]) {
            translate([pcx(x), pcy(y), -1])
                cylinder(d = bot_screw_d, h = wall + pillar_h - hex_depth + 1.2, $fn = 24);
            translate([pcx(x), pcy(y), -1])
                cylinder(d = bot_head_d, h = bot_head_h + 1, $fn = 24);
        }
    }
}

module cover() {
    // Cover sits ON TOP of the base (plate bottom at z=oz), skirt hangs below.
    // This keeps the skirt screws at z=screw_z aligned with the base screw pilots.
    difference() {
        union() {
            // top plate: sized to the skirt outer so it overlaps the skirt ring (no gap)
            translate([-skirt_t, -skirt_t, oz])
                linear_extrude(wall) rrect(ox + 2*skirt_t, oy + 2*skirt_t, corner_r + skirt_t);
            translate([-skirt_t, -skirt_t, oz - skirt_h])
                linear_extrude(skirt_h) rrect(ox + 2*skirt_t, oy + 2*skirt_t, corner_r + skirt_t);
        }
        translate([-fit_clear, -fit_clear, oz - skirt_h - 0.1])
            linear_extrude(skirt_h + 0.2) rrect(ox + 2*fit_clear, oy + 2*fit_clear, corner_r + fit_clear);
        for (y = [15:vp:oy-15]) {
            translate([ox/2 - slot_w/2, y, oz - 0.1]) cube([slot_w, slot_h, wall + 0.2]);
        }
        translate([40, oy+fit_clear-0.1, screw_z]) rotate([-90,0,0]) cylinder(d = screw_d, h = skirt_t-fit_clear+0.3, $fn = 24);
        translate([80, oy+fit_clear-0.1, screw_z]) rotate([-90,0,0]) cylinder(d = screw_d, h = skirt_t-fit_clear+0.3, $fn = 24);
        translate([-skirt_t-0.1, 40, screw_z]) rotate([0,90,0]) cylinder(d = screw_d, h = skirt_t+0.2, $fn = 24);
        translate([-skirt_t-0.1, 80, screw_z]) rotate([0,90,0]) cylinder(d = screw_d, h = skirt_t+0.2, $fn = 24);
    }
}

// Print-oriented cover: flipped so the top plate sits on the bed and the
// skirt points up. This avoids a 125mm bridge across the open interior.
module cover_print() {
    translate([0, 0, oz + wall]) mirror([0, 0, 1]) cover();
}

part = "both";
if (part == "base") base();
if (part == "cover") cover_print();
if (part == "cover_design") cover();
if (part == "both") {
    base();
    translate([0, oy + 15, 0]) cover();
}
