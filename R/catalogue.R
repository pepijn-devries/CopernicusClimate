#' @rdname cds_search_datasets
#' @include helpers.R
#' @export
cds_list_datasets <- function(dataset, ...) {
  if (missing(dataset)) dataset <- NULL
  result <-
    .base_url |>
    paste("catalogue/v1/collections", dataset, sep = "/") |>
    .execute_request()
  
  if (is.null(result$collections)) .simplify(list(result)) else
    result$collections |>
      .simplify()
}

#' List or search Climate Data Service datasets
#' 
#' This will help you decide which datasets you wish to obtain.
#' @param dataset A specific dataset for which to list details. If missing
#' all datasets are listed.
#' @param search A string containing free text search terms to look for in the available datasets.
#' @param keywords A (vector of) string containing specific keywords. Should be listed in
#' `cds_catalogue_vocabulary()`
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
#'   cds_search_datasets("rain", "Temporal coverage: Future")
#' }
#' @include helpers.R
#' @export
cds_search_datasets <- function(search, keywords, page = 0, limit = 50, ...) {
  if (missing(search)) search <- ""
  if (missing(keywords)) keywords <- list()
  keywords <- unlist(keywords)
  result <-
    .base_url |>
    paste0("/catalogue/v1/datasets", sep = "") |>
    .execute_request("", "POST",
                     list(q = search, kw = as.list(keywords), idx = list(), sortby = "update",
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
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_dataset_form("reanalysis-era5-pressure-levels")
#' }
#' @export
cds_dataset_form <- function(dataset, ...) {
  result <-
    .base_url |>
    paste("catalogue/v1/collections", dataset, "form.json", sep = "/") |>
    .execute_request() |>
    purrr::map_df(~ .x)
  if ("details" %in% names(result))
    result <- tidyr::nest(result, details = "details")
  if ("children" %in% names(result))
    result <- tidyr::nest(result, children = "children")
  result
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
