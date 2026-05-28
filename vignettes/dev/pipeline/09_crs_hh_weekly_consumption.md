

Convert CRS individual dietary consumption data to household consumption

``` r
library(targets)
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

``` r
devtools::load_all()
```

    ℹ Loading prospectorMahery

``` r
tar_load(
  c(
    crs_indiv_daily_grams_categs_long
  ), 
  store = here("_targets")
)
```

<!-- Data processing goes here... -->

``` r
crs_hh_daily_grams_categs_long <- {
  x <- c(
    crs_indiv_daily_grams_categs_long
  )
  tibble()
}

crs_hh_weekly_grams_categs_long <- {
  x <- c(
    crs_indiv_daily_grams_categs_long
  )
  tibble()
}

crs_hh_weekly_per_month_wide <- {
  x <- c(
    crs_indiv_daily_grams_categs_long
  )
  tibble()
}
```
