#ECON7217 Statistic Network Formation: Latent Space Model with 'latentnet'
#April 3 2020


setwd("C:/Users/ssunr/Dropbox/teaching_NTU/Econ7217/tutorial_materials/lecture 4/");
install.packages("latentnet");
install.packages("ergm");
library(ergm);
library(sna);
library(latentnet);
library(network);

load("dataset_ergmm.RData");


#Blocking Model with 'sna'

eq <- equiv.clust(net);
block <- blockmodel(net, eq, k=2);
plot(block);


plot(net, vertex.col = "male")


# Latent Space Effects
#
# euclidean(d, G=0, var.mul=1/8, var=NULL, var.df.mul=1, var.df=NULL, mean.var.mul=1, mean.var=NULL, pK.mul=1, pK=NULL) 
# Adds a term to the model equal to the negative Eucledean distance -dist(Z[i],Z[j]), where Z[i] and Z[j] are the positions of their respective actors in an unobserved social space. 
#
# bilinear(d, G=0, var.mul=1/8, var=NULL, var.df.mul=1, var.df=NULL, mean.var.mul=1, mean.var=NULL, pK.mul=1, pK=NULL)
# Adds a term to the model equal to the inner product of the latent positions: sum(Z[i]*Z[j]), where Z[i] and Z[j] are the positions of their respective actors in an unobserved social space.
#
# Actor-specific effects
# rsender(var=1, var.df=3)
# Random sender effect. Adds a random sender effect to the model


model1_fomula <- formula(net ~ euclidean(d=2));
model1 <- ergmm(model1_fomula,
                control=ergmm.control(burnin=100000,sample.size= 10000,interval=5));
summary(model1);
plot(model1, pie = TRUE, vertex.cex = 2.5);
#mcmc.diagnostics(model2);

model2_fomula <- formula(net ~ nodematch("white") + nodematch("male") +
                               euclidean(d=2,G=3));
model2 <- ergmm(model2_fomula,
                control=ergmm.control(burnin=100000,sample.size= 10000,interval=5));
summary(model2);
plot(model2, pie = TRUE, vertex.cex = 2.5);
#mcmc.diagnostics(model2);


