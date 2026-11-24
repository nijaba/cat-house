// Driven-rain line-of-sight test: the room is filled with marker-coloured blocks.
// Viewed along the rain direction, any marker colour that shows is where rain falls straight in.
include <../cat_house.scad>
calib = false;
m = 1.5;  // stay this far inside the inner wall faces
module room_xz() polygon([[-iw/2 + m, 0.5], [iw/2 - m, 0.5], [iw/2 - m, wall_h], [0, roof_z(0) - roof_t - 14], [-iw/2 + m, wall_h]]);
if (calib) color("#FF0000") translate([-50, -50, 0]) cube([100, 100, 1]);
else {
  assembly();
  y0 = -idp/2 + m; y1 = idp/2 - m; x0 = -iw/2 + m; zc = cushion_h; za = roof_z(0) - roof_t - 14;
  // cushion top, in bands by distance from the inside of the front wall: magenta 0-50 mm, red beyond
  color("#FF00FF") translate([x0, y0, zc]) cube([iw - 2*m, 50, 1]);
  color("#FF0000") translate([x0, y0 + 50, zc]) cube([iw - 2*m, y1 - y0 - 50, 1]);
  // inner wall faces above the cushion: red (water there runs down into the bed)
  color("#FF0000") {
    for (x = [x0, -x0 - 1]) translate([x, y0, zc]) cube([1, y1 - y0, wall_h - zc]);
    for (y = [y0, y1 - 1]) translate([x0, y, zc]) cube([iw - 2*m, 1, wall_h - zc]);
  }
  // underside of the roof and inside of the gables: blue (drips from here land on the bed)
  color("#0000FF") {
    translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) difference() {
      polygon([[x0, wall_h], [-x0, wall_h], [0, za]]);
      offset(delta = -1) polygon([[x0, wall_h], [-x0, wall_h], [0, za]]);
      translate([x0 + 2, wall_h - 1]) square([-2*x0 - 4, 3]);
    }
    for (y = [y0, y1 - 1]) translate([0, y + 1, 0]) rotate([90, 0, 0]) linear_extrude(1) polygon([[x0, wall_h], [-x0, wall_h], [0, za]]);
  }
}
