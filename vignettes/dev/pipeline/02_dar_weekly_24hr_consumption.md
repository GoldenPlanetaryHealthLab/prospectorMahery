

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
  c(mahery_files, fish_enc_g),
  store = here("_targets")
)
```

``` r
hh_weekly <- mahery_files %>%
  str_subset("hh_weekly.csv") %>%
  read.csv() %>%
  select(-X)

hh_24_hr <- mahery_files %>%
  str_subset("hh_24_hr") %>%
  read.csv() %>%
  select(-X)
```

Read in Mahery average food weights per meal

``` r
mah_foods_avg <- mahery_files %>%
  str_subset("mah_foods_avg") %>%
  read.csv() %>%
  select(-X) %>%
  rename("Malagasy Name" = "Malagasy.Name", "English Name" = "English.Name") %>%
  mutate(
    dar_name = replace_when(
      dar_name, var_names == "mavon" ~ "mavondro"
    )
  )
```

Read in gram unit conversion files:

``` r
u_isany <- mahery_files %>%
  str_subset("utg_isany") %>%
  read.csv() %>%
  mutate(
    FISHID = as.character(FISHID), 
    CookingMethod2 = as.character(CookingMethod2)
  )
# Read in gram conversions for items measured by cup ('kapoaka')
u_kapoaka <- mahery_files %>%
  str_subset("utg_kapoaka") %>%
  read.csv() %>%
  mutate(FISHID = as.character(FISHID))

# Read in gram conversions for items measured by other units 
u_other <- mahery_files %>%
  str_subset("utg_other") %>%
  read.csv() %>%
  mutate(FISHID = as.character(FISHID))

# Read in gram conversions for items with no measurement unit
u_NA <- mahery_files %>%
  str_subset("utg_NA") %>%
  read.csv() %>%#[1:2,]
  slice(1:2) %>%
  mutate(FISHID = as.character(FISHID))
```

<!-- Data processing goes here... -->

Final targets for this step:

``` r
dar_hh_weekly_with_grams <- {
  x <- c(mahery_files, hh_weekly, hh_24_hr, fish_enc_g)
  tibble()
}
dar_hh_24_hr_with_grams <- {
  x <- c(mahery_files, hh_weekly, hh_24_hr, fish_enc_g)
  tibble()
}
```
