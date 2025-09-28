#' Get a previously stored Climate Data Service API key
#' 
#' TODO
#' @returns TODO
#' @examples
#' # TODO
#' 
#' @include helpers.R
#' @export
cds_get_token <- function() {
  token <- Sys.getenv("CDSAPI_KEY")
  if (token == "")    token <- getOption("CDSAPI_KEY")
  if (is.null(token)) token <- Sys.getenv("ECMWF_DATASTORES_KEY")
  if (token == "")    token <- getOption("ECMWF_DATASTORES_KEY")
  if (is.null(token)) token <- ""
  return(token)
}

#' Store a Climate Data Service API key for the current R session
#' 
#' TODO
#' @param token TODO
#' @param method TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' # TODO
#' 
#' @export
cds_set_token <- function(token, method = c("option", "sysenv"), ...) {
  method <- match.arg(method)
  switch(
    method,
    option = {
      options(CDSAPI_KEY = token)
    },
    sysenv = {
      Sys.setenv(CDSAPI_KEY = token)
    })
  return(invisible())
}

#' Check if authentication works with a specific token
#' 
#' TODO
#' @param token TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' # TODO
#' 
#' @include helpers.R
#' @export
cds_check_authentication <- function(token = cds_get_token(), ...) {
  #https://cds.climate.copernicus.eu/api/profiles/v1/docs
  .base_url |>
    paste0("/profiles/v1/account/verification/pat", sep = "") |>
    .execute_request(token, "POST")
}

#' @rdname cds_check_authentication
#' @include helpers.R
#' @export
cds_token_works <- function(token = cds_get_token(), ...) {
  result <-
    tryCatch({
      cds_check_authentication(token)
      TRUE
    }, error = function(e) FALSE)
  return(result)
}

#' Get account details
#' 
#' TODO
#' @param token TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' # TODO
#' 
#' @include helpers.R
#' @export
cds_get_account <- function(token = cds_get_token(), ...) {
  .base_url |>
    paste0("/profiles/v1/account/", sep = "") |>
    .execute_request(token)
}

#' Get Prometheus metrics for account
#' 
#' TODO
#' @param token TODO
#' @param ... Ignored
#' @returns TODO
#' @examples
#' # TODO
#' 
#' @include helpers.R
#' @export
cds_account_metrics <- function(token = cds_get_token(), ...) {
  .base_url |>
    paste0("/profiles/v1/metrics/", sep = "") |>
    .execute_request(token)
}
