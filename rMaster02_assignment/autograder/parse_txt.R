# (c) 2020 Peter Gruber and Paolo Montemurro
# Universita della Svizzera italiana
# Contact: peter.gruber@usi.ch

# Parse txt file
list_of_config <- Parser()
tests    <- list_of_config[[2]]
ass_name <- list_of_config[[4]]

# Rileva esercizi
exercise_delimiter <- which(apply(tests, 1, function(r) any(r %in% c("---"))))
n_tests            <- length(exercise_delimiter)-1

# List of exercises
exercises = list()
for(i in 1:n_tests){
  ex      <- tests[(exercise_delimiter[i]+1) : (exercise_delimiter[i+1]-1),1]
  if(length(ex)==3){ ex <- c(ex, "")}
  # added PG
  if(length(ex)==4){ ex <- c(ex, "")}
  exercises <- append(exercises, list(ex))
}

# Points must sum up to 100
scores  <- as.numeric(unlist(exercises)[ c(FALSE,FALSE,TRUE,FALSE,FALSE) ]) # score is third
weights <- as.integer(scores/sum(scores) *100)
if(sum(weights)!=100){weights[n_tests] <- weights[n_tests] - sum(weights) +100}
for(i in 1:n_tests){  exercises[[i]][3] <- weights[i]  }
