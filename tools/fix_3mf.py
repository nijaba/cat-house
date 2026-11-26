"""Make Bambu Studio keep this project's settings when it opens a project file exported by the command line.

The command line writes every setting into Metadata/project_settings.config, but leaves
"different_settings_to_system" empty. Bambu Studio reads that list to know which values differ from its
built-in profile, so it silently reloads the plain profile (no supports, 2 walls, ...). This script fills in
the list by comparing with the built-in profiles.

Supports are built into the parts (breakaway combs and lattices in cat_house.scad), so slicer supports stay off.
Only the hinge test coupon, which predates them, still gets slicer supports; any per-object support switched on
by an older version of this script is removed from the other parts.

Usage: python3 -I tools/fix_3mf.py release/*.3mf
"""
import json, os, re, sys, zipfile

BBL = '/Applications/BambuStudio.app/Contents/Resources/profiles/BBL'
SKIP = {'name', 'from', 'inherits', 'setting_id', 'instantiation', 'version', 'compatible_printers',
        'compatible_printers_condition', 'renamed_from', 'type', 'description', 'filament_id',
        'print_settings_id', 'filament_settings_id', 'printer_settings_id'}
NEEDS_SUPPORT = {'hinge_cap.stl'}
SUPPORT_KEYS = ('enable_support', 'support_type', 'support_threshold_angle', 'support_on_build_plate_only',
                'support_critical_regions_only')
# settings Bambu's built-in profile may leave to the app's own defaults: always record them as ours
FORCE = ['brim_type', 'brim_width', 'enable_support', 'support_type', 'wall_loops', 'sparse_infill_density',
         'sparse_infill_pattern', 'top_shell_layers', 'bottom_shell_layers']
FORCE_FILAMENT = ['activate_air_filtration', 'during_print_exhaust_fan_speed', 'complete_print_exhaust_fan_speed']
# printer settings we change: the H2D's cooling filter (it has no "air filtration" of its own)
MACHINE_SET = {'cooling_filter_enabled': '1'}
# filament colour shown in Bambu Studio, by project file: white roof, grey walls, green trim
COLOURS = [('_roof', '#FFFFFF'), ('_walls', '#A7ABAD'), ('_trim', '#3F7D4E'), ('_tunnel_body', '#3F7D4E'),
           ('_test_coupons', '#FFFFFF'), ('_test_breakaway', '#A7ABAD')]
# Brim rule (ASA): every part gets the project's 5 mm outer brim against warping. A part taller than 100 mm whose
# first layer covers less than 40 % of its footprint gets 8 mm, and less than 15 % gets 10 mm, set on the part
# itself. Measured 2026-11-26: landing (tunnel_body) 291 mm tall on 12 %, ridge caps 272 on 8 %, ramp 263 on 38 %.
BRIM = {'ridge_front.stl': 10, 'ridge_back.stl': 10, 'ridge_pair.stl': 10, 'tunnel_body.stl': 10, 'tunnel_ramp.stl': 8,
        'hinge_cap.stl': 8, 'leg.stl': 6}
OBJECT_SUPPORT = [('enable_support', '1'), ('support_type', 'tree(auto)'), ('support_threshold_angle', '30'),
                  ('support_on_build_plate_only', '0')]

_idx = {}


def index(kind):
    if kind not in _idx:
        out = {}
        for f in os.listdir(os.path.join(BBL, kind)):
            if f.endswith('.json'):
                try:
                    d = json.load(open(os.path.join(BBL, kind, f)))
                except ValueError:
                    continue
                out[d.get('name', f[:-5])] = os.path.join(BBL, kind, f)
        _idx[kind] = out
    return _idx[kind]


def flatten(kind, name):
    d = json.load(open(index(kind)[name]))
    base = flatten(kind, d['inherits']) if d.get('inherits') else {}
    base.update({k: v for k, v in d.items() if k != 'inherits'})
    return base


def diff_keys(project, system):
    keys = []
    for k, v in system.items():
        if k in SKIP or k not in project:
            continue
        pv = project[k]
        if isinstance(v, list) and not isinstance(pv, list):
            pv = [pv]
        if isinstance(pv, list) and isinstance(v, list) and len(pv) != len(v) and len(set(map(str, v))) == 1:
            v = [v[0]] * len(pv)   # system lists one value per extruder; the project may carry more
        if str(pv) != str(v):
            keys.append(k)
    return ';'.join(sorted(keys))


