# Load libraries
library(tidyverse)
library(Rvoteview)
library(wnominate)

# Dataframes
View(vview.final)     ## Table with constructed nom7 score for every legislator (tenure not included)
View(vview.unique)    ## Table with constructed nom7 score for every legislator (tenure included)
View(vview.median)    ## Median of constructed nom7 score for each party per Congress

# Visualizations
scatter_legis  ## Scatterplot of all legislators (x = dim1, y = nom7)
boxplot_legis  ## Boxplot of all legislators (x = dim1, y = nom7)
scatter_median ## Scatterplot of party nom7 median (x = cong, y = nom7)