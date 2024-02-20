# Load libraries
library(tidyverse)
library(Rvoteview)
library(wnominate)

# Load data
votes_vector <- read_csv("data/votes_vector.csv")
legis_all    <- read_csv("data/HSall_votes.csv")
envscore_ind <- read_csv("data/envscore_ind.csv") |> 
  select(-...1) |> drop_na(dim1, coord1D) |> filter(party_code == 100 | party_code == 200)
envscore_all <- read_csv("data/envscore_all.csv") |> 
  drop_na(dim1, coord1D) |> filter(party_code == 100 | party_code == 200)
rollcalls <- read_csv("data/rcv_voteview_v3_2.csv") |>
  filter(congress > 87 & pap_majortopic == 7)
rollcalls$chamber[rollcalls$chamber == 'Senate'] <- '2'
rollcalls$chamber[rollcalls$chamber == 'House']  <- '1'

# Load visuals
legis_dims
dims_diff
dims_meds
votes_freq
votes_prop