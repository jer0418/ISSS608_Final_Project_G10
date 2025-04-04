library(shiny)

ui <- navbarPage("Thailand Road Accident Main Dashboard",
                 
                 # --- 1. EDA Tab ---
                 tabPanel("Thailand Road Accidents [2019–2022] EDA",
                          tags$div(
                            h4("EDA Dashboard"),
                            p("Please wait while the dashboard loads..."),
                            tags$iframe(
                              src = "https://hyding.shinyapps.io/Shiny_App_EDA/",
                              width = "100%",
                              height = "900px",
                              frameborder = "0"
                            ),
                            br(),
                            tags$a(href = "https://hyding.shinyapps.io/Shiny_App_EDA/",
                                   "👉 Or click here if it doesn't load properly",
                                   target = "_blank",
                                   style = "color: blue; font-size: 16px;")
                          )
                 ),
                 
                 # --- 2. Time Series Tab ---
                 tabPanel("Time Series & Lag Analysis",
                          tags$div(
                            h4("Time Series Dashboard"),
                            p("Loading may take a few seconds..."),
                            tags$iframe(
                              src = "https://jer0418.shinyapps.io/Time-series/",
                              width = "100%",
                              height = "900px",
                              frameborder = "0"
                            ),
                            br(),
                            tags$a(href = "https://jer0418.shinyapps.io/Time-series/",
                                   "👉 Or click here if it doesn't load properly",
                                   target = "_blank",
                                   style = "color: blue; font-size: 16px;")
                          )
                 ),
                 
                 # --- 3. Predictive Tab ---
                 tabPanel("Visual Exploration and Predictive Modeling",
                          tags$div(
                            h4("Predictive Modeling Dashboard"),
                            p("Loading may take 10–20 seconds depending on the model and map..."),
                            tags$iframe(
                              src = "https://jhyunkim.shinyapps.io/Take-home_Ex3/",
                              width = "100%",
                              height = "900px",
                              frameborder = "0"
                            ),
                            br(),
                            tags$a(href = "https://jhyunkim.shinyapps.io/Take-home_Ex3/",
                                   "👉 Or click here if it doesn't load properly",
                                   target = "_blank",
                                   style = "color: blue; font-size: 16px;")
                          )
                 )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
