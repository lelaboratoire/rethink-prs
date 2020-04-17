#!/bin/bash

fname="data/reformat_heart_failure.txt"
# run mbmdr on real data file
echo "Processing $fname file..."
for dimension in 1D 2D; do
  ./mbmdr-4.4.1-linux-64bits.out \
    --binary \
    -ac 12 \
    -d $dimension \
    -o "${fname%.*}_output_$dimension.txt" \
    -o2 "${fname%.*}_model_$dimension.txt" \
    "$fname" > /dev/null 2>&1
done

