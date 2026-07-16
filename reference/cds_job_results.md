# Get the results for a submitted job

When a job is completed, you can get its results (i.e. download link) by
calling this function.

## Usage

``` r
cds_job_results(job_id, ..., token = cds_get_token())
```

## Arguments

- job_id:

  Hexadecimal code used as identifier of a job. Identifies the job for
  which to obtain the results.

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a `data.frame` with information about the requested job.

## See also

Other job-functions:
[`cds_delete_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_delete_job.md),
[`cds_download_jobs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_download_jobs.md),
[`cds_list_jobs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_list_jobs.md),
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md)

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
  cds_job_results(job$jobID)
}
```
