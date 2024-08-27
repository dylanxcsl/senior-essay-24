################################ LOAD LIBRARIES ################################
# library(glue)
# library(issueirt)
# library(pscl) 
# library(Rvoteview)
# library(tidyverse)

################################### LOAD DATA ##################################
rolls <- read_csv("01_data/rcv_voteview_v3_2.csv") |> 
  mutate(chamber = recode(chamber, `1` = "H", `2` = "S", House = "H", Senate = "S")) |> 
  select(congress, chamber, rollnumber, subtopic, majortopic) |>
  filter(congress %in% 112 & majortopic %in% 7:8) |>
  as_tibble()

# roll call vote item data
h112_item_init <- Rvoteview::download_metadata("rollcalls", chamber = "house", congress = 112) |> 
  mutate(chamber = recode(chamber, House = "H", Senate = "S")) |> 
  select(!matches("nominate")) |> 
  filter(nay_count > 0) |> 
  tidylog::left_join(rolls, by = c("clerk_rollnumber" = "rollnumber", "congress", "chamber")) |> 
  mutate(vname = glue("R{chamber}{str_pad(congress, pad = '0', width = 3)}{str_pad(rollnumber, pad = '0', width = 4)}")) |> 
  tidylog::filter(n() > 5, .by = majortopic) |>
  filter(majortopic %in% 7:8) |>
  as_tibble()

# issue codes need to be consecutive ---
pap_recode <- h112_item_init |> 
  select(subtopic) |> 
  # renumber to consecutive
  mutate(pap2 = as.integer(fct_reorder(factor(subtopic), subtopic))) |> 
  distinct(subtopic, pap2) |> 
  arrange(subtopic) |>
  # substantive meanings
  mutate(sub_name = case_when(subtopic == 700 ~ "General (Env.)",
                              subtopic == 701 ~ "Drinking Water", 
                              subtopic == 703 ~ "Waste Disposal",
                              subtopic == 704 ~ "Hazardous Waste",
                              subtopic == 705 ~ "Air Pollution",
                              subtopic == 707 ~ "Recycling",
                              subtopic == 708 ~ "Indoor Hazards",
                              subtopic == 709 ~ "Species/Habitat Protection" ,
                              subtopic == 710 ~ "Coastal Pollution" ,
                              subtopic == 711 ~ "Land/Water Conservation" ,
                              subtopic == 798 ~ "Research (Env.)", 
                              subtopic == 799 ~ "Other (Env.)",
                              subtopic == 800 ~ "General (Eng.)", 
                              subtopic == 801 ~ "Nuclear Energy",
                              subtopic == 802 ~ "Electricity/Hydroelectricity", 
                              subtopic == 803 ~ "Natural Gas and Oil",
                              subtopic == 805 ~ "Coal", 
                              subtopic == 806 ~ "Renewable Energy",
                              subtopic == 807 ~ "Energy Conservation",
                              subtopic == 898 ~ "Research (Eng.)",
                              subtopic == 899 ~ "Other (Eng.)"))

h112_item <- h112_item_init |> left_join(pap_recode, by = "subtopic")

## rollcall votes
h112_rc <- Rvoteview::voteview_download(h112_item$vname)

# Member data
h112_memb <- Rvoteview::download_metadata("members", chamber = "house", congress = 112) |> 
  as_tibble() |> 
  mutate(icpsr = factor(icpsr, levels = rownames(h112_rc$votes))) |> 
  drop_na(icpsr) |>
  arrange(icpsr)

# Preprocessing -----
## follow vignette instruciton
rc_rec <- issueirt::recode_votes(
  h112_rc$votes,
  party_code = h112_memb$party_code,
  yea = 1, 
  nay = 6,
  missing = c(NA, 7, 9)
)

## rollcall obj
rc_input <- pscl::rollcall(
  rc_rec, 
  yea = 1, nay = 0, missing = NA,
  legis.names = h112_memb$icpsr,
  legis.data = as.data.frame(h112_memb),
  vote.names = colnames(h112_rc$votes))

# Initial dimensions (Clinton Jackman Rivers) ---
ideal <- pscl::ideal(rc_input, d = 2, store.item = TRUE) ## need store.item for later

## follow vignette
pol_rc1 <- issueirt::find_pol_rc_horizontal(rc_input)
pol_rc2 <- issueirt::find_pol_rc_vertical(ideal, rc_input, pol_rc_horizontal = pol_rc1)
const_ls <- issueirt::find_constraints(
  ideal, rc_input, pol_rc1 = pol_rc1, pol_rc2 = pol_rc2, 
  as_list = TRUE)
ideal_pp <- pscl::postProcess(ideal, constraints = const_ls)

## check
issueirt::plot_ideal(
  ideal_point_1d = ideal_pp$xbar[,1], 
  ideal_point_2d = ideal_pp$xbar[,2],
  group = h112_memb$party_code)


## main object for issueirt
stan_input <- issueirt::make_stan_input(
  issue_code_vec = h112_item$pap2, # user-supplied issue labels
  rollcall = rc_input, 
  ideal = ideal_pp, 
  a = 0.01, b = 0.001, rho_init = 10 
)


# Fit final issueirt model ----
fit_sim <- issueirt::issueirt_stan(
  data = stan_input$data,   
  # one per chain
  init = list(stan_input$init, stan_input$init, 
              stan_input$init, stan_input$init),
  chains = 4,
  warmup = 900,
  iter = 1400,
  cores = 4,
  seed = 1
)
# 30 minutes for 1400 iterations?

write_rds(fit_sim, "issueirt_fit.rds")
write_rds(stan_input, "temp_shiro_stan_input.rds")


# View results ------
posterior_summary_pp <- issueirt::make_posterior_summary_postprocessed(
  stan_fit = fit_sim, 
  constraints = const_ls, 
  issue_label = pap_recode$subtopic,
  rc_label = colnames(rc_input$votes), 
  legis_label = rownames(rc_input$votes)
)

## data
plot_out <- issueirt::plot_issueaxis(
  stan_input = stan_input, 
  posterior_summary = posterior_summary_pp,
  group = h112_memb$party_code, 
  p.title = "",
)

## Plot list in concatenation
library(patchwork)
gg <- wrap_plots(plot_out) + plot_layout(guides = "collect")
ggsave("issueirt.pdf", gg, w = 10, h = 12)
