#!/bin/bash
# Count peaks per feature (5UTR, CDS, 3UTR, introns)

# Output file
echo -e "Sample\t5UTR\tCDS\t3UTR\tIntron" > feature_counts.tsv

for peaks in *_peaks.bed
do
    sample=$(basename "$peaks" _peaks.bed)

    # Count overlaps using bedtools
    utr5=$(bedtools intersect -a "$peaks" -b ../annotations/utr5.bed -u | wc -l)
    cds=$(bedtools intersect -a "$peaks" -b ../annotations/cds.bed -u | wc -l)
    utr3=$(bedtools intersect -a "$peaks" -b ../annotations/utr3.bed -u | wc -l)
    introns=$(bedtools intersect -a "$peaks" -b ../annotations/introns.bed -u | wc -l)

    # Add counts to the output file
    echo -e "${sample}\t${utr5}\t${cds}\t${utr3}\t${introns}" >> feature_counts.tsv
done

echo "Feature counts saved to feature_counts.tsv"
