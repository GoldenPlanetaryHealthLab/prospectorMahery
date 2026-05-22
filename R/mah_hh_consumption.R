#===============================================================================
# Household Consumption MAHERY
# Author: SM Wu
# Date created: 2023/06/22
# Date updated: 2025/02/18
# Purpose: Clean MAHERY household dietary consumption data
# STEPS: 
# (1) Read in data
# (2) Update MAHERY data with new food groups
# (3) Calculate MAHERY daily, weekly, monthly, yearly, and weekly-per-month 
# consumption for each food
# (4) Calculate weekly and daily averages
# 
# Inputs:
#   Code:
#     "Combined/Code/cleaning_functions.R": Code with cleaning functions to help with recoding foods
#   Datasets:
#     "Data/MAHERY/mah_hh_dietary_intake.csv": MAHERY per-meal household consumption
#     "Data/MAHERY/mahery_metadata.xlsx": Metadata to match MAHERY columns to food names
#     "Data/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1.xlsx": New categories for all foods
#     "Cleaned_Data/DARWIN/dar_hh_weekly_per_month_grams_categs_long.csv": Darwin per-food entry data 
#     "Data/fish_enc_17Feb2025.csv": Updated fish encyclopedia  
#
# Outputs (number in parentheses indicates step in which it was generated):
#   Final outputs:
#     (2) "Cleaned_Data/MAHERY/mah_hh_per_meal_grams_categs_long.csv": MAHERY per-meal data with new food group categories
#     (3) "Cleaned_Data/MAHERY/mah_hh_per_meal_wide.csv": MAHERY per-meal household consumption for each food
#     (3) "Cleaned_Data/MAHERY/mah_hh_daily_wide.csv": MAHERY daily household consumption for each food
#     (3) "Cleaned_Data/MAHERY/mah_hh_weekly_wide.csv": MAHERY weekly household consumption for each food
#     (3) "Cleaned_Data/MAHERY/mah_hh_monthly_wide.csv": MAHERY monthly household consumption for each food
#     (3) "Cleaned_Data/MAHERY/mah_hh_yearly_wide.csv": MAHERY yearly household consumption for each food
#     (3) "Cleaned_Data/MAHERY/mah_hh_weekly_per_month_wide.csv": MAHERY weekly hh consump, measured per month, for each food
#     (4) "Cleaned_Data/MAHERY/mah_avg_hh_weekly_grams_categs_long.csv": Average 1-week consumption for each household
#     (4) "Cleaned_Data/MAHERY/mah_avg_hh_daily_grams_categs_long.csv": Average 1-day consumption for each household


#============== (1) Read in data ===============================================
library(tidyverse)        # for tidy data routines
library(magrittr)         # for efficient piping
library(readxl)           # for reading excel files

### Specify directories (change to your local paths)
# setwd("/Users/Stephanie/Documents/Github/madagascar_data_cleaning")
wd <- "/Users/Stephanie/Documents/Github/madagascar_data_cleaning/"  # Working directory
data_dir <- "Data/MAHERY/"  # Directory with data prior to cleaning
code_dir <- "Code/"  # Directory with code
res_dir <- "Cleaned_Data/MAHERY/"  # Directory to store cleaned results

# Read in cleaning functions
source(paste0(wd, code_dir, "cleaning_functions.R"))

# Read in previously cleaned MAHERY total consumption data
mah_hh_total <- read.csv(paste0(wd, data_dir, "mah_hh_dietary_intake.csv"))

# Read in MAHERY metadata
mah_meta <- read_excel(paste0(wd, data_dir, "mahery_metadata.xlsx"), sheet = 2)
mah_meta <- mah_meta %>%
  mutate(`Malagasy Name` = tolower(`Malagasy Name`))

# Read in updated food categories and subcategories for all distinct food items, 
# downloaded from source: https://docs.google.com/spreadsheets/d/1etaxo9hN3kCNDqS5GDdMyYLA0vKJcqb3aqbciFXkLYs/edit?gid=0#gid=0
# Note: older version of categorization was from "dar_mah_categs17Oct2023_CG.xlsx",
# which can be found in Combined/Data/Old_Data
new_groups <- read_xlsx(
  paste0(wd, "Data/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1.xlsx"),
  sheet = "ItemLevelMatches")
