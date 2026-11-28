// =====================================================================
//  Cat Cottage: a parametric outdoor cat house for 3D printing
//  Plain OpenSCAD (2021.01 or newer), no libraries.
//  Target printer: Bambu Lab H2D, single nozzle, 325 x 320 x 325 mm.
//
//  Units are mm. World axes: x = width (left/right), y = depth
//  (front is -y, back is +y), z = up. Floor top (the rib tops) is z = 0.
//
//  Render one part:   -D 'part="corner_fl"'   (see the list below)
//  Defaults assume a 40 x 40 cm (16 in) square cushion or a 40 cm round
//  pet bed, up to about 10 cm thick.
// =====================================================================

/* [What to render] */
// assembly, exploded, layout, or one printable part
part = "assembly"; // [assembly, exploded, layout, corner_fl, corner_fr, corner_bl, corner_br, roof_fl, roof_fr, roof_bl, roof_br, ridge_front, ridge_back, ridge_saddle, ridge_pair, seam_cap, door_surround, door_inner_ring, tunnel_body, tunnel_roof, tunnel_ramp, tunnel_ramp_roof, leg, center_leg, bowtie_key, fence_house_cleat, fence_post_cleat, fence_standoff, tree_plate, support_bracket, landing, latch_keeper, latch_button, window_retainer, hatch_frame, hatch_flap]
// Optional mount on one eave (long side) wall, so the door in the front gable stays reachable from the
// tree or fence. Anything but "none" adds bolt holes to the two corner modules on that side, drops the
// windows there and shortens the roof overhang on that side.
mount = "none"; // [none, tree, fence]
// Which eave wall carries the mount, seen from the front
mount_side = "right"; // [right, left]
// Preview only: show the cushion inside
show_cushion = true;
// Preview only: show the legs (you can use legs and a mount together)
show_legs = true;

/* [Cushion and interior] */
// Cushion width (x). 400 = 40 cm / 16 in square cushion or round bed
cushion_w = 400;
// Cushion depth (y)
cushion_d = 400;
// Preview only: cushion thickness
cushion_h = 80;
// Free space around the cushion
cushion_clear = 10;
// Interior height of the side walls above the floor
wall_h = 180;

/* [Shell] */
wt = 5;          // wall core thickness
slab_t = 5;      // floor slab thickness
rib_h = 8;       // floor ribs: the cushion sits on these, water drains under it; they also stiffen the floor
rib_w = 3;
rib_pitch = 35;
flange_d = 10;   // inner bolt flanges at the module seams
flange_t = 5;
gap = 0.15;      // half of the clearance at each seam
pitch = 30;      // roof pitch, degrees

/* [Siding and trim] */
relief = 3.5;    // how far trim boards stand proud of the wall core
clap = 2.5;      // lap-siding board butt thickness
clap_h = 20;     // lap-siding board height
batten_pitch = 25; // board-and-batten spacing in the gables
seam_cover = 12; // half-width of the batten that covers each seam
windows = true;  // decorative shuttered windows on the side walls

/* [Roof] */
roof_t = 6;
eave_ov = 50;    // overhang past the side walls
front_ov = 70;   // overhang past the front gable (shelters the door)
back_ov = 35;
shingle_e = 26;  // fish-scale shingle exposure
shingle_w = 30;
shingle_t = 2.6;
seam_h = 20;     // standing seam (20 mm makes it a rib that carries a 20 kg point load at mid-slope) that joins the front and back roof panels
seam_t = 4;
seam_cap = true;  // printed U-cap over each standing seam, so rain can't reach the joint from above
ridge_leg = 40;
ridge_t = 4;
rake_w = 14;

/* [Opening roof] */
// One roof slope lifts like a lid: a knuckle hinge on the other slope just below the ridge, and two
// turn-button latches on the gable ends. The lid is the slope away from the mount.
roof_hinge = true;
hinge_r = 5;         // knuckle radius
hinge_pin = 4.5;     // hole for a 4 mm stainless rod or M4 threaded rod
hinge_seg = 18;      // knuckle length
hinge_gap = 0.6;
hinge_stop = 134;    // stop-ear design angle: the lid comes to rest at about 118 degrees, past its ~111 degree balance point (126 stopped it at ~109; 2026-11-25)
latch_x = 150;       // keeper position from the centre line (on the lid side)
latch_pivot_x = 115; // turn-button pivot
latch_pivot_z = 204.5; // the tongue presses the keeper down 1.5 mm, compressing the foam seal under the lid
rib_u = 14;          // weather rib on the fixed slope, under the ridge cap, this far up-slope from the hinge axis

/* [Escape hatch] */
// One-way flap in the back wall: the cat can push it open from inside; from outside it only closes
// harder against its frame. Magnets and a gasket keep wind from rattling or lifting it.
hatch = true;
hatch_w = 140;       // clear opening
hatch_h = 140;
hatch_x = -100;      // centre of the opening (left half of the back wall)
hatch_z0 = 25;       // sill height above the floor
hatch_gasket = 1.5;  // closed-cell foam strip between the frame and the flap
hatch_magnet = [6.3, 3.2]; // pocket for 6 x 3 mm neodymium discs (use [8.3, 3.2] for 8 x 3 if wind lifts the flap)

/* [Peek window] */
// The windows are glazed, so you can see the cushion from outside.
peek_window = true;
peek_all = true;     // true: glaze every window (2 when mounted, 4 on legs); false: only the front one on the lid side
pane_alpha = 0.45;   // preview only: pane transparency
pane_t = 2;          // 2 mm UV-stable polycarbonate, cut to (win_w + 7) x (win_h + 7)
print_supports = true; // breakaway combs under the window heads, hatch top and door top, printed with the corners
bk_gap = 0.3;       // air gap between a comb and the surface it holds: one 0.30 mm layer
bk_t = 1.2;         // rib and spine thickness: two 0.6 mm lines
bk_pitch = 7;       // rib spacing: the surface bridges this far between ribs
bk_side = 1;        // clearance from the sides of the opening, so the slicer keeps the outlines apart
bk_tab_h = 0.6;     // tabs the comb stands on: two layers, snipped off afterwards
bk_tabs = true;     // false only for the clearance check
open_angle = 0;      // preview only: show the lid opened by this many degrees
hatch_open_angle = 0; // preview only: show the escape flap opened by this many degrees

/* [Entrance] */
door_d = 160;      // clear opening, fine for a 5 kg cat
door_sill = 40;    // sill height above the floor: keeps splash and the cushion in
surround_w = 28;
hood_depth = 45;   // rain hood over the entrance
sill_depth = 28;   // outside step / drip ledge
// Optional cornered entrance tunnel: replaces the door surround. The cat goes in at a mouth facing the
// mount side (on the landing when mounted), turns a corner and reaches the door, so wind can't drive rain
// straight in. Its roof slopes down towards the mouth to pass under the house's front overhang.
door_tunnel = false;
tun_wi = 150;       // inside width (out from the wall)
tun_t = 4;          // wall thickness
tun_floor_t = 6;    // floor thickness (20 kg on one spot past the landing's edge: see STRUCTURAL.md)
tun_roof_t = 6;     // roof plate under the shingles (a cat jumping onto it)
tun_end = -90;      // closed end, outer face (x, mount side positive); keeps clear of the roof-latch button
tun_run = 150;      // mouth (x): 150 keeps it dry up to 22 mph wind from any side (see RAIN.md)
tun_z0 = 204;       // top of the walls at the house wall, above the door centre line
tun_ax = 9;         // roof slope down towards the mouth (degrees)
tun_ay = 3;         // and outwards
tun_dir = "mount";  // [mount, away] mouth towards the mount (post or tree: the cat comes along the landing),
                    // or away from it (a wall: the landing moves to the free side and runs past the corner as a porch)
tun_ground = mount == "none";   // on legs the tunnel's outer half drops to the ground; mounted, it sits on the landing
tun_step_x = 90;                // on legs: where the ramp starts, just past the door
tun_ramp_a = 30;                // on legs: ramp angle down to the ground
tun_land_tilt = 1.5;            // on legs: the landing falls this much (degrees) towards the ramp, away from the door, so water drains
tun_ramp_end = 300;             // on legs: the ramp extension's mouth (x)
tun_ramp_ax = 20;               // on legs: the extension's roof slope, steeper so it passes under the house's eave
tun_skirt = "arches";          // [arches, lattice, big_arch] on legs: how the wall below the walking surface is opened
tun_siding = true;              // siding grooves and window trim on the tunnel's outer wall, to match the house
tun_windows = tun_ground;       // clear 2 mm polycarbonate windows in the outer wall (panes 88 x 88 mm); on by default for the on-legs tunnel
tun_lintel_z = 155; // underside of the lintel over the mouth (mouth clear height = this - door_sill - tun_floor_t)

/* [Legs and floor] */
leg_h = 60;
leg_foot_d = 84;     // wide foot for sand or soft soil (0 = the original narrow foot); 84 clears the ground-level tunnel
drain_d = 6;

/* [Mount] */
rail_len = 300;
// French cleat: the house cleat (on the house) hooks over the mount cleat (on the fence, or on the tree plate).
// Stack from the house wall to the mounting surface:
cleat_t = 30;
cleat_zh = 110;      // top of the 45 degree bevel at the house side
cleat_top = 148;     // top of the house cleat (just under the eave louvres)
standoff_z = [2, 46]; // lower standoff that bears on the mounting surface
cleat_bolt_z = [120, 138];
standoff_bolt_z = [12, 36];
lock_xs = [-95, 95]; // lock screws from inside: top through the house cleat, bottom through the standoff
lock_z = [129, 24];
tree_back_t = 25;    // tree plate backing behind the cleat; V-groove and strap channels on its back
tree_plate_bottom = -160; // the plate runs below the house so the support brackets can bolt to it
strap_w = 26;        // 25 mm ratchet strap or hose clamps
strap_t = 6;
// Support brackets under the floor when mounted (required): see STRUCTURAL.md
show_brackets = true;
brackets = "steel";  // [steel, printed] bought steel shelf brackets, or the printable support_bracket (print 2)
bracket_arm = 305;   // 12 in shelf bracket
bracket_leg = 200;   // 8 in
pb_arm = 300;        // printed bracket: arm length from the mounting surface
pb_leg = 200;        // upright height under the floor
pb_flange = 12;      // thickness of the arm and upright flanges
pb_w = 36;           // flange width (the print height)
pb_web = 7;          // web on one side of the flanges
bracket_screw_z = [-40, -95, -145]; // screws or M5 bolts through the upright (matches the tree plate)
bracket_bolt_d = [220, 280];        // M6 bolts up through the floor's centre-leg holes, from the mounting surface
mount_eave_ov = 15; // roof overhang on the mount side, so the eave clears the post or trunk
// L-shaped landing ledge at door-sill height, from beside the mount around the front corner to the door
landing = true;      // only used when mount is not "none"
landing_w = 95;      // walking width
landing_t = 8;
landing_x0 = 8;      // runs to the middle of the door (the lowest point of the opening); replaces the door step
// the ledge ends flush with the mounting surface (wall, fence board, post or trunk), never past it

/* [Hardware clearances] */
m4 = 4.5;
m5 = 5.5;
m6 = 6.5;
pilot = 3.4;       // for #8 / 4.2 mm stainless self-tapping screws
screw_clear = 4.8;

/* [Printer] */
bed = [325, 320, 325]; // Bambu Lab H2D, single nozzle

/* [Hidden] */
$fn = 48;
iw = cushion_w + 2*flange_d + cushion_clear;   // interior width
idp = cushion_d + 2*flange_d + cushion_clear;  // interior depth
hx = iw/2 + wt;
hy = idp/2 + wt;
zb = -(slab_t + rib_h);
tp = tan(pitch);
function roof_z(x) = wall_h + (hx - abs(x))*tp;
apex = roof_z(0);
x_eave = hx + eave_ov;
z_eave = wall_h - eave_ov*tp;
yf = -(hy + front_ov);
yb = hy + back_ov;
ysplit = (yf + yb)/2;
door_r = door_d/2;
door_z = door_sill + door_r;
R_out = door_r + surround_w;
Lu = (x_eave + roof_t + shingle_t)/cos(pitch) + 2;
Lsh = x_eave/cos(pitch) - ridge_leg - 4;
u_ridge = Lsh + 4 + ridge_leg/2;
// per-side eave (the mount side gets a short overhang)
mount_sx = mount_side == "left" ? -1 : 1;
function eave_of(sx) = (mount != "none" && sx == mount_sx) ? mount_eave_ov : eave_ov;
function xe(e) = hx + e;
function ze(e) = wall_h - e*tp;
function Lu_e(e) = (xe(e) + roof_t + shingle_t)/cos(pitch) + 2;
function Lsh_e(e) = xe(e)/cos(pitch) - ridge_leg - 4;
function u_ridge_e(e) = Lsh_e(e) + 4 + ridge_leg/2;
function roof_len_e(e) = (xe(e) + roof_t*sin(pitch))/cos(pitch) + 1;
landing_on = landing && mount != "none";
landing_bolt_xs = [115, 165, 201];
// the side the landing (and the tunnel's mouth) is on
entry_sx = (door_tunnel && tun_dir == "away") ? -mount_sx : mount_sx;
landing_x_end = entry_sx == mount_sx ? hx + cleat_t - 1 : hx + 80;   // away from a wall it runs past the corner as a porch
landing_bolt_z = 26;
lid_sx = mount != "none" ? -mount_sx : -1;   // the slope that opens
hinge_sx = -lid_sx;                           // the slope that carries the hinge
hinge_on = roof_hinge;
function u_ax() = Lsh_e(eave_of(hinge_sx)) + 6;
w_ax = roof_t + hinge_r + 0.5;
// knuckle segments along one ridge-cap length: [start, end, owner] with owner 0 = fixed panel, 1 = lid (cap)
function hinge_segs(v0, v1) = let(n0 = floor((v1 - v0 - 20 + hinge_gap)/(hinge_seg + hinge_gap)),
    n = n0 % 2 == 1 ? n0 : n0 - 1, len = n*(hinge_seg + hinge_gap) - hinge_gap, a = (v0 + v1 - len)/2)
  [for (i = [0 : n - 1]) [a + i*(hinge_seg + hinge_gap), a + i*(hinge_seg + hinge_gap) + hinge_seg, i % 2]];
