# Structural check: 20 kg design load

Hand calculations, 2026-11-20. These are engineering estimates with conservative assumptions, not a
finite-element analysis. Before letting a cat in, do the proof test at the end.

## Short answer

| Case | Result |
|---|---|
| On its legs, 20 kg anywhere | ✅ OK (floor, legs, seams) |
| Mounted, **no support underneath** | ❌ **Not OK.** The floor centre has nothing under it and is overstressed (≈ 24 MPa against an allowable ≈ 10 MPa). The whole moment would hang on two lock screws. |
| Mounted **with two steel shelf brackets** under the floor | ✅ OK, so **brackets are required when mounted** |
| Mounted with the two **printed** `support_bracket`s instead | ✅ OK (≈ 4 MPa peak, ≈ 1 MPa everyday); check for sag after the first hot month |
| Roof, 20 kg standing on it | ✅ OK, after raising the standing seam from 14 to 20 mm (at 14 mm: ≈ 16 MPa, over the limit) |
| Landing ledge, 20 kg at its outer edge | ✅ OK, after moving its bolts up to 26 mm |
| Entrance tunnel (optional): floor, roof, bolts | ✅ OK after thickening the floor and the roof plate from 4 to 6 mm (at 4 mm: ≈ 18 MPa each) |
| Landing as a porch past the corner (tunnel facing away from a wall) | ✅ OK after deepening the web and end gusset to 50 mm and adding a second gusset (at 30 mm: ≈ 19 MPa) |
| French cleat as first designed | ❌ **Bug, fixed.** The bevels sloped the wrong way and pushed the house away from the fence. Even when correct, a 45° cleat can only resist an outward pull equal to the weight it carries, and this house needs 4–7 times that. Lock screws now carry that pull. |

## Assumptions

- **Design load P = 20 kg = 196 N**, applied as a static point load. That covers a 5 kg cat landing with
  about 4 g of impact, or a heavier cat with margin. On top of that, the house's own weight is
  W ≈ 5.1 kg (4.4 kg printed plus about 0.7 kg of hardware) = 50 N.
- **Material: printed ASA**, roughly 35 MPa tensile strength in the print plane and about 20 MPa across
  layers (typical datasheet values). Allow **×0.6 for 60 °C** (a light-coloured part in Florida sun) and a
  **safety factor of 2**. That gives allowable stress of **≈ 10 MPa** in the print plane and **≈ 6 MPa**
  across layers.
- **Sustained loads must stay low because ASA creeps when hot.** The everyday load (the house plus a
  resting 5 kg cat) is about a quarter of the design case: ≤ 3 MPa everywhere below.
- **Geometry** (defaults): interior 430 × 430 mm, walls 5 mm. The mount is on the right eave wall, and the
  mounting surface is 30 mm out from the wall, 250 mm from the house centre.

## 1. Mounted, no support underneath

- **Moment at the mounting surface, worst case** (20 kg against the far wall, 470 mm out):
  M = 196 × 0.47 + 50 × 0.25 = **105 N·m**. With the 20 kg at the centre it is 62 N·m.
- **Cleat.** On a 45° bevel the outward pull the cleat can resist is no more than the vertical load,
  about 246 N. Holding M would take T = M / 0.093 m ≈ 1.1 kN. **The cleat alone can't hold the house.**
