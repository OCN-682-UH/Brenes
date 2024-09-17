###Description: Scatter plots on penguin species for various measurments including island 
#in Palmer Archipelago, size (flipper length, body mass, bill dimensions), and sex.

#this is version 1.0 of this penguin plot (made in class of week 3a)

#created by: Brandon Brenes
#created on: 2024-09-13
#######################################

#WARNING: if you run this code it will download "palmerpenguins"
install.packages("palmerpenguins")

#Library:
library(palmerpenguins)
library(tidyverse)
glimpse(penguins)

#plots

#Version 1.0- scatter plot on bill depth vs. bill length

ggplot(data=penguins, 
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm, color = species)) +
  geom_point() +
  labs(title = "Bill depth and length",
       subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
       x = "Bill depth (mm)", y = "Bill length (mm)",
       color = "Species",
       caption = "Source: Palmer Station LTER / palmerpenguins package")+
  scale_color_viridis_d()


#Version 2.0- scatter plot from Version 1.0 + Transparency (alpha) and size of points altered, easier on the eyes

ggplot(data=penguins, 
mapping = aes(x = bill_depth_mm,
              y = bill_length_mm,
              color = species,
              size = body_mass_g,
              alpha = flipper_length_mm
)) +
  geom_point()+
  scale_color_viridis_d()

##Faceting! Making multiple small plots to display species and sex data cohesively
ggplot(data=penguins, 
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     color = species,
       )) +
  geom_point()+
  scale_color_viridis_d()+
  facet_grid(species~sex)+
  guides(color = FALSE)

# 'the guides(color = false)'command gets rid of the legend.
