// Cutting guides for the polycarbonate window panes.
// Each guide lies on the piece being kept, with two lips hooked over the sheet's edge. Its far edge is the cut
// line, a fixed distance from that edge, so every strip and pane comes out the same size without marking.
// Run the knife (scoring knife or ultrasonic blade) along the far edge, on the waste side.
// Printed in ASA-CF (stiffer, shrinks less than ASA): release/cat_cottage_H2D_pane_jig.3mf, hardened nozzle.
//   strip97: 97 mm strips across the sheet, for the house panes (77 x 97)
//   strip88: 88 mm strips across the sheet, for the tunnel panes (78 x 88)
//   pane77:  cuts the strips into panes, 77 mm from the strip's end (the tunnel panes come out 77 x 88; their
//            pockets are 78.6 wide over a 70 mm opening, so that still overlaps 3.5 mm each side)
// Usage: openscad -o stl/jig/pane_jig_strip97.stl -D 'part="strip97"' tools/pane_jig.scad
part = "strip97"; // [strip97, strip88, pane77, assembly]

sheet_t = 2.4;    // the sheet ordered: 0.093 in
t = 5;            // guide thickness, on top of the sheet
lip_d = 2;        // how far the lips reach down the sheet's edge (less than sheet_t, so the guide sits flat)
lip_w = 4;        // lip thickness, beyond the sheet's edge
lip_len = 25;
rail_in = 8;      // the lip rail runs from the lips to this far onto the sheet
edge_w = 14;      // the guide rail, along the cut line
strut = 5;
relief = 0.8;     // groove over the sheet's top edge, so a burr there can't hold the guide off the edge
cham = 0.5;       // chamfer on the cut edge's printed-on-the-bed corner, so elephant's foot can't push it out

// width: distance from the sheet's edge to the cut line; len: guide length along the cut
module guide(width, len, label) {
  lips = [lip_len - 5, len - 2*lip_len + 5];
  difference() {
    union() {
      translate([0, -lip_w, 0]) cube([len, lip_w + rail_in, t]);                 // lip rail
      translate([0, width - edge_w, 0]) cube([len, edge_w, t]);                  // guide rail (the cut edge)
      for (x = [0, len - strut]) translate([x, 0, 0]) cube([strut, width, t]);  // end ties
      // diagonal struts between the rails, so the cut edge stays straight in the plane of the sheet
      n = max(1, round((len - strut)/(width - edge_w - rail_in)));
      p = (len - strut)/n;
      for (i = [0 : n - 1]) {
        x0 = i*p; x1 = x0 + p;
        hull() { translate([i % 2 ? x1 : x0, rail_in - 1, 0]) cube([strut, 1, t]);
                 translate([i % 2 ? x0 : x1, width - edge_w, 0]) cube([strut, 1, t]); }
      }
      for (x = lips) translate([x, -lip_w, -lip_d]) cube([lip_len, lip_w, lip_d + 0.01]);  // lips
    }
    translate([-1, -0.01, -0.01]) cube([len + 2, relief, relief]);
    translate([-1, width, t - cham]) rotate([45, 0, 0]) cube([len + 2, cham*1.5, cham*1.5], center = false);
    // label, sunk into the top
    translate([len/2, width - edge_w/2, t - 0.6]) linear_extrude(1)
      text(label, size = 5.5, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
  }
}

module guide_part(name) {
  if (name == "strip97") guide(97, 310, "97 STRIP  |  CUT THIS EDGE");
  if (name == "strip88") guide(88, 310, "88 STRIP  |  CUT THIS EDGE");
  if (name == "pane77") guide(77, 120, "77 PANE  |  CUT EDGE");
}

// printed upside down: the top lies on the bed, the lips point up
if (part == "assembly") {
  color("#EEF6FA", 0.5) translate([-5, 0, -sheet_t]) cube([320, 305, sheet_t]);
  color("#3F7D4E") guide_part("strip97");
} else translate([0, 0, t]) rotate([180, 0, 0]) guide_part(part);
