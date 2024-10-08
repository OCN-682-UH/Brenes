###date created: 2024/09/24 ###
###created by: Brandon Brenes ###
###last edited: 2024/09/29 ###
#description: HW for week_5- use join() and lubridate()

########################################################


#libraries:
library(patchwork)# for plotting with multiple axes units
library(tidyverse) #to manipulate date if needed
library(here) #to help save files
library(lubridate) #to help recognize dates and time
library(wesanderson) #really cool color pallette
library(readr) #for csv files if needed
library(dplyr) #to use join()
library(tidyr) #to manipulate date if needed


########################################################


#1) 

### data ###:

# cond_data #

#How:
#convert date to datetime format using lubridate's mdy_hms() and mutate()

cond_data <- read_csv(here("Week_05/data/CondData.csv")) %>% 
  drop_na() %>% #drop NAs- gets rid of non-overlapping rows of data
  mutate(date = as.character(date),#to prevent having date values that aren't characters
          date = mdy_hms(date),#convert date to datetime format
          date = round_date(date, "10 seconds")) %>% #round date to the nearest 10min so datasets match
  rename(datetime = date) #rename date column to datetime


#View changes:
glimpse(cond_data)


# depth_data #

#same changes for this dataset

depth_data <- read_csv(here("Week_05/data/DepthData.csv")) %>%
  mutate(date = ymd_hms(date), # Convert to datetime
       date = round_date(date, "10 seconds")) %>%  # Round to nearest 10 seconds
  rename(datetime = date) #rename date column to datetime


#View changes:
glimpse(depth_data)

#note: be sure seconds are all rounded to nearest 10 and that there is a 'datetime' column

########################################################


#2)

## Merging the two datasets ##

#How:
#using full_join() on the 'datetime' column
#dropping NAs makes it not include rows that have missing data


merged_data <- full_join(cond_data, depth_data, by = "datetime") %>% 
  drop_na()


#View changes:
glimpse(merged_data)  

#note: be sure no NAs and one datetime column with all other variables


########################################################


#3)

## Averaged data ##

#How:
#using group_by() minute which originated from datetime, renamed to datetime_mins.
#find avg of temp, sal, depth and pressure using summerise() per minute

averaged_data<-merged_data %>% #rename to avg data
  mutate(datetime_mins = round_date(datetime, "minute")) %>%   #as used in class 5a - round_date() function
  group_by(datetime_mins) %>% #group_by() minute since we're wanting to calc mean by the minute
summarise(
    mean_temp = mean(Temperature, na.rm = TRUE), #mean temp calculated per min
    mean_abs_press = mean(AbsPressure, na.rm = TRUE), #mean abs press calculated per min
    mean_salinity = mean(Salinity, na.rm = TRUE), #mean salinity calculated per min
    mean_depth = mean(Depth, na.rm = TRUE)) #mean depth calculated per min

#View changes:
glimpse(averaged_data)

#note: be sure to check for no 'seconds' values, since we rounded to nearest minute


########################################################


#4 

## plots ##

#I am going to make a line plot of temp and salinity vs. depth plot

ggplot(averaged_data, aes(y = mean_depth)) + #using averaged data and geom_line(), make a line plot
  geom_line(aes(x = mean_temp, color = "Temperature"), size = 1) + #aes for temp
  geom_line(aes(x = mean_salinity, color = "Salinity"), size = 1) + #aes for sal
  
  scale_y_reverse(limits = c(0.45, 0.2)) +  # reverse  depth axis so it increases downwards
  
  # add second axis for salinity
  scale_x_continuous(name = "Mean Temperature (°C)", 
                     sec.axis = sec_axis(~ ., name = "Mean Salinity (ppt)")) + # "~" makes the limits the same for both x axis variables
  
  scale_color_manual(values = c("Temperature" = "red3", "Salinity" = "blue3")) + #assign colors to variables
  
  theme_bw() + #base theme
  
  theme(panel.background = element_rect(fill = "azure"), #colors for background
        panel.grid.major = element_line(color = "gray90"),  #colors for grid lines
        panel.grid.minor = element_line(color = "gray90"),  #colors for grid lines
        axis.title.x.top = element_text(color = "blue3", face = "bold", size = 12), #colors for sal x axis title  
        axis.title.x.bottom = element_text(color = "red3", face = "bold",size = 12),  #colors for temp x axis title
        axis.text.x.top = element_text(color = "blue3"),     #colors for sal x axis tick marks, etc.
        axis.text.x.bottom = element_text(color = "red3"),  #colors for temp x axis tick marks, etc.
        legend.position = "none", #get rid of legend, colors tell the whole story
        plot.title = element_text(size = 20, face = "bold", margin = margin(b = 10))) + #plot title settings
  
  labs(y = "Depth (m)", #y axis - depth
       title = "Mean Temperature and Salinity with Depth") #title for plot

#notes on how this plot could be improved: 
# -the ends of T and S data seem to be outliers, this data could be removed manually
# -to visualize trends better, overlap these lines, make them semi-transparent to show trends that may be correlated with depth.
# -add a couple more reference numbers on the axis


########################################################


#6

## save plot ##

ggsave(here("Week_05","output","vertical_T_S_plot.png"), width = 12, height = 8)


## this concludes the script ##

