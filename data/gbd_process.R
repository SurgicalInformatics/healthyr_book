library(tidyverse)

gbd_short = read_csv("data/IHME-GBD_2017_DATA-short.csv") %>%
  select(-location, -sex, -age, -upper, -lower, -metric, -measure) %>%
  rename(deaths = val) %>%
  mutate(deaths = round(deaths, 0)) %>%
  mutate(cause = fct_recode(cause, "Communicable diseases" = "Communicable, maternal, neonatal, and nutritional diseases")) %>%
  arrange(year, cause)

gbd_short %>%
  write_csv(path = "data/global_burden_disease_SHORT.csv")

