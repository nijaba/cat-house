"""Flatten Bambu Studio's system profiles (which inherit from each other) into the three standalone files the
Bambu Studio command line needs, with this project's print settings applied.

Usage: python3 -I tools/flatten_profiles.py [out_dir] [nozzle]   (defaults tools/slicer and 0.4; git-ignored)
       python3 -I tools/flatten_profiles.py tools/slicer06 0.6
Writes machine.json, process.json (house parts), process_strong.json (support brackets) and asa.json.
"""
import json, os, sys

BBL = '/Applications/BambuStudio.app/Contents/Resources/profiles/BBL'
NOZZLE = sys.argv[2] if len(sys.argv) > 2 else '0.4'
MACHINE = f'Bambu Lab H2D {NOZZLE} nozzle'
PROCESS = {'0.4': '0.20mm Standard @BBL H2D', '0.6': '0.30mm Standard @BBL H2D 0.6 nozzle'}[NOZZLE]
FILAMENT = f'Bambu ASA @BBL H2D {NOZZLE} nozzle'

# the house: 4 walls, 15 % gyroid, 5 top and bottom layers, 5 mm brim
HOUSE = {'wall_loops': '4', 'sparse_infill_density': '15%', 'sparse_infill_pattern': 'gyroid',
         'top_shell_layers': '5', 'bottom_shell_layers': '5', 'brim_type': 'outer_only', 'brim_width': '5'}
# load-bearing extras (printed support brackets)
STRONG = {**HOUSE, 'wall_loops': '6', 'sparse_infill_density': '40%', 'top_shell_layers': '6', 'bottom_shell_layers': '6'}


def index(kind):
    out = {}
    for f in os.listdir(os.path.join(BBL, kind)):
        if f.endswith('.json'):
            p = os.path.join(BBL, kind, f)
            try:
                d = json.load(open(p))
            except ValueError:
                continue
            out[d.get('name', f[:-5])] = p
    return out


def flatten(kind, name, idx):
    d = json.load(open(idx[name]))
    parent = d.get('inherits')
    base = flatten(kind, parent, idx) if parent else {}
    base.update({k: v for k, v in d.items() if k != 'inherits'})
    return base


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), 'slicer')
    os.makedirs(out, exist_ok=True)
    m = flatten('machine', MACHINE, index('machine'))
    p = flatten('process', PROCESS, index('process'))
    f = flatten('filament', FILAMENT, index('filament'))
    for d in (m, p, f):
        d['from'] = 'system'   # the CLI rejects "user" profiles it can't match to a printer
    json.dump(m, open(os.path.join(out, 'machine.json'), 'w'), indent=1)
    json.dump({**p, **HOUSE}, open(os.path.join(out, 'process.json'), 'w'), indent=1)
    json.dump({**p, **STRONG}, open(os.path.join(out, 'process_strong.json'), 'w'), indent=1)
    json.dump(f, open(os.path.join(out, 'asa.json'), 'w'), indent=1)
    print('wrote profiles to', out)


main()
