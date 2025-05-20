# R/python_imports.R
utils::globalVariables(c("torch", "transformers", "PIL_Image",
                         "hf_model", "processor", "model", "device"))

torch        <- NULL
transformers <- NULL
PIL_Image    <- NULL
hf_model     <- NULL
processor    <- NULL
model        <- NULL
device       <- NULL


load_py_model <- function() {
  if (!is.null(model)) return(invisible())
  
  # ── install missing Python packages ───────────────────────────────
  if (!reticulate::py_module_available("torch")) {
    reticulate::py_install(
      packages = c(
        "numpy==1.26.4",
        "torch==2.2.2+cpu",
        "torchvision",
        "torchaudio",
        "transformers",
        "pillow",
        "accelerate"
      ),
      method            = "auto",
      pip               = TRUE,
      pip_install_opts  = "--extra-index-url https://download.pytorch.org/whl/cpu"
    )
  }
  
  # ── now import safely ───────────────────────────────────────────────
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