#model selection following optimization in ResistanceGA
#this model selection was conducted for two prairie species: 
#Achyrachaena mollis and Plectritis congesta
#this script was created using the reference materials associated with the ResistanceGA R package: 
#Peterman, W. E. (2018). ResistanceGA: An R package for the optimization of resistance surfaces using genetic algorithms. Methods in Ecology and Evolution, 9(6), 1638-1647.

#import libraries
library(ResistanceGA)
library(PopGenReport)

#set working directory and load output files from ResistanceGA optimization process
setwd("/home/ech4/ResistanceGA")
load(file = "single/ag.rda") 
load(file = "single/can.rda") 
load(file = "single/dev2.rda") 
load(file = "single/ele.rda") 
load(file = "single/enm.rda") 
load(file = "single/nat.rda") 
load(file = "single/rds.rda")
load(file = "single/riv.rda") 

#create required variables for bootstrapping 
#list of cost distance matrices
mat.list <- c(ag$cd, can$cd, dev2$cd, ele$cd, enm$cd, nat$cd, rds$cd, riv$cd)
#list of variables per matrix
k <- rbind(ag$k, can$k, dev2$k, ele$k, enm$k, nat$k, rds$k, riv$k)
#load genetic distance matrix 
gendist.mat <- read.csv("gen_dist_matrix.csv", header = TRUE, row.names = 1)
response <- gendist.mat
dim(response)
#the number reported in the dim() function above is what should be set in the obs flag in the 
#Resist.boot command below 

#run bootstrapping function. 
AIC.boot <- Resist.boot(mod.names = names(mat.list), 
                        dist.mat = mat.list,
                        n.parameters = k[,2],
                        sample.prop = 0.75,
                        iters = 15000,
                        obs = 26,    
                        genetic.mat = response)

#save results
save(AIC.boot, file = "bootstrapping.rda")
write.csv(AIC.boot, file = "bootstrapping.csv")


