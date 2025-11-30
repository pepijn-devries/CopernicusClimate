# Prepare a request for downloading a dataset

This function is used by
[`cds_estimate_costs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_estimate_costs.md)
and
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md)
to subset a dataset before downloading. It will also help you to explore
which parameters are available for subsetting.

## Usage

``` r
cds_build_request(dataset, ...)
```

## Arguments

- dataset:

  The dataset name to be used for setting up a request.

- ...:

  Parameters for subsetting the dataset. Use
  [`cds_dataset_form()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_dataset_form.md)
  to inquiry which parameters and parameter values are available for a
  specific dataset. If left blank it will take default parameter values.

## Value

Returns a named list, which can be used to submit a job
([`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md))
or inquiry its cost
([`cds_estimate_costs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_estimate_costs.md)).

## Examples

``` r
if (interactive()) {
  cds_build_request(
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
}
```
