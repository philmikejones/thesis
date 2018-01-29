# Markdown
library("bookdown")
library("knitr")


# tidyverse
library("tidyverse")
library("forcats")
library("stringr")


# Regression
library("broom")
requireNamespace("car", quietly = TRUE)


# Reweighting
library("rakeR")


# GIS
suppressPackageStartupMessages(library("rgdal"))
suppressPackageStartupMessages(library("rgeos"))
requireNamespace("rmapshaper", quietly = TRUE)  # topology-aware simplication
requireNamespace("geolookup", quietly = TRUE)
library("tmap")


# Lookups
requireNamespace("geolookup", quietly = TRUE)


# Cartograms
library("cartogram")
