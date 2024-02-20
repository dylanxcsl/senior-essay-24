#  VOTES ON TOPIC PER CONGRESS

# STEP 1. Format data into horizontal format
roll_count.705 <- rollcalls |>
  filter(pap_subtopic == 705) |>
  group_by(chamber, congress) |>
  count(congress) |>
  mutate(topic = "705")
roll_count.7   <- rollcalls |>
  group_by(chamber, congress) |>
  count(congress) |>
  mutate(topic = "7")
roll_count     <- left_join(roll_count.7, roll_count.705, by = c("congress", "chamber")) |>
  mutate(topic.y = "705")
roll_count$n.y <- replace(roll_count$n.y, is.na(roll_count$n.y), 0)
roll_count_hz  <- roll_count |>
  mutate(prop = n.y / n.x * 100)

# STEP 2. Format data into vertical format
roll_count.705_v <- roll_count |> select(chamber, congress, n.y, topic.y) |>
  rename(n = n.y, topic = topic.y)
roll_count.7_v   <- roll_count |> select(chamber, congress, n.x, topic.x) |>
  rename(n = n.x, topic = topic.x)
roll_count_vt    <- rbind(roll_count.705, roll_count.7)