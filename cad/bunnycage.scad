// bunnycage — MagSafe + Qi charging case for the Rabbit r1
// Frame: screen facing you, x from device LEFT edge, y from device BOTTOM edge,
// z up from the case's outer back face (print bed). Units: mm.
// Render one part:  openscad -D 'part="body"' -o body.stl bunnycage.scad

part = "assembly"; // body | lid | cap | fit_test | port_test | assembly | check | viz_* (see bottom)

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

// ---- End cap: closes the right end after the r1 has slid onto the plug ----
cap_x   = 66;    // joint plane: everything right of this is the cap
cap_ov  = 11;    // the cap's two arms overlap the outside of the body rails by this much
arm_t   = 0.9;   // arm thickness (outer skin of the 2 mm rail)
arm_gap = 0.15;  // clearance between arm and rail
ridge_h = 0.5;   // snap ridge height on each rail: raise for a firmer click, lower if the cap is hard to pull off
ridge_back = 8;  // ridge distance from the joint plane (the arm flexes over this length)
ledge_r = 1.2;   // back ledge under the r1's right edge
// Side button, from the reference body STL (reference/Nawaz_RabbitR1Body_CC0.stl): a 6.6 mm round hole in the right edge
btn   = [46.63, 6.51]; // button centre: y along the right edge, z above the r1's back
btn_d = 6.2;     // button diameter (reference button STL)
btn_out = 1.3;   // how far the button stands out of the r1's edge (from the assembled reference model)
ptt_d = 10;      // round opening in the cap; its outer edge is countersunk so a fingertip reaches the button
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

// ---- USB-C boards (ANMBEST 4-pad breakouts) ----
// Nothing on either board is usefully wider than its metal shell (owner's measurements, 18 Nov 2026), so there is
// no collar to stop on. Each board slides into its pill hole from inside the spine; pressing the lid on drops a
// gate into grooves behind the board's TAIL, which is what stops it being pushed back in. Pulling out is resisted
// only by the snug hole: add a drop of glue under each board.
m_shell = [8.25, 2.4];     // male plug metal shell: width, height (USB-C standard; owner read 8 x 2)
m_shell_len = 9.0;         // male: exposed metal, collar to tip (measured)
m_col = [8.33, 2.66];      // male black collar: width, height (measured)
m_pcb = [7.5, 0.8];        // male board: width (measured), thickness (assumed)
m_len = 16.0;              // male: overall length, plug tip to board tail (listing value; fit confirmed by the owner's port-test print, 18 Nov 2026)
m_mate = 6.3;              // how deep the plug sits in the r1's port. r1 won't click home: lower it. Flaky contact: raise it
f_shell = [8.94, 3.26];    // female receptacle metal shell: width, height (USB-C standard; owner read 9 x 3)
f_pcb = [8.5, 0.8];        // female board: width (measured), thickness (assumed)
f_len = 14.6;              // female: overall length, mouth to board tail (listing value; fit confirmed by the port-test print)
f_sleeve = 4.5;            // length of the tunnel that holds the female shell (outer wall included)
f_recess = 0;              // 0 = receptacle mouth flush with the outer wall; raise to sink it in
fport_y = 63;              // female port position along the left edge (must clear the receiver board, which ends at y = 54)
hole_fit = 0.25;           // added to shell width and height for the pill-shaped holes; lower for a tighter grip
col_fit  = 0.15;           // clearance each side of the board in its channel
gate_t = 2.0; gate_ear = 2.5; // lid gate: thickness, and how far each leg reaches into its groove
lid_t = 1.6; lid_rebate = 0.8; lid_clr = 0.15; skirt_h = 4; skirt_fit = 0.12;
rib = 0.15;     // lid crush-rib interference; raise if the lid is loose

H   = bt + dev_t + dz + lip + cap;
m_z   = bt + port_z;                       // male plug centreline
f_z   = H / 2;                             // female port centred on the case edge
m_xt  = m_mate - m_len;                    // male board tail (world x)
m_xcf = m_mate - m_shell_len;              // male collar front face (world x); must stay inside the spine
m_hw  = max(m_col[0], m_pcb[0]) / 2 + col_fit;
f_hw  = max(f_shell[0], f_pcb[0]) / 2 + col_fit;
m_zb  = m_col[1] / 2 + 0.1;                // channel floor below the centreline: the male collar rests on it
f_zb  = f_shell[1] / 2 + 0.15;
crad_h = 3.5;                              // cradle cheeks rise this far above the centreline; wires run over them
crad_back = 0.15 + gate_t + 0.2 + 1.4;     // cradle length behind the board tail
function crad_w(hw) = hw + gate_ear + 1.2; // cradle half-width
win_w = 2 * crad_w(m_hw);                  // shelf width under the male board
shelf_top = m_z - m_zb;
xl  = -clr - wall - spine_in - wall;       // outer left
xr  = dev + clr + wall;                    // outer right (before the end cut)
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

