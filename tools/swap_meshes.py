"""Replace the meshes inside Bambu Studio project files with the current STLs from stl/, keeping every plate,
position and setting. Each object is matched by its name (corner_fl.stl -> stl/corner_fl.stl, or
stl/test/<name>). Bambu stores a mesh centred on its bounding box, so a part whose bounding box changed is
reported and left alone (re-export that project instead).

Usage: python3 -I tools/swap_meshes.py [--grow name.stl=old.stl ...] release/<file>.3mf [...]
  --grow lets a part's bounding box change: old.stl is the part as it was when the project was made, and the
  part's old geometry stays exactly where it was on the plate while the new parts of it extend around it.
Then run tools/fix_3mf.py on the same files.
"""
import os, re, struct, sys, zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read_stl(path):
    data = open(path, 'rb').read()
    if data[:5] == b'solid' and b'facet' in data[:300]:
        v = [tuple(map(float, l.split()[1:4])) for l in data.decode().splitlines() if l.strip().startswith('vertex')]
        return [v[i:i + 3] for i in range(0, len(v), 3)]
    n = struct.unpack('<I', data[80:84])[0]
    out = []
    for i in range(n):
        f = struct.unpack('<12f', data[84 + 50 * i:84 + 50 * i + 48])
        out.append([f[3:6], f[6:9], f[9:12]])
    return out


def bbox(points):
    return [(min(p[i] for p in points), max(p[i] for p in points)) for i in range(3)]


def mesh_xml(tris, centre):
    idx, verts, faces = {}, [], []
    for t in tris:
        f = []
        for p in t:
            k = tuple(round(p[i] - centre[i], 5) for i in range(3))
            if k not in idx:
                idx[k] = len(verts)
                verts.append(k)
            f.append(idx[k])
        if len(set(f)) == 3:
            faces.append(f)
    v = ''.join(f'\n     <vertex x="{x:g}" y="{y:g}" z="{z:g}"/>' for x, y, z in verts)
    t = ''.join(f'\n     <triangle v1="{a}" v2="{b}" v3="{c}"/>' for a, b, c in faces)
    return f'<vertices>{v}\n    </vertices>\n    <triangles>{t}\n    </triangles>', len(faces)


def swap(path):
    z = zipfile.ZipFile(path)
    items = [(i, z.read(i.filename)) for i in z.infolist()]
    z.close()
    files = {i.filename: d for i, d in items}
    ms = files['Metadata/model_settings.config'].decode()
    top = files['3D/3dmodel.model'].decode()
    # object id -> name, and object id -> its mesh file
    names = {m.group(1): re.search(r'key="name" value="([^"]+)"', m.group(2)).group(1)
             for m in re.finditer(r'<object id="(\d+)">(.*?)</object>', ms, re.S)}
    comp = {m.group(1): m.group(2).lstrip('/') for m in re.finditer(
        r'<object id="(\d+)"[^>]*>\s*<components>\s*<component p:path="([^"]+)"', top)}
    new_files, counts, grow_shift = {}, {}, {}
    for oid, name in names.items():
        if oid not in comp:
            continue
        stl = next((p for p in (os.path.join(ROOT, 'stl', name), os.path.join(ROOT, 'stl', 'test', name)) if os.path.exists(p)), None)
        if not stl:
            print(f'  {name}: no STL, left as it was')
            continue
        old = files[comp[oid]].decode()
        ov = [tuple(map(float, v)) for v in re.findall(r'<vertex x="([^"]+)" y="([^"]+)" z="([^"]+)"', old)]
        tris = read_stl(stl)
        nb = bbox([p for t in tris for p in t])
        ob = bbox(ov)
        if name in GROW:
            rb = bbox([p for t in read_stl(GROW[name]) for p in t])
            if any(abs((rb[i][1] - rb[i][0]) - (ob[i][1] - ob[i][0])) > 0.02 for i in range(3)):
                print(f'  {name}: the reference STL does not match the project mesh; left as it was')
                continue
            # shift the mesh's origin with the bounding-box centre, and the component offset by the same amount
            shift = [(nb[i][0] + nb[i][1]) / 2 - (rb[i][0] + rb[i][1]) / 2 for i in range(3)]
            centre = [(rb[i][0] + rb[i][1]) / 2 - (ob[i][0] + ob[i][1]) / 2 + shift[i] for i in range(3)]
            body, n = mesh_xml(tris, centre)
            new_files[comp[oid]] = re.sub(r'<vertices>.*</triangles>', lambda _: body, old, flags=re.S).encode()
            counts[oid] = n
            grow_shift[oid] = shift
            print(f'  {name}: {len(re.findall("<triangle ", old))} -> {n} triangles, grown by {[round(v, 2) for v in shift]} (centre)')
            continue
        if any(abs((nb[i][1] - nb[i][0]) - (ob[i][1] - ob[i][0])) > 0.02 for i in range(3)):
            print(f'  {name}: bounding box changed {[round(b[1] - b[0], 2) for b in ob]} -> {[round(b[1] - b[0], 2) for b in nb]}; left as it was')
            continue
        centre = [(nb[i][0] + nb[i][1]) / 2 - (ob[i][0] + ob[i][1]) / 2 for i in range(3)]
        body, n = mesh_xml(tris, centre)
        new_files[comp[oid]] = re.sub(r'<vertices>.*</triangles>', lambda _: body, old, flags=re.S).encode()
        counts[oid] = n
        print(f'  {name}: {len(re.findall("<triangle ", old))} -> {n} triangles')
    # keep the face counts Bambu Studio records per object in step
    def fix_count(m):
        oid = m.group(1)
        if oid in counts:
            return re.sub(r'<metadata face_count="\d+"/>', f'<metadata face_count="{counts[oid]}"/>', m.group(0))
        return m.group(0)
    ms = re.sub(r'<object id="(\d+)">.*?</object>', fix_count, ms, flags=re.S)
    new_files['Metadata/model_settings.config'] = ms.encode()
    # grown parts: move the component by the centre shift so the old geometry stays put
    def fix_comp(m):
        oid = m.group(1)
        if oid not in grow_shift:
            return m.group(0)
        t = list(map(float, m.group(3).split()))
        if t[:9] != [1, 0, 0, 0, 1, 0, 0, 0, 1]:
            raise SystemExit(f'object {oid}: rotated component, not handled')
        t[9:12] = [t[9 + i] + grow_shift[oid][i] for i in range(3)]
        return m.group(0).replace(m.group(3), ' '.join(f'{v:g}' for v in t))
    top = re.sub(r'<object id="(\d+)"[^>]*>\s*<components>\s*<component p:path="([^"]+)"[^>]*transform="([^"]+)"', fix_comp, top)
    new_files['3D/3dmodel.model'] = top.encode()
    tmp = path + '.tmp'
    with zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as w:
        for info, data in items:
            w.writestr(info, new_files.get(info.filename, data))
    os.replace(tmp, path)


GROW = {}
args = sys.argv[1:]
while args and args[0] == '--grow':
    k, v = args[1].split('=', 1)
    GROW[k] = v
    args = args[2:]
for p in args:
    print(os.path.basename(p))
    swap(p)
