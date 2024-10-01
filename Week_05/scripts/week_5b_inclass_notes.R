###date created: 2024/09/29 ###
###created by: Brandon Brenes ###
###last edited: 2024/09/29 ###
#description:class for week 2b - Data wrangling: lubridate dates and times 

# we will...
# convert and manipulate data and time data using lubridate
# HW is to practices with dates and times and using the joins() function

#libraries:
library(tidyverse)
library(here)
library(lubridate)

## data ##:

#condition data
cond_data <- read_csv("Week_05/data/CondData.csv")
glimpse(cond_data)

#depth data
depth_data <- read_csv("Week_05/data/DepthData.csv")
glimpse(depth_data)

## now() function: tells you what time it is now. helpful when you want to time stamp your script

# you can also ask what time it is in different time zones
now(tzone = "GMT")
# Today() function: gives you date without time. You can use timezones for this as well 

# am(now()) - asks the question "is it morning now?". Helpful to divide data into night and day

#lubridate() function - this function does a great job guessing the data format 
#With any format, you can use the lubridate function to 
#when using this, DATES MUST BE A CHARACTER THO- PUT QUOTES AROUND IT

# Date 	          Function
# 2021-02-24 	      ymd()
# 02/24/2021 	      mdy()
# February 24 2021 	mdy()
# 24/02/2021 	      dmy()

#example: mdy("02/24/2021")

# [1] "2021-02-24"
#it gives you the answer in ISO date format
#dates and time
#Time                     #function
#2021-02-24 10:22:20 PM 	ymd_hms()
#02/24/2021 22:22:20 	mdy_hms()
#February 24 2021 10:22 PM 	mdy_hm()

# make a character string

datetimes<-c("02/24/2021 22:22:20", 
             "02/25/2021 11:21:10", 
             "02/26/2021 8:01:52") 

# convert to datetimes
datetimes <- mdy_hms(datetimes)
month(datetimes, label = TRUE, abbr = FALSE) #Not number notation for months and spell it out

## [1] February February February
## 12 Levels: January < February < March < April < May < June < ... < December

day(datetimes) # extract day 
wday(datetimes, label = TRUE) # extract day of week (mon,tue,wed...)

hour(datetimes)#extract hour
minute(datetimes) #extract minute
second(datetimes) #extract second

#changing your time: your time is in the wrong time zone for instance
#example: add 4 hours to time

datetimes + hours(4)

##Challenge:##
#Read in the conductivity data (CondData.csv) 
#and convert the date column to a datetime. Use the %>% to keep everything clean.
#check to see what we're reading in, it may be ymd instead of mdy
#T and S data

#convert date column to timedate column by reading in the data, using mutate(), rename() and mdy_hms()

cond_data <- read_csv(here("Week_05/data/CondData.csv")) %>%
  mutate(date = mdy_hms(date)) %>%  # convert date column to datetime column
  rename(datetime = date) %>% # rename date column to 'datetime'
  mutate(date = as.character(date)) 

#to be safe, if the date column gets imported as a numeric, 
#mutate(date = as.character(date)) treats it as text


