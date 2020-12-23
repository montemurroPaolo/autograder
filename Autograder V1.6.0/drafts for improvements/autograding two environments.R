# Global environment
x <- 1

# Create environment for student variables
stud <- new.env()
stud$x <- 2

# Create environment for solution variables
sol <- new.env()
sol$x <- 3

# Three different environments, different values for same variable name
x
stud$x
sol$x
