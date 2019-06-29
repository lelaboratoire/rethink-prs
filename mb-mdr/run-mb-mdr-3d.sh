#!/bin/bash

FILES=$(ls reformated-data/*)
for fname in $FILES; do
  echo "Processing $fname file..."
  # run mbmdr on each file
  ./mbmdr-4.4.1-mac-64bits.out \
    --binary \
    -d 3D \
    -o "${fname%.*}_output_3D.txt" \
    -o2 "${fname%.*}_model_3D.txt" \
    "$fname" > /dev/null 2>&1
done
