// Breakaway-support test: a 70 mm opening with the same comb the corner modules get under their window heads.
// Print it with the house settings (no slicer supports), then snip the tabs and lift the comb out.
// The head should come away clean and flat, with the comb leaving only faint lines.
// Usage: openscad -o stl/test/breakaway_test.stl tools/breakaway_test.scad
include <../cat_house.scad>
part = "none";

L = 70;      // span of the head, as in the window
D = wt;      // wall core depth
H = 30;      // opening height (the real one is 90; the comb's top and bottom are what matter)
B = 3;       // base plate under the wall

difference() {
  union() {
    translate([-L/2 - 12, -D - 8, 0]) cube([L + 24, D + 16, B]);          // base plate, so the wall stands
    translate([-L/2 - 12, -D, 0]) cube([L + 24, D, B + H + 6]);           // wall
  }
  translate([-L/2, -D - 1, B]) cube([L, D + 2, H]);                       // the opening: its top bridges L
}
bk_comb(-L/2 + bk_side, L/2 - bk_side,
        [[-D + 0.3, B + bk_tab_h], [-0.5, B + bk_tab_h], [-0.5, B + H - bk_gap], [-D + 0.3, B + H - bk_gap]],
        -D/2, [B + bk_tab_h, B + H - bk_gap]);
