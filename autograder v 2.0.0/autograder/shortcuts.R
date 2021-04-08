# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch

# each shortcut returns 

# internal
evaluate_clean <- function(object,list_element = 2 ){
  temp <- evaluate(object)[[list_element]]        # This runs the function and stores the result in test, a list where the result is the second element    
  temp <- substr(temp,6,nchar(temp)-2)            # evaluate always put 5 character at the beginning and "\n" at the end
  
  return(temp)
}


keyword_count <- function(keyword, comments=FALSE, case_sensitive=TRUE){
  #submission_text <- load_text(load_text("config.txt")$first_row)   
  submission_text <- load_text(stud_submission)  
  
  if(comments){
    submission_text   <- submission_text$complete_text}else{
      submission_text <- submission_text$no_comment_text}
  
  if(!case_sensitive){
    submission_text$V1 <- tolower(submission_text$V1)
    keyword            <- tolower(keyword)
  }
  
  count   <- nrow(dplyr::filter(submission_text, grepl(keyword,V1))) # check in submission code
  
  return(count)
  
  }


object_exists <- function(object, envir = submission){
  result <- exists(object, envir=envir)

  return(result)
}


object_condition <- function(object,condition){
  
  # Tried it with [[badFn]](5). DO NOT TRY IT AGAIN.
  expr <- paste0("submission$", object, " ",
                 condition,
                 " solution$", object)
  return(expr)
}


object_equal <- function(object, tol=0, scale=1){
  
  expr <- paste0("abs(submission$", object, " - solution$", object, ") <= ", tol, "/", scale)
  
  return(expr)
}



check_all <- function(object,tol=0,scale=1){ 
  object        <- "badFn(5)"
  my_class      <- paste0("class(submission$", object, ") ",
                          "==",
                          " class(solution$", object,") ")
  my_class <- evaluate(my_class)[[2]]
  
  my_dimension  <- paste0("class(submission$", object, ") ",
                         "==",
                         " class(solution$", object,") ")
  my_dimension  <- evaluate(my_dimension)[[2]]
  
  my_value      <- object_equal(object,tol,scale)
  my_value      <- evaluate(my_value)[[2]]
  
  my_res <- c(my_class, my_dimension, my_value)
  my_res <- grepl("TRUE",my_res)
  
  return(my_res)
  
}
