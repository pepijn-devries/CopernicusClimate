# Accept a specific licence

Call this function if you wish to accept a specific license.

## Usage

``` r
cds_accept_licence(license, revision, ..., token = cds_get_token())
```

## Arguments

- license:

  The license id you wish to accept.

- revision:

  The revision number of the license you are accepting. Should always be
  the latest revision.

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a `data.frame` containing the accepted license

## See also

Other licences:
[`cds_accepted_licences()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_accepted_licences.md),
[`cds_list_licences()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_list_licences.md)

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_accept_licence("cc-by", 1)
}
```
