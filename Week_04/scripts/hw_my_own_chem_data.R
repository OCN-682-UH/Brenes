##Created by: Brandon Brenes 
##Last edited: 2024/09/23

#Description:
#HW_2_Using the chemistry data:
#Create a new clean script
#Remove all the NAs
#Separate the Tide_time column into appropriate columns for analysis
#Filter out a subset of data (your choice)
#use either pivot_longer or pivot_wider at least once
#Calculate some summary statistics (can be anything) and export the csv file into the output folder
#Make any kind of plot (it cannot be a boxplot) and export it into the output folder
#Make sure you comment your code and your data, outputs, and script are in the appropriate folders

#what did I end up choosing for my plot: 
#Bar graph of nutrient concentrations across different tidal conditions and times of the day

#libraries:
library(tidyverse)
library(here)
library(wesanderson)
library(readr)
library(dplyr)
library(tidyr)

#load data and glimpse
chem_data_dictionary <- read_csv("Week_04/data/chem_data_dictionary.csv")
glimpse(chem_data_dictionary)


chemicaldata_maunalua <- read_csv("Week_04/data/chemicaldata_maunalua.csv")
glimpse(chemicaldata_maunalua)

##clean up data 
#get rid of all NAs and rename it
#separate Tide_time variable into Tide and Time variables

# Clean chemical data and separate Tide_time into Tide and time
clean_chemicaldata_maunalua <- chemicaldata_maunalua %>% 
  drop_na() %>%  # Drop NAs
  separate(
    col = Tide_time,
    into = c("Tide", "Time"),
    sep = "_", 
    remove = FALSE
  )

glimpse(clean_chemicaldata_maunalua)

# pivot data into long format to make it easier to use group_by
chem_data_long <- clean_chemicaldata_maunalua %>%
  pivot_longer(
    cols = Temp_in:percent_sgd,  # The columns to pivot
    names_to = "Variables",      # New column for variable names
    values_to = "Values"         # New column for values of those variables
  )

#look at data
glimpse(chem_data_long)

#group by variables (nutrients), time and tide and define mean values of variables
summary_data <- chem_data_long %>%
  group_by(Variables, Tide, Time) %>%   # Group by Variables and Tide condition
  summarise(measurment_mean = mean(Values, na.rm = TRUE))  # Calculate the mean of each group

#look at data
glimpse(summary_data)

#this ^^ is harsh on the eyes though, as Nyssa mentioned, so lets pivot.
#format to wide data to have the variables be different columns
chem_data_wide <- summary_data %>%
  pivot_wider(
    names_from = Variables,     
    values_from = measurment_mean
    )

#look at data
glimpse(chem_data_wide)

#choose variables to use for plot based on summary statistics: 
#I chose to select() out nutrient concentrations, time and tide conditions data 

nutrient_tide_data<-chem_data_wide %>%
  select(Time, Tide, Phosphate, NN, Silicate)

#look at data
glimpse(nutrient_tide_data)

#reorganize nutrient variables and rename column to "Nutrient"
nutrient_long <- nutrient_tide_data %>%
  pivot_longer(
    cols = c(Phosphate, NN, Silicate),  # Columns to pivot
    names_to = "Nutrient",               # New column for nutrient names
    values_to = "Mean_Concentration"     # New column for mean nutrient concentration
  ) %>% 
  mutate(Nutrient = recode(Nutrient, "NN" = "Nitrate+Nitrite"))  # Recode "NN" to "Nitrate+Nitrite"

glimpse(nutrient_long)

#export the filtered out nutrient data to a CSV file
write_csv(nutrient_long, here("Week_04", "output", "hw_my_own_chem_data.csv"))

#plot: Bar graph of nutrient concentrations across different tidal conditions

ggplot(nutrient_long, aes(x = interaction(Tide), y = Mean_Concentration, fill = Time)) +
  geom_bar(stat = "identity", position = position_dodge()) +  #use stat = "identity" to plot means for each variable
  facet_wrap(~ Nutrient, scales = "free_y") +  #facet by nutrient (Nutrient)
  labs(
    title = "Nutrient Concentrations across Tides and Times of the Day",
    x = "Tide",
    y = "Mean Nutrient Concentration (umol/L)",
    fill = "Time"
  ) +
  scale_fill_manual(values = wes_palette("GrandBudapest1")) +  # Apply the Wes Anderson palette, of course.
  theme_minimal(base_size = 15) +  #use theme_minimal and have base font size be 15 to start with
  theme(
    panel.background = element_rect(fill = "ivory"), #off white panel background
    plot.background = element_rect(fill = "white"), #plot background was turning grey
    panel.grid.major = element_line(color = "lightgray"),#light gray grid lines
    axis.text.x = element_text(angle = 45, hjust = 1), #axis title- adjusted because was formatted weird
    plot.title = element_text(face = "bold", size = 20),#axis title
    axis.title.x = element_text(face = "bold", size = 14),#axis title for x
    axis.title.y = element_text(face = "bold", size = 14),#axis title for y
    legend.text = element_text(size = 10),#legend text font size
    legend.title = element_text(size = 12))#legend title font size

#save plot
ggsave(here("Week_04","output","Nutrient conc_for_tide_time.png"), width = 12, height = 8)

#this concludes the script
