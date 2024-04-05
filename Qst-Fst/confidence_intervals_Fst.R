library(adegenet)
library(hierfstat)
library(boot)

setwd("/file/path/ci_qst-fst")

#read in data and check structure of file
cg <- read.csv("Achmol_common_garden.csv", header = TRUE)

#define common garden variables, convert pappus-achene angle
cgPop <- cg$Population
cgSWL <- cg$SWL
cgLWL <- cg$LWL
cgAL <- cg$AL
#account for angle of achene (subtract 90) 
#and convert paa to radians (deg*(pi/180))
cgPAA <- (cg$PAA-90)*(pi/180)
cgPD <- cg$PD
cgLWW <- cg$LWW
cgSWW <- cg$SWW

meanpops <- c("ALS", "AR", "BLM", "CL", "CM", "CW", "DCR", "DEN", 
              "DR", "MA", "UR2", "UR3", "UTR2", "UW2", "WHS")


######## Qst-Fst CONFIDENCE INTERVALS ######## 
#to identify confidence intervals for Qst-Fst comparisons, run bootstrapping on 
#trait measurement and loci 

#import Achmol loci data and convert to hierfstat object
a_nuc_str <- read.structure("Achmol_loci.str", 
                            n.ind = 185, n.loc = 6756, 
                            onerowperind = FALSE, col.lab = 1, col.pop = 2, 
                            row.marknames = 1, NA.char = -9, ask = FALSE)
a_hier <- genind2hierfstat(a_nuc_str)

#append cleaned trait data together and check the file structure
cg2 <- as.data.frame(cbind(cgPop, cgSWL, cgLWL, cgAL, cgPAA, cgPD, cgLWW, cgSWW))

#create an empty matrix for CI Fst values 
#define number of simulations
numsims=1000

#make a matrix of 0s with the number of individuals as # of rows and 
#the number of simulations as # of columns
fpop=matrix(0,nrow=nrow(a_hier),ncol=numsims) 
simFst1000=rep(0,numsims)

#randomly select a subset of loci and calculate Fst
#rewrite the 0s in the simFst variable with Fst values 
f<-for(i in 1:numsims){
  popnames<-a_hier[,1]
  g<-sample(subset(a_hier, select=names(a_hier[,-1])), replace=T)
  rando<-cbind(a_hier,g)
  simFst1000[i]=as.numeric(as.vector(unlist(basic.stats((rando))[[7]]))[7])
  print(simFst1000[i])
}

save(simFst1000, file = "simFst1000.rda")
