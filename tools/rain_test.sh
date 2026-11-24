#!/bin/bash
# Driven-rain line-of-sight test: renders the house along the rain direction for 8 wind directions and
# 3 storm angles (plus vertical) with marker-coloured sheets inside, then counts the marker pixels.
# Usage: tools/rain_test.sh [OUT] [-D extra=settings ...]   (default OUT rain; about 30 s)
# e.g. tools/rain_test.sh rain_tunnel -D door_tunnel=true -D 'mount="fence"' -D show_legs=false
set -euo pipefail
cd "$(dirname "$0")"
OS="${OPENSCAD:-/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD}"
out="${1:-rain}"; shift || true; extra=("$@")
mkdir -p "$out"
r() { "$OS" -o "$out/$1.png" -D 'part="none"' -D 'show_cushion=false' -D 'pane_alpha=1' ${extra[@]+"${extra[@]}"} "${@:3}" \
      --imgsize=1200,1200 --camera=0,0,150,$2,1400 --projection=ortho --colorscheme=Tomorrow rain_test.scad >/dev/null 2>&1; }
r calib 0,0,0 -D calib=true
r a00_000 0,0,0
for a in 35 55 70; do for z in 0 45 90 135 180 225 270 315; do
  while (( $(jobs -r | wc -l) >= 6 )); do sleep 0.5; done
  r "a${a}_$(printf %03d $z)" $a,0,$z &
done; done
wait
python3 -I rain_count.py "$out"/*.png | tee "$out/counts.txt"
