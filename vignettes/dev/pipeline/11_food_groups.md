

Add in food categories and subcategories for combined MAH, DAR, CRS
data, then examine average consumption by category-subcategory group

``` r
knitr::opts_chunk$set(eval = FALSE)
```

``` r
library(targets)
library(dplyr)
library(here)

devtools::load_all()
```

``` r
tar_load(
  c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  ), 
  store = here("_targets")
)
```

<!-- Data processing goes here... -->

``` r
crs_add_categ <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}

mah_dar_crs_hh_weekly_per_month_long <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}

mah_dar_crs_hh_groups_weekly_per_month_grams_categ_long <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}

mah_dar_crs_avg_consump_by_group <- {
  x <- c(
    mah_dar_crs_hh_weekly_per_month_wide, new_groups,
    crs_unique_foods
  )
  tibble()
}
```
