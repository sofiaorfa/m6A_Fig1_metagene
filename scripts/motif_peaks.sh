#!/bin/bash
#Motif discovery from peak summits

# Merge all peaks
cat *_peaks.bed > all_peaks.bed

# Calculate summits (middle of each peak)
awk '{mid=int(($2+$3)/2); print $1,mid,mid+1}' all_peaks.bed > all_summits.bed

# Expand summits
bedtools slop -i all_summits.bed -g ../hg19.chrom.sizes -b 150 > all_summits150.bed

# Extract sequences from hg19.fa
bedtools getfasta -fi ../hg19.fa -bed all_summits150.bed -fo all_peaks.fa

findMotifsGenome.pl all_summits150.bed hg19 homer_out/ -size 300

echo "Motif discovery complete. Results in homer_out/"
