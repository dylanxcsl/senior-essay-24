#  CALCULATE ENVSCORE (MEAN AND MEDIAN)

## STEP 1. Create a table of the party means
envscore_count.mean <- envscore_all |>
  group_by(chamber) |> count(congress) |> select(congress, n, chamber)
envscore_estim.mean <- envscore_all |>
  group_by(congress, party_code, chamber) |>
  summarise_at(vars(coord1D, dim1), list(mean = mean)) |>
  pivot_wider(names_from = party_code, values_from = c(coord1D_mean, dim1_mean))
envscore_mean <- left_join(envscore_count.mean, envscore_estim.mean, by = c("congress", "chamber"))
## write.csv(envscore_mean, "data/envscore_mean.csv")

## STEP 2. Calculate difference between party means
envscore_mean <- envscore_mean |>
  mutate(
    env_diff = abs(coord1D_mean_100 - coord1D_mean_200),
    gen_diff = abs(dim1_mean_100 - dim1_mean_200))
envscore_diff <- envscore_mean |>
  pivot_longer(
    cols = env_diff:gen_diff,
    names_to = "type",
    values_to = "difference"
  ) |>
  select(congress, chamber, type, difference)

## STEP 3. Create a table of the party medians
envscore_count.medi <- envscore_all |>
  group_by(chamber) |> count(congress) |> select(congress, n, chamber)
envscore_estim.medi <- envscore_all |>
  group_by(congress, party_code, chamber) |>
  summarise_at(vars(coord1D, dim1), list(median = median)) |>
  pivot_wider(names_from = party_code, values_from = c(coord1D_median, dim1_median))
envscore_median <- left_join(envscore_count.medi, envscore_estim.medi, by = c("congress", "chamber"))
## write.csv(envscore_median, "data/envscore_median.csv")

## STEP 4. Reformat table of party medians in vertical format
envscore_median <- envscore_median |>
  pivot_longer(
    cols = contains("median"),
    names_to = "type",
    values_to = "median") |>
  mutate(measure = case_when(
    type == c("coord1D_median_100", "coord1D_median_200") ~ "coord1D",
    type == c("dim1_median_100", "dim1_median_200") ~ "dim1")) |>
  mutate(party = case_when(
    type == "coord1D_median_100" ~ "100",
    type == "coord1D_median_200" ~ "200",
    type == "dim1_median_100" ~ "100",
    type == "dim1_median_200" ~ "200"))