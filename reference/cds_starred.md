# Add or remove a star to a dataset, or list starred datasets

Use stars to keep track of your favourite datasets. Use these functions
to add or remove a star.

## Usage

``` r
cds_starred(..., token = cds_get_token())

cds_assign_star(dataset, ..., token = cds_get_token())

cds_remove_star(dataset, ..., token = cds_get_token())
```

## Arguments

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

- dataset:

  Name of the dataset to assign a star to, or remove it from.

## Value

In case of `cds_assign_star()` returns the name of the starred dataset.
In case of `cds_starred()` a vector of names of starred datasets. In
case of `cds_remove_star()` returns `NULL` invisibly.

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_assign_star("reanalysis-carra-single-levels")
  cds_starred()
  cds_remove_star("reanalysis-carra-single-levels")
}
```