// ---- Connector cradles. Local frame: origin at the board's tail on the connector centreline, +x toward the mouth ----
module male_at()   translate([m_xt, port_y, m_z]) children();
module female_at() translate([xl + f_recess + f_len, fport_y, f_z]) mirror([1, 0, 0]) children();
module pill_x(w, h, len) hull() for (s = [-1, 1]) translate([0, s * (w - h) / 2, 0]) rotate([0, 90, 0]) cylinder(d = h, h = len, $fn = 48);
module cr_cheeks(hw, zb, front) translate([-crad_back, -crad_w(hw), -zb]) cube([crad_back + front, 2 * crad_w(hw), zb + crad_h]);
module cr_cuts(sh, hw, zb, front, hole_len) {
  translate([front - 0.01, 0, 0]) pill_x(sh[0] + hole_fit, sh[1] + hole_fit, hole_len);       // pill hole for the metal shell
  translate([-crad_back - 1, -hw, -zb]) cube([crad_back + 1 + front, 2 * hw, 50]);              // board channel, open above
  translate([-0.15 - gate_t - 0.2, -hw - gate_ear, -zb]) cube([gate_t + 0.4, 2 * (hw + gate_ear), 50]); // gate grooves
}
module cr_gate(hw, zb, pt, zc) { // hangs from the lid, just behind the board tail
  zl = H - lid_t - zc + 0.01; x0 = -0.15 - gate_t; w = hw + gate_ear - 0.25;
  for (s = [-1, 1]) translate([x0, s > 0 ? hw + 0.25 : -w, -zb + 0.4]) cube([gate_t, gate_ear - 0.5, zl + zb - 0.4]); // legs in the grooves
  translate([x0, -w, -zb + 0.4]) cube([gate_t, 2 * w, zb - 0.4 + pt / 2]);  // crossbar: the board tail backs onto this
  translate([x0, -w, pt / 2 + 2.6]) cube([gate_t, 2 * w, zl - pt / 2 - 2.6]); // top plate; the gap under it is the wire window
}
m_front = -clr - wall - m_xt;      // male channel runs from the tail to the inner wall
f_front = f_len - f_sleeve;        // female channel runs from the tail to the sleeve
module spine_keep() { // solid left standing inside the spine cavity
  difference() { // male shelf, hollow underneath for the receiver board
    translate([xl + wall - 1, port_y - win_w / 2, 0]) cube([spine_in + 2, win_w, shelf_top]);
    translate([rx_x0, port_y - win_w / 2 - 1, -1]) cube([100, win_w + 2, shelf_top - shelf_t + 1]);
  }
  male_at() cr_cheeks(m_hw, m_zb, m_front + 0.3);
  female_at() {
    cr_cheeks(f_hw, f_zb, f_front);
    translate([-crad_back, -crad_w(f_hw), -f_z]) // pedestal + sleeve, floor to just under the lid skirt
      cube([crad_back + f_len + f_recess - wall + 0.5, 2 * crad_w(f_hw), f_z + f_shell[1] / 2 + hole_fit / 2 + 1.2]);
  }
}
module port_cuts() {
  male_at()   cr_cuts(m_shell, m_hw, m_zb, m_front, wall + clr + 1);
  female_at() cr_cuts(f_shell, f_hw, f_zb, f_front, f_sleeve + f_recess + 1);
}
module gates() {
  male_at()   cr_gate(m_hw, m_zb, m_pcb[1], m_z);
  female_at() cr_gate(f_hw, f_zb, f_pcb[1], f_z);
  // foot on top of the male collar, so the plug cannot tip
  translate([m_xcf - 1.5, port_y - m_hw + 0.4, m_z + m_col[1] / 2 + 0.2]) cube([1.2, 2 * (m_hw - 0.4), H - lid_t - m_z - m_col[1] / 2 - 0.19]);
}

