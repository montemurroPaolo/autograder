# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch

# Naming: Assignment - Exercise - Question

library(testthat)
source("parse_txt.R")


for(i in 1:n_tests){
  
  # Single exercise
  my_title   = exercises[[i]][1]
  my_test    = exercises[[i]][2]
  
  test_that(my_title, {
      eval(parse(text = my_test))
  })
}

# How to 
#fun  = eval(as.symbol(as.character(my_text[5,1]))) # evaluates one variable expressed as text  # https://stackoverflow.com/questions/9057006/getting-strings-recognized-as-variable-names-in-r
#test = eval(parse(text = as.character(my_text[5,1]))) # evaluates an equation expressed as text

