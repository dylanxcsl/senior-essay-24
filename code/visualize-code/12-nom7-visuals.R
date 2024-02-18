# Load libraries
library(tidyverse)
library(Rvoteview)
library(wnominate)

# Load dataframes
voview_uni.csv <- read_csv("data/visualize-data/voview_unique.csv")
voview_all.csv <- read_csv("data/visualize-data/voview_tenure.csv")
median.csv     <- read_csv("data/visualize-data/median.csv")

# Scatterplot of all legislators
scatter.legis <- ggplot(
  filter(voview_uni.csv, party_code == 100 | party_code == 200),
  aes(dim1, coord1D, color = as.character(party_code))
) +
  geom_point() +
  facet_wrap(~chamber) +
  xlim(-1, 1) +
  scale_color_manual(
    name   = "Legislator party",
    labels = c("Democrat", "Republican"),
    values = c("steelblue3", "tomato1")
  ) +
  labs(
    x = "NOMINATE dimension 1",
    y = "Environmental score",
    title = "Legislators across dimension 1 and environmental score"
  ) +
  theme(
    panel.background = element_blank(), 
    axis.line = element_line(color = "black")
  )

# Boxplot of all legislators
boxplot.legis <- ggplot(
  filter(voview_uni.csv, party_code == 100 | party_code == 200),
  aes(dim1, coord1D, color = as.character(party_code))
) +
  geom_boxplot() +
  facet_wrap(~chamber) +
  xlim(-1, 1) +
  scale_color_manual(
    name   = "Legislator party",
    labels = c("Democrat", "Republican"),
    values = c("steelblue3", "tomato1")
  ) +
  labs(
    x = "NOMINATE dimension 1",
    y = "Environmental score",
    title = "Legislators across dimension 1 and environmental score"
  ) +
  theme(
    panel.background = element_blank(), 
    axis.line = element_line(color = "black")
  )

# Scatterplot of party median
median.party <- ggplot(
  filter(median.csv, party_code == 100 | party_code == 200),
  aes(congress, median, color = type, shape = as.character(party_code))
) +
  geom_point() +
  facet_wrap(~chamber) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  ylim(-1, 1) +
  scale_color_manual(
    name   = "NOMINATE",
    labels = c("Environmental", "Dimension 1"),
    values = c("palegreen4", "gray")
  ) +
  scale_shape_manual(
    name = "Party",
    labels = c("Democrats", "Republicans"),
    values = c("circle", "square"),
  ) +
  labs(
    x = "Congress",
    y = "Party median",
    title = "Polarization on dimension 1 and environmental score"
  ) +
  theme(
    panel.background = element_blank(), 
    axis.line = element_line(color = "black")
  )

# Download visuals (ggsave())
scatter.legis
boxplot.legis
median.party