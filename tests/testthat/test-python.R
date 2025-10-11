python_code <-
"import cdsapi

dataset = \"reanalysis-era5-pressure-levels\"
request = {
  \"product_type\": [\"reanalysis\"],
  \"variable\": [\"geopotential\"],
  \"year\": [\"2024\"],
  \"month\": [\"03\"],
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
  \"pressure_level\": [\"1000\"],
  \"data_format\": \"netcdf\",
  \"download_format\": \"unarchived\",
  \"area\": [55, -1, 50, 10]
}

client = cdsapi.Client()
client.retrieve(dataset, request).download()"

test_that("Clipboard can be used to define request", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(clipr::clipr_available(), "This test needs access to the clipboard")
  skip_if_not(cds_token_works(), "This test requires a working access token")
  expect_no_error({
    clipr::write_clip(python_code)
    cds_submit_job() |>
      suppressMessages()
  })
})

test_that("Python request can be converted to R request", {
  skip_on_cran()
  skip_if_offline()
  expect_no_error({
    req <- cds_python_to_r(python_code)
  })
})
