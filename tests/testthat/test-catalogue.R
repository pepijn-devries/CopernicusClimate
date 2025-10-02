test_that("Listing datasets results in at least 100 hits", {
  skip_on_cran()
  skip_if_offline()
  expect_true({
    nrow(cds_list_datasets()) >= 100
  })
})

test_that("Searching rain forecasts results in exactly that", {
  skip_on_cran()
  skip_if_offline()
  expect_true({
    result <- cds_search_datasets("rain", "Temporal coverage: Future")
    lapply(result$keywords, \(x) "Temporal coverage: Future" %in% x) |>
      unlist() |>
      all()
  })
})

test_that("Limiting a search works", {
  skip_on_cran()
  skip_if_offline()
  expect_true({
    nrow(cds_search_datasets(limit = 5)) == 5
  })
})

test_that("Getting catalogue vocabulary works", {
  skip_on_cran()
  skip_if_offline()
  expect_true({
    "Temporal coverage: Future" %in% cds_catalogue_vocabulary()$id
  })
})
