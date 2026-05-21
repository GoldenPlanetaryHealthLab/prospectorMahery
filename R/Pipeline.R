library(prospectorMahery)
library(here)


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
