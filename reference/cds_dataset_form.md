# Obtain an overview of options to subset a dataset

This function provides an overview of parameters that can be used to
subset a dataset. It can help you set up a request with
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md)
or
[`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md).

## Usage

``` r
cds_dataset_form(dataset, ...)
```

## Arguments

- dataset:

  A name of a dataset to explore

- ...:

  Ignored

## Value

A `data.frame` with aspects of the dataset that can be subsetted, when
defining a job. See also
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md)
and
[`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md)

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_dataset_form("reanalysis-era5-pressure-levels")
}
```
