library(shiny)

# Define UI for data upload app ----
ui <- fluidPage(
  
  titlePanel("Welcome to Autograder 2.0"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file_uploaded", "Upload your submission", multiple = FALSE),
      actionButton("do_grading",label = "Grade")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      textOutput("execution_time"),
      textOutput("execution"),
      tableOutput("result"),
      textOutput("total_score")
      
    )
  )
)

# Define server logic to read selected file ----
server <- function(input, output) {
  uploaded_file <- "impossiblefile"
  
  # Load the file and copy it in the submission folder
  Reactive_Var <- eventReactive(input$file_uploaded, { 
    uploaded_file <- paste0("..",.Platform$file.sep,"submission",.Platform$file.sep, input$file_uploaded$name) # Remember the name!!!
    file.copy(input$file_uploaded$datapath, uploaded_file )
    return(uploaded_file)
  }) # difference between reactive and observe: https://stackoverflow.com/questions/53016404/advantages-of-reactive-vs-observe-vs-observeevent
  

  observeEvent(input$do_grading,{
    uploaded_file <- Reactive_Var()
    # If the file is copied correctly
    if(file.exists(uploaded_file)){  
      start     <- Sys.time()
      source("grader.R")
      grade()
      execution_time <- paste0(round(Sys.time() - start,4)," seconds")
      
      # create grade report (like a function...)
      grade_report <- eventReactive(input$do_grading, { return(TRUE) })
      
      if(grade_report()){ # If we pressed grade
        output$execution_time <- renderText(paste0("Execution time:" , execution_time))
        output$execution      <- renderText(paste("Execution errors:", run_submission$run_error_feedback))
        output$result         <- renderTable(grade(csv=TRUE,txt=FALSE,json=FALSE,normalize=TRUE,show_test=TRUE))
      }
    }
  })
}

# Create Shiny app ----
shinyApp(ui, server)


