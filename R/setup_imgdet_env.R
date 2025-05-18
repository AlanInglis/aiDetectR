#' Set up the Python environment for aiDetectR
#'
#' This installs the required Python packages into a named conda environment ("imgdet").
#' Run this once after installing the package.
#'
#' @param env The name of the conda environment to create (default is "imgdet")
#' @param python_version Python version to install (default is "3.11")
#' @return NULL (called for side effect)
#' @export
setup_imgdet_env <- function(env = "imgdet", python_version = "3.11") {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    stop("The 'reticulate' package is required.")
  }
  
  if (!env %in% reticulate::conda_list()$name) {
    reticulate::conda_create(env, packages = paste0("python=", python_version))
  }
  
  req_file <- system.file("requirements.txt", package = "aiDetectR")
  if (!file.exists(req_file)) {
    stop("requirements.txt not found in inst/. Is the package installed correctly?")
  }
  
  pkgs <- readLines(req_file)
  reticulate::py_install(
    packages = pkgs,
    envname  = env,
    method   = "conda",
    pip      = TRUE
  )
  
  message("Python environment '", env, "' is ready.")
}
