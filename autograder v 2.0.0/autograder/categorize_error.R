categorize_error <- function(error_messages, code_of_errors, format_errors=""){
  # Would be better to have a df: error and message of error in 2 different columns
  
  # ======= Syntax error
  if(length(code_of_errors)==2){  # When there is a Syntax error, length of the list is 2 (containing also type of syntax error in element 2) 
    # Alternatively (not work, just concept):     any(grepl("simpleError", class(code_of_errors[[2]]))) # If we have a syntax error (called simpleError) # https://stat.ethz.ch/R-manual/R-devel/library/base/html/conditions.html
    format_errors <- paste0(text_params["syntax_error",],"\n",error_messages[[1]])
    
    # ======== Compiling error
  }else{
    for(i in 1:length(error_messages)){  # For each error (there could be many)
      format_errors <- paste0(format_errors, 
                              text_params["compiling_error",],
                              text_params["separator",],"\n",code_of_errors[[i]][[1]],"\n",text_params["separator",],
                              "\nError message:\n",
                              error_messages[[i]],
                              "\n\n",text_params["big_separator",],"\n") 
    } # Close of the for
  } # Close of the else
  
  return(format_errors)
  
} # Close of function Categorize