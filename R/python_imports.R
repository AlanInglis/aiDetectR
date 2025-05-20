# R/python_imports.R

utils::globalVariables(c(
  "torch", "transformers", "PIL_Image",
  "processor", "model", "device"
))

torch        <- NULL
transformers <- NULL
PIL_Image    <- NULL
processor    <- NULL
model        <- NULL
device       <- NULL

load_py_model <- function() {
  if (!is.null(model)) return(invisible())  # already loaded
  
  torch        <<- reticulate::import("torch")
  transformers <<- reticulate::import("transformers")
  PIL_Image    <<- reticulate::import("PIL.Image")
  
  hf_model  <- "Ateeqq/ai-vs-human-image-detector"
  processor <<- transformers$AutoImageProcessor$from_pretrained(hf_model)
  model     <<- transformers$AutoModelForImageClassification$from_pretrained(hf_model)
  
  device <<- torch$device(
    if (torch$cuda$is_available()) "cuda"
    else if (torch$backends$mps$is_available()) "mps"
    else "cpu"
  )
  model$to(device)$eval()
  invisible()
}