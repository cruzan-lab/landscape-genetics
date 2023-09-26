#the following script is used for single surface optimization using the program ResistanceGA
#optimization was conducted for two prairie species: 
#Achyrachaena mollis and Plectritis congesta
#Optimization was conducted for each landscape feature and genetic distance response variable. 

#this script was created using the reference materials associated with the ResistanceGA R package: 
#Peterman, W. E. (2018). ResistanceGA: An R package for the optimization of resistance surfaces using genetic algorithms. Methods in Ecology and Evolution, 9(6), 1638-1647.

#load libraries 
library(ResistanceGA)
library(doParallel)

#set working directory
setwd("/home/ech4/ResistanceGA/plectritis/ag/")

#load landscape input files from ascii folder
list <-list.files(path='ascii/', full.names = TRUE)
#combine landscape files into single variable 
layer_stack <- stack(list)
#import population locations
my_samples <- read.table("poploc.txt", sep = "\t", header=F, fill=T)
sample.locales <- SpatialPoints(my_samples[ ,c(2,3) ])
#assign output directory
write.dir <- ("/home/ech4/ResistanceGA/plectritis/ag/results/")

#ResistanceGA functions:

#GA.prep:
#method = "AIC"; AIC method used to optimize models
#min.cat = 0, max.cat = 500; categorical features resistance values must fall between 0-500
#select.trans = list("A"); all transformations considered
GA.inputs_All <- GA.prep(method = "AIC", ASCII = layer_stack,
	Results.dir = write.dir, min.cat = 0, max.cat = 500,
	select.trans = list("A"), seed = 23, parallel = 20)

#load genetic distance column
gendist <- scan("genetic_distance_column.txt")

#run optimization
gdist.inputs <- gdist.prep(n.Pops = length(sample.locales), 
	samples = sample.locales, response = gendist, method = 'commuteDistance')
ag <- SS_optim(gdist.inputs = gdist.inputs, GA.inputs = GA.inputs_All)

#save R object; required for bootstrapping step
save(ag, file = "ag.rda")
