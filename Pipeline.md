# MAHERY Pipeline


Here we document, create, and run the pipeline all in one file thanks to
Quarto and the [`bakepipe`
package](https://vangberg.github.io/bakepipe/index.html). `bakepipe` is
a package by Harrry Vangberg that I stumbled across online, built to
facilitate simpler, more script-focused, and less involved reproducible
pipelines. While it is driven by `targets` under the hood, it is much
more lightweight and is intended for ease of use and simplicity — ideal
for scenarios like this where you have been given a batch of scripts and
just want to run them in a pipeline without having to deliberately
refactor them into a more `targets`-like structure.

See [here](https://vangberg.github.io/bakepipe/index.html#motivation)
for more info on `bakepipe`.

To set up a pipeline with `bakepipe`, you just need to have a
`_bakepipe.R` file in your project. This tells `bakepipe` to scaffold
all of the targets stuff in the background for you. Then in each of your
scripts, simply register (in a Make-like, or even more familiar,
snakemake-like way) the input and output files respectively. `bakepipe`
will then figure out the dependencies and build the DAG for you.

Because it is so simple, `bakepipe` is ideal for quick pipelines that
are just IO, no fancy stuff.

For the backend, we’ll use this Quarto notebook as the “orchestrator,”
meaning that the pipeline runs any time this notebook is
executed/rendered. First, let’s get the script files from the inputs
directory:

``` r
library(prospectorMahery)
library(here)
```

    here() starts at /n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery

The inputs were provided by stagecoach. The manifest for the stagecoach
run is in `stagecoach_manifest.yaml` if you want to check it out.

``` r
repo_files <- register_inputs(
  here(
    "data", 
    "inputs", 
    "01_gold_mine", 
    "madagascar-cohort-data-zip/madagascar_data_cleaning-main.zip"
    ),
  regex = "Data\\/MAHERY"
  )
repo_files
```

     [1] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/"                                                                           
     [2] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/Intermediate_Outputs/"                                                      
     [3] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/Intermediate_Outputs/mah_large_wt.csv"                                      
     [4] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_avg_hh_daily_grams_categs_long.csv"                                     
     [5] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_avg_hh_weekly_grams_categs_long.csv"                                    
     [6] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_daily_wide.csv"                                                      
     [7] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_monthly_wide.csv"                                                    
     [8] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_per_meal_grams_categs_long.csv"                                      
     [9] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_per_meal_wide.csv"                                                   
    [10] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_weekly_per_month_wide.csv"                                           
    [11] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_weekly_wide.csv"                                                     
    [12] "madagascar_data_cleaning-main/Cleaned_Data/MAHERY/mah_hh_yearly_wide.csv"                                                     
    [13] "madagascar_data_cleaning-main/Data/MAHERY/"                                                                                   
    [14] "madagascar_data_cleaning-main/Data/MAHERY/mah_foods_avg.csv"                                                                  
    [15] "madagascar_data_cleaning-main/Data/MAHERY/mah_hh_dietary_intake.csv"                                                          
    [16] "madagascar_data_cleaning-main/Data/MAHERY/mahery_metadata.xlsx"                                                               
    [17] "madagascar_data_cleaning-main/Data/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1.xlsx"          
    [18] "madagascar_data_cleaning-main/Data/Old_Data/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2024Jul2.xlsx" 
    [19] "madagascar_data_cleaning-main/Data/Old_Data/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2024Jun10.xlsx"
    [20] "madagascar_data_cleaning-main/Data/Old_Data/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2024Jun20.xlsx"
    [21] "madagascar_data_cleaning-main/Data/Old_Data/MAHERY_DARWIN_Matching_AllUniqueFoods_to_Nutritional_Equivalents2024May31.xlsx"   

It looks like MAHERY only has an individual cleaning script, meaning we
can turnover this project pretty quickly.

Here’s the preamble from the previous script:

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

We can use multiple notebooks to orchestrate the pipeline. First, we’ll
introduce a notebook for cleaning the data:

## Pipeline Run

``` r
library(bakepipe)
```

We can check the status of the pipeline with `bakepipe::status()`:

``` r
status()
```

Finally, we run the pipeline with `bakepipe::run()`

``` r
run()
```
