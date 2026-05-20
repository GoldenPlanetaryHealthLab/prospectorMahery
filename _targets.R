library(targets)

list(
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
  )
)
