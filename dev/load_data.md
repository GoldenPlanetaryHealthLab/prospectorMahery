# Load MAHERY Data


This is a simple notebook that documents the “load data” step. The code
chunks get exported to a script which is then run as part of the
pipeline by `bakepipe`.

``` r
devtools::load_all(".")
```

    ℹ Loading prospectorMahery

``` r
library(bakepipe)
library(stringr)
library(here)
```

    here() starts at /n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery

``` r
library(dplyr)
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
library(readr)
```


    Attaching package: 'readr'

    The following objects are masked from 'package:testthat':

        edition_get, local_edition

``` r
library(readxl)
```

Setting up directories now relies on the `here` package:

``` r
wd <- here()
inputs_dir <- file.path(wd, "data", "inputs", "01_gold_mine", "madagascar-cohort-data-zip")
code_dir <- file.path(wd, "R")
results_dir <- file.path(wd, "data", "outputs")
```

To load in the data, we register the input file with `bakepipe` by using
the `external_in` function:

``` r
repo_files <- register_inputs(
    file.path(inputs_dir, "madagascar_data_cleaning-main.zip"),
    regex = "Data\\/MAHERY"
  )
```

`bakepipe` only accepts string literals as inputs, so, as a hack, we are
using an equivalence test to ensure the file exists before using it as
an input to `bakepipe` targets.

``` r
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

mah_hh_total <- read_csv(external_in("/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mah_hh_dietary_intake.csv"))
```

    Rows: 110154 Columns: 332
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr   (2): date, all_pulses
    dbl (330): vh, base_people, num_meals, village, household, meal, day, week, ...

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

This is janky, but we will refactor it into a `targets` pipeline later
on. For now, we just want to churn this project quickly, so we are going
to settle for bakepipe’s weirdness.

Looks like this is a dataframe about household dietary intake.

We do the same with a couple of other files:

``` r
target_file <- "mahery_metadata.xlsx"
sheet <- 2
mah_meta_f <- repo_files %>%
    str_subset(target_file)

mah_meta_f %>%
    unzip(file.path(inputs_dir, "madagascar_data_cleaning-main.zip"), exdir = inputs_dir, files = ., junkpaths = TRUE)
infile <- file.path(inputs_dir, target_file)

if(!file.exists(infile)) {
    stop("File does not exist.")
}

if(infile != "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mahery_metadata.xlsx") {
    stop("File path does not match expected path.")
}

mah_meta <- read_excel(external_in("/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mahery_metadata.xlsx"), sheet = sheet)
```

    New names:
    • `` -> `...7`
    • `` -> `...8`

``` r
mah_meta <- mah_meta %>%
  mutate(`Malagasy Name` = tolower(`Malagasy Name`))
```
