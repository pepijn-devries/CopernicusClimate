#' Get or set a Climate Data Service API key
#' 
#' Many of the Climate Data Services features require a personal
#' Application Programming Interface (API) key. This function
#' will get a token that was previously stored (`cds_set_token()`),
#' and can be used throughout the R session.
#' 
#' To use an API key, you first need to get one from the
#' Climate Data Service. You can do so, by creating an account
#' and then initialise the key at <https://cds.climate.copernicus.eu/profile>.
#' 
#' There are diffrent locations where the key can be stored and where
#' `cds_get_token()` will look. It will look for the first succecful value of (in order):
#' the environment variable named `"CDSAPI_KEY"`, the R `getOption()` named `"CDSAPI_KEY"`,
#' the environment variable named `"ECMWF_DATASTORES_KEY"`, and the R `getOption()` named
#' `"ECMWF_DATASTORES_KEY"`.
#'
#' You can set the key at the start of each R session with `cds_set_token()`. If you
#' want a persistent sollution, you can add the environment variable (with names shown above)
#' to your system. Or you can add the option (with the names shown above) to your
#' `".profile"` file. This will help you obscure your sensitive account information in your R script.
#'
#' @param token The API key you wish to set as an R option or to an evironment variable.
#' @param method Method to store the API key. Should be either `"option"` (default) or
#' `"sysenv"`.
#' @param ... Ignored
#' @returns `cds_get_token()` will return an API key token if it has been set. If
#' it is not set it will return an empty string: `""`. `cds_set_token()` will
#' return `NULL` invisibly.
#' @examples
#' if (interactive() && !cds_token_works()) {
#'   cds_set_token("this-is-a-dummy-token", "option")
#' }
#' 
#' if (interactive()) {
#'   cds_get_token()
#' }
#' @include helpers.R
#' @export
cds_get_token <- function(...) {
  token <- Sys.getenv("CDSAPI_KEY")
  if (token == "")    token <- getOption("CDSAPI_KEY")
  if (is.null(token)) token <- Sys.getenv("ECMWF_DATASTORES_KEY")
  if (token == "")    token <- getOption("ECMWF_DATASTORES_KEY")
  if (is.null(token)) token <- ""
  return(token)
}

#' @rdname cds_get_token
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
#' Checks if the specified API key can be used for authentication at
#' the Climate Data Service.
#' @param token An API key to be used for authentication. Will use
#' `cds_get_token()` by default.
#' @param ... Ignored
#' @returns `cds_check_authentication()` will return
#' some account information when successful but throws an error if
#' it is not. In contrast `cds_token_works()` returns a `logical`
#' value and will not throw an error upon failure.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_check_authentication()
#' }
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
#' Retrieve account details associated with the provided `token`
#' @inheritParams cds_check_authentication
#' @param ... Ignored
#' @returns Returns a named `list` with account details.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_get_account()
#' }
#' @include helpers.R
#' @export
cds_get_account <- function(token = cds_get_token(), ...) {
  .base_url |>
    paste0("/profiles/v1/account/", sep = "") |>
    .execute_request(token)
}

#' Get Prometheus metrics for account
#' 
#' Obtain account metrics that can be interpreted with [prometheus](https://prometheus.io/)
#' @inheritParams cds_check_authentication
#' @param ... Ignored
#' @returns Returns text that can be interpreted with [prometheus](https://prometheus.io/)
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_account_metrics()
#' }
#' @include helpers.R
#' @export
cds_account_metrics <- function(token = cds_get_token(), ...) {
  .base_url |>
    paste0("/profiles/v1/metrics/", sep = "") |>
    .execute_request(token)
}
