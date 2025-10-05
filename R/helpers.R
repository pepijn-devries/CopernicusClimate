.base_url <- "https://cds.climate.copernicus.eu/api"

.make_request <- function(x, token = "", method = "GET") {
  x |>
    httr2::request() |>
    httr2::req_headers(
      `PRIVATE-TOKEN` = token,
      `User-Agent` = "r_package") |>
    httr2::req_method(method) |>
    httr2::req_retry(max_tries = 3, retry_on_failure = TRUE, after = \(x) NA)
}

.execute_request <- function(x, token = "", method = "GET", req_body = NULL) {
  x |>
    .make_request(token, method) |>
    httr2::req_body_json(req_body, auto_unbox = TRUE) |>
    httr2::req_error(body = .req_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

.req_error <- function(body) {
  ct <- httr2::resp_content_type(body)
  body <-
    switch(
    ct,
    `application/json` = {
      body <- httr2::resp_body_json(body)
      if (!is.null(body$detail) && nchar(body$detail) > 3) {
        body$detail <- tryCatch({
          result <-
            substr(body$detail, 2, nchar(body$detail) - 1) |>
            stringr::str_replace_all("'", "\"") |>
            stringr::str_replace_all("\\(", "[") |>
            stringr::str_replace_all("\\)", "]") |>
            jsonlite::fromJSON()
          result$msg
        }, error = function(e) body$detail)
        body
      } else {
        body$detail <- NULL
        body
      }
    },
    `text/html` = {
      list(detail = httr2::resp_body_string(body))
    },
    list(detail = "")
  )
  c(body$title, body$detail)
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