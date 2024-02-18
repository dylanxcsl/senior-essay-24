# Load libraries
library(tidyverse)
library(Rvoteview)
library(wnominate)

# Create dataframes
voview <- rbind(h_vview.final.clean, s_vview.final.clean)
median <- rbind(h_legis.cong.med, s_legis.cong.med)
median <- median |> pivot_longer(
  cols      = starts_with("median"), 
  names_to  = "type", 
  values_to = "median"
)

# Dataframes
View(vview.final)     ## Table with constructed nom7 score for every legislator (tenure not included)
View(vview.unique)    ## Table with constructed nom7 score for every legislator (tenure included)
View(vview.median)    ## Median of constructed nom7 score for each party per Congress
View(vview.long)      ## Median of constructed nom7 & dim 1 scores for each party per Congress

# Visualizations
scatter_legis       ## Scatterplot of all legislators (x = dim1, y = nom7)
boxplot_legis       ## Boxplot of all legislators (x = dim1, y = nom7)
scatter_median.nom7 ## Scatterplot of party nom7 median (x = cong, y = nom7)
scatter_median.all  ## Scatterplot of party nom7 median & dim 1 median