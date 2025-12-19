AIM OF THE PROJECT:
This repository contains scripts and figures in an attempt to reproduce Figure 1C–F from Transient N-6-Methyladenosine Transcriptome Sequencing Reveals a Regulatory Role of m6A in Splicing Efficiency (Louloupi, Annita et al.)
Following the paper and supplementary methods, two concepts are central:m6A signal is obtained from m6A-IP sequencing normalized to input and the metagene analysis was done by plotting the average frequency of m6A peak summits per nucleotide position

STEPS FOLLOWED FOR THE PROJECT :

 STEP 1: In order to download the GSE83561 raw file and annotation file,the following commands were used in a bash terminal
     
      mkdir -p ~/projects/m6a
      cd ~/projects/m6a
      wget ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE83nnn/GSE83561/suppl/GSE83561_RAW.tar
      mkdir GSE83561_raw
      tar -xvf GSE83561_RAW.tar -C GSE83561_raw
      wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz
      gunzip gencode.v19.annotation.gtf.gz
      
  STEP 2: Created annotation BED files using the annotation.sh script 
  
  STEP 3: Convert all bigWigs to bedGraph 
  
    mkdir results
    cd results
    
    for f in ../GSE83561_raw/*.bw
    do
      base=$(basename $f .bw)
      bigWigToBedGraph $f ${base}.bedGraph
    done

 STEP 4: Find the peaks using the peaks.sh script and then calculate the peaks per feature using the peak_perfeature.sh script
 
 STEP 5: Find motifs for every peak using the motif_peaks.sh script

 STEP 6:
 




