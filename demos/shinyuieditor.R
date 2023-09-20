# https://rstudio.github.io/shinyuieditor/

remotes::install_github("rstudio/shinyuieditor")

install.packages("remotes")
remotes::install_git("https://github.com/rstudio/shinyuieditor.git")

library(shinyuieditor)

launch_editor(app_loc = "demos/conf-app")




