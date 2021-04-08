library(shiny)

# Initialization of variables
sep                 <- .Platform$file.sep
starting_assignment <- "assignment01"
starting_course     <- "Programming in Finance 2020"

course_path          <- paste0("..",sep,"courses",sep)
starting_ass_folder  <- paste0(course_path, starting_course,sep)
starting_main_folder <- paste0(starting_ass_folder, starting_assignment,sep)

# Define UI for data upload app ----
ui <- fluidPage(
  
  titlePanel("Welcome to Autograder 2.0"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file_uploaded", "Upload your submission", multiple = FALSE),
      selectInput("course","course",list.files(course_path), selected = "Programming in Finance 2020"),
      selectInput("assignment","assignment",list.files(starting_ass_folder)),
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
server <- function(input, output,session) {
  uploaded_file <- "impossiblefile"
  
# Change course folder
    observeEvent(c(input$course), {
    ass_folder_path <<- paste0(course_path,input$course)
    updateSelectInput(session,"assignment","assignment",list.files(ass_folder_path))
  })
    
# Save the assignment folder,
  observeEvent(input$assignment,{
    ass_folder_path <<- paste0(course_path,input$course) # refresh the ass_folder_path
    main_folder    <<- paste0(ass_folder_path, sep, input$assignment, sep)
    config_name    <<- paste0(main_folder,"config.txt")
    solution_name  <<- paste0(main_folder,"solution.R")
  })
    
  # Load the file and copy it in the submission folder
  Reactive_Var <- eventReactive(input$file_uploaded, { 
    uploaded_file  <- paste0(main_folder,"submissions", sep, input$file_uploaded$name) # Remember the name!!!
    print(uploaded_file)
    file.copy(input$file_uploaded$datapath, uploaded_file )
    return(uploaded_file)
  }) # difference between reactive and observe: https://stackoverflow.com/questions/53016404/advantages-of-reactive-vs-observe-vs-observeevent
  
# When button is pushed
  observeEvent(input$do_grading,{
    uploaded_file <- Reactive_Var()
    # If the file is copied correctly
    if(file.exists(uploaded_file)){ 
      stud_submission <<- uploaded_file # You can't make global results from reactive values
      start     <- Sys.time()
      
      source("grader.R")
      run_submission <- run_code(stud_submission) # Run the submission in a separate environment and save it.
      submission     <<- run_submission$run_env
      run_solution   <- run_code(solution_name, student=FALSE)# Run the solution in a separate environment and save it
      solution       <<- run_solution$run_env
      
      print(stud_submission)
      grade(stud_submission, submission, solution)
      
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


