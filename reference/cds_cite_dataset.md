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

## Examples

``` r
if (interactive()) {
  cds_cite_dataset("reanalysis-era5-pressure-levels")
}
```
