# aiImageDetect <img src="man/figures/logo.png" align="right" height="110"/>

*AI-vs-Human image checker for R*

## What it does

`aiImageDetect` classifies any JPEG or PNG as **AI-generated** or **photographic**.
It wraps an open-source Vision Transformer fine-tuned on 120 k balanced images
covering Midjourney, Stable Diffusion, DALL·E and real photos.

```r
library(aiImageDetect)

setup_imgdet_env()          # one-off (≈ 3 min)
detect_ai_image("cats.jpg")
# $label       [1] "hum"
# $confidence  [1] 93.8
# $flagged     [1] FALSE
```

## Installation

### 1. Install the package

```r
install.packages("remotes")        # if not already installed
remotes::install_github("alaninglis/aiImageDetect")
```

### 2. Install Python dependencies

This package relies on Python libraries including `torch`, `transformers`,
and `pillow`. It uses **reticulate** to manage a clean Python environment.

**You must have Miniconda or Anaconda installed**.

- [Miniconda for Mac/Linux/Windows](https://docs.conda.io/en/latest/miniconda.html)

Once conda is available, set up the environment:

```r
library(aiImageDetect)
setup_imgdet_env()   # creates conda env 'imgdet' and installs required packages
```

This only needs to be run once per machine.

### 3. Test it

```r
res <- detect_ai_image("/path/to/image.jpg")
str(res)
# List of 4
#  $ label     : chr "ai"
#  $ confidence: num 97.2
#  $ probs     : Named num [1:2] 97.2 2.8
#  $ flagged   : logi TRUE
```

## How it works

1. **Processor** — SigLIP ViT normalises pixels to 224 × 224.
2. **Model** — classifier head outputs logits for classes `ai` and `hum`.
3. **Softmax** — probabilities are returned; you decide the threshold.

CPU inference < 0.5 s per image; Apple GPU ≈ 40 ms.

## Citation

The weights originate from **Ateeq A.** *AI vs Human Image Detector*, found at: 
https://huggingface.co/Ateeqq/ai-vs-human-image-detector
(Hugging Face model `Ateeqq/ai-vs-human-image-detector`, 2024, Apache-2.0).


