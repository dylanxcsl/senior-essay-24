#  CALCULATE ENVSCORE (BY UNIQUE LEGISLATOR)

# STEP 1. Create a vector of votes
# House
h.votes7 <- filter(votes_vector, str_detect(votes, "RH"))
h.votes7 <- as.vector(h.votes7$votes)
# Senate
s.votes7 <- filter(votes_vector, str_detect(votes, "RS"))
s.votes7 <- as.vector(s.votes7$votes)

# STEP 2. Create a table of legislators' votes
# House
h.out         <- voteview_download(ids = h.votes7)
h.legis       <- h.out$legis.data |> as_tibble()
h.votes       <- h.out$votes |> as_tibble(rownames = "icpsr")
h.legis_votes <- left_join(h.legis, h.votes, by = "icpsr") |>
  select(icpsr, name, state_abbrev, starts_with("RH"))
h.matrix <- as.matrix(h.legis_votes[ , 4:1238])
# Senate
s.out         <- voteview_download(ids = s.votes7)
s.legis       <- s.out$legis.data |> as_tibble()
s.votes       <- s.out$votes |> as_tibble(rownames = "icpsr")
s.legis_votes <- left_join(s.legis, s.votes, by = "icpsr") |>
  select(icpsr, name, state_abbrev, starts_with("RS"))
s.matrix <- as.matrix(s.legis_votes[ , 4:464])

# STEP 3. Construct environmental score estimate
# House
h.rollcall <- rollcall(h.matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                       missing = c(7, 8, 9), notInLegis = 0,
                       legis.names = h.legis_votes$icpsr,
                       desc = "7-coded votes",
                       source = "www.voteview.com")
set.seed(337) # run simultaneously with h.nominate
h.nominate <- wnominate(rcObject = h.rollcall, dims = 1, minvotes = 20, polarity = "20100")
# Senate
s.rollcall <- rollcall(s.matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                       missing = c(7, 8, 9), notInLegis = 0,
                       legis.names = s.legis_votes$icpsr,
                       desc = "7-coded votes",
                       source = "www.voteview.com")
set.seed(337) # run simultaneously with s.nominate
s.nominate <- wnominate(rcObject = s.rollcall, dims = 1, minvotes = 20, polarity = "20100")

# STEP 4. Create a table of legislators' environmental score
# House
h.nominate_legis <- h.nominate$legislators |> as_tibble(rownames = "icpsr")
h.envscore       <- left_join(h.legis, h.nominate_legis, by = "icpsr") |>
  mutate(chamber = "House")
# Senate
s.nominate_legis <- s.nominate$legislators |> as_tibble(rownames = "icpsr")
s.envscore       <- left_join(s.legis, s.nominate_legis, by = "icpsr") |>
  mutate(chamber = "Senate")
# Congress
envscore_ind     <- rbind(h.envscore, s.envscore) |>
  select(icpsr, name, party_code, chamber, 
         state_abbrev, dim1, dim2, coord1D, 
         correctYea, wrongYea, correctNay, wrongNay)

# Save data
write.csv(envscore_ind, "data/envscore_ind.csv")