library(shiny)
library(plotly)
library(gridlayout)
library(bslib)


ui <- grid_page(
  layout = c(
    "header  header  ",
    "sidebar plot "
  ),
  row_sizes = c(
    "100px",
    "1fr"
  ),
  col_sizes = c(
    "250px",
    "1fr"
  ),
  gap_size = "1rem",
  grid_card(
    area = "sidebar",
    card_header("Settings"),
    card_body(
      selectInput(
        inputId = "city",
        label = "City",
        choices = list(
          "Chicago" = "Chicago",
          "Durham" = "Durham",
          "Seattle" = "Seattle",
          "Premium" = "Premium",
          "Ideal" = "Ideal"
        ),
        selected = "Ideal",
        width = "100%"
      ),
      checkboxGroupInput(
        inputId = "var",
        label = "Variable",
        choices = list("temp" = "temp", "precip" = "precip")
      )
    )
  ),
  grid_card_text(
    area = "header",
    content = "Today's Forecast",
    alignment = "start",
    is_title = FALSE
  ),
  grid_card(
    area = "plot",
    card_header("Interactive Plot"),
    card_body(
      plotlyOutput(
        outputId = "plot",
        width = "100%",
        height = "100%"
      )
    )
  )
)


server <- function(input, output) {
   
  output$plot <- renderPlotly({
    
  })
  
}

shinyApp(ui, server)
  

