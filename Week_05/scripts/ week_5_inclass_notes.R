###date created: 2024/09/24 ###
###created by: Brandon Brenes ###
###last edited: 2024/09/24 ###
###description: Week 5 notes in fundamentals in R ###
###this script will have notes, examples and other information from the first class of week 5 ###

## libraries ##
library(tidyverse)
library(here)
library(wesanderson)
library(readr)
library(dplyr)
library(tidyr)

## data ##:

#environmental data
site_char_data <- read_csv("Week_05/data/site.characteristics.data.csv")
glimpse(site_char_data)

#coral thermal performance data
topt_data <- read_csv("Week_05/data/Topt_data.csv")
glimpse(topt_data)

#site number links both the datasets! we will use this

site_char_data_wide <-site_char_data %>% 
  pivot_wider(names_from = parameter.measured,
              values_from = values) %>% 
  arrange(site.letter)#pivot and arrange in order of site letter

 
#left_join(): I can use left_join() to bring the two data frames together into one single data frame,
#discards left side but keeps other column

full_data_left<- left_join(topt_data,site_char_data_wide) %>% 
  relocate(where(is.numeric), .after = where(is.character))#relocate all values after characters to make it pretty 

#view
head(full_data_left)

#group_by(site) and provide mean and variance for each measurement
summary_data <- full_data_left %>%
  pivot_longer(cols = c(E:substrate.cover), 
               names_to = "Variables", 
               values_to = "Values") %>% 
  group_by(site.letter, Variables) %>% 
  summarise(measurment_mean = mean(Values, na.rm = TRUE),
            measurment_variance = var(Values, na.rm = TRUE))

glimpse(summary_data)

##use tibble().to make a tibble or data frame##
T1<- tibble(Site.ID = c("A","B","D","E"), 
            Temperture = c(14.1, 12, 12, 12))
T2<-tibble(Site.ID = c("A","B","D","C","E"), 
           pH = c(4, 20, 4, 20, 4))   

left_join(T1, T2)
right_join(T1, T2)
full_join(T1, T2)
inner_join(T1, T2)

