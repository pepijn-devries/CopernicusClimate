# Obtain a list of licences that can be accepted

Some datasets require you to accept specific licences. This function
will provide an overview of all licences associated with datasets and
can be accepted.

## Usage

``` r
cds_list_licences(...)
```

## Arguments

- ...:

  Ignored

## Value

Returns a `data.frame` of available licences that can be accepted.

## See also

Other licences:
[`cds_accept_licence()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_accept_licence.md),
[`cds_accepted_licences()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_accepted_licences.md)

## Examples

``` r
if (interactive()) {
  cds_list_licences()
}
```
