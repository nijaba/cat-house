# MakerWorld release plan: Cat Cottage

Status (2026-11-20): files and texts are ready. Publishing is **blocked on real print photos**: MakerWorld
won't accept the model without them (see section 1).

## 1. What MakerWorld requires, and where we stand

Sources: the [Model Upload Guidelines](https://wiki.bambulab.com/en/makerworld/tutorials/model-upload-guidelines),
the [Print Profile Upload Guidelines](https://wiki.bambulab.com/en/makerworld/tutorials/print-profile-upload),
[How to Upload Models](https://wiki.bambulab.com/en/makerworld/tutorials/how-to-upload-models), and the
[Community Guidelines](https://makerworld.com/en/community-guidelines) (updated 27 April 2026), all read
on 2026-11-20.

| Requirement | Rule | Status |
|---|---|---|
| Real photos | "at least three real printed images from different angles" that match the files. The cover should be a real photo; a render may be the cover only if it "closely match[es] the actual model". Blurry, cropped, unfinished or unassembled prints don't count. | ❌ **Print the house first**, then take ≥ 3 photos of the assembled house (front 3/4, side, a close-up of the roof or door; ideally a cat inside). |
| Print profile photos | Each print profile needs at least one photo of a print made with that profile. | ❌ Same photos, plus one of the mounted version if we publish the mounted profile. |
| Upload type | "Original", since it isn't a remix. | ✅ |
| Files | Raw model files (STL, SCAD and STEP are all accepted) plus a Bambu Studio 3MF as the print profile. Don't split one model across several uploads or profiles; variants go on separate plates. | ✅ `stl/*.stl`, `cat_house.scad`, and two profiles in this folder (see section 2). |
| Cloud slicing check | Each profile is re-sliced in the cloud: 5 min per plate, 15 min per file. It must use Bambu printer and filament presets only, and parts must stay clear of the plate edges and avoidance zones. | ✅ Local slicing with the stock Bambu ASA / H2D presets takes about 20–60 s per plate. Re-check the edge clearance in Bambu Studio after naming the plates. |
| Printer compatibility | The upload page lists the printers to check. | ⚠️ The corner modules are 317 mm tall, so only the H2 series fits (H2D and H2S). Untick the X1, P1, A1 and P2S. |
| Title, description, category, tags | Required, and they must match the files. Profile titles must not say "fast", "best", "perfect", "guaranteed" or "official". | ✅ Drafted in section 3. |
| Licence | Choose one: Standard Digital File License, CC BY, CC BY-SA, CC BY-NC, CC BY-NC-SA, CC BY-ND, CC BY-NC-ND or CC0. (CC0 additionally needs a photo of your own print.) | ✅ **CC BY-NC-SA 4.0** (decided 2026-11-20). |
| AI-generated content | MakerWorld asks creators to label models that are "mostly or entirely AI-generated" as AIGC; mislabelled models can lose visibility or be removed. AI-generated images are not allowed as model photos. | ✅ **Tick the AIGC label** (decided 2026-11-20) and keep the one-line note at the end of the description. The OpenSCAD renders are not AI images, but keep them in the gallery after the real photos, not as the cover. |
| Bill of materials | Optional. A BOM field lists filaments and non-printed parts. | ✅ Add the stainless hardware and Bambu ASA. The list is in the README. |
| Off-platform links | The guidelines forbid using the account to "redirect users off-platform". | ✅ The repo is public: https://github.com/nijaba/cat-house. Keep the page self-contained, with one plain "Source" link at the end of the description. |
| Customize button (Parametric Model Maker) | Uploading the `.scad` adds a **Customize** button. It runs OpenSCAD with the Customizer parameters on Bambu's servers. | ✅ Plain OpenSCAD with no libraries. ⚠️ Rendering takes about 35 s per corner module and longer for a roof panel, so check that MakerWorld's renderer doesn't time out. If it does, mention it in the description. |
| Exclusive programme | Needs 100 cumulative prints across your models first. | ➖ Not eligible yet; leaves us free to post elsewhere too. |

## 2. Files to upload

- **Raw files:** every STL in `stl/` (32 files), `cat_house.scad`, and the README as the printing guide
  (paste its key sections into the description).
- **Print profile 1 — "On legs":** `release/cat_cottage_H2D_on_legs.3mf`, 12 plates on the H2D with a
  0.4 mm nozzle, 0.20 mm layers, Bambu ASA, the textured PEI plate, 4 walls, 15 % gyroid and a 5 mm brim.
  The big parts (corners, roof panels) get a plate each; the small parts share plates.
- **Print profile 2 — "Fence or tree mount with landing ledge":** `release/cat_cottage_H2D_mounted.3mf`
  (13 plates). It uses the `_mount` corners and roof panels, the step-less door surround and the ledge, and
  holds both mount sets, so the description says to print either the fence or the tree plates.
- **Print profile 3 — "Printed support brackets (optional)":** `release/cat_cottage_H2D_printed_brackets.3mf`
  (2 plates, one bracket each, 6 walls and 40 % gyroid). For mounted houses that use printed brackets
  instead of steel ones.
- **Before uploading:** open each 3MF in Bambu Studio, name the plates ("Corner FL + small parts", …,
  "Fence mount (optional)"), slice once to confirm, then save. This is allowed as a separate profile
  because it is a variant with different parts.

## 3. Listing text (draft)

**Model name:** Cat Cottage – Weatherproof Outdoor Cat House (parametric, H2D)

**Category:** Household → Pets, or the closest pet category on the upload form.

**Tags:** cat house, outdoor cat house, cat shelter, pet house, feral cat shelter, weatherproof, ASA,
H2D, large format, OpenSCAD, parametric, customizable, cottage, tree mount, fence mount

**Description:**

> A cosy cottage for an outdoor cat that holds up to sun, heat and storms. It has lap siding,
> board-and-batten gables, shuttered windows, a fish-scale shingle roof, and a round entrance with a
> rain hood.
>
> **Sized for** a cat of about 5 kg and a standard **40 × 40 cm (16 in) cushion or round pet bed**.
> The interior is 43 × 43 cm. Use the Customize button for other cushion sizes.
>
> **Weatherproof by design.** Deep roof overhangs, the hood and a raised sill keep rain off the
> entrance. Shingles, a standing seam and battens cover every joint. Every ledge has a sloped top, so
> nothing holds water. The floor has drainage ribs and 124 drain holes and sits 6 cm up on legs. Slanted
> louvres in the gable and under the eaves let hot air out.
>
> **Build it your way.** Stand it on its legs, or hang it on a fence, wall or tree. The mount goes on
> the long side wall and a landing ledge leads to the door. It hangs on a French cleat with lock
> screws on a fence, or on a strapped tree plate; two steel shelf brackets carry it from below.
> Checked by hand for a 20 kg load.
>
> **Prints without supports** on a Bambu Lab **H2D or H2S**. The corner modules are 317 mm tall, so
> it needs an H2-series build volume. There are 4 corner modules that bolt together, 4 roof panels,
> a ridge cap, the door surround and the legs.
>
> **Material:** ASA is strongly recommended for outdoor use; PLA softens in summer sun. Light colours
> keep it cooler.
> **Filament:** 4.2 kg on legs, 4.5 kg on a fence, 5.1 kg on a tree, so buy 5–6 × 1 kg spools.
> **Opening roof:** one slope lifts on a ridge hinge and stays open on its own, held shut by two
> turn-button latches, so you can swap the cushion without tools. A rib under the ridge cap and foam
> under the lid keep it watertight. A glazed peek window shows whether the cat is home.
> A one-way escape flap in the back wall lets the cat out but stays shut against wind.
> **Print time:** about 130 h with a 0.4 mm nozzle; a 0.6 mm nozzle is much faster on the big parts.
> **Hardware:** stainless M4/M5/M6 bolts and #8 roofing screws with EPDM washers (full list in the
> BOM).
>
> **Assembly:** (paste the 8 assembly steps from the README)
>
> *Designed in OpenSCAD with the help of an AI assistant (Claude); every part was test-sliced, and the
> photos show my own print.*
>
> Source (OpenSCAD, build script, guide): https://github.com/nijaba/cat-house

**Print profile titles:**
- `H2D 0.4 · ASA · On legs · 10 plates`
- `H2D 0.4 · ASA · Fence/tree mount + landing ledge · 11 plates`

## 4. Where to announce, in order

1. **MakerWorld itself.** Tick **"Community Post"** when publishing, which syncs an announcement to the
   community feed. Also check [makerworld.com/contests](https://makerworld.com/contests) for a running
   pets, home or outdoor contest and enter it if one fits.
2. **Bambu Lab forum** ([forum.bambulab.com](https://forum.bambulab.com)), in the MakerWorld or showcase
   category. H2D owners hang out there, and they are the only people who can print it as-is.
3. **Reddit**, spread over a few days and each post with real photos:
   - r/BambuLab: the H2D angle
   - r/functionalprint: it requires photos of the part in use, so it needs a cat-in-house photo
   - r/3Dprinting: use the "Show-off" flair and follow its self-promotion ratio rules
   - r/openscad: the parametric, plain-OpenSCAD angle
   - Read each subreddit's rules before posting; some ban links in the post body and want them in a
     comment.
4. **Community-cat / TNR groups** on Facebook and Nextdoor, and local Florida groups. These are people
   who build shelters for outdoor cats. Lead with the cat and the weatherproofing, not the printer.
5. **Short video** (Instagram Reels, TikTok or YouTube Shorts): a time-lapse of a corner module printing,
   the assembly, and the cat moving in. Use the same text with the MakerWorld link in the bio or caption.

Post on MakerWorld first and wait until the listing is live. Then share the link, and answer comments
for the first two days, because early engagement drives MakerWorld's ranking.

## 5. Announcement texts (drafts)

**Bambu forum / r/BambuLab**

> **Title:** I designed a weatherproof outdoor cat cottage for the H2D: 4 kg of ASA, no supports
>
> Our outdoor cat needed a proper house for Florida weather, so I designed one to use the H2D's full
> build height. It has 4 corner modules (317 mm tall) that bolt together, a fish-scale shingle roof in
> 4 panels, and a round door with a rain hood. The floor has drainage ribs and sits on legs, and louvres
> vent the heat.
>
> It's fully parametric in OpenSCAD. It's sized for a 40 cm cushion, but you can change that with
> MakerWorld's Customize button. You can stand it on legs or mount it on a fence, wall or tree, with
> a landing ledge to the door.
>
> Print profiles for the H2D are included (10–11 plates, Bambu ASA, about 130 h). Free on MakerWorld:
> [link]
>
> Happy to answer questions about the design, ASA on the H2D, or holding up in a hurricane season.

**r/functionalprint**

> **Title:** Outdoor cat house that drains, vents and survives the Florida sun (ASA, 4 kg)
>
> [photo of the cat in the house] Bolt-together modules, shingled roof with a standing seam, raised
> floor with 124 drain holes, slanted louvres. Stainless hardware throughout. Hangs on a fence with a
> French cleat or straps to a tree. Files and assembly guide: [link]

**r/openscad**

> **Title:** A parametric cat cottage in plain OpenSCAD (no libraries) that splits itself into
> bed-sized parts
>
> Change the cushion size and it re-sizes the house, then checks that every part still fits a
> 325 × 320 × 325 mm bed (`assert`s on each part). It flattens the roof panels and ridge caps into
> print orientation and exports everything with one script. The textures are all CSG: V-groove lap
> siding, fish-scale shingles, louvres. Code and STLs: [link]

**Facebook / TNR groups**

> Made a 3D-printed outdoor cat house built for Florida weather. It's raised off the ground, the floor
> drains, rain stays out of the door, and it's vented for summer heat. It fits a standard 40 cm cat
> bed and can hang on a fence or tree, with a ledge up to the door. The design is free if you or
> someone you know has a large 3D printer: [link]

**Short-video caption**

> Printed a cottage for our outdoor cat 🐈 4 kg of ASA, 130 hours, zero supports. Free files on
> MakerWorld. #3Dprinting #BambuLab #H2D #cathouse #catsofinstagram

## 6. Remaining to-do before publishing

- [ ] Print and assemble the house; take ≥ 3 real photos (plus a cat, plus the mounted version if
      publishing profile 2)
- [x] Licence: CC BY-NC-SA 4.0
- [x] AIGC label: on
- [ ] Name the plates in the 3MFs in Bambu Studio, slice, save
- [x] GitHub repo public and linked in the description
- [ ] Publish on MakerWorld with Community Post on, then work down section 4
