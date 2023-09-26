perl /home/ech4/GBS-SNP-CROP-1.pl -d SE -b /home/ech4/plate2-barcodes.txt -fq Plate-2 -s 1 -e 1 -enz1 CAGC -enz2 CAGC -t 10

# use one of the following two commands to merge wobble base step1 outputs (sometimes pipe maxes out) 

# cat ./step1a/Plate-2_001.R1parsed.fq.gz ./step1b/Plate-2.R1parsed_001.fq.gz | gzip > plate2_merged_001.R1parsed.fq.gz
#or
# cat ./step1a/Plate-2_001.R1parsed.fq.gz ./step1b/Plate-2_001.R1parsed.fq.gz > plate2_merged_001.R1parsed.fq.gz
