# NTU ECON7217
# Peer Effects from Social Networks
# March 19, 2020

install.packages("spatialreg")
install.packages("spdep")
install.packages("ade4")
install.packages("units")

set.seed(20200319)
library(spdep)
library(spatialreg)
library(igraph)
library(ade4)
load("~/Social-Network-Analysis/Script/demonstration_codes_export/dataset_network_interactions.RData")

network <- igraph::graph.adjacency(dataset_lecture3[[2]],
  mode = c("directed"), weighted = NULL, diag = FALSE
)



## convert data from edgelist to class nb

igraph2nb <- function(gr) {
  return(ade4::neig2nb(ade4::neig(edges = get.edgelist(network))))
}

networknb <- igraph2nb(network)


## randomly assign a friend for those 93 isolated(without any link).

iso <- c(
  4, 9, 26, 31, 33, 34, 36, 49, 54, 61, 62, 69, 73, 75, 77, 81, 83, 84, 88, 89, 95, 96, 100,
  103, 108, 111, 114, 117, 118, 126, 128, 131, 132, 135, 137, 138, 141, 142, 151, 153,
  158, 159, 169, 170, 171, 175, 178, 181, 182, 184, 193, 198, 200, 203, 209, 213, 219,
  221, 223, 231, 242, 244, 246, 248, 249, 251, 252, 253, 255, 257, 259, 267, 269, 272,
  274, 275, 277, 280, 284, 285, 286, 289, 292, 293, 296, 297, 301, 309, 315, 317, 318,
  330, 334
)

for (i in 1:93) {
  networknb[[iso[i]]] <- sample(1:336, 1)
}

# B is the basic binary coding,
# W is row standardised (sums over all links to n),
# C is globally standardised (sums over all links to n),
# U is equal to C divided by the number of neighbours (sums over all links to unity), while S is the variance-stabilizing coding scheme proposed by Tiefelsdorf et al. 1999, p. 167-168 (sums over all links to n).

lw <- spdep::nb2listw(networknb, glist = NULL, style = "W", zero.policy = T)


variable <- data.frame()
variable <- rbind(variable, dataset_lecture3[[1]])
colnames(variable) <- c(
  "gpa", "smoke_freq", "drink", "club", "exer",
  "male", "black", "hisp", "asian", "race_other",
  "both_par", "less_hs", "more_hs", "momedu_miss",
  "Prof", "Home", "job_other"
)


model1 <- lm(gpa ~ male + black + hisp + asian + race_other
  + both_par + less_hs + more_hs
  + momedu_miss + Prof + Home + job_other,
data = variable
)

summary(model1)


model2 <- lagsarlm(gpa ~ male + black + hisp + asian + race_other
  + both_par + less_hs + more_hs
  + momedu_miss + Prof + Home + job_other,
data = variable, listw = lw, method = "eigen",
quiet = FALSE, zero.policy = TRUE, tol.solve = 1e-13,
type = "lag"
)

summary(model2)
