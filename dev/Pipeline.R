#' ---
#' title: MAHERY Pipeline
#' format: gfm
#' ---
#' 

devtools::load_all()


library(stringr)
library(testthat)
library(dplyr)


library(here)


manifest <- here("stagecoach_manifest.yml")


repo_files <- register_inputs(
  here(
    "data", 
    "inputs", 
    "01_gold_mine", 
    "madagascar-cohort-data-zip/madagascar_data_cleaning-main.zip"
    ),
  regex = ".+"
  ) %>%
  str_c(here("data", "inputs", "01_gold_mine", "madagascar-cohort-data-zip"), .)


target_files <- c(
  #01 darwin
  "fish_enc_17Feb2025\\.csv",
  "Laoko_Mar_10_2021\\.csv",
  # 07 mahery
  "mah_hh_dietary_intake\\.csv",
  "mahery_metadata\\.xlsx",
  "MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1\\.xlsx",
  "dar_hh_weekly_per_month_grams_categs_long\\.csv",
  "fish_enc_17Feb2025\\.csv"
  )


mahery_files <- unzip_tracked(
  here(
    "data", 
    "inputs", 
    "01_gold_mine", 
    "madagascar-cohort-data-zip/madagascar_data_cleaning-main.zip"
    ),
  files = target_files,
  junkpaths = TRUE,  
  exdir = here("data", "inputs", "01_gold_mine", "madagascar-cohort-data-zip/")
)


knitr::opts_chunk$set(eval = FALSE)


#| sorting-hat: keep
library(dplyr)
library(here)
library(targets)


#| sorting-hat: keep
dar_hh_fish_with_grams_no_weekly <- {
  x <- mahery_files
  tibble()
}


tar_load(dar_hh_fish_with_grams_no_weekly)

test_that("Testing Node: dar_hh_fish_with_grams_no_weekly", {

expect_true(exists("dar_hh_fish_with_grams_no_weekly"))
expect_true(is.data.frame(dar_hh_fish_with_grams_no_weekly))
expect_false(nrow(dar_hh_fish_with_grams_no_weekly) > 0)

})


library(dplyr)


dar_hh_weekly_with_grams <- tibble()
dar_hh_24_hr_with_grams <- tibble()


tar_load(c(dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams))

test_that("Testing Node(s): dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams", {

expect_true(exists("dar_hh_24_hr_with_grams"))
expect_true(exists("dar_hh_weekly_with_grams"))

expect_true(is.data.frame(dar_hh_24_hr_with_grams))
expect_true(is.data.frame(dar_hh_weekly_with_grams))

expect_false(nrow(dar_hh_24_hr_with_grams) > 0)
expect_false(nrow(dar_hh_weekly_with_grams) > 0)

})
