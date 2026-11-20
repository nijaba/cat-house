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
part = "assembly"; // [assembly, exploded, layout, corner_fl, corner_fr, corner_bl, corner_br, roof_fl, roof_fr, roof_bl, roof_br, ridge_front, ridge_back, ridge_saddle, door_surround, door_inner_ring, leg, center_leg, bowtie_key, fence_house_cleat, fence_post_cleat, fence_standoff, tree_rail, landing]
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
slab_t = 4;      // floor slab thickness
rib_h = 6;       // floor ribs: the cushion sits on these, water drains under it
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
seam_h = 14;     // standing seam that joins the front and back roof panels
seam_t = 4;
ridge_leg = 40;
ridge_t = 4;
rake_w = 14;

/* [Entrance] */
door_d = 160;      // clear opening, fine for a 5 kg cat
door_sill = 40;    // sill height above the floor: keeps splash and the cushion in
surround_w = 28;
hood_depth = 45;   // rain hood over the entrance
sill_depth = 28;   // outside step / drip ledge

/* [Legs and floor] */
leg_h = 60;
drain_d = 6;

/* [Mount] */
rail_len = 300;
rail_upper_z = 118;
mount_eave_ov = 15; // roof overhang on the mount side, so the eave clears the post or trunk
// L-shaped landing ledge at door-sill height, from beside the mount around the front corner to the door
landing = true;      // only used when mount is not "none"
landing_w = 95;      // walking width
landing_t = 8;
landing_x0 = 8;      // runs to the middle of the door (the lowest point of the opening); replaces the door step
// the ledge ends flush with the mounting surface (wall, fence board, post or trunk), never past it
rail_lower_z = 40;
cleat_t = 24;
tree_rail_t = 35;
strap_w = 26;    // 25 mm ratchet strap or hose clamps
strap_t = 6;

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
landing_bolt_xs = [115, 170, 196];
landing_x_end = hx + min(cleat_t + 20, tree_rail_t) - 1;
landing_bolt_z = 12;
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

// slanted louvre slot through a wall (outside opening lower than inside)
module louvre(a0, w, z0, h)
  multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [0, -1, 1, 0], [0, 0, 0, 1]])
    translate([a0, -wt - 3, z0]) cube([w, wt + relief + 6, h]);

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
  // shutters with louvre grooves
  for (s = [-1, 1]) translate([ac + s*(win_w/2 + 6 + 3 + 14) - 14, 0, win_zc - win_h/2])
    difference() {
      cube([28, 2.5, win_h]);
      for (gz = [6 : 7 : win_h - 8]) translate([3, 1.5, gz]) cube([22, 2, 2]);
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
  }
  if (sy > 0) face_xf(1) for (ac = [-75, 75], i = [0:4]) louvre(ac - 20, 40, vz0 + i*6.5, 4);
  face_xf(sx > 0 ? 2 : 3) for (ac = [-hy/2, hy/2], i = [0:2]) louvre(ac - 30, 60, 151 + i*6.5, 4);
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
  // landing ledge: flat pads and bolt holes on the front-corner module of the mount side
  if (landing_on && sx == mount_sx && sy < 0) scale([mount_sx, 1, 1]) {
    translate([76, -hy - 15, zb - 1]) cube([hx + 20 - 76, 15 - 0.01, door_sill + 1 - zb + 1]);
    for (x = landing_bolt_xs) translate([x, -hy - 10, landing_bolt_z]) rotate([-90, 0, 0]) cylinder(d = m5, h = wt + 20, $fn = 16);
  }
  // mount rails on the eave wall
  if (mount_holes && sx == mount_sx) mount_xf() {
    for (c = [rail_upper_z, rail_lower_z]) {
      translate([-rail_len/2 - 2, 0.01, c - 31]) cube([rail_len + 4, 12, 62]);
      for (x = rail_xs, dz = [-20, 20]) translate([x, -wt - 1, c + dz]) rotate([-90, 0, 0]) cylinder(d = m5, h = wt + 20);
    }
    for (x = [-95, 95]) translate([x, -wt - 1, rail_lower_z]) rotate([-90, 0, 0]) cylinder(d = 5.2, h = wt + 20);
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

module panel_local(v0, v1, front, e) {
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
    for (u = [40, Lsh/2, Lsh - 30]) translate([u, front ? v1 : v0, roof_t + 8])
      rotate([90, 0, 0]) cylinder(d = m4, h = 3*seam_t, center = true);
  }
}