function win_on(f) = windows && !(mount != "none" && f == (mount_sx > 0 ? 2 : 3));
rib_xs = [for (k = [1:30]) if (5 + k*rib_pitch < iw/2 - 6) 5 + k*rib_pitch];
leg_xy = [iw/2 - 35, idp/2 - 35];
key_xk = iw/4;
key_yk = idp/4;
vz0 = wall_h + 14;          // bottom of the gable louvres
win_zc = 85;
win_w = 70;
win_h = 90;
mount_holes = mount != "none";
// roof screws for the left slope (mirrored for the right): gable cores, then eave corbels
roof_screws_left = concat(
  [for (s = [40, 140, 195], sy = [-1, 1]) [-s, sy*(idp/2 + 1.5)]],
  [for (y = [-(idp/2 - 40), -35, 35, idp/2 - 40]) [-(hx - wt/2), y]]
);
corbel_ys = [-(idp/2 - 40), -35, 35, idp/2 - 40];
rail_xs = [-130, -60, 60, 130];

// ---- fit checks ------------------------------------------------------
module_h = apex - zb;
module_w = hx + relief + 4 + seam_cover;
roof_len = (x_eave + (roof_t)*sin(pitch))/cos(pitch) + 1;
roof_dep = (yb - yf)/2;
assert(module_h <= bed[2], str("Corner modules are ", module_h, " mm tall; the bed allows ", bed[2]));
assert(module_w <= bed[1], str("Corner modules are ", module_w, " mm wide; the bed allows ", bed[1]));
assert(roof_len <= bed[0] && roof_dep <= bed[1], str("Roof panels are ", roof_len, " x ", roof_dep));
echo(str("Interior ", iw, " x ", idp, " mm; corner module ", module_w, " x ", module_w, " x ", module_h,
         " mm; roof panel ", roof_len, " x ", roof_dep, " mm"));

// =====================================================================
//  Helpers
// =====================================================================
module slope_frame(e = eave_ov) translate([-xe(e), 0, ze(e)]) rotate([0, -pitch, 0]) children();
module unslope_left(e = eave_ov) rotate([0, pitch, 0]) translate([xe(e), 0, -ze(e)]) children();
module unslope_right(e = eave_ov) rotate([0, -pitch, 0]) translate([-xe(e), 0, -ze(e)]) children();
// mount frame: local y = outward from the mount wall, local x = along it
// frame of the slope on world side sx (-1 left, +1 right): local u up the slope, w out of the roof
module side_frame(sx) scale([sx < 0 ? 1 : -1, 1, 1]) slope_frame(eave_of(sx)) children();
module mount_xf() translate([mount_sx*hx, 0, 0]) rotate([0, 0, mount_sx > 0 ? -90 : 90]) children();
module screw_xf(p) translate([p[0], p[1], roof_z(p[0])]) rotate([0, -pitch, 0]) children();

// Face frame: local x = along the wall, local y = outward, z = up.
// f: 0 front, 1 back, 2 right, 3 left
module face_xf(f) {
  if (f == 0) translate([0, -hy, 0]) rotate([0, 0, 180]) children();
  if (f == 1) translate([0, hy, 0]) children();
  if (f == 2) translate([hx, 0, 0]) rotate([0, 0, -90]) children();
  if (f == 3) translate([-hx, 0, 0]) rotate([0, 0, 90]) children();
}
function face_len(f) = f < 2 ? 2*hx : 2*hy;

// prism along local x, centred, section given as [outward, z] points
module prism_a(len, pts) translate([-len/2, 0, 0]) rotate([90, 0, 90]) linear_extrude(len) polygon(pts);

module teardrop2d(r) intersection() {
  hull() { circle(r, $fn = 120); translate([0, r*sqrt(2)]) square(0.01, center = true); }
  translate([-2*r, -2*r]) square([4*r, 3*r]);
}

// slanted louvre slot through a wall (outside opening lower than inside). The slats slope at about 56 degrees,
// steeper than 45, because their thin undersides sagged at 45 degrees on the first corners (2026-11-27).
louvre_k = 1.5;  // rise per mm of depth: tan of the slats' angle from horizontal
module louvre(a0, w, z0, h)
  multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [0, -louvre_k, 1, 0], [0, 0, 0, 1]])
    translate([a0, -wt - 1, z0]) cube([w, wt + relief + 4, h]);

module bowtie2d() polygon([[-25, -15], [0, -8], [25, -15], [25, 15], [0, 8], [-25, 15]]);

module envelope() rotate([90, 0, 0]) linear_extrude(height = 1200, center = true)
  polygon([[-500, zb - 60], [500, zb - 60], [500, roof_z(500)], [0, apex], [-500, roof_z(500)]]);

module quadrant(sx, sy)
  translate([sx > 0 ? gap : -600, sy > 0 ? gap : -600, -200]) cube([600 - gap, 600 - gap, 900]);

// =====================================================================
//  House body (whole house, before it is cut into four corner modules)
// =====================================================================
module shell() difference() {
  translate([-hx, -hy, zb]) cube([2*hx, 2*hy, apex - zb + 10]);
  translate([-iw/2, -idp/2, zb + slab_t]) cube([iw, idp, 600]);
}

module ribs() for (s = [-1, 1], x = rib_xs)
  translate([s*x - rib_w/2, -idp/2, zb]) cube([rib_w, idp, slab_t + rib_h]);

// sloped seats under the roof, inside the gables (45 degree undersides print without support)
module rafters() for (sx = [-1, 1], sy = [-1, 1]) scale([sx, sy, 1])
  translate([-hx, 0, wall_h]) rotate([0, -pitch, 0]) rotate([90, 0, 90])
    linear_extrude(hx/cos(pitch) + 2)
      polygon([[-idp/2 - 1, 1], [-idp/2 + 20, 1], [-idp/2 - 1, -21]]);

module wall_plates() {
  x3 = hx - wt - 16; z3 = roof_z(x3);
  for (sx = [-1, 1]) scale([sx, 1, 1]) rotate([90, 0, 0]) linear_extrude(height = idp, center = true)
    polygon([[x3, z3 + 2], [x3, z3], [hx - wt, z3 - 16], [hx - 0.5, z3 - 16], [hx - 0.5, wall_h + 2]]);
  // deeper corbels where the eave screws go in
  xc = hx - wt - 50; zc = roof_z(xc);
  for (sx = [-1, 1], y = corbel_ys) scale([sx, 1, 1]) translate([0, y, 0]) rotate([90, 0, 0])
    linear_extrude(height = 24, center = true)
      polygon([[xc, zc + 2], [xc, zc], [hx - wt, zc - 50], [hx - 0.5, zc - 50], [hx - 0.5, wall_h + 2]]);
}

// V-groove lap boards: the 45 degree chamfers print without support and read as shadow lines
module clapboards(len, ztop)
  for (z0 = [zb : clap_h : ztop])
    prism_a(len, [[0, z0], [0.4, z0], [clap, z0 + clap - 0.4], [clap, z0 + clap_h - clap + 0.4],
                  [0.4, z0 + clap_h], [0, z0 + clap_h]]);

module gable_battens(len)
  for (a = [-floor(len/2/batten_pitch)*batten_pitch : batten_pitch : len/2])
    translate([a - 2, 0, wall_h]) cube([4, 2, apex - wall_h + 10]);

module belt(len)
  prism_a(len + 2*relief, [[0, wall_h - relief], [relief, wall_h], [relief, wall_h + 8], [0, wall_h + 8 + relief]]);

module base_band(len)
  prism_a(len + 2*relief, [[0, zb], [relief, zb], [relief, zb + 14], [0, zb + 14 + relief]]);

module corner_trims(f, len) for (s = [-1, 1])
  translate([s > 0 ? len/2 - 22 : -len/2 - relief, 0, zb])
    cube([22 + relief, relief, (f < 2 ? wall_h : wall_h + 10) - zb]);

module window_clear(ac) translate([ac - 76, 0.01, win_zc - win_h/2 - 14]) cube([152, 12, win_h + 36]);

module window(ac) {
  zt = win_zc + win_h/2 + 6;
  zs = win_zc - win_h/2 - 6;
  difference() {
    translate([ac - win_w/2 - 6, 0, zs]) cube([win_w + 12, relief, win_h + 12]);
    translate([ac - win_w/2, -1, win_zc - win_h/2]) cube([win_w, 10, win_h]);
  }
  translate([ac - 2, 0, win_zc - win_h/2]) cube([4, 2.5, win_h]);
  translate([ac - win_w/2, 0, win_zc - 2]) cube([win_w, 2.5, 4]);
  // drip cap: sloped top sheds water, 45 degree underside
  translate([ac, 0, 0]) prism_a(win_w + 24, [[0, zt - 5], [5, zt], [5, zt + 3], [0, zt + 8]]);
  // sill: top slopes away from the wall
  translate([ac, 0, 0]) prism_a(win_w + 20, [[0, zs - 7], [7, zs], [0, zs + 3]]);
  // shutters with louvre grooves; each groove's top slopes at 45 degrees so it prints without sagging
  for (s = [-1, 1]) translate([ac + s*(win_w/2 + 6 + 3 + 14) - 14, 0, win_zc - win_h/2])
    difference() {
      cube([28, 2.5, win_h]);
      for (gz = [6 : 7 : win_h - 8]) translate([14, 0, 0])
        prism_a(22, [[1.5, gz], [3.5, gz], [3.5, gz + 3], [1.5, gz + 1]]);
    }
}

module vent_clear(ac) translate([ac - 30, 0.01, vz0 - 6]) cube([60, 12, 52]);

module vent_frame(ac) {
  difference() {
    translate([ac - 24, 0, vz0 - 4]) cube([48, relief, 38.5]);
    translate([ac - 20, -1, vz0]) cube([40, 10, 30.5]);
  }
  translate([ac, 0, 0]) prism_a(56, [[0, vz0 + 34.5 - 5], [5, vz0 + 34.5], [0, vz0 + 34.5 + 6]]);
}

module face_dressing(f) {
  len = face_len(f);
  difference() {
    union() {
      clapboards(len, f < 2 ? wall_h : wall_h + 10);
      if (f < 2) { gable_battens(len); belt(len); }
      base_band(len);
      corner_trims(f, len);
    }
    if (f >= 2 && win_on(f)) for (ac = [-hy/2, hy/2]) window_clear(ac);
    if (f == 1) for (ac = [-75, 75]) vent_clear(ac);
  }
  if (f >= 2 && win_on(f)) for (ac = [-hy/2, hy/2]) window(ac);
  if (f == 1) for (ac = [-75, 75]) vent_frame(ac);
}

module body() union() {
  shell();
  ribs();
  rafters();
  wall_plates();
  for (f = [0:3]) face_xf(f) face_dressing(f);
}

// =====================================================================
//  Corner modules
// =====================================================================
module seam_parts(sx, sy) {
  // side seam flange (y = 0)
  translate([sx > 0 ? iw/2 - flange_d : -iw/2 - 0.5, sy > 0 ? gap : -gap - flange_t, zb])
    cube([flange_d + 0.5, flange_t, wall_h - 20 - zb]);
  // front/back seam flange (x = 0)
  translate([sx > 0 ? gap : -gap - flange_t, sy > 0 ? idp/2 - flange_d : -idp/2 - 0.5, zb])
    cube([flange_t, flange_d + 0.5, apex - zb + 5]);
  // floor seam ribs
  translate([sx > 0 ? gap : -gap - rib_w, sy > 0 ? 0 : -idp/2, zb]) cube([rib_w, idp/2, slab_t + rib_h]);
  translate([sx > 0 ? 0 : -iw/2, sy > 0 ? gap : -gap - rib_w, zb]) cube([iw/2, rib_w, slab_t + rib_h]);
  // leg bosses
  translate([sx*leg_xy[0], sy*leg_xy[1], zb]) cylinder(d = 24, h = slab_t + rib_h);
  translate([sx*30, sy*30, zb]) cylinder(d = 18, h = slab_t + rib_h);
  // seam battens: left modules cover the front/back seams, front modules cover the side seams
  if (sx < 0) translate([-seam_cover, sy < 0 ? -hy - relief : hy, zb])
    cube([2*seam_cover, relief, apex - zb + 10]);
  if (sy < 0) translate([sx < 0 ? -hx - relief : hx, -seam_cover, zb])
    cube([relief, 2*seam_cover, wall_h + 10 - zb]);
}

function drain_pts(sx, sy) = [
  for (x = [5 + rib_pitch/2 : rib_pitch : iw/2 - 8], y = [20 : 35 : idp/2 - 8])
    if (norm([x - leg_xy[0], y - leg_xy[1]]) > 18 && norm([x - 30, y - 30]) > 16
        && !(abs(x - key_xk) < 22 && y < 32) && !(abs(y - key_yk) < 22 && x < 32))
      [sx*x, sy*y]
];

module door_cut() translate([0, -hy, door_z]) rotate([90, 0, 0])
  linear_extrude(height = 80, center = true) teardrop2d(door_r + 4);