- **Lock screws** (2 × #10 at z = 129, pivoting on the standoff's bottom edge, lever arm 127 mm):
  T = 105 / 0.127 = 824 N, so about 410 N per screw. A #10 wood screw with 30 mm in softwood holds about
  500 N as a reference design value (NDS, already with roughly a 5× margin to failure). That is only just
  enough as the sole support.
- **Floor centre.** Without the centre leg, each floor quarter hangs off its two walls, and the four
  quarters only meet through the bowtie keys. A quarter loaded with a quarter of P (49 N) at its free
  corner is a 210 mm cantilever with about 3 ribs working (section modulus about 430 mm³ with the deeper
  8 mm ribs):
  σ = 49 × 210 / 430 ≈ **24 MPa**, more than twice the allowable. ❌

**Verdict: a mounted house needs support under the floor.**

## 2. Mounted with two steel shelf brackets (required)

Use two **12 × 8 in (305 × 200 mm) heavy-duty shelf brackets, each rated for at least 45 kg**, in stainless
or hot-dip galvanised steel. They sit 60 mm apart under the middle of the floor. Each bracket's arm bolts
through the two existing centre-leg holes on its side (x = ±30 mm) with M6 × 25 bolts. Drill 6.5 mm holes in
each arm 216 mm and 276 mm from the inside face of its upright. The uprights go on the mounting surface:
3 × #10 × 2″ screws each into a fence or post, or M5 bolts into the tree plate, whose nuts sit in pockets
on the trunk side.

- **Floor.** The brackets carry the floor centre directly, so each quarter is supported on its two walls
  and its inner corner. Stress drops below 5 MPa. ✅
- **Brackets.** Each carries at most (P + W) / 2 ≈ 123 N, a moment of at most about 52 N·m. That is well
  within a heavy-duty 12″ bracket. ✅
- **Bracket top screws.** 52 N·m over the roughly 170 mm screw spacing ≈ 300 N per bracket, shared by its
  top screws. ✅
- **Cleat and lock screws.** They now only keep the house against the wall; the brackets take the weight
  and most of the moment. Keep the 2 top and 2 bottom lock screws for storms. ✅
- **Tree plate.** The plate holds 3 straps. With ratchet straps tensioned to 1 kN or more, the V-groove's
  grip and friction carry the roughly 250 N vertical load many times over. Each bracket nut is pulled
  through a 20 mm backing with about 4 kN capacity. ✅

## 2b. Printed support brackets

Added 2026-11-21. `support_bracket` is a triangle: a 300 mm arm and a 200 mm upright, both
36 × 12 mm flanges, plus a diagonal from the upright's foot to the arm 250 mm out, between the two floor
bolts (220 and 280 mm), and a 7 mm web on one side. It prints lying on the web, so every member carries its
load in the print plane (allowable ≈ 10 MPa). Loads per bracket are the same as for the steel ones:
≤ 123 N vertical and ≤ 52 N·m at the mounting surface.

- **Couple at the wall.** The top screw (z = −40) is 173 mm above the upright's foot:
  52 / 0.173 ≈ 300 N pulls on the top screw, and the foot pushes on the wall with the same force. That is
  the same as for a steel bracket, within a #10 wood screw's ≈ 500 N design value. ✅
- **Diagonal** (compression, about 35° from horizontal): 300 / cos 35° ≈ 370 N over its flange and web,
  ≈ 370 mm², ≈ 1 MPa. Its unbraced length is about 290 mm, but the web holds it against buckling. ✅
- **Arm** beyond the diagonal: the outer bolt is 30 mm past it. M = 123 × 30 ≈ 3.7 N·m. The flange alone
  has Z = 36 × 12² / 6 = 864 mm³, giving σ ≈ **4.3 MPa**. ✅ Everyday load is about a quarter of that. The
  inner bolt sits over the web.
- **Bolt bearing** (M6 in a 12 mm flange): 123 N / (6 × 12) ≈ 1.7 MPa. ✅
- **Creep.** Everyday stress is about 1 MPa or less. At 60 °C ASA under that stress creeps by a fraction of
  a percent a year, so a sag of 1–2 mm at the arm's end is possible over the first summer. Check it, and
  switch to steel for heavier cats or full sun.

## 3. On its legs

- **Legs.** 4 corner legs plus the centre leg share 246 N: a few kilonewtons of capacity each in
  compression, and M6 bolts. ✅
- **Floor.** Spans run 215 mm from a wall to the centre leg. With the 20 kg spread through the cushion,
  stress is about 3 MPa. For paw-sized loads, the slab is now 5 mm (was 4) and the ribs 8 mm (were 6),
  which is about 65 % stiffer. Local stress is about 6–8 MPa, within the allowable. ✅

## 4. Roof (a cat standing on it)

- **Panel field.** A 6 mm plate supported on the gable, eave and ridge, with a 196 N point load:
  σ ≈ 6.4 MPa. ✅
- **Standing seam.** The panel edges meet here halfway between the gables, so the seam works as a beam
  from the eave plate to the ridge (254 mm along the slope). M = P × L / 4 = 12.4 kN·mm:
  - seam 14 mm tall: σ ≈ 16 MPa ❌
  - **seam 20 mm tall (now the default): σ ≈ 9.4 MPa ✅**

## 5. Landing ledge (a cat landing on its outer edge)

- **Web under the doorway stretch.** It cantilevers 68 mm from the bolted flange:
  σ = 13.3 kN·mm × 20 / 32 000 mm⁴ ≈ 8.3 MPa (bending in the print plane, since it prints upside down). ✅
- **Bolts.** The ledge tips about the bottom of its flange. With the bolts moved up to z = 26 mm (lever
  37 mm), 18.6 N·m gives ≈ 500 N across 3 × M5, about 170 N each. Each bolt's washer would need about
  2 kN to pull through the 5 mm wall. ✅

## 5b. Landing as a porch (tunnel facing away from a wall)

Added 2026-11-23. With `tun_dir = "away"` the landing runs 80 mm past the house corner, where nothing
holds it but its own web along the wall line and the gussets under it.

- **End gusset**, carrying 20 kg at the porch's outer corner (about 87 mm out from the web):
  - 30 mm deep: Z = 6 × 30² / 6 = 900 mm³, M = 196 × 87 ≈ 17 N·m, σ ≈ 19 MPa ❌
  - **50 mm deep (now the default for the porch): Z = 2 500 mm³, σ ≈ 6.8 MPa ✅**
  - A second gusset halfway along the porch shares the load.
- **The porch as a cantilever past the corner:** the 95 × 8 mm plate plus the 6 × 50 mm web have
  Z ≈ 5 400 mm³. M = 196 × 80 ≈ 15.7 N·m, so σ ≈ 2.9 MPa. ✅
- **Bolts:** the same three M5s and the same tipping moment as the standard ledge (section 5). ✅

## 6. Joints

- **Front and back seam bolts** (M4) carry the far half of the house as a cantilever (≈ 46 N·m over a
  275 mm couple, ≈ 170 N in total). ✅
- **House cleat and standoff bolts** (8 × M5 each) carry the vertical shear, about 250 N in total. Bearing
  on the 5 mm wall is about 1.2 MPa. ✅

## 7. Entrance tunnel (optional)

Added 2026-11-23. A box 150 mm wide inside, bolted to the wall through 4 of the door's M4 holes. Mounted,
its floor also rests on the landing. The plate stresses use the circular-plate formula for a point load
on a simply supported plate: σ = 3P / (2π t²) × [(1 + ν) ln(a / r₀) + 1], with P = 196 N, ν = 0.35 and a
paw of r₀ ≈ 15 mm.

- **Floor**, worst case on legs, where it spans 150 mm from the back wall to the front wall (a = 75 mm):
  - 4 mm: σ ≈ 18.5 MPa ❌
  - **6 mm (now the default): σ ≈ 8.2 MPa ✅**
  - Mounted, the floor rests on the landing, and only a 56 mm band past the landing's edge spans, at
    about 5 MPa.
- **Roof.** A cat will jump onto it. The plate rests on the wall tops along both sides and spans 150 mm:
  - 4 mm: σ ≈ 18.5 MPa ❌
  - **6 mm plate under the shingles (now the default): σ ≈ 8.2 MPa ✅**
  - Wind uplift is held by its 4 screws.
- **Front wall as a beam.** Taking 20 kg at the mouth's outer corner as a cantilever from the closed end
  (246 mm), with depth about 130 mm and 4 mm wall: σ ≈ 4.3 MPa. ✅ The floor and roof make it a closed tube,
  so the real stress is lower.
- **Door bolts on legs**, where the tunnel hangs from them alone. 20 kg at the mouth's outer corner gives
  31 N·m of tipping, pivoting on the boss's bottom edge: about 135 N of tension in each top bolt. It also
  gives 29 N·m of twist in the wall plane: about 125 N of shear per bolt. M4 stainless carries several kN.
  The 5 mm wall, backed by the inner ring, takes about 1.2 kN before a washer pulls through. ✅
- **Mounted, tipping over the landing's edge:** about 120 N on the door bolts. ✅

## 8. On legs: ramp tunnel and wide feet

Added 2026-11-25.

- **Ramp tunnel.** It touches the ground at three places: the two keel legs under the landing, and the
  ramp's V-belly where it reaches the ground. It is bolted to the door, so the door bolts carry little.
  - **Landing.** The 6 mm landing rests on a solid V-belly (printed with infill) for its whole width, so it
    doesn't span at all.
  - **Keel legs.** Each is 6 × 60 mm with a 40 × 40 mm foot. 20 kg on one leg is about 0.5 MPa in the
    leg, and about 120 kPa on the soil under its foot for the moment of a landing. A cat standing still on
    the landing presses far less. ✅
  - **Ramp.** The ramp rests on its belly all the way down, and on the ground for its last 80 mm or so. ✅
- **Wide feet.** The house (about 5 kg), a 20 kg design load and the tunnel's share come to about 260 N
  over 5 legs, about 52 N per leg. On an 84 mm foot (5 540 mm²) that's under 10 kPa. Loose dry sand
  carries about 50 kPa or more, so the feet won't sink. The old 28 mm foot pressed about 85 kPa. ✅

## Proof test before first use

1. **Floor.** With the house assembled (and mounted, if you're mounting it), put a 20 kg sandbag or a stack
   of books on a board on the floor centre for 10 minutes. Look for cracking at the floor seams and keys,
   and check that the floor doesn't sag by more than a few millimetres.
2. **Ledge.** Hang or set 10 kg on the outer edge of the ledge for 10 minutes (on the porch's outer corner
   too, if it runs past the house corner). With the tunnel, also set 10 kg on its floor at the mouth and on
   the middle of its roof.
3. **Roof.** Press firmly at the middle of the standing seam on each slope.
4. **Afterwards.** Re-tighten all the bolts. Recheck the screws and straps after the first hot month, since
   ASA settles a little under load.