function ridge_hole_vs(front) = front ? [yf + 30, (yf + ysplit)/2, ysplit - 14] : [ysplit + 14, (ysplit + yb)/2, yb - 30];

module roof_panel(sx, sy) {
  front = sy < 0;
  v0 = front ? yf : ysplit + gap;
  v1 = front ? ysplit - gap : yb;
  e = eave_of(sx);
  scale([-sx, 1, 1]) difference() {
    union() {
      intersection() {
        slope_frame(e) panel_local(v0, v1, front, e);
        translate([-600, -600, -100]) cube([600, 1200, 900]);
      }
      for (p = roof_screws_left) if (p[1] > v0 + 5 && p[1] < v1 - 5)
        screw_xf(p) translate([0, 0, roof_t - 0.2]) cylinder(d = 16, h = shingle_t + 0.8);
    }
    for (p = roof_screws_left) screw_xf(p) translate([0, 0, -1]) cylinder(d = screw_clear, h = roof_t + shingle_t + 5, $fn = 16);
    for (v = ridge_hole_vs(front)) slope_frame(e) translate([u_ridge_e(e), v, -1]) cylinder(d = m4, h = roof_t + 20, $fn = 16);
  }
}

module ridge_cap(sy, saddle = false) {
  front = sy < 0;
  v0 = saddle ? ysplit - 25 : (front ? yf : ysplit + gap);
  v1 = saddle ? ysplit + 25 : (front ? ysplit - gap : yb);
  t0 = saddle ? roof_t + ridge_t + 0.2 : roof_t + 0.2;
  difference() {
    for (s = [-1, 1]) let(e = eave_of(s), u0 = Lsh_e(e) + 4 + (saddle ? 6 : 0)) scale([s, 1, 1]) intersection() {
      slope_frame(e) translate([u0, v0, t0]) cube([Lu_e(e) + 40 - u0, v1 - v0, ridge_t]);
      translate([-600, -600, -100]) cube([600, 1200, 900]);
    }
    for (s = [-1, 1], v = (saddle ? [ysplit - 14, ysplit + 14] : ridge_hole_vs(front)))
      let(e = eave_of(s)) scale([s, 1, 1]) slope_frame(e) translate([u_ridge_e(e), v, -1]) cylinder(d = m4, h = 40, $fn = 16);
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

// =====================================================================
//  Legs and floor keys
// =====================================================================
module leg() difference() {
  cylinder(d1 = 28, d2 = 40, h = leg_h);
  translate([0, 0, -1]) cylinder(d = m6, h = leg_h + 2);
  translate([0, 0, -0.01]) cylinder(r = 10/sqrt(3) + 0.25, h = 6, $fn = 6);   // M6 nut
  translate([0, 0, 10]) rotate_extrude() translate([14 + 10*6/leg_h, 0]) circle(r = 1.4, $fn = 4);
}

// printed upside down: the plate's top face goes on the bed
module center_leg() difference() {
  union() {
    cylinder(d = 100, h = 8);
    cylinder(d1 = 44, d2 = 32, h = leg_h);
  }
  for (sx = [-1, 1], sy = [-1, 1]) translate([sx*30, sy*30, 0]) {
    translate([0, 0, -1]) cylinder(d = m6, h = 20);
    translate([0, 0, 3]) cylinder(r = 10/sqrt(3) + 0.25, h = 10, $fn = 6);
  }
}

module bowtie_key() linear_extrude(slab_t + rib_h - 0.2) offset(delta = -0.15) bowtie2d();

// =====================================================================
//  Mount rails (mount frame: wall face at y = 0, outward +y; placed with mount_xf)
// =====================================================================
module rail_section(pts, c) translate([-rail_len/2, 0, c]) rotate([90, 0, 90]) linear_extrude(rail_len) polygon(pts);

module rail_bolts(c, from_y, nut = "hex") for (x = rail_xs, dz = [-20, 20]) translate([x, 0, c + dz]) {
  translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = m5, h = 80, $fn = 16);
  translate([0, from_y, 0]) rotate([-90, 0, 0]) cylinder(r = 8/sqrt(3) + 0.3, h = 80, $fn = 6);
}

module fence_house_cleat() difference() {
  rail_section([[0, 30], [cleat_t, 30], [cleat_t, -10], [4, -30], [0, -30]], rail_upper_z);
  rail_bolts(rail_upper_z, 8);
}

module fence_post_cleat() {
  c = rail_upper_z;
  difference() {
    rail_section([[5, -70], [cleat_t + 20, -70], [cleat_t + 20, 9.5], [5, -29.5]], c);
    for (x = [-110, 0, 110]) translate([x, 0, c - 50]) screw_hole_y(5);
    for (x = [-60, 60]) translate([x, 0, c - 22]) screw_hole_y(14);
  }
}
// countersunk wood-screw hole along +y, head on the side facing the house
module screw_hole_y(y0) {
  translate([0, y0 - 1, 0]) rotate([-90, 0, 0]) cylinder(d = 5, h = 80, $fn = 16);
  translate([0, y0 - 6, 0]) rotate([-90, 0, 0]) cylinder(d1 = 16, d2 = 5, h = 5.5 + 6, $fn = 24);
}

module fence_standoff() difference() {
  rail_section([[0, -30], [cleat_t + 20, -30], [cleat_t + 20, 30], [0, 30]], rail_lower_z);
  for (x = rail_xs, dz = [-20, 20]) translate([x, 0, rail_lower_z + dz]) {
    translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = m5, h = 80, $fn = 16);
    translate([0, 10, 0]) rotate([-90, 0, 0]) cylinder(d = 12, h = 80, $fn = 24);
  }
  for (x = [-95, 95]) translate([x, -1, rail_lower_z]) rotate([-90, 0, 0]) cylinder(d = 5.2, h = 80, $fn = 16);
}

