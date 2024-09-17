###Description: Scatter plots on penguin species for various measurments including island 
#in Palmer Archipelago, size (flipper length, body mass, bill dimensions), and sex.

#this is version 2.0 of this penguin plot (made in class of week 3b), 
#it includes changed themes, text and more

#created by: Brandon Brenes
#created on: 2024-09-16
#######################################

###Library:
library(ggplot2)
library(palmerpenguins)
library(beyonce)
library(ggthemes)
library(tidyverse)
library(here)
glimpse(penguins)

###plots
#remember, plot wont show up unless you type in "plot1", we it an 'environment'
# you need to type it out to view it now

plot1<-ggplot(data = penguins, 
              mapping = aes(x = bill_depth_mm, 
                            y = bill_length_mm,
                            group = species,
                            color = species)) + #dont forget to add this "+", 
  #Use the group function, groups all data by whatever variable you’re using 
  #(species in this case), add this in the regression area
  
 ##scatter plot code
  
  #let us continue refining the penguin plot with SCALES:
  #scale_x_continuous(limits= c(0,20), #this adds limits to your x axes for a continuous variable
  #you can add labels for these breaks 14,17,21
  #lm = linear model; you can add any function for method
  
  geom_point() + 
  geom_smooth(method = "lm") + 
  labs(x = "Bill Depth (mm)", y = "Bill Length (mm)") + 
  scale_x_continuous(breaks = c(14, 17, 21), #this adds breaks to your x axes
                     labels = c("low", "medium", "high")) + 
  scale_color_manual(values = beyonce_palette(17)) +theme_classic() +  # Added parentheses to theme_classic
  theme(axis.title = element_text(size = 22, color = "red"),  # Closed the theme() function
        panel.background = element_rect(fill = "linen"))

# "+theme_classic()" to this plot will give it a cohesive clean look, they have different themes you can use

##scale_color_manual(values = c("orange","purple","blue")) ###add manual colors

#scale_color_viridis_d()+  ###for color blind friendly

ggsave(here("Week_03","output","penguin.png"),
       width = 7, height = 5) # in inches

#When in desparate need of compliments use...
install.packages("praise")

library(praise)
praise()


