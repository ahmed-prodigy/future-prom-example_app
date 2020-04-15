function(input, output, session){
  
  reac_sess <- reactiveValues(
    random_number = round(runif(1, min = 1000, max = 9999)),
    active_task = FALSE,
    current_task = "task_null",
    dataset = NULL,
    model = NULL
  )
  
  plot_df <- eventReactive(input$number_cap, {
    cap <- input$number_cap
    
    future({
      x <- runif(cap)
      y <- runif(cap)
      data.frame("x" = x, "y" = y)
    })     
  })
  
  # Renderer ------------------
  output$plan <- renderText({
    paste0("Current Plan: ", reac$plan)
  })
  
  output$result_available <- renderText({
    if(!reac_sess$active_task){
      paste0("No result available")
    } else {
      paste0("Result available!")
    }
  })
  
  output$random_number <- renderText({
    reac$random_number
  })
  
  output$random_number_2 <- renderText({
    reac_sess$random_number
  })
  # ---------------------------
  
  
  # Buttons -------------------
  observeEvent(input$gen_rn, {
    reac$random_number <- round(runif(1, min = 1000, max = 9999))
  })
  
  observeEvent(input$gen_rn_2, {
    reac_sess$random_number <- round(runif(1, min = 1000, max = 9999))
  })
  
  observeEvent(input$plan_seq, {
    plan(sequential)
    reac$plan <- "Sequential"
  }, ignoreInit = TRUE)
  
  observeEvent(input$plan_multi, {
    plan(multisession)
    reac$plan <- "Multisession"
  }, ignoreInit = TRUE)
  
  observeEvent(input$task_loaddata, {
    
    p <- Progress$new()
    p$set(value = 0.5, message = "Load Dataset")
    
    future({
      cat(paste0("--- Executed task 'Loading dataset' under PID: ", Sys.getpid(), "\n")) 
      read.csv("1500000 Sales Records.csv") 
    }) %...>%
      {
        reac_sess$dataset <- .
        reac_sess$current_task <- "task_load"
        reac_sess$active_task <- TRUE
        cat(paste0("--- Finished task 'Loading dataset' under PID: ", Sys.getpid(), "\n\n"))
      } %>%
      finally(~p$close())
  })
  
  observeEvent(input$task_sleep, {

    p <- Progress$new()
    p$set(value = 0.1, message = "Begin Sleeping")

    future({
      Sys.sleep(5)
    }) %...>%
      { p$set(value = 0.6, message = "Slept for 5 seconds") } %...>%
      { 
        future({
          Sys.sleep(5)
          cat(paste0("--- Executed task 'Sleeping' under PID: ", Sys.getpid(), "\n"))
        }) 
      } %...>%
      {
        reac_sess$current_task <- "task_sleep"
        reac_sess$active_task <- TRUE
        cat(paste0("--- Finished task 'Sleeping' under PID: ", Sys.getpid(), "\n\n"))
      } %>%
      finally(~p$close())
  })
  
  observeEvent(input$task_linearmodel, {
    
    p <- Progress$new()
    p$set(value = 0.5, message = "Calcualting model")
    
    future({
      cat(paste0("--- Executed task 'Linear Model' under PID: ", Sys.getpid(), "\n")) 
      lm(x ~ y, data.frame("x" = runif(5e6), "y" = runif(5e6)))
    }) %...>%
      {
        reac_sess$model <- .
        reac_sess$current_task <- "task_model"
        reac_sess$active_task <- TRUE
        cat(paste0("--- Finished task 'Linear Model' under PID: ", Sys.getpid(), "\n\n"))
      } %>%
      finally(~p$close())
  })
  
  observeEvent(input$view_results, {
    validate(
      need(reac_sess$active_task == TRUE, "No result currently available")
    )
    
    if(reac_sess$current_task == "task_load"){
      showModal(
        modalDialog(title = "Results",
          tagList(
            wellPanel(style = "overflow-x: scroll; overflow-y: scroll",
              dataTableOutput("result")
            ),
            h3("Loaded a 1500000-Row dataset asynchronus")
          )
        )
      )
      
      output$result <- renderDataTable({
        reac_sess$dataset
      })
    }
    
    if(reac_sess$current_task == "task_sleep"){
      showModal(
        modalDialog(title = "Results",
          h3("Slept for 10 seconds")
        )
      )
    }
    
    if(reac_sess$current_task == "task_model"){
      showModal(
        modalDialog(title = "Results",
          tagList(
            h4(reac_sess$model$call %>% as.character() %>% paste(collapse = " ")),
            h4(paste("Intercept: ", reac_sess$model$coefficients[1])),
            h4(paste("y: ", reac_sess$model$coefficients[1])),
            h3("Calculated lm-Model with 5e6 data points in x/y each")
          )
        )
      )
    }
  })
  
  observeEvent(input$clc, {
    reac_sess$active_task <- FALSE
    reac_sess$current_task <- "task_null"
  })
  # ---------------------------
  
  # Plot ----------------------
  output$number_plot <- renderPlot({
    plot_df() %...>%
    {
      df <- .
      ggplot(df, aes(x = x, y = y)) + 
        geom_point()
    }
  })
  # ---------------------------
  
  # Observer ------------------
  
  # ---------------------------
  
}