module module_cuts(sx, sy) {
  if (sy < 0) {
    door_cut();
    // clear the siding where the door surround sits
    translate([0, -hy - 0.01, door_z]) rotate([90, 0, 0]) cylinder(r = R_out + 2, h = relief + 8, $fn = 120);
    // clear the inner flange where the inner ring sits
    translate([0, -idp/2 + 0.01, door_z]) rotate([-90, 0, 0]) cylinder(r = R_out + 2, h = flange_d + 1, $fn = 120);
    // 45 degree undersides where the seam flange and (left modules) the seam batten resume above the door,
    // so neither starts as a flat overhang at the seam
    let(ct = door_z + R_out + 2) {
      translate([-gap - flange_t - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(2*(gap + flange_t + 1))
        polygon([[-idp/2 - 0.6, ct - 1], [-idp/2 + flange_d + 1.5, ct - 1], [-idp/2 + flange_d + 1.5, ct + flange_d + 1.5],
                 [-idp/2 - 0.6, ct - 0.6]]);
      if (sx < 0) translate([0, -hy + 0.01, 0]) rotate([90, 0, 0]) linear_extrude(relief + 1)
        polygon([[0, ct - 1], [seam_cover + 1, ct - 1], [seam_cover + 1, ct + seam_cover + 1], [0, ct]]);
    }
  }
  if (sy > 0) face_xf(1) for (ac = [-75, 75], i = [0:4]) louvre(ac - 20, 40, vz0 + i*6.5, 3.5);
  face_xf(sx > 0 ? 2 : 3) for (ac = [-hy/2, hy/2], i = [0:2]) louvre(ac - 30, 60, 151 + i*6.5, 3.5);
  // floor drains
  for (p = drain_pts(sx, sy)) translate([p[0], p[1], zb - 1]) cylinder(d = drain_d, h = slab_t + 2, $fn = 16);
  // bowtie key pockets
  for (s = [-1, 1]) {
    translate([0, s*key_yk, zb - 1]) linear_extrude(slab_t + rib_h + 2) offset(delta = 0.15) bowtie2d();
    translate([s*key_xk, 0, zb - 1]) rotate([0, 0, 90]) linear_extrude(slab_t + rib_h + 2) offset(delta = 0.15) bowtie2d();
  }
  // leg bolts, countersunk from inside
  for (p = [[sx*leg_xy[0], sy*leg_xy[1]], [sx*30, sy*30]]) translate([p[0], p[1], 0]) {
    translate([0, 0, zb - 1]) cylinder(d = m6, h = 20);
    translate([0, 0, -3.5]) cylinder(d1 = m6, d2 = 13.5, h = 3.51);
  }
  // seam bolts
  for (z = [25, 80, 135]) translate([sx*(iw/2 - flange_d/2), 0, z]) rotate([90, 0, 0]) cylinder(d = m4, h = 30, center = true);
  for (z = (sy < 0 ? [5, 245, 280] : [5, 65, 125, 185, 245, 280]))
    translate([0, sy*(idp/2 - flange_d/2), z]) rotate([0, 90, 0]) cylinder(d = m4, h = 30, center = true);
  // pilot holes for the roof screws
  for (s = [-1, 1], p = roof_screws_left) scale([s, 1, 1]) screw_xf(p) translate([0, 0, -22]) cylinder(d = pilot, h = 23, $fn = 16);
  // room for the neighbour's seam batten
  if (sx > 0) translate([-0.01, sy < 0 ? -hy - 12 : hy + 0.01, zb - 1]) cube([seam_cover + 0.4, 12 - 0.01, 600]);
  if (sy > 0) translate([sx > 0 ? hx + 0.01 : -hx - 12, -0.01, zb - 1]) cube([12 - 0.01, seam_cover + 0.4, 600]);
  // glazed peek window: opening through the wall core, a pocket for the pane on the inside, 4 clamp bolts
  if (peek_on(sx, sy)) face_xf(sx < 0 ? 3 : 2) let(ac = peek_ac(sx, sy)) {
    translate([ac - win_w/2, -wt - 1, win_zc - win_h/2]) cube([win_w, wt + 1.01, win_h]);
    translate([ac - win_w/2 - 4, -wt - 1, win_zc - win_h/2 - 4]) cube([win_w + 8, 1 + pane_t, win_h + 8]);
    for (dx = [-1, 1], dz = [-1, 1]) translate([ac + dx*(win_w/2 + 3), -wt - 1, win_zc + dz*(win_h/2 - 10)])
      rotate([-90, 0, 0]) cylinder(d = 3.4, h = wt + relief + 3, $fn = 12);
  }
  // escape hatch: opening, flat pad for the frame, frame bolts
  if (hatch && sy > 0 && sx * hatch_x > 0) {
    // opening with 45 degree top corners, hidden behind the frame: its 98 mm top stands on a breakaway comb (print_supports)
    translate([0, hy + 19, 0]) rotate([90, 0, 0]) linear_extrude(wt + 20)
      polygon([[hx0, hatch_z0], [hx1, hatch_z0], [hx1, hz1 - 21], [hx1 - 21, hz1], [hx0 + 21, hz1], [hx0, hz1 - 21]]);
    translate([hf[0] - 1, hy + 0.01, hatch_z0 - 13]) cube([hf[1] - hf[0] + 2, 12, hz1 + 23 - (hatch_z0 - 13)]);
    for (b = hatch_bolts) translate([b[0], hy - wt - 1, b[1]]) rotate([-90, 0, 0]) cylinder(d = m4, h = wt + 10, $fn = 16);
  }
  // turn-button pivots on the lid side of both gables
  if (hinge_on && sx == lid_sx) translate([sx*latch_pivot_x, sy*hy, latch_pivot_z]) rotate([90, 0, 0])
    cylinder(d = m4, h = 3*wt + 10, center = true, $fn = 16);
  // landing ledge: flat pads and bolt holes on the front-corner module of the mount side
  if (landing_on && sx == entry_sx && sy < 0) scale([entry_sx, 1, 1]) {
    translate([76, -hy - 15, zb - 1]) cube([hx + 20 - 76, 15 - 0.01, door_sill + 1 - zb + 1]);
    for (x = landing_bolt_xs) translate([x, -hy - 10, landing_bolt_z]) rotate([-90, 0, 0]) cylinder(d = m5, h = wt + 20, $fn = 16);
  }
  // mount on the eave wall: flat pads for the house cleat and the standoff, bolt and lock-screw holes
  if (mount_holes && sx == mount_sx) mount_xf() {
    for (b = [[standoff_z[0] - 1, standoff_z[1] + 1], [cleat_zh - 1, cleat_top + 1]])
      translate([-rail_len/2 - 2, 0.01, b[0]]) cube([rail_len + 4, 12, b[1] - b[0]]);
    for (x = rail_xs, z = concat(cleat_bolt_z, standoff_bolt_z)) translate([x, -wt - 1, z]) rotate([-90, 0, 0]) cylinder(d = m5, h = wt + 20);
    for (x = lock_xs, z = lock_z) translate([x, -wt - 1, z]) rotate([-90, 0, 0]) cylinder(d = 5.2, h = wt + 20);
  }
}

module corner(sx, sy) difference() {
  union() {
    intersection() { body(); quadrant(sx, sy); envelope(); }
    intersection() { seam_parts(sx, sy); envelope(); }
  }
  module_cuts(sx, sy);
}

// =====================================================================
//  Roof
// =====================================================================
module shingles(vA, vB, Lsh) {
  r = (shingle_w - 2)/2;
  for (k = [0 : ceil(Lsh/shingle_e) - 1]) {
    u0 = k*shingle_e;
    u1 = min((k + 1)*shingle_e + r, Lsh);
    if (u1 > u0 + 1) intersection() {
      hull() {
        translate([u0, vA, roof_t - 0.01]) cube([0.01, vB - vA, shingle_t]);
        translate([u1 - 0.01, vA, roof_t - 0.01]) cube([0.01, vB - vA, 0.6]);
      }
      translate([0, 0, roof_t - 0.1]) linear_extrude(shingle_t + 0.2) intersection() {
        translate([u0, vA]) square([u1 - u0, vB - vA]);
        for (j = [-1 : ceil((vB - vA)/shingle_w) + 1]) hull() {
          vc = vA + (j + (k % 2)*0.5)*shingle_w;
          translate([u0 + r, vc]) circle(r = r, $fn = 32);
          translate([u0 + r, vc - r]) square([shingle_e + 0.01, 2*r]);
        }
      }
    }
  }
}

module panel_local(v0, v1, front, e, holes = true) {
  Lu = Lu_e(e);
  Lsh = Lsh_e(e);
  vA = front ? v0 + rake_w : v0 + seam_t;
  vB = front ? v1 - seam_t : v1 - rake_w;
  translate([0, v0, 0]) cube([Lu, v1 - v0, roof_t]);
  shingles(vA, vB, Lsh);
  // rake board along the gable edge
  translate([0, front ? v0 : v1 - rake_w, roof_t - 0.01]) cube([Lsh, rake_w, shingle_t + 1]);
  // standing seam
  difference() {
    translate([0, front ? v1 - seam_t : v0, roof_t - 0.01]) hull() {
      translate([6, 0, 0]) cube([Lsh - 8, seam_t, seam_h]);
      cube([1, seam_t, 2]);
    }
    if (holes) for (u = [40, Lsh/2, Lsh - 30]) translate([u, front ? v1 : v0, roof_t + 10])
      rotate([90, 0, 0]) cylinder(d = m4, h = 3*seam_t, center = true);
  }
}

// Seam cap (slope frame): an inverted U that slips over the two upstands of a standing seam and is held by
// the seam's own bolts. With a silicone bead between the upstands that makes two seals in a row.
seam_cap_cl = 0.15;   // was 0.4: the test print measured 0.8 mm of play in total (2026-11-25)
seam_cap_wall = 2;
function seam_cap_zb() = roof_t + shingle_t + 0.6;   // walls stop just above the shingles
module seam_profile(Lsh) polygon([[0, roof_t], [0, roof_t + 2], [1, roof_t + 2], [6, roof_t + seam_h], [Lsh - 2, roof_t + seam_h], [Lsh - 2, roof_t]]);
module seam_cap_local(e) {
  Lsh = Lsh_e(e);
  hi = seam_t + gap + seam_cap_cl;   // inner half-width
  module ext(w) translate([0, ysplit, 0]) rotate([90, 0, 0]) linear_extrude(2*w, center = true) children();
  difference() {
    intersection() {
      ext(hi + seam_cap_wall) offset(r = seam_cap_cl + seam_cap_wall, $fn = 16) seam_profile(Lsh);
      translate([-50, ysplit - 50, seam_cap_zb()]) cube([Lsh + 100, 100, 100]);
    }
    ext(hi) offset(delta = seam_cap_cl) seam_profile(Lsh);
    for (u = [40, Lsh/2, Lsh - 30]) translate([u, ysplit, roof_t + 10]) rotate([90, 0, 0]) cylinder(d = m4 + 0.2, h = 40, center = true, $fn = 16);
  }
}
module seam_cap_print(e) {
  W = seam_t + gap + seam_cap_cl + seam_cap_wall;
  wtop = roof_t + seam_h + seam_cap_cl + seam_cap_wall;
  translate([seam_cap_cl + seam_cap_wall, ysplit + W, wtop]) rotate([180, 0, 0]) seam_cap_local(e);
}

function ridge_hole_vs(front) = front ? [yf + 30, (yf + ysplit)/2, ysplit - 14] : [ysplit + 14, (ysplit + yb)/2, yb - 30];

// holes = false only for the open-lid preview, where OpenSCAD's preview mis-draws the holed underside
module roof_panel(sx, sy, holes = true) {
  front = sy < 0;
  v0 = front ? yf : ysplit + gap;
  v1 = front ? ysplit - gap : yb;
  e = eave_of(sx);
  is_lid = hinge_on && sx == lid_sx;
  is_hinge = hinge_on && sx == hinge_sx;
  scale([-sx, 1, 1]) difference() {
    union() {
      intersection() {
        slope_frame(e) panel_local(v0, v1, front, e, holes);
        // the lid's ridge edge stops 4 mm short so it clears the fixed slope as it swings open
        translate([-350, -330, 100]) cube([350 - (is_lid ? 4 : 0), 660, 300]);
      }
      // screw pads on the fixed slope only: the lid is held by its hinge and latches, so it has no storm screws
      // (not the gable screw nearest the ridge on the hinge slope: its pad would sit under the ridge cap's knuckles)
      if (!is_lid) for (p = roof_screws_left) if (p[1] > v0 + 5 && p[1] < v1 - 5 && !(is_hinge && abs(p[0]) < 50))
        screw_xf(p) translate([0, 0, roof_t - 0.2]) cylinder(d = 16, h = shingle_t + 0.8);
      if (is_hinge) slope_frame(e) panel_knuckles(v0, v1);
      // weather rib under the ridge cap: wind-driven rain can't creep past it to the ridge gap
      if (is_hinge) slope_frame(e) translate([u_ax() + rib_u - 1.5, v0, roof_t - 0.1]) cube([3, v1 - v0, 2.1]);
      if (is_lid) for (p = keeper_screws(front)) screw_xf(p) translate([0, 0, roof_t - 0.2]) cylinder(d = 16, h = shingle_t + 0.8);
    }
    if (holes && !is_lid) for (p = roof_screws_left) if (!(is_hinge && abs(p[0]) < 50)) screw_xf(p) translate([0, 0, -1]) cylinder(d = screw_clear, h = roof_t + shingle_t + 5, $fn = 16);
    if (holes) if (!is_hinge) for (v = ridge_hole_vs(front)) slope_frame(e) translate([u_ridge_e(e), v, -1]) cylinder(d = m4, h = roof_t + 20, $fn = 16);
    if (is_hinge) slope_frame(e) translate([u_ax(), 0, w_ax]) rotate([90, 0, 0]) cylinder(d = hinge_pin, h = 1200, center = true, $fn = 20);
    if (holes) if (is_lid) for (p = keeper_screws(front)) screw_xf(p) translate([0, 0, -1]) cylinder(d = screw_clear, h = roof_t + shingle_t + 5, $fn = 16);
  }
}

// fixed-slope knuckles (slope frame of that panel, before mirroring)
module panel_knuckles(v0, v1) for (sg = hinge_segs(v0, v1)) if (sg[2] == 0) translate([u_ax(), sg[0], 0]) {
  translate([-hinge_r, 0, roof_t - 0.1]) cube([2*hinge_r, sg[1] - sg[0], w_ax - roof_t + 0.1]);
  translate([0, 0, w_ax]) rotate([-90, 0, 0]) cylinder(r = hinge_r, h = sg[1] - sg[0], $fn = 32);
}

// lid-side knuckles on the ridge cap, with stop ears that land on the fixed slope at hinge_stop degrees
// (slope frame of the fixed side: u up the slope, w out of the roof; opening turns u towards w)
module cap_knuckles(v0, v1) {
  t0 = roof_t + 0.2;
  for (sg = hinge_segs(v0, v1)) if (sg[2] == 1) {
    L = sg[1] - sg[0];
    hull() {
      translate([u_ax(), sg[0], w_ax]) rotate([-90, 0, 0]) cylinder(r = hinge_r, h = L, $fn = 32);
      translate([u_ax() + hinge_r + 2, sg[0], t0]) cube([0.1, L, ridge_t]);
    }
    translate([u_ax(), sg[0], w_ax]) rotate([0, -(196.6 - hinge_stop), 0]) translate([0, 0, -3]) cube([14, L, 6]);
  }
}

// screws run along the roof normal, which leans towards the ridge, so they sit towards the eave side
function keeper_screws(front) = [for (x = [latch_x - 2, latch_x + 8]) [-x, (front ? -1 : 1)*(hy + 10)]];

// hinge axis in world coordinates, and the preview transform that swings the lid open
function ax_xl() = let(e = eave_of(hinge_sx)) -xe(e) + u_ax()*cos(pitch) - w_ax*sin(pitch);
function ax_x() = hinge_sx > 0 ? -ax_xl() : ax_xl();
function ax_z() = let(e = eave_of(hinge_sx)) ze(e) + u_ax()*sin(pitch) + w_ax*cos(pitch);
module lid_open(a = open_angle) translate([ax_x(), 0, ax_z()]) rotate([0, hinge_sx*a, 0]) translate([-ax_x(), 0, -ax_z()]) children();

// Latch keeper: hangs under the lid's gable overhang, screwed through the lid with two roofing screws.
// Built for a lid on the left and the front gable; mirrored as needed.
module latch_keeper_world(front = true) scale([lid_sx < 0 ? 1 : -1, front ? 1 : -1, 1]) difference() {
  intersection() {
    translate([0, -hy - 4.5, 0]) rotate([90, 0, 0]) linear_extrude(11.5)
      polygon([[-latch_x - 12, 193], [-latch_pivot_x - 11, 193], [-latch_pivot_x - 11, 199],
               [-latch_x + 12, 199], [-latch_x + 12, 300], [-latch_x - 12, 300]]);
    envelope();
  }
  for (p = keeper_screws(true)) screw_xf(p) translate([0, 0, -15]) cylinder(d = pilot, h = 16, $fn = 16);
}

// Turn button on the gable wall: closed, its tongue lies over the keeper's foot; turned up, the lid is free.
module latch_button_world(front = true, open = false) scale([lid_sx < 0 ? 1 : -1, front ? 1 : -1, 1])
  translate([-latch_pivot_x, -hy - 2.2, latch_pivot_z]) rotate([90, 0, 0]) rotate([0, 0, open ? -90 : 0]) latch_button_local();

// local: wall face at z = 0, outward +z, tongue along -x
module latch_button_local() difference() {
  union() {
    cylinder(r = 9, h = 6, $fn = 40);
    translate([-21, -4, 0]) cube([21, 8, 6]);
    translate([-20, -1.5, 5.9]) cube([24, 3, 3.5]);   // finger grip
  }
  translate([0, 0, -1]) cylinder(d = m4, h = 20, $fn = 16);
  translate([0, 0, 6 - 2]) cylinder(d = 9, h = 10, $fn = 24);   // recess for the washer and nyloc nut
}

// inner frame that clamps the window pane into its pocket (M3 bolts, nuts in pockets on the room side)
module window_retainer() difference() {
  translate([-win_w/2 - 10, -win_h/2 - 10, 0]) cube([win_w + 20, win_h + 20, 3]);
  translate([-win_w/2, -win_h/2, -1]) cube([win_w, win_h, 5]);
  for (dx = [-1, 1], dz = [-1, 1]) translate([dx*(win_w/2 + 3), dz*(win_h/2 - 10), 0]) {
    translate([0, 0, -1]) cylinder(d = 3.4, h = 5, $fn = 12);
    translate([0, 0, 1]) cylinder(r = 5.5/sqrt(3) + 0.2, h = 5, $fn = 6);
  }
}
// which corner modules get a glazed window, and where it sits along that wall (face frame)
function peek_on(sx, sy) = peek_window && win_on(sx < 0 ? 3 : 2) && (peek_all || (sx == lid_sx && sy < 0));
function peek_ac(sx, sy) = (sx < 0 ? -1 : 1) * (sy < 0 ? 1 : -1) * hy/2;
// panes and retainers in place (preview)
module peek_window_world() for (sx = [-1, 1], sy = [-1, 1]) if (peek_on(sx, sy)) face_xf(sx < 0 ? 3 : 2) let(ac = peek_ac(sx, sy)) {
  color("#BFE3F0", pane_alpha) translate([ac - win_w/2 - 3.5, -wt + 0.01, win_zc - win_h/2 - 3.5]) cube([win_w + 7, pane_t - 0.02, win_h + 7]);
  color(c_trim) translate([ac, -wt, win_zc]) rotate([90, 0, 0]) window_retainer();
}

// ---- escape hatch (world coordinates, back wall outer face at y = hy) ----
hx0 = hatch_x - hatch_w/2; hx1 = hatch_x + hatch_w/2; hz1 = hatch_z0 + hatch_h;
hf = [hx0 - 15, hx1 + 15];            // frame x range
hyf = hy + 5;                          // frame plate outer face
hyl = hyf + hatch_gasket;              // flap inner face when closed
hax = [hyl + 4 + 4, hz1 + 10];         // hinge axis [y, z]
hatch_bolts = [for (x = [hf[0] + 10, hf[1] - 10], z = [hatch_z0 + 5, hz1 - 15]) [x, z]];

module hatch_frame_world() difference() {
  union() {
    // plate round the opening
    translate([hf[0], hy, hatch_z0 - 12]) cube([hf[1] - hf[0], 5, hz1 + 21 - (hatch_z0 - 12)]);
    // side cheeks: the flap sits recessed between them, out of the wind and with no edge to grab
    for (x = [hf[0], hf[1] - 5]) translate([x, hyf - 0.01, hatch_z0 - 12]) cube([5, hax[0] + 5 - hyf, hz1 + 21 - (hatch_z0 - 12)]);
    // hinge lugs at the flap's top corners
    for (x = [hf[0] + 5, hf[1] - 13]) hull() {
      translate([x, hyf - 0.01, hax[1] - 6]) cube([8, 0.1, 18]);
      translate([x, hax[0], hax[1]]) rotate([0, 90, 0]) cylinder(r = 5, h = 8, $fn = 24);
      translate([x, hax[0] - 5, hz1 + 21 - 5]) cube([8, 10, 5]);
    }
    // rain hood, sloping outwards
    translate([hf[0], 0, 0]) rotate([90, 0, 90]) linear_extrude(hf[1] - hf[0])
      polygon([[hyf - 0.01, hz1 + 16], [hyf - 0.01, hz1 + 21], [hyf + 38, hz1 + 15], [hyf + 38, hz1 + 12]]);
  }
  translate([hx0, hy - 1, hatch_z0]) cube([hatch_w, 10, hatch_h]);
  translate([hf[0] - 1, hax[0], hax[1]]) rotate([0, 90, 0]) cylinder(d = hinge_pin, h = hf[1] - hf[0] + 2, $fn = 16);
  for (b = hatch_bolts) translate([b[0], hy - 1, b[1]]) rotate([-90, 0, 0]) {
    cylinder(d = m4, h = 20, $fn = 16);
    translate([0, 0, 1 + 5 - 2.6]) cylinder(d1 = m4, d2 = 8.6, h = 2.61, $fn = 24);  // countersunk, flush
  }
  for (x = [hx0 + 2, hx1 - 2]) translate([x, hyf - hatch_magnet[1], hatch_z0 - 3]) rotate([-90, 0, 0]) cylinder(d = hatch_magnet[0], h = hatch_magnet[1] + 1, $fn = 24);
}

module hatch_flap_world() difference() {
  union() {
    translate([hf[0] + 6.5, hyl, hatch_z0 - 10]) cube([hf[1] - hf[0] - 13, 4, hatch_h + 20]);
    hull() {
      translate([hf[0] + 14, hax[0], hax[1]]) rotate([0, 90, 0]) cylinder(r = 4, h = hf[1] - hf[0] - 28, $fn = 24);
      translate([hf[0] + 14, hyl, hax[1] - 8]) cube([hf[1] - hf[0] - 28, 4, 1]);
    }
  }
  // clear the lugs at the top corners
  for (x = [hf[0] + 4, hf[1] - 14.5]) translate([x, hyl - 1, hax[1] - 7]) cube([10.5, 20, 20]);
  translate([hf[0] - 1, hax[0], hax[1]]) rotate([0, 90, 0]) cylinder(d = hinge_pin, h = hf[1] - hf[0] + 2, $fn = 16);
  for (x = [hx0 + 2, hx1 - 2]) translate([x, hyl - 1, hatch_z0 - 3]) rotate([-90, 0, 0]) cylinder(d = hatch_magnet[0], h = hatch_magnet[1] + 1, $fn = 24);
}

// preview: swing the flap open by a degrees (it only opens outwards)
module hatch_open(a) translate([0, hax[0], hax[1]]) rotate([a, 0, 0]) translate([0, -hax[0], -hax[1]]) children();

module latch_keeper_print() translate([latch_x + 12, roof_z(latch_x - 12), 0]) rotate([90, 0, 0]) translate([0, hy + 16, 0]) latch_keeper_world(true);

module ridge_cap(sy, saddle = false) {
  front = sy < 0;
  v0 = saddle ? ysplit - 25 : (front ? yf : ysplit + gap);
  v1 = saddle ? ysplit + 25 : (front ? ysplit - gap : yb);
  t0 = saddle ? roof_t + ridge_t + 0.2 : roof_t + 0.2;
  difference() {
    union() {
      for (sx = [-1, 1]) let(e = eave_of(sx), hingeleg = hinge_on && sx == hinge_sx,
          u0 = hingeleg ? (saddle ? u_ax() + rib_u + 6 : u_ax()) : Lsh_e(e) + 4 + (saddle ? 6 : 0))
        intersection() {
          side_frame(sx) difference() {
            union() {
              translate([u0, v0, t0]) cube([Lu_e(e) + 40 - u0, v1 - v0, ridge_t]);
              // thickening over the weather-rib groove
              if (hingeleg && !saddle) translate([u_ax() + rib_u - 4.5, v0, t0 + ridge_t - 0.01]) cube([9, v1 - v0, 2]);
            }
            // groove that fits over the weather rib
            if (hingeleg && !saddle) translate([u_ax() + rib_u - 2.5, v0 - 1, t0 - 0.01]) cube([5, v1 - v0 + 2, 2.6]);
            // clear the fixed knuckles
            if (hingeleg && !saddle) for (sg = hinge_segs(v0, v1)) if (sg[2] == 0)
              translate([u0 - 1, sg[0] - hinge_gap, -1]) cube([hinge_r + 1.8 + (u_ax() - u0) + 1, sg[1] - sg[0] + 2*hinge_gap, 40]);
          }
          translate([sx < 0 ? -600 : 0, -600, -100]) cube([600, 1200, 900]);
        }
      if (hinge_on && !saddle) side_frame(hinge_sx) cap_knuckles(v0, v1);
    }
    for (sx = [-1, 1], v = (saddle ? [ysplit - 14, ysplit + 14] : ridge_hole_vs(front)))
      if (!(hinge_on && sx == hinge_sx)) let(e = eave_of(sx)) side_frame(sx) translate([u_ridge_e(e), v, -1]) cylinder(d = m4, h = 40, $fn = 16);
    if (hinge_on && !saddle) side_frame(hinge_sx) translate([u_ax(), 0, w_ax]) rotate([90, 0, 0]) cylinder(d = hinge_pin, h = 1200, center = true, $fn = 20);
  }
}

// =====================================================================
//  Entrance
// =====================================================================
// local frame: wall-side face at z = 0, outward +z, y up
module door_surround(step = true) difference() {
  union() {
    cylinder(r = R_out, h = 5, $fn = 120);
    // rain hood: top half of a tube
    intersection() {
      difference() {
        cylinder(r = R_out, h = 5 + hood_depth, $fn = 120);
        translate([0, 0, -1]) cylinder(r = R_out - 8, h = hood_depth + 10, $fn = 120);
      }
      translate([-R_out - 1, 0, 0]) cube([2*R_out + 2, R_out + 1, hood_depth + 6]);
    }
    // keystone
    linear_extrude(7.5) polygon([[-8, door_r + 1], [8, door_r + 1], [12, R_out - 8], [-12, R_out - 8]]);
    // step / drip ledge, sloped 8 degrees outward and down (the landing ledge replaces it)
    if (step) multmatrix([[1, 0, 0, 0], [0, 1, -tan(8), 0], [0, 0, 1, 0], [0, 0, 0, 1]])
      translate([-55, -door_r - 6, 0]) cube([110, 6, sill_depth]);
  }
  translate([0, 0, -1]) cylinder(r = door_r, h = 100, $fn = 120);
  // voussoir grooves
  for (a = [7.5 : 15 : 360]) if (sin(a) > -0.55) rotate([0, 0, a]) translate([door_r + 3, -0.6, 4]) cube([R_out - 12 - door_r - 3, 1.2, 10]);
  for (a = [0 : 60 : 300]) rotate([0, 0, a]) translate([door_r + 14, 0, -1]) cylinder(d = m4, h = 20, $fn = 16);
}

module door_inner_ring() difference() {
  cylinder(r = door_r + 24, h = 4, $fn = 120);
  translate([0, 0, -1]) cylinder(r = door_r, h = 10, $fn = 120);
  for (a = [0 : 60 : 300]) rotate([0, 0, a]) translate([door_r + 14, 0, -1]) cylinder(d = m4, h = 10, $fn = 16);
}

// ---- cornered entrance tunnel (world frame for a mount on the right; mirrored for the left) ----
function tun_yb() = -hy - relief;                      // back face against the siding
function tun_yo() = tun_yb() - 2*tun_t - tun_wi;       // outer face of the front wall
module tun_plane() translate([0, tun_yb(), tun_z0]) rotate([tun_ay, 0, 0]) rotate([0, tun_ax, 0]) children();
tun_tabs = [for (lx = [tun_end + 12, tun_run - 14], ly = [-tun_t - 7, -(tun_wi + tun_t) + 7]) [lx, ly]];
tun_floor_z = door_sill;   // the floor's underside: sits on the landing when mounted

module tunnel_body_world() if (tun_ground) tunnel_landing_world(); else scale([entry_sx, 1, 1]) {
  yb = tun_yb(); yo = tun_yo(); L = tun_run - tun_end; zf = tun_floor_z;
  zg = tun_ground ? zb - leg_h : zf;   // bottom of the walls: the ground on legs, the landing when mounted
  H = 200 + zf - zg;
  difference() {
    union() {
      intersection() {
        union() {
          if (tun_ground) tun_base_frame(tun_end, tun_run);
          else translate([tun_end, yo, zg]) cube([L, yb - yo, tun_floor_t]);         // floor
          if (tun_ground) tun_ramp_floor(tun_end, tun_run, yo, yb);
          translate([tun_end, yb - tun_t, zg]) cube([L, tun_t, H]);                   // back wall
          translate([tun_end, yo, zg]) cube([L, tun_t, H]);                           // front wall
          translate([tun_end, yo, zg]) cube([2*tun_t, yb - yo, H]);                   // closed end, thick enough for a door bolt
          // lintel over the mouth: stops near-horizontal rain skimming under the roof to the doorway
          // with 45 degree haunches at the walls; the 80 mm flat between them stands on a breakaway comb when printed
          translate([tun_run - 8, 0, 0]) rotate([90, 0, 90]) linear_extrude(8)
            polygon([[yo, tun_lintel_z - 35], [yo + tun_t, tun_lintel_z - 35], [yo + tun_t + 35, tun_lintel_z],
                     [yb - tun_t - 35, tun_lintel_z], [yb - tun_t, tun_lintel_z - 35], [yb, tun_lintel_z - 35], [yb, 400], [yo, 400]]);
          // round boss that fills the siding cut-out round the door and carries the bolts
          intersection() {
            translate([0, -hy - 0.01, door_z]) rotate([90, 0, 0]) cylinder(r1 = R_out, r2 = R_out - relief, h = relief + 0.01, $fn = 120);   // 45 degree rim: no ledge at its bottom
            translate([tun_end, -hy - 10, zf]) cube([L, 20, 300]);
          }
        }
        tun_plane() translate([-1000, -1000, -1000]) cube([2000, 2000, 1000]);        // walls stop at the roof plane
      }
      // screw tabs for the roof, with 45 degree gussets so the body prints without support
      for (t = tun_tabs) hull() {
        tun_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 10.5 : t[1] - 7, -6]) cube([14, t[1] < -tun_wi/2 ? 17.5 : 16, 6 - 0.01]);
        tun_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 11.5 : t[1] + 7, -26]) cube([14, t[1] < -tun_wi/2 ? 3.5 : 2, 1]);
      }
    }
    // the doorway, open to the top so the back wall needs no bridge
    intersection() {   // above the tunnel floor, so the cut never grazes the floor's underside
      hull() for (z = [door_z, door_z + 200]) translate([0, -hy + 1, z]) rotate([90, 0, 0]) cylinder(r = door_r, h = relief + tun_t + 2, $fn = 120);
      translate([-200, -hy - 50, zf + tun_floor_t]) cube([400, 100, 400]);
    }
    // the door's bolt pattern (4 of its 6 holes; the top two fall in the open doorway)
    for (a = [0, 180, 240, 300]) translate([(door_r + 14)*cos(a), -hy + 1, door_z + (door_r + 14)*sin(a)])
      rotate([90, 0, 0]) cylinder(d = m4, h = relief + tun_t + 2, $fn = 16);
    // pilot holes for the roof screws
    for (t = tun_tabs) tun_plane() translate([t[0], t[1], -16]) cylinder(d = pilot, h = 17, $fn = 16);
    // floor drains past the doorway (on legs the underside is open: arches between piers)
    if (tun_ground) tun_skirt_cuts(tun_end + 2*tun_t, tun_run, 25);   // tops at 25 keep 12 mm of wall under the lower door bolts
    if (tun_ground && tun_siding) intersection() {
      tun_siding_cuts(tun_end, tun_run);
      translate([tun_end - 1, tun_yo() - 1, door_sill + tun_floor_t]) cube([tun_run - tun_end + 2, 3, 300]);
    }
    if (tun_windows) for (xc = [-30, 70]) tun_window_cut(xc, door_sill + tun_floor_t + 59);
    if (!tun_ground) for (x = [door_r + 25 : 25 : tun_run - 15], y = [yo + 25 : 25 : yb - 20]) translate([x, y, zf - 1]) cylinder(d = drain_d, h = tun_floor_t + 2, $fn = 16);
    // on legs: bolt holes for the ramp extension's splice plates
    if (tun_ground) for (y = [yb - tun_t - 1, yo - 1], z = [40, 110], x = [tun_run - 12]) translate([x, y, z]) rotate([-90, 0, 0]) cylinder(d = m4, h = tun_t + 2, $fn = 16);
  }
  if (tun_siding && tun_windows) for (xc = [-30, 70]) tun_window_trim(xc, door_sill + tun_floor_t + 59);
}

