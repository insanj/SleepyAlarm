#!/bin/bash
pngcrush_options=-reduce -brute -l9
find . -name '*.png' -print | while read f; do
  pngcrush $pngcrush_options -e '.pngcrushed' "$f"
  mv "$f" "${f/%.pngcrushed/}"
done