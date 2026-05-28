#| sorting-hat: keep
library(dplyr)


library(readxl)
library(stringr)
library(here)


library(targets)


tar_load(
  c(
    mahery_files, darwin_pop, new_groups
  ),
  store = here("_targets")
)


ooh <- mahery_files %>%
  str_subset("MeasureSakafo") %>%
  read.csv() %>%
  select(-last_col())

clean_ooh <- mahery_files %>%
  str_subset("Out_of_household_unmatched_items_for_Chris_02.08.2024") %>%
  read_xlsx() %>%
  mutate(
    FoodName_Recoded = str_to_lower(FoodName_Recoded), 
    FoodName_Translated = str_to_lower(foodname_translated), 
    Action = str_to_lower(Action)
  )

amounts_ooh <- mahery_files %>%
  str_subset("ooh_indiv_amounts8Feb2024") %>%
  read_xlsx() %>%
  mutate(
    FoodName_Recoded = str_to_lower(FoodName_Recoded), 
    Amount = str_to_lower(Amount), 
    Action = str_to_lower(Action), 
    `New Notes` = str_to_lower(`New Notes`)
  )


dar_ooh_medicine_entries <- {
  x <- c(new_groups, ooh, clean_ooh, amounts_ooh)
  tibble()
}
dar_ooh_trad_medicine_entries <- {
  x <- c(new_groups, ooh, clean_ooh, amounts_ooh)
  tibble()
}
dar_ooh_indiv <- {
  x <- c(new_groups, ooh, clean_ooh, amounts_ooh)
  tibble()
}
dar_ooh_unique_foods <- {
  x <- c(new_groups, ooh, clean_ooh, amounts_ooh)
  tibble()
}
