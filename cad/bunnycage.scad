// bunnycage — MagSafe + Qi charging case for the Rabbit r1
// Frame: screen facing you, x from device LEFT edge, y from device BOTTOM edge,
// z up from the case's outer back face (print bed). Units: mm.
// Render one part:  openscad -D 'part="body"' -o body.stl bunnycage.scad

part = "assembly"; // body | lid | fit_test | port_test | assembly | check | viz_* (see bottom)

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
spine_in = 18;  // inner depth
floor_t  = 1.2;

// ---- USB-C boards (ANMBEST 4-pad breakouts). ESTIMATES from the listing photos: measure yours ----
// Each board slides into its hole from inside the spine until its black collar stops against the print.
// Pressing the lid on drops a gate behind each collar (into grooves in the cradle) and a foot on top of it.
m_shell = [8.3, 2.5];      // male plug metal shell: width, height
m_shell_len = 9.0;         // male: exposed metal from collar face to tip
m_col = [9.4, 3.4, 1.5];   // male black collar: width, height, thickness along the plug
m_pcb = [8.6, 0.8, 5.5];   // male board: width, thickness, length behind the collar
m_pcb_dz = 0;              // male board centre above (+) / below (-) the plug centreline
m_mate = 6.3;              // how deep the plug sits in the r1's port. r1 won't click home: lower it. Flaky contact: raise it
f_shell = [8.94, 3.26];    // female receptacle metal shell: width, height
f_shell_len = 7.2;         // female: exposed metal from collar face to mouth
f_col = [10.0, 4.2, 1.6];  // female black collar: width, height, thickness
f_pcb = [9.8, 0.8, 5.8];   // female board: width, thickness, length behind the collar
f_pcb_dz = 0;              // female board centre above / below the receptacle centreline
f_recess = 0;              // 0 = receptacle mouth flush with the outer wall; raise to sink it in
fport_y = 63;              // female port position along the left edge (must clear the receiver board, which ends at y = 54)
hole_fit = 0.3;            // added to shell width and height for the pill-shaped holes
col_fit  = 0.15;           // clearance each side of collar / board in its channel
gate_t = 2.0; gate_ear = 1.5; // lid gate: thickness, and how far each end reaches into its groove
lid_t = 1.6; lid_rebate = 0.8; lid_clr = 0.15; skirt_h = 4; skirt_fit = 0.12;
rib = 0.15;     // lid crush-rib interference; raise if the lid is loose

H   = bt + dev_t + dz + lip + cap;
m_z   = bt + port_z;                       // male plug centreline
f_z   = H / 2;                             // female port centred on the case edge
m_xcf = m_mate - m_shell_len;              // male collar front face (world x)
m_hw  = max(m_col[0], m_pcb[0]) / 2 + col_fit;
f_hw  = max(f_col[0], f_pcb[0]) / 2 + col_fit;
crad_top = H - lid_t - 1.2;                // top of the cradle cheeks
function crad_back(c) = c[2] + 0.15 + gate_t + 0.25 + 1.6; // cradle length behind the collar front
function crad_w(hw) = hw + gate_ear + 1.4;                 // cradle half-width
win_w = 2 * crad_w(m_hw);                  // shelf width under the male board
shelf_top = m_z - m_col[1] / 2 - 0.1;      // the male collar rests on the shelf
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

// ---- Connector cradles. Local frame: origin at the collar's front face on the connector centreline, +x toward the mouth ----
module male_at()   translate([m_xcf, port_y, m_z]) children();
module female_at() translate([xl + f_recess + f_shell_len, fport_y, f_z]) mirror([1, 0, 0]) children();
module pill_x(w, h, len) hull() for (s = [-1, 1]) translate([0, s * (w - h) / 2, 0]) rotate([0, 90, 0]) cylinder(d = h, h = len, $fn = 48);
module cr_cheeks(c, hw, zc, fwd) // tall block either side of the board; the gate grooves are cut into it
  translate([-crad_back(c), -crad_w(hw), -c[1] / 2 - 0.1]) cube([crad_back(c) + fwd, 2 * crad_w(hw), crad_top - zc + c[1] / 2 + 0.1]);
