#library(evaluate)
#source("categorize_error.R")

run_code <- function(my_code, student = TRUE){
  
  # Create new envir
  run_env <- new.env() 
  
  # if the name is different (currently, this just stops the autograder, nothing is done.)
  if(student){
    if(!file.exists(my_code)) { # Check file naming
      my_cmd           <- paste0("ls ..",.Platform$file.sep,"submission")
      student_filename <- system(my_cmd,intern = TRUE)
      wrong_name_msg   <- paste0(text_params["wrong_filename",] ,student_filename,'".')
      # output_0_grade("Correct file name", wrong_name_msg, .Platform$file.sep)
      stop("Wrong filename. results written")
    }
  }
  
  # Try to directly source into run_env. Save execution into trial
  trial               <- try(source(my_code, run_env)) 
  run_error_feedback  <- "no_errors" # Will be overwritten if any error occurred

  # Check if we successfully runned the try statement
  if("try-error" %in% class(trial)){  # https://stackoverflow.com/questions/2158780/catching-an-error-and-then-branching-logic
    # If we have an error, run the code line by line and report where we have an error
    
    # Run the program of the student line by line and saves result to run_env, so we can grade it. Equivalent to source.
    replay(evaluate(file(my_code), envir=run_env) ) # https://stackoverflow.com/questions/14612190/is-there-a-way-to-source-and-continue-after-an-error
    
    # Save the errors! (Run the code line by line and save the errors)
    line_by_line    <- evaluate(file(my_code))
    errors_bool     <- grepl("error", sapply(line_by_line, class))
    error_messages  <- line_by_line[errors_bool]
    
    # Output the code and line that create an error 
    code_of_errors  <- line_by_line[errors_bool[-1]] # Because code with error is always in the line before the error
    
    # Categorize the error produced
    run_error_feedback <- categorize_error(error_messages, code_of_errors)
    
  } # Close of code with errors
  
  # Return a named list with the environment and the errors
  return(list(run_env = run_env, 
              run_error_feedback = run_error_feedback))
  
} # Close of the function

# Test:
# a <- run_code()

#output_0_grade("Code produces errors", format_errors, sep=.Platform$file.sep)
#stop("Code produces errors. results written")
