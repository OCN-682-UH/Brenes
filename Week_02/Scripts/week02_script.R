#Description: 
    #This is literally my first script. How exciting! 
    #The purpose of this script is to practice my skills in importing csv files (data)
    #This will be used for HW assignment of week 2
    #The date is 2024.09.07
#########################################

##Load Libraries##
library(tidyverse)
library (here)

### Read in Data ###
WeightData<-read_csv(here("Week_02","Data","weightdata.csv"))

##Data Analysis##
head(WeightData) #views top 6 lines of data set
tail(WeightData) #views bottom 6 lines of data set
view(WeightData) #views entire data set