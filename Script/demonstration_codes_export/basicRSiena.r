################################################################################
###                                                                          ###
### ---- basicRSiena.r: a basic script for the introduction to RSiena ------ ###
###                                                                          ###
###                               version: May 19, 2015                       ###
################################################################################

# An example of a basic sequence of commands
# for estimating a basic model by function siena07() of RSiena.
# With a lot of use of help pages; this can be skipped as you like.
# Note that lines starting with # are comment lines, not commands.

# What is your current working directory?
getwd()
# If you wish it to be different, change it by
setwd()
# In my case:
setwd("C:\\Users\\tom.snijders\\Documents\\Siena\\s50_script")
# Note the double backslashes used for R.

# If you have not yet installed RSiena, do this preferably from R-Forge;
# this can be done by (for Windows) downloading the .zip file from
# http://r-forge.r-project.org/R/?group_id=461
# or (for Mac) the .tgz file from
# http://www.stats.ox.ac.uk/~snijders/siena/siena_downloads.htm
# and then in R installing from the local zip or tgz file.
# Or you can use
# install.packages("RSiena", repos="http://R-Forge.R-project.org")
# and for the RSienaTest package by
# install.packages("RSienaTest", repos="http://R-Forge.R-project.org")
# The R-Forge version usually is more up to date than the version
# available from CRAN, the general R archive.
# RSienaTest is not available from CRAN.
# Note that you can also download the recent versions from the
# Siena website, http://www.stats.ox.ac.uk/~snijders/siena/siena_downloads.htm

# Define data sets

# If you have internet access, you can download the data
# from the Siena website ("Data sets" tab)
# http://www.stats.ox.ac.uk/~snijders/siena/s50_data.zip
# and unzip it in your working directory.
# The data description is at
# http://www.stats.ox.ac.uk/~snijders/siena/s50_data.htm
# Then you can read the data files by the commands
# (this can be replaced by using the internal data set, see below)
#        friend.data.w1 <- as.matrix(read.table("s50-network1.dat"))
#        friend.data.w2 <- as.matrix(read.table("s50-network2.dat"))
#        friend.data.w3 <- as.matrix(read.table("s50-network3.dat"))
#        drink <- as.matrix(read.table("s50-alcohol.dat"))
#        smoke <- as.matrix(read.table("s50-smoke.dat"))

# But without internet access, the data can be obtained
# from within RSiena (see below), because this is an internal data set.

install.packages('RSiena')
library(RSiena) # or RSienaTest
# Now we use the internally available s50 data set.
# Look at its description:
?s50
# 3 waves, 50 actors
# Look at the start and end of the first wave matrix
head(s501)
tail(s501)
# and at the alcohol variable
s50a
# Now define the objects with the same names as above
# (this step is superfluous if you read the data already).
        friend.data.w1 <- s501
        friend.data.w2 <- s502
        friend.data.w3 <- s503
        drink <- s50a
        smoke <- s50s
# s50s is only available from Siena version 1.1-278 onward
# (available from R-Forge).

# Now the data must be given the specific roles of variables
# in an RSiena analysis.
# Dependent variable
?sienaDependent
# First create a 50 * 50 * 3 array composed of the 3 adjacency matrices
friendshipData <- array( c( friend.data.w1, friend.data.w2, friend.data.w3 ),
           dim = c( 50, 50, 3 ) )
# and next give this the role of the dependent variable:
	friendship <- sienaDependent(friendshipData)

# We also must prepare the objects that will be the explanatory variables.
# Constant actor covariate; smoking for wave 1.
smoke1 <- coCovar( smoke[ , 1 ] )
# Variable actor covariate
alcohol <- varCovar( drink )

# Put the variables together in the data set for analysis
?sienaDataCreate
mydata <- sienaDataCreate( friendship, smoke1, alcohol )
# Check what we have
mydata

# You can get an outline of the data set with some basic descriptives from
print01Report( mydata, modelname="s50")
# For the model specification we need to create the effects object
myeff <- getEffects( mydata )
# All the effects that are available given the structure
# of this data set can be seen from
effectsDocumentation(myeff)
# For a precise description of all effects, see Chapter 12 in the RSiena manual.
# A basic specification of the structural effects:
?includeEffects
myeff <- includeEffects( myeff, transTrip, cycle3)
# and some covariate effects:
myeff <- includeEffects( myeff, egoX, altX, egoXaltX, interaction1 = "alcohol" )
myeff <- includeEffects( myeff, simX, interaction1 = "smoke1" )
myeff

