## POLARIZATION - PERCENTAGE OF VOTES WHERE 90% OF EACH PARTY IS OPPOSED

## STEP 1. Create a vector of votes
rollcalls <- read_csv("data/rollcalls.csv") |> filter(congress > 87)
rollcalls <- as.vector(rollcalls$voteview_id)
rollcalls <- voteview_download(ids = rollcalls)

## STEP 2. Estimate the percentage of party votes per position (Yea or Nay)
out_rolls <- rollcalls$vote.data
out_rolls <- out_rolls |>
  select(vname, chamber, congress, 
         yea_count, nay_count, starts_with("party_vote_counts."), 
         vote_result, codes.Issue)
out_rolls$vote_result[is.na(out_rolls$vote_result)] <- "NA"
out_rolls$codes.Issue[is.na(out_rolls$codes.Issue)] <- "NA"
out_rolls[is.na(out_rolls)] <- 0
out_rolls <- out_rolls |>
  mutate_at(c("party_vote_counts.200.1", "party_vote_counts.200.2", 
              "party_vote_counts.200.5", "party_vote_counts.200.6", 
              "party_vote_counts.100.1", "party_vote_counts.100.2", 
              "party_vote_counts.100.3", "party_vote_counts.100.6"), 
            as.numeric) |>
  mutate(yea_200 = party_vote_counts.200.1 + party_vote_counts.200.2) |>
  mutate(nay_200 = party_vote_counts.200.5 + party_vote_counts.200.6) |>
  mutate(yea_100 = party_vote_counts.100.1 + party_vote_counts.100.2 + party_vote_counts.100.3) |>
  mutate(nay_100 = party_vote_counts.100.6) |>
  mutate(votes_200 = yea_200 + nay_200) |>
  mutate(votes_100 = yea_100 + nay_100) |>
  mutate(pct_yea_200 = yea_200 / votes_200 * 100) |>
  mutate(pct_nay_200 = nay_200 / votes_200 * 100) |>
  mutate(pct_yea_100 = yea_100 / votes_100 * 100) |>
  mutate(pct_nay_100 = nay_100 / votes_100 * 100)
out_rolls <- out_rolls |> 
  select(vname, chamber, congress, starts_with("pct_"), vote_result, codes.Issue)

## STEP 3. Estimate the proportion of votes where 90% of each party is opposed
out_rolls_opp90 <- out_rolls |>
  filter(pct_yea_200 >= 90 & pct_nay_100 >= 90 | pct_yea_100 >= 90 & pct_nay_200 >= 90 )
count_opp90 <- count(out_rolls_opp90, congress, chamber)
count_rolls <- count(out_rolls, congress, chamber)
count_rolls <- left_join(count_rolls, count_opp90, by = c("congress", "chamber")) |>
  rename(rolls = n.x, opps90 = n.y)
count_rolls[is.na(count_rolls)] <- 0
pct_opps90 <- count_rolls |> select(congress, chamber, opps90, rolls) |> 
  mutate(percent = opps90 / rolls * 100)