#' List accepted licences
#' 
#' TODO
#' @param scope TODO
#' @param ... Ignored
#' @param token TODO
#' @returns TODO
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_accepted_licences("portal")
#' }
#' @include helpers.R
#' @export
cds_accepted_licences <- function(
    scope = c("None", "all", "dataset", "portal"),
    ...,
    token = cds_get_token()) {
  scope <- match.arg(scope)
  if (scope == "None") scope <- NULL
  .base_url |>
    paste0("/profiles/v1/account/licences", sep = "") |>
    httr2::url_modify_query(scope = scope) |>
    .execute_request(token) |>
    dplyr::first() |>
    lapply(data.frame) |>
    dplyr::bind_rows()
}