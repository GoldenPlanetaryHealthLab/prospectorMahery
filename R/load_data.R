library(prospectorMahery)
library(bakepipe)
library(stringr)
library(here)


library(dplyr)


library(readr)
library(readxl)


wd <- here()
inputs_dir <- file.path(wd, "data", "inputs", "01_gold_mine", "madagascar-cohort-data-zip")
code_dir <- file.path(wd, "R")
results_dir <- file.path(wd, "data", "outputs")


repo_files <- register_inputs(
    file.path(inputs_dir, "madagascar_data_cleaning-main.zip"),
    regex = "Data\\/MAHERY"
  )


target_file <- "mah_hh_dietary_intake.csv"
mah_hh_total_f <- repo_files %>%
    str_subset(target_file)

mah_hh_total_f %>%
    unzip(file.path(inputs_dir, "madagascar_data_cleaning-main.zip"), exdir = inputs_dir, files = ., junkpaths = TRUE)
infile <- file.path(inputs_dir, target_file)

if(!file.exists(infile)) {
    stop("File does not exist.")
}

if(infile != "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mah_hh_dietary_intake.csv") {
    stop("File path does not match expected path.")
}

mah_hh_total <- external_in("/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mah_hh_dietary_intake.csv") %>%
    read_csv(.)