module tree_rail(c = rail_upper_z) difference() {
  rail_section([[0, -30], [tree_rail_t, -30], [tree_rail_t, 30], [0, 30]], c);
  // strap channel along the rail
  translate([-rail_len/2 - 1, 6, c - strap_w/2]) cube([rail_len + 2, strap_t, strap_w]);
  // V groove that centres the rail on the trunk
  translate([0, 0, c - 31]) linear_extrude(62) polygon([[-14, tree_rail_t + 0.01], [14, tree_rail_t + 0.01], [0, tree_rail_t - 14]]);
  rail_bolts(c, 16);
}

// =====================================================================
//  Landing ledge (world coordinates, built for the right side and mirrored for the left)
// =====================================================================
module landing_world() scale([mount_sx, 1, 1]) {
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
      translate([landing_x_end - 8, 0, 0]) rotate([90, 0, 90]) linear_extrude(6)
        polygon([[yi - 0.01, zp - 30], [yi - 0.01, zp + 0.01], [yi - landing_w + 8, zp + 0.01]]);
      translate([hx, yi - 0.01, zp - 30]) cube([landing_x_end - hx - 2, 6, 30.02]);
    }
    // drain and grip slots, square to the wall
    for (x = [landing_x0 + 14 : 16 : landing_x_end - 12]) translate([x - 2.5, yi - landing_w + 12, zp - 1]) cube([5, landing_w - 24, landing_t + 2]);
    // bolts to the house
    for (x = landing_bolt_xs) translate([x, yi - 20, landing_bolt_z]) rotate([-90, 0, 0]) cylinder(d = m5, h = 40, $fn = 16);
  }
}

