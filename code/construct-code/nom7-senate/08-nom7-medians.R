# Load data
s_legis.all <- read_csv("data/construct-data/Sall_votes.csv") # Download from Voteview.com

# Create a table of all legislators per Congress
s_legis.filt <- s_legis.all |> filter(congress > 87 & congress < 118)
s_legis.uniq <- unique(s_legis.filt[c("icpsr", "congress")])

# Create a table of all legislators per Congress with nom7 score
s_legis.uniq$icpsr <- as.character(s_legis.uniq$icpsr)
s_legis.cong <- left_join(s_legis.uniq, s_vview.final.clean, by = "icpsr")
s_legis.cong.clean <- s_legis.cong |> drop_na(coord1D) |>
  mutate(chamber = "Senate")

# Create a table of the party nom7 median per Congress
s_legis.cong.med <- s_legis.cong.clean |>
  group_by(congress, party_code) |>
  summarise_at(vars(coord1D, dim1), list(median = median)) |>
  mutate(chamber = "Senate")

s_legis.cong.med <- rename(s_legis.cong.med, 
                           median_coord1D = coord1D_median, 
                           median_dim1 = dim1_median)