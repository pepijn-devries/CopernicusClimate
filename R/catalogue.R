#' @include helpers.R
#' @examples
#' if (interactive()) {
#'   cds_collections()
#' }
#' 
#' @export
cds_collections <- function() {
  result <-
    .base_url |>
    paste0("/catalogue/v1/collections", sep = "") |>
    .execute_request("")

  result$collections |>
    .simplify()
}

#' @export
cds_datasets <- function(search = NULL, page = 0, limit = 50) {
  if (is.null(search)) search <- ""
  result <-
    .base_url |>
    paste0("/catalogue/v1/datasets", sep = "") |>
    .execute_request("", "POST",
                     list(q = search, kw = list(), idx = list(), sortby = "update",
                          page = page, limit = limit, search_stats = TRUE))
  result$collections |>
    .simplify()
}

#' @export
cds_open_api <- function() {
  #https://cds.climate.copernicus.eu/api/catalogue/v1/docs
  .base_url |>
    paste0("/catalogue/v1/openapi.json", sep = "") |>
    .execute_request("")
  
}

#' @export
cds_vocabulary <- function() {
  .base_url |>
    paste0("/catalogue/v1/vocabularies/keywords", sep = "") |>
    .excute_request("")
}