// roof, built flat in the roof plane's frame (x along the house, y out from the wall), shingles up
module tunnel_roof_local() {
  x0 = tun_end - 2; x1 = tun_run + 14; y0 = -(tun_wi + 2*tun_t) - 20; t = tun_roof_t;   // closed end: 2 mm, clear of the latch
  difference() {
    union() {
      translate([x0, y0, 0]) cube([x1 - x0, -y0 - 2, t]);   // 2 mm off the siding: the double slope leans the back edge in
      translate([x0, -6, 0]) cube([90 - x0, 4, t + 10]);    // flashing upstand against the wall (stops short of the roof latch)
      // fish-scale shingles, courses running along x and stepping down towards the outer edge
      translate([0, 0, t - roof_t]) multmatrix([[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]])
        translate([y0, 0, 0]) shingles_strip(x0 + 2, x1 - 2, -y0 - 6);
    }
    for (p = tun_tabs) translate([p[0], p[1], -1]) cylinder(d = screw_clear, h = 20, $fn = 16);
  }
}
// the shingles module works along u from an eave at u = 0; here the eave is the outer edge
module shingles_strip(vA, vB, Lsh) shingles(vA, vB, Lsh);
module tunnel_roof_world() scale([entry_sx, 1, 1]) tun_plane() tunnel_roof_local();

