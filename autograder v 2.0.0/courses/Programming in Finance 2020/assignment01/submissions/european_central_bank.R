library(ecb)
library(dplyr)

keys <- c("MNA.A.N.FR.W2.S1.S1.B.B1GQ._Z._Z._Z.EUR.V.N", 
          "MNA.A.N.DE.W2.S1.S1.B.B1GQ._Z._Z._Z.EUR.V.N", 
          "MNA.A.N.IT.W2.S1.S1.B.B1GQ._Z._Z._Z.EUR.V.N")

gdp_fr <- get_data(keys[1])       
gdp_de <- get_data(keys[2]) 
gdp_it <- get_data(keys[3]) 

gdp_fr <- data.frame(gdp_fr$obstime, gdp_fr$obsvalue)
gdp_de <- data.frame(gdp_de$obstime, gdp_de$obsvalue)
gdp_it <- data.frame(gdp_it$obstime, gdp_it$obsvalue)

colnames(gdp_fr) <- c("date", "france")
colnames(gdp_de) <- c("date", "germany")
colnames(gdp_it) <- c("date", "italy")

FR_DE <- merge(gdp_fr, gdp_de)
merged_data <- merge(FR_DE, gdp_it)

merged_short <- merged_data[-c(12:25), ]


