#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(lubridate)
library(plotly)
library(dplyr)

# Define UI for application that draws a histogram
data_clean <- read.csv("data/thai_road_accident_2019_2022.csv")  

data_clean$incident_datetime <- ymd_hms(data_clean$incident_datetime)  
data_clean$year  <- year(data_clean$incident_datetime)
data_clean$month <- month(data_clean$incident_datetime, label = TRUE)
data_clean$number_of_fatalities <- as.numeric(data_clean$number_of_fatalities)
data_clean$number_of_injuries   <- as.numeric(data_clean$number_of_injuries)

ui <- fluidPage(
  titlePanel("Traffic Accident Analysis"),
  tabsetPanel(
   
    tabPanel("Time Distribution",
             sidebarLayout(
               sidebarPanel(
                 radioButtons("timeGranularity", "Select Distribution:",
                              choices = c("Year", "Month"),
                              selected = "Year"),
                 conditionalPanel(
                   condition = "input.timeGranularity == 'Month'",
                   selectInput("selectedYear", "Select Year:",
                               choices = sort(unique(data_clean$year)),
                               selected = sort(unique(data_clean$year))[1])
                 )
               ),
               mainPanel(
                 plotlyOutput("timePlot")
               )
             )
    ),
    
   
    tabPanel("Fatalities / Injuries Distribution",
             sidebarLayout(
               sidebarPanel(
                 radioButtons("distType", "Select Distribution Type:",
                              choices = c("Fatalities", "Injuries"),
                              selected = "Fatalities")
               ),
               mainPanel(
                 plotlyOutput("distPlot")
               )
             )
    ),
    
   
    tabPanel("Other Factors",
             sidebarLayout(
               sidebarPanel(
                 selectInput("otherVar", "Select Variable:",
                             choices = c("Weather", "Vehicle Type", "Presumed Cause"),
                             selected = "Weather")
               ),
               mainPanel(
                 plotlyOutput("otherPlot")
               )
             )
    )
  )
)

server <- function(input, output) {
  
 
  output$timePlot <- renderPlotly({
    if (input$timeGranularity == "Year") {
      data_year <- data_clean %>%
        group_by(year) %>%
        summarise(count = n())
      p <- ggplot(data_year, aes(x = factor(year), y = count)) +
        geom_bar(stat = "identity", fill = "lightblue") +
        labs(title = "Number of Accidents by Year",
             x = "Year", y = "Count")
    } else {
      data_month <- data_clean %>%
        filter(year == input$selectedYear) %>%
        group_by(month) %>%
        summarise(count = n())
      p <- ggplot(data_month, aes(x = month, y = count)) +
        geom_bar(stat = "identity", fill = "lightgreen") +
        labs(title = paste("Number of Accidents in", input$selectedYear, "by Month"),
             x = "Month", y = "Count")
    }
    ggplotly(p)
  })
  
  
  output$distPlot <- renderPlotly({
    if (input$distType == "Fatalities") {
      p <- ggplot(data_clean, aes(x = number_of_fatalities)) +
        geom_histogram(binwidth = 1, fill = "purple", color = "black") +
        labs(title = "Distribution of Fatalities per Accident", 
             x = "Number of Fatalities", y = "Count") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 0, hjust = 0.5))
    } else {
      p <- ggplot(data_clean, aes(x = number_of_injuries)) +
        geom_histogram(binwidth = 1, fill = "orange", color = "black") +
        labs(title = "Distribution of Injuries per Accident", 
             x = "Number of Injuries", y = "Count") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 0, hjust = 0.5))
    }
    ggplotly(p)
  })
  
  
  output$otherPlot <- renderPlotly({
    
    if (input$otherVar == "Weather") {
      
      data_weather <- data_clean %>%
        group_by(weather_condition) %>%
        summarise(count = n())
      p <- ggplot(data_weather, aes(x = weather_condition, y = count)) +
        geom_bar(stat = "identity", fill = "skyblue") +
        labs(title = "Number of Accidents by Weather",
             x = "Weather Condition", y = "Count") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    } else if (input$otherVar == "Vehicle Type") {
      
      data_vehicle <- data_clean %>%
        group_by(vehicle_type) %>%
        summarise(count = n())
      p <- ggplot(data_vehicle, aes(x = vehicle_type, y = count)) +
        geom_bar(stat = "identity", fill = "salmon") +
        labs(title = "Number of Accidents by Vehicle Type",
             x = "Vehicle Type", y = "Count") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    } else if (input$otherVar == "Presumed Cause") {
     
      cause_counts <- data_clean %>%
        count(presumed_cause) %>%
        rename(count = n)
      
     
      threshold <- 1000
      significant_causes <- cause_counts %>%
        filter(count > threshold)
      
      
      data_filtered <- data_clean %>%
        filter(presumed_cause %in% significant_causes$presumed_cause)
      
      
      p <- ggplot(data_filtered, aes(
        x = reorder(presumed_cause, -table(presumed_cause)[presumed_cause])
      )) +
        geom_bar(fill = "salmon") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(title = "Number of Accidents by Presumed Cause",
             x = "Presumed Cause", y = "Count")
      
    }
    
    ggplotly(p)
  })
  
}

shinyApp(ui = ui, server = server)