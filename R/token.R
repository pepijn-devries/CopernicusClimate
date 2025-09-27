#' @include helpers.R
#' @export
cds_get_token <- function() {
  ## TODO env var ECMWF_DATASTORES_KEY
  ## CDSAPI_KEY
  getOption("copernicus_era_api")
}

#' @include helpers.R
#' @export
cds_check_authentication <- function(token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/verification/pat", sep = "") |>
    .execute_request(token, "POST")
}

#' @include helpers.R
#' @export
cds_token_works <- function(token = cds_get_token()) {
  result <-
    tryCatch({
      cds_check_authentication(token)
      TRUE
    }, error = function(e) FALSE)
  return(result)
}

#' @include helpers.R
#' @export
cds_get_account <- function(token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/", sep = "") |>
    .execute_request(token)
}

#' @include helpers.R
#' @export
cds_account_metrics <- function(token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/metrics/", sep = "") |>
    .execute_request(token)
}
