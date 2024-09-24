##Today we're plotting penguin data again in OCN 682- Fundamentals in R
##Created by: Brandon Brenes 
##Last edited: 2024/09/17

#Library
library(palmerpenguins)
library(tidyverse)
library(here)

glimpse(penguins)

##filter functions 

filter(.data = penguins, sex == "female" ) #filters out only female
filter(.data = penguins, year == "2008" ) #filters out only 2008 obs
filter(.data = penguins, body_mass_g > 5000) #filters out greater than 5000 bodymass
filter(.data = penguins, sex == "female", body_mass_g >5000) #filter out females largercthan 5000

filter(.data = penguins, year == "2008" | year == "2009") #Penguins that were collected in either 2008 or 2009
filter(.data = penguins, year %in% c("Adelie","Gento")) #Penguins in the species Adelie and Gentoo
filter(.data = penguins, island != "Dream") #Penguins that are not from the island Dream


##mutate: add new columns

#example (convert g to kg)
data2<-mutate(.data = penguins, body_mass_kg = body_mass_g/1000)
View(data2)

#add multiple lines

#example: converted units AND made a ratio column
data2<-mutate(.data = penguins, 
              body_mass_kg = body_mass_g/1000,
              bill_length_depth = bill_length_mm/bill_depth_mm)
#mutate with ifelse

#example: if it is greater than 2008, label it "After 2008", otherwise, label it as "Before 2008"
data2<- mutate(.data = penguins,
               after_2008 = ifelse(year>2008, "After 2008", "Before 2008"))
View(data2)

#add flipper length and body mass then label it as "added them"
data2<- mutate(.data = penguins, added_them = body_mass_g+flipper_length_mm)
View(data2)

data2<- mutate(.data = penguins, added_them = body_mass_g+flipper_length_mm)
View(data2) 

#Use mutate and ifelse to create a new column where body mass greater than 4000 is labeled as big and everything else is small 
data2<- mutate(.data = penguins, thicc_penguins = ifelse(body_mass_g>4000,"big boi","smol boi"))
View(data2) 

#Filter only female penguins and add a new column that calculates the log body mass
#When you use %>% the dataframe carries over so you don't need to write it out anymore

penguins %>% # use penguin dataframe
  filter(sex == "female") %>% #select females
  mutate(log_mass = log(body_mass_g)) #calculate log biomass
               
#%>% = cmd+shift+m

#Select function
#Use select() to select certain columns to remain in the dataframe
penguins %>% # use penguin dataframe
  filter(sex == "female") %>% #select females
  mutate(log_mass = log(body_mass_g)) %>% #calculate log biomass
  select(species, island, sex, log_mass)


#Summarize function
#Computer a table of summarized data Calculate the mean flipper length (and exclude any NAs)

penguins %>% # 
  summarise(mean_flipper = mean(flipper_length_mm, na.rm=TRUE))

#group_by

#You can summarize values by certain groups.
#group_by() by itself doesn't do anything, but it is powerful when put before summarize.

penguins %>%
  group_by(island, sex) %>%
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
            max_bill_length = max(bill_length_mm, na.rm=TRUE))
#remove NAs
#drop_na()- drops rows with NAs from a specific column, 
#drop all the rows that are missing data on sex calculate mean bill length by sex

#data wrangling with ggplot
#You can connect your data wrangling to a ggplot with the pipe 
#(you won't need to call the dataframe in ggplot if you pipe to it)

#example:
penguins %>%
  drop_na(sex) %>%
  ggplot(aes(x = sex, y = flipper_length_mm)) +
  geom_boxplot()

#this concludes the script
