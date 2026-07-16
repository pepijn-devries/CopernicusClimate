# List catalogue vocabulary

The catalogue uses a specific vocabulary for keywords. This function
produces an overview.

## Usage

``` r
cds_catalogue_vocabulary(...)
```

## Arguments

- ...:

  Ignored

## Value

Returns a `data.frame` of keyword vocabulary used by the catalogue.

## See also

Other exploration-functions:
[`cds_list_datasets()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_search_datasets.md),
[`cds_starred()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_starred.md)

## Examples

``` r
if (interactive()) {
  cds_catalogue_vocabulary()
}
```
