#!/bin/bash
# compute_distances.sh
# Calculates distance of m6A peak summits to anchor points (Fig1 C–F)

set -e

echo "[INFO] Working directory: $(pwd)"

# 5' splice sites
echo "[INFO] Computing distances to 5' splice sites..."
bedtools closest -d -a all_summits.bed -b ../annotations/sj5.bed > dist_sj5.bed

# 3' splice sites
echo "[INFO] Computing distances to 3' splice sites..."
bedtools closest -d -a all_summits.bed -b ../annotations/sj3.bed > dist_sj3.bed

# start codons
echo "[INFO] Computing distances to start codons..."
bedtools closest -d -a all_summits.bed -b ../annotations/startcodon.bed > dist_start.bed

# stop codons
echo "[INFO] Computing distances to stop codons..."
bedtools closest -d -a all_summits.bed -b ../annotations/stopcodon.bed > dist_stop.bed

echo "[DONE] Distance files created:"
ls -lh dist_*.bed
