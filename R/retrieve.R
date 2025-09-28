#' TODO retrieve split this in submit and download functions
#' 
#' TODO
#' @param id TODO
#' @param variable TODO
#' @param product_type TODO
#' @param year TODO
#' @param month TODO
#' @param day TODO
#' @param pressure_level TODO
#' @param format TODO
#' @param ... Ignored
#' @param token TODO
#' @returns TODO
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_retrieve(
#'     id             = "reanalysis-era5-pressure-levels",
#'     variable       = "geopotential",
#'     product_type   = "reanalysis",
#'     year           = "2024",
#'     month          = "03",
#'     day            = "01",
#'     pressure_level = "1000",
#'     format         = "netcdf"
#'   )
#' }
#' @include helpers.R
#' @export
cds_retrieve <- function(
    id,
    variable,
    product_type,
    # date,
    # time,
    year,
    month,
    day,
    pressure_level,
    format,
    ...,
    token = cds_get_token()
) {
  body <- list(inputs =
                 list(variable     = as.list(variable),
                      product_type = as.list(product_type),
                      # date         = as.list(date),
                      # time         = as.list(time),
                      year         = as.list(year),
                      month        = as.list(month),
                      day          = as.list(day),
                      pressure_level = as.list(pressure_level),
                      format       = format))
  
  message("Submitting job")
  
  job <-
    .base_url |>
    paste("retrieve/v1/processes", id, "execution", sep = "/") |>
    .execute_request(token, "POST", body)

  wait_anim <- c("-", "\\", "|", "/")
  i <- 1
  repeat {
    status <- cds_list_jobs(job$jobID, token)
    if ("finished" %in% names(status)) {wait_anim <- " "; i <- 1}
    message(paste("\rChecking job status:", wait_anim[i], status$status, "    "), appendLF = FALSE)
    if ("finished" %in% names(status)) break
    i <- i + 1
    if (i > length(wait_anim)) i <- 1
    Sys.sleep(1)
  }
  
  if (status$status %in% c("failed", "error")) stop(sprintf("Job id '%s' failed", job$jobID))
  
  message("\nGetting job results")
  
  job_result <-
    .base_url |>
    paste("retrieve/v1/jobs", job$jobID, "results", sep = "/") |>
    .execute_request(token)

  message("Downloading data")
  
  data <-
    job_result$asset$value$href |>
    .make_request(token) |>
    httr2::req_perform() |>
    httr2::resp_body_raw()
  
  message("Done")
}
