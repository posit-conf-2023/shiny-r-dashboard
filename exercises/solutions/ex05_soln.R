library(tidyverse)
library(shiny)
library(shinydashboard)

d = readr::read_csv(here::here("data/weather.csv"))

d_vars = d |>
  select(where(is.numeric)) |>
  names()

temp_color = function(x) {
  case_when(
    x >= 0 & x < 50 ~ "aqua",
    x >=50 & x < 90 ~ "green",
    x >=90 & x < 120 ~ "red"
  )
}


shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title="Shinydashboard"
    ),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
      fluidRow(
        box(
          width=8,
          selectInput(
            "city", "Select a city",
            choices = c("Chicago", "Durham", "Sedona", "New York", "Los Angeles")
          ),
          plotOutput("plot")
        ),
        column(
          width=4,
          #flexdashboard::renderGauge("min"),
          valueBoxOutput("min", width=NULL),
          valueBoxOutput("max", width=NULL),
          valueBoxOutput("avg", width=NULL)
        )
      )
    )
  ),
  server = function(input, output, session) {
    d_city = reactive({
      d |>
        filter(city %in% input$city)
    })
    
    output$plot = renderPlot({
      d_city() |>
        ggplot(aes(x=time, y=temp)) +
        geom_line()
    })
    
    #output$min = flexdashboard::renderGauge({
    #  flexdashboard::gauge(
    #    min(d_city()$temp),
    #    min = 0, max=120, symbol = "°F",
    #    flexdashboard::gaugeSectors(success=c(60,90), warning=c(0,50), danger=c(90,120))
    #  )
    #})
    
    output$min = renderValueBox({
      m = min(d_city()$temp) |> round(1)
      valueBox(
        m,
        subtitle = "Min temp",
        icon = icon("thermometer-half"),
        color = temp_color(m)
      )
    })
    
    output$max = renderValueBox({
      m = max(d_city()$temp) |> round(1)
      valueBox(
        m,
        subtitle = "Max temp",
        icon = icon("thermometer-half"),
        color = temp_color(m)
      )
    })
    
    output$avg = renderValueBox({
      avg = mean(d_city()$temp) |> round(1)
      valueBox(
        avg,
        subtitle = "Avg temp",
        icon = icon("thermometer-half"),
        color = temp_color(avg)
      )
    })
  }
)