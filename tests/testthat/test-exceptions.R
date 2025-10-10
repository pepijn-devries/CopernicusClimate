test_that("Request cannot exceed quota", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_error({
    cds_submit_job("reanalysis-era5-pressure-levels") |>
      suppressMessages()
  }, regexp = "*.?This request \\(\\d+\\) exceeds your quota*.?")
})

test_that("Only valid values can be submitted", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_error({
    cds_submit_job("reanalysis-era5-pressure-levels", pressure_level = -1) |>
      suppressMessages()
  }, regexp = "*.?Unknown value*.?")
})

test_that("Unknown fields are removed", {
  skip_on_cran()
  skip_if_offline()
  expect_message({
    cds_build_request("reanalysis-era5-pressure-levels", foo = "bar")
  }, regexp = "Removing unknown field foo")
})

test_that("Cannot provide multiple values when expecting one", {
  skip_on_cran()
  skip_if_offline()
  expect_error({
    cds_build_request("reanalysis-era5-pressure-levels",
                      data_format = c("grib", "netcdf")) |>
      suppressMessages()
  }, regexp = "*.?Found multiple values for field*.?")
})

test_that("Names cannot have a different length than jobs", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_error({
    cds_download_jobs(1:3, names = "foo")
  }, "should have the same length")
})

test_that("Cannot delete non-existing stars", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_error({
    cds_remove_star("foobar")
  }, regexp = "*.?Cannot find dataset foobar*.?")
})

test_that("Cannot pass invalid parameters to url", {
  skip_on_cran()
  skip_if_offline()
  expect_error({
    cds_search_datasets(page = "foobar")
  }, regexp = "*.?value is not a valid integer*.?")
})

test_that("Bounding box with no 4 values is rejected", {
  skip_on_cran()
  skip_if_offline()
  expect_error({
    cds_build_request("reanalysis-era5-single-levels", area = 1:3)
  }, "4 values")
})

test_that("Invalid bounding box coords are rejected", {
  skip_on_cran()
  skip_if_offline()
  expect_error({
    cds_build_request("reanalysis-era5-single-levels", area = 1:4)
  }, "correctness")
})

test_that("Coordinates out of range are rejected", {
  skip_on_cran()
  skip_if_offline()
  expect_error({
    cds_build_request("reanalysis-era5-single-levels", area = c(95, 0, 94, -1))
  }, "out of range")
})
