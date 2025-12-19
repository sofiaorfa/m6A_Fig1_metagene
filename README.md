AIM OF THE PROJECT

This repository contains scripts and figures aiming to reproduce Figure 1C–F from Transient N-6-Methyladenosine Transcriptome Sequencing Reveals a Regulatory Role of m6A in Splicing Efficiency (Louloupi A. et al., Cell Reports, 2018).The biological hypothesis tested in the paper is that m⁶A deposition is not random, but instead positionally enriched near functional RNA processing sites.
The goal of Figure 1C–F is to demonstrate the positional enrichment of m⁶A along nascent transcripts, specifically around:
5′ splice sites, 3′ splice sites, start codons, stop codons.
Two central concepts from the paper are followed:The m⁶A signal is derived from m⁶A-IP sequencing normalized to input.Metagene analysis is performed by averaging the m⁶A signal across many genomic features, aligned at a common reference point.


STEPS FOLLOWED FOR THE PROJECT :

 STEP 1: In order to download the GSE83561 raw file and annotation file,the following commands were used in a bash terminal.
 Raw sequencing signal is provided by GEO in bigWig (.bw) format, which stores normalized per-base coverage across the genome.
     
      mkdir -p ~/projects/m6a
      cd ~/projects/m6a
      wget ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE83nnn/GSE83561/suppl/GSE83561_RAW.tar
      mkdir GSE83561_raw
      tar -xvf GSE83561_RAW.tar -C GSE83561_raw
      wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz
      gunzip gencode.v19.annotation.gtf.gz
      
  STEP 2: Created annotation BED files using the annotation.sh script. This script parses the GENCODE GTF file and generates BED    files for 5′ splice sites, 3′ splice sites, start codons, stop codons
  
  STEP 3: Convert all bigWigs to bedGraph. This step happend because bedgraph provides genomic intervals and signal values useful           for peak detection.
  
    mkdir results
    cd results
    
    for f in ../GSE83561_raw/*.bw
    do
      base=$(basename $f .bw)
      bigWigToBedGraph $f ${base}.bedGraph
    done

 STEP 4: Find the peaks using the peaks.sh script and then calculate the peaks per feature using the peak_perfeature.sh script.The script peaks.sh detects regions with elevated signal intensity of enriched m⁶A-IP signal that correspond to potential m⁶A modification sites.The per-feature annotation script assigns biological meaning to the detected m⁶A peaks by determining which transcript features they overlap. Each peak is compared against annotated splice sites, exons, introns, and codons to identify where along the transcript the m⁶A signal occurs.

 STEP 5: Distance-based signal extraction using the distance.sh script to measure how the m⁶A signal changes around important transcript landmarks such as splice sites and codons. For each landmark, the script extracts the m⁶A signal in a fixed region 500 nucleotides upstream and downstream and rewrites the signal using the landmark as the center point (distance = 0).This allows signals from many different genes to be aligned and averaged together.
 
 STEP 5: Find motifs for every peak using the motif_peaks.sh script

 STEP 6: For metagene profiles use the metagene_profiles.sh script 

 STEP 7: For the plotting make use of the R script plot_Fig1C_F_normazlized.R scipt This R scriptreads distance-resolved signal matrices computes the mean signal per nucleotide position produces line plots corresponding to Figure 1C–F
 
 
 




