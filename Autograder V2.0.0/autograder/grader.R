# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch - montep@usi.ch

# Libraries
library(evaluate)
library(stringr)

# Load functions
source("load_text.R")        # Used both from parse_config and shortcuts
source("parse_config.R")     # Make computer readable the instruction of config.txt
source("run_code.R")         # Rune the code in a separate environment
source("shortcuts.R")        # Fancy shortcuts for the tests!
source("do_assessment.R")    # Modify all_tests with tests results
source("create_feedback.R")  # From the test results, create the feedback
source("categorize_error.R") # Creates the error message for compiling or syntax error by run_code 

# Parameters always valid
text_params     <- read.csv(file = "text_params.csv", head = TRUE, sep=",", row.names = 1, stringsAsFactors = F)
ass_title       <- load_text("config.txt")$first_row
ass_title       <- paste0("..",.Platform$file.sep,"submission",.Platform$file.sep, ass_title)
config_name     <- "config.txt"
solution_name   <- "solution.R"

### For being able to call grader() as a function, submission and solution must be global variables.
run_submission <- run_code(ass_title) # Run the submission in a separate environment and save it. 
submission     <- run_submission$run_env

run_solution   <- run_code(solution_name, student=FALSE)# Run the solution in a separate environment and save it
solution       <- run_solution$run_env


grade <- function(csv=TRUE,txt=FALSE,json=FALSE,normalize=TRUE,show_test=TRUE){

# Determine the tests
all_tests      <- parse_config(file_name = config_name, normalize=normalize)

# Assess the results of the tests
all_tests_res  <- do_assessment(all_tests, ass_title)

# Create feedback
feedback <- create_feedback(all_tests_res, csv=csv, txt=txt, json=json)

return(feedback)

}
grade()

