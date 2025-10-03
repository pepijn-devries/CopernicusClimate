#' List accepted licences
#' 
#' In order to use specific features of the Climate Data Service, you may first
#' need to accept specific licences. This function will list all licenses you
#' have accepted.
#' @param scope Scope of the licenses to be listed should be one of `"all"` (default),
#' `"dataset"` or `"portal"`.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns Returns a `data.frame` listing the accepted licenses.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_accepted_licences("portal")
#' }
#' @include helpers.R
#' @export
cds_accepted_licences <- function(
    scope = c("all", "dataset", "portal"),
    ...,
    token = cds_get_token()) {
  scope <- match.arg(scope)
  .base_url |>
    paste0("/profiles/v1/account/licences", sep = "") |>
    httr2::url_modify_query(scope = scope) |>
    .execute_request(token) |>
    dplyr::first() |>
    lapply(data.frame) |>
    dplyr::bind_rows()
}

#' Accept a specific licence
#' 
#' Call this function if you wish to accept a specific license.
#' @param license The license id you wish to accept.
#' @param revision The revision number of the license you are accepting.
#' Should always be the latest revision.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns Returns a `data.frame` containing the accepted license
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_accept_licence("cc-by", 1)
#' }
#' @include helpers.R
#' @export
cds_accept_licence <- function(
    license, revision, ..., token = cds_get_token()) {
  .base_url |>
    paste("profiles/v1/account/licences", license, sep = "/") |>
    .make_request(token, "PUT") |>
    httr2::req_body_json(list(revision = revision)) |>
    httr2::req_error(body = .req_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::as_tibble()
}