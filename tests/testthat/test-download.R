test_that("Download workflow works", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_true({
    job <- cds_submit_job(
      dataset        = "reanalysis-era5-pressure-levels",
      variable       = "geopotential",
      product_type   = "reanalysis",
      area           = c(n = 55, w = -1, s = 50, e = 10),
      year           = "2024",
      month          = "03",
      day            = "01",
      pressure_level = "1000",
      data_format    = "netcdf"
    ) |>
      suppressMessages()
    my_download <-
      cds_download_jobs(job$jobID, tempdir()) |>
      suppressMessages()
    file.size(my_download$local) > 0
  })
})

test_that("Area can be a `bbox` class object", {
  expect_no_error({
    cds_build_request(
      dataset        = "reanalysis-era5-pressure-levels",
      variable       = "geopotential",
      product_type   = "reanalysis",
      area           = sf::st_bbox(c(ymax = 55, xmin = -1,
                                     ymin = 50, xmax = 10)),
      year           = "2024",
      month          = "03",
      day            = "01",
      pressure_level = "1000",
      data_format    = "netcdf"
    )
  })
})

test_that("Costs can be estimated", {
  skip_on_cran()
  skip_if_offline()
  expect_no_error({
    cds_estimate_costs("reanalysis-era5-pressure-levels")
  })
})

test_that("Job can be cancelled", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_true({
    job <- cds_submit_job(
      dataset        = "reanalysis-era5-pressure-levels",
      variable       = "geopotential",
      product_type   = "reanalysis",
      area           = c(n = 55, w = -1, s = 50, e = 10),
      year           = "2024",
      month          = "03",
      day            = "01",
      pressure_level = "1000",
      data_format    = "netcdf",
      wait           = FALSE
    ) |>
      suppressMessages()
    job_del <- cds_delete_job(job$jobID)
    job_del$status == "dismissed"
  })
})

test_that("Job can listed", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_no_error({
    cds_list_jobs(status = "accepted")
  })
})

test_that("Duplicated default values are removed", {
  skip_on_cran()
  skip_if_offline()
  expect_true({
    request <-
      cds_build_request(
        "reanalysis-era5-single-levels",
        variable = "v_component_stokes_drift",
        year = "2025",
        month = "01",
        day = "01",
        data_format="netcdf"
      )
    length(request$product_type) == 1
  })
})

test_that("Grouped variables can also be used to build query", {
  skip_on_cran()
  skip_if_offline()
  expect_true({
    req <-
      cds_build_request(
        "reanalysis-era5-single-levels",
        variable = "wind" ## <- this is a group
      )
    ## should return all variables within group
    length(req$variable) > 1
  })
})