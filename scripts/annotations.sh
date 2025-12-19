mkdir annotations

# CDS
awk '$3=="CDS"{print $1,$4-1,$5,$7}' OFS="\t" gencode.v19.annotation.gtf > annotations/cds.bed

# 5'UTR
grep -w "five_prime_utr" gencode.v19.annotation.gtf | \
awk '{print $1,$4-1,$5,$7}' OFS="\t" > annotations/utr5.bed

# 3'UTR
grep -w "three_prime_utr" gencode.v19.annotation.gtf | \
awk '{print $1,$4-1,$5,$7}' OFS="\t" > annotations/utr3.bed

# Exons
awk '$3=="exon"{print $1,$4-1,$5,$7}' OFS="\t" gencode.v19.annotation.gtf > annotations/exons.bed

# Genes
awk '$3=="gene"{print $1,$4-1,$5,$7}' OFS="\t" gencode.v19.annotation.gtf > annotations/genes.bed

# Introns
bedtools subtract -a annotations/genes.bed -b annotations/exons.bed > annotations/introns.bed

# Splice junctions
awk '$3=="exon" && $7=="+" {print $1,$4-1,$4,"+"}
     $3=="exon" && $7=="-" {print $1,$5-1,$5,"-"}' OFS="\t" gencode.v19.annotation.gtf > annotations/sj5.bed

awk '$3=="exon" && $7=="+" {print $1,$5-1,$5,"+"}
     $3=="exon" && $7=="-" {print $1,$4-1,$4,"-"}' OFS="\t" gencode.v19.annotation.gtf > annotations/sj3.bed

# Start/Stop codons
awk '$3=="start_codon"{print $1,$4-1,$5,$7}' OFS="\t" gencode.v19.annotation.gtf > annotations/startcodon.bed
awk '$3=="stop_codon" {print $1,$4-1,$5,$7}' OFS="\t" gencode.v19.annotation.gtf > annotations/stopcodon.bed
