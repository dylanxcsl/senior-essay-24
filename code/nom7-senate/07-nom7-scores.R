# Create a matrix of 7-coded votes
s_vview.matrx <- as.matrix(s_tab.fin[ , 4:461])

# Run matrix through rollcall function
s_vview.rolls  <- rollcall(s_vview.matrx, yea = c(1, 2, 3), nay = c(4, 5, 6),
                          missing = c(7, 8, 9), notInLegis = 0,
                          legis.names = s_tab.fin$icpsr,
                          desc = "7-coded votes",
                          source = "www.voteview.com")

#  Run rollcall through NOMINATE function (run set.seed and wnominate together)
set.seed(337)
s_vview.nomte <- wnominate(rcObject = s_vview.rolls, dims = 1, minvotes = 20, polarity = "20100")

summary(s_vview.nomte)

# Create a table of legislators' NOMINATE-7 scores
s_vview.legis <- s_vview.nomte$legislators |> as_tibble(rownames = "icpsr")

s_vview.final <- left_join(s_tab.leg, s_vview.legis, by = "icpsr") |>
  mutate(dim1 = as.numeric(dim1)) |>
  mutate(prop1 = correctYea / (correctYea + wrongYea) * 100) |>
  mutate(prop2 = correctNay / (correctNay + wrongNay) * 100) |>
  mutate(prop3 = (prop1 + prop2) / 2)

# Drop NAs in h_vview.final
s_vview.final.clean <- s_vview.final |>
  drop_na(coord1D, prop1, prop2, prop3) |>
  mutate(chamber = "Senate")