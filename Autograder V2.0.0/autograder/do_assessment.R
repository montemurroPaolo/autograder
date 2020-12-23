# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch

do_assessment <- function(all_tests, ass_title){
  # single_test <- all_tests[[7]]
  all_tests_res <- list() # initialize result
  
  for(single_test in all_tests){ #single_test <- all_tests[[3]] for testing
    test           <- single_test[single_test$type=="test","value"]
    prep_lines     <- single_test[single_test$type=="preparatory","value"]
    
    # Evaluate the preparatory lines...
    if(length(prep_lines)>0){evaluate(prep_lines)}
    
    # Parse the test and check if it is one of the shortcut functions
    if(grepl("object_condition",test) | grepl("object_equal",test)){
      test <- evaluate(test)[[2]]           # This runs the function and stores the result in test, a list where the result is the second element
      test <- substr(test,6,nchar(test)-2)  # evaluate always put 5 character at the beginning and "\n" at the end
      
    }
    
    if(grepl("check_all",test)){
      
      multiple_feed   <- ""
      class_dim_value <- evaluate(test)[[2]]                                     # Evaluate the expression
      class_dim_value <- substring(class_dim_value, 5, nchar(class_dim_value)-1) # Remove evaluate characters
      class_dim_value <- strsplit(class_dim_value, " ")[[1]]                     # split each result
      
      # Create feedback
      if(!grepl("TRUE",class_dim_value[1])){multiple_feed <- paste0(multiple_feed,text_params["wrong_class","value"], "\n")}
      if(!grepl("TRUE",class_dim_value[2])){multiple_feed <- paste0(multiple_feed,text_params["wrong_dimension","value"], "\n")}
      if(!grepl("TRUE",class_dim_value[3])){multiple_feed <- paste0(multiple_feed,text_params["wrong_value","value"], "\n")}
      
      # Assign feedback
      single_test[single_test$type=="negative_feedback","value"] <- multiple_feed
      
      # If all tests are true, then TRUE is returned. False otherwise. 
      test <- all(grepl("TRUE",class_dim_value))
    }
    
    # Evaluate the test with the input solutions and polish the output
    res  <- evaluate(test)
    if(grepl("TRUE",res[[2]])){outcome <- TRUE}else{outcome <- FALSE}
    outcome_raw <- res[[2]]
    
    # Add information on the test
    single_test[nrow(single_test) + 1,] <- c(outcome,"content_result")
    if(single_test[single_test$type=="content_result","value"]==TRUE){ # if the test is correct
      single_test[nrow(single_test) + 1,] <- c(single_test[single_test$type=="max_score","value"],"score")
      single_test[nrow(single_test) + 1,] <- c(single_test[single_test$type=="positive_feed","value"],"feedback_given")
    }else{ # if the test is wrong
      
      # Add the R output if there is no feedback 
      if(single_test[single_test$type=="negative_feed","value"] == text_params["feedback_negative",]){
        single_test[single_test$type=="negative_feed","value"] <- paste0(text_params["R_error_intro",], outcome_raw)}
      # and the message for variable not found (max priority)
      if(grepl("could not find|not found",outcome_raw)){
        single_test[single_test$type=="negative_feed","value"] <- text_params["variable_not_found",]}
      
      # Give the correct feedback and score
      single_test[nrow(single_test) + 1,] <- c(0,"score")
      single_test[nrow(single_test) + 1,] <- c(single_test[single_test$type=="negative_feed","value"],"feedback_given")
      
    }
    
    all_tests_res <- append(all_tests_res, list(single_test))
  }
  
  return(all_tests_res)
  
}

