#| sorting-hat: keep
library(dplyr)


library(readxl)
library(stringr)
library(here)


library(targets)


tar_load(
  c(mahery_files, dar_hh_weekly_with_grams, hh_fish),
  store = here("_targets")
)


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


dar_hh_weekly_per_month_fish_grams_categs_long <- {
  x <- c(mahery_files, dar_hh_weekly_with_grams, hh_fish, darwin_pop, new_groups)
  tibble()
}
dar_hh_weekly_per_month_fish_wide <- {
  x <- c(mahery_files, dar_hh_weekly_with_grams, hh_fish, darwin_pop, new_groups)
  tibble()
}
