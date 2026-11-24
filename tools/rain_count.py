import sys, zlib, struct
def load(p):
    b = open(p, 'rb').read(); i = 8; idat = b''; W = H = 0
    while i < len(b):
        n = struct.unpack('>I', b[i:i+4])[0]; t = b[i+4:i+8]; d = b[i+8:i+8+n]; i += 12 + n
        if t == b'IHDR': W, H, bd, ct = struct.unpack('>IIBB', d[:10]); bpp = {2: 3, 6: 4}[ct]
        elif t == b'IDAT': idat += d
    raw = zlib.decompress(idat); stride = W*bpp; rows = []; prev = bytearray(stride); k = 0
    for y in range(H):
        f = raw[k]; line = bytearray(raw[k+1:k+1+stride]); k += 1 + stride
        for x in range(stride):
            a = line[x-bpp] if x >= bpp else 0; c = prev[x-bpp] if x >= bpp else 0; up = prev[x]
            if f == 1: line[x] = (line[x] + a) & 255
            elif f == 2: line[x] = (line[x] + up) & 255
            elif f == 3: line[x] = (line[x] + (a + up)//2) & 255
            elif f == 4:
                pp = a + up - c; pa, pb, pc = abs(pp-a), abs(pp-up), abs(pp-c)
                line[x] = (line[x] + (a if pa <= pb and pa <= pc else up if pb <= pc else c)) & 255
        rows.append(line); prev = line
    return W, H, bpp, rows
def classify(p):
    W, H, bpp, rows = load(p); cnt = {'red': 0, 'mag': 0, 'blue': 0}
    for line in rows:
        for x in range(0, W*bpp, bpp):
            r, g, b = line[x], line[x+1], line[x+2]
            if r > 50 and b > 50 and g < 0.3*min(r, b): cnt['mag'] += 1
            elif r > 50 and g < 0.3*r and b < 0.3*r: cnt['red'] += 1
            elif b > 50 and r < 0.3*b and g < 0.3*b: cnt['blue'] += 1
    return cnt
if __name__ == "__main__":
  for p in sys.argv[1:]: print(p.split('/')[-1], classify(p))
