library(tidyverse)
library(shiny)
library(bslib)

ggplot2::theme_set(ggplot2::theme_bw())

d = readr::read_csv(here::here("data/weather.csv"))

d_vars = d |>
  select(where(is.numeric)) |>
  names()

shinyApp(
  ui = page_sidebar(
    title = "bslib dashboard",
    sidebar = sidebar(open=FALSE),
    card(
      card_header(
        "Temperature",
        popover(
          bsicons::bs_icon("gear"),
          title = "Input controls",
          selectInput(
            "city", "Select a city",
            choices = c("Chicago", "Durham", "Sedona", "New York", "Los Angeles"),
            selected = "Chicago", multiple = TRUE
          )
        )
      ), 
      plotOutput("plot_temp")
    ),
    card(
      card_header(textOutput("header_other")),
      layout_sidebar(
        sidebar = sidebar(
          position = "right", open = FALSE,
          selectInput(
            "var", "Select a variable",
            choices = d_vars, selected = "humidity"
          )
        ),
        plotOutput("plot_other")
      )
    )
  ),
  server = function(input, output, session) {
    d_city = reactive({
      d |>
        filter(city %in% input$city)
    })
    
    output$plot_temp = renderPlot({
      d_city() |>
        ggplot(aes(x=time, y=temp, color=city)) +
        geom_line()
    })
    
    output$header_other = renderText({input$var})
    
    output$plot_other = renderPlot({
      d_city() |>
        ggplot(aes(x=time, y=.data[[input$var]], color=city)) +
        geom_line()
    })
  }
)
