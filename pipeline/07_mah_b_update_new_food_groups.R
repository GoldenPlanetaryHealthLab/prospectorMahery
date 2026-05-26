update_groups_targets <- list()


update_groups_targets <- append(
  update_groups_targets,
  tar_target(
    mah_hh_long,
    command = {
      mah_hh_total %>%
        pivot_longer(  
          cols = agiv:zavok,
          names_to = "var_names",
          values_to = "wt_g") %>%
        filter(wt_g != 0)
    }
  )
)


update_groups_targets <- append(
  update_groups_targets,
  tar_target(
    mah_foods,
    command = {
      mah_hh_long %>%
        left_join(mah_meta %>% 
            select(Variable, `Malagasy Name`),
            by = join_by(var_names == Variable)) %>%
        rename(FoodName_Recoded = `Malagasy Name`) %>%
        mutate(FoodName_Recoded = case_when(is.na(FoodName_Recoded) ~ var_names, 
            .default = FoodName_Recoded)) %>%
        mutate(
          FoodName_Recoded = gsub("\\s+", " ", FoodName_Recoded),
          FoodName_Recoded = trimws(FoodName_Recoded)
        ) %>%
        left_join(new_groups, join_by(FoodName_Recoded), 
                  relationship = "many-to-one", unmatched = "drop")
    }
  )
)


update_groups_targets <- append(
  update_groups_targets,
  tar_target(
    mah_foods_fixed,
    command = {
      mah_foods %>%
        fix_recoded() %>%
        fix_trans() %>%
        fix_makoba() %>%
        # fix_med() %>%
        # fix_trad_med() %>%
        fix_remove()
    }
  )
)


# update_groups_targets <- append(
#   update_groups_targets,
#   tar_target(
#     old_trans,
#     command = {
#       hh_comb_groups %>% 
#         select(FoodName_Recoded, FoodName_Translated) %>%
#         mutate(FoodName_Translated = na_if(FoodName_Translated, "")) %>%
#         drop_na(FoodName_Translated) %>%
#         distinct() %>%
#         group_by(FoodName_Recoded) %>%
#         filter(row_number() == 1)
#     }
#   )
# )
