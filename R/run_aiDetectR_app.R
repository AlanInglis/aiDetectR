#' Launch the aiDetectR Shiny App
#'
#' Starts the interactive AI vs Human image detection dashboard.
#'
#' @return Opens a Shiny app in the browser.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   run_aiDetectR_app()
#' }
run_aiDetectR_app <- function() {
  app_dir <- system.file("shiny", package = "aiDetectR")
  if (app_dir == "") {
    stop("Could not find Shiny app directory. Try reinstalling the package.",
         call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}