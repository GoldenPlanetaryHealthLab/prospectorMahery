

This notebook cleans CRS individual dietary consumption data

``` r
library(dplyr)        # for tidy data routines #TODO slim this down
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
library(readxl)           # for reading excel files
library(stringr)
library(here)
```

    here() starts at /work

``` r
devtools::load_all()
```

    ℹ Loading prospectorMahery

Load the `targets` store:

``` r
library(targets)
tar_load(
  c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  ), 
  store = here("_targets")
)
```

Read in previously cleaned MAHERY total consumption data:

``` r
crs_raw <- mahery_files %>%
  str_subset("Survey_Data_Adults_All_Merged.csv") %>%
  read.csv() %>%
  tibble()

crs_meta <- mahery_files %>% 
  str_subset("Metadata_Adults 20180128.csv") %>%
  read.csv() %>%
  tibble()

crs_changes <- mahery_files %>%
  str_subset("CRS_fuzzy_match_to_DAR_for_weights.xlsx") %>%
  read_xlsx() %>%
  tibble()
```

    New names:
    • `New in CRS?` -> `New in CRS?...14`
    • `New in CRS?` -> `New in CRS?...15`

<!-- Data processing goes here... -->

Final targets for this step:

``` r
crs_names_units <- {
  x <- c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  )
  tibble()
}
crs_written_foods <- {
  x <- c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  )
  tibble()
}
crs_24h_amounts_units <- {
  x <- c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  )
  tibble()
}
crs_food_freq <- {
  x <- c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  )
  tibble()
}
crs_unique_foods <- {
  x <- c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  )
  tibble()
}

crs_indiv_daily_grams_categs_long <- {
  x <- c(
    u_isany, u_kapoaka, u_other, u_NA,
    new_groups, mahery_files, mah_foods_avg
  )
  tibble()
}
```
