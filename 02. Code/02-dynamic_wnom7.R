# LIBRARY
# library(tidyverse)
# library(Rvoteview)
# library(wnominate)
# library(pscl)

# DATA
rolls <- read.csv("data/rcv_voteview_v3_2_91to117(1).csv") |> as_tibble()
h_rollcalls <- rolls |> filter(majortopic == 7)
h_members <- read.csv("01. Data/HSall_members.csv") |> as_tibble() |>
  filter(chamber == "House" & congress > 90 & congress < 118) |>
  mutate(icpsr = as.character(icpsr),
         party_code = case_when(
           party_code == 100 ~ "D",
           party_code == 200 ~ "R",
           party_code != 100 & party_code != 200 ~ "I"
         ))

################################################################################
############################## RUN ITERATIVELY #################################
################################################################################

# CONGRESS 91 TO 92
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(91, 92))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:53])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_91to92 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "12041")
  
  env_91to92 <- wnom_91to92$legislators |>
    mutate(icpsr = rownames(wnom_91to92$legislators), group = 1)
  
  env_91to92 <- left_join(env_91to92, filter(h_members, congress %in% c(91, 92)), by = "icpsr") |> as_tibble()
  env_91to92 <- env_91to92 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 93 TO 94
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(93, 94))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:94])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_93to94 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "12041")
  
  env_93to94 <- wnom_93to94$legislators |>
    mutate(icpsr = rownames(wnom_93to94$legislators), group = 2)
  
  env_93to94 <- left_join(env_93to94, filter(h_members, congress %in% c(93, 94)), by = "icpsr") |> as_tibble()
  env_93to94 <- env_93to94 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 95 TO 97
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(95, 96, 97))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:116])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_95to97 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "12041")
  
  env_95to97 <- wnom_95to97$legislators |>
    mutate(icpsr = rownames(wnom_95to97$legislators), group = 3)
  
  env_95to97 <- left_join(env_95to97, filter(h_members, congress %in% c(95, 96, 97)), by = "icpsr") |> as_tibble()
  env_95to97 <- env_95to97 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 98 TO 100
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(98, 99, 100))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:82])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_98to100 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "12041")
  
  env_98to100 <- wnom_98to100$legislators |>
    mutate(icpsr = rownames(wnom_98to100$legislators), group = 4)
  
  env_98to100 <- left_join(env_98to100, filter(h_members, congress %in% c(98, 99, 100)), by = "icpsr") |> as_tibble()
  env_98to100 <- env_98to100 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 101 TO 103
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(101, 102, 103))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:68])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_101to103 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "12041")
  
  env_101to103 <- wnom_101to103$legislators |>
    mutate(icpsr = rownames(wnom_101to103$legislators), group = 5)
  
  env_101to103 <- left_join(env_101to103, filter(h_members, congress %in% c(101, 102, 103)), by = "icpsr") |> as_tibble()
  env_101to103 <- env_101to103 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 104 TO 105
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(104, 105))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:97])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_104to105 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "12041")
  
  env_104to105 <- wnom_104to105$legislators |>
    mutate(icpsr = rownames(wnom_104to105$legislators), group = 6)
  
  env_104to105 <- left_join(env_104to105, filter(h_members, congress %in% c(104, 105)), by = "icpsr") |> as_tibble()
  env_104to105 <- env_104to105 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 106 TO 109
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(106, 107, 108, 109))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:99])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_106to109 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "14290")
  
  env_106to109 <- wnom_106to109$legislators |>
    mutate(icpsr = rownames(wnom_106to109$legislators), group = 7)
  
  env_106to109 <- left_join(env_106to109, filter(h_members, congress %in% c(106, 107, 108, 109)), by = "icpsr") |> as_tibble()
  env_106to109 <- env_106to109 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 110 TO 111
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(110, 111))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:102])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_110to111 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "14290")
  
  env_110to111 <- wnom_110to111$legislators |>
    mutate(icpsr = rownames(wnom_110to111$legislators), group = 8)
  
  env_110to111 <- left_join(env_110to111, filter(h_members, congress %in% c(110, 111)), by = "icpsr") |> as_tibble()
  env_110to111 <- env_110to111 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 112
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(112))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:149])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_112 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "14290")
  
  env_112 <- wnom_112$legislators |>
    mutate(icpsr = rownames(wnom_112$legislators), group = 9)
  
  env_112 <- left_join(env_112, filter(h_members, congress %in% c(112)), by = "icpsr") |> as_tibble()
  env_112 <- env_112 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 113
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(113))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:101])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_113 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "20738")
  
  env_113 <- wnom_113$legislators |>
    mutate(icpsr = rownames(wnom_113$legislators), group = 10)
  
  env_113 <- left_join(env_113, filter(h_members, congress %in% c(113)), by = "icpsr") |> as_tibble()
  env_113 <- env_113 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 114
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(114))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:133])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_114 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "20738")
  
  env_114 <- wnom_114$legislators |>
    mutate(icpsr = rownames(wnom_114$legislators), group = 11)
  
  env_114 <- left_join(env_114, filter(h_members, congress %in% c(114)), by = "icpsr") |> as_tibble()
  env_114 <- env_114 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 115
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(115))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:83])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_115 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "20738")
  
  env_115 <- wnom_115$legislators |>
    mutate(icpsr = rownames(wnom_115$legislators), group = 12)
  
  env_115 <- left_join(env_115, filter(h_members, congress %in% c(115)), by = "icpsr") |> as_tibble()
  env_115 <- env_115 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

# CONGRESS 116 TO 117
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(116, 117))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:74])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN W-NOMINATE
  wnom_116to117 <- h_rollcall |>
    wnominate(dims = 1, minvotes = 15, trials = 1, polarity = "20738")
  
  env_116to117 <- wnom_116to117$legislators |>
    mutate(icpsr = rownames(wnom_116to117$legislators), group = 13)
  
  env_116to117 <- left_join(env_116to117, filter(h_members, congress %in% c(116, 117)), by = "icpsr") |> as_tibble()
  env_116to117 <- env_116to117 |>
    select(group, congress, chamber, icpsr, bioguide_id, bioname, party_code, state_abbrev,
           district_code, born, died, nominate_dim1, nokken_poole_dim1, coord1D, 
           correctYea, wrongYea, correctNay, wrongNay, GMP, CC, se1D)
}

################################################################################
################################ MERGE DATA ####################################
################################################################################

env_91to117 <- rbind(env_91to92, env_93to94, env_95to97, env_98to100,
                     env_101to103, env_104to105, env_106to109, env_110to111,
                     env_112, env_113, env_114, env_115, env_116to117)

# write.csv(ideal_91to117, "04. Results/dyn_wnom7.csv")

summary(wnom_91to92)
summary(wnom_93to94)z
summary(wnom_95to97)
summary(wnom_98to100)
summary(wnom_101to103)
summary(wnom_104to105)
summary(wnom_106to109)
summary(wnom_110to111)
summary(wnom_112)
summary(wnom_113)
summary(wnom_114)
summary(wnom_115)
summary(wnom_116to117)