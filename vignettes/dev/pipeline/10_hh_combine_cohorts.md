

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

tar_load(
  c(mahery_files),
  store = here("_targets")
)
```

``` r
#| sorting-hat: keep
dar_hh_fish_with_grams_no_weekly2 <- {
  x <- mahery_files
  tibble()
}
```

``` r
#| sorting-hat: remove
dar_hh_fish_with_grams_no_weekly <- tibble()
```

# Script file

The code for this document can be found here:

- [10_hh_combine_cohorts.R](10_hh_combine_cohorts.R)
