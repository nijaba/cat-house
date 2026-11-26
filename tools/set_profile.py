"""Give a Bambu Studio project file another project's printer, process and filament profile, keeping its plates,
parts and positions. Used to move the 0.4 mm project files to the 0.6 mm nozzle.

Usage: python3 -I tools/set_profile.py REFERENCE.3mf TARGET.3mf [key=value ...]
  REFERENCE.3mf: a project file already set up the way you want (e.g. release/cat_cottage_H2D_tunnel_body.3mf)
  key=value:     process settings to override in TARGET (e.g. wall_loops=6 sparse_infill_density=40%)
The target's own filament colour is kept. Run tools/fix_3mf.py on TARGET afterwards.
"""
import json, os, sys, zipfile


def read(path, name):
    with zipfile.ZipFile(path) as z:
        return z.read(name)


def main():
    ref, target, *overrides = sys.argv[1:]
    cfg = json.loads(read(ref, 'Metadata/project_settings.config'))
    old = json.loads(read(target, 'Metadata/project_settings.config'))
    cfg['filament_colour'] = old.get('filament_colour', cfg.get('filament_colour'))
    for kv in overrides:
        k, v = kv.split('=', 1)
        cfg[k] = v
    with zipfile.ZipFile(target) as z:
        items = [(i, z.read(i.filename)) for i in z.infolist()]
    tmp = target + '.tmp'
    with zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as w:
        for info, data in items:
            if info.filename == 'Metadata/project_settings.config':
                data = json.dumps(cfg, indent=4).encode()
            w.writestr(info, data)
    os.replace(tmp, target)
    print(f'{os.path.basename(target)}: now {cfg.get("print_settings_id")}, nozzle {cfg.get("nozzle_diameter")}'
          + (f', {" ".join(overrides)}' if overrides else ''))


main()
