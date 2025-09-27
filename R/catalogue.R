#' @include helpers.R
#' @export
cds_collections <- function() {
  result <-
    .base_url |>
    paste0("/catalogue/v1/collections", sep = "") |>
    .make_request("") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  result$collections |>
    .simplify()
}
