# R/python_imports.R
load_py_model <- function() {
  if (!is.null(model)) return(invisible())             # already loaded
  
  # ── ensure required wheels are present ─────────────────────────────
  if (!reticulate::py_module_available("torch")) {
    reticulate::py_install(
      packages = c(
        "numpy==1.26.4",
        "torch==2.2.2",
        "torchvision",
        "torchaudio",
        "transformers",
        "pillow",
        "accelerate"
      ),
      method   = "auto",   # uses the same mini-Python reticulate just downloaded
      pip      = TRUE
    )
  }
  
  # ── now safe to import ─────────────────────────────────────────────
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