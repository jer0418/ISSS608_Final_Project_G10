library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",  # 可以用 "blue", "purple", "red", "yellow", "green", "black"
  
  dashboardHeader(title = "Thailand Road Accident Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("EDA Dashboard", tabName = "eda", icon = icon("chart-bar")),
      menuItem("Time Series & Lag", tabName = "timeseries", icon = icon("clock")),
      menuItem("Predictive Modeling", tabName = "predictive", icon = icon("brain"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # --- 1. EDA Tab ---
      tabItem(tabName = "eda",
              h3("Traffic Accident Analysis (EDA)"),
              p("Please wait while the dashboard loads..."),
              tags$iframe(
                src = "https://hyding.shinyapps.io/Shiny_App_EDA/",
                width = "100%", height = "900px", frameborder = "0"
              ),
              br(),
              tags$a(href = "https://hyding.shinyapps.io/Shiny_App_EDA/",
                     "👉 Or click here if it doesn't load properly",
                     target = "_blank",
                     style = "color: blue; font-size: 16px;")
      ),
      
      # --- 2. Time Series Tab ---
      tabItem(tabName = "timeseries",
              h3("Time Series & Lag Analysis"),
              p("Loading may take a few seconds..."),
              tags$iframe(
                src = "https://jer0418.shinyapps.io/Time-series/",
                width = "100%", height = "900px", frameborder = "0"
              ),
              br(),
              tags$a(href = "https://jer0418.shinyapps.io/Time-series/",
                     "👉 Or click here if it doesn't load properly",
                     target = "_blank",
                     style = "color: blue; font-size: 16px;")
      ),
      
      # --- 3. Predictive Modeling Tab ---
      tabItem(tabName = "predictive",
              h3("Predictive Modeling Dashboard"),
              p("Loading may take 10–20 seconds depending on the model and map..."),
              tags$iframe(
                src = "https://jhyunkim.shinyapps.io/Take-home_Ex3/",
                width = "100%", height = "900px", frameborder = "0"
              ),
              br(),
              tags$a(href = "https://jhyunkim.shinyapps.io/Take-home_Ex3/",
                     "👉 Or click here if it doesn't load properly",
                     target = "_blank",
                     style = "color: blue; font-size: 16px;")
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
