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
