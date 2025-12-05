#' List jobs submitted to the Climate Data Service
#' 
#' Once submitted with `cds_submit_job()` you can check the status of the job with
#' this function. You can list all available jobs, or specific jobs.
#' @param job_id The id of a specific job, if you want the results for that job. If `NULL`
#' (default) it is ignored.
#' @param status Only return jobs with the status stated by this argument. Default is `NULL`
#' meaning that jobs with any status are returned. Should be any of `"accepted"`, `"running"`,
#' `"successful"`, `"failed"`, or `"rejected"`.
#' @param limit Use to limit the number of listed results. Defaults to `50`.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns Returns a `data.frame` of submitted jobs.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_list_jobs()
#' }
#' @include helpers.R
#' @export
cds_list_jobs <- function(job_id = NULL, status = NULL, limit = 50,
                          ..., token = cds_get_token()) {
  # https://cds.climate.copernicus.eu/api/retrieve/v1/docs
  if (!is.null(status))
    status <- match.arg(
      status, c("accepted", "running", "successful", "failed", "rejected"))
  
  result <-
    .base_url |>
    paste("retrieve/v1/jobs", job_id, sep = "/") |>
    httr2::url_modify_query(status = status, limit = limit) |>
    .execute_request(token)
  
  meta <- result$metadata
  result <-
    if ("jobs" %in% names(result)) {
      result$jobs |>
        .simplify()
    } else {
      result |> list() |> .simplify()
    }
  attributes(result)$MetaList <- meta
  result
}

#' Delete/cancel jobs submitted to the Climate Data Service
#' 
#' When you regret submitting a job, you can cancel it by calling this function.
#' @param job_id Hexadecimal code used as identifier of a job. Identifies the job
#' to be cancelled.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns Returns a `data.frame` with information about the cancelled job.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   job <- cds_submit_job(
#'       dataset        = "reanalysis-era5-pressure-levels",
#'       variable       = "geopotential",
#'       product_type   = "reanalysis",
#'       area           = c(n = 55, w = -1, s = 50, e = 10),
#'       year           = "2024",
#'       month          = "03",
#'       day            = "01",
#'       pressure_level = "1000",
#'       data_format    = "netcdf"
#'     )
#'   cds_delete_job(job$jobID, tempdir())
#' }
#' @include helpers.R
#' @export
cds_delete_job <- function(job_id, ..., token = cds_get_token()) {
  result <-
    .base_url |>
    paste("retrieve/v1/jobs/delete", sep = "/") |>
    .execute_request(token, "POST", list(job_ids = as.list(job_id)))
  result$jobs |> .simplify()
}
