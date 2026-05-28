

Combine all MAHERY, DARWIN, and CRS household weekly dietary consumption
data. 0 means no consumption; NA’s where food was not captured in that
dataset are converted to 0’s. Note: CRS was captured as individual
24-hour recall data and converted to weekly household intake.

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
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  ), 
  store = here("_targets")
)
```

<!-- Data processing goes here... -->

``` r
mah_dar_crs_hh_weekly_per_month_wide <- {
  x <- c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  )
  tibble()
}

mah_dar_crs_avg_hh_weekly_grams_categs_long <- {
  x <- c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  )
  tibble()
}

mah_dar_crs_avg_hh_daily_grams_categs_long <- {
  x <- c(
    mah_hh_weekly_per_month_wide, dar_hh_weekly_per_month_wide,
    crs_hh_weekly_per_month_wide, mah_avg_hh_weekly_grams_categs_long,
    dar_avg_hh_weekly_grams_categs_long, crs_hh_weekly_grams_categs_long,
    mah_avg_hh_daily_grams_categs_long, dar_avg_hh_daily_grams_categs_long,
    crs_hh_daily_grams_categs_long
  )
  tibble()
}
```
