# Functions


# Function for parsing
Replace_special_character <- function(keyword, special_char){
  char <- str_replace(keyword, paste0("\\",special_char), paste0("\\\\",special_char))
  return(char)
}

# parser
Parser <- function(text="config.txt"){
  # Read txt or R file and outputs a list containing: complete code, code without comments, length of code, content of first row
  my_text     <- read.delim(text, header = FALSE, stringsAsFactors = FALSE)
  len_text    <- length(my_text$V1)
  
  if(text=="config.txt"){
    first_row <- str_replace(my_text[1,1]," *# *","")}else{ #name of assignment
    first_row <- my_text[1,1]                               # should be a comment
  }
  
  no_comments <- dplyr::filter(my_text, !grepl("^#",V1)) # No lines with first character as hashtag
  for(i in 1:length(no_comments$V1)){ 
    if(grepl(" *#" ,no_comments[i,1])){ no_comments[i,1] <- str_replace(no_comments[i,1]," *#","#")} # Delete space before hashtages
    if(grepl("#" ,no_comments[i,1])){ no_comments[i,1] <- str_extract(no_comments[i,1], ".*?(?=#)")} # Keep everything before hashtag
  }
  no_comments <- data.frame("V1" = no_comments[no_comments$V1!="",],  header = FALSE, stringsAsFactors = FALSE) # Delete "" rows
  
  return(list(my_text, no_comments, len_text, first_row))
}


output_0_grade <- function(test_name, msge, sep){
  tests <- list()
  tests[["tests"]][[1]] <- list(name = test_name,
                                score = 0,
                                max_score = 100,
                                visibility = "visible",
                                output = msge)
  json_filename <- paste0("..",sep,"results",sep,"results.json")
  write(jsonlite::toJSON(tests, auto_unbox = T), file = json_filename)
}

separator     <- "---------------------------------------------"
big_separator <- "============================================="
