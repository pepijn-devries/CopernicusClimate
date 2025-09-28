#' List starred datasets
#' 
#' TODO
#' @param ... Ignored
#' @param token TODO
#' @returns TODO
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_starred()
#' }
#' @include helpers.R
#' @export
cds_starred <- function(..., token = cds_get_token()) {
  account <- cds_get_account(token = token)
  account$starred_datasets |> unlist()
}

#' Assign or remove stars to/from datasets
#' 
#' TODO
#' @param dataset TODO
#' @param ... Ignored
#' @param token TODO
#' @returns TODO
#' @examples
#' #TODO
#' @include helpers.R
#' @export
cds_assign_star <- function(dataset, ..., token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/starred", sep = "") |>
    .execute_request(token, "POST", list(uid = dataset)) |>
    unlist()
}

#' @rdname cds_assign_star
#' @include helpers.R
#' @export
cds_remove_star <- function(dataset, ..., token = cds_get_token()) {
  .base_url |>
    paste("profiles/v1/account/starred", dataset, sep = "/") |>
    .make_request(token) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform()
  ## removing a star returns empty body
  invisible(NULL)
}
