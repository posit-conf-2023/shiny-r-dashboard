library(shiny)
library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title="shinydashboard"
    ),
    dashboardSidebar(),
    dashboardBody()
  ),
  server = function(input, output, session) {
  }
)