library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(waiter)

# Custom CSS
custom_css <- "
  .skin-red .main-header .logo {
    background-color: #2c3e50;
    font-family: 'Arial', sans-serif;
    font-weight: bold;
  }
  .skin-red .main-header .logo:hover {
    background-color: #1a252f;
  }
  .skin-red .main-header .navbar {
    background-color: #2c3e50;
  }
  .content-wrapper {
    background-color: #f8f9fa;
  }
  .box {
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }
  .tab-content {
    padding: 20px;
  }
  .main-header .logo {
    font-weight: bold;
    font-size: 20px;
  }
  .sidebar-menu li a {
    font-size: 15px;
    padding: 12px 15px;
    transition: all 0.3s ease;
    color: #2c3e50;
  }
  .sidebar-menu li.active a {
    background-color: #f8f9fa;
    border-left: 4px solid #2c3e50;
    color: #2c3e50;
  }
  .iframe-container {
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    margin: 20px 0;
    position: relative;
  }
  .loading-message {
    text-align: center;
    padding: 20px;
    color: #666;
    font-style: italic;
  }
  .tab-title {
    color: #2c3e50;
    margin-bottom: 20px;
    font-weight: bold;
    font-size: 24px;
    display: inline-block;
  }
  .external-link {
    background-color: #2c3e50;
    color: white;
    padding: 10px 20px;
    border-radius: 4px;
    text-decoration: none;
    transition: all 0.3s ease;
    margin: 0 10px;
  }
  .external-link:hover {
    background-color: #1a252f;
    color: white;
  }
  .badge {
    background-color: #2c3e50;
  }
  .sidebar-menu .fa {
    color: #2c3e50;
  }
  .return-button {
    background-color: #37465B;
    color: white !important;
    padding: 8px 16px;
    border-radius: 4px;
    text-decoration: none;
    transition: all 0.3s ease;
    float: right;
    margin-top: 10px;
    margin-right: 20px;
    font-size: 14px;
    border: none;
  }
  .return-button:hover {
    background-color: #2c3e50;
    color: white !important;
    text-decoration: none;
  }
  .header-container {
    position: relative;
    margin-bottom: 30px;
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
"

ui <- dashboardPage(
  skin = "red",
  
  dashboardHeader(
    title = span("TRAFFIC_ACCIDENT Dashboard", 
                 style = "font-family: 'Arial', sans-serif; font-weight: bold;"),
    titleWidth = 300
  ),
  
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      menuItem("EDA Dashboard", 
               tabName = "eda", 
               icon = icon("chart-bar"),
               badgeLabel = "Analysis",
               badgeColor = "red"),
      menuItem("Time Series & Lag", 
               tabName = "timeseries", 
               icon = icon("clock"),
               badgeLabel = "Trends",
               badgeColor = "red"),
      menuItem("Predictive Modeling", 
               tabName = "predictive", 
               icon = icon("brain"),
               badgeLabel = "Forecast",
               badgeColor = "red")
    )
  ),
  
  dashboardBody(
    tags$head(tags$style(HTML(custom_css))),
    use_waiter(),
    
    tabItems(
      # --- 1. EDA Tab ---
      tabItem(tabName = "eda",
              fluidRow(
                column(12,
                       div(class = "header-container",
                           h2("Exploratory Data Analysis", class = "tab-title"),
                           tags$a(href = "https://isss608-ay2024-25aug-group10.netlify.app/",
                                  "Return to Main Website",
                                  class = "return-button")
                       ),
                       div(class = "iframe-container",
                           waiter::waiter_show_on_load(
                             html = tagList(
                               spin_flower(),
                               "Loading dashboard..."
                             ),
                             color = "rgba(255, 255, 255, 0.9)"
                           ),
                           tags$iframe(
                             src = "https://hyding.shinyapps.io/Shiny_App_EDA/",
                             width = "100%", 
                             height = "900px", 
                             frameborder = "0"
                           )
                       ),
                       div(style = "text-align: center; margin-top: 20px;",
                           tags$a(href = "https://hyding.shinyapps.io/Shiny_App_EDA/",
                                  "👉 Open in New Window",
                                  target = "_blank",
                                  class = "external-link")
                       )
                )
              )
      ),
      
      # --- 2. Time Series Tab ---
      tabItem(tabName = "timeseries",
              fluidRow(
                column(12,
                       div(class = "header-container",
                           h2("Time Series Analysis", class = "tab-title"),
                           tags$a(href = "https://isss608-ay2024-25aug-group10.netlify.app/",
                                  "Return to Main Website",
                                  class = "return-button")
                       ),
                       div(class = "iframe-container",
                           waiter::waiter_show_on_load(
                             html = tagList(
                               spin_flower(),
                               "Loading dashboard..."
                             ),
                             color = "rgba(255, 255, 255, 0.9)"
                           ),
                           tags$iframe(
                             src = "https://jer0418.shinyapps.io/Time-series/",
                             width = "100%", 
                             height = "900px", 
                             frameborder = "0"
                           )
                       ),
                       div(style = "text-align: center; margin-top: 20px;",
                           tags$a(href = "https://jer0418.shinyapps.io/Time-series/",
                                  "👉 Open in New Window",
                                  target = "_blank",
                                  class = "external-link")
                       )
                )
              )
      ),
      
      # --- 3. Predictive Modeling Tab ---
      tabItem(tabName = "predictive",
              fluidRow(
                column(12,
                       div(class = "header-container",
                           h2("Predictive Analysis", class = "tab-title"),
                           tags$a(href = "https://isss608-ay2024-25aug-group10.netlify.app/",
                                  "Return to Main Website",
                                  class = "return-button")
                       ),
                       div(class = "iframe-container",
                           waiter::waiter_show_on_load(
                             html = tagList(
                               spin_flower(),
                               "Loading dashboard..."
                             ),
                             color = "rgba(255, 255, 255, 0.9)"
                           ),
                           tags$iframe(
                             src = "https://jhyunkim.shinyapps.io/Take-home_Ex3/",
                             width = "100%", 
                             height = "900px", 
                             frameborder = "0"
                           )
                       ),
                       div(style = "text-align: center; margin-top: 20px;",
                           tags$a(href = "https://jhyunkim.shinyapps.io/Take-home_Ex3/",
                                  "👉 Open in New Window",
                                  target = "_blank",
                                  class = "external-link")
                       )
                )
              )
      )
    )
  )
)

server <- function(input, output, session) {
  # Initialize waiter
  waiter_hide()
}

shinyApp(ui, server)
