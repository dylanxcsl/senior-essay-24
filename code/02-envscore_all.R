#  CALCULATE ENVSCORE (BY LEGISLATORS PER CONGRESS)

## STEP 1. Create a table of legislators' environmental score (w/ tenure)
## House
h.legis_uni <- unique(filter(legis_all, congress > 87 & congress < 118 & chamber == "House")[c("icpsr", "congress")])
h.legis_env <-filter(envscore_ind, chamber == "House")
h.legis_end <- left_join(h.legis_uni, h.legis_env, by = "icpsr") |>
  select(icpsr, congress, name, party_code, chamber, 
         state_abbrev, dim1, dim2, coord1D, 
         correctYea, wrongYea, correctNay, wrongNay)
## Senate
s.legis_uni <- unique(filter(legis_all, congress > 87 & congress < 118 & chamber == "Senate")[c("icpsr", "congress")])
s.legis_env <- filter(envscore_ind, chamber == "Senate")
s.legis_end <- left_join(s.legis_uni, s.legis_env, by = "icpsr") |>
  select(icpsr, congress, name, party_code, chamber, 
         state_abbrev, dim1, dim2, coord1D, 
         correctYea, wrongYea, correctNay, wrongNay)
## Congress
envscore_all <- rbind(h.legis_end, s.legis_end)
## write.csv(envscore_all, "data/envscore_all.csv")