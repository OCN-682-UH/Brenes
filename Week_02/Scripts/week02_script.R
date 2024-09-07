#This is literally my first script. How exciting! 
#The purpose of this script is to practice my skills in importing csv files (data)
#The date is 2024.09.07
#########################################

##load libraries##
library(tidyverse)
library (here)

### Read in data ###
WeightData<-read_csv(here("Week_02","Data","weightdata.csv"))