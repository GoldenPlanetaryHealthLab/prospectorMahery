

# Read in data

First, we read in all of the libraries and functions

Load the `targets` store:

``` r
mah_load_data_targets <- list()
```

Read in previously cleaned MAHERY total consumption data:

This would be better off as a tibble for convenience:

``` r
mah_load_data_targets <- append(
  mah_load_data_targets,
  tar_target(
    mah_hh_total,
    command = {
      mah_hh_total <- mahery_files %>%
        str_subset("mah_hh_dietary_intake.csv") %>%
        read.csv() %>%
        tibble()
    }
  )
)
```

Read in MAHERY metadata

Looks good, add it to the targets:

``` r
mah_load_data_targets <- append(
  mah_load_data_targets,
  tar_target(
    mah_meta,
    command = {
      mah_meta <- mahery_files %>% 
        str_subset("mahery_metadata.xlsx") %>%
        read_excel(., sheet = 2) %>%
        mutate(`Malagasy Name` = tolower(`Malagasy Name`))
    }
  )
)
```

Read in updated food categories and subcategories for all distinct food
items, downloaded from source:
https://docs.google.com/spreadsheets/d/1etaxo9hN3kCNDqS5GDdMyYLA0vKJcqb3aqbciFXkLYs/edit?gid=0#gid=0
Note: older version of categorization was from
“dar_mah_categs17Oct2023_CG.xlsx”, which can be found in
Combined/Data/Old_Data

Add to targets:

``` r
mah_load_data_targets <- append(
  mah_load_data_targets,
  tar_target(
    new_groups,
    command = {
      mahery_files %>%
        str_subset(
          "MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1.xlsx"
        ) %>%
        read_xlsx(., sheet = "ItemLevelMatches") %>%
        rename(FoodName_Recoded = `FoodName_Recoded NOT THE FINAL ONES - MUST GET`) %>%
        select(FoodName_Recoded, FoodName_Translated,
               Category, Subcategory) %>%
        mutate(FoodName_Recoded = gsub("cafe", "café", FoodName_Recoded))
    }
  )
)
```

Read in DARWIN data with new food groupings

Add to targets:

``` r
mah_load_data_targets <- append(
  mah_load_data_targets,
  tar_target(
    food_groupings,
    command = {
      hh_comb_groups <- mahery_files %>%
        str_subset("dar_hh_weekly_per_month_grams_categs_long.csv") %>%
        read.csv() %>%
        tibble()
    }
  )
)
```

# Script file

The code for this document can be found here:

- [07_mah_hh_consumption.R](07_mah_hh_consumption.R)
