## RUN CODE 0.
## Legislators mapped along NOMINATE dimension 1 and environment score
legis_dims <- ggplot(
  envscore_ind, aes(dim1, coord1D, color = as.character(party_code))
) +
  geom_point(size = 1) +
  facet_wrap(~chamber) +
  xlim(-1, 1) +
  theme(
    panel.background = element_blank(), 
    axis.line = element_line(color = "black")
  ) +
  scale_color_manual(
    name = "Party",
    labels = c("Democrat", "Republican"),
    values = c("steelblue3", "tomato1")
  ) +
  labs(
    x = "General ideology",
    y = "Environmental ideology"
  )

## RUN CODE 3. 
## Scatterplot of difference between party means
dims_diff <- ggplot(
  envscore_diff, aes(congress, difference, color = type)
) +
  geom_point() +
  geom_line() +
  facet_wrap(~chamber) +
  ylim(0, 2) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  scale_color_manual(
    name = "Measure",
    labels = c("Environmental", "General"),
    values = c("palegreen4", "gray")
  ) +
  labs(
    x = "Congress",
    y = "Difference"
  )

## RUN CODE 3.
## Scatterplot of party medians along both dimensions
dims_meds <- ggplot(
  envscore_median, aes(congress, median, color = measure, shape = party)
) +
  geom_point() +
  facet_wrap(~chamber) +
  ylim(-1, 1) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  scale_color_manual(
    name = "Measure",
    labels = c("Environmental", "General"),
    values = c("palegreen4", "gray")
  ) +
  scale_shape_manual(
    name = "Party",
    labels = c("Democrats", "Republicans"),
    values = c("square", "triangle")
  ) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")) +
  labs(
    x = "Congress",
    y = "Median"
  )

## RUN CODE 4.
## Scatterplot of votes per topic (7 or 705)
votes_freq <- ggplot(
  roll_count_vt, aes(congress, n, color = topic)
) +
  geom_point() +
  geom_line() +
  facet_wrap(~chamber, labeller = labeller(chamber = c("1" = "House", "2" = "Senate"))) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  scale_color_manual(
    name = "Vote type",
    labels = c("Environmental", "Pollution"),
    values = c("palegreen4", "darkorchid1")
  ) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  scale_y_continuous(breaks = seq(0, 150, 25)) +
  labs(
    x = "Congress",
    y = "Votes"
  )

## RUN CODE 4.
## Scatterplot of proportion of votes (705 to 7)
votes_prop <- ggplot(
  roll_count_hz, aes(congress, prop)
) +
  geom_point(color = "darkorchid1") +
  geom_line(color = "darkorchid1") +
  facet_wrap(~chamber, labeller = labeller(chamber = c("1" = "House", "2" = "Senate"))) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  labs(
    x = "Congress",
    y = "Proportion (%)"
  )