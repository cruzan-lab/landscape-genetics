perl /home/ech4/GBS-SNP-CROP-1.pl -d SE -b /home/ech4/plate1-barcodes.txt -fq Plate-1 -s 1 -e 1 -enz1 CTGC -enz2 CTGC -t 10

# use one of the following two commands to merge wobble base step1 outputs (sometimes pipe maxes out) 

# cat ./step1a/Plate-1_001.R1parsed.fq.gz ./step1b/Plate-1.R1parsed_001.fq.gz | gzip > plate1_merged_001.R1parsed.fq.gz
#or
# cat ./step1a/Plate-1_001.R1parsed.fq.gz ./step1b/Plate-1_001.R1parsed.fq.gz > plate1_merged_001.R1parsed.fq.gz
