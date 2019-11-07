# Stats on gridcode metrics 
require(ggplot2)
require(dplyr)
require(tibble)
require(readr)
require(tidyr)

# includes demographics
tgridcodein = read_csv('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/gridCAT_outX_totalresults.csv');
tgridtaskin = read.csv('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/gridCATbehaviourresults.csv');
#demographics = read.csv('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/demographics.csv')

# extract variables of interest
GCmag_all = select(tgridcodein, Subject, Age, starts_with("GCmagnitude"))
GCmag_av = select(tgridcodein, Subject,Age, starts_with("GCmagnitude_allRuns"))
Out_01 = select(tgridcodein, Subject,Age, ends_with("01"))
Out_03 = select(tgridcodein, Subject, Age, ends_with("03"))
Out_04 = select(tgridcodein, Subject,Age, ends_with("04"))

# need to creat binary varibale for young and old
GCmag_young = filter(GCmag_av,Age<30)
GCmag_old = filter(GCmag_av,Age>30)

# get mean
#gridcodemean <- t(data.frame(apply(tgridcodein,2,mean)))
GCmag_stats <- summarise_all(GCmag_all,list(mean,sd))
attach(GCmag_av)
# both EC 6 fold against age
ggplot(GCmag_av, aes(Age, GCmagnitude_allRuns_both_gridCAT_out01)) +
  geom_point() +
# left EC against age
ggplot(GCmag_av) +
  geom_point(aes(Age,GCmagnitude_allRuns_Left_gridCAT_out03))
# right EC against age
ggplot(GCmag_av) +
  geom_point(aes(Age,GCmagnitude_allRuns_Righ_gridCAT_out04))
#ggplot(GCmag_av) +
  #geom_boxplot(aes(select(GCmag_av,starts_with("GCmagnitude_allRuns_both"))))
ggplot(GCmag_av, aes(x="Output 01",y=GCmagnitude_allRuns_both_gridCAT_out01)) +
  geom_boxplot()

boxplot(GCmag_av[,3:10])
boxplot(select(GCmag_av,starts_with("GCmagnitude_allRuns_both")))

## trying to reorganise data for boxplots
# bilateral models all ages
a = data.frame(Model = "Bilateral_6fold", Grid_Signal = tgridcodein$GCmagnitude_allRuns_both_gridCAT_out01)
b = data.frame(Model = "Bilateral_7fold", Grid_Signal = tgridcodein$GCmagnitude_allRuns_both_gridCAT_out02)
c = data.frame(Model = "Bilateral_4fold", Grid_Signal = tgridcodein$GCmagnitude_allRuns_both_gridCAT_out05)
d = data.frame(Model = "Control_6fold", Grid_Signal = tgridcodein$GCmagnitude_allRuns_both_gridCAT_out07)
bilateralmodels = rbind(a,b,c,d)
ggplot(bilateralmodels, aes(x=Model, y = Grid_Signal, fill = Model)) +
  geom_boxplot()

attach(bilateralmodels)

# young vs old on bilateral all runs average
a = data.frame(Age = "Young", Grid_Signal = GCmag_young$GCmagnitude_allRuns_both_gridCAT_out01)
b = data.frame(Age = "Old", Grid_Signal = GCmag_old$GCmagnitude_allRuns_both_gridCAT_out01)
ageout01 = rbind(a,b)
ggplot(ageout01, aes(x= Age,y = Grid_Signal, fill = Age)) +
  geom_boxplot()

# recode age cont > cat in tgridcodein
tgridcodein_orig <- tgridcodein
tgridcodein <- tgridcodeinnew 
tgridcodeinnew %>% mutate(Age=cut(Age,breaks = c(-Inf, 30, Inf), labels = c("Young","Old")))

# statistics
# ANOVA between bilateral models
bilateralmodelstats <- lm(data = bilateralmodels, Grid_Signal~Model)
summary(bilateralmodelstats)
# t-test between age for model 01
agestats01 <- lm(data = ageout01, Grid_Signal~Age)
summary(agestats01)

