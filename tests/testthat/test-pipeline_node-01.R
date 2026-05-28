knitr::opts_chunk$set(eval = FALSE)


#| sorting-hat: keep
library(dplyr)
library(here)
library(targets)

tar_load(
  c(mahery_files),
  store = here("_targets")
)


#| sorting-hat: keep
dar_hh_fish_with_grams_no_weekly <- {
  x <- c(mahery_files, fish_enc_g, hh_fish)
  tibble()
}
