library(targets)

list(
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mah_hh_dietary_intake_csv, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mah_hh_dietary_intake.csv", format = "file"),
  tar_target(n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_metadata_xlsx, "/n/holylabs/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/data/inputs/01_gold_mine/madagascar-cohort-data-zip/mahery_metadata.xlsx", format = "file"),
  tar_target(script_pipeline_load_data_r, "pipeline/load_data.R", format = "file"),
  tar_target(
    output_pipeline_load_data_r,
    {
      script_pipeline_load_data_r
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mah_hh_dietary_intake_csv
      n_holylabs_cgolden_lab_lab_frontier_works_prospectors_prospectormahery_data_inputs_01_gold_mine_madagascar_cohort_data_zip_mahery_metadata_xlsx
      callr::r(
        func = function(script_path) {
          source(script_path, local = TRUE)
        },
        args = list(script_path = "pipeline/load_data.R")
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
