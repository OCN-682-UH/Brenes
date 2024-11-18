### date: 2024/11/17 ###
### creator: Brandon Brenes ###
### last edited: 2024/11/17 ###

# description: shiny app of interactive data of a coffee survey, plot and display of most frequent answer #

# libraries #
library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(rsconnect)

# load data #
coffee_survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-14/coffee_survey.csv')

# filter to include only the specified columns
selected_columns <- c("cups", "favorite", "style", "strength", "roast_level", "most_willing")
coffee_survey <- coffee_survey %>%
  select(any_of(selected_columns)) %>% # select the specified columns
  filter(roast_level %in% c("Light", "Medium", "Dark")) # filter to only include Light, Medium, Dark for roast_level

# mapping of column names to user-friendly labels
question_labels <- c(
  "cups" = "How many cups of coffee do you typically drink per day?",
  "favorite" = "What is your favorite coffee drink?",
  "style" = "What flavornotes do you prefer?",
  "strength" = "How strong do you like your coffee?",
  "roast_level" = "What roast level of coffee do you prefer?",
  "most_willing" = "What is the most you'd ever be willing to pay for a cup of coffee?"
)

# defining levels for ordered categorical variables
coffee_survey <- coffee_survey %>%
  mutate(
    cups = factor(cups, levels = c("Less than 1", "1", "2", "3", "4", "More than 4")),
    strength = factor(strength, levels = c("Weak","Somewhat light", "Medium","Somewhat strong", "Very Strong")),
    roast_level = factor(roast_level, levels = c("Light", "Medium", "Dark")),
    most_willing = factor(most_willing, levels = c("Less than $2", "$2-$4", "$4-$6", "$6-$8", "$8-$10", "$10-$15", "$15-$20", "More than $20"))
  )

# define ui for application
ui <- fluidPage(
  
  # application title with custom font and size
  titlePanel(
    "Coffee Survey Results",
    windowTitle = "Coffee Survey Results" # title of the webpage
  ),
  
  # sidebar layout
  sidebarLayout(
    sidebarPanel(
      # dropdown menu for selecting the question (variable)
      selectInput("question",
                  "Choose a question to observe:",
                  choices = setNames(names(question_labels), question_labels),
                  selected = names(question_labels)[1]),
      helpText("Select a question from the dropdown to see the frequency of the answers received")
    ),
    
    # main panel to display the histogram plot
    mainPanel(
      plotOutput("freqHist"),
      textOutput("mostFrequentResponse") #  most frequent response output
    )
  ),
  
  # custom css for coffee color theme and font adjustments
  tags$style(HTML("
    body {
      background-color: #f4f1e1;  /* light coffee cream color */
      color: #3e2a47; /* dark coffee color */
      font-family: 'Georgia', serif; /* Georgia font */
    }
    .shiny-input-container {
      background-color: #d2b48c; /* coffee brown for input containers */
      padding: 10px;
      border-radius: 5px;
    }
    .navbar {
      background-color: #3e2a47; /* dark coffee color for the navbar */
    }
    .navbar a {
      color: white;
    }
    .well {
      background-color: #f5deb3; /* light coffee brown for well sections */
    }
    #titlePanel {
      font-size: 36px;
      color: #6f4f37;
    }
  "))
)


# define server logic
server <- function(input, output) {
  
  # render histogram plot
  output$freqHist <- renderPlot({
    # get the selected question/variable from input
    selected_question <- input$question
    
    # calculate the frequency of each answer for the selected question
    response_counts <- coffee_survey %>%
      filter(!is.na(.data[[selected_question]])) %>% # filter out nas
      count(.data[[selected_question]], name = "Frequency")
    
    # plot the histogram using ggplot2
    ggplot(response_counts, aes(x = .data[[selected_question]], y = Frequency)) +
      geom_bar(stat = "identity", fill = "#6f4f37") +  # coffee brown color for bars
      labs(
        x = "Response", 
        y = "Frequency of response",
        title = question_labels[selected_question]
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) # rotate x-axis labels
  })
  output$mostFrequentResponse <- renderText({
    selected_question <- input$question
    
    # calculate the frequency of each answer for the selected question
    response_counts <- coffee_survey %>%
      filter(!is.na(.data[[selected_question]])) %>% # filter out nas
      count(.data[[selected_question]], name = "Frequency")
    
    # find the response with the highest frequency
    if(nrow(response_counts) > 0) {
      top_response <- response_counts %>%
        filter(Frequency == max(Frequency)) %>%
        pull(.data[[selected_question]])
      
      paste("Most frequent response:", top_response)
    } else {
      "No data available for this question."
    }
  })
}



# run the application
shinyApp(ui = ui, server = server)
