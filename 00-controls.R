# Load libraries
library(tidyverse)
library(Rvoteview)
library(wnominate)

# Dataframes
View(h_tab.fin)           ## Table with every 7-coded vote taken by a legislator 
View(h_vview.final.clean) ## Table with constructed nom7 score for every legislator (tenure not included)
View(h_legis.cong.clean)  ## Table with constructed nom7 score for every legislator (tenure included)
View(h_legis.cong.med)    ## Median of constructed nom7 score for each party per Congress

# Visualizations
scatter_legis  ## Scatterplot of all legislators (x = dim1, y = nom7)
boxplot_legis  ## Boxplot of all legislators (x = dim1, y = nom7)
scatter_median ## Scatterplot of party nom7 median (x = cong, y = nom7)