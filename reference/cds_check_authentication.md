# Check if authentication works with a specific token

Checks if the specified API key can be used for authentication at the
Climate Data Service.

## Usage

``` r
cds_check_authentication(token = cds_get_token(), ...)

cds_token_works(token = cds_get_token(), ...)
```

## Arguments

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

- ...:

  Ignored

## Value

`cds_check_authentication()` will return some account information when
successful but throws an error if it is not. In contrast
`cds_token_works()` returns a `logical` value and will not throw an
error upon failure.

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_check_authentication()
}
```
