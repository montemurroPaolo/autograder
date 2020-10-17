# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch

# load in the package
library(gradeR)
library(testthat)
library(stringr)
library(evaluate)
# also requires dplyr
 
# source the functions and the test
source("functions.R")
source("parse_txt.R") # Can be done as a function. However, for this case I guess it's more straight forward like this


# ----- SETUP <----------
#file_modus <- "local"           # "local" for debugging, if you do not have a folder /autograder/results in your structure
file_modus <- "gradescope"       # "gradescope" for production
submission_file <- paste0("..",.Platform$file.sep,"submission",.Platform$file.sep, ass_name)
# -----

my_test_file    <- "tests.R"
solution_file   <- "solution.R"

# function
calcGradesForGradescope <- function(submission_file, my_test_file, debug=FALSE){

  if(missing(my_test_file)) 
    stop("Must have a test file")
  
  if(!file.exists(submission_file)) 
  {
    my_cmd <- paste0("ls ..",.Platform$file.sep,"submission")
    student_filename <- system(my_cmd,intern = TRUE)
    tests <- list()
    tests[["tests"]][[1]] <- list(name = "Correct file name",
                                  score = 0,
                                  max_score = 100,
                                  visibility = "visible",
                                  output = paste0('Your submission cannot be evaluated, because it has an incorrect file name. The file you have submitted is called "' ,student_filename,'".')
                                  )
    json_filename <- paste0("..",.Platform$file.sep,"results",.Platform$file.sep,"results.json")
    
    # now write out all the stuff to a json file
    write(jsonlite::toJSON(tests, auto_unbox = T), file = json_filename)
  } else
  {    

  if(n_tests == 0)
    stop("you need at least one graded question")
  
  testEnv <- new.env() # run student's submission in a separate environment
  
  #tryCatch(source(submission_file, testEnv),  error = function(c) c, warning = function(c) c ,message = function(c) c)
  replay(evaluate(file(submission_file))) # Run the program of the student line by line. Student can make errors.
  
  # source solution, if exists
  if(file.exists(solution_file)){source(solution_file)}
  
  # source submission parser
  parsing_submission  <- Parser(submission_file)
  submission_code <- parsing_submission[[2]]
  code_length     <- parsing_submission[[3]]
  first_row       <- parsing_submission[[4]]
    
  # Distinguish between parsing or exercise
  exercise_names   <- unlist(exercises)[ c(TRUE,FALSE,FALSE,FALSE,FALSE) ] #Select names
  which_is_parsing <- grepl("^@ ", exercise_names)                   #Select parsing exercises
  if (any(which_is_parsing))
  {
    parsing_ex       <- exercises[which_is_parsing]                  #Subset parsing ex
    for(i in 1:length(parsing_ex)){
      print(i)
      parsing_ex[[i]][1] <- substring(parsing_ex[[i]][1],3)            # Delete @ and space
      # isolate the keyword (between ( and , )): can't we now look between the ""?
      keyword            <- regmatches(parsing_ex[[i]][2], gregexpr("(?<=\\().*?(?=,)", parsing_ex[[i]][2], perl=T))[[1]][1] # https://stackoverflow.com/questions/8613237/extract-info-inside-all-parenthesis-in-r
      # TODO: add more special signs
      if( length(grep("\\(", keyword))>0 ){keyword <- Replace_special_character(keyword, "(")} # Replace ( with //( for regex
      word_check         <- nrow(dplyr::filter(submission_code, grepl(keyword,V1))) # check in submission code
      parsing_ex[[i]][2] <- str_replace(parsing_ex[[i]][2],"(?<=\\().*?(?=,)", as.character(word_check)) # replace variable name with result
    }
    exercises[which_is_parsing] <- parsing_ex # Bring back to exercises
  }
  
  # test the student's submissions
  lr               <- ListReporter$new()                                      ### Original code
  out              <- test_file(my_test_file, reporter=lr,  env = testEnv)                 ### Original code
  tests            <- list()                                                  ### Original code  
  tests[["tests"]] <- list()                                                  ### Original code
  raw_results      <- lr$results$as_list()                                    
  
  for(i in 1:n_tests){
    ex                    <- exercises[[i]]
    test_name             <- ex[1] 
    test_max_score        <- ex[3]
    assertionResults      <- raw_results[[i]]$results
    success               <- all(sapply(assertionResults, methods::is, "expectation_success"))
    test_score            <- ifelse(success, test_max_score, 0)
    
    tests[["tests"]][[i]] <- list(name = test_name,
                                  score = test_score,
                                  max_score = test_max_score,
                                  visibility = "visible")
    
    # Paste messages...
    if(test_score != test_max_score){
      
      # Paste user-defined errors
      if(ex[4]!=""){
        msg <- paste0(ex[4], "\n")}else{
          msg <- paste0("R reports the following error(s): \n",raw_results[[i]][["results"]][[1]][["message"]])
        }
      
      # Paste correct result
    }else{
      if(ex[5]!=""){
        msg <- paste0(ex[5], "\n")}else{
          msg <- "Congratulations, the answer is correct!"
        }
      
    }
    
    # Insert the message
    tests[["tests"]][[i]][["output"]] <- msg
  }
  
  #Debug stuff
  if(debug){print(tests)}
  
  # Prepare the output location
  # Use / or \ .Platform$file.sep
  json_filename <- paste0("..",.Platform$file.sep,"results",.Platform$file.sep,"results.json")
  
  # now write out all the stuff to a json file
  write(jsonlite::toJSON(tests, auto_unbox = T), file = json_filename)

}
}  # end of if ... wrong file

calcGradesForGradescope(submission_file, my_test_file) 
  


