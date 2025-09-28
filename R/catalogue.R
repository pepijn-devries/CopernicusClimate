#' List Climate Data Service collections
#' 
#' TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' if (interactive()) {
#'   cds_collections()
#' }
#' @include helpers.R
#' @export
cds_list_collections <- function(...) {
  result <-
    .base_url |>
    paste0("/catalogue/v1/collections", sep = "") |>
    .execute_request()

  result$collections |>
    .simplify()
}

#' List or search Climate Data Service datasets
#' 
#' TODO
#' @param search TODO
#' @param page TODO
#' @param limit TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' if (interactive()) {
#'   #TODO
#' }
#' @include helpers.R
#' @export
cds_datasets <- function(search = NULL, page = 0, limit = 50, ...) {
  if (is.null(search)) search <- ""
  result <-
    .base_url |>
    paste0("/catalogue/v1/datasets", sep = "") |>
    .execute_request("", "POST",
                     list(q = search, kw = list(), idx = list(), sortby = "update",
                          page = page, limit = limit, search_stats = TRUE))
  #TODO add meta info (pagination as attributes!)
  result$collections |>
    .simplify()
}

#' List information about the API used for the catalogue
#' 
#' TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' if (interactive()) {
#'   cds_open_api()
#' }
#' @include helpers.R
#' @export
cds_open_api <- function(...) {
  #https://cds.climate.copernicus.eu/api/catalogue/v1/docs
  .base_url |>
    paste0("/catalogue/v1/openapi.json", sep = "") |>
    .execute_request()
  
}

#' List catalogue vocabulary
#' 
#' TODO
#' @param ... Ignored
#' @returns TODO
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
