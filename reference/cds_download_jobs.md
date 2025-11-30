# Download specific jobs

After submitting one or more jobs with
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md),
you can download the resulting files with `cds_download_jobs()`. See
[`vignette("download")`](https://pepijn-devries.github.io/CopernicusClimate/articles/download.md)
for more details.

## Usage

``` r
cds_download_jobs(job_id, destination, names, ..., token = cds_get_token())
```

## Arguments

- job_id:

  If a specific job identifier is listed here, only the files resulting
  from those jobs are downloaded. If left blank, all successful jobs are
  downloaded.

- destination:

  Destination path to store downloaded files.

- names:

  File names for the downloaded files. If missing, the cryptic
  hexadecimal file name is taken from the job.

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

A `data.frame` of all downloaded files. Contains a column `local` with
the path to the locally stored files.

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
  cds_download_jobs(job$jobID, tempdir())
}
```
