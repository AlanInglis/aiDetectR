.onLoad <- function(libname, pkgname) {
  reticulate::use_condaenv("imgdet", required = FALSE)
}
