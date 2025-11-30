# Get or set a Climate Data Service API key

Many of the Climate Data Services features require a personal
Application Programming Interface (API) key. This function will get a
token that was previously stored (`cds_set_token()`), and can be used
throughout the R session.

## Usage

``` r
cds_get_token(...)

cds_set_token(token, method = c("option", "sysenv"), ...)
```

## Arguments

- ...:

  Ignored

- token:

  The API key you wish to set as an R option or to an evironment
  variable.

- method:

  Method to store the API key. Should be either `"option"` (default) or
  `"sysenv"`.

## Value

`cds_get_token()` will return an API key token if it has been set. If it
is not set it will return an empty string: `""`. `cds_set_token()` will
return `NULL` invisibly.

## Details

To use an API key, you first need to get one from the Climate Data
Service. You can do so, by creating an account and then initialise the
key at <https://cds.climate.copernicus.eu/profile>.

There are different locations where the key can be stored and where
`cds_get_token()` will look. It will look for the first successful value
of (in order): the environment variable named `"CDSAPI_KEY"`, the R
[`getOption()`](https://rdrr.io/r/base/options.html) named
`"CDSAPI_KEY"`, the environment variable named `"ECMWF_DATASTORES_KEY"`,
and the R [`getOption()`](https://rdrr.io/r/base/options.html) named
`"ECMWF_DATASTORES_KEY"`.

You can set the key at the start of each R session with
`cds_set_token()`. If you want a persistent solution, you can add the
environment variable (with names shown above) to your system. Or you can
add the option (with the names shown above) to your `".profile"` file.
This will help you obscure your sensitive account information in your R
script.

## Examples

``` r
if (interactive() && !cds_token_works()) {
  cds_set_token("this-is-a-dummy-token", "option")
}

if (interactive()) {
  cds_get_token()
}
```
