install.packages("igraph")
library(igraph)
setwd("C:/Users/ssunr/Dropbox/teaching_NTU/Econ7217/code")

# reference
# https://rstudio-pubs-static.s3.amazonaws.com/74248_3bd99f966ed94a91b36d39d8f21e3dc3.html
# http://www.mjdenny.com/Preparing_Network_Data_In_R.html
# https://rdatamining.wordpress.com/2012/05/17/an-example-of-social-network-analysis-with-r-using-package-igraph/


# Example 1. 

W=matrix( c(0,1,0,0,0,1,0,1,1,0,0,1,0,1,0,0,0,1,0,0,1,1,0,0,0), nrow=5, ncol=5)
g <- graph.adjacency(W)
plot.igraph(g)

# Example 2. 

dat=read.csv("sample_adjmatrix.csv",header=TRUE,row.names=1,check.names=FALSE) # choose an adjacency matrix from a .csv file
m=as.matrix(dat) # coerces the data set as a matrix
g=graph.adjacency(m,mode="undirected",weighted=NULL) # this will create an 'igraph object'
plot.igraph(g)


W2=W%*%W        # W2 shows the number of walks between every 2 nodes with 2 steps # 
W3=W%*%W%*%W    # W3 shows the number of walks between every 2 nodes with 3 steps # 

deg <- degree(g, mode = "out")
bet <- betweenness(g, directed = TRUE)
clo <- closeness(g, mode = "out")

# Calculate the average path length of the network 
average.path.length(g, directed=TRUE, unconnected=TRUE)

# Calculate the assortativity coefficient
assortativity_degree(g, directed = TRUE)

# Calculate the diameter of the network 
diameter(g, directed = TRUE, unconnected = TRUE, weights = NULL)


 