module cr_cuts(sh, c, hw, hole_len, setback) {
  translate([-0.01, 0, 0]) pill_x(sh[0] + hole_fit, sh[1] + hole_fit, hole_len);                         // pill hole for the metal shell
  translate([-crad_back(c) - 1, -hw, -c[1] / 2 - 0.1]) cube([crad_back(c) + 1, 2 * hw, c[1] + 0.35]);       // collar + board channel
  translate([-crad_back(c) - 1, -hw, 0]) cube([crad_back(c) + 1 - setback, 2 * hw, 50]);                  // open above for the lid foot and wires
  translate([-c[2] - 0.15 - gate_t - 0.2, -hw - gate_ear, -c[1] / 2 - 0.1]) cube([gate_t + 0.4, 2 * (hw + gate_ear), 50]); // gate grooves
}
module cr_gate(c, pcb, pdz, hw, zc, setback) { // hangs from the lid
  zl = H - lid_t - zc + 0.01; x0 = -c[2] - 0.15 - gate_t; zp = pdz + pcb[1] / 2 + 0.6;
  translate([x0, -hw - gate_ear + 0.25, zp]) cube([gate_t, 2 * (hw + gate_ear - 0.25), zl - zp]);           // gate: bears on the collar above the board
  for (s = [-1, 1]) translate([x0, s > 0 ? hw + 0.25 : -hw - gate_ear + 0.25, -c[1] / 2 + 0.4]) cube([gate_t, gate_ear - 0.5, zl + c[1] / 2 - 0.4]); // ears in the grooves
  if (c[2] - 0.1 - setback > 0.4) translate([x0, -hw + 0.4, c[1] / 2 + 0.2]) cube([gate_t + c[2] - 0.1 - setback, 2 * (hw - 0.4), zl - c[1] / 2 - 0.2]); // foot on top of the collar
}
m_setback = max(0, m_xcf + clr + wall); // collar pocket sunk into the inner wall (only if the shell is short)
module spine_keep() { // solid left standing inside the spine cavity
  difference() { // male shelf, hollow underneath for the receiver board
    translate([xl + wall - 1, port_y - win_w / 2, 0]) cube([spine_in + 2, win_w, shelf_top]);
    translate([rx_x0, port_y - win_w / 2 - 1, -1]) cube([100, win_w + 2, shelf_top - shelf_t + 1]);
  }
  male_at() cr_cheeks(m_col, m_hw, m_z, -clr - wall + 0.3 - m_xcf);
  female_at() {
    cr_cheeks(f_col, f_hw, f_z, 0);
    translate([-crad_back(f_col), -crad_w(f_hw), -f_z]) // pedestal + sleeve, floor to just under the lid skirt
      cube([crad_back(f_col) + f_shell_len + f_recess - wall + 0.5, 2 * crad_w(f_hw), f_z + f_shell[1] / 2 + hole_fit / 2 + 1.2]);
  }
}
module port_cuts() {
  male_at()   cr_cuts(m_shell, m_col, m_hw, -m_xcf + 1, m_setback);
  female_at() cr_cuts(f_shell, f_col, f_hw, f_shell_len + f_recess + 1, 0);
}
module gates() {
  male_at()   cr_gate(m_col, m_pcb, m_pcb_dz, m_hw, m_z, m_setback);
  female_at() cr_gate(f_col, f_pcb, f_pcb_dz, f_hw, f_z, 0);
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
      spine_keep(); // overshoots the cavity so no faces coincide
    }
    translate([0, 0, H - lid_t]) linear_extrude(lid_t + 1) offset(delta = lid_rebate) spine2d();
    translate([xl - 1, 35, H - lid_t]) cube([wall + 1.5, 8, lid_t + 1]);
    // pill holes, collar channels and gate grooves for both USB-C boards
    port_cuts();
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
    // skip the skirt beside the male cradle
    translate([-clr - wall - 3, port_y - win_w / 2 - 1]) square([4, win_w + 2]);
  }
  gates();
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
module conn(sh, len, c, pcb, pdz) { // mock board in the cradle's local frame
  pill_x(sh[0], sh[1], len);
  translate([-c[2], -c[0] / 2, -c[1] / 2]) cube([c[2], c[0], c[1]]);
  translate([-c[2] - pcb[2], -pcb[0] / 2, pdz - pcb[1] / 2]) cube([pcb[2] + 0.5, pcb[0], pcb[1]]);
}
module plug() male_at() conn(m_shell, m_shell_len, m_col, m_pcb, m_pcb_dz);
module jack() female_at() conn(f_shell, f_shell_len, f_col, f_pcb, f_pcb_dz);
module rx_pcb() translate([-12, 20, floor_t]) cube([14, 34, 1.5]); // Qi receiver flex board: slid through the slot, under the plug shelf

if (part == "body") body();
if (part == "lid") translate([0, 0, H]) rotate([180, 0, 0]) lid();
if (part == "fit_test") difference() { // low frame: checks width, all four corners and the detents
  intersection() { body(); translate([-3, -50, 0]) cube([200, 200, bt + 6]); }
  translate([6, 6, -1]) cube([50, 66, bt + 2]);
}
if (part == "port_test") { // spine slice with both cradles + the matching lid slice: checks the USB-C fits in minutes
  intersection() { body(); translate([xl - 1, port_y - 11, -1]) cube([-xl + 2.5, fport_y - port_y + 21, H + 2]); }
  translate([26, 2 * port_y + 16, H]) rotate([180, 0, 0]) intersection() { lid(); translate([xl - 1, port_y - 11, 0]) cube([-xl + 2.5, fport_y - port_y + 21, H + 2]); }
}
if (part == "check") intersection() { union() { body(); lid(); } union() { r1(); ring(); coil(); plug(); jack(); rx_pcb(); } }
if (part == "viz_lid") lid();
if (part == "viz_r1") r1();
if (part == "viz_ring") ring();
if (part == "viz_coil") coil();
if (part == "viz_plug") plug();
if (part == "viz_jack") jack();
if (part == "viz_rx") rx_pcb();
if (part == "assembly") { body(); lid(); color("orangered") r1(); color("silver") ring(); color("peru") coil(); color("green") { plug(); jack(); rx_pcb(); } }
