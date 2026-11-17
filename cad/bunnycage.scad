// bunnycage — MagSafe + Qi charging case for the Rabbit r1
// Frame: screen facing you, x from device LEFT edge, y from device BOTTOM edge,
// z up from the case's outer back face (print bed). Units: mm.
// Render one part:  openscad -D 'part="body"' -o body.stl bunnycage.scad

part = "assembly"; // body | lid | fit_test | assembly | check | viz_* (see bottom)

// ---- Device (rabbit official drawing; verify with calipers) ----
dev   = 78;     // width = height
dev_t = 13;     // thickness
dev_r = 7.5;    // plan corner radius (community STEP says 5.9)
port_y = 78 - 31.6; // USB-C centre, left edge
port_z = 6.6;       // USB-C centre above device back
mic_x  = [78 - 26.6, 78 - 51.6]; // top-edge mics
col_x  = 60;    // right column (eye / wheel / speaker) starts here

// ---- Fit knobs ----
clr    = 0.2;   // cavity clearance per side
dz     = 0.3;   // extra cavity height over dev_t
wall   = 2.0;
lip    = 1.0;   // front lip overhang (45° underside, prints without support)
cap    = 0.4;   // flat on top of lip
hook_x = 2.5;   // how far the rails wrap past the right corners
detent_pre = 0.1; // detent bump presses this far into the seated device corner (snap strength + no rattle)
detent_len = 1.2; // bump length along x; longer = harder snap
ledge  = 1.7;   // back ledge width under the rail fingers

// ---- Charging hardware ----
skin    = 0.6;  // plastic between magnets/coil and the charger
bt      = 3.7;  // back thickness: skin + ring + 0.1 + ferrite sheet (~0.3) + 0.1 for tape
ring_od = 54;   // owner's ring: 53.9 OD x 45.8 ID x 2.6 (the 1.5 mm TotalElement ring: ring_t = 1.5, bt = 2.6)
ring_id = 45.8;
ring_t  = 2.6;
coil_t  = 0.7;  // Qi coil thickness: measure yours
disc_fit = 0.6; // diametral clearance between the centre boss and the ring's hole
disc_t  = ring_t - coil_t; // height of the boss printed inside the ring's hole: the coil rests on it, level with the ring top
// Acxico Qi receiver (5 V / 1 A): 41 x 29 coil sits centred in the ring's hole facing the charger,
// loose ferrite sheet (~42 x 34) lies on top of the ring. The 34 x 14 x ~1.5 flex board hangs off the
// coil's short end on stiff ~5 mm leads, long side toward the coil, so it slides flat through a wide
// slot under the spine wall and ends up half under the r1's edge, half in the spine under the plug shelf.
panel   = [48, 35]; panel_fit = 1.0;
rx_slot = [18, 56]; // y-range of the slot under the spine wall: board length + 2 mm each side
rx_x0   = -14.5;    // the board reaches this far into the spine; the plug shelf is hollow from here inward
shelf_t = 1.6;      // plug shelf thickness where it bridges over the receiver board
ring_c  = [29, 39]; // ring/coil centre: shifted left to clear the wheel's Hall sensor
ring_fit = 0.8; // diametral clearance on the pocket

// ---- Spine (left-edge electronics bay: USB-C plug board + Qi receiver PCB) ----
spine_in = 18;  // inner depth; Adafruit 5978 plug board reaches ~17.6 mm past the port
floor_t  = 1.2;
shelf_drop = 3.0; // shelf top below plug centreline; shim the plug board with glue
win_w = 15; win_below = shelf_drop; win_above = 2.4; // plug window in the inner wall; its sill is the shelf top
lid_t = 1.6; lid_rebate = 0.8; lid_clr = 0.15; skirt_h = 4; skirt_fit = 0.12;
rib = 0.15;     // lid crush-rib interference; raise if the lid is loose

H   = bt + dev_t + dz + lip + cap;
xl  = -clr - wall - spine_in - wall;       // outer left
xr  = dev + clr + wall;                    // outer right (before the end cut)
x_end   = dev - dev_r + hook_x;            // rails stop here; device slides in from the right
back_end = col_x - 0.8;                    // back plate stops before the right column
$fn = 72;

