# install.packages('statnet')
library(statnet)
data(package='ergm')
data(florentine)

flomarriage
plot(flomarriage, main="Florentine Marriage", cex.main=0.8)
summary(flomarriage ~ edges+triangle)

flomodel <-ergm(flomarriage ~ edges+triangle)
summary(flomodel)
