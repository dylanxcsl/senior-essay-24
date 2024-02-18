# Create a matrix of 7-coded votes
h_vview.matrx <- as.matrix(h_tab.fin[ , 4:1238])

# Run matrix through rollcall function
h_vview.rolls <- rollcall(h_vview.matrx, yea = c(1, 2, 3), nay = c(4, 5, 6),
                          missing = c(7, 8, 9), notInLegis = 0,
                          legis.names = h_tab.fin$icpsr,
                          desc = "7-coded votes",
                          source = "www.voteview.com")

#  Run rollcall through NOMINATE function (run set.seed and wnominate together)
set.seed(337)
h_vview.nomte <- wnominate(rcObject = h_vview.rolls, dims = 1, minvotes = 20, polarity = "20100")

summary(h_vview.nomte)

# Create a table of legislators' NOMINATE-7 scores
h_vview.legis <- h_vview.nomte$legislators |> as_tibble(rownames = "icpsr")

h_vview.final <- left_join(h_tab.leg, h_vview.legis, by = "icpsr") |>
  mutate(dim1 = as.numeric(dim1)) |>
  mutate(prop1 = correctYea / (correctYea + wrongYea) * 100) |>
  mutate(prop2 = correctNay / (correctNay + wrongNay) * 100) |>
  mutate(prop3 = (prop1 + prop2) / 2)

# Drop NAs in h_vview.final
h_vview.final.clean <- h_vview.final |>
  drop_na(coord1D, prop1, prop2, prop3) |>
  mutate(chamber = "House")