library(shiny)
library(future)
library(promises)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(shinyjs)
library(DT)

plan(multisession)

reac <- reactiveValues(
  plan = "Multisession",
  random_number = round(runif(1, min = 1000, max = 9999))
)

# Helper-Functions
FUN_vertical_spacing <- function(space) {
  div(style = paste0("min-height: ", space, "vh;"))
}


