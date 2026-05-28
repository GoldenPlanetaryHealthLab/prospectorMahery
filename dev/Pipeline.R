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
  #02 darwin
  "hh_weekly\\.csv",
  "hh_24_hr\\.csv",
  "mah_foods_avg\\.csv",
  "utg_isany\\.csv",
  "utg_kapoaka\\.csv",
  "utg_other\\.csv",
  "utg_NA\\.csv",
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

tar_load(
  c(mahery_files),
  store = here("_targets")
)


fish_enc_g <- mahery_files %>%
  str_subset("fish_enc_17Feb2025") %>%
  read.csv()

hh_fish <- mahery_files %>%
  str_subset("Laoko_Mar_10_2021") %>%
  read.csv()


#| sorting-hat: keep
dar_hh_fish_with_grams_no_weekly <- {
  x <- c(mahery_files, fish_enc_g, hh_fish)
  tibble()
}


tar_load(dar_hh_fish_with_grams_no_weekly, store = here("_targets"))

test_that("Testing Node: dar_hh_fish_with_grams_no_weekly", {

expect_true(exists("dar_hh_fish_with_grams_no_weekly"))
expect_true(is.data.frame(dar_hh_fish_with_grams_no_weekly))
expect_false(nrow(dar_hh_fish_with_grams_no_weekly) > 0)

})


#| sorting-hat: keep
library(dplyr)
library(stringr)
library(here)
library(targets)


tar_load(
  c(mahery_files, fish_enc_g),
  store = here("_targets")
)


hh_weekly <- mahery_files %>%
  str_subset("hh_weekly.csv") %>%
  read.csv() %>%
  select(-X)

hh_24_hr <- mahery_files %>%
  str_subset("hh_24_hr") %>%
  read.csv() %>%
  select(-X)


mah_foods_avg <- mahery_files %>%
  str_subset("mah_foods_avg") %>%
  read.csv() %>%
  select(-X) %>%
  rename("Malagasy Name" = "Malagasy.Name", "English Name" = "English.Name") %>%
  mutate(
    dar_name = replace_when(
      dar_name, var_names == "mavon" ~ "mavondro"
    )
  )


u_isany <- mahery_files %>%
  str_subset("utg_isany") %>%
  read.csv() %>%
  mutate(
    FISHID = as.character(FISHID), 
    CookingMethod2 = as.character(CookingMethod2)
  )
# Read in gram conversions for items measured by cup ('kapoaka')
u_kapoaka <- mahery_files %>%
  str_subset("utg_kapoaka") %>%
  read.csv() %>%
  mutate(FISHID = as.character(FISHID))

# Read in gram conversions for items measured by other units 
u_other <- mahery_files %>%
  str_subset("utg_other") %>%
  read.csv() %>%
  mutate(FISHID = as.character(FISHID))

# Read in gram conversions for items with no measurement unit
u_NA <- mahery_files %>%
  str_subset("utg_NA") %>%
  read.csv() %>%#[1:2,]
  slice(1:2) %>%
  mutate(FISHID = as.character(FISHID))


dar_hh_weekly_with_grams <- {
  x <- c(mahery_files, hh_weekly, hh_24_hr, fish_enc_g)
  tibble()
}
dar_hh_24_hr_with_grams <- {
  x <- c(mahery_files, hh_weekly, hh_24_hr, fish_enc_g)
  tibble()
}


tar_load(c(dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams), store = here("_targets"))

test_that("Testing Node(s): dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams", {

expect_true(exists("dar_hh_24_hr_with_grams"))
expect_true(exists("dar_hh_weekly_with_grams"))

expect_true(is.data.frame(dar_hh_24_hr_with_grams))
expect_true(is.data.frame(dar_hh_weekly_with_grams))

expect_false(nrow(dar_hh_24_hr_with_grams) > 0)
expect_false(nrow(dar_hh_weekly_with_grams) > 0)

})
