###date created: 2024/10/08 ###
###created by: Brandon Brenes ###
###last edited: 2024/10/08 ###

#description: In class notes for ggmaps. For HW from now on, we will be submitting a knitted rmarkdown file

############################################################################################

## library: ##
library(tidyverse)
library(here)
library(maps)
library(mapdata)
library(mapproj)
library(readr)
library(ggdogs)
library(ggmap)

############################################################################################


## load data ##


# Read in data on population in California by county
popdata<-read_csv(here("Week_07","data","CApopdata.csv"))

# view #
glimpse(popdata)

#read in data on number of seastars at different field sites
stars<-read_csv(here("Week_07","data","stars.csv"))

# view #
glimpse(stars)

############################################################################################


## maps package info ##


#The {maps} packageis a combination of functions that pair well with ggplot and base layers for maps 

#example: get data for the entire world
world<-map_data("world")
head(world)

#countries
France<-map_data("france")
head(France)

#state
states<-map_data("state") #only states in the US

#counties
counties<-map_data("county")

############################################################################################

## structure of the data ##

#long is longitude. Things to the west of the prime meridian are negative
#lat is latitude
#order. This just shows in which order ggplot should “connect the dots”
#region and subregion tell what region or subregion a set of points surrounds
#group. This is very important! ggplot2’s functions can take a group argument which controls 
#(amongst other things) whether adjacent points should be connected by lines. 
#If they are in the same group, then they get connected, 
#but if they are in different groups then they don’t. 
#Essentially, having to points in different groups means that ggplot “lifts the pen” when going between them.


## example ##
 
ggplot()+
  geom_polygon(data = world, 
               aes(x = long, 
                   y = lat, 
                   group = group, #group lat and long, tells it how to link points
                   fill = region), #regions will be outlined
               color = "black") + #make the countries outline black
  guides(fill = FALSE) + #make sure this is FALSE
  theme_light() + #add a theme, get jiggy wit it
  theme(panel.background = element_rect(fill = "lightblue3"))+
  coord_map(projection = "sinusoidal",#make it have the curves that more closely depict the world
            xlim = c(-180,180)) #you can crop in on a particular spot if you wanted


#example lets make a map of cali
CA_data<-states %>%
  filter(region == "california")

ggplot()+
  geom_polygon(data = CA_data,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = region),
               color = "red4")+
  coord_map(projection = "mercator")+
  theme_void()

#if we want region/county outlined...

CApop_county<-popdata %>%
  select("subregion" = County, Population)  %>% # rename the county col
  inner_join(counties) %>% #join two sets
  filter(region == "california")

ggplot()+
  geom_polygon(data = CApop_county,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = Population),
               color = "blue4")+
  geom_point(data = stars, # add a point at all my sites
              aes(x = long,
                  y = lat,
                  size = star_no))+ # star pop in cali
  coord_map(projection = "mercator") +
  theme_void() +
  scale_fill_gradient(trans = "log10") + #so we can visualize the population differences better
  labs(size = "# stars/m2")


## save ##
ggsave(here("Week_07","output","CApop.pdf"))


## this concludes the script ##

