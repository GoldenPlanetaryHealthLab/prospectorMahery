

At this stage, the purpose is to obtain total household 1-week
consumption of fish foods for DARWIN. Total fish consumption is
calculated using the fish recall, with the addition of certain fish
captured using the weekly recall (see node (2)).

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
  c(mahery_files, dar_hh_weekly_with_grams, hh_fish),
  store = here("_targets")
)
```

``` r
new_groups <- mahery_files %>%
  str_subset(
    "MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1"
  ) %>%
  read_xlsx(sheet = "ItemLevelMatches") %>%
  rename(FoodName_Recoded = `FoodName_Recoded NOT THE FINAL ONES - MUST GET`) %>%
  select(FoodName_Recoded, FoodName_Translated,
         Category, Subcategory) %>%
  mutate(FoodName_Recoded = str_replace(FoodName_Recoded, "cafe", "café"))

darwin_pop <- mahery_files %>%
  str_subset("darwin_pop") %>%
  read.csv()
```

<!-- Data processing goes here... -->

Final targets for this step:

``` r
dar_hh_weekly_per_month_fish_grams_categs_long <- {
  x <- c(mahery_files, dar_hh_weekly_with_grams, hh_fish, darwin_pop, new_groups)
  tibble()
}
dar_hh_weekly_per_month_fish_wide <- {
  x <- c(mahery_files, dar_hh_weekly_with_grams, hh_fish, darwin_pop, new_groups)
  tibble()
}
```
