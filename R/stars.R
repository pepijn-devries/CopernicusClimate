#' @include helpers.R
#' @export
cds_starred <- function(..., token = cds_get_token()) {
  account <- cds_get_account(token = token)
  account$starred_datasets |> unlist()
}

#' @include helpers.R
#' @export
cds_assign_star <- function(dataset, ..., token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/starred", sep = "") |>
    .execute_request(token, "POST", list(uid = dataset)) |>
    unlist()
}

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
