.base_url <- "https://cds.climate.copernicus.eu/api"

.make_request <- function(x, token) {
  x |>
    httr2::request() |>
    httr2::req_headers(
      `PRIVATE-TOKEN` = token,
      `User-Agent` = "r_package")
}

.execute_request <- function(x, token, method = "GET", req_body = NULL) {
  x |>
    .make_request(token) |>
    httr2::req_method(method) |>
    httr2::req_body_json(req_body) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

.simplify <- function(x) {
  x <- lapply(x, tibble::enframe) |>
    lapply(tidyr::pivot_wider, names_from = "name", values_from = "value") |>
    dplyr:: bind_rows()
  unnest_col <-
    lapply(x, \(x) lengths(x) == 1) |>
    lapply(any) |>
    unlist()
  tidyr::unnest(x, names(unnest_col)[unnest_col])
}