#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_processes("derived-era5-land-daily-statistics")
#' }
#' @include helpers.R
#' @export
cds_processes <- function(id = NULL, token = cds_get_token()) {
  result <-
    .base_url |>
    paste("retrieve/v1/processes", id, sep = "/") |>
    .execute_request(token)
  
  result$links     <- .simplify(result$links)
  result$inputs    <- .simplify(result$inputs)
  result$outputs   <- .simplify(result$outputs)
  result$processes <- .simplify(result$processes)
  return(result)
}
