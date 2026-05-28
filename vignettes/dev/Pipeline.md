# MAHERY Pipeline


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
library(here)
```

    here() starts at /work

The inputs were provided by stagecoach. The manifest for the stagecoach
run is in `stagecoach_manifest.yml` if you want to check it out.

``` r
manifest <- here("stagecoach_manifest.yml")
```

``` r
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
```

It looks like MAHERY only has an individual cleaning script, meaning we
can turnover this project pretty quickly.

First, we unzip the data that is relevant to this pipeline:

``` r
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
```

``` r
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

### Fish Consumption

First we read in the

``` r
knitr::opts_chunk$set(eval = FALSE)
```

``` r
#| sorting-hat: keep
library(dplyr)
library(here)
library(targets)
```

``` r
#| sorting-hat: keep
dar_hh_fish_with_grams_no_weekly <- {
  x <- mahery_files
  tibble()
}
```

We can insert our first `tar_load()` here to check that the output from
the first stage of the pipeline is what we expect. If this runs without
error, then we know that the first stage of the pipeline is working as
expected and we can move on to the second stage. Essentially, we’re
implementing test-driven development (TDD) in our notebook workflow!

``` r
tar_load(dar_hh_fish_with_grams_no_weekly)

test_that("Testing Node: dar_hh_fish_with_grams_no_weekly", {

expect_true(exists("dar_hh_fish_with_grams_no_weekly"))
expect_true(is.data.frame(dar_hh_fish_with_grams_no_weekly))
expect_false(nrow(dar_hh_fish_with_grams_no_weekly) > 0)

})
```

Next, we expect 2 outputs from the second stage Darwin script:
`dar_hh_weekly_with_grams` and `dar_hh_24_hr_with_grams`.

``` r
library(dplyr)
```

``` r
dar_hh_weekly_with_grams <- tibble()
dar_hh_24_hr_with_grams <- tibble()
```

``` r
tar_load(c(dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams))

test_that("Testing Node(s): dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams", {

expect_true(exists("dar_hh_24_hr_with_grams"))
expect_true(exists("dar_hh_weekly_with_grams"))

expect_true(is.data.frame(dar_hh_24_hr_with_grams))
expect_true(is.data.frame(dar_hh_weekly_with_grams))

expect_false(nrow(dar_hh_24_hr_with_grams) > 0)
expect_false(nrow(dar_hh_weekly_with_grams) > 0)

})
```

# Script file

The code for this document can be found here:

- [Pipeline.R](Pipeline.R)
