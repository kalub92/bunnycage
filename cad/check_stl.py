"""Fails if any STL in stl/ is not watertight (every edge must join exactly two triangles)."""
import re, glob, collections, sys
bad_total = 0
for f in sorted(glob.glob('stl/*.stl')):
    v = [tuple(round(float(x), 4) for x in m) for m in re.findall(r'vertex\s+(\S+)\s+(\S+)\s+(\S+)', open(f).read())]
    e = collections.Counter()
    for i in range(0, len(v), 3):
        a, b, c = v[i:i + 3]
        for p, q in ((a, b), (b, c), (c, a)): e[(p, q)] += 1
    bad = sum(1 for (p, q), n in e.items() if n != 1 or e.get((q, p), 0) != 1)
    size = [round(max(c[i] for c in v) - min(c[i] for c in v), 1) for i in range(3)]
    print(f, len(v) // 3, 'tris | bad edges:', bad, '| size', size)
    bad_total += bad
sys.exit(1 if bad_total else 0)
