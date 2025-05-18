#' Detect whether an image is AI generated
#'
#' @param image_path A character scalar giving the path to a JPEG or PNG.
#' @param threshold Numeric scalar between 0 and 1. If the AI class
#'   probability meets or exceeds this value, \code{flagged} is \code{TRUE}.
#'
#' @return A named \code{list} with elements:
#'   \itemize{
#'     \item \code{label}   – "ai" or "hum"
#'     \item \code{confidence} – probability (percent)
#'     \item \code{probs}   – numeric vector of class probabilities
#'     \item \code{flagged} – logical
#'   }
#' @export
detect_ai_image <- function(image_path, threshold = 0.5) {
  img <- PIL_Image$open(image_path)$convert("RGB")
  
  batch      <- processor(img, return_tensors = "pt")
  pixel_vals <- batch$pixel_values$to(device)
  
  ng  <- torch$no_grad(); ng$`__enter__`()
  out <- model(pixel_values = pixel_vals)
  ng$`__exit__`(NULL, NULL, NULL)
  
  ## integer dim avoids the TypeError
  probs  <- torch$softmax(out$logits, as.integer(1))$cpu()$numpy()[1, ]
  labels <- unlist(model$config$id2label, use.names = FALSE)
  pred   <- which.max(probs)
  
  list(
    label      = labels[pred],                  # "ai" or "hum"
    confidence = round(probs[pred], 4) * 100,   # percentage
    probs      = setNames(round(probs, 4) * 100, labels),
    flagged    = (labels[pred] == "ai") && probs[pred] >= threshold
  )
}
