# Cite a dataset

Use this function to obtain citation details for a specific dataset

## Usage

``` r
cds_cite_dataset(dataset, ...)
```

## Arguments

- dataset:

  The name of a dataset to be cited.

- ...:

  Ignored

## Value

Returns a `BibEntry`-class object, with citation details for the
requested dataset

## See also

Other helper-functions:
[`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md),
[`cds_dataset_form()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_dataset_form.md),
[`cds_estimate_costs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_estimate_costs.md),
[`cds_python_to_r()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_python_to_r.md)

## Examples

``` r
if (interactive()) {
  cds_cite_dataset("reanalysis-era5-pressure-levels")
}
```
