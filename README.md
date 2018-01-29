## A Spatial Microsimulation Analysis of Health Inequalities and Health Resilience

This is the public repository of my thesis.
The published thesis can be downloaded from the White Rose Ethesis Repository, see http://etheses.whiterose.ac.uk/id/eprint/19283

The repository is laid out much like an R package, with the following 'extras':

* Thesis chapters are in root for building with `bookdown`
* Plots, charts, maps, etc. are in `figures/`
* Systematic review notes are in `inst/systematic_review`

### Reproducibility

As much as I've tried to make my thesis completely reproducible, there are unfortunately some data sources whose licenses mean I cannot include them so you need to download them manually.
These are:

1. Download [Understanding Society](https://www.understandingsociety.ac.uk/). Specifically you will need [SN 6614: Waves 1-7, 2009-2016 and Harmonised BHPS: Waves 1-18, 1991-2009](https://discover.ukdataservice.ac.uk/catalogue?sn=6614). Copy this (but do not unzip!) to `inst/extdata/`
1. Download OS's [strategi](https://www.ordnancesurvey.co.uk/business-and-government/products/strategi.html) vector map. You will need to sign up and you will receive an email with a download link. Place the downloaded archive in `inst/extdata/`
1. Download OS's [Open Greenspace](https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html) full GB file and place in `inst/extdata/`
1. You *may* need to download the full CQC data set as sometimes archive versions are removed. If this is the case:
  - Open the web page at `http://www.cqc.org.uk/about-us/transparency/using-cqc-data#directory`
  - Copy the link to the file `CQC care directory - zip`. It will look something like `http://www.cqc.org.uk/sites/default/files/01_Month_Year_CQC_directory.zip`
  - Open `data-raw/01-construct-shapefiles.R`
  - Replace the link to the CQC directory on lines 943-944 with your new link
  - Save and run as normal.