// ---- on legs: the ramp down to the ground (in the tunnel's own frame, mouth towards +x) ----
// cells between the ribs that carry the landing and the ramp (ribs run along x, so each layer bridges 30 mm)
function tun_cell_ys() = let(yo = tun_yo()) [for (k = [0 : 4]) yo + tun_t + 15 + k*30];
function tun_rib_ys() = let(yo = tun_yo()) [for (k = [1 : 4]) yo + tun_t + k*30];
// top of the walking surface along x: landing at the door, then the ramp, then flat on the ground
function tun_walk_z(x) = let(zt = door_sill + tun_floor_t, zg = zb - leg_h + 4, zs = zt - (tun_step_x - tun_end)*tan(tun_land_tilt))
  max(zg, x <= tun_step_x ? zt - (max(x, tun_end) - tun_end)*tan(tun_land_tilt) : zs - (x - tun_step_x)*tan(tun_ramp_a));
// the walking surface (6 mm) with grip ridges, plus the ribs under it, between x0 and x1
module tun_ramp_floor(x0, x1, yo, yb) {
  zg = zb - leg_h;
  n = 24;
  pts = [for (i = [0 : n]) let(x = x0 + (x1 - x0)*i/n) [x, tun_walk_z(x)]];
  // walking surface, 6 mm thick under the landing; under the ramp its underside falls at 45 degrees (not the
  // ramp's 30), so it prints over itself without supports
  translate([0, yb, 0]) rotate([90, 0, 0]) linear_extrude(yb - yo)
    // (where its underside would come within 3 mm of the ground it drops to the ground, so nothing hovers just above the bed)
    polygon(concat(pts, [for (i = [n : -1 : 0]) [pts[i][0], pts[i][1] - tun_floor_t < zg + 3 ? zg : pts[i][1] - tun_floor_t]]));
  // grip ridges across the ramp, every 25 mm along it
  // (in 26 mm segments with 8 mm gaps, so water runs down the ramp instead of pooling behind them)
  for (x = [tun_step_x + 15 : 25 : x1 - 5], y = [yo + tun_t + 4 : 34 : yb - tun_t - 26]) if (x > x0 && tun_walk_z(x) > zg + 5)
    translate([x, y, tun_walk_z(x) - 1]) cube([3, 26, 3]);
}
// on legs: pointed arches through the walls and ribs below the walking surface, leaving piers (45 degree tops, no supports)
module tun_arch_cuts(x0, x1, zcap) {
  w = 44; step = w + 18; base = zb - leg_h + 3;
  for (xc = [x0 + 12 + w/2 : step : x1 - w/2 - 6]) let(top = min(zcap, tun_walk_z(xc + w/2) - tun_floor_t - 6))
    if (top - base > w/2 + 8) translate([0, tun_yb() + 1, 0]) rotate([90, 0, 0]) linear_extrude(tun_yb() - tun_yo() + 2)
      polygon([[xc - w/2, base], [xc + w/2, base], [xc + w/2, top - w/2], [xc, top], [xc - w/2, top - w/2]]);
}
// on legs: the wall area below the walking surface (x-z), up to zcap
function tun_under_z(x) = max(zb - leg_h, tun_walk_z(x) - tun_floor_t);   // underside of the walking surface
module tun_skirt_region(x0, x1, zcap) let(base = zb - leg_h + 3, n = 30)
  polygon(concat([[x0, base], [x1, base]], [for (i = [n : -1 : 0]) let(x = x0 + (x1 - x0)*i/n) [x, max(base, min(zcap, tun_under_z(x) - 6))]]));
// the openings below the walking surface, for the style chosen, as 2D shapes in x-z
module tun_skirt_cut2d(x0, x1, zcap) {
  base = zb - leg_h + 3;
  if (tun_skirt == "lattice") intersection() {
    offset(delta = -6) tun_skirt_region(x0, x1, zcap);
    p = 30; a = p/sqrt(2) - 6;   // diamond holes, leaving 45 degree bars about 6 mm wide
    for (i = [floor(x0/p) - 1 : ceil(x1/p) + 1], j = [0 : 12]) translate([i*p + (j % 2)*p/2, base + j*p/2]) rotate(45) square(a, center = true);
  }
  if (tun_skirt == "big_arch") {
    // one tall pointed arch (45 degree top) as wide as the height allows, posts only at the ends
    xc = (x0 + x1)/2;
    top = min(zcap, tun_under_z(x1 - 12) + (x1 - 12 - xc), tun_under_z(xc) - 4) - 4;
    w = min(x1 - x0 - 24, 2*(top - base - 6));
    if (w > 30) polygon([[xc - w/2, base], [xc + w/2, base], [xc + w/2, top - w/2], [xc, top], [xc - w/2, top - w/2]]);
  }
}
module tun_skirt_cuts(x0, x1, zcap) {
  if (tun_skirt == "arches") tun_arch_cuts(x0, x1, zcap);
  else translate([0, tun_yb() + 1, 0]) rotate([90, 0, 0]) linear_extrude(tun_yb() - tun_yo() + 2) tun_skirt_cut2d(x0, x1, zcap);
}
// siding on the outer face of the front wall above the walking surface: V-grooves every 25 mm, like the house
module tun_siding_cuts(x0, x1) let(yo = tun_yo())
  for (z = [door_sill + 20 : 25 : 260]) translate([x0, yo - 0.01, z]) rotate([0, 90, 0]) linear_extrude(x1 - x0)
    polygon([[-1, -0.1], [1, -0.1], [0, 1.1]]);
// raised trim round a window on the outer face, with a sloped sill
module tun_window_trim(xc, zc, w = 80, h = 80, c = 25) let(yo = tun_yo()) difference() {
  translate([0, yo + 0.01, 0]) rotate([90, 0, 0]) linear_extrude(3)
    offset(delta = 8) polygon([[xc - w/2, zc - h/2], [xc + w/2, zc - h/2], [xc + w/2, zc + h/2 - c], [xc + w/2 - c, zc + h/2],
                               [xc - w/2 + c, zc + h/2], [xc - w/2, zc + h/2 - c]]);
  // sloped top on the bottom bar, so rain runs off instead of sitting on a ledge
  translate([xc - w/2 - 10, 0, 0]) rotate([90, 0, 90]) linear_extrude(w + 20)
    polygon([[yo - 3.1, zc - h/2 + 0.1], [yo - 3.1, zc - h/2 - 3], [yo + 0.01, zc - h/2 + 0.1]]);
  translate([0, yo + 2, 0]) rotate([90, 0, 0]) linear_extrude(10)
    polygon([[xc - w/2, zc - h/2], [xc + w/2, zc - h/2], [xc + w/2, zc + h/2 - c], [xc + w/2 - c, zc + h/2],
             [xc - w/2 + c, zc + h/2], [xc - w/2, zc + h/2 - c]]);
  // 45 degree underside on the bottom bar, so it doesn't start as a 3 mm ledge
  let(zt = zc - h/2 - 8) translate([xc - w/2 - 10, 0, 0]) rotate([90, 0, 90]) linear_extrude(w + 20)
    polygon([[yo - 3.1, zt - 0.1], [yo - 3.1, zt + 3.1], [yo + 0.01, zt - 0.1]]);
}
// on legs: base frame under the walls, so the piers spread their load on soft ground
module tun_base_frame(x0, x1) let(zg = zb - leg_h, yo = tun_yo(), yb = tun_yb()) {
  translate([x0, yo, zg]) cube([x1 - x0, 14, 3]);
  translate([x0, yb - 14, zg]) cube([x1 - x0, 14, 3]);
}
// a window in the outer wall: opening with 45 degree top corners, and a pocket for the pane on the inside face
module tun_window_cut(xc, zc, w = 80, h = 80, c = 25) let(yo = tun_yo()) {
  translate([0, yo + tun_t + 1, 0]) rotate([90, 0, 0]) linear_extrude(tun_t + 2)
    polygon([[xc - w/2, zc - h/2], [xc + w/2, zc - h/2], [xc + w/2, zc + h/2 - c], [xc + w/2 - c, zc + h/2],
             [xc - w/2 + c, zc + h/2], [xc - w/2, zc + h/2 - c]]);
  translate([xc - w/2 - 4.3, yo + tun_t - 2.2, zc - h/2 - 4.3]) cube([w + 8.6, 3.2, h + 8.6]);
}
tun_ramp_drop = tun_roof_t + shingle_t + 1;   // the extension's roof starts this far below, so it tucks under the door section's roof
module tun_ramp_plane() translate([tun_run, tun_yb(), tun_z0 - tun_run*tan(tun_ax) - tun_ramp_drop]) rotate([tun_ay, 0, 0]) rotate([0, tun_ramp_ax, 0]) children();
tun_ramp_tabs = [for (lx = [22, (tun_ramp_end - tun_run)/cos(tun_ramp_ax) - 14], ly = [-tun_t - 7, -(tun_wi + tun_t) + 7]) [lx, ly]];

// on legs: the door section is just the landing, on a V-shaped belly (45 degree faces, prints without supports)
// carried by a central keel with two legs; the ramp extension brings the walking surface down to the ground
tun_land_x1 = tun_step_x;                          // where the landing section ends and the ramp extension starts
tun_land_windows = [-42, 35];
tun_ramp_windows = [[135, 80], [222, 55]];
module tun_belly(x0, x1) let(yo = tun_yo(), yb = tun_yb(), zf = tun_floor_z, d = (tun_yb() - tun_yo())/2)
  translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) polygon([[yo, zf + 0.01], [yb, zf + 0.01], [(yo + yb)/2, zf - d]]);
// the same V-shaped belly under the ramp, sheared to follow it down to the ground (faces about 49 degrees)
module tun_ramp_belly(x0, x1) tun_slope_belly(x0, x1, tan(tun_ramp_a));
module tun_slope_belly(x0, x1, k) let(yo = tun_yo(), yb = tun_yb(), d = (tun_yb() - tun_yo())/2, zg = zb - leg_h,
                                     z0 = tun_walk_z(x0) - tun_floor_t)
  intersection() {
    multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [-k, 0, 1, k*x0], [0, 0, 0, 1]])
      translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) polygon([[yo, z0 + 0.01], [yb, z0 + 0.01], [(yo + yb)/2, z0 - d]]);
    translate([x0 - 1, yo - 1, zg]) cube([x1 - x0 + 2, yb - yo + 2, 500]);
  }
