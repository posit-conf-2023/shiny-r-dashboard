library(shiny)
library(bslib)

card1 <- card(
  card_header("Faithful Plot"),
  layout_sidebar(
    sidebar = sidebar(
      sliderInput(
        "bins",
        "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      )
    ),
    plotOutput("distPlot")
  )
)

card2 <- card(
  card_header("Other Card")
)

ui <- page_fixed(
  theme = bs_theme(
    version = 5,
    bootswatch = "yeti",
    "border-width" = "5px"
  ),
  title = "Old Faithful Geyser Data",
  card1,
  input_dark_mode()
)

server <- function(input, output) {
  bs_themer()
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(
      x,
      breaks = bins,
      col = 'darkgray',
      border = 'white',
      xlab = 'Waiting time to next eruption (in mins)',
      main = 'Histogram of waiting times'
    )
  })
}

shinyApp(ui = ui, server = server)
