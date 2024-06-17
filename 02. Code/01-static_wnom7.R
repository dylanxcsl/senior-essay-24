# LIBRARY
# library(tidyverse)
# library(Rvoteview)
# library(wnominate)
# library(pscl)

# DATA
rolls <- read.csv("data/rcv_voteview_v3_2_91to117(1).csv") |> as_tibble()
rolls <- rolls |> filter(majortopic == 7)

# ROLLCALL OBJECT
rolls  <- as.vector(rolls$vote_id)
out    <- voteview_download(ids = rolls)
legis  <- out$legis.data |> as_tibble()
votes  <- out$votes      |> as_tibble(rownames = "icpsr")
join   <- left_join(legis, votes, by = "icpsr") |>
  select(icpsr, name, state_abbrev, starts_with("RH"))
matrix <- as.matrix(join[ , 4:1215])

rollcall <- matrix |> 
  rollcall(yea = c(1, 2, 3), nay = c(4, 5, 6), missing = c(7, 8, 9), 
           notInLegis = 0, legis.names = join$icpsr)

# IDEAL POINT ESTIMATION
rc_wnom <- rollcall |>
  wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "20100")

# DATABASE
wnom7   <- rc_wnom$legislators |>
  mutate(icpsr = rownames(rc_wnom$legislators)) |>
  mutate(wnom7 = round(coord1D, 3))

members <- read.csv("data/HSall_members.csv") |> as_tibble() |>
  filter(chamber == "House" & congress > 90 & congress < 118) |>
  select(congress, chamber, icpsr, bioname, party_code, state_abbrev, district_code) |>
  rename(name = bioname, party = party_code, state = state_abbrev, district = district_code) |>
  mutate(icpsr = as.character(icpsr),
         party = case_when(
           party == 100 ~ "D",
           party == 200 ~ "R",
           party != 100 & party != 200 ~ "I"
         ))

wnom7 <- left_join(members, wnom7, by = "icpsr") |>
  select(-starts_with(c("correct", "wrong"))) |>
  select(-c("GMP", "CC", "se1D", "coord1D"))

# JOIN IDEAL AND WNOM
dim7 <- left_join(ideal7, wnom7, by = c("congress", "chamber", "icpsr", "name", "party", "state", "district"))

# write.csv(dim7, "04. Results/stat_ideal7.csv")