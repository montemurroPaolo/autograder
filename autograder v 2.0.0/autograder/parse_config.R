# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch

parse_config <- function(file_name = "config.txt", normalize=T){
  
  #source("load_text.R")
  #text_text_params   <- read.csv(file = "text_text_params.csv", head = TRUE, sep=",", row.names = 1, stringsAsFactors = F)
  
  # Parse txt file
  list_of_config <- load_text(file_name)
  tests    <- list_of_config[["no_comment_text"]]
  ass_name <- list_of_config[["first_row"]]
  
  # Rileva esercizi
  test_delimiter <- which(apply(tests, 1, function(r) any(r %in% c("---"))))
  n_tests        <- length(test_delimiter)-1
  
  # List of all_tests: enclose each exercise and save it
  all_tests <- list()
  score_vec <- NULL  
  
  for(i in 1:n_tests){
    single_test              <- tests[(test_delimiter[i]+1) : (test_delimiter[i+1]-1) ,1]
    single_test              <- data.frame(value = single_test, type=NA, stringsAsFactors = F)
    prep_lines_bool          <- grepl("@",single_test$value)             # check if there are preparatory lines
    prep_lines_num           <- sum(prep_lines_bool)                     # save number of them
    single_test$value        <- str_replace(single_test$value, "@", "")  # delete the preparatory symbols...
    
    # Naming each exercise type
    single_test[1,"type"]                   <- "title"
    single_test[prep_lines_bool, "type"]    <- "preparatory"
    single_test[(2+prep_lines_num), "type"] <- "test"
    single_test[(3+prep_lines_num), "type"] <- "max_score"
    if(length(single_test$value) == (3+prep_lines_num)){single_test[nrow(single_test) + 1,] <- c(text_params["feedback_negative",],"negative_feed")}else{single_test[(4+prep_lines_num), "type"] <- "negative_feed"}
    if(length(single_test$value) == (4+prep_lines_num)){single_test[nrow(single_test) + 1,] <- c(text_params["feedback_positive",],"positive_feed")}else{single_test[(5+prep_lines_num), "type"] <- "positive_feed"}
    
    all_tests <- append(all_tests, list(single_test))
    score_vec <- c(score_vec, as.numeric(single_test[single_test$type=="max_score","value"])) # saving each score for normalization...
  }
  
  if(normalize){
    # Points must sum up to 100 (normalization)
    weights <- round(score_vec/sum(score_vec) *100,1)
    if(sum(weights)!=100){weights[n_tests] <- weights[n_tests] - sum(weights) +100}
    for(i in 1:n_tests){  all_tests[[i]][all_tests[[i]]["type"]=="max_score","value"] <- weights[i]  }
  }
  
  return(all_tests)
}

