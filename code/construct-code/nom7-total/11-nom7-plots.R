# Merge data
vview.final  <- rbind(h_vview.final.clean, s_vview.final.clean)
vview.unique <- rbind(h_legis.cong.clean, s_legis.cong.clean)
vview.median <- rbind(h_legis.cong.med, s_legis.cong.med)

vview.long <- vview.median |>   pivot_longer(
  cols = starts_with("median"), 
  names_to = "type", 
  values_to = "median"
)

# Create a scatterplot of dim1 against nom7
scatter_legis <- ggplot(
  filter(vview.final, party_code == 100 | party_code == 200), 
  aes(dim1, coord1D, color = party_code)
) +
  xlim(-1, 1) +
  scale_color_manual(
    name = "Legislator party",
    labels = c("Democrat", "Republican"),
    values = c("steelblue3", "tomato1")
  ) +
  labs(
    title = "Legislators along NOMINATE dimension 1 and constructed NOMINATE dimension",
    x = "NOMINATE Dimension 1",
    y = "Constructed NOMINATE dimension"
  ) +
  geom_point() +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  facet_wrap(~chamber)

# Create a boxplot of dim1 against nom7
boxplot_legis <- ggplot(
  filter(vview.final, party_code == 100 | party_code == 200), 
  aes(dim1, coord1D, fill = party_code)
) +
  xlim(-1, 1) +
  scale_fill_manual(
    name = "Party",
    labels = c("Democrats", "Republicans"),
    values = c("steelblue3", "tomato1")
  ) +
  labs(
    title = "Parties along NOMINATE dimension 1 and constructed NOMINATE dimension",
    x = "NOMINATE Dimension 1",
    y = "Constructed NOMINATE dimension"
  ) +
  geom_boxplot() +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  facet_wrap(~chamber)

# Create a scatterplot of party nom7 median per Congress
scatter_median.nom7 <- ggplot(
  filter(vview.median, party_code == 100 | party_code == 200), 
  aes(congress, median_coord1D, color = party_code)
) +
  ylim(-1, 1) +
  scale_color_manual(
    name = "Party",
    labels = c("Democrats", "Republicans"),
    values = c("steelblue3", "tomato1")
  ) +
  labs(
    x = "Congress",
    y = "Median of constructed NOMINATE dimension",
    title = "Polarization on the environment in Congress"
  ) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  geom_point() +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  facet_wrap(~chamber)

#
scatter_median.all <- ggplot(
  filter(vview.long, party_code == 100 | party_code == 200), 
  aes(congress, median, color = type, shape = party_code)
) +
  ylim(-1, 1) +
  scale_color_manual(
    name = "Dimension",
    labels = c("Nominate 7", "Dimension 1"),
    values = c("palegreen4", "gray")
  ) +
  scale_shape_manual(
    name = "Party",
    labels = c("Democrats", "Republicans"),
    values = c("circle", "square"),
  ) +
  labs(
    x = "Congress",
    y = "Median of constructed NOMINATE dimension",
    title = "Polarization on the environment in Congress"
  ) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  geom_point() +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  facet_wrap(~chamber)