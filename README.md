# landscape-genetics
Scripts related to the processing of SNPs and spatial data for landscape genetic analysis 

### GBS-SNP-CROP

Bash scripts used to process GBS files through GBS-SNP-CROP pipeline (Melo et al. 2016), which parses and filters SNPs. 

### STRUCTURE

Bash and R scripts used to identify subclusters in whole-genome sequencing. ParallelStructure R package (Besnier et al. 2013) was used to parallelize STRUCTURE program (Prichard et al. 2000).

### ENMTools

R script and population location CSV files required for generating a habitat suitability map (Warren et al. 2021).

### ResistanceGA

R scripts used to optimize landscape features using genetic distance variables in ResistanceGA (Peterman 2018). Three scripts are provided: single surface optimization, optimization of multiple surfaces, and bootstrapping for model selection. Each script was run independently for each landscape feature and genetic distance variable. 

### Qst-Fst
R scripts used to run Qst-Fst comparisons. These scripts were adapted from Marchini et al., 2018. 

## Citations 

Besnier, F., & Glover, K. A. (2013). ParallelStructure: An R package to distribute parallel runs of the population genetics program STRUCTURE on multi-core computers. _PloS One_, 8(7), e70651.

Marchini, G. L., Arredondo, T. M., & Cruzan, M. B. (2018). Selective differentiation during the colonization and establishment of a newly invasive species. _Journal of Evolutionary Biology_, 31(11), 1689-1703.

Melo, A. T., Bartaula, R., & Hale, I. (2016). GBS-SNP-CROP: a reference-optional pipeline for SNP discovery and plant germplasm characterization using variable length, paired-end genotyping-by-sequencing data. _BMC Bioinformatics_, 17(1), 1-15.

Peterman, W. E. (2018). ResistanceGA: An R package for the optimization of resistance surfaces using genetic algorithms. _Methods in Ecology and Evolution_, 9(6), 1638-1647.

Pritchard, J. K., Stephens, M., & Donnelly, P. (2000). Inference of population structure using multilocus genotype data. _Genetics_, 155(2), 945-959.

Warren, D. L., Matzke, N. J., Cardillo, M., Baumgartner, J. B., Beaumont, L. J., Turelli, M., ... & Dinnage, R. (2021). ENMTools 1.0: An R package for comparative ecological biogeography. _Ecography_, 44(4), 504-511.
