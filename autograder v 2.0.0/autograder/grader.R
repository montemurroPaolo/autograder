# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch - montep@usi.ch

# Libraries
library(evaluate)
library(stringr)

# Load functions / global variables
source("load_text.R")        # Used both from parse_config and shortcuts
source("parse_config.R")     # Make computer readable the instruction of config.txt
source("run_code.R")         # Rune the code in a separate environment
source("shortcuts.R")        # Fancy shortcuts for the tests!
source("do_assessment.R")    # Modify all_tests with tests results
source("create_feedback.R")  # From the test results, create the feedback
source("categorize_error.R") # Creates the error message for compiling or syntax error by run_code 
text_params     <- read.csv(file = "text_params.csv", head = TRUE, sep=",", row.names = 1, stringsAsFactors = F)

args <- commandArgs(trailingOnly = TRUE)

# If I'm calling this from command line
if(length(args)!=0){
  # Parameters always valid (uncomment if not using shiny)
  ass_folder      <- "assignment01"
  course_folder   <- "Programming in Finance 2020"
  sep             <- .Platform$file.sep
  
  main_folder     <- paste0("..",sep,"courses",sep,course_folder,sep,ass_folder,sep)
  #stud_submission       <- load_text(paste0(main_folder,"config.txt"))$first_row
  #stud_submission       <- paste0(main_folder,"submissions",sep, stud_submission)
  stud_submission <- args[1]
  config_name     <- paste0(main_folder,"config.txt")
  solution_name   <- paste0(main_folder,"solution.R")
  
  ### For being able to call grader() as a function, submission and solution must be global variables.
  run_submission <- run_code(stud_submission) # Run the submission in a separate environment and save it.
  submission     <- run_submission$run_env
  
  run_solution   <- run_code(solution_name, student=FALSE)# Run the solution in a separate environment and save it
  solution       <- run_solution$run_env
  }

grade <- function(stud_submission,submission,solution,
                  csv=FALSE,txt=FALSE,json=TRUE,normalize=TRUE,show_test=TRUE){

# Determine the tests
all_tests      <- parse_config(file_name = config_name, normalize=normalize)

# Assess the results of the tests
all_tests_res  <- do_assessment(all_tests, stud_submission)
#print(stud_submission)

# Create feedback
feedback       <- create_feedback(all_tests_res, csv=csv, txt=txt, json=json)

return(feedback)

}

# Call grader
if(length(args)!=0){
  grade()
  }
