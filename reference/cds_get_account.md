# Get account details

Retrieve account details associated with the provided `token`

## Usage

``` r
cds_get_account(token = cds_get_token(), ...)
```

## Arguments

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

- ...:

  Ignored

## Value

Returns a named `list` with account details.

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_get_account()
}
```