module rr(x0, y0, x1, y1, r) {
  hull() for (x = [x0 + r, x1 - r], y = [y0 + r, y1 - r]) translate([x, y]) circle(r);
}
module cav2d()   { rr(-clr, -clr, dev + clr, dev + clr, dev_r + clr); }
module outer2d() {
  ro = dev_r + clr + wall;
  hull() {
    for (y = [-clr - wall + 6, dev + clr + wall - 6]) translate([xl + 6, y]) circle(6);
    for (y = [-clr - wall + ro, dev + clr + wall - ro]) translate([xr - ro, y]) circle(ro);
  }
}
module spine2d() { rr(xl + wall, -clr, -clr - wall, dev + clr, 4); }
module detent2d() for (yc = [dev_r, dev - dev_r]) intersection() {
  translate([dev - dev_r, yc]) difference() { circle(dev_r + clr + 0.3); circle(dev_r - detent_pre, $fn = 160); }
  translate([dev - dev_r + 0.5, yc > dev / 2 ? yc : yc - 20]) square([detent_len, 20]);
}

module body() {
  disc();
  translate([0, 0, bt]) linear_extrude(H - bt) detent2d();
  difference() {
    linear_extrude(H) outer2d();
    // device cavity + chamfered front lip
    translate([0, 0, bt]) linear_extrude(dev_t + dz) cav2d();
    translate([0, 0, bt + dev_t + dz - 0.01]) hull() {
      linear_extrude(0.01) cav2d();
      translate([0, 0, lip]) linear_extrude(0.01) offset(delta = -lip) cav2d();
    }
    translate([0, 0, bt + dev_t + dz + lip - 0.02]) linear_extrude(cap + 1) offset(delta = -lip) cav2d();
    // open right end: device slides in from here; rails wrap the corners as detents
    translate([x_end, -50, -1]) cube([100, 200, H + 2]);
    // right column (eye, wheel, speaker) stays exposed on the back, minus rail ledges
    translate([back_end, -clr + ledge, -1]) cube([100, dev + 2 * clr - 2 * ledge, bt + 1]);
    // magnet ring pocket (full depth so the ring drops in) + receiver panel recess resting on the ring
    translate([ring_c[0], ring_c[1], skin]) cylinder(d = ring_od + ring_fit, h = bt, $fn = 120);
    translate([ring_c[0] - (panel[0] + panel_fit) / 2, ring_c[1] - (panel[1] + panel_fit) / 2, skin + ring_t + 0.1])
      cube([panel[0] + panel_fit, panel[1] + panel_fit, bt]);
    // chip-board slot: panel recess -> under the spine wall -> spine floor
    translate([-clr - wall - 0.5, rx_slot[0], floor_t]) cube([clr + wall + 0.5 + ring_c[0] - panel[0] / 2, rx_slot[1] - rx_slot[0], bt]);
    // spine cavity + lid rebate + fingernail notch
    difference() {
      translate([0, 0, floor_t]) linear_extrude(H) spine2d();
      difference() {
        translate([xl + wall - 1, port_y - win_w / 2, 0]) cube([spine_in + 2, win_w, bt + port_z - shelf_drop]);
        translate([rx_x0, port_y - win_w / 2 - 1, -1]) cube([100, win_w + 2, bt + port_z - shelf_drop - shelf_t + 1]); // room for the receiver board under the shelf
      } // plug shelf (overshoots the cavity so no faces coincide)
    }
    translate([0, 0, H - lid_t]) linear_extrude(lid_t + 1) offset(delta = lid_rebate) spine2d();
    translate([xl - 1, 35, H - lid_t]) cube([wall + 1.5, 8, lid_t + 1]);
    // plug window through the spine's inner wall
    translate([-clr - wall - 0.5, port_y - win_w / 2, bt + port_z - win_below]) cube([wall + 1, win_w, win_below + win_above]);
    // mic holes, top edge
    for (x = mic_x) translate([x, dev, bt + dev_t / 2]) rotate([-90, 0, 0]) cylinder(d = 2, h = 10, $fn = 24);
  }
}

module disc() translate([ring_c[0], ring_c[1], skin - 0.1]) cylinder(d = ring_id - disc_fit, h = disc_t + 0.1, $fn = 120); // boss in the ring's hole, part of the body

