
# CopernicusClimate <img src="man/figures/logo.svg" align="right" height="139" copyright="cc-sa" alt="logo" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/pepijn-devries/CopernicusClimate/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pepijn-devries/CopernicusClimate/actions/workflows/R-CMD-check.yaml)
[![CopernicusClimate status
badge](https://pepijn-devries.r-universe.dev/badges/CopernicusClimate)](https://pepijn-devries.r-universe.dev/CopernicusClimate)
<!-- [![Codecov test coverage](https://codecov.io/gh/pepijn-devries/CopernicusClimate/graph/badge.svg)](https://app.codecov.io/gh/pepijn-devries/CopernicusClimate) -->
<!-- badges: end -->

## Overview

[The Copernicus Climate Change Service
(C3S)](https://climate.copernicus.eu/) has the mission of providing
information about the past, present and future climate, as well as tools
to enable climate change mitigation and adaptation strategies.

The C3S Climate Data Store provides open and state-of-the-art climate
data to scientists. This package allows users to download data from the
data store and handle it in R.

## Installation

Install latest developmental version from R-Universe:

``` r
install.packages("CopernicusClimate", repos = c('https://pepijn-devries.r-universe.dev', 'https://cloud.r-project.org'))
```

## Example

In order to download data from C3S you first need to submit a request
with `cds_submit_job()`. After your request has been processed by C3S,
you can download the data with `cds_download_jobs()`. This workflow is
demonstrated in the code snippet below.

``` r
library(CopernicusClimate)
library(stars)   ## For loading spatial raster data
library(ggplot2) ## For plotting the data

if (cds_token_works()) { ## Make sure there is an operational access token
  
  ## Submit a download job:
  job <-
    cds_submit_job(
      "sis-agrometeorological-indicators",
      statistic = "day_time_mean",
      variable = "2m_temperature",
      year = "2025",
      month = "01",
      day = "01")
  
  ## Actually download the data:
  data_file <- cds_download_jobs(job$jobID, tempdir())
  
  ## Unzip the downloaded data:
  data_unzipped <- unzip(data_file$local, list = TRUE)
  unzip(data_file$local, exdir = tempdir())
  data_stars <- read_mdim(file.path(tempdir(), data_unzipped))
  
  ## Plot the downloaded data
  ggplot() +
    geom_stars(data = data_stars) +
    coord_sf() +
    labs(fill = "T(air 2m) [K]") +
    scale_fill_viridis_c(option = "inferno", na.value = "transparent")
}
```

<img src="man/figures/README-example-1.png" width="100%" />

## More of Copernicus

More R packages for exploring other Copernicus data services:

- [CopernicusClimate](https://github.com/pepijn-devries/CopernicusClimate)
  Dedicated to marine datasets

## Code of Conduct

Please note that the CopernicusClimate project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
