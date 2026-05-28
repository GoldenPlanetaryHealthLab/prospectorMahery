

In this step, we’ll obtain total household 1-week consumption of
non-fish foods for DARWIN. Total non-fish consumption is calculated
using only the weekly recall.

``` r
#| sorting-hat: keep
library(dplyr)
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
library(readxl)
library(stringr)
library(here)
```

    here() starts at /work

``` r
library(targets)
```

Load raw file paths, fish encyclopedia, which includes unique fish ids
with taxonomic information and weights obtained from CPUE and
FishBase/SeaLifeBase:

``` r
tar_load(
  c(
    new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long,
    dar_hh_weekly_per_month_fish_wide
  ),
  store = here("_targets")
)
```

<!-- Data processing goes here... -->

Final targets for this step:

``` r
dar_hh_comb_groups_with_24h <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_hh_weekly_per_month_grams_categs_long <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_hh_weekly_per_month_non_fish_wide <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_hh_weekly_per_month_wide <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_avg_hh_weekly_grams_categs_long <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
dar_avg_hh_daily_grams_categs_long <- {
  x <- c(new_groups, fish_enc_g, darwin_pop,
    dar_hh_weekly_with_grams, dar_hh_24_hr_with_grams,
    dar_hh_weekly_per_month_fish_grams_categs_long, dar_hh_weekly_per_month_fish_wide)
  tibble()
}
```
