test_that("Dataset can be cited", {
  skip_on_cran()
  skip_if_offline()
  testthat::expect_s3_class({
    cds_cite_dataset("reanalysis-era5-pressure-levels") |>
      suppressMessages()
  }, "BibEntry")
})