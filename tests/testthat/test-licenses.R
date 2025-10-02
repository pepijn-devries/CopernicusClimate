test_that("Accepted licences can be obtained", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_no_error({
    cds_accepted_licences()
  })
})

test_that("A license can be accepted", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(cds_token_works())
  expect_no_error({
    cds_accept_licence("cc-by", 1)
  })
})