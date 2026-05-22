library(targets)

list(
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mah_hh_dietary_intake_csv, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mah_hh_dietary_intake.csv", format = "file"),
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_metadata_xlsx, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mahery_metadata.xlsx", format = "file"),
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_darwin_formatching_alluniquefoods_to_nutritional_equivalents2025feb1_xlsx, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/MAHERY_DARWIN_ForMatching_AllUniqueFoods_to_Nutritional_Equivalents2025Feb1.xlsx", format = "file"),
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_dar_hh_weekly_per_month_grams_categs_long_csv, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/dar_hh_weekly_per_month_grams_categs_long.csv", format = "file"),
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_fish_enc_17feb2025_csv, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/fish_enc_17Feb2025.csv", format = "file"),
  tar_target(script_pipeline_01_mah_hh_consumption_r, "pipeline/01_mah_hh_consumption.R", format = "file"),
  tar_target(
    output_pipeline_01_mah_hh_consumption_r,
    {
      script_pipeline_01_mah_hh_consumption_r
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mah_hh_dietary_intake_csv
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_metadata_xlsx
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_darwin_formatching_alluniquefoods_to_nutritional_equivalents2025feb1_xlsx
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_dar_hh_weekly_per_month_grams_categs_long_csv
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_fish_enc_17feb2025_csv
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "pipeline/01_mah_hh_consumption.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_pipeline_02_mah_hh_consumption_r, "pipeline/02_mah_hh_consumption.R", format = "file"),
  tar_target(
    output_pipeline_02_mah_hh_consumption_r,
    {
      script_pipeline_02_mah_hh_consumption_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "pipeline/02_mah_hh_consumption.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_pipeline_03_mah_hh_consumption_r, "pipeline/03_mah_hh_consumption.R", format = "file"),
  tar_target(
    output_pipeline_03_mah_hh_consumption_r,
    {
      script_pipeline_03_mah_hh_consumption_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "pipeline/03_mah_hh_consumption.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_pipeline_04_mah_hh_consumption_r, "pipeline/04_mah_hh_consumption.R", format = "file"),
  tar_target(
    output_pipeline_04_mah_hh_consumption_r,
    {
      script_pipeline_04_mah_hh_consumption_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "pipeline/04_mah_hh_consumption.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_pipeline_mah_hh_consumption_r, "pipeline/mah_hh_consumption.R", format = "file"),
  tar_target(
    output_pipeline_mah_hh_consumption_r,
    {
      script_pipeline_mah_hh_consumption_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "pipeline/mah_hh_consumption.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_r_prospectormahery_package_r, "R/prospectorMahery-package.R", format = "file"),
  tar_target(
    output_r_prospectormahery_package_r,
    {
      script_r_prospectormahery_package_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "R/prospectorMahery-package.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_r_register_inputs_r, "R/register_inputs.R", format = "file"),
  tar_target(
    output_r_register_inputs_r,
    {
      script_r_register_inputs_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "R/register_inputs.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_r_utils_pipe_r, "R/utils-pipe.R", format = "file"),
  tar_target(
    output_r_utils_pipe_r,
    {
      script_r_utils_pipe_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "R/utils-pipe.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_rv_scripts_activate_r, "rv/scripts/activate.R", format = "file"),
  tar_target(
    output_rv_scripts_activate_r,
    {
      script_rv_scripts_activate_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "rv/scripts/activate.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_rv_scripts_rvr_r, "rv/scripts/rvr.R", format = "file"),
  tar_target(
    output_rv_scripts_rvr_r,
    {
      script_rv_scripts_rvr_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "rv/scripts/rvr.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_sandbox_load_data_r, "sandbox/load_data.R", format = "file"),
  tar_target(
    output_sandbox_load_data_r,
    {
      script_sandbox_load_data_r
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mah_hh_dietary_intake_csv
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_metadata_xlsx
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "sandbox/load_data.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_tests_testthat_r, "tests/testthat.R", format = "file"),
  tar_target(
    output_tests_testthat_r,
    {
      script_tests_testthat_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "tests/testthat.R")
      )
      character(0)
    },
    format = "file"
  ),
  tar_target(script_tests_testthat_test_register_inputs_r, "tests/testthat/test-register_inputs.R", format = "file"),
  tar_target(
    output_tests_testthat_test_register_inputs_r,
    {
      script_tests_testthat_test_register_inputs_r
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "tests/testthat/test-register_inputs.R")
      )
      character(0)
    },
    format = "file"
  )
)
