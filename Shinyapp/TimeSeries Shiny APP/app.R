library(shiny)
library(shinythemes)
library(tidyverse)
library(lubridate)
library(tsibble)
library(feasts)
library(fable)
library(plotly)
library(leaflet)

thai_data <- read_csv("data/thai_road_accident_2019_2022.csv", show_col_types = FALSE) %>%
  mutate(
    incident_datetime = parse_date_time(incident_datetime, orders = c("ymd HMS", "ymd HM", "ymd")),
    Date = as_date(incident_datetime),
    Month = yearmonth(incident_datetime),
    year = year(incident_datetime),
    month = month(incident_datetime, label = TRUE),
    day_of_week = weekdays(incident_datetime),
    hour = hour(incident_datetime),
    number_of_fatalities = as.numeric(number_of_fatalities),
    number_of_injuries = as.numeric(number_of_injuries)
  ) %>%
  filter(!is.na(Date), !is.na(province_en), province_en != "unknown")
  

all_provinces <- sort(unique(thai_data$province_en))

daily_province_ts <- thai_data %>%
  count(Date, province_en, name = "Total_Accident") %>%
  as_tsibble(index = Date, key = province_en)

model_data <- thai_data %>%
  drop_na(number_of_fatalities, vehicle_type, weather_condition, number_of_vehicles_involved, province_en, day_of_week) %>%
  mutate(
    vehicle_type = as.factor(vehicle_type),
    weather_condition = as.factor(weather_condition),
    day_of_week = as.factor(day_of_week),
    province_en = as.factor(province_en)
  )

if (nrow(model_data) > 0) {
  model <- glm(number_of_fatalities ~ province_en + vehicle_type +
                 weather_condition + day_of_week + hour +
                 number_of_vehicles_involved,
               family = poisson(), data = model_data)
} else {
  model <- NULL
  warning("Model data insufficient: not enough levels for categorical variables.")
}

# ==== UI ====
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Thailand Road Accident Analysis (2019-2022)"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("province", "Province", choices = all_provinces, selected = "Bangkok"),
      conditionalPanel(
        condition = "input.tab_selected == 'Time Series'",
        numericInput("year_start", "Year Start", value = 2021, min = 2019, max = 2023),
        numericInput("year_end", "Year End", value = 2023, min = 2019, max = 2023)
      ),
      conditionalPanel(
        condition = "input.tab_selected == 'Daily Lag'",
        sliderInput("lag_input", "Lag (Days):", min = 5, max = 60, value = 20, step = 5)
      ),
      conditionalPanel(
        condition = "input.tab_selected == 'By Accident Type'",
        selectInput("year_select", "Year Select", choices = sort(unique(thai_data$year)), selected = 2022)
      )
    ),
    
    mainPanel(
      tabsetPanel(id = "tab_selected",
                  tabPanel("Time Series", value = "Time Series", plotOutput("ts_plot")),
                  tabPanel("Daily Lag", value = "Daily Lag", plotOutput("daily_lag_plot")),
                  tabPanel("By Accident Type", value = "By Accident Type", plotOutput("type_plot"))
      )
    )
  )
)

# ==== Server ====
server <- function(input, output, session) {
  
  output$ts_plot <- renderPlot({
    daily_province_ts %>%
      filter(province_en == input$province, year(Date) >= input$year_start, year(Date) <= input$year_end) %>%
      ggplot(aes(x = Date, y = Total_Accident)) +
      geom_line(linewidth = 0.5, color = "black") +
      labs(title = paste("Daily Accidents in", input$province, "(", input$year_start, "–", input$year_end, ")"),
           x = "Date", y = "Total Accidents") +
      theme_minimal()
  })
  
  output$daily_lag_plot <- renderPlot({
    daily_province_ts %>%
      filter(province_en == input$province) %>%
      fill_gaps() %>%
      ACF(Total_Accident, lag_max = input$lag_input) %>%
      autoplot() +
      labs(title = paste("Daily Lag of Accidents in", input$province, "(lag =", input$lag_input, ")"),
           x = "Lag (days)", y = "ACF")
  })
  
  output$type_plot <- renderPlot({
    acc_ts <- thai_data %>%
      filter(province_en == input$province, year == input$year_select) %>%
      group_by(Month, accident_type) %>%
      summarise(Total = n(), .groups = "drop") %>%
      as_tsibble(index = Month, key = accident_type)
    
    ggplot(acc_ts, aes(x = Month, y = Total, color = accident_type)) +
      geom_line(linewidth = 1) +
      geom_point() +
      labs(title = paste("Monthly Accident Types in", input$province, "(", input$year_select, ")"),
           x = "Month", y = "Number of Accidents", color = "Accident Type") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)