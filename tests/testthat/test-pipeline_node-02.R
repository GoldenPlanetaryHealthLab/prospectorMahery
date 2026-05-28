#| sorting-hat: keep
library(dplyr)


library(stringr)
library(here)


library(targets)


tar_load(
  c(mahery_files, fish_enc_g),
  store = here("_targets")
)


hh_weekly <- mahery_files %>%
  str_subset("hh_weekly.csv") %>%
  read.csv() %>%
  select(-X)

hh_24_hr <- mahery_files %>%
  str_subset("hh_24_hr") %>%
  read.csv() %>%
  select(-X)


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


dar_hh_weekly_with_grams <- {
  x <- c(mahery_files, hh_weekly, hh_24_hr, fish_enc_g)
  tibble()
}
dar_hh_24_hr_with_grams <- {
  x <- c(mahery_files, hh_weekly, hh_24_hr, fish_enc_g)
  tibble()
}
