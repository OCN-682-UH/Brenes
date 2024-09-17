#Description: this script was used to create a plot using penguin data provided
#by Dr. Nyssa S. This was made for HW of week 3 OCN682- fundamentals in R.

#Objective: create a box and whisker plot displaying the varying (or non varying)
#body masses across the three species of penguins. We used the libraries seen below,
#plot was generated using geom_boxplot()

#created by: Brandon Brenes
#created on: 2024-09-16
#last edited: 2024-09-16
#######################################


#Library:
library(ggplot2)
library(palmerpenguins)
library(beyonce)
library(ggthemes)
library(tidyverse)
library(here)
library(dplyr)
library(wesanderson)

#Data
#Take a look at the data:
glimpse(penguins)

# Calculate summary statistic of bodymass vs. speceies (pre-plot data analysis)

summary_stats <- penguins %>%
  group_by(species) %>%
  summarize(Min = min(body_mass_g, na.rm = TRUE),
            Q1 = quantile(body_mass_g, 0.25, na.rm = TRUE),
            Median = median(body_mass_g, na.rm = TRUE),
            Q3 = quantile(body_mass_g, 0.75, na.rm = TRUE),
            Max = max(body_mass_g, na.rm = TRUE))

#Functions/data
ggplot(data = penguins, 
       mapping = aes(x = species, 
                     y = body_mass_g,
                     group = species,
                     fill = species)) +
  geom_boxplot(outlier.shape = NA) + # Removed outliers in 'penguins' dataset
  geom_text(data = summary_stats, 
                            aes(x = species, 
                                y = Median, 
                                label = paste("Median:", round(Median, 1))),
                            vjust = -0.5, size = 3) +
  labs(x = "Penguin Species", 
       y = "Body Mass (g)", 
       title = "Box Plot of Penguin Species Body Mass") +
  scale_fill_manual(values = wes_palette("AsteroidCity1")) + #used Wes Anderson theme colors
  theme_few() + 
  theme(axis.title = element_text(size = 12, face = "bold"),  #bolded title
        axis.text = element_text(face = "bold"),              #bolded axis titles
        plot.title = element_text(size = 16, face = "bold"),  #bolded and enlarge title
        panel.background = element_rect(fill = "white"),
        axis.title.x = element_text(margin = margin(t = 10)), #Added length to margins
        axis.title.y = element_text(margin = margin(r = 10)))

#this concludes this script