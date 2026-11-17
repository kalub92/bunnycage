#!/bin/sh
# Renders every STL and runs the interference check. Usage: cad/build.sh
set -e
cd "$(dirname "$0")/.."
mkdir -p stl guide/models
for p in body lid fit_test; do
  openscad -q -D "part=\"$p\"" -o "stl/bunnycage_$p.stl" cad/bunnycage.scad &
done
for p in lid r1 ring coil plug rx; do
  openscad -q -D "part=\"viz_$p\"" -o "guide/models/$p.stl" cad/bunnycage.scad &
done
wait
cp stl/bunnycage_body.stl guide/models/body.stl
# the guide is published as an Artifact, which only serves text files under a .txt name
for f in guide/models/*.stl; do mv "$f" "$f.txt"; done
# Check: the printed parts must not intersect the device or any component.
# detent_pre=-0.2 flattens the corner detents, which press on the device on purpose.
# Touching faces give vertices but zero facets; any real overlap gives facets.
if openscad -D 'part="check"' -D 'detent_pre=-0.2' -o stl/.check.stl cad/bunnycage.scad 2>&1 | grep -Eq "Facets: +0$|top level object is empty"; then
  echo "check OK: no interference"
else
  echo "check FAILED: parts intersect"; exit 1
fi
rm -f stl/.check.stl
ls -l stl guide/models
python3 cad/check_stl.py