module shell() { // the whole case as one piece; body() and cap() are cut from it
  disc();
  difference() {
    linear_extrude(H) outer2d();
    // device cavity + chamfered front lip
    translate([0, 0, bt]) linear_extrude(dev_t + dz) cav2d();
    translate([0, 0, bt + dev_t + dz - 0.01]) hull() {
      linear_extrude(0.01) cav2d();
      translate([0, 0, lip]) linear_extrude(0.01) offset(delta = -lip) cav2d();
    }
    translate([0, 0, bt + dev_t + dz + lip - 0.02]) linear_extrude(cap + 1) offset(delta = -lip) cav2d();
    // side button opening in the right wall
    translate([dev - 1, btn[0], bt + btn[1]]) rotate([0, 90, 0]) { cylinder(d = ptt_d, h = wall + 3, $fn = 64);
      translate([0, 0, 1 + clr + wall - 1]) cylinder(d1 = ptt_d, d2 = ptt_d + 2.4, h = 1.2, $fn = 64); }
    // right column (eye, wheel, speaker) stays exposed on the back, minus rail ledges
    translate([back_end, -clr + ledge, -1]) cube([dev + clr - ledge_r - back_end, dev + 2 * clr - 2 * ledge, bt + 1]);
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

module arm_zone(g) for (s = [0, 1]) // outer skin of both rails where the cap arms lie
  translate([cap_x - cap_ov - g, s ? dev + clr + wall - arm_t - g : -clr - wall - 1, -1]) cube([cap_ov + g + 0.01, arm_t + g + 1, H + 2]);
x_ridge = cap_x - ridge_back;
module ridge2d() polygon([[x_ridge + 1.73 * ridge_h, -0.2], [x_ridge + 1.73 * ridge_h, 0], [x_ridge, ridge_h], [x_ridge - ridge_h, 0], [x_ridge - ridge_h, -0.2]]); // gentle side leads the arm on, 45 deg side holds it
module body() {
  difference() { shell(); translate([cap_x, -50, -1]) cube([100, 200, H + 2]); arm_zone(arm_gap); }
  for (s = [0, 1]) translate([0, s ? dev + clr + wall - arm_t - arm_gap : -clr - wall + arm_t + arm_gap, 4]) mirror([0, s ? 0 : 1, 0]) linear_extrude(H - 8) ridge2d();
}
module cap() difference() {
  intersection() { shell(); union() { translate([cap_x, -50, -1]) cube([100, 200, H + 2]); arm_zone(0); } }
  translate([x_ridge - ridge_h - 0.25, -50, 3.5]) cube([2.73 * ridge_h + 0.5, 200, H - 7]); // windows the ridges click into
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
module r1() translate([0, 0, bt]) { // reference models by Nawaz (CC0), in reference/
  import("../reference/Nawaz_RabbitR1Body_CC0.stl", convexity = 10);
  translate([dev + btn_out - 22, btn[0], btn[1]]) rotate([0, 0, -90]) import("../reference/Nawaz_RabbitR1Button_CC0.stl", convexity = 4); // side button
  translate([60.06, 46.55, dev_t / 2]) rotate([0, 0, -90]) import("../reference/Nawaz_Knobb_CC0.stl", convexity = 4);                 // scroll wheel, 1 mm proud front and back
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
module plug() male_at() { // mock boards, in the cradle's local frame
  translate([m_len - m_shell_len, 0, 0]) pill_x(m_shell[0], m_shell[1], m_shell_len);
  translate([4, -m_col[0] / 2, -m_col[1] / 2]) cube([m_len - m_shell_len - 4, m_col[0], m_col[1]]);
  translate([0, -m_pcb[0] / 2, -m_pcb[1] / 2]) cube([4.5, m_pcb[0], m_pcb[1]]);
}
module jack() female_at() {
  translate([f_len - 7.7, 0, 0]) pill_x(f_shell[0], f_shell[1], 7.7);
  translate([0, -f_pcb[0] / 2, -f_pcb[1] / 2]) cube([f_len - 7.2, f_pcb[0], f_pcb[1]]);
}
module rx_pcb() translate([-12, 20, floor_t]) cube([14, 34, 1.5]); // Qi receiver flex board: slid through the slot, under the plug shelf

if (part == "body") body();
if (part == "cap") cap();
if (part == "viz_cap") cap();
if (part == "lid") translate([0, 0, H]) rotate([180, 0, 0]) lid();
if (part == "fit_test") difference() { // low frame: checks width, the left corners and the rails
  intersection() { body(); translate([-3, -50, 0]) cube([200, 200, bt + 6]); }
  translate([6, 6, -1]) cube([50, 66, bt + 2]);
}
if (part == "port_test") { // spine slice with both cradles + the matching lid slice: checks the USB-C fits in minutes
  intersection() { body(); translate([xl - 1, port_y - 11, -1]) cube([-xl + 2.5, fport_y - port_y + 21, H + 2]); }
  translate([26, 2 * port_y + 16, H]) rotate([180, 0, 0]) intersection() { lid(); translate([xl - 1, port_y - 11, 0]) cube([-xl + 2.5, fport_y - port_y + 21, H + 2]); }
}
if (part == "check") intersection() { union() { body(); lid(); cap(); } union() { r1(); ring(); coil(); plug(); jack(); rx_pcb(); } }
if (part == "viz_lid") lid();
if (part == "viz_r1") r1();
if (part == "viz_ring") ring();
if (part == "viz_coil") coil();
if (part == "viz_plug") plug();
if (part == "viz_jack") jack();
if (part == "viz_rx") rx_pcb();
if (part == "assembly") { body(); lid(); color("steelblue") cap(); color("orangered") r1(); color("silver") ring(); color("peru") coil(); color("green") { plug(); jack(); rx_pcb(); } }
