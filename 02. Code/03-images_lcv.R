# LIBRARY
# library(tidyverse)

# DATA
env <- read.csv("04. Results/dim7.csv") |> as_tibble()

# POLARIZATION (PARTY MEDIANS)  
env |>
  select(congress, party, ends_with("lcv")) |>
  pivot_longer(3:4) |>
  filter(party %in% c("D", "R")) |>
  drop_na(value) |>
  group_by(congress, party, name) |>
  summarize(median = median(value)) |>
  pivot_wider(names_from = party, values_from = median) |>
  mutate(diff = abs(D - R)) |>
  mutate(name = case_when(
    name == "adjusted_lcv" ~ 2,
    name == "pooled_lcv" ~ 1
    )) |>
  ggplot(aes(congress, diff, color = as.character(name))) +
  geom_line() +
  geom_point(alpha = 0.5) +
  theme_bw() +
  scale_color_manual(name = "LCV",
                     labels = c("Unadjusted",
                                "GLS-Adjusted"),
                     values = c("grey60", "palegreen4")) +
  labs(x = "Congress", y = "Divergence of Party Medians") +
  scale_x_continuous(breaks = seq(92, 116, 4)) +
  geom_vline(xintercept = 104)

# ggsave("party_lcvmedians.png", width = 8, height = 5)

# POLARIZATION (10-90 PERCENTILES)
env |>
  select(congress, party, ends_with("lcv")) |>
  pivot_longer(3:4) |>
  filter(party %in% c("D", "R")) |>
  drop_na(value) |>
  group_by(congress, party, name) |>
  summarise(x = quantile(value, c(0.1, 0.9)), q = c(0.1, 0.9)) |>
  mutate(name = case_when(
    name == "adjusted_lcv" ~ 2,
    name == "pooled_lcv" ~ 1
  )) |>
  ggplot(aes(congress, x, color = interaction(as.character(name), q, party))) +
  geom_line() +
  facet_wrap(~ name, labeller = labeller(name = c("1" = "Unadjusted LCV",
                                                  "2" = "Adjusted LCV"))) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("steelblue1",
                                "steelblue1",
                                "steelblue4",
                                "steelblue4",
                                "firebrick4",
                                "firebrick4",
                                "firebrick1",
                                "firebrick1")) +
  labs(x = "Congress", y = "Divergence of Party Medians") +
  scale_x_continuous(breaks = seq(92, 116, 4)) +
  geom_smooth(method = "lm", lty = "dashed", se = FALSE, size = 0.5) +
  geom_vline(xintercept = 104)

# ggsave("party_lcv10-90.png", width = 8, height = 3)

# DISTRIBUTIONS
env |>
  select(congress, party, pooled_lcv) |>
  drop_na(pooled_lcv) |>
  filter(congress > 91 & congress < 116) |>
  ggplot(aes(pooled_lcv)) +
  geom_density() +
  facet_wrap(~ congress, ncol = 4) +
  theme_bw() +
  theme(panel.grid = element_blank()) +
  labs(x = "Pooled LCV", y = "Density")
# ggsave("distribution_pooledlcv.png", width = 8, height = 10)

env |>
  select(congress, party, adjusted_lcv) |>
  drop_na(adjusted_lcv) |>
  filter(congress > 91 & congress < 117) |>
  ggplot(aes(adjusted_lcv)) +
  geom_density() +
  facet_wrap(~ congress, ncol = 4) +
  theme_bw() +
  theme(panel.grid = element_blank()) +
  labs(x = "Adjusted LCV", y = "Density")
# ggsave("distribution_adjustedlcv.png", width = 8, height = 10)