def fix(path):
    z = zipfile.ZipFile(path)
    items = [(i, z.read(i.filename)) for i in z.infolist()]
    z.close()
    out = []
    names = set(re.findall(r'<metadata key="name" value="([^"]+\.stl)"/>',
                           next(d for i, d in items if i.filename == 'Metadata/model_settings.config').decode()))
    for info, data in items:
        if info.filename == 'Metadata/project_settings.config':
            cfg = json.loads(data)
            if not names & NEEDS_SUPPORT:   # supports are built into the parts: none from the slicer
                cfg['enable_support'] = '0'
            # the command line records the extruders' nozzle as 0.4 whatever the profile; Bambu Studio sees the
            # mismatch with the printer and reloads its default settings (2 walls, 3 shells, grid...), so match it
            if cfg.get('nozzle_diameter'):
                cfg['extruder_nozzle_diameter'] = list(cfg['nozzle_diameter'])
            if cfg['print_settings_id'] not in index('process'):   # an older export renamed the profile
                cfg['print_settings_id'] = cfg['print_settings_id'].rsplit(' ', 1)[0]
            p = diff_keys(cfg, flatten('process', cfg['print_settings_id']))
            p = ';'.join(sorted(set(filter(None, p.split(';'))) | {k for k in FORCE if k in cfg}))
            fils = cfg.get('filament_settings_id') or []
            f = [diff_keys(cfg, flatten('filament', n)) if n in index('filament') else '' for n in fils]
            f = [';'.join(sorted(set(filter(None, x.split(';'))) | {k for k in FORCE_FILAMENT if k in cfg})) for x in f]
            for key, colour in COLOURS:
                if key in os.path.basename(path) and 'filament_colour' in cfg:
                    cfg['filament_colour'] = [colour] * len(cfg['filament_colour'])
            for k, v in MACHINE_SET.items():
                if k in cfg:
                    cfg[k] = v
            m = diff_keys(cfg, flatten('machine', cfg['printer_settings_id']))
            cfg['different_settings_to_system'] = [p] + f + [m]
            data = json.dumps(cfg, indent=4).encode()
            print(f"{os.path.basename(path)}: process differs in {len(p.split(';')) if p else 0} settings"
                  f" ({'supports on' if cfg.get('enable_support') == '1' else 'supports off'} globally)")
        elif info.filename == 'Metadata/model_settings.config':
            text = data.decode()

            def add(m):
                block = m.group(0)
                name = re.search(r'<metadata key="name" value="([^"]+)"', block).group(1)
                kv = []
                if name not in NEEDS_SUPPORT:   # drop slicer supports an older version of this script switched on
                    block = re.sub(r'\n\s*<metadata key="(%s)" value="[^"]*"/>' % '|'.join(SUPPORT_KEYS), '', block)
                elif 'key="enable_support"' not in block:
                    kv += OBJECT_SUPPORT
                if name in BRIM:   # (replacing any brim an older version of this script set)
                    block = re.sub(r'\n\s*<metadata key="(brim_type|brim_width)" value="[^"]*"/>', '', block)
                    kv += [('brim_type', 'outer_only'), ('brim_width', str(BRIM[name]))]
                if not kv:
                    return block
                extra = ''.join(f'\n    <metadata key="{k}" value="{v}"/>' for k, v in kv)
                return re.sub(r'(<metadata key="name" value="[^"]+"/>)', r'\1' + extra, block, count=1)

            text, n = re.subn(r'<object id="\d+">.*?</object>', add, text, flags=re.S)
            hits = len(re.findall(r'<metadata key="enable_support" value="1"/>', text))
            brims = len(re.findall(r'<metadata key="brim_width" value="\d+"/>', text))
            if hits or brims:
                print(f"    per-object: supports on {hits}, wider brim {brims}")
            data = text.encode()
        out.append((info, data))
    tmp = path + '.tmp'
    with zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as w:
        for info, data in out:
            w.writestr(info, data)
    os.replace(tmp, path)


for p in sys.argv[1:]:
    fix(p)
