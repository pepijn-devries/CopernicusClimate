# Translate Python Climate Data Store request to R request

When looking for a dataset on
<https://cds.climate.copernicus.eu/datasets>, you have the option to
copy the API request code to the clipboard. However, this is Python code
and cannot be used directly in this package. Use this function to
translate the code to a request that can be handled by the package. For
more details see
[`vignette("translate")`](https://pepijn-devries.github.io/CopernicusClimate/articles/translate.md)

## Usage

``` r
cds_python_to_r(text, ...)
```

## Arguments

- text:

  A `character` string containing the Python code copied from a dataset
  download website <https://cds.climate.copernicus.eu/datasets>. When
  missing, the function will use any text on the system clipboard. This
  means that you can copy the API request code from the website to the
  clipboard, then call this function without arguments.

- ...:

  Ignored

## Value

A named `list` that can be used as input for the functions
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md)
and
[`cds_estimate_costs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_estimate_costs.md)

## Examples

``` r
python_code <-
"import cdsapi
dataset = \"reanalysis-era5-land\"
request = {
  \"variable\": [\"2m_dewpoint_temperature\"],
  \"year\": \"2025\",
  \"month\": \"01\",
  \"day\": [\"01\"],
  \"time\": [
    \"00:00\", \"01:00\", \"02:00\",
    \"03:00\", \"04:00\", \"05:00\",
    \"06:00\", \"07:00\", \"08:00\",
    \"09:00\", \"10:00\", \"11:00\",
    \"12:00\", \"13:00\", \"14:00\",
    \"15:00\", \"16:00\", \"17:00\",
    \"18:00\", \"19:00\", \"20:00\",
    \"21:00\", \"22:00\", \"23:00\"
  ],
  \"data_format\": \"netcdf\",
  \"download_format\": \"unarchived\"
}

client = cdsapi.Client()
client.retrieve(dataset, request).download()
"

cds_python_to_r(python_code)
#> $variable
#> $variable[[1]]
#> [1] "2m_dewpoint_temperature"
#> 
#> 
#> $year
#> [1] "2025"
#> 
#> $month
#> [1] "01"
#> 
#> $day
#> $day[[1]]
#> [1] "01"
#> 
#> 
#> $time
#> $time[[1]]
#> [1] "00:00"
#> 
#> $time[[2]]
#> [1] "01:00"
#> 
#> $time[[3]]
#> [1] "02:00"
#> 
#> $time[[4]]
#> [1] "03:00"
#> 
#> $time[[5]]
#> [1] "04:00"
#> 
#> $time[[6]]
#> [1] "05:00"
#> 
#> $time[[7]]
#> [1] "06:00"
#> 
#> $time[[8]]
#> [1] "07:00"
#> 
#> $time[[9]]
#> [1] "08:00"
#> 
#> $time[[10]]
#> [1] "09:00"
#> 
#> $time[[11]]
#> [1] "10:00"
#> 
#> $time[[12]]
#> [1] "11:00"
#> 
#> $time[[13]]
#> [1] "12:00"
#> 
#> $time[[14]]
#> [1] "13:00"
#> 
#> $time[[15]]
#> [1] "14:00"
#> 
#> $time[[16]]
#> [1] "15:00"
#> 
#> $time[[17]]
#> [1] "16:00"
#> 
#> $time[[18]]
#> [1] "17:00"
#> 
#> $time[[19]]
#> [1] "18:00"
#> 
#> $time[[20]]
#> [1] "19:00"
#> 
#> $time[[21]]
#> [1] "20:00"
#> 
#> $time[[22]]
#> [1] "21:00"
#> 
#> $time[[23]]
#> [1] "22:00"
#> 
#> $time[[24]]
#> [1] "23:00"
#> 
#> 
#> $data_format
#> [1] "netcdf"
#> 
#> $download_format
#> [1] "unarchived"
#> 
#> attr(,"dataset")
#> [1] "reanalysis-era5-land"
```
