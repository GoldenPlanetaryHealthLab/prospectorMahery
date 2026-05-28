knitr::opts_chunk$set(eval = FALSE)


library(targets)
library(dplyr)
library(here)

devtools::load_all()


tar_load(
  c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  ), 
  store = here("_targets")
)


crs_add_categ <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}

mah_dar_crs_hh_weekly_per_month_long <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}

mah_dar_crs_hh_groups_weekly_per_month_grams_categ_long <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}

mah_dar_crs_avg_consump_by_group <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}
