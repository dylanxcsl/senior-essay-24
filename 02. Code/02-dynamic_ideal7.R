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

# CONGRESS 91
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(91))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:15])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))

  members <- h_members |> filter(congress == 91)
  
  ideal91 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 92
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(92))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:41])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 92)
  
  ideal92 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 93
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(93))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:31])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 93)
  
  ideal93 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 94
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(94))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:66])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 94)
  
  ideal94 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 95
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(95))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:48])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 95)
  
  ideal95 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 96
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(96))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:35])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 96)
  
  ideal96 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 97
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(97))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:39])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 97)
  
  ideal97 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 98
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(98))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:33])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 98)
  
  ideal98 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 99
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(99))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:31])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 99)
  
  ideal99 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 100
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(100))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:24])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 100)
  
  ideal100 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 101
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(101))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:36])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 101)
  
  ideal101 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 102
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(102))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:14])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 102)
  
  ideal102 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 103
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(103))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:21])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 103)
  
  ideal103 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 104
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(104))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:66])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 104)
  
  ideal104 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 105
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(105))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:34])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 105)
  
  ideal105 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 106
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(106))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:48])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 106)
  
  ideal106 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 107
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(107))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:21])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 107)
  
  ideal107 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 108
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(108))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:16])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 108)
  
  ideal108 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 109
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(109))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:23])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 109)
  
  ideal109 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 110
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(110))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:52])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 110)
  
  ideal110 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 111
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(111))
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
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 111)
  
  ideal111 <- left_join(members, ideal, by = "icpsr")
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
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 112)
  
  ideal112 <- left_join(members, ideal, by = "icpsr")
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
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 113)
  
  ideal113 <- left_join(members, ideal, by = "icpsr")
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
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 114)
  
  ideal114 <- left_join(members, ideal, by = "icpsr")
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
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))

  members <- h_members |> filter(congress == 115)
  
  ideal115 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 116
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(116))
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
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 116)
  
  ideal116 <- left_join(members, ideal, by = "icpsr")
}

# CONGRESS 117
{
  # CREATE MATRIX
  h_rolls <- h_rollcalls |>
    filter(congress %in% c(117))
  h_rolls <- as.vector(h_rolls$vote_id)
  h_out   <- voteview_download(ids = h_rolls)
  h_legis <- h_out$legis.data |> as_tibble()
  h_votes <- h_out$votes |> as_tibble(rownames = "icpsr")
  h_join  <- left_join(h_legis, h_votes, by = "icpsr") |>
    select(icpsr, name, state_abbrev, starts_with("RH"))
  h_matrix <- as.matrix(h_join[ , 4:24])
  
  # CREATE ROLLCALL
  h_rollcall <- rollcall(h_matrix, yea = c(1, 2, 3), nay = c(4, 5, 6),
                         missing = c(7, 8, 9), notInLegis = 0,
                         legis.names = h_join$icpsr,
                         desc = "env-coded votes",
                         source = "www.voteview.com")
  
  # RUN IDEAL
  rc_ideal <- h_rollcall |>
    ideal(maxiter = 30000, thin = 30, burnin = 3000,
          impute = FALSE, normalize = TRUE, store.item = TRUE, verbose = TRUE)
  
  ideal <- rc_ideal$xbar
  ideal <- data.frame(rownames(ideal), ideal) |>
    rename(icpsr = 1, ideal7 = 2) |>
    mutate(ideal7 = round(ideal7, 3))
  
  members <- h_members |> filter(congress == 117)
  
  ideal117 <- left_join(members, ideal, by = "icpsr")
}

################################################################################
################################ MERGE DATA ####################################
################################################################################

ideal117 <- ideal117 |>
  mutate(ideal7 = ideal7 * -1)
ideal112 <- ideal112 |>
  mutate(ideal7 = ideal7 * -1)
ideal111 <- ideal111 |>
  mutate(ideal7 = ideal7 * -1)
ideal110 <- ideal110 |>
  mutate(ideal7 = ideal7 * -1)
ideal109 <- ideal109 |>
  mutate(ideal7 = ideal7 * -1)
ideal108 <- ideal108 |>
  mutate(ideal7 = ideal7 * -1)
ideal107 <- ideal107 |>
  mutate(ideal7 = ideal7 * -1)
ideal106 <- ideal106 |>
  mutate(ideal7 = ideal7 * -1)
ideal105 <- ideal105 |>
  mutate(ideal7 = ideal7 * -1)
ideal104 <- ideal104 |>
  mutate(ideal7 = ideal7 * -1)
ideal103 <- ideal103 |>
  mutate(ideal7 = ideal7 * -1)
ideal102 <- ideal102 |>
  mutate(ideal7 = ideal7 * -1)
ideal101 <- ideal101 |>
  mutate(ideal7 = ideal7 * -1)
ideal100 <- ideal100 |>
  mutate(ideal7 = ideal7 * -1)
ideal99 <- ideal99 |>
  mutate(ideal7 = ideal7 * -1)
ideal98 <- ideal98 |>
  mutate(ideal7 = ideal7 * -1)
ideal97 <- ideal97 |>
  mutate(ideal7 = ideal7 * -1)
ideal96 <- ideal96 |>
  mutate(ideal7 = ideal7 * -1)
ideal95 <- ideal95 |>
  mutate(ideal7 = ideal7 * -1)
ideal94 <- ideal94 |>
  mutate(ideal7 = ideal7 * -1)
ideal93 <- ideal93 |>
  mutate(ideal7 = ideal7 * -1)
ideal92 <- ideal92 |>
  mutate(ideal7 = ideal7 * -1)

ideal_91to117 <- rbind(ideal91, ideal92, ideal93, ideal94, ideal95, ideal96, ideal97, 
                       ideal98, ideal99, ideal100, ideal101, ideal102, ideal103, 
                       ideal104, ideal105, ideal106, ideal107, ideal108, ideal109, 
                       ideal110, ideal111, ideal112, ideal113, ideal114, ideal115,
                       ideal116, ideal117)

# write.csv(ideal_91to117, "04. Results/dyn_ideal7.csv")