module tun_keel(x0, x1) let(yc = (tun_yo() + tun_yb())/2, zg = zb - leg_h, zk = tun_floor_z - (tun_yb() - tun_yo())/2 + 1, w = 60, xc = (x0 + x1)/2)
  difference() {
    union() {
      translate([x0, yc - 3, zg]) cube([x1 - x0, 6, zk - zg]);
      for (x = [x0, x1 - 40]) translate([x, yc - 20, zg]) cube([40, 40, 3]);   // foot pads
    }
    // the opening between the two legs, with a 45 degree top
    translate([0, yc + 4, 0]) rotate([90, 0, 0]) linear_extrude(8)
      polygon([[xc - w/2, zg - 1], [xc + w/2, zg - 1], [xc + w/2, zk - 5 - w/2], [xc, zk - 5], [xc - w/2, zk - 5 - w/2]]);
  }

module tunnel_landing_world() scale([entry_sx, 1, 1]) {
  yb = tun_yb(); yo = tun_yo(); zf = tun_floor_z; x0 = tun_end; x1 = tun_land_x1; L = x1 - x0;
  difference() {
    union() {
      intersection() {
        union() {
          translate([0, yb, 0]) rotate([90, 0, 0]) linear_extrude(yb - yo)            // landing, falling towards the ramp
            polygon([[x0, tun_walk_z(x0)], [x1, tun_walk_z(x1)], [x1, tun_walk_z(x1) - tun_floor_t], [x0, tun_walk_z(x0) - tun_floor_t]]);
          translate([x0, yb - tun_t, zf]) cube([L, tun_t, 200]);                      // back wall
          translate([x0, yo, zf]) cube([L, tun_t, 200]);                              // front wall
          translate([x0, yo, zf]) cube([2*tun_t, yb - yo, 200]);                      // closed end
          intersection() {
            translate([0, -hy - 0.01, door_z]) rotate([90, 0, 0]) cylinder(r1 = R_out, r2 = R_out - relief, h = relief + 0.01, $fn = 120);   // 45 degree rim: no ledge at its bottom
            translate([x0, -hy - 10, zf - 40]) cube([L, 20, 340]);
          }
        }
        tun_plane() translate([-1000, -1000, -1000]) cube([2000, 2000, 1000]);
      }
      tun_slope_belly(x0, x1, tan(tun_land_tilt));
      tun_keel(x0 + 2, x1 - 2);
      for (t = tun_tabs) if (t[0] < 0) hull() {
        tun_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 10.5 : t[1] - 7, -6]) cube([14, t[1] < -tun_wi/2 ? 17.5 : 16, 6 - 0.01]);
        tun_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 11.5 : t[1] + 7, -26]) cube([14, t[1] < -tun_wi/2 ? 3.5 : 2, 1]);
      }
    }
    intersection() {
      hull() for (z = [door_z, door_z + 200]) translate([0, -hy + 1, z]) rotate([90, 0, 0]) cylinder(r = door_r, h = relief + tun_t + 2, $fn = 120);
      translate([-200, -hy - 50, zf + tun_floor_t]) cube([400, 100, 400]);
    }
    for (a = [0, 180, 240, 300]) translate([(door_r + 14)*cos(a), -hy + 1, door_z + (door_r + 14)*sin(a)])
      rotate([90, 0, 0]) cylinder(d = m4, h = relief + tun_t + 2, $fn = 16);
    for (t = tun_tabs) if (t[0] < 0) tun_plane() translate([t[0], t[1], -16]) cylinder(d = pilot, h = 17, $fn = 16);
    // bolt holes for the ramp extension's splice plates
    for (y = [yb - tun_t - 1, yo - 1], z = [70, 150]) translate([x1 - 8, y, z]) rotate([-90, 0, 0]) cylinder(d = m4, h = tun_t + 2, $fn = 16);
    // drains at the landing's low end, coming out on the belly's faces (clear of the keel)
    for (dy = [-60, -25, 25, 60]) translate([x1 - 14, (yo + yb)/2 + dy, zb - leg_h]) cylinder(d = drain_d, h = 200, $fn = 16);
    if (tun_windows) for (xc = tun_land_windows) tun_window_cut(xc, zf + tun_floor_t + 59, 70);
    if (tun_siding) intersection() {
      tun_siding_cuts(x0, x1);
      translate([x0 - 1, yo - 1, zf + tun_floor_t]) cube([L + 2, 3, 300]);
    }
  }
  if (tun_siding && tun_windows) for (xc = tun_land_windows) tun_window_trim(xc, zf + tun_floor_t + 59, 70);
}

module tunnel_ramp_world() scale([entry_sx, 1, 1]) {
  yb = tun_yb(); yo = tun_yo(); zg = zb - leg_h; x0 = tun_land_x1; x1 = tun_ramp_end;
  difference() {
    union() {
      intersection() {
        union() {
          tun_ramp_floor(x0, x1, yo, yb);
          tun_ramp_belly(x0, x1);
          // walls from the walking surface's underside up
          intersection() {
            union() {
              translate([x0, yb - tun_t, zg]) cube([x1 - x0, tun_t, 400]);
              translate([x0, yo, zg]) cube([x1 - x0, tun_t, 400]);
            }
            translate([0, yb + 1, 0]) rotate([90, 0, 0]) linear_extrude(yb - yo + 2)
              polygon(concat([[x1, 400], [x0, 400]], [for (i = [0 : 30]) let(x = x0 + (x1 - x0)*i/30) [x, tun_under_z(x)]]));
          }
          // the lintel where the roofs meet
          translate([tun_run - 8, 0, 0]) rotate([90, 0, 90]) linear_extrude(8)
            polygon([[yo, tun_lintel_z - 35], [yo + tun_t, tun_lintel_z - 35], [yo + tun_t + 35, tun_lintel_z],
                     [yb - tun_t - 35, tun_lintel_z], [yb - tun_t, tun_lintel_z - 35], [yb, tun_lintel_z - 35], [yb, 400], [yo, 400]]);
        }
        // up to the door section's roof before tun_run, its own lower roof after
        union() {
          intersection() { translate([x0 - 30, -1000, -1000]) cube([tun_run - x0 + 30, 2000, 2000]); tun_plane() translate([-1000, -1000, -1000]) cube([2000, 2000, 1000]); }
          intersection() { translate([tun_run, -1000, -1000]) cube([1000, 2000, 2000]); tun_ramp_plane() translate([-1000, -1000, -1000]) cube([2000, 2000, 1000]); }
        }
      }
      // splice plates that slide inside the landing section's walls
      // (each tongue is joined to its ramp wall over x0..x0 + 15, and its free end has a 45 degree underside)
      for (y = [yb - 2*tun_t - 0.3, yo + tun_t + 0.3]) let(z0 = tun_floor_z + tun_floor_t + 4, z1 = tun_floor_z + tun_floor_t + 110) {
        translate([0, y + tun_t, 0]) rotate([90, 0, 0]) linear_extrude(tun_t)
          polygon([[x0, z0], [x0 + 15, z0], [x0 + 15, z1], [x0 - 15, z1], [x0 - 15, z0 + 15]]);
        translate([x0, y > (yo + yb)/2 ? yb - tun_t - 0.31 : yo + tun_t - 0.01, z0]) cube([15, 0.32, z1 - z0]);
        // 45 degree gusset under the joined part, from the wall to the plate's inner face
        let(yw = y > (yo + yb)/2 ? yb - tun_t + 0.01 : yo + tun_t - 0.01, d = y > (yo + yb)/2 ? -4.32 : 4.32)
          translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(15) polygon([[yw, z0], [yw + d, z0], [yw, z0 - abs(d)]]);
      }
      // tabs for the door section's roof (over the top of the ramp) and for its own roof
      for (t = tun_tabs) if (t[0] > 0) hull() {
        tun_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 10.5 : t[1] - 7, -6]) cube([14, t[1] < -tun_wi/2 ? 17.5 : 16, 6 - 0.01]);
        tun_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 11.5 : t[1] + 7, -26]) cube([14, t[1] < -tun_wi/2 ? 3.5 : 2, 1]);
      }
      for (t = tun_ramp_tabs) hull() {
        tun_ramp_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 10.5 : t[1] - 7, -6]) cube([14, t[1] < -tun_wi/2 ? 17.5 : 16, 6 - 0.01]);
        tun_ramp_plane() translate([t[0] - 7, t[1] < -tun_wi/2 ? t[1] - 11.5 : t[1] + 7, -26]) cube([14, t[1] < -tun_wi/2 ? 3.5 : 2, 1]);
      }
    }
    for (y = [yb - 2*tun_t - 1.3, yo + tun_t - 0.7], z = [70, 150]) translate([x0 - 8, y, z]) rotate([-90, 0, 0]) cylinder(d = m4, h = tun_t + 2, $fn = 16);
    for (t = tun_tabs) if (t[0] > 0) tun_plane() translate([t[0], t[1], -16]) cylinder(d = pilot, h = 17, $fn = 16);
    for (t = tun_ramp_tabs) tun_ramp_plane() translate([t[0], t[1], -16]) cylinder(d = pilot, h = 17, $fn = 16);
    if (tun_siding) intersection() {
      tun_siding_cuts(x0, x1);
      translate([0, yb, 0]) rotate([90, 0, 0]) linear_extrude(yb - yo + 1) polygon(concat([[x1, 400], [x0, 400]], [for (i = [0 : 20]) let(x = x0 + (x1 - x0)*i/20) [x, tun_walk_z(x) + 2]]));
    }
    if (tun_windows) for (w = tun_ramp_windows) tun_window_cut(w[0], w[1], 70);
    // drains where water collects at the mouth
    for (x = [x1 - 30 : 12 : x1 - 6], y = [yo + 20 : 20 : yb - 15]) translate([x, y, zg - 1]) cylinder(d = drain_d, h = 20, $fn = 16);
  }
  if (tun_siding && tun_windows) for (w = tun_ramp_windows) tun_window_trim(w[0], w[1], 70);
}
// its roof, flat in its own plane, tucked 14 mm under the door section's roof
module tunnel_ramp_roof_local() {
  x1 = (tun_ramp_end - tun_run)/cos(tun_ramp_ax) + 14; y0 = -(tun_wi + 2*tun_t) - 20; t = tun_roof_t;
  difference() {
    union() {
      translate([0.5, y0, 0]) cube([x1 - 0.5, -y0 - 2, t]);
      translate([0, 0, t - roof_t]) multmatrix([[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]])
        translate([y0, 0, 0]) shingles_strip(16, x1 - 2, -y0 - 6);
    }
    for (p = tun_ramp_tabs) translate([p[0], p[1], -1]) cylinder(d = screw_clear, h = 20, $fn = 16);
  }
}
module tunnel_ramp_roof_world() scale([entry_sx, 1, 1]) tun_ramp_plane() tunnel_ramp_roof_local();

// =====================================================================
//  Legs and floor keys
// =====================================================================
module leg() difference() {
  union() {
    cylinder(d1 = 28, d2 = 40, h = leg_h);
    if (leg_foot_d > 0) {   // wide foot, coned up into the leg (prints foot down, no overhang)
      cylinder(d = leg_foot_d, h = 4);
      translate([0, 0, 4]) cylinder(d1 = leg_foot_d, d2 = 30, h = (leg_foot_d - 30)/2);
    }
  }
  translate([0, 0, -1]) cylinder(d = m6, h = leg_h + 2);
  translate([0, 0, -0.01]) cylinder(r = 10/sqrt(3) + 0.25, h = 6, $fn = 6);   // M6 nut
  if (leg_foot_d == 0) translate([0, 0, 10]) rotate_extrude() translate([14 + 10*6/leg_h, 0]) circle(r = 1.4, $fn = 4);
}

// printed upside down: the plate's top face goes on the bed
module center_leg() difference() {
  union() {
    cylinder(d = 100, h = 8);
    cylinder(d1 = 44, d2 = 32, h = leg_h);
    // wide foot (this leg prints upside down, so the foot widens upward at 45 degrees)
    if (leg_foot_d > 0) {
      translate([0, 0, leg_h - 4 - (leg_foot_d - 33)/2]) cylinder(d1 = 33, d2 = leg_foot_d, h = (leg_foot_d - 33)/2);
      translate([0, 0, leg_h - 4]) cylinder(d = leg_foot_d, h = 4);
    }
  }
  for (sx = [-1, 1], sy = [-1, 1]) translate([sx*30, sy*30, 0]) {
    translate([0, 0, -1]) cylinder(d = m6, h = 20);
    translate([0, 0, 3]) cylinder(r = 10/sqrt(3) + 0.25, h = 10, $fn = 6);
  }
}

module bowtie_key() linear_extrude(slab_t + rib_h - 0.2) bowtie2d();   // drawn size: -0.15 slid with 0.8 mm play, +0.2 held the halves 1 mm apart (2026-11-25)

// =====================================================================
//  Mount rails (mount frame: wall face at y = 0, outward +y; placed with mount_xf)
// =====================================================================
module rail_section(pts) translate([-rail_len/2, 0, 0]) rotate([90, 0, 90]) linear_extrude(rail_len) polygon(pts);
module y_hole(x, z, d, y0 = -1, h = 120) translate([x, y0, z]) rotate([-90, 0, 0]) cylinder(d = d, h = h, $fn = 16);
module y_hex(x, z, y0, h, af) translate([x, y0, z]) rotate([-90, 0, 0]) cylinder(r = af/sqrt(3) + 0.3, h = h, $fn = 6);
// countersunk wood-screw hole along +y, head on the side facing the house
module screw_hole_y(x, z, y0) {
  y_hole(x, z, 5, y0 - 1);
  translate([x, y0 - 6, z]) rotate([-90, 0, 0]) cylinder(d1 = 16, d2 = 5, h = 5.5 + 6, $fn = 24);
}
// bevel line shared by both cleats: z = cleat_zh - y (lower at the mounting-surface side)
module fence_house_cleat() difference() {
  rail_section([[0, cleat_top], [cleat_t - 0.3, cleat_top], [cleat_t - 0.3, cleat_zh - cleat_t + 0.3], [0, cleat_zh]]);
  for (x = rail_xs, z = cleat_bolt_z) { y_hole(x, z, m5); y_hex(x, z, 10, 40, 8); }
  for (x = lock_xs) y_hole(x, lock_z[0], 5.2);
}

// mount cleat profile: below the bevel, bevel high at the house side so the house cleat is pulled in
function mount_cleat_pts(y_back) = [[4, cleat_zh - 4 - 0.4], [cleat_t, cleat_zh - cleat_t - 0.4], [y_back, cleat_zh - cleat_t - 0.4],
                                    [y_back, 48], [4, 48]];

module fence_post_cleat() difference() {
  rail_section(mount_cleat_pts(cleat_t));
  for (x = [-110, -40, 40, 110]) screw_hole_y(x, 64, 4);
}

module fence_standoff() difference() {
  rail_section([[0, standoff_z[0]], [cleat_t, standoff_z[0]], [cleat_t, standoff_z[1]], [0, standoff_z[1]]]);
  for (x = rail_xs, z = standoff_bolt_z) { y_hole(x, z, m5); y_hole(x, z, 12, 10); }
  for (x = lock_xs) y_hole(x, lock_z[1], 5.2);
}

