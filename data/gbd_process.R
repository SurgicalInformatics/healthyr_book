library(tidyverse)

gbd_long = read_csv("data/IHME-GBD_2017_DATA-years_3causes_sex_wb-income.csv") %>%
  select(-age, -upper, -lower, -metric, -measure) %>%
  rename(deaths = val) %>%
  mutate(deaths_millions = round(deaths/1e6, 2)) %>%
  select(-deaths) %>%
  mutate(cause = fct_recode(cause, "Communicable diseases" = "Communicable, maternal, neonatal, and nutritional diseases")) %>%
  mutate(income = fct_recode(location,
                            "High"         = "World Bank High Income",
                            "Upper-Middle" = "World Bank Upper Middle Income",
                            "Lower-Middle" = "World Bank Lower Middle Income",
                            "Low"          = "World Bank Low Income") %>%
           fct_relevel("High", "Upper-Middle", "Lower-Middle")) %>%
  arrange(year, cause, sex, income) %>%
  select(cause, year, sex, income, deaths_millions)


gbd_short = gbd_long %>%
  group_by(year, cause) %>%
  summarise(deaths_millions = sum(deaths_millions))

# Chapter 2 - for filter()
gbd_short %>%
  write_csv(path = "data/global_burden_disease_cause-year.csv")

# Chapter 3 - for summarise() and mutate()
gbd_long %>%
  write_csv(path = "data/global_burden_disease_cause-year-sex-income.csv")

#Chapter 3 - spread() and gather()
gbd_long_example = gbd_long %>%
  filter(year %in% c(1990, 2017)) %>%
  group_by(cause, sex, year) %>%
  summarise(deaths_millions = sum(deaths_millions))

gbd_wide_exercise = gbd_long_example %>%
  group_by(cause) %>%
  arrange(year, cause, .by_group = TRUE) %>%
  unite("sex_year", c("sex", "year"), sep = "-") %>%
  spread(sex_year, deaths_millions)


gbd_long_example %>%
  write_csv(path = "data/global_burden_disease_cause-sex-year.csv")


gbd_wide_exercise %>%
  write_csv(path = "data/global_burden_disease_wide-format.csv")

