dashboardPage(
  
  dashboardHeader(title = "Performance-App"
    
  ),
  
  dashboardSidebar(
    sidebarMenu(id = "menu_sidebar",
      menuItem("Tasks & Processes", tabName = "tasks", icon = icon("calculator"))
    )
  ),
  
  dashboardBody(
    
    useShinyjs(),
    
    tags$head(
      tags$style("#plan, #result_available {font-size: 28px; font-weight: bold}")
    ),
    
    tabItems(
      tabItem(tabName = "tasks",
        fluidRow(
          column(width = 4,
            infoBox(title = tags$b(style = "font-size: 1.6em;", "Process-ID:"),
              value = div(style = "padding-top: 10px; padding-bottom: 10px; text-align: center;",
                tags$b(style = "font-size: 1.3em", Sys.getpid())
              ),
              subtitle = "The Process-ID of the R-Process you are currently working under.",
              width = NULL,
              fill = TRUE
            )
          ),
          column(width = 4,
            infoBox(title = tags$b(style = "font-size: 1.6em;", "Test responsiveness (Global):"),
              value = tagList(
                div(style = "padding-top: 10px; text-align: center;",
                  actionButton("gen_rn", "Generate random number:"),
                  div(style = "padding-top: 5px;",
                    tags$b(style = "font-size: 1.3em;", textOutput("random_number"))
                  )
                )
              ),
              subtitle = "Generate a random number to test the responsiveness of the session globally, which means every user connected
              to the R-Process with the same PID as yours can see the change.",
              width = NULL,
              fill = TRUE
            )
          ),
          column(width = 4,
            infoBox(title = tags$b(style = "font-size: 1.6em;", "Change Plan:"),
              value = div(style = "padding-top: 10px; padding-bottom: 10px; text-align: center;",
                tagList(
                  actionButton("plan_seq", "Go Sequential"),
                  actionButton("plan_multi", "Go Multisession")
                )
              ),
              subtitle = "Change the current processing plan.",
              width = NULL,
              fill = TRUE
            )
          )
        ),
        fluidRow(
          column(width = 2, offset = 1,
            h3("Perform expensive task:"),
            wellPanel(style = "background-color: #ccc9c4",
              actionButton("task_loaddata", label = "Load large dataset", width = "100%"),
              FUN_vertical_spacing(3),
              actionButton("task_sleep", label = "Sleep 10 Seconds", width = "100%"),
              FUN_vertical_spacing(3),
              actionButton("task_linearmodel", label = "Generate linear model", width = "100%")
            )
          ),
          column(width = 4, offset = 1,
            infoBox(title = tags$b(style = "font-size: 1.6em;", "Test responsiveness (User-Session):"),
              value = tagList(
                div(style = "padding-top: 10px; text-align: center;",
                  actionButton("gen_rn_2", "Generate random number:"),
                  div(style = "padding-top: 5px;",
                      tags$b(style = "font-size: 1.3em;", textOutput("random_number_2"))
                  )
                )
              ),
              subtitle = "Generate a random number to test the responsiveness of the user-session, which means only the current session
               should be able to see the change.",
              width = NULL,
              fill = TRUE
            ),
            numericInput("number_cap", label = "Enter number of Data Points", value = 1000, min = 1, max = 500000),
            plotOutput("number_plot")
          ),
          column(width = 2, offset = 1,
            h3("Task options:"),
            wellPanel(style = "background-color: #ccc9c4",
              actionButton("view_results", label = "View Results", width = "100%"),
              FUN_vertical_spacing(2),
              actionButton("clc", label = "Clear tasks", width = "100%")
            ),
            FUN_vertical_spacing(15),
            textOutput("plan"),
            FUN_vertical_spacing(10),
            textOutput("result_available")
          )
        )
      )
    )
    
  )
  
)