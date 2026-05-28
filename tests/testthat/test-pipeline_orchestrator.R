devtools::load_all()


library(stringr)
library(testthat)
library(dplyr)


library(yaml)
library(purrr)
library(here)


library(targets)


manifest <- here("stagecoach_manifest.yml")


repository_zip <- read_yaml(manifest) %>%
  pluck("sources", "01_gold_mine", "items", 1, "path_regex") %>%
  basename()

repo_files <- register_inputs(
  here(
    "data", 
    "inputs", 
    "01_gold_mine", 
    "madagascar-cohort-data-zip",
    repository_zip
    ),
  regex = ".+"
  ) %>%
  str_c(here("data", "inputs", "01_gold_mine", "madagascar-cohort-data-zip"), .)


target_files <- c(
  #01 darwin
  "fish_enc_17Feb2025\\.csv",
  "Laoko_Mar_10_2021\\.csv",
  #02 darwin
  "darwin_pop\\.csv",
  "hh_weekly\\.csv",
  "hh_24_hr\\.csv",
  "mah_foods_avg\\.csv",
  "utg_isany\\.csv",
  "utg_kapoaka\\.csv",
  "utg_other\\.csv",
  "utg_NA\\.csv",
  #05 darwin
   "MeasureSakafo\\.csv",
   "Out_of_household_unmatched_items_for_Chris_02\\.08\\.2024\\.xlsx",
   "ooh_indiv_amounts8Feb2024\\.xlsx",
  # 07 mahery
  "mah_hh_dietary_intake\\.csv",
  "mahery_metadata\\.xlsx",
  "MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1\\.xlsx",
  "dar_hh_weekly_per_month_grams_categs_long\\.csv",
  "fish_enc_17Feb2025\\.csv",
  #08 CRS
  "Survey_Data_Adults_All_Merged\\.csv",
  "Metadata_Adults 20180128\\.csv",
  "CRS_fuzzy_match_to_DAR_for_weights\\.xlsx"


  )


mahery_files <- unzip_tracked(
  here(
    "data", 
    "inputs", 
    "01_gold_mine", 
    "madagascar-cohort-data-zip", 
    repository_zip
    ),
  files = target_files,
  junkpaths = TRUE,  
  exdir = here("data", "inputs", "01_gold_mine", "madagascar-cohort-data-zip/")
)


tar_load(dar_hh_fish_with_grams_no_weekly, store = here("_targets"))

test_that("Testing Node: dar_hh_fish_with_grams_no_weekly", {

expect_true(exists("dar_hh_fish_with_grams_no_weekly"))
expect_true(is.data.frame(dar_hh_fish_with_grams_no_weekly))
expect_false(nrow(dar_hh_fish_with_grams_no_weekly) > 0)

})


tar_load(c(dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams), store = here("_targets"))

test_that("Testing Node(s): dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams", {

expect_true(exists("dar_hh_24_hr_with_grams"))
expect_true(exists("dar_hh_weekly_with_grams"))

expect_true(is.data.frame(dar_hh_24_hr_with_grams))
expect_true(is.data.frame(dar_hh_weekly_with_grams))

expect_false(nrow(dar_hh_24_hr_with_grams) > 0)
expect_false(nrow(dar_hh_weekly_with_grams) > 0)

})