module lid() { // assembled position; export flipped for printing
  translate([0, 0, H - lid_t]) linear_extrude(lid_t) offset(delta = lid_rebate - lid_clr) spine2d();
  translate([0, 0, H - lid_t - skirt_h]) linear_extrude(skirt_h) difference() {
    offset(delta = -skirt_fit) spine2d();
    offset(delta = -skirt_fit - 1.2) spine2d();
    // skip the skirt over the plug window so it can't foul the plug board
    translate([-clr - wall - 3, port_y - win_w / 2 - 1]) square([4, win_w + 2]);
  }
  // crush ribs: the only interference in the lid fit
  translate([0, 0, H - lid_t - skirt_h]) linear_extrude(skirt_h) for (y = [10, 26, 68])
    for (x = [xl + wall + 0.5 - rib, -clr - wall - 0.5 + rib]) translate([x, y]) circle(0.5, $fn = 16);
}

// ---- Mock-ups (viewer + interference check only, never printed) ----
module r1() translate([0, 0, bt]) {
  difference() {
    linear_extrude(dev_t) rr(0, 0, dev, dev, dev_r);
    translate([0, 0, dev_t - 0.4]) linear_extrude(1) rr(2.5, 2.8, 57.4, 75.4, 5);       // screen
    translate([0, 0, -1]) linear_extrude(dev_t + 2) rr(60, 60, 75.6, 75.6, 3.5);         // eye window
    translate([0, 0, -1]) linear_extrude(dev_t + 2) rr(60, 38.5, 75.6, 54.5, 1.8);       // wheel slot
  }
  translate([60, 46.5, dev_t / 2]) rotate([0, 90, 0]) cylinder(d = 14.9, h = 15.5);       // wheel (+1 mm proud)
  translate([60, 67.8, dev_t / 2]) rotate([0, 90, 0]) cylinder(d = 8, h = 15.5);         // eye barrel
  translate([dev - 1, port_y, dev_t / 2]) rotate([0, 90, 0]) cylinder(d = 6.5, h = 2.5); // PTT button
}
module ring() translate([ring_c[0], ring_c[1], skin]) difference() {
  cylinder(d = 53.9, h = ring_t, $fn = 120); translate([0, 0, -1]) cylinder(d = ring_id, h = ring_t + 2, $fn = 120);
}
module coil() translate([ring_c[0], ring_c[1], skin + ring_t + 0.1]) { // shield panel + coil (coil side down)
  translate([-panel[0] / 2, -panel[1] / 2, 0]) cube([panel[0], panel[1], 0.5]);
  translate([0, 0, -coil_t]) linear_extrude(coil_t) difference() {
    hull() for (x = [-6, 6]) translate([x, 0]) circle(d = 29);
    hull() for (x = [-5.5, 5.5]) translate([x, 0]) circle(d = 9);
  }
}
module plug() translate([0, port_y, bt + port_z]) { // envelope of the largest plug board that fits (Adafruit 5978); the ANMBEST 24P male board is smaller
  translate([-17.6, -7.15, -0.8]) cube([17.6, 14.3, 1.6]);
  translate([-3, -4.15, -1.3]) cube([9.5, 8.3, 2.6]);
}
module rx_pcb() translate([-12, 20, floor_t]) cube([14, 34, 1.5]); // Qi receiver flex board: slid through the slot, under the plug shelf

if (part == "body") body();
if (part == "lid") translate([0, 0, H]) rotate([180, 0, 0]) lid();
if (part == "fit_test") difference() { // low frame: checks width, all four corners and the detents
  intersection() { body(); translate([-3, -50, 0]) cube([200, 200, bt + 6]); }
  translate([6, 6, -1]) cube([50, 66, bt + 2]);
}
if (part == "check") intersection() { union() { body(); lid(); } union() { r1(); ring(); coil(); plug(); rx_pcb(); } }
if (part == "viz_lid") lid();
if (part == "viz_r1") r1();
if (part == "viz_ring") ring();
if (part == "viz_coil") coil();
if (part == "viz_plug") plug();
if (part == "viz_rx") rx_pcb();
if (part == "assembly") { body(); lid(); color("orangered") r1(); color("silver") ring(); color("peru") coil(); color("green") { plug(); rx_pcb(); } }
