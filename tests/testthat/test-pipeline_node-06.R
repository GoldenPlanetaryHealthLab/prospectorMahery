#| sorting-hat: keep
library(dplyr)


library(readxl)
library(stringr)
library(here)


library(targets)


tar_load(
  c(
    fish_enc_g, mah_foods_avg, dar_ooh_indiv,
    u_isany, u_kapoaka, u_other, u_NA
  ),
  store = here("_targets")
)


dar_ooh_indiv_with_grams <- {
  x <- c(
    fish_enc_g, mah_foods_avg, dar_ooh_indiv,
    u_isany, u_kapoaka, u_other, u_NA
  )
  tibble()
}

hh_comb <- {
  x <- c(
    fish_enc_g, mah_foods_avg, dar_ooh_indiv,
    u_isany, u_kapoaka, u_other, u_NA
  )
  tibble()
}

hh_comb_groups <- {
  x <- c(
    fish_enc_g, mah_foods_avg, dar_ooh_indiv,
    u_isany, u_kapoaka, u_other, u_NA
  )
  tibble()
}

hh_total_weekly_non_fish <- {
  x <- c(
    fish_enc_g, mah_foods_avg, dar_ooh_indiv,
    u_isany, u_kapoaka, u_other, u_NA
  )
  tibble()
}
