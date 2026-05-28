library(targets)
library(dplyr)


library(here)


devtools::load_all()


tar_load(
  c(
    crs_indiv_daily_grams_categs_long
  ), 
  store = here("_targets")
)


crs_hh_daily_grams_categs_long <- {
  x <- c(
    crs_indiv_daily_grams_categs_long
  )
  tibble()
}

crs_hh_weekly_grams_categs_long <- {
  x <- c(
    crs_indiv_daily_grams_categs_long
  )
  tibble()
}

crs_hh_weekly_per_month_wide <- {
  x <- c(
    crs_indiv_daily_grams_categs_long
  )
  tibble()
}
