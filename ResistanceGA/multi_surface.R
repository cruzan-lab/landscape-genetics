#the following script is used for multiple surface optimization using the program ResistanceGA
#optimization was conducted for two prairie species: 
#Achyrachaena mollis and Plectritis congesta
#Optimization was conducted for each genetic distance variable. 
#Three multisurfaces were considered: 
#1) the top features identified in single-surface optimization, 
#2) the top surfaces + habitat quality
#3) landuse classification: agriculture, roads, rivers, and urbanization 

#this script was created using the reference materials associated with the ResistanceGA R package: 
#Peterman, W. E. (2018). ResistanceGA: An R package for the optimization of resistance surfaces using genetic algorithms. Methods in Ecology and Evolution, 9(6), 1638-1647.

#load libraries
library(rgdal)
library(raster)
library(ResistanceGA)
library(gdistance)
library(ggplot2)
library(doParallel) 

#set working directory
setwd("/home/ech4/ResistanceGA/plectritis/landuse/")

#load landscape input files from ascii folder
list <-list.files(path='ascii', full.names = TRUE)
#combine landscape files into single variable
ascii_stack <- stack(list)
#import population locations
my_samples <- read.table("poploc.txt", sep = "\t", header=F, fill=T)
sample.locales <- SpatialPoints(my_samples[ ,c(2,3)])
#assign output directory 
write.dir <- "/home/ech4/ResistanceGA/plectritis/landuse/output/"

#ResistanceGA functions:

#GA.prep:
#method = "AIC"; AIC method used to optimize models
#min.cat = 0, max.cat = 500; categorical features resistance values must fall between 0-500
#select.trans = list("A"); all transformations considered
GA.inputs <- GA.prep(ASCII = ascii_stack, Results.dir = write.dir, method = "AIC", seed = 20, parallel = 20)

#load genetic distance column
gendist <- scan("plecon_pair_cyt_wc_fst.txt")

#prepare for optimization
gdist.inputs <- gdist.prep(length(sample.locales), samples = sample.locales, response = gendist, method = 'commuteDistance') 

#set input parameters for transforming surfaces into multisurface
#transformations determined from single-surface optimization:
#ag: 1,1.964093166,171.8456313
#dev: 1,22.16421849
#rds: 8.324080026,1
#riv: 1,1.342509787
PARM <- c(1,1.964093166,171.8456313, 1,22.16421849, 8.324080026,1, 1,1.342509787)
#combine surfaces into single surface
Resist <- Combine_Surfaces(PARM = PARM, gdist.inputs = gdist.inputs, GA.inputs = GA.inputs, rescale = TRUE)

#run optimization
gdist.response <- Run_gdistance(gdist.inputs = gdist.inputs, r = Resist) 
landuse <- MS_optim(gdist.inputs = gdist.inputs, GA.inputs = GA.inputs)

#save R object; required for bootstrapping step
save(landuse, file = "landuse.rda") 
