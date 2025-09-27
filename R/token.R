#' @export
cds_get_token <- function() {
  getOption("copernicus_era_api")
}

#' @include helpers.R
#' @export
cds_check_authentication <- function(token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/verification/pat", sep = "") |>
    .make_request(token) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}