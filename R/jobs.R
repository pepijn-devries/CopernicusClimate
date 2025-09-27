#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_jobs()
#' }
#' @export
cds_list_jobs <- function(job_id = NULL, token = cds_get_token()) {
  result <-
    .base_url |>
    paste("retrieve/v1/jobs", job_id, sep = "/") |>
    .make_request(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  result$jobs |>
    .simplify()
}

#' @export
cds_delete_job <- function(job_id, ..., token = cds_get_token()) {
  result <-
    .base_url |>
    paste("retrieve/v1/jobs/delete", sep = "/") |>
    .make_request(token) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(list(job_ids = as.list(job_id))) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  result$jobs |> .simplify()
}