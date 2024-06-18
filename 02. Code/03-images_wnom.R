# LIBRARY
# library(tidyverse)

# DATA
env <- read.csv("04. Results/dim7.csv") |> as_tibble()

# POLARIZATION (PARTY MEDIANS)  
env |>
  select(congress, party, ends_with("w7")) |>
  pivot_longer(3:5) |>
  filter(party %in% c("D", "R")) |>
  drop_na(value) |>
  group_by(congress, party, name) |>
  summarize(median = median(value)) |>
  pivot_wider(names_from = party, values_from = median) |>
  mutate(diff = abs(D - R)) |>
  mutate(name = case_when(
    name == "adjusted_w7" ~ 3,
    name == "unadjusted_w7" ~ 2,
    name == "static_w7" ~ 1
  )) |>
  ggplot(aes(congress, diff, color = as.character(name))) +
  geom_line() +
  geom_point(alpha = 0.5) +
  theme_bw() +
  scale_color_manual(name = "WNOMINATE",
                     labels = c("Static",
                                "Unadjusted",
                                "GLS-Adjusted"),
                     values = c("darkseagreen2", "grey60", "palegreen4")) +
  labs(x = "Congress", y = "Divergence of Party Medians") +
  scale_x_continuous(breaks = seq(92, 116, 4)) +
  geom_vline(xintercept = 104)
  
# ggsave("party_medians.png", width = 8, height = 5)

# POLARIZATION (10-90 PERCENTILES)
env |>
  select(congress, party, ends_with("w7")) |>
  pivot_longer(3:5) |>
  filter(party %in% c("D", "R")) |>
  drop_na(value) |>
  group_by(congress, party, name) |>
  summarise(x = quantile(value, c(0.1, 0.9)), q = c(0.1, 0.9)) |>
  mutate(name = case_when(
    name == "adjusted_w7" ~ 2,
    name == "unadjusted_w7" ~ 3,
    name == "static_w7" ~ 1
  )) |>
  ggplot(aes(congress, x, color = interaction(as.character(name), q, party))) +
  geom_line() +
  facet_wrap(~ name, labeller = labeller(name = c("1" = "Static WNOMINATE",
                                                  "2" = "Adjusted WNOMINATE",
                                                  "3" = "Unadjusted WNOMINATE"))) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("firebrick4",
                                "firebrick4",
                                "firebrick4",
                                "firebrick1",
                                "firebrick1",
                                "firebrick1",
                                "steelblue1",
                                "steelblue1",
                                "steelblue1",
                                "steelblue4",
                                "steelblue4",
                                "steelblue4")) +
  labs(x = "Congress", y = "Divergence of Party Medians") +
  scale_x_continuous(breaks = seq(92, 116, 4)) +
  scale_y_continuous(limits = c(-2, 2)) +
  geom_smooth(method = "lm", lty = "dashed", se = FALSE, size = 0.5) +
  geom_vline(xintercept = 104)

# ggsave("party_10-90.png", width = 8, height = 3)

# DISTRIBUTIONS
env |>
  select(congress, party, static_w7) |>
  drop_na(static_w7) |>
  filter(congress > 91 & congress < 117) |>
  ggplot(aes(static_w7)) +
  geom_density() +
  facet_wrap(~ congress) +
  theme_bw() +
  theme(panel.grid = element_blank()) +
  labs(x = "Static WNOMINATE", y = "Density")
# ggsave("distribution_staticW7.png", width = 8, height = 6)

env |>
  select(congress, party, unadjusted_w7) |>
  drop_na(unadjusted_w7) |>
  filter(congress > 91 & congress < 117) |>
  ggplot(aes(unadjusted_w7)) +
  geom_density() +
  facet_wrap(~ congress) +
  theme_bw() +
  theme(panel.grid = element_blank()) +
  labs(x = "Unadjusted WNOMINATE", y = "Density")
# ggsave("distribution_unadjustedW7.png", width = 8, height = 6)

env |>
  select(congress, party, adjusted_w7) |>
  drop_na(adjusted_w7) |>
  filter(congress > 91 & congress < 117) |>
  ggplot(aes(adjusted_w7)) +
  geom_density() +
  facet_wrap(~ congress) +
  theme_bw() +
  theme(panel.grid = element_blank()) +
  labs(x = "Adjusted WNOMINATE", y = "Density")
# ggsave("distribution_adjustedW7.png", width = 8, height = 6)