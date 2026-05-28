#| sorting-hat: keep
library(dplyr)


library(readxl)
library(stringr)
library(here)


library(targets)


tar_load(
  c(
    new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long,
    dar_hh_weekly_per_month_fish_wide
  ),
  store = here("_targets")
)


dar_hh_comb_groups_with_24h <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_hh_weekly_per_month_grams_categs_long <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_hh_weekly_per_month_non_fish_wide <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_hh_weekly_per_month_wide <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_avg_hh_weekly_grams_categs_long <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_avg_hh_daily_grams_categs_long <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