## NEED TO TIDY DATA - there are repeated observations of grid cell value ##
#tgridcodein2 <- tgridcodein %>% gather(key = "Model", 4:111) - need value,key and data
tgridcodein2 <- tgridcodein %>% gather(key = "MagnitudeModel", value = "Grid_Magnitude", starts_with("GCmagnitude"))
tgridcodein3 <- tgridcodein2 %>% gather(key = "tStabilityModel", value = "Grid_tStability", starts_with("tStability"))
tgridcodein4 <- tgridcodein3 %>% gather(key = "sStabilityModelz", value = "Grid_sStability_z", starts_with("sStability_zRay"))
tgridcodein5 <- tgridcodein4 %>% gather(key = "sStabilityModelp", value = "Grid_sStability_p", starts_with("sStability_pRay"))
# this didnt work because it duplicated values in other columns and then gathered those too

require(DataCombine) # if you want to do FindReplace

# cant gather tstability / mag / sStability = different values
# get mag
grid.mag.untidy = tgridcodein %>% select(Subject,Age,Gender,starts_with("GCmagnitude"))
grid.mag <- grid.mag.untidy %>% gather(Model,Grid_Magnitude,starts_with("GCmag"))
grid.mag.sep <- separate(grid.mag,Model,c(NA,"Run",NA,NA,"Model"),"_")
# get spatial stability
grid.sStability.z.untidy <- tgridcodein %>% select(Subject,Age,Gender,starts_with("sStability_zRay"))
grid.sStability.z <- grid.sStability.z.untidy %>% gather(Model,Grid_sStabilityZ,starts_with("sStability"))
grid.sStability.z.sep <- separate(grid.sStability.z,Model,c(NA,NA,"Run",NA,NA,"Model"),"_")
grid.sStability.p.untidy <- tgridcodein %>% select(Subject,Age,Gender,starts_with("sStability_pRay"))
grid.sStability.p <- grid.sStability.p.untidy %>% gather(Model,Grid_sStabilityP,starts_with("sStability"))
# get temporal stability
grid.tStability.untidy <- tgridcodein %>% select(Subject,Age,Gender,starts_with("tStability"))
grid.tStability <- grid.tStability.untidy %>% gather(Model,Grid_tStability,starts_with("tStability"))
grid.tStability.sep <- separate(grid.tStability,Model,c(NA,NA,"RunComparison",NA,NA,"Model"),"_")

filter(RunComparison == "allRunsAvgVSrun1")

dim(tgridcodein)

# Now get stats and plot

# compare all models
# MAGNITDUE averageed across runs across models
gridmagav <- filter(grid.mag.sep,Run == "allRuns")
modelcomp_mag <- lm(data = gridmagav,Grid_Magnitude~Model)
summary(modelcomp_mag)
ggplot(gridmagav, aes(Model,Grid_Magnitude,fill = Model)) +
  geom_boxplot()
# Plot magnitude per run across models
gridmagruns <- filter(grid.mag.sep,Run != "allRuns")



# tStABILITY RUN1 vs RUN2
tStab.run1vsrun2 <- filter(grid.tStability.sep,RunComparison == "run1VSrun2")
modelcom_tStab1vs2 <- lm(data = tStab.run1vsrun2,Grid_tStability~Model)
summary(modelcom_tStab1vs2)
ggplot(tStab.run1vsrun2, aes(Model,Grid_tStability,fill=Model)) +
  geom_boxplot()
# tStability Run2 vs Run3
tStab.run2vsrun3 <- filter(grid.tStability.sep,RunComparison == "run2VSrun3")
modelcom_tStab2vs3 <- lm(data = tStab.run2vsrun3,Grid_tStability~Model)
summary(modelcom_tStab2vs3)
ggplot(tStab.run2vsrun3, aes(Model,Grid_tStability,fill=Model)) +
  geom_boxplot()
# frequency of Rayligh significance across all runs, all models

# age differences
# magnitude
agecomp.mag <- glm(data = gridmagav)
ggplot(filter(gridmagav,Age>30), aes(Model,Grid_Magnitude,fill = Model)) +
  geom_boxplot()
ggplot(gridmagav, aes(y=Grid_Magnitude,x=interaction(Model,Age),fill = Age)) +
  geom_boxplot()
ggplot(gridmagav, aes(y=Grid_Magnitude,x=Model)) +
  geom_boxplot() +
  facet_wrap(~Age)
#ggplot(gridmagav,aes(y = Grid_Magnitude)) +
  geom_boxplot(aes(x = Model, colour = Model)) +
  geom_boxplot(aes(x = Age, colour = Age))

attach(gridmagav)
interaction.plot(Grid_Magnitude$Model,Grid_Magnitude$Age)