# Create object with algorithm settings
# Accept defaults but specify name for output file
# (which you may replace by any name you prefer)
?sienaAlgorithmCreate
myalgorithm <- sienaAlgorithmCreate( projname = 's50' )

# Estimate parameters
?siena07
ans <- siena07( myalgorithm, data = mydata, effects = myeff)
ans

# For checking convergence, look at the
# 'Overall maximum convergence ratio' mentioned under the parameter estimates.
# It can also be shown by requesting
ans$tconv.max
# If this is less than 0.25, convergence is good.
# If convergence is inadequate, estimate once more,
# using the result obtained as the "previous answer"
# from which estimation continues:

ans <- siena07( myalgorithm, data = mydata, effects = myeff, prevAns=ans)
ans
# If convergence is good, you can look at the estimates.
# More extensive results
summary(ans)
# Still more extensive results are given in the output file
# s50.out in the current directory.

# Note that by putting an R command between parentheses (....),
# the result will also be printed to the screen.
# Next add the transitive reciprocated triplets effect,
# an interaction between transitive triplets and reciprocity,

(myeff <- includeEffects( myeff, transRecTrip))
(ans1 <- siena07( myalgorithm, data = mydata, effects = myeff, prevAns=ans))
# If necessary, repeat the estimation with the new result:
(ans1 <- siena07( myalgorithm, data = mydata, effects = myeff, prevAns=ans1))
# This might still not have an overall maximum convergence ratio
# less than 0.25. If not, you could go on once more;
# but convergence may be more rapid with another algorithm option
# (available since version 1.1-285):
myalgorithm1 <- sienaAlgorithmCreate( projname = 's50', doubleAveraging=0)
(ans1 <- siena07( myalgorithm1, data = mydata, effects = myeff, prevAns=ans1))

# Inspect the file s50.out in your working directory
# and understand the meaning of its contents.

################################################################################
###                Assignment 1                                              ###
################################################################################

# 1a.
# Drop the effect of smoke1 similarity and estimate the model again.
# Do this by the function setEffects() using the <<include>> parameter.
# Give the changed effects object and the new answer object new names,
# such as effects1 and ans1, to distinguish them.
# 1b.
# Change the three effects of alcohol to the single effect
# of alcohol similarity, and estimate again.

################################################################################
###                Networks and behavior study                               ###
################################################################################

# Now we redefine the role of alcohol drinking
# as a dependent behaviour variable.
# Once again, look at the help file
?sienaDependent
# now paying special attention to the <<type>> parameter.
drinking <- sienaDependent( drink, type = "behavior" )

# Put the variables together in the data set for analysis
NBdata <- sienaDataCreate( friendship, smoke1, drinking )
NBdata
NBeff <- getEffects( NBdata )
effectsDocumentation(NBeff)
NBeff <- includeEffects( NBeff, transTrip, transRecTrip )
NBeff <- includeEffects( NBeff, egoX, altX, egoXaltX,
                         interaction1 = "drinking" )
NBeff <- includeEffects( NBeff, simX, interaction1 = "smoke1" )
NBeff
# For including effects also for the dependent behaviour variable, see
?includeEffects
NBeff <- includeEffects( NBeff, avAlt, name="drinking",
                         interaction1 = "friendship" )
NBeff

# Estimate again, using the second algorithm right from the start.
NBans <- siena07( myalgorithm1, data = NBdata, effects = NBeff)
# You may improve convergence (considering the overall maximum
# convergence ratio) by repeated estimation in the same way as above.

# Look at results
NBans
# Make a nicer listing of the results
siena.table(NBans, type="html", sig=TRUE)
# This produces an html file; siena.table can also produce a LaTeX file.

################################################################################
###                Assignment 2                                              ###
################################################################################

# 2a.
# Replace the average alter effect by average similarity (avSim)
# or total similarity (totSim) and estimate the model again.
# 2b.
# Add the effect of smoking on drinking and estimate again.

################################################################################
