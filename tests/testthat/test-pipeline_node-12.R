knitr::opts_chunk$set(eval = FALSE)


library(targets)
library(dplyr)
library(here)

devtools::load_all()


tar_load(
  c(
    fish_enc_g, new_groups, mah_hh_per_meal_grams_categs_long,
    dar_hh_comb_groups_with_24h, dar_ooh_unique_foods, crs_unique_foods
  ), 
  store = here("_targets")
)


unique_non_fish_foods <- {
  x <- c(
    fish_enc_g, new_groups, mah_hh_per_meal_grams_categs_long,
    dar_hh_comb_groups_with_24h, dar_ooh_unique_foods, crs_unique_foods
  )
  tibble()
}

unique_fish_foods <- {
  x <- c(
    fish_enc_g, new_groups, mah_hh_per_meal_grams_categs_long,
    dar_hh_comb_groups_with_24h, dar_ooh_unique_foods, crs_unique_foods
  )
  tibble()
}

unique_foods <- {
  x <- c(
    fish_enc_g, new_groups, mah_hh_per_meal_grams_categs_long,
    dar_hh_comb_groups_with_24h, dar_ooh_unique_foods, crs_unique_foods
  )
  tibble()
}
