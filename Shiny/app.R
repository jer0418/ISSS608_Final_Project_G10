library(shiny)
library(shinythemes)
library(tidyverse)
library(lubridate)
library(tsibble)
library(feasts)
library(fable)
library(plotly)
library(leaflet)

# ==== 数据读取与预处理 ====
thai_data <- read_csv("data/thai_road_accident_2019_2022.csv", show_col_types = FALSE) %>%
  mutate(
    incident_datetime = parse_datetime(as.character(incident_datetime), format = "%Y-%m-%d %I:%M:%S %p"),
    Date = as_date(incident_datetime),
    Month = yearmonth(incident_datetime),
    year = year(incident_datetime),
    month = month(incident_datetime, label = TRUE),
    day_of_week = weekdays(incident_datetime),
    hour = hour(incident_datetime),
    number_of_fatalities = as.numeric(number_of_fatalities),
    number_of_injuries = as.numeric(number_of_injuries)
  ) %>%
  drop_na(province_en)

all_provinces <- sort(unique(na.omit(thai_data$province_en)))

daily_province_ts <- thai_data %>%
  filter(!is.na(Date), !is.na(province_en)) %>%
  count(Date, province_en, name = "Total_Accident") %>%
  as_tsibble(index = Date, key = province_en)

model_data <- thai_data %>%
  drop_na(number_of_fatalities, vehicle_type, weather_condition, number_of_vehicles_involved, province_en, day_of_week) %>%
  mutate(
    vehicle_type = as.factor(vehicle_type),
    weather_condition = as.factor(weather_condition),
    day_of_week = as.factor(day_of_week),
    province_en = as.factor(province_en)
  ) %>%
  filter(
    n_distinct(vehicle_type) > 1,
    n_distinct(weather_condition) > 1,
    n_distinct(day_of_week) > 1,
    n_distinct(province_en) > 1
  )

model <- glm(number_of_fatalities ~ province_en + vehicle_type +
               weather_condition + day_of_week + hour +
               number_of_vehicles_involved,
             family = poisson(), data = model_data)

# ==== UI ====
# ...(UI 结构保留不变)...
# ==== Server ====
# ...(Server 结构保留不变)...

# ==== 启动应用 ====
shinyApp(ui = ui, server = server)