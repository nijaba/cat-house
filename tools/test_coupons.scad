// Test coupons: small pieces cut from the real parts, in the real parts' print orientation, so the joints
// can be checked in an hour or two before the big prints. Export one at a time:
//   OpenSCAD -o stl/test/<name>.stl -D 'part="none"' -D 'coupon="<name>"' tools/test_coupons.scad
// Names: seam_front, seam_back, seam_cap_slice, hinge_panel, hinge_cap, key_left, key_right
include <../cat_house.scad>
coupon = "seam_front";

// a roof panel, cut by a box given in that slope's frame, then laid flat exactly as roof_print does
module roof_coupon(sx, sy) {
  e = eave_of(sx);
  v0 = sy < 0 ? yf : ysplit + gap;
  module cut() intersection() { roof_panel(sx, sy); side_frame(sx) children(); }
  if (sx < 0) translate([0, -v0, 0]) unslope_left(e) cut() children();
  else translate([roof_len_e(e) + 1, -v0, 0]) unslope_right(e) cut() children();
}

// standing seam: 40 mm of each panel's edge round the middle seam bolt (left slope)
module seam_box() let(e = eave_of(-1)) translate([Lsh_e(e)/2 - 20, ysplit - 35, -20]) cube([40, 70, 60]);
if (coupon == "seam_front") roof_coupon(-1, -1) seam_box();
if (coupon == "seam_back") roof_coupon(-1, 1) seam_box();
if (coupon == "seam_cap_slice") let(e = eave_of(-1), L = Lsh_e(e),
    W = seam_t + gap + seam_cap_cl + seam_cap_wall, wtop = roof_t + seam_h + seam_cap_cl + seam_cap_wall)
  translate([-(L/2 - 20), ysplit + W, wtop]) rotate([180, 0, 0])
    intersection() { seam_cap_local(e); translate([L/2 - 20, -500, -500]) cube([40, 1000, 1000]); }

// ridge hinge: the gable-end 90 mm of the fixed slope's knuckles and of the front ridge cap
if (coupon == "hinge_panel") roof_coupon(hinge_sx, -1) translate([u_ax() - 30, yf - 1, -20]) cube([80, 92, 60]);
if (coupon == "hinge_cap") intersection() { ridge_print(-1); translate([-500, -500, -1]) cube([1000, 1000, 92]); }

// floor key: the two floor pockets either side of the front-back seam, and the key itself (print bowtie_key)
module key_box() translate([0, -key_yk - 20, zb - 1]) cube([30, 40, 15]);
if (coupon == "key_left") translate([0, 0, -zb]) intersection() { corner(-1, -1); mirror([1, 0, 0]) key_box(); }
if (coupon == "key_right") translate([0, 0, -zb]) intersection() { corner(1, -1); key_box(); }
