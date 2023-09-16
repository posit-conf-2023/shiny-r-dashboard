library(tidyverse)
library(shiny)
library(shinydashboard)

ggplot2::theme_set(ggplot2::theme_bw())

d = readr::read_csv(here::here("data/weather.csv"))

d_vars = d |>
  select(where(is.numeric)) |>
  names()

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title="shinydashboard"
    ),
    dashboardSidebar(
      selectInput(
        "city", "Select a city",
        choices = c("Chicago", "Durham", "Sedona", "New York", "Los Angeles")
      ),
      selectInput(
        "var", "Select a variable",
        choices = d_vars, selected = "humidity"
      ),
      sidebarMenuOutput("menu")
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "temp", 
          plotOutput("plot_temp")
        ),
        tabItem(
          "other", 
          plotOutput("plot_other")
        )
      )
    )
  ),
  server = function(input, output, session) {
    output$menu = renderMenu(
      sidebarMenu(
        menuItem("Temperature", tabName = "temp", icon = icon("thermometer-half")),
        menuItem(input$var, tabName = "other")
      )
    )
    
    d_city = reactive({
      d |>
        filter(city %in% input$city)
    })
    
    output$plot_temp = renderPlot({
      d_city() |>
        ggplot(aes(x=time, y=temp)) +
        ggtitle("Temperature") +
        geom_line()
    })
    
    output$plot_other = renderPlot({
      d_city() |>
        ggplot(aes(x=time, y=.data[[input$var]])) +
        ggtitle(input$var) +
        geom_line()
    })
  }
)
