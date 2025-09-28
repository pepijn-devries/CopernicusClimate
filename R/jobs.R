#' List jobs submitted to the Climate Data Service
#' 
#' TODO
#' @param job_id TODO
#' @param ... Ignored
#' @param token TODO
#' @returns TODO
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_list_jobs()
#' }
#' @include helpers.R
#' @export
cds_list_jobs <- function(job_id = NULL, ..., token = cds_get_token()) {

  result <-
    .base_url |>
    paste("retrieve/v1/jobs", job_id, sep = "/") |>
    .execute_request(token)
  
  if ("jobs" %in% names(result)) {
    result$jobs |>
      .simplify()
  } else {
    result |> list() |> .simplify()
  }
}

#' Delete/cancel jobs submitted to the Climate Data Service
#' 
#' TODO
#' @param job_id TODO
#' @param ... Ignored
#' @param token TODO
#' @returns TODO
#' @examples
#' #TODO
#' @include helpers.R
#' @export
cds_delete_job <- function(job_id, ..., token = cds_get_token()) {
  result <-
    .base_url |>
    paste("retrieve/v1/jobs/delete", sep = "/") |>
    .execute_request(token, "POST", list(job_ids = as.list(job_id)))
  result$jobs |> .simplify()
}