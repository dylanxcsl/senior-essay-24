# Load data
h_legis.all <- read_csv("data/construct-data/Hall_votes.csv") # Download from Voteview.com

# Create a table of all legislators per Congress
h_legis.filt <- h_legis.all |> filter(congress > 87 & congress < 118)
h_legis.uniq <- unique(h_legis.filt[c("icpsr", "congress")])

# Create a table of all legislators per Congress with nom7 score
h_legis.uniq$icpsr <- as.character(h_legis.uniq$icpsr)
h_legis.cong <- left_join(h_legis.uniq, h_vview.final.clean, by = "icpsr")
h_legis.cong.clean <- h_legis.cong |> drop_na(coord1D) |>
  mutate(chamber = "House")

# Create a table of the party nom7 median per Congress
h_legis.cong.med <- h_legis.cong.clean |>
  group_by(congress, party_code) |>
  summarise_at(vars(coord1D, dim1), list(median = median)) |>
  mutate(chamber = "House")

h_legis.cong.med <- rename(h_legis.cong.med, 
                           median_coord1D = coord1D_median, 
                           median_dim1 = dim1_median)