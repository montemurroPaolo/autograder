# Solution to assignment set 02
# Programming in Finance I
# peter.gruber@usi.ch, 2020-10 

badFn <- function(x)
# Calculates the square of a number. 
# INPUT   x  1x1 .. a number
# OUTPUT  y  1x1 .. the square
# USAGE   badFn(x) 
# peter.gruber@usi.ch, 2011-09-01
    {
    y <- x^2
    return(y)
    }

blackScholesCall <- function (S,K,t,r,sigma)
# blackScholes Price of a call option according to Black-Scholes
# INPUT     S ... scalar ... price of the stock
#           K ... scalar ... strike price
#           t ... scalar ... duration [year]
#           r ... scalar ... interest rate  [fraction]
#           sigma scalar ... sigma, the implied volatility
# OUTPUT    BSC . scalar ... the Black Scholes Call price
# USAGE     blackScholes(S,K,r,t,sigma)
# EXAMPLE  blackScholes(50,50,1,0.05,0.2)
# peter.gruber@usi.ch, 2010-10-07
    {
    d1  <- ( log(S/K)+(r+.5*sigma^2)*t ) / ( sigma*sqrt(t) )
    d2  <- d1 - sigma*sqrt(t)
    BSC <- S*pnorm(d1) - exp(-r*t)*K*pnorm(d2)
    return(BSC)   # Do not forget return()
    }


dcinterest <- function(r,t) 
# Calculates the discretely compounded interest on 1 Euro. 
# INPUT	  r	1x1 .. interest rate [fractions of 1]
#         t	1x1 .. duration in yrs
# OUTPUT y  1x1 .. payoff
# USAGE   dcinterest(r,t) 
# peter.gruber@usi.ch, 2011-09-01
    {
    tFull <- floor(t)      # full years for re-investment
    tFrac <- t-tFull       # fractional years, no re-investmetn 
    y <- (1+r)^tFull       # Amount after tFull years
    y <- y * (1+r*tFrac)   # Interest for the tFrac year
    return(y)
}


