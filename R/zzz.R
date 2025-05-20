# .onLoad <- function(libname, pkgname) {
#   message("Loading AI image detector model...")
#   reticulate::use_condaenv("imgdet", required = FALSE)
#   
#   torch        <<- reticulate::import("torch", delay_load = TRUE)
#   transformers <<- reticulate::import("transformers", delay_load = TRUE)
#   PIL_Image    <<- reticulate::import("PIL.Image", delay_load = TRUE)
#   
#   hf_model  <<- "Ateeqq/ai-vs-human-image-detector"
#   processor <<- transformers$AutoImageProcessor$from_pretrained(hf_model)
#   model     <<- transformers$AutoModelForImageClassification$from_pretrained(hf_model)
#   
#   device <<- torch$device(
#     if (torch$cuda$is_available()) {
#       "cuda"
#     } else if (torch$backends$mps$is_available()) {
#       "mps"
#     } else {
#       "cpu"
#     }
#   )
#   model$to(device)$eval()
# }

# zzz.R
.onLoad <- function(libname, pkgname) {
  ## Point reticulate at the env name you intend to use at runtime.
  ## Do NOT import Python or load the model here.
 # reticulate::use_virtualenv("imgdet", required = FALSE)
  
  packageStartupMessage(
    "aiDetectR ready – Python model will load on first use."
  )
}