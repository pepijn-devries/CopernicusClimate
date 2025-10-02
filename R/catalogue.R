#' @rdname cds_search_datasets
#' @include helpers.R
#' @export
cds_list_datasets <- function(...) {
  result <-
    .base_url |>
    paste0("/catalogue/v1/collections", sep = "") |>
    .execute_request()

  result$collections |>
    .simplify()
}

#' List or search Climate Data Service datasets
#' 
#' This will help you decide which datasets you wish to obtain.
#' @param search A string containing search terms to look for in the available datasets.
#' @param page When there are more search results than `limit`, results are paginated.
#' Use `page` to specify which page to return starting at `0` (default).
#' @param limit Use to limit the number of search results. Defaults to `50`.
#' @param ... Ignored
#' @returns A `data.frame` listing the datasets from the Climate Data Service. In
#' case of `cds_search_datasets()`, attributes named `SearchMeta` are added containing
#' the number of matching and number of returned datasets.
#' @examples
#' if (interactive()) {
#'   cds_list_datasets()
#'   cds_search_datasets("rain")
#' }
#' @include helpers.R
#' @export
cds_search_datasets <- function(search = NULL, page = 0, limit = 50, ...) {
  if (is.null(search)) search <- ""
  result <-
    .base_url |>
    paste0("/catalogue/v1/datasets", sep = "") |>
    .execute_request("", "POST",
                     list(q = search, kw = list(), idx = list(), sortby = "update",
                          page = page, limit = limit, search_stats = TRUE))
  
  meta <- list(numberMatched = result$numberMatched,
               numberReturned = result$numberReturned)
  
  result <-
    result$collections |>
    .simplify()
  attributes(result)$SearchMeta <- meta
  result
}

#' Obtain an overview of options to subset a dataset
#' 
#' This function provides an overview of parameters that can be used to subset a
#' dataset. It can help you set up a request with `cds_submit_job()` or `cds_build_request()`.
#' @param dataset A name of a dataset to explore
#' @param ... Ignored
#' @returns A `data.frame` with aspects of the dataset that can be subsetted, when defining
#' a job. See also `cds_submit_job()` and `cds_build_request()`
#' @export
cds_dataset_form <- function(dataset, ...) {
  result <-
    .base_url |>
    paste("catalogue/v1/collections", dataset, "form.json", sep = "/") |>
    .execute_request() |>
    purrr::map_df(~ .x)
  if ("details" %in% names(result))
    result <- tidyr::nest(result, details = .data$details)
  if ("children" %in% names(result))
    result <- tidyr::nest(result, children = .data$children)
  result
}

# This function is not exported as it will not have added value
# for most users
cds_open_api <- function(...) {
  #https://cds.climate.copernicus.eu/api/catalogue/v1/docs
  .base_url |>
    paste0("/catalogue/v1/openapi.json", sep = "") |>
    .execute_request()
  
}

#' List catalogue vocabulary
#' 
#' The catalogue uses a specific vocabulary for keywords. This function
#' produces an overview.
#' @param ... Ignored
#' @returns Returns a `data.frame` of keyword vocabulary used by the catalogue.
#' @examples
#' if (interactive()) {
#'   cds_catalogue_vocabulary()
#' }
#' @include helpers.R
#' @export
cds_catalogue_vocabulary <- function(...) {
  result <-
    .base_url |>
    paste0("/catalogue/v1/vocabularies/keywords", sep = "") |>
    .execute_request()
  result$keywords |> .simplify()
}
