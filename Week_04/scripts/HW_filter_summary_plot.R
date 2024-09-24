##Created by: Brandon Brenes 
##Last edited: 2024/09/17

#Homework: Write a script that:1) 
#calculates the mean and variance of body mass by species, island, 
#and sex without any NAs filters out (i.e. excludes) male penguins, 
#then calculates the log body mass, then selects only the columns for species, 
#island, sex, and log body mass, then use these data to make any plot. 
#Make sure the plot has clean and clear labels and follows best practices. 
#Save the plot in the correct output folder.

##Today we're plotting penguin data again in OCN 682- Fundamentals in R


#Library
library(palmerpenguins)
library(tidyverse)
library(here)
library(wesanderson)
library(dplyr)
library(tidyr)

#data
data("penguins", package = "palmerpenguins")
glimpse(penguins)

#1)
penguins %>% #penguin dataset
group_by(island, sex, species) %>% #summarize by island, sex and species
drop_na(sex, island, species)%>% #remove NAs
summarise(mean_bodymass = mean(body_mass_g, na.rm = TRUE), variance_bodymass
= var(body_mass_g, na.rm = TRUE))

#2)

#summarize data
penguinz <- penguins %>%
group_by(island, sex, species) %>%
drop_na(sex, island, species)%>%
filter(sex == "female")%>% #exclude males :(
summarise(mean_bodymass = mean(body_mass_g, na.rm = TRUE),
variance_bodymass = var(body_mass_g, na.rm = TRUE),
log_bodymass = log(body_mass_g))%>% #add column for log bodymass
select(species, island, sex, log_bodymass)

#look at summarized data
glimpse(penguinz)
# make a box plot
ggplot(penguinz, aes(x = species, y = log_bodymass, fill = species))+ #fill color will be equal to species
#also, used modified penguin data (penguinz)
geom_boxplot(outlier.shape = NA) + #boxplot
scale_fill_manual(values = wes_palette("AsteroidCity2")) + #use WA color pallette for species
theme_bw()+
facet_wrap(~island)+ #make separate mini boxplots for every island
labs(title = "Log Body Mass of Female Penguins by Island and Species", #lets add some axis labels
x = "Species",
y = "Log Body Mass (g)", fill = "Species")+
theme(axis.title = element_text(size = 12, face = "bold"),  #bolded title
axis.text = element_text(face = "bold"),              #bolded axis titles
plot.title = element_text(size = 16, face = "bold"),  #bolded and enlarge title
panel.background = element_rect(fill = "linen"),
axis.title.x = element_text(margin = margin(t = 10)), #Added length to margins
axis.title.y = element_text(margin = margin(r = 10))) #white fill for the panel background

#save plot in output of repository "Brenes" folder "Week_4" as "penguin_log_bodymass_plot.png"
ggsave(here("Week_04","output","penguin_log_bodymass_plot.png"), width = 8, height = 6)


#this concludes the script
