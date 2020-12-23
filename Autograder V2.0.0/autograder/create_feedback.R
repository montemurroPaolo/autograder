#source("parse_config.R")
#source("run_code.R")
#source("do_assessment.R")
#all_tests_res   <- parse_config()
#single_test <- all_tests_res[[1]]
#single_test <- do_assessment(single_test)

create_feedback <- function(all_tests_res, csv=TRUE, txt=FALSE, json=TRUE, show_test=TRUE){
  
  # initialize outputs
  directory   <- paste0("..",.Platform$file.sep,"results",.Platform$file.sep,"results")
  txt_output  <- NULL
  csv_output  <- data.frame(title = character(), test = character(), score = numeric(), 
                            max_score = numeric(), feedback_given = character(), stringsAsFactors = F ) 
  
  for(single_test in all_tests_res){

    # For readability
    title      <- single_test[single_test$type=="title","value"]
    test       <- single_test[single_test$type=="test","value"]
    score      <- single_test[single_test$type=="score","value"]
    max_score  <- single_test[single_test$type=="max_score","value"]
    feedback_given   <- single_test[single_test$type=="feedback_given","value"]
            
                      
    if(txt){ # Create readable txt output
      if(show_test){test_row <- paste0("Test: ", test, "\n")}else{test_row <- ""}
      txt_output <- paste0(txt_output, 
                           title,     "\n",
                           test_row,
                           "Score: ", score, "/",max_score,"\n",
                           feedback_given,  "\n \n")
    }
    
    if(csv){
      csv_output[nrow(csv_output)+1,] <- c(title,test,score,max_score,feedback_given)
    }
  }
  
  # Manipulation of csv_output
  csv_output$score <- as.numeric(csv_output$score) ; csv_output$max_score <- as.numeric(csv_output$max_score)
  total_score      <- paste0(round(100* sum(csv_output$score) / sum(csv_output$max_score),2),"%")
  csv_output[nrow(csv_output)+1,] <- c("TOTAL SCORE","",sum(csv_output$score),sum(csv_output$max_score),"")
  if(!show_test){csv_output <- csv_output[ , !names(csv_output) %in% c("test")]} 
  
  # Create outputs
  if(txt){
    paste0("Total score: ", total_score, "\n\n", txt_output)
    cat(txt_output ,file=paste0(directory,".txt"),sep="")
  }
  
  if(json){
    write(jsonlite::toJSON(all_tests_res, auto_unbox = T),  file=paste0(directory,".json"))
    
  }
  
  if(csv){
    write.csv(csv_output, file=paste0(directory,".csv"))
    return(csv_output) # only return this (for shiny...)
  } 
  
  
}