new_groups <- new_groups %>% 
  rename(FoodName_Recoded = `FoodName_Recoded NOT THE FINAL ONES - MUST GET`) %>%
  select(FoodName_Recoded, FoodName_Translated,
         Category, Subcategory) %>%
  mutate(FoodName_Recoded = gsub("cafe", "café", FoodName_Recoded))      
 
# Read in DARWIN data with new food groupings
hh_comb_groups <- read.csv(
  paste0(wd, "Cleaned_Data/DARWIN/dar_hh_weekly_per_month_grams_categs_long.csv"))

# Read in fish encyclopedia
fish_enc_g <- read.csv(paste0(wd, "Data/fish_enc_17Feb2025.csv")) %>% 
  rename(FISHID = FISH.ID) %>%
  mutate(FISHID = as.character(FISHID))


#================ (2) Update MAHERY data with new food groups ==================

# Keep general information and columns with the specific foods
mah_hh_total <- mah_hh_total %>%
  select(vh:all_foods_pc, agiv:zavok)

# Convert food columns to a variable of 'var_names' and their corresponding 
# weight in grams (long format)
mah_hh_long <- mah_hh_total %>%  # (~28 million entries)
  pivot_longer(  
    cols = agiv:zavok,
    names_to = "var_names",
    values_to = "wt_g")
# Drop rows with no consumption recorded
mah_hh_long <- mah_hh_long %>%  # 370987 obs
  filter(wt_g != 0)
# Match foods to their full names
mah_foods <- mah_hh_long %>%
  left_join(mah_meta %>% 
              select(Variable, `Malagasy Name`),
            by = join_by(var_names == Variable)) %>%
  rename(FoodName_Recoded = `Malagasy Name`)
# If no name, use var_name as recoded name
mah_foods <- mah_foods %>% 
  mutate(FoodName_Recoded = case_when(is.na(FoodName_Recoded) ~ var_names, 
         .default = FoodName_Recoded))

### Merge and standardize recoded and translated names 
# Remove extra whitespace from FoodName_Recoded
mah_foods$FoodName_Recoded <- gsub("\\s+", " ", mah_foods$FoodName_Recoded)
mah_foods$FoodName_Recoded <- trimws(mah_foods$FoodName_Recoded)

# Join by FoodName_Recoded and get FoodName_Translated, Category, Subcategory
mah_foods <- mah_foods %>%
  left_join(new_groups, join_by(FoodName_Recoded), 
            relationship = "many-to-one", unmatched = "drop")

# Fix FoodName_Recoded values
mah_foods <- fix_recoded(diet_df = mah_foods)
# Fix FoodName_Translated values
mah_foods <- fix_trans(diet_df = mah_foods)
# Fix makoba for fish
mah_foods <- fix_makoba(diet_df = mah_foods)
# Extract and remove medicines 
temp <- fix_med(diet_df = mah_foods)
mah_foods <- temp$diet_df
mah_foods_med <- temp$med_df
# Extract and remove traditional medicines
temp <- fix_trad_med(diet_df = mah_foods)
mah_foods <- temp$diet_df
mah_foods_trad_med <- temp$trad_med_df
# Remove erroneous entries, tobacco, measure words, and misc
mah_foods <- fix_remove(diet_df = mah_foods)

### Fill in missing translations
# If FoodName_Translated is NA, see if can fill in
# Original translations, keeping only the first in each group
old_trans <- hh_comb_groups %>% 
  select(FoodName_Recoded, FoodName_Translated) %>%
  mutate(FoodName_Translated = na_if(FoodName_Translated, "")) %>%
  drop_na(FoodName_Translated) %>%
  distinct() %>%
  group_by(FoodName_Recoded) %>%
  filter(row_number() == 1)
# Fill in translations using old translations
mah_foods <- mah_foods %>%
  rows_patch(old_trans, by = "FoodName_Recoded", unmatched = "ignore")
# Fill in translations using fish encyclopedia
mah_foods <- mah_foods %>%
  rows_patch(fish_enc_g %>% select(FoodName_Recoded, Common.Name) %>%
               drop_na() %>% distinct() %>%
               rename(FoodName_Translated = Common.Name) %>%
               group_by(`FoodName_Recoded`) %>% 
               filter(row_number() == 1), 
             by = "FoodName_Recoded", unmatched = "ignore") %>%
  rows_patch(fish_enc_g %>% select(FoodName_Recoded, ComName) %>%
               drop_na() %>% distinct() %>%
               rename(FoodName_Translated = ComName) %>%
               group_by(`FoodName_Recoded`) %>% 
               filter(row_number() == 1), 
             by = "FoodName_Recoded", unmatched = "ignore") %>%
  rows_patch(fish_enc_g %>% select(FoodName_Recoded, Scientific.name) %>%
               drop_na() %>% distinct() %>%
               rename(FoodName_Translated = Scientific.name) %>%
               group_by(`FoodName_Recoded`) %>% 
               filter(row_number() == 1), 
             by = "FoodName_Recoded", unmatched = "ignore")

