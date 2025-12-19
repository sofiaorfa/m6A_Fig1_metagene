#!/bin/bash
# Call peaks from all .bedGraph files in the folder (threshold = 5)

for bg in *.bedGraph
do
    base=$(basename "$bg" .bedGraph)
    awk '$4 > 5 {print $1,$2,$3,$4}' OFS="\t" "$bg" > "${base}_peaks.bed"     # Keep only regions where the 4th column (signal) > 5
done

echo "Peaks called for all .bedGraph files"

