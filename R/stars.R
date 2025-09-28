#' Add or remove a star to a dataset, or list starred datasets
#' 
#' Use stars to keep track of your favourite datasets. Use these
#' functions to add or remove a star.
#' @param dataset Name of the dataset to assign a star to, or remove it from.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns In case of `cds_assign_star()` returns the name of the starred
#' dataset. In case of `cds_starred()` a vector of names of starred datasets.
#' In case of `cds_remove_star()` returns `NULL` invisibly.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_assign_star("reanalysis-carra-single-levels")
#'   cds_starred()
#'   cds_remove_star("reanalysis-carra-single-levels")
#' }
#' @include helpers.R
#' @export
cds_starred <- function(..., token = cds_get_token()) {
  account <- cds_get_account(token = token)
  account$starred_datasets |> unlist()
}

#' @rdname cds_starred
#' @include helpers.R
#' @export
cds_assign_star <- function(dataset, ..., token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/starred", sep = "") |>
    .execute_request(token, "POST", list(uid = dataset)) |>
    unlist()
}

#' @rdname cds_starred
#' @include helpers.R
#' @export
cds_remove_star <- function(dataset, ..., token = cds_get_token()) {
  .base_url |>
    paste("profiles/v1/account/starred", dataset, sep = "/") |>
    .make_request(token, "DELETE") |>
    httr2::req_perform()
  ## removing a star returns empty body
  invisible(NULL)
}
