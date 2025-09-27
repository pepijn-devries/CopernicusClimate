#' @export
cds_starred <- function(..., token = cds_get_token()) {
  account <- cds_get_account(token = token)
  account$starred_datasets
}

#' @export
cds_assign_star <- function(dataset, ..., token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/starred", sep = "") |>
    .make_request(token) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(list(uid = dataset)) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    unlist()
}

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
