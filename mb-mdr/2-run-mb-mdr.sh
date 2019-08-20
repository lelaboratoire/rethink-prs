#!/bin/bash

FILES=$(ls reformatted-data/train/hibachi*)
for fname in $FILES; do
  echo "Processing $fname file..."
  # run mbmdr on each file
  for dimension in 1D 2D 3D; do
    ./mbmdr-4.4.1-mac-64bits.out \
      --binary \
      -d $dimension \
      -o "${fname%.*}_output_$dimension.txt" \
      -o2 "${fname%.*}_model_$dimension.txt" \
      "$fname" > /dev/null 2>&1
  done
done

mv -f reformatted-data/train/*_1D.txt results/
mv -f reformatted-data/train/*_2D.txt results/
mv -f reformatted-data/train/*_3D.txt results/
