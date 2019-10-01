#!/bin/bash

fname="reformatted-data/real-train/Glaucoma_results_snps_pval0.01_6PCs_prune0.6_wPheno.txt"
# run mbmdr on real data file
echo "Processing $fname file..."
for dimension in 1D 2D; do
  ./mbmdr-4.4.1-mac-64bits.out \
    --binary \
    -d $dimension \
    -o "${fname%.*}_output_$dimension.txt" \
    -o2 "${fname%.*}_model_$dimension.txt" \
    -n 10000 \
    "$fname" > /dev/null 2>&1
done

mv -f reformatted-data/real-train/*_1D.txt results/real/
mv -f reformatted-data/real-train/*_2D.txt results/real/
