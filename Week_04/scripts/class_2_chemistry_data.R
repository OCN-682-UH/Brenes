##Created by: Brandon Brenes 
##Last edited: 2024/09/22

#libraries:
library(tidyverse)
library(here)
library(wesanderson)
library(readr)
library(dplyr)
library(tidyr)

#load data and view

chem_data_dictionary <- read_csv("Week_04/data/chem_data_dictionary.csv")
glimpse(chem_data_dictionary)

chemicaldata_maunalua <- read_csv("Week_04/data/chemicaldata_maunalua.csv")
glimpse(chemicaldata_maunalua)

##clean up data 
#- get rid of all NAs and rename it
#separate tide and time

clean_chemicaldata_maunalua <- chemicaldata_maunalua %>% 
  filter(complete.cases(.)) %>% #drop the NAs
  separate(
    col = Tide_time,
    into = c("Tide", "time"),
    sep = "_", 
    remove = FALSE
  )
  
#separate() function deletes the column 
#and makes two new ones, to do this and save the 
#column use 'remove = FALSE' within the separate function.
#sep() function separated Tide_time into tide and time columns.

#unite two columns- site and zone in this case:
#unite(col = "Site_Zone", #name of new column
     # c(Site, Zone), #columns being united into one
     # sep = ".", #separate them by a period #keep original data of Site and zone
     # remove = FALSE)

#we will now convert/pivot this wide dataset to a long dataset
#cols being pivoted to long(biogeochem data)
  
chem_data_long <- clean_chemicaldata_maunalua %>%
  pivot_longer(
    cols = Temp_in:percent_sgd,#everything from temp in to percent_sgd
    names_to = "Variables",
    values_to = "Values")%>%
  group_by(Variables, Site, time) %>%
  summarise(measurment_mean = mean(Values, na.rm = TRUE))

  glimpse(chem_data_long)

#This is harsh on the eyes though, so lets pivot


#group_by to calculate mean and variance by site, zone, tide, variables

chem_data_wide<-chem_data_long %>%
  pivot_wider(names_from = Variables, values_from = measurment_mean) 

glimpse(chem_data_wide)

#from here, you could use these columns to make a plot and use facetwrap to make 
#all variables have their own graph for these groups. Use 
#facet_wrap(~Variab;es, scales = "free")

#Visualize
View(chem_data_wide)

#Now we're going to 

#export
write_csv(chem_data_wide, here("Week_04", "output", "class_2_chemistry_data.csv"))

#this concludes the script

