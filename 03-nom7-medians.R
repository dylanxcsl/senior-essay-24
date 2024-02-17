# Load data
h_legis.all <- read_csv("data/Hall_votes.csv")

# Create a table of all legislators per Congress
h_legis.filt <- h_legis.all |> filter(congress > 87 & congress < 118)
h_legis.uniq <- unique(h_legis.filt[c("icpsr", "congress")])

# Create a table of all legislators per Congress with nom7 score
h_legis.uniq$icpsr <- as.character(h_legis.uniq$icpsr)
h_legis.cong <- left_join(h_legis.uniq, h_vview.final.clean, by = "icpsr")
h_legis.cong.clean <- h_legis.cong |> drop_na(coord1D)

# Create a table of the party nom7 median per Congress
h_legis.cong.med <- h_legis.cong.clean |>
  group_by(congress, party_code) |>
  summarise_at(vars(coord1D), list(median = median))
