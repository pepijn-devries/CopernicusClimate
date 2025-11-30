# Delete/cancel jobs submitted to the Climate Data Service

Whe you regret submitting a job, you can cancel it by calling this
function.

## Usage

``` r
cds_delete_job(job_id, ..., token = cds_get_token())
```

## Arguments

- job_id:

  Hexadecimal code used as identifier of a job. Identifies the job to be
  cancelled.

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a `data.frame` with information about the cancelled job.

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
  cds_delete_job(job$jobID, tempdir())
}
```
