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
      data_format    = "netcdf",
      wait           = FALSE
    ) |>
      suppressMessages()
    my_download <-
      cds_download_jobs(job$jobID, tempdir()) |>
      suppressMessages()
    file.size(my_download$local) > 0
  })
})