// Tree plate: the mount cleat on a backing board that straps to the trunk. The standoff and the house
// cleat bear on its front face, and the support brackets bolt to its lower part.
module tree_plate() {
  yb = cleat_t + tree_back_t;
  difference() {
    union() {
      rail_section(mount_cleat_pts(cleat_t + 1));
      translate([-rail_len/2, cleat_t, tree_plate_bottom]) cube([rail_len, tree_back_t, cleat_top - tree_plate_bottom]);
    }
    // strap channels along the plate
    for (z = [cleat_top - 22, 24, tree_plate_bottom + 40]) translate([-rail_len/2 - 1, cleat_t + 6, z - strap_w/2]) cube([rail_len + 2, strap_t, strap_w]);
    // V-groove that centres it on the trunk
    translate([0, 0, tree_plate_bottom - 1]) linear_extrude(cleat_top - tree_plate_bottom + 2)
      polygon([[-14, yb + 0.01], [14, yb + 0.01], [0, yb - 10]]);
    // pilot holes for the lock screws
    for (x = lock_xs, z = lock_z) y_hole(x, z, 3.5, cleat_t - 1, tree_back_t - 4);
    // bracket bolts: M5 with the nut in a pocket on the trunk side (fit them before strapping)
    for (x = [-30, 30], z = [-40, -95, -145]) { y_hole(x, z, m5, cleat_t - 1, 40); y_hex(x, z, yb - 5, 6, 8); }
  }
}

// Steel shelf brackets (bought), shown for reference: two under the floor centre, bolted through the
// centre-leg holes. Mount frame: arm runs from the mounting surface back under the house.
module steel_brackets() color("#8A8F94") for (x = [-30, 30]) translate([x - 15, 0, 0]) {
  translate([0, cleat_t - 4, zb - bracket_leg]) cube([30, 4, bracket_leg]);
  translate([0, cleat_t - bracket_arm, zb - 4]) cube([30, bracket_arm, 4]);
  hull() {
    translate([13, cleat_t - 4.5, zb - bracket_leg + 20]) cube([4, 0.5, 0.5]);
    translate([13, cleat_t - bracket_arm + 40, zb - 4.5]) cube([4, 0.5, 0.5]);
  }
}

module support_brackets() {
  if (brackets == "printed") color(c_trim) for (s = [-1, 1]) translate([s*30, 0, 0]) scale([s, 1, 1]) printed_bracket();
  else steel_brackets();
}

// Printable support bracket (mount frame, centred on its floor bolts at x = 0). An L-section: flanges
// pb_w wide and a web on the -x side, so the screws through the upright sit on the open side and a
// driver reaches them straight past the diagonal. Printed lying on the web, so every member is loaded
// along its layers.
module printed_bracket() {
  y0 = cleat_t;
  x0 = -21; x1 = x0 + pb_w;
  xd = x0 + 13;  // the diagonal flange stops short of the screw line
  module prof(a, b) translate([a, 0, 0]) rotate([90, 0, 90]) linear_extrude(b - a) children();
  d_lo = [y0 - pb_flange, zb - pb_leg + 11];   // diagonal: upright foot to the arm, between the floor bolts
  d_hi = [y0 - 250, zb - pb_flange];
  difference() {
    union() {
      prof(x0, x1) {
        translate([y0 - pb_flange, zb - pb_leg]) square([pb_flange, pb_leg]);
        translate([y0 - pb_arm, zb - pb_flange]) square([pb_arm - pb_flange + 0.01, pb_flange]);
      }
      prof(x0, xd) {
        hull() { translate(d_lo) circle(r = 7, $fn = 24); translate(d_hi) circle(r = 7, $fn = 24); }
        // fillet in the top corner, web side only
        polygon([[y0 - pb_flange, zb - pb_flange], [y0 - pb_flange, zb - 45], [y0 - 45, zb - pb_flange]]);
      }
      prof(x0, x0 + pb_web) polygon([[y0 - pb_flange, d_lo[1]], [y0 - pb_flange, zb - pb_flange], [d_hi[0], zb - pb_flange]]);
    }
    // keep the arm's top flat and the upright's back flat
    translate([x0 - 1, y0 - pb_arm - 1, zb]) cube([pb_w + 2, pb_arm + 2, 10]);
    translate([x0 - 1, y0, zb - pb_leg - 1]) cube([pb_w + 2, 10, pb_leg + 2]);
    for (d = bracket_bolt_d) translate([0, y0 - d, zb - pb_flange - 1]) cylinder(d = 6.5, h = pb_flange + 2, $fn = 20);
    for (z = bracket_screw_z) translate([0, y0 + 1, z]) rotate([90, 0, 0]) cylinder(d = 5.5, h = pb_flange + 2, $fn = 20);
  }
}

// =====================================================================
//  Landing ledge (world coordinates, built for the right side and mirrored for the left)
// =====================================================================
porch_d = landing_x_end - hx > 40 ? 50 : 30;   // depth of the web and gussets past the corner
module landing_world() scale([entry_sx, 1, 1]) {
  zt = door_sill; zp = zt - landing_t; zf = zb + 2;
  yi = -hy - 6;
  difference() {
    union() {
      // walking plate, outer corners rounded
      translate([0, 0, zp]) linear_extrude(landing_t) offset(r = 10) offset(delta = -10)
        polygon([[landing_x0, yi], [landing_x_end, yi], [landing_x_end, yi - landing_w], [landing_x0, yi - landing_w]]);
      // bolting flange against the front wall
      translate([76, yi, zf]) cube([hx - 76, 6, zt - zf]);
      // web under the stretch in front of the door, kept 6 mm off the wall so it clears the door surround
      translate([landing_x0 + 4, yi - 6, zf]) cube([76 + 1 - landing_x0 - 4, 6, zt - zf]);
      // gussets
      for (x = [landing_x0 + 4, 48, 92, 140, 188, hx - 6]) translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(6)
        polygon([[yi + 0.01, zf], [yi + 0.01, zp + 0.01], [yi - landing_w + 8, zp + 0.01]]);
      // end gusset past the corner, under the part that reaches out to the mounting surface
      // (deeper, and doubled, when it runs past the corner as a porch)
      for (x = landing_x_end - hx > 40 ? [hx + 36, landing_x_end - 8] : [landing_x_end - 8])
        translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(6)
          polygon([[yi - 0.01, zp - porch_d], [yi - 0.01, zp + 0.01], [yi - landing_w + 8, zp + 0.01]]);
      translate([hx, yi - 0.01, zp - porch_d]) cube([landing_x_end - hx - 2, 6, porch_d + 0.02]);
    }
    // drain and grip slots, square to the wall
    for (x = [landing_x0 + 14 : 16 : landing_x_end - 12]) translate([x - 2.5, yi - landing_w + 12, zp - 1]) cube([5, landing_w - 24, landing_t + 2]);
    // bolts to the house
    for (x = landing_bolt_xs) translate([x, yi - 20, landing_bolt_z]) rotate([-90, 0, 0]) cylinder(d = m5, h = 40, $fn = 16);
  }
}

// print upside down: the walking surface goes on the bed
module landing_print() translate([entry_sx > 0 ? -landing_x0 : landing_x_end, -hy, door_sill])
  rotate([180, 0, 0]) landing_world();

// =====================================================================
//  Printable parts (print orientation)
// =====================================================================
module corner_print(sx, sy) translate([0, 0, -zb]) {
  corner(sx, sy);
  if (print_supports) breakaway(sx, sy);
}

// ---------------------------------------------------------------------
//  Breakaway supports, printed with the corner modules and snapped off afterwards.
//  ASA bridges about 40 mm cleanly; the window heads (70 mm), the hatch top (98 mm) and the half door top
//  (35 mm, free at the seam) need holding up. Each support is a comb: thin ribs across the wall every
//  bk_pitch, tied by a spine along the span. It stops bk_gap short of the surface it holds (one 0.30 mm
//  layer, so it doesn't fuse), keeps bk_side away from the sides, and stands on small tabs (bk_tab_h tall)
//  that a flush cutter snips.
// ---------------------------------------------------------------------
// ribs at x0..x1 (every bk_pitch), each the (y, z) polygon prof; spine at y = ys from zs[0] to zs[1]
module bk_comb(x0, x1, prof, ys, zs) {
  n = max(1, round((x1 - x0)/bk_pitch));
  xs = [for (i = [0:n]) x0 + (x1 - x0 - bk_t)*i/n];
  for (x = xs) translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(bk_t) polygon(prof);
  translate([x0, ys - bk_t/2, zs[0]]) cube([x1 - x0, bk_t, zs[1] - zs[0]]);
  if (bk_tabs) for (x = xs) translate([x, ys - 1, zs[0] - bk_tab_h - 0.2]) cube([bk_t, 2, bk_tab_h + 0.21]);
}

// On legs, the landing prints standing on its keel (two 40 mm pads under a body 164 mm wide and 290 tall).
// Breakaway outriggers steady it: on each side, triangular ribs from the bed 25 mm outside the wall up the
// belly's 45 degree face, joined to it by snip-off tabs every 15 mm (unlike the combs, they must hold).
bk_rig_t = 2.4;      // outrigger rib thickness: four 0.6 mm lines
bk_rig_out = 25;     // how far the ribs stand out past the walls on the bed
module tun_outriggers() let(yo = tun_yo(), yb = tun_yb(), yc = (yo + yb)/2, d = (yb - yo)/2, zg = zb - leg_h,
                            gs = bk_gap*sqrt(2), xs = [tun_end + 15, (tun_end + tun_land_x1)/2, tun_land_x1 - 15])
  // (no middle rib on the house side: the round boss comes down to 12 mm there)
  for (x = xs, side = [-1, 1]) if (!(side > 0 && x == xs[1])) let(za = tun_walk_z(x) - tun_floor_t - d,   // the belly's apex at this x
                                   ya = yc + side*22, yw = yc + side*(d - 1), yf = yc + side*(d + bk_rig_out)) {
    translate([x - bk_rig_t/2, 0, 0]) rotate([90, 0, 90]) linear_extrude(bk_rig_t)
      polygon([[yf, zg], [ya, zg], [ya, za + 22 - gs], [yw, za + d - 1 - gs]]);
    // tabs across the gap, every 15 mm up the face
    if (bk_tabs) for (t = [0 : 15 : d - 23]) let(y = ya + side*t, zf = za + abs(y - yc) - gs/2)
      translate([x - bk_rig_t/2, y - 1, zf - 1]) cube([bk_rig_t, 2, 2]);
  }

// under the lintel's flat (80 mm between its 45 degree haunches), standing on the walking surface walk(x)
module tun_lintel_comb(walk) scale([entry_sx, 1, 1]) let(yo = tun_yo(), yb = tun_yb(), xa = tun_run - 8 + 0.3, xb = tun_run - 0.3,
    xm = (xa + xb)/2, ya = yo + tun_t + 35 + bk_side, yc = yb - tun_t - 35 - bk_side, top = tun_lintel_z - bk_gap,
    n = max(1, round((yc - ya)/bk_pitch))) {
  for (i = [0:n]) let(y = ya + (yc - ya - bk_t)*i/n) {
    translate([0, y + bk_t, 0]) rotate([90, 0, 0]) linear_extrude(bk_t)
      polygon([[xa, walk(xa) + bk_tab_h], [xb, walk(xb) + bk_tab_h], [xb, top], [xa, top]]);
    if (bk_tabs) translate([xm - 1, y, min(walk(xm - 1), walk(xm + 1)) - 0.2]) cube([2, bk_t, bk_tab_h + 0.2 + abs(walk(xm - 1) - walk(xm + 1))]);
  }
  translate([xm - bk_t/2, ya, max(walk(xm - bk_t/2), walk(xm + bk_t/2)) + bk_tab_h]) cube([bk_t, yc - ya, top - max(walk(xm - bk_t/2), walk(xm + bk_t/2)) - bk_tab_h]);
}

module breakaway(sx, sy) {
  zb0 = bk_tab_h;   // combs start this far above the surface they stand on
  // window heads: through the wall core (head at the top of the opening) and the pane pocket (4 mm higher)
  if (peek_on(sx, sy)) face_xf(sx < 0 ? 3 : 2) let(ac = peek_ac(sx, sy), z0 = win_zc - win_h/2, z1 = win_zc + win_h/2)
    bk_comb(ac - win_w/2 + bk_side, ac + win_w/2 - bk_side,
            [[-wt + 0.3, z0 + zb0], [-0.5, z0 + zb0], [-0.5, z1 - bk_gap], [-wt + pane_t - bk_side, z1 - bk_gap],
             [-wt + pane_t - bk_side, z1 + 4 - bk_gap], [-wt + 0.3, z1 + 4 - bk_gap]],
            -wt + pane_t + (wt - pane_t)/2, [z0 + zb0, z1 - bk_gap]);
  // escape hatch: under the flat top between the 45 degree corners, through the core and the frame pad
  if (hatch && sy > 0 && sx * hatch_x > 0)
    bk_comb(hx0 + 21 + bk_side, hx1 - 21 - bk_side,
            [[hy - wt + 0.3, hatch_z0 + zb0], [hy, hatch_z0 + zb0], [hy + relief - 0.5, hatch_z0 + zb0 + 3],
             [hy + relief - 0.5, hz1 - bk_gap], [hy - wt + 0.3, hz1 - bk_gap]],
            hy - wt/2, [hatch_z0 + zb0, hz1 - bk_gap]);
  // door: the flat top of the clipped teardrop, door_r + 4 above its centre, half of it in each front corner
  if (sy < 0) let(r = door_r + 4, xe = r*(sqrt(2) - 1), zt = door_z + r - bk_gap,
                  zbot = function(x) door_z - sqrt(r*r - x*x) + zb0)
    scale([sx, 1, 1]) {
      n = max(1, round((xe - 1 - gap - 0.3)/bk_pitch));
      xs = [for (i = [0:n]) gap + 0.3 + (xe - 1 - gap - 0.3 - bk_t)*i/n];
      for (x = xs) let(z0 = zbot(x + bk_t)) {
        translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(bk_t)
          polygon([[-hy - relief + 0.5, z0 + 3], [-hy, z0], [-idp/2 - 0.3, z0], [-idp/2 - 0.3, zt], [-hy - relief + 0.5, zt]]);
        if (bk_tabs) translate([x, -hy + wt/2 - 1, zbot(x) - zb0 - 0.2]) cube([bk_t, 2, z0 - zbot(x) + zb0 + 0.21]);
      }
      // spine along the core's mid-plane, its foot following the round bottom of the door
      translate([0, -hy + wt/2 + bk_t/2, 0]) rotate([90, 0, 0]) linear_extrude(bk_t)
        polygon(concat([[gap + 0.3, zt], [xe - 1, zt]],
                       [for (i = [0:12]) let(x = xe - 1 - (xe - 1 - gap - 0.3)*i/12) [x, zbot(x)]]));
    }
}

