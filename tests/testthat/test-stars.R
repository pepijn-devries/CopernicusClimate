test_that("Datasets can be starred", {
  skip_on_cran()
  skip_if(Sys.getenv("SKIPSTARS") == "TRUE",
          "Skip to avoid too many simultaneous star operations")
  skip_if_not(cds_token_works())
  skip_if_offline()
  expect_false({
    nm <- "reanalysis-era5-pressure-levels"
    cds_assign_star(nm)
    Sys.sleep(2) ## Wait to make sure request has been processed
    cds_remove_star(nm)
    Sys.sleep(2) ## Wait to make sure request has been processed
    nm %in% cds_starred()
  })
})