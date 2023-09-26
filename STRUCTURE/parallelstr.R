#this script was used to evaluate the number of clusters within two prairie species: 
#Achyrachaena mollis and Plectritis congesta
#the following was generated using reference materials from ParallelStructure documentation: 
#Besnier & Glover (2013) ParallelStructure: AR package to distribute parallel runs of the population genetics program STRUCTURE on multi-core computers. PloS one, 8(7), e70651.

#load library
library(ParallelStructure)
#set working directory 
setwd("/home/ech4/structure/achyra")
#run structure
parallel_structure(infile="achyra.str", outpath="results/", 
joblist="ParallelJobs.txt", n_cpu=20, structure_path="/home/ech4/console/", 
numinds = 185, numloci = 6756, ploidy = 2, label = 1, popdata = 1, 
markernames = 1, missing = -9, locprior = 1, printqhat = 1)