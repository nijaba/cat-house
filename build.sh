#!/bin/bash
# Export every printable part to stl/ and render the previews in renders/.
# Usage: ./build.sh [stl|png|all]   (default: all)
set -euo pipefail
cd "$(dirname "$0")"
OS="${OPENSCAD:-/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD}"
what="${1:-all}"
mkdir -p stl renders

parts=(corner_fl corner_fr corner_bl corner_br roof_fl roof_fr roof_bl roof_br
       ridge_front ridge_back ridge_saddle door_surround door_inner_ring leg center_leg
       bowtie_key fence_house_cleat fence_post_cleat fence_standoff tree_plate landing latch_keeper latch_button window_retainer)

if [[ "$what" == stl || "$what" == all ]]; then
  jobs_max=$(sysctl -n hw.ncpu 2>/dev/null || echo 4)
  run() { "$OS" -o "stl/$1.stl" "${@:2}" cat_house.scad >/dev/null 2>"stl/.$1.log" && echo "ok   $1" || echo "FAIL $1 (see stl/.$1.log)"; }
  for p in "${parts[@]}"; do
    while (( $(jobs -r | wc -l) >= jobs_max )); do sleep 1; done
    run "$p" -D "part=\"$p\"" &
  done
  # mount-side (right) corners and roof panels: bolt holes, no windows, short eave (tree or fence)
  for p in corner_fr corner_br roof_fr roof_br door_surround; do run "${p}_mount" -D "part=\"$p\"" -D 'mount="fence"' & done
  wait
fi

if [[ "$what" == png || "$what" == all ]]; then
  common=(--colorscheme=Tomorrow)
  "$OS" -o renders/assembly_front.png --imgsize=1600,1300 --camera=0,0,110,72,0,330,1650 "${common[@]}" cat_house.scad
  "$OS" -o renders/assembly_front_gable.png --imgsize=1600,1300 --camera=0,0,120,68,0,8,1750 "${common[@]}" cat_house.scad
  "$OS" -o renders/assembly_fence_mount.png --imgsize=1600,1300 --camera=60,0,60,74,0,42,2200 -D 'mount="fence"' -D 'show_legs=false' "${common[@]}" cat_house.scad
  "$OS" -o renders/assembly_tree_mount.png --imgsize=1600,1300 --camera=60,0,60,74,0,42,2300 -D 'mount="tree"' -D 'show_legs=false' "${common[@]}" cat_house.scad
  "$OS" -o renders/landing.png --imgsize=1400,1100 --camera=150,-150,40,62,0,40,1150 -D 'mount="fence"' -D 'show_legs=false' "${common[@]}" cat_house.scad
  "$OS" -o renders/roof_open.png --imgsize=1600,1300 --camera=-60,0,170,52,0,22,1900 -D 'open_angle=115' "${common[@]}" cat_house.scad
  "$OS" -o renders/exploded.png --imgsize=1600,1400 --camera=0,0,150,68,0,330,2500 -D 'part="exploded"' "${common[@]}" cat_house.scad
  # single-part views from the exported STL (needs ./build.sh stl first)
  if [[ -f stl/corner_fl.stl ]]; then
    v="$(mktemp -d)/view.scad"
    echo "color(\"#F3E2B3\") import(\"$PWD/stl/corner_fl.stl\");" > "$v"
    "$OS" -o renders/corner_fl_outside.png --imgsize=1200,1100 --camera=-110,-110,160,70,0,325,1000 "${common[@]}" "$v"
    "$OS" -o renders/corner_fl_inside.png --imgsize=1200,1100 --camera=-110,-110,160,62,0,140,1000 "${common[@]}" "$v"
  fi
  "$OS" -o renders/plate_layout.png --imgsize=2000,1300 --camera=880,-360,0,0,0,0,3300 --projection=ortho -D 'part="layout"' "${common[@]}" cat_house.scad
fi
