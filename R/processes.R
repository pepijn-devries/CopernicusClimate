#' @examples
#' if (interactive()) { # TODO test if token works
#'   cds_processes("derived-era5-land-daily-statistics")
#' }
#' @export
cds_processes <- function(id = NULL, token = cds_get_token()) {
  .base_url |>
    paste("retrieve/v1/processes", id, sep = "/") |>
    .make_request(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @examples
#' if (interactive()) { # TODO test if token works
#'   cds_jobs("6634b2ae-b9a7-4a1a-a1d8-af1f5a4e59dd")
#' }
#' @export
cds_jobs <- function(job_id = NULL, token = cds_get_token()) {
  .base_url |>
    paste("retrieve/v1/jobs", job_id, sep = "/") |>
    .make_request(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @examples
#' if (interactive()) { # TODO test if token works
#'   cds_tasks("6634b2ae-b9a7-4a1a-a1d8-af1f5a4e59dd")
#' }
#' @export
cds_tasks <- function(job_id = NULL, token = cds_get_token()) {
  browser() #TODO
  .base_url |>
    paste("retrieve/v1/tasks", job_id, sep = "/") |>
    .make_request(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @examples
#' if (interactive()) { # TODO test if token works
#'   cds_estimate_costs("derived-era5-land-daily-statistics")
#' }
#' @export
cds_estimate_costs <- function(
    id,
    token = cds_get_token()) {
  .base_url |>
    paste("retrieve/v1/processes", id, "costing", sep = "/") |>
    .make_request(token) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}