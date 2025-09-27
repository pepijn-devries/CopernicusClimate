#' @export
cds_accepted_licences <- function(token = cds_get_token()) {
  .base_url |>
    paste0("/profiles/v1/account/licences", sep = "") |>
    .make_request(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::first() |>
    lapply(data.frame) |>
    dplyr::bind_rows()
}