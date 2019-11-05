# Stats on gridcode metrics 
require(ggplot2)
require(dplyr)
require(tibble)

# includes demographics
tgridcodein = read.csv('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/gridCAT_outX_totalresults.csv');
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
GCmag_stats <- summarise_all(GCmag_all,funs(mean,sd))
attach(GCmag_av)
# both EC 6 fold against age
ggplot(GCmag_av) +
  geom_point(aes(Age,GCmagnitude_allRuns_both_gridCAT_out01))
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

# young vs old on bilateral all runs average
a = data.frame(Age = "Young", Grid_Signal = GCmag_young$GCmagnitude_allRuns_both_gridCAT_out01)
b = data.frame(Age = "Old", Grid_Signal = GCmag_old$GCmagnitude_allRuns_both_gridCAT_out01)
ageout01 = rbind(a,b)
ggplot(ageout01, aes(x= Age,y = Grid_Signal, fill = Age)) +
  geom_boxplot()

# young vs old on all runs
