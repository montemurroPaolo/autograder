# Optim - (Deliberately non-sense optimization function)
weights     <- c(0.33,0.33,0.34)
past_return <- c(0.1,0.1,0.2)
past_sd     <- c(0.05,0.1,0.2)

out   <- optim(par     = weights,  function(weights)(-sum(weights * past_return * past_sd)),
             #Can insert new parameters. See https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/optim
             method  = "L-BFGS-B", lower   = -1, upper   = 1 )

optimal_weights <- out$par / sum(out$par)
