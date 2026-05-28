

In this step, we’ll obtain total out-of-household 1-week consumption for
DARWIN. Household totals are obtained by combining all individuals in
each household.

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

Load raw file paths and dependencies:

``` r
tar_load(
  c(
    fish_enc_g, mah_foods_avg, dar_ooh_indiv,
    u_isany, u_kapoaka, u_other, u_NA
  ),
  store = here("_targets")
)
```

<!-- Data processing goes here... -->

Final targets for this step:

``` r
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
```
