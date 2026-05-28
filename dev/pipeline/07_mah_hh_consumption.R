#' ---
#' ---
#' 

mah_load_data_targets <- list()


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
