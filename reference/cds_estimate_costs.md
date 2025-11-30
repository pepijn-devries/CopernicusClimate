# Check the cost of a request against your quota

Each account has a limit to the amount of data that can be downloaded.
Use this function to check if a request exceeds your quota.

## Usage

``` r
cds_estimate_costs(dataset, ..., token = cds_get_token())
```

## Arguments

- dataset:

  A dataset name to be inspected

- ...:

  Parameters passed on to
  [`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md)

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a named list indicating the available quota and the estimated
cost for a request specified with `...`-arguments.

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_estimate_costs(
    dataset        = "reanalysis-era5-pressure-levels",
    variable       = "geopotential",
    product_type   = "reanalysis",
    area           = c(n = 55, w = -1, s = 50, e = 10),
    year           = "2024",
    month          = "03",
    day            = "01",
    pressure_level = "1000",
    data_format    = "netcdf"
  )
  
  cds_estimate_costs(dataset = "reanalysis-era5-pressure-levels")
}
```
