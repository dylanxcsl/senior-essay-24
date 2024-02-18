# Load libraries
library(tidyverse)
library(Rvoteview)
library(wnominate)

# Dataframes
View(s_tab.fin)           ## Table with every 7-coded vote taken by a legislator 
View(s_vview.final.clean) ## Table with constructed nom7 score for every legislator (tenure not included)
View(s_legis.cong.clean)  ## Table with constructed nom7 score for every legislator (tenure included)
View(s_legis.cong.med)    ## Median of constructed nom7 score for each party per Congress

# Visualizations
scatter_legis.s  ## Scatterplot of all legislators (x = dim1, y = nom7)
boxplot_legis.s  ## Boxplot of all legislators (x = dim1, y = nom7)
scatter_median.s ## Scatterplot of party nom7 median (x = cong, y = nom7)

ggsave("s.scatter_median.png")
