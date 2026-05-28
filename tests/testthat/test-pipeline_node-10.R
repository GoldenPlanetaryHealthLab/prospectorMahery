library(targets)
library(dplyr)


library(here)


devtools::load_all()


tar_load(
  c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  ), 
  store = here("_targets")
)


mah_dar_crs_hh_weekly_per_month_wide <- {
  x <- c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  )
  tibble()
}

mah_dar_crs_avg_hh_weekly_grams_categs_long <- {
  x <- c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  )
  tibble()
}

mah_dar_crs_avg_hh_daily_grams_categs_long <- {
  x <- c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  )
  tibble()
}
