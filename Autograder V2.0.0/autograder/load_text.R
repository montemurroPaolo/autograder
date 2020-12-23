#library(stringr)

load_text <- function(text="config.txt"){
  # Read txt or R file and outputs a named list containing: code without comments, content of first row
  
  my_text <- read.delim(text, header = FALSE, stringsAsFactors = FALSE)

  first_row <- str_replace(my_text[1,1]," *# *","") #Title is the first row
  
  # Delete lines with first character as hashtag
  my_text_no_comments <- dplyr::filter(my_text, !grepl("^#",V1)) 
  
  for(i in 1:length(my_text_no_comments$V1)){ 
    
    # Delete space before hashtags
    if(grepl(" *#" ,my_text_no_comments[i,1])){ my_text_no_comments[i,1] <- str_replace(my_text_no_comments[i,1]," *#","#")} 
    
    # Keep everything before hashtag
    if(grepl("#" ,my_text_no_comments[i,1])){ my_text_no_comments[i,1] <- str_extract(my_text_no_comments[i,1], ".*?(?=#)")}
  }
  
  # Delete "" rows
  my_text_no_comments <- data.frame("V1" = my_text_no_comments[my_text_no_comments$V1!="",], stringsAsFactors = FALSE) 
  
  return(list(complete_text = my_text, 
              no_comment_text = my_text_no_comments, 
              first_row = first_row))
}