// print upside down: the walking surface goes on the bed
module landing_print() translate([mount_sx > 0 ? -landing_x0 : landing_x_end, -hy, door_sill])
  rotate([180, 0, 0]) landing_world();

// =====================================================================
//  Printable parts (print orientation)
// =====================================================================
module corner_print(sx, sy) translate([0, 0, -zb]) corner(sx, sy);

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
  translate([0, 0, ridge_t]) rotate([180, 0, 0]) translate([-u0, -v0, -t0]) unslope_left(e) ridge_cap(sy, saddle);
}

module rail_print(which) {
  if (which == "fence_house_cleat") rotate([90, 0, 0]) translate([0, 0, -rail_upper_z]) fence_house_cleat();
  if (which == "fence_post_cleat") rotate([-90, 0, 0]) translate([0, -(cleat_t + 20), -rail_upper_z]) fence_post_cleat();
  if (which == "fence_standoff") rotate([90, 0, 0]) translate([0, 0, -rail_lower_z]) fence_standoff();
  if (which == "tree_rail") rotate([90, 0, 0]) translate([0, 0, -rail_upper_z]) tree_rail();
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
  if (p == "door_surround") door_surround(step = !landing_on);
  if (p == "door_inner_ring") door_inner_ring();
  if (p == "leg") leg();
  if (p == "center_leg") center_leg();
  if (p == "bowtie_key") bowtie_key();
  if (p == "landing") landing_print();
  if (p == "fence_house_cleat" || p == "fence_post_cleat" || p == "fence_standoff" || p == "tree_rail") rail_print(p);
}

// =====================================================================
//  Assembly, exploded view and plate layout
// =====================================================================
c_wall = "#F3E2B3";
c_roof = "#9DB8A8";
c_trim = "#FBFBF7";
c_leg = "#FBFBF7";

module assembly(e = 0) {
  for (sx = [-1, 1], sy = [-1, 1]) color(c_wall) translate([sx*e*70, sy*e*70, 0]) corner(sx, sy);
  for (sx = [-1, 1], sy = [-1, 1]) color(c_roof) translate([sx*e*90, sy*e*40, e*170]) roof_panel(sx, sy);
  color(c_trim) translate([0, 0, e*260]) { ridge_cap(-1); ridge_cap(1); }
  color(c_trim) translate([0, 0, e*300]) ridge_cap(-1, true);
  color(c_trim) translate([0, -hy - e*150, door_z]) rotate([90, 0, 0]) door_surround(step = !landing_on);
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
  if (mount == "fence") {
    color(c_trim) { fence_house_cleat(); fence_standoff(); }
    color("#C9B79C") fence_post_cleat();
    color("#7A5C3E") translate([-45, cleat_t + 20, -900]) cube([90, 90, 1400]);  // a fence post, for scale
  }
  if (mount == "tree") {
    color(c_trim) { tree_rail(rail_upper_z); tree_rail(rail_lower_z); }
    color("#6B4F35") translate([0, tree_rail_t + 130 - 6, -900]) cylinder(r = 130, h = 1500, $fn = 64);
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
  }
  plate(1, 2) color(c_trim) {
    translate([162, 20, 0]) rail_print("fence_house_cleat");
    translate([162, 160, 0]) rail_print("fence_post_cleat");
    translate([162, 250, 0]) rail_print("fence_standoff");
  }
  plate(3, 2) color(c_trim) translate([10, 10, 0]) landing_print();
  plate(2, 2) color(c_trim) {
    translate([162, 40, 0]) rail_print("tree_rail");
    translate([162, 160, 0]) rail_print("tree_rail");
  }
}

if (part == "assembly") assembly();
else if (part == "exploded") assembly(1);
else if (part == "layout") layout();
else print_part(part);