module roof_print(sx, sy) {
  v0 = sy < 0 ? yf : ysplit + gap;
  e = eave_of(sx);
  if (sx < 0) translate([0, -v0, 0]) unslope_left(e) roof_panel(sx, sy);
  else translate([roof_len_e(e) + 1, -v0, 0]) unslope_right(e) roof_panel(sx, sy);
}

module ridge_print(sy, saddle = false) {
  v0 = saddle ? ysplit - 25 : (sy < 0 ? yf : ysplit + gap);
  t0 = saddle ? roof_t + ridge_t + 0.2 : roof_t + 0.2;
  e = eave_of(-1);
  u0 = Lsh_e(e) + 4 + (saddle ? 6 : 0);
  // outer face of one leg on the bed, the other leg rises at 2 x pitch
  v1 = saddle ? ysplit + 25 : (sy < 0 ? ysplit - gap : yb);
  eh = eave_of(hinge_sx);
  if (hinge_on && !saddle) {
    // stood on its end: the profile extrudes straight up; the knuckles and stop ears get breakaway lattices
    ridge_standing(sy);
    if (print_supports) knuckle_combs(sy, v0, v1);
  } else
    translate([0, v1 - v0, ridge_t]) rotate([180, 0, 0]) translate([-u0, -v0, -t0]) unslope_left(e) ridge_cap(sy, saddle);
}

module ridge_standing(sy) let(v0 = sy < 0 ? yf : ysplit + gap, eh = eave_of(hinge_sx))
  translate([hinge_sx > 0 ? 345 : 0, 30, -v0]) rotate([90, 0, 0])
    if (hinge_sx > 0) unslope_right(eh) ridge_cap(sy); else unslope_left(eh) ridge_cap(sy);

// Breakaway supports under the cap's knuckles (stood on end, each knuckle and its stop ear overhang the cap's
// profile). In each gap below a knuckle: a lattice the knuckle's shape, kept bk_side clear of the cap's profile
// (where the fixed knuckles' notch is and where it isn't), bk_gap below the knuckle and above the one under it.
module bk_lattice2d() for (i = [-60 : 3.5 : 60]) {
  translate([i, -1000]) square([bk_t, 2000]);
  translate([-1000, i]) square([2000, bk_t]);
}
module knuckle_combs(sy, v0, v1) let(segs = hinge_segs(v0, v1), caps = [for (sg = segs) if (sg[2] == 1) sg], zend = (segs[0][0] - v0)/2)
  for (k = [0 : len(caps) - 1]) let(sg = caps[k], zl = k == 0 ? 0 : caps[k - 1][1] - v0 + bk_gap, zh = sg[0] - v0 - bk_gap,
                                     zk = (sg[0] + sg[1])/2 - v0, zp = sg[0] - v0 - hinge_gap - hinge_seg/2)
    translate([0, 0, zl]) linear_extrude(zh - zl) {
      intersection() { knuckle_area(sy, zk, zp, zend); bk_lattice2d(); }
      // a ring round the outline ties the lattice into one piece
      difference() { knuckle_area(sy, zk, zp, zend); offset(delta = -bk_t) knuckle_area(sy, zk, zp, zend); }
    }
module knuckle_area(sy, zk, zp, zend) difference() {
  projection(cut = true) translate([0, 0, -zk]) ridge_standing(sy);
  offset(r = bk_side) union() {
    projection(cut = true) translate([0, 0, -zp]) ridge_standing(sy);
    projection(cut = true) translate([0, 0, -zend]) ridge_standing(sy);
  }
}

module rail_print(which) {
  // house-side face down for the parts bolted to the house, mounting-surface face down for the others
  if (which == "fence_house_cleat") rotate([90, 0, 0]) translate([0, 0, -cleat_top]) fence_house_cleat();
  if (which == "fence_post_cleat") rotate([-90, 0, 0]) translate([0, -cleat_t, -48]) fence_post_cleat();
  if (which == "fence_standoff") rotate([90, 0, 0]) translate([0, 0, -standoff_z[1]]) fence_standoff();
  if (which == "tree_plate") rotate([-90, 0, 0]) translate([0, -(cleat_t + tree_back_t), -tree_plate_bottom]) tree_plate();
}

module print_part(p) {
  if (p == "corner_fl") corner_print(-1, -1);
  if (p == "corner_fr") corner_print(1, -1);
  if (p == "corner_bl") corner_print(-1, 1);
  if (p == "corner_br") corner_print(1, 1);
  if (p == "roof_fl") roof_print(-1, -1);
  if (p == "roof_fr") roof_print(1, -1);
  if (p == "roof_bl") roof_print(-1, 1);
  if (p == "roof_br") roof_print(1, 1);
  if (p == "ridge_front") ridge_print(-1);
  if (p == "ridge_back") ridge_print(1);
  if (p == "ridge_saddle") ridge_print(-1, true);
  // both ridge caps as one object with a fixed gap, so their supports and brims can't collide on the plate
  if (p == "ridge_pair") { ridge_print(-1); translate([0, 100, 0]) ridge_print(1); }
  if (p == "seam_cap") seam_cap_print(eave_of(mount_sx));
  if (p == "door_surround") door_surround(step = !landing_on);
  if (p == "tunnel_body") translate([entry_sx > 0 ? -tun_end : tun_run, -tun_yo(), -(tun_ground ? zb - leg_h : tun_floor_z)]) {
    tunnel_body_world();
    if (print_supports && !tun_ground) tun_lintel_comb(function(x) tun_floor_z + tun_floor_t);
    if (print_supports && tun_ground) scale([entry_sx, 1, 1]) tun_outriggers();
  }
  if (p == "tunnel_roof") translate([entry_sx > 0 ? -(tun_end - 2) : tun_run + 14, tun_wi + 2*tun_t + 20, 0]) scale([entry_sx, 1, 1]) tunnel_roof_local();
  if (p == "tunnel_ramp") translate([-(tun_land_x1 - 15), -tun_yo(), -(zb - leg_h)]) {
    tunnel_ramp_world();
    if (print_supports) tun_lintel_comb(function(x) tun_walk_z(x));
  }
  if (p == "tunnel_ramp_roof") translate([0, tun_wi + 2*tun_t + 20, 0]) tunnel_ramp_roof_local();
  if (p == "door_inner_ring") door_inner_ring();
  if (p == "leg") leg();
  if (p == "center_leg") center_leg();
  if (p == "support_bracket") translate([zb, -(cleat_t - pb_arm), 0]) rotate([0, -90, 0]) translate([21, 0, 0]) printed_bracket();
  if (p == "bowtie_key") bowtie_key();
  if (p == "landing") landing_print();
  if (p == "latch_keeper") latch_keeper_print();
  if (p == "latch_button") latch_button_local();
  if (p == "window_retainer") window_retainer();
  if (p == "hatch_frame") translate([-hf[0], 0, 0]) rotate([90, 0, 0]) translate([0, -hy, -(hatch_z0 - 12)]) hatch_frame_world();
  if (p == "hatch_flap") translate([-hf[0], 0, 0]) rotate([90, 0, 0]) translate([0, -hyl, -(hatch_z0 - 10)]) hatch_flap_world();
  if (p == "fence_house_cleat" || p == "fence_post_cleat" || p == "fence_standoff" || p == "tree_plate") rail_print(p);
}

// =====================================================================
//  Assembly, exploded view and plate layout
// =====================================================================
c_wall = "#A7ABAD";   // grey walls
c_roof = "#F4F4F1";   // white roof: reflects the sun
c_trim = "#3F7D4E";   // green trim
c_leg = "#3F7D4E";

module assembly(e = 0) {
  for (sx = [-1, 1], sy = [-1, 1]) color(c_wall) translate([sx*e*70, sy*e*70, 0]) corner(sx, sy);
  for (sx = [-1, 1], sy = [-1, 1]) color(c_roof) translate([sx*e*90, sy*e*40, e*170])
    if (hinge_on && sx == lid_sx) lid_open() roof_panel(sx, sy, holes = open_angle == 0); else roof_panel(sx, sy);
  color(c_trim) translate([0, 0, e*260]) lid_open(hinge_on ? open_angle : 0) { ridge_cap(-1); ridge_cap(1); }
  if (seam_cap) color(c_trim) for (sx = [-1, 1]) translate([sx*e*90, 0, e*220])
    lid_open(hinge_on && sx == lid_sx ? open_angle : 0) side_frame(sx) seam_cap_local(eave_of(sx));
  color(c_trim) translate([0, 0, e*300]) lid_open(hinge_on ? open_angle : 0) ridge_cap(-1, true);
  if (e == 0) peek_window_world();
  if (hatch) color(c_trim) translate([0, e*100, 0]) { hatch_frame_world(); hatch_open(hatch_open_angle) hatch_flap_world(); }
  if (hinge_on) color(c_trim) for (f = [true, false]) {
    translate([0, 0, e*200]) lid_open() latch_keeper_world(f);
    translate([0, (f ? -1 : 1)*e*60, 0]) latch_button_world(f, open_angle > 0);
  }
  if (door_tunnel) {
    color(c_trim) translate([0, -e*150, 0]) tunnel_body_world();   // green: the grey goes to the corners
    color(c_roof) translate([0, -e*150, e*120]) tunnel_roof_world();
    if (tun_windows && e == 0) color("#BFE3F0", pane_alpha) scale([entry_sx, 1, 1])
      for (w = tun_ground ? concat([for (x = tun_land_windows) [x, door_sill + tun_floor_t + 59]], tun_ramp_windows)
                          : [[-30, door_sill + tun_floor_t + 59], [70, door_sill + tun_floor_t + 59]])
        translate([w[0] - 39, tun_yo() + tun_t - 2.1, w[1] - 44]) cube([78, 2, 88]);
    if (tun_ground) {
      color(c_trim) translate([e*120, -e*150, 0]) tunnel_ramp_world();
      color(c_roof) translate([e*120, -e*150, e*120]) tunnel_ramp_roof_world();
    }
  } else color(c_trim) translate([0, -hy - e*150, door_z]) rotate([90, 0, 0]) door_surround(step = !landing_on);
  color(c_trim) translate([0, -idp/2 + e*80, door_z]) rotate([-90, 0, 0]) door_inner_ring();
  if (show_legs) color(c_leg) translate([0, 0, -e*80]) {
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx*leg_xy[0], sy*leg_xy[1], zb - leg_h]) leg();
    translate([0, 0, zb]) rotate([180, 0, 0]) center_leg();
  }
  color(c_trim) for (s = [-1, 1]) {
    translate([0, s*key_yk, zb + e*150]) bowtie_key();
    translate([s*key_xk, 0, zb + e*150]) rotate([0, 0, 90]) bowtie_key();
  }
  if (show_cushion && e == 0) color("#B5524A") translate([0, 0, 0])
    hull() for (sx = [-1, 1], sy = [-1, 1]) translate([sx*(cushion_w/2 - 40), sy*(cushion_d/2 - 40), 0])
      scale([1, 1, cushion_h/80]) translate([0, 0, 40]) sphere(r = 40, $fn = 24);
  mount_xf() translate([0, e*120, 0]) mount_parts_local();
  if (landing_on) color(c_trim) translate([e*120, -e*120, 0]) landing_world();
}

module mount_parts_local() {
  if (mount != "none") color(c_trim) { fence_house_cleat(); fence_standoff(); }
  if (mount != "none" && show_brackets) support_brackets();
  if (mount == "fence") {
    color("#C9B79C") fence_post_cleat();
    color("#7A5C3E") translate([-45, cleat_t, -900]) cube([90, 90, 1400]);  // a fence post, for scale
  }
  if (mount == "tree") {
    color("#C9B79C") tree_plate();
    color("#6B4F35") translate([0, cleat_t + tree_back_t + 130 - 10, -900]) cylinder(r = 130, h = 1500, $fn = 64);
  }
}

module plate(i, j, label) {
  translate([i*360, -j*355, 0]) {
    color("#D9D9D9") translate([0, 0, -1.2]) cube([bed[0], bed[1], 1]);
    children();
  }
}

module layout() {
  ox = [hx + relief + 10, 10];
  plate(0, 0) color(c_wall) translate([hx + 12, hy + 12, 0]) corner_print(-1, -1);
  plate(1, 0) color(c_wall) translate([12, hy + 12, 0]) corner_print(1, -1);
  plate(2, 0) color(c_wall) translate([hx + 12, 12, 0]) corner_print(-1, 1);
  plate(3, 0) color(c_wall) translate([12, 12, 0]) corner_print(1, 1);
  plate(0, 1) color(c_roof) translate([4, 20, 0]) roof_print(-1, -1);
  plate(1, 1) color(c_roof) translate([4, 20, 0]) roof_print(1, -1);
  plate(2, 1) color(c_roof) translate([4, 20, 0]) roof_print(-1, 1);
  plate(3, 1) color(c_roof) translate([4, 20, 0]) roof_print(1, 1);
  plate(4, 0) color(c_trim) {
    translate([20, 15, 0]) ridge_print(-1);
    translate([110, 15, 0]) ridge_print(1);
    translate([210, 120, 0]) ridge_print(-1, true);
  }
  plate(4, 1) color(c_trim) {
    translate([115, 115, 0]) door_surround();
    for (i = [0:3]) translate([250 + (i % 2)*45, 245 + floor(i/2)*45, 0]) leg();
    for (i = [0:3]) translate([40 + i*58, 275, 0]) rotate([0, 0, 90]) bowtie_key();
  }
  plate(0, 2) color(c_trim) {
    translate([110, 110, 0]) door_inner_ring();
    translate([260, 70, 0]) center_leg();
    for (i = [0, 1]) translate([228 + i*45, 170, 0]) latch_keeper_print();
    for (i = [0, 1]) translate([250 + i*40, 280, 0]) latch_button_local();
  }
  plate(1, 2) color(c_trim) {
    translate([162, 50, 0]) rail_print("fence_house_cleat");
    translate([162, 150, 0]) rail_print("fence_post_cleat");
    translate([162, 220, 0]) rail_print("fence_standoff");
  }
  plate(3, 2) color(c_trim) translate([10, 10, 0]) landing_print();
  plate(2, 2) color(c_trim) translate([162, 6, 0]) rail_print("tree_plate");
}

if (part == "assembly") assembly();
else if (part == "exploded") assembly(1);
else if (part == "layout") layout();
else print_part(part);
