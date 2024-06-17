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
rc_ideal <- ideal(rollcall, d = 1,
                  maxiter = 30000, thin = 30, burnin = 3000,
                  impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)

# DATABASE
ideal7 <- rc_ideal$xbar
ideal7 <- data.frame(rownames(ideal7), ideal7) |>
  rename(icpsr = 1, ideal7 = 2) |>
  mutate(ideal7 = round(ideal7 * -1, 3))

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

ideal7 <- left_join(members, ideal7, by = "icpsr")

# JOIN IDEAL AND WNOM
dim7 <- left_join(ideal7, wnom7, by = c("congress", "chamber", "icpsr", "name", "party", "state", "district"))

# write.csv(dim7, "03. Results/dim7.csv")