# Fill in any remaining missing categories 
mah_foods <- mah_foods %>%
  rows_patch(new_groups, by = "FoodName_Recoded", unmatched = "ignore") %>%
  rename(grams = wt_g) %>%
  # Add column indicating source of grams is from mahery weighted data
  mutate(grams_source = "mahery")

# Drop unnecessary columns and reorder columns
mah_hh_comb_groups <- mah_foods %>%
  mutate(project = "mahery", 
         region = 1,
         proj_reg_vill_hh = 
           paste0(project, "_", region, "_", village, "_", household),
         hh_size = base_people) %>%
  arrange(project, region, village, household, hh_size, proj_reg_vill_hh, 
          year, month, week, day, meal, FoodName_Recoded) %>%
  select(project, region, village, household, hh_size, proj_reg_vill_hh, 
         year, month, week, day, meal, FoodName_Recoded, FoodName_Translated, 
         Category, Subcategory, var_names, grams)

# Check all categories and food names are filled in
temp <- mah_hh_comb_groups[is.na(mah_hh_comb_groups$Category), ]
temp <- mah_hh_comb_groups[is.na(mah_hh_comb_groups$FoodName_Recoded), ]


# # Save MAHERY household consumption with new food groups
# write.csv(mah_hh_comb_groups,
#           paste0(wd, res_dir, "mah_hh_per_meal_grams_categs_long.csv"),
#           row.names = FALSE)

    # # Detection of outliers
    # mah_large_wt <- mah_hh_comb_groups %>%
    #   arrange(grams) %>%
    #   filter(grams > 2000)
    # write.csv(mah_large_wt, paste0(wd, "Cleaned_Data/MAHERY/Intermediate_Outputs/", 
    #                                "mah_large_wt.csv"))

#========= (3) Calculate per-food daily, weekly, monthly, yearly consumption ===

# Subset to relevant columns
per_meal <- mah_hh_comb_groups %>% 
  select(project, region, village, household, hh_size, proj_reg_vill_hh, 
         year, month, week, day, meal, FoodName_Recoded, grams)
  # select(year, month, week, day, meal, village, household, date, base_people, 
  #        grams, FoodName_Recoded)
length(unique(mah_hh_comb_groups$FoodName_Recoded))  # 237 unique foods
    # # Duplicate weights -- use first entry
    # dupes <- per_meal %>%
    #   dplyr::group_by(year, month, week, day, meal, village, household, date,
    #                   base_people, FoodName_Recoded) %>%
    #   dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    #   dplyr::filter(n > 1L) 
# Widen data so each food has its own column
per_meal <- per_meal %>% 
  pivot_wider(
    names_from = "FoodName_Recoded",
    values_from = "grams", 
    values_fn = first)
# Order columns alphabetically
per_meal <- per_meal[, c(1:11, order(colnames(per_meal)[-c(1:11)]) + 11)]
# Add vill_hh column and order columns
mah_hh_per_meal <- per_meal %>%
  arrange(project, region, village, household, hh_size, proj_reg_vill_hh, 
          year, month, week, day, meal)
# Fill in NA's as 0's
mah_hh_per_meal <- mah_hh_per_meal %>% replace(is.na(.), 0)
# # Save MAHERY per-meal household assumption for each food
# write.csv(mah_hh_per_meal, paste0(wd, res_dir, "mah_hh_per_meal_wide.csv"),
#           row.names = FALSE)


# Save cleaned dataset of total daily household consumption for each food
mah_hh_daily <- mah_hh_per_meal %>% 
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           year, month, week, day) %>%
  summarise(across(agnambe:zavoka, sum))
# write.csv(mah_hh_daily, paste0(wd, res_dir, "mah_hh_daily_wide.csv"),
#           row.names = FALSE)

# Save cleaned dataset of total weekly household consumption for each food
mah_hh_weekly <- mah_hh_daily %>%
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           year, month, week) %>%
  summarise(across(agnambe:zavoka, sum))
# write.csv(mah_hh_weekly, paste0(wd, res_dir, "mah_hh_weekly_wide.csv"),
#           row.names = FALSE)

# Save cleaned dataset of total monthly household consumption for each food
mah_hh_monthly <- mah_hh_weekly %>%
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           year, month) %>%
  summarise(across(agnambe:zavoka, sum))
# write.csv(mah_hh_monthly, paste0(wd, res_dir, "mah_hh_monthly_wide.csv"),
#           row.names = FALSE)

# Save cleaned dataset of total annual household consumption
mah_hh_yearly <- mah_hh_monthly %>%
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           year) %>%
  summarise(across(agnambe:zavoka, sum))
# write.csv(mah_hh_yearly, paste0(wd, res_dir, "mah_hh_yearly_wide.csv"),
#           row.names = FALSE)

# Average across all weeks in each month to get weekly household consumption 
# that is measured on a monthly basis. For harmonization with Darwin and CRS
mah_hh_weekly_per_month <- mah_hh_weekly %>%
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           year, month) %>%
  summarise(across(agnambe:zavoka, mean))
# write.csv(mah_hh_weekly_per_month,
#           paste0(wd, res_dir, "mah_hh_weekly_per_month_wide.csv"),
#           row.names = FALSE)


#============== (4) Calculate weekly and daily averages ========================

# Get average 1-week consumption of food itmes across months, for each household 
avg_mah_hh <- mah_hh_comb_groups %>%
  # Get 1-week consumption by summing across meals and days
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           FoodName_Recoded, FoodName_Translated, Category, Subcategory,
           year, month, week) %>%
  summarise(grams = sum(grams, na.rm = TRUE), 
            .groups = "drop") %>%
  # Average across months
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           FoodName_Recoded, FoodName_Translated, Category, Subcategory) %>%
  summarise(avg_grams = mean(grams),
            .groups = "drop")
# # Save data
# write.csv(avg_mah_hh,
#           paste0(wd, res_dir, "mah_avg_hh_weekly_grams_categs_long.csv"),
#           row.names = FALSE)


# Get average 1-day consumption of food itmes across months, for each household.
avg_mah_hh_daily <- mah_hh_comb_groups %>%
  # Get 1-day consumption by summing across meals 
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           FoodName_Recoded, FoodName_Translated, Category, Subcategory,
           year, month, week, day) %>%
  summarise(grams = sum(grams, na.rm = TRUE), 
            .groups = "drop") %>%
  # Average across months
  group_by(project, region, village, household, hh_size, proj_reg_vill_hh, 
           FoodName_Recoded, FoodName_Translated, Category, Subcategory) %>%
  summarise(avg_grams = mean(grams),
            .groups = "drop")
# # Save data
# write.csv(avg_mah_hh_daily,
#           paste0(wd, res_dir, "mah_avg_hh_daily_grams_categs_long.csv"),
#           row.names = FALSE)



#============ Old code for consumption by food grouping ====================

# ### Notes on calculating total consumption
# # Since food categories are not disjoint, certain items can contribute to 
# # consumption for multiple categories (e.g., both all_vegetables and all_greens).
# # No items were classified under all_meat or all_misc.
# 
# # # Read in MAHERY dataset with new groupings
# # hh_comb_groups_mah <- read.csv(paste0(wd, res_dir, "hh_comb_groups_mah.csv"))[, -1]
# 
# # Fish groupings and other groupings
# groups_fish <- c("all_dried_freshwater", "all_dried_seafood", 
#                  "all_freshwater_fish", "all_seafood")  # 4 groups
# groups_no_fish <- setdiff(na.omit(
#   union(union(unique(new_groups$CATEG1), unique(new_groups$CATEG2)),
#         unique(new_groups$CATEG3))), c(groups_fish, "50/50"))  # 29 groups
# food_groups <- c(groups_no_fish, groups_fish)
# 
# ## Get daily household consumption
# # Initialize unique entries for year, month, week, day, village, household
# num_entries <- hh_comb_groups_mah %>% 
#   select(year, month, week, day, village, household) %>% 
#   arrange(year, month, week, day, village, household)
# num_entries <- unique(num_entries)
# date_cols <- ncol(num_entries)
# 
# # Initialize df of total household consumption 
# mah_hh_daily_groups <- as.data.frame(
#   matrix(NA, nrow = nrow(num_entries), 
#          ncol = date_cols + length(food_groups) + 1))
# colnames(mah_hh_daily_groups) <- c(colnames(num_entries), food_groups, "data_sources")
# mah_hh_daily_groups[, 1:date_cols] <- num_entries
# 
# 
# # Obtain total household consumption for each year, month, week, day, village, 
# # and household.
# # For each year-month-week-day-village-household combo, get total consumption
# for (i in 1:nrow(mah_hh_daily_groups)) {  
#   if (i %% 250 == 0) print(i)  # check progress
#   # All food entries for a given household and monthly survey
#   comb_i <- hh_comb_groups_mah %>% 
#     filter(year == mah_hh_daily_groups[i, "year"] &
#              month == mah_hh_daily_groups[i, "month"] &
#              week == mah_hh_daily_groups[i, "week"] &
#              day == mah_hh_daily_groups[i, "day"] &
#              village == mah_hh_daily_groups[i, "village"] &
#              household == mah_hh_daily_groups[i, "household"])
#   # Data sources with contributions to this combo's entries
#   mah_hh_daily_groups$data_sources[i] <- "hh_mahery"
#   
#   # For each food group, get total household consumption across the food items
#   for (g in 1:length(food_groups)) {
#     # Filter to consumption of foods in grouping g
#     group <- food_groups[g]
#     group_consump <- comb_i %>%
#       filter(CATEG1 == group | CATEG2 == group | CATEG3 == group)
#     
#     # If there are non-zero entries, calculate total consumption
#     if (nrow(group_consump) > 0) { 
#       
#       # Total consumption
#       consump <- sum(group_consump %>% select(grams), na.rm = TRUE)
#       mah_hh_daily_groups[i, date_cols + g] <- consump
#       
#       # If no consumption for this grouping, put 0
#     } else {  
#       mah_hh_daily_groups[i, date_cols + g] <- 0
#     }
#   }
# }
# 
# # Order columns alphabetically
# mah_hh_daily_groups <- mah_hh_daily_groups[, c(1:date_cols, 
#                                  order(colnames(mah_hh_daily_groups)[-c(1:date_cols)]) 
#                                  + date_cols)]
# 
# # Save cleaned dataset of total daily household consumption
# write.csv(mah_hh_daily_groups, paste0(wd, res_dir, "mah_hh_daily_groups.csv"),
#           row.names = FALSE)
# 
# # Save cleaned dataset of total weekly household consumption
# mah_hh_weekly_groups <- mah_hh_daily_groups %>%
#   group_by(year, month, week, village, household) %>%
#   summarise(across(all_alcohol:all_wild_birds, sum))
# mah_hh_weekly_groups$data_sources <- "hh_mahery"
# write.csv(mah_hh_weekly_groups, paste0(wd, res_dir, "mah_hh_weekly_groups.csv"),
#           row.names = FALSE)
# 
# # Save cleaned dataset of total monthly household consumption
# mah_hh_monthly_groups <- mah_hh_weekly_groups %>%
#   group_by(year, month, village, household) %>%
#   summarise(across(all_alcohol:all_wild_birds, sum))
# mah_hh_monthly_groups$data_sources <- "hh_mahery"
# write.csv(mah_hh_monthly_groups, paste0(wd, res_dir, "mah_hh_monthly_groups.csv"),
#           row.names = FALSE)
# 
# # Save cleaned dataset of total annual household consumption
# mah_hh_yearly_groups <- mah_hh_monthly_groups %>%
#   group_by(year, village, household) %>%
#   summarise(across(all_alcohol:all_wild_birds, sum))
# mah_hh_yearly_groups$data_sources <- "hh_mahery"
# write.csv(mah_hh_yearly_groups, paste0(wd, res_dir, "mah_hh_yearly_groups.csv"),
#           row.names = FALSE)
# 
# ### Match to DARWIN data: average across all weeks in each month to get weekly 
# ### household consumption that is measured on a monthly basis
# mah_hh_weekly_per_month_groups <- mah_hh_weekly_groups %>%
#   group_by(year, month, village, household) %>%
#   summarise(across(all_alcohol:all_wild_birds, mean))
# mah_hh_yearly_groups$data_sources <- "hh_mahery"
# write.csv(mah_hh_weekly_per_month_groups,
#           paste0(wd, res_dir, "mah_hh_weekly_per_month_groups.csv"),
#           row.names = FALSE)
