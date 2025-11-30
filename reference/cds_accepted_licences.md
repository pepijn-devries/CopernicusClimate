# List accepted licences

In order to use specific features of the Climate Data Service, you may
first need to accept specific licences. This function will list all
licenses you have accepted.

## Usage

``` r
cds_accepted_licences(
  scope = c("all", "dataset", "portal"),
  ...,
  token = cds_get_token()
)
```

## Arguments

- scope:

  Scope of the licenses to be listed should be one of `"all"` (default),
  `"dataset"` or `"portal"`.

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a `data.frame` listing the accepted licenses.

## See also

Other licences:
[`cds_accept_licence()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_accept_licence.md),
[`cds_list_licences()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_list_licences.md)

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_accepted_licences("portal")
}
```
