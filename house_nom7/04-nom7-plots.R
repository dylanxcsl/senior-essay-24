# Create a scatterplot of dim1 against nom7
scatter_legis <- ggplot(
  filter(h_vview.final.clean, party_code == 100 | party_code == 200), 
  aes(dim1, coord1D, color = party_code)
) +
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
  )

# Create a boxplot of dim1 against nom7
boxplot_legis <- ggplot(
  filter(h_vview.final.clean, party_code == 100 | party_code == 200), 
  aes(dim1, coord1D, fill = party_code)
) +
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
  )

# Create a scatterplot of party nom7 median per Congress
scatter_median <- ggplot(
  filter(h_legis.cong.med, party_code == 100 | party_code == 200), 
  aes(congress, median, color = party_code)
) +
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
  scale_x_continuous(breaks = seq(88, 118, 2)) +
  geom_point() +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  )