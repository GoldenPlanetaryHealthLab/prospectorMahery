

First, we read in all of the libraries and functions

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
library(purrr)             
devtools::load_all()
```

    ℹ Loading prospectorMahery

Load the `targets` store:

``` r
library(targets)
tar_load(
  c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  ), 
  store = here("_targets")
)
```

Read in previously cleaned MAHERY total consumption data:

``` r
mah_hh_total <- mahery_files %>%
  str_subset("mah_hh_dietary_intake.csv") %>%
  read.csv() %>%
  tibble()

mah_meta <- mahery_files %>% 
  str_subset("mahery_metadata.xlsx") %>%
  read_excel(., sheet = 2) %>%
  mutate(`Malagasy Name` = tolower(`Malagasy Name`))
```

    New names:
    • `` -> `...7`
    • `` -> `...8`

<!-- Data processing goes here... -->

Final targets for this step:

``` r
mah_hh_per_meal_grams_categs_long <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_hh_per_meal_wide <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_hh_daily_wide <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_hh_weekly_wide <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_hh_monthly_wide <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_hh_yearly_wide <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_hh_weekly_per_month_wide <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_avg_hh_weekly_grams_categs_long <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
mah_avg_hh_daily_grams_categs_long <- {
  x <- c(
    mahery_files, new_groups, fish_enc_g,
    dar_hh_weekly_per_month_grams_categs_long
  )
  tibble()
}
```
