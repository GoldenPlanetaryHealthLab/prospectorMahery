# Update MAHERY Food Groups


In the second stage of the pipeline, we’re following the scripts and
updating the food groups.

``` r
update_groups_targets <- list()
```

Keep general information and columns with the specific foods:

Drop rows with no consumption recorded

``` r
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
```

Match foods to their full names (new target created here)

Next, merge and standardize recoded and translated names, which includes
removing extra whitespace from `FoodName_Recoded`:

Join by FoodName_Recoded and get FoodName_Translated, Category,
Subcategory

We can put a stake in the pipeline here for a new target:

``` r
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
```

Now, we need to do some spot fixes on the names; fortunately these are
all pre-registered functions:

# Fix FoodName_Recoded values

``` r
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
```

Fill in missing translations

If FoodName_Translated is NA, see if can fill in original translations,
keeping only the first in each group

``` r
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
```

# Fill in translations using old translations

mah_foods \<- mah_foods %\>% rows_patch(old_trans, by =
“FoodName_Recoded”, unmatched = “ignore”) \# Fill in translations using
fish encyclopedia mah_foods \<- mah_foods %\>% rows_patch(fish_enc_g
%\>% select(FoodName_Recoded, Common.Name) %\>% drop_na() %\>%
distinct() %\>% rename(FoodName_Translated = Common.Name) %\>%
group_by(`FoodName_Recoded`) %\>% filter(row_number() == 1), by =
“FoodName_Recoded”, unmatched = “ignore”) %\>% rows_patch(fish_enc_g
%\>% select(FoodName_Recoded, ComName) %\>% drop_na() %\>% distinct()
%\>% rename(FoodName_Translated = ComName) %\>%
group_by(`FoodName_Recoded`) %\>% filter(row_number() == 1), by =
“FoodName_Recoded”, unmatched = “ignore”) %\>% rows_patch(fish_enc_g
%\>% select(FoodName_Recoded, Scientific.name) %\>% drop_na() %\>%
distinct() %\>% rename(FoodName_Translated = Scientific.name) %\>%
group_by(`FoodName_Recoded`) %\>% filter(row_number() == 1), by =
“FoodName_Recoded”, unmatched = “ignore”)

# Fill in any remaining missing categories

mah_foods \<- mah_foods %\>% rows_patch(new_groups, by =
“FoodName_Recoded”, unmatched = “ignore”) %\>% rename(grams = wt_g) %\>%
\# Add column indicating source of grams is from mahery weighted data
mutate(grams_source = “mahery”)

# Drop unnecessary columns and reorder columns

mah_hh_comb_groups \<- mah_foods %\>% mutate(project = “mahery”, region
= 1, proj_reg_vill_hh = paste0(project, “*”, region, ”*”, village, “\_“,
household), hh_size = base_people) %\>% arrange(project, region,
village, household, hh_size, proj_reg_vill_hh, year, month, week, day,
meal, FoodName_Recoded) %\>% select(project, region, village, household,
hh_size, proj_reg_vill_hh, year, month, week, day, meal,
FoodName_Recoded, FoodName_Translated, Category, Subcategory, var_names,
grams)

# Check all categories and food names are filled in

temp \<- mah_hh_comb_groups\[is.na(mah_hh_comb_groups$Category), ]
temp <- mah_hh_comb_groups[is.na(mah_hh_comb_groups$FoodName_Recoded),
\]

# \# Save MAHERY household consumption with new food groups

# write.csv(mah_hh_comb_groups,

# paste0(wd, res_dir, “mah_hh_per_meal_grams_categs_long.csv”),

# row.names = FALSE)

    # # Detection of outliers
    # mah_large_wt <- mah_hh_comb_groups %>%
    #   arrange(grams) %>%
    #   filter(grams > 2000)
    # write.csv(mah_large_wt, paste0(wd, "Cleaned_Data/MAHERY/Intermediate_Outputs/", 
    #                                "mah_large_wt.csv"))
