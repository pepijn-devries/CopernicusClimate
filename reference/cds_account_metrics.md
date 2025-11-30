# Get Prometheus metrics for account

Obtain account metrics that can be interpreted with
[prometheus](https://prometheus.io/)

## Usage

``` r
cds_account_metrics(token = cds_get_token(), ...)
```

## Arguments

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

- ...:

  Ignored

## Value

Returns text that can be interpreted with
[prometheus](https://prometheus.io/)

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_account_metrics()
}
```
