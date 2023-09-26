#this script details the workflow for generating a habitat suitability map for two prairie species: 
#Achyrachaena mollis and Plectritis congesta
#script is adapted from enmtools reference materials: 
#Warren et al. (2021) ENMTools 1.0: An R package for comparative ecological biogeography. Ecography, 44(4), 504-511.

#import libraries
library(devtools)
library(ENMTools)
library(RStoolbox)
library(reshape2)

########################################################################################################
################################### Round 1 Testing for Collinearity ###################################
########################################################################################################
#read environment input files
env.files <- list.files(path="./asciis_round1", full.names=TRUE)
env.files

#convert all files into one object 
env <- stack(env.files)
#identify min and max values for each layer
env <- setMinMax(env)

#separate out layers into individual variables
canopy <- env[[1]]
clay <- env[[2]]
dewpt <- env[[3]]
elevation <- env[[4]]
mntmpc <- env[[5]]
mxtmpw <- env[[6]]
ph <- env[[7]]
pcold <- env[[8]]
pdry <- env[[9]]
pwarm <- env[[10]]
pwet <- env[[11]]
tmax <- env[[12]]
tmean <- env[[13]]
tmin <- env[[14]]
trange <- env[[15]]

#for each variable, rescale from 1 to 10 and plot to verify results 
canopy_re <- rescaleImage(canopy, ymin = 1, ymax = 10)
#plot(canopy_re)
clay_re <- rescaleImage(clay, ymin = 1, ymax = 10)
#plot(clay_re)
dewpt_re <- rescaleImage(dewpt, ymin = 1, ymax = 10)
#plot(dewpt_re)
elevation_re <- rescaleImage(elevation, ymin = 1, ymax = 10)
#plot(elevation_re)
mntmpc_re <- rescaleImage(mntmpc, ymin = 1, ymax = 10)
#plot(mntmpc_re)
mxtmpw_re <- rescaleImage(mxtmpw, ymin = 1, ymax = 10)
#plot(mxtmpw_re)
ph_re <- rescaleImage(ph, ymin = 1, ymax = 10)
#plot(ph_re)
pcold_re <- rescaleImage(pcold, ymin = 1, ymax = 10)
#plot(pcold_re)
pdry_re <- rescaleImage(pdry, ymin = 1, ymax = 10)
#plot(pdry_re)
pwarm_re <- rescaleImage(pwarm, ymin = 1, ymax = 10)
#plot(pwarm_re)
pwet_re <- rescaleImage(pwet, ymin = 1, ymax = 10)
#plot(pwet_re)
tmax_re <- rescaleImage(tmax, ymin = 1, ymax = 10)
#plot(tmax_re)
tmean_re <- rescaleImage(tmean, ymin = 1, ymax = 10)
#plot(tmean_re)
tmin_re <- rescaleImage(tmin , ymin = 1, ymax = 10)
#plot(tmin_re)
trange_re <- rescaleImage(trange , ymin = 1, ymax = 10)
#plot(trange_re)

#restack layers
env_re <- stack(canopy_re, clay_re, dewpt_re, elevation_re, mntmpc_re, mxtmpw_re, ph_re, pcold_re, pdry_re, 
                pwarm_re, pwet_re, tmax_re, tmean_re, tmin_re, trange_re)
env_re
#label variables 
#use list produced by env.files command to label layers in the correct order (also alphabetical)
names(env_re) <- c("can", "clay", "dewpt", "ele", "mntmpc", "mxtmpw", "ph", 
                "pcold", "pdry", "pwarm", "pwet", "tmax", "tmean", "tmin", "trange")
env_re

#set projection
crs(env_re) <- "+proj=longlat"
#plot all layers:
plot(env)

########################################################################################################
############################## Plectritis congesta species profile #####################################
########################################################################################################
#building species profile 
#make species object
plectritis <- enmtools.species()
plectritis

#import species locations 
plectritis.path <- paste("./plectritis_poplocs_wgs.csv", sep="")
plectritis <- enmtools.species(species.name = "plectritis",
                           presence.points = read.csv(plectritis.path))
#establish range of species points and environmental variables 
plectritis$range <- background.raster.buffer(plectritis$presence.points,
                                         100000, mask = env_re)
#establish background points for baseline 
plectritis$background.points <- background.points.buffer(
  points = plectritis$presence.points, radius = 30000, 
  n = 20, mask = env_re[[1]])
#list any issues building the species profile 
plectritis <- check.species(plectritis)
library(leaflet)
#plot sampling points, background points, and range 
interactive.plot.enmtools.species(plectritis)

#building ENM
#check for coliniarity
raster.cor.matrix(env_re)
#pearson correlation coefficient
#high correlation = +/- 0.7 to +/- 1
#mod correlation = +/- 0.5 - +/- 0.7
#low correlation = < +/- 0.5

#visualize correlation plot
raster.cor.plot(env_re)

########################################################################################################
############################## Round 2 Building Model without Collinearity #############################
########################################################################################################

#make another stack with only variables of interest 
env_un <- stack(canopy_re, clay_re, dewpt_re, pcold_re, pdry_re, tmin_re, trange_re)
env_un
scale(env_un)
names(env_un) <- c("can", "clay", "dewpt", "pcold", "pdry", "tmin", "trange")
env_un

#define projection
crs(env_un) <- "+proj=longlat"

