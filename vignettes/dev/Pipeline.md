# MAHERY Pipeline
Tinashe M. Tapera

Here we document, create, and run the pipeline all in one file thanks to
Quarto and `targets`.

For the backend, we’ll use this Quarto notebook as the “orchestrator,”
meaning that the pipeline runs any time this notebook is
executed/rendered. First, let’s get the script files from the inputs
directory:

``` r
devtools::load_all()
```

    ℹ Loading prospectorMahery

``` r
library(stringr)
library(testthat)
library(dplyr)
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
library(yaml)
library(purrr)
library(here)
```

    here() starts at /work

``` r
library(targets)
```

The inputs were provided by stagecoach. The manifest for the stagecoach
run is in `stagecoach_manifest.yml` if you want to check it out.

``` r
manifest <- here("stagecoach_manifest.yml")
```

``` r
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
```

It looks like MAHERY only has an individual cleaning script, meaning we
can turnover this project pretty quickly.

First, we unzip the data that is relevant to this pipeline:

``` r
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
```

``` r
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
```

The rest of the nodes of the pipeline dag are defined according to the
expectations laid out in the original R scripts.

## Darwin

There are 3 scripts that pertain to data from the Darwin project, AKA
MAHERY-Antongil:

> Golden CD, Borgerson C, Rice BL, Allen LH, Anjaranirina EJG, Barrett
> CB, Boateng G, Gephart JA, Hampel D, Hartl DL, Knippenberg E, Myers
> SS, Ralalason DH, Ramihantaniarivo H, Randriamady H, Shahab-Ferdows S,
> Vaitla B, Volkman SK, Vonona MA. Cohort Description of the Madagascar
> Health and Environmental Research-Antongil (MAHERY-Antongil) Study in
> Madagascar. Front Nutr. 2019 Jul 19;6:109. doi:
> 10.3389/fnut.2019.00109. PMID: 31428615; PMCID: PMC6690017.

Our first expected output is `dar_hh_fish_with_grams_no_weekly`, while
the inputs are the raw files `fish_enc_17Feb2025.csv`,
`Laoko_Mar_10_2021.csv`, `all_fish_ID_7_22.csv`

We can insert our first `tar_load()` here to check that the output from
the first stage of the pipeline is what we expect. If this runs without
error, then we know that the first stage of the pipeline is working as
expected and we can move on to the second stage. Essentially, we’re
implementing test-driven development (TDD) in our notebook workflow!

``` r
tar_load(dar_hh_fish_with_grams_no_weekly, store = here("_targets"))

test_that("Testing Node: dar_hh_fish_with_grams_no_weekly", {

expect_true(exists("dar_hh_fish_with_grams_no_weekly"))
expect_true(is.data.frame(dar_hh_fish_with_grams_no_weekly))
expect_false(nrow(dar_hh_fish_with_grams_no_weekly) > 0)

})
```

    Test passed with 3 successes 🥳.

Next, we expect 2 outputs from the second stage Darwin script:
`dar_hh_weekly_with_grams` and `dar_hh_24_hr_with_grams`.

``` r
tar_load(c(dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams), store = here("_targets"))

test_that("Testing Node(s): dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams", {

expect_true(exists("dar_hh_24_hr_with_grams"))
expect_true(exists("dar_hh_weekly_with_grams"))

expect_true(is.data.frame(dar_hh_24_hr_with_grams))
expect_true(is.data.frame(dar_hh_weekly_with_grams))

expect_false(nrow(dar_hh_24_hr_with_grams) > 0)
expect_false(nrow(dar_hh_weekly_with_grams) > 0)

})
```

    Test passed with 6 successes 🥳.
