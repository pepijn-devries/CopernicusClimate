# Submit a download job for a dataset

Submit a request to the Copernicus Climate Data Service to download
(part of) a dataset. If the request is successful, a job identifier is
returned which can be used to actually download the data
([`cds_download_jobs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_download_jobs.md)).

## Usage

``` r
cds_submit_job(
  dataset,
  ...,
  wait = TRUE,
  check_quota = TRUE,
  check_licence = TRUE,
  token = cds_get_token()
)
```

## Arguments

- dataset:

  The dataset name to be downloaded, or a `list` returned by
  [`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md).
  When this argument is missing the function will attempt to build a
  request with text on the clipboard using
  [`cds_python_to_r()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_python_to_r.md).

- ...:

  Subsetting parameters passed onto
  [`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md).
  Should be empty when `dataset` is missing or a `list`.

- wait:

  A `logical` value indicating if the function should wait for the
  submitted job to finish. Set it to `FALSE` to continue without waiting

- check_quota:

  Each account has a quota of data that can be downloaded. If this
  argument is set to `TRUE` (default) it is checked if the request
  doesn't exceed your quota. Set it to `FALSE` to skip this step and
  speed up the submission.

- check_licence:

  Datasets generally require you to accept certain terms of use. If this
  argument is set to `TRUE` (default), it will be checked if you have
  accepted all required licences for the submitted request. Set it to
  `FALSE` to skip this step and speed up the submission.

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a `data.frame` containing information about the submitted job.

## Examples

``` r
if (interactive() && cds_token_works()) {
  job <- cds_submit_job(
      dataset        = "reanalysis-era5-pressure-levels",
      variable       = "geopotential",
      product_type   = "reanalysis",
      area           = c(n = 55, w = -1, s = 50, e = 10),
      year           = "2024",
      month          = "03",
      day            = "01",
      pressure_level = "1000",
      data_format    = "netcdf"
    )

  ## Or split into two separate steps:
  
  req <- cds_build_request(
      dataset        = "reanalysis-era5-pressure-levels",
      variable       = "geopotential",
      product_type   = "reanalysis",
      area           = c(n = 55, w = -1, s = 50, e = 10),
      year           = "2024",
      month          = "03",
      day            = "01",
      pressure_level = "1000",
      data_format    = "netcdf"
    )
  job <- cds_submit_job(req)
}
```