#building species profile 
#make species object
plectritis <- enmtools.species()
plectritis 

#import species locations 
plectritis.path <- paste("./plectritis_poplocs_wgs.csv", sep="")
plectritis <- enmtools.species(species.name = "plectritis",
                           presence.points = read.csv(plectritis.path))
#establish range of species points and environmental variables 
plectritis$range <- background.raster.buffer(plectritis$presence.points,
                                         100000, mask = env_un)
#sometimes this will throw an error, but it works if you run it again! 
#establish background points for baseline 
plectritis$background.points <- background.points.buffer(
  points = plectritis$presence.points, radius = 30000, 
  n = 20, mask = env_un[[1]])
#list any issues building the species profile 
plectritis <- check.species(plectritis)
#library(leaflet)
#plot sampling points, background points, and range 
interactive.plot.enmtools.species(plectritis)

#building ENM
#check for coliniarity
cor.matrix_un <- raster.cor.matrix(env_un)
#export collinearity matrix
write.csv(cor.matrix_un, "plectritis_all_vars_cor_matrix.csv")
#pearson correlation coefficient
#visualize correlation plot
cor.plot_un <- raster.cor.plot(env_un)
cor.plot_un


########################################################################################################
############################################### ENM ####################################################
########################################################################################################

#run enm on species presence and environmental variables 
plectritis.glm1 <- enmtools.glm(species=plectritis, env=env_un, 
                            f = pres ~ can + dewpt + pdry + tmin, 
                            test.prop = 0.2, maxit = 10000)

#print and plot results 
#print AIC value only -- used for model selection
plectritis.glm1$model$aic
#print all model information
plectritis.glm1
#plot habitat suitability map and individual response plots
plot(plectritis.glm1$suitability)
plectritis.glm1$response.plots

#this layer will be used as the input for ResistanceGA 
writeRaster(plectritis.glm1$suitability, "plectritis_enmtools.tif")


########################################################################################################
############################## Achyrachaena mollis species profile #####################################
########################################################################################################
#building species profile 
#make species object
achyra <- enmtools.species()
achyra

#import species locations 
achyra.path <- paste("./poplocs_wgs.csv", sep="")
achyra <- enmtools.species(species.name = "achyra",
                           presence.points = read.csv(achyra.path))
#establish range of species points and environmental variables 
achyra$range <- background.raster.buffer(achyra$presence.points,
                                         100000, mask = env_re)
#establish background points for baseline 
achyra$background.points <- background.points.buffer(
  points = achyra$presence.points, radius = 30000, 
  n = 20, mask = env_re[[1]])
#list any issues building the species profile 
achyra <- check.species(achyra)
library(leaflet)
#plot sampling points, background points, and range 
interactive.plot.enmtools.species(achyra)

#building ENM
#check for coliniarity
raster.cor.matrix(env_re)
#pearson correlation coefficient
#high correlation = +/- 0.7 to +/- 1
#mod correlation = +/- 0.5 - +/- 0.7
#low correlation = < +/- 0.5

#visualize correlation plot
raster.cor.plot(env_re)

########################################################################################################
############################## Round 2 Building Model without Collinearity #############################
########################################################################################################
#make another stack with only variables of interest 
env_un <- stack(canopy_re, clay_re, dewpt_re, pcold_re, pdry_re, tmin_re)
env_un
scale(env_un)
names(env_un) <- c("can", "clay", "dewpt", "pcold", "pdry", "tmin")
env_un

#define projection
crs(env_un) <- "+proj=longlat"

#building species profile 
#make species object
achyra <- enmtools.species()
achyra

#import species locations 
achyra.path <- paste("./poplocs_wgs.csv", sep="")
achyra <- enmtools.species(species.name = "achyra",
                           presence.points = read.csv(achyra.path))
#establish range of species points and environmental variables 
achyra$range <- background.raster.buffer(achyra$presence.points,
                                         100000, mask = env_un)
#sometimes this will throw an error, but it works if you run it again! 
#establish background points for baseline 
achyra$background.points <- background.points.buffer(
  points = achyra$presence.points, radius = 30000, 
  n = 20, mask = env_un[[1]])
#list any issues building the species profile 
achyra <- check.species(achyra)
#library(leaflet)
#plot sampling points, background points, and range 
interactive.plot.enmtools.species(achyra)

#building ENM
#check for coliniarity
cor.matrix_un <- raster.cor.matrix(env_un)
write.csv(cor.matrix_un, "achyra_all_vars_cor_matrix.csv")
#pearson correlation coefficient
#visualize correlation plot
cor.plot_un <- raster.cor.plot(env_un)
cor.plot_un


########################################################################################################
############################################### ENM ####################################################
########################################################################################################

#run enm on species presence and environmental variables 
achyra.glm1 <- enmtools.glm(species=achyra, env=env_un, 
                           f = pres ~ can + dewpt + pdry + tmin, 
                           test.prop = 0.2, maxit = 10000)

#print and plot results 
#print AIC value only -- used for model selection
achyra.glm1$model$aic
#print all model information
achyra.glm1
#plot habitat suitability map and individual response plots
plot(achyra.glm1$suitability)
achyra.glm1$response.plots

#this layer will be used as the input for ResistanceGA 
writeRaster(achyra.glm1$suitability, "achyra_enmtools.tif")
