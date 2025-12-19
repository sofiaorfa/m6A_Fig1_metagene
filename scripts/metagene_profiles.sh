#!/bin/bash
# Generate metagene profiles from bigWig files for 4 features (sj5, sj3, start, stop)

mkdir -p metagene_plots
features=("sj5" "sj3" "startcodon" "stopcodon")
bw_files=(../GSE83561_raw/*.bw)

if [ ${#bw_files[@]} -eq 0 ]; then
    echo "ERROR: No .bw files found in ../GSE83561_raw/"
    exit 1
fi

echo "Found ${#bw_files[@]} bigWig files"

process_feature() {
    feature=$1
    bed="../annotations/${feature}.bed"
    matrix="metagene_plots/matrix_${feature}.gz"
    out_pdf="metagene_plots/${feature}_combined.pdf"

    if [ ! -f "$bed" ]; then
        echo " BED file $bed not found. Skipping $feature."
        return
    fi

    echo "Feature: $feature"

    # Compute matrix around anchor point
    computeMatrix reference-point \
        -S "${bw_files[@]}" \
        -R "$bed" \
        --referencePoint center -b 500 -a 500 \
        --skipZeros \
        -out "$matrix"

    # Plot the profile
    plotProfile -m "$matrix" -out "$out_pdf" --perGroup

    echo "Feature: $feature → $out_pdf"
}

# Run each feature in background
for feature in "${features[@]}"; do
    process_feature "$feature" &
done

wait
echo "All features processed. Results in metagene_plots/"
