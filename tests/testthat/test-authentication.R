test_that("Authentication works", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_no_error({
    cds_check_authentication()
  })
})

test_that("Getting account details works", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_true({
    cds_get_account()$origin_portal[[1]] == "c3s"
  })
})

test_that("Can get account metrics", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_no_error({
    cds_account_metrics()
  })
})

test_that("Token can be set", {
  expect_true({
    my_token <- cds_get_token()
    cds_set_token("foobar", "option")
    cds_set_token("foobar", "sysenv")
    result <- getOption("CDSAPI_KEY") == "foobar" &&
      Sys.getenv("CDSAPI_KEY") == "foobar"
    options(CDSAPI_KEY = NULL)
    cds_set_token(my_token, "sysenv")
    result
  })
})