# Legislators mapped along NOMINATE dimension 1 and environment score
legis_dims <- ggplot(
  envscore_ind, aes(dim1, coord1D, color = as.character(party_code))
) +
  geom_point(size = 1) +
  facet_wrap(~chamber) +
  xlim(-1, 1) +
  theme(
    panel.background = element_blank(), 
    axis.line = element_line(color = "black"),
    axis.title = element_blank(),
    legend.title = element_blank()
  ) +
  scale_color_manual(
    labels = c("Democrat", "Republican"),
    values = c("steelblue3", "tomato1")
  )

# Scatterplot of difference between party means
envscore_diff$type[envscore_diff$type == "env_diff"] <- "Environment"
envscore_diff$type[envscore_diff$type == "gen_diff"] <- "General"

dims_diff <- ggplot(
  envscore_diff, aes(congress, difference, shape = type, linetype = type)
) +
  geom_point(size = 1) +
  geom_line() +
  facet_wrap(~chamber) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  scale_y_continuous(breaks = seq(0, 2, 0.25)) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    axis.title = element_blank(),
    legend.title = element_blank()
  ) +
  scale_shape_manual(values = c(1, 15))

# Scatterplot of party means along both dimensions
dims_mean <- ggplot(
  envscore_mean, aes(congress, mean, color = party)
) +
  geom_point(alpha = 0) +
  geom_line(aes(linetype = envscore_median$measure), size = 1) +
  facet_wrap(~chamber) +
  scale_x_reverse(expand = c(0, 0), breaks = seq(88, 118, 2)) +
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  coord_flip() +
  scale_color_manual(
    labels = c("Democrats", "Republicans"),
    values = c("steelblue3", "tomato1")
  ) +
  scale_linetype_manual(
    labels = c("Environment", "General"),
    values = c("solid", "dotted")
  ) +
  theme(panel.background = element_blank(), 
        axis.line = element_line(color = "black"),
        axis.title = element_blank(), 
        legend.title = element_blank())

# Scatterplot of votes per topic (7 or 705)
roll_count_vt$topic[roll_count_vt$topic == "7"] <- "Environment"
roll_count_vt$topic[roll_count_vt$topic == "705"] <- "Pollution"

votes_freq <- ggplot(
  roll_count_vt, aes(congress, n, shape = topic, linetype = topic)
) +
  geom_point() +
  geom_line() +
  facet_wrap(~chamber, labeller = labeller(chamber = c("1" = "House", "2" = "Senate"))) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    legend.title = element_blank(),
    axis.title = element_blank()
  ) +
  scale_x_continuous(breaks = seq(88, 118, 4)) +
  scale_y_continuous(breaks = seq(0, 150, 25)) +
  scale_shape_manual(values = c(1, 15))

# Scatterplot of proportion of votes (705 to 7)
count_merge$chamber[count_merge$chamber == "1"] <- "House"
count_merge$chamber[count_merge$chamber == "2"] <- "Senate"

votes_prop_env <- ggplot(
  filter(count_merge, type == "env"), aes(congress, prop, shape = chamber, linetype = chamber)
) +
  geom_point(size = 2) +
  geom_line() +
  scale_y_continuous(breaks = seq(0, 80, 10), labels = scales::percent_format(scale = 1)) +
  scale_shape_manual(values = c(1, 15)) +
  scale_x_continuous(breaks = seq(88, 118, 2)) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    axis.title = element_blank(),
    legend.title = element_blank()
  )

# Scatterplot of proportion of votes (7 to all)
votes_prop_gen <- ggplot(
  filter(count_merge, type == "gen"), aes(congress, prop, shape = chamber, linetype = chamber)
) +
  geom_point(size = 2) +
  geom_line() +
  scale_y_continuous(breaks = seq(0, 10, 1), labels = scales::percent_format(scale = 1)) +
  scale_shape_manual(values = c(1, 15)) +
  scale_x_continuous(breaks = seq(88, 118, 2)) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    axis.title = element_blank(),
    legend.title = element_blank()
  )

# Scatterplot of mean vote margin per topic in Senate (7 or 705)
votes_margin
rolls_margin$topic[rolls_margin$topic == "7"] <- "Environment"
rolls_margin$topic[rolls_margin$topic == "705"] <- "Pollution"
votes_margin_sen <- ggplot(
  filter(rolls_margin, chamber == "2"), aes(congress, mean, shape = topic, linetype = topic)
) +
  geom_point(size = 1) +
  scale_shape_manual(values = c(1, 15)) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    axis.title = element_blank(),
    legend.title = element_blank()
  ) +
  scale_x_continuous(breaks = seq(88, 118, 2)) +
  scale_y_continuous(breaks = seq(-50, 100, 10)) +
  geom_hline(yintercept = 0)

# Scatterplot of mean vote margin per topic in House (7 or 705)
votes_margin_hou <- ggplot(
  filter(rolls_margin, chamber == "1"), aes(congress, mean, shape = topic, linetype = topic)
) +
  geom_point(size = 1) +
  scale_shape_manual(values = c(1, 15)) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    axis.title = element_blank(),
    legend.title = element_blank()
  ) +
  scale_x_continuous(breaks = seq(88, 118, 2)) +
  scale_y_continuous(breaks = seq(-100, 400, 50)) +
  geom_hline(yintercept = 0)

# Scatterplot of proportion of votes where 90% of each party was opposed
opps90 <- ggplot(
  pct_opps90, aes(congress, percent, shape = chamber, linetype = chamber)
) +
  geom_point(size = 2) +
  geom_line() +
  scale_shape_manual(values = c(1, 15)) +
  scale_x_continuous(breaks = seq(88, 117, 2)) +
  scale_y_continuous(breaks = seq(0, 100, 10), labels = scales::percent_format(scale = 1)) +
  theme(
    panel.background = element_blank(), 
    axis.line = element_line(color = "black"),
    legend.title = element_blank(),
    axis.title = element_blank()
  )