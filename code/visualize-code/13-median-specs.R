# Create House table of medians
h_count <- voview_all.csv |>
  filter(chamber == "House") |>
  count(congress)
h_med1 <- median.csv |>
  filter(type == "median_coord1D" & party_code == 100 & chamber == "House") |>
  select(congress, median)
h_med2 <- median.csv |>
  filter(type == "median_coord1D" & party_code == 200 & chamber == "House") |>
  select(congress, median)
h_med3 <- median.csv |>
  filter(type == "median_dim1" & party_code == 100 & chamber == "House") |>
  select(congress, median)
h_med4 <- median.csv |>
  filter(type == "median_dim1" & party_code == 200 & chamber == "House") |>
  select(congress, median)
merge1 <- merge(h_med1, h_med2, by = "congress")
merge2 <- merge(h_med3, h_med4, by = "congress")
merge3 <- merge(merge1, merge2, by = "congress")

h_merge <- left_join(h_count, merge3, by = "congress")
h_merge <- h_merge |>
  rename(env_dems  = median.x.x, env_reps  = median.y.x, dim1_dems = median.x.y, dim1_reps = median.y.y)
h_merge$env_dems <- round(h_merge$env_dems, digits = 3)
h_merge$env_reps <- round(h_merge$env_reps, digits = 3)
h_merge$dim1_dems <- round(h_merge$dim1_dems, digits = 3)
h_merge$dim1_reps <- round(h_merge$dim1_reps, digits = 3)

# Create a Senate table of medians
s_count <- voview_all.csv |>
  filter(chamber == "Senate") |>
  count(congress)
s_med1 <- median.csv |>
  filter(type == "median_coord1D" & party_code == 100 & chamber == "Senate") |>
  select(congress, median)
s_med2 <- median.csv |>
  filter(type == "median_coord1D" & party_code == 200 & chamber == "Senate") |>
  select(congress, median)
s_med3 <- median.csv |>
  filter(type == "median_dim1" & party_code == 100 & chamber == "Senate") |>
  select(congress, median)
s_med4 <- median.csv |>
  filter(type == "median_dim1" & party_code == 200 & chamber == "Senate") |>
  select(congress, median)
merge4 <- merge(s_med1, s_med2, by = "congress")
merge5 <- merge(s_med3, s_med4, by = "congress")
merge6 <- merge(merge4, merge5, by = "congress")
s_merge <- left_join(s_count, merge6, by = "congress")
s_merge <- s_merge |>
  rename(env_dems  = median.x.x, env_reps  = median.y.x, dim1_dems = median.x.y, dim1_reps = median.y.y)
s_merge$env_dems <- round(s_merge$env_dems, digits = 3)
s_merge$env_reps <- round(s_merge$env_reps, digits = 3)
s_merge$dim1_dems <- round(s_merge$dim1_dems, digits = 3)
s_merge$dim1_reps <- round(s_merge$dim1_reps, digits = 3)