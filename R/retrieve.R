#' Submit a download job for a dataset
#' 
#' TODO
#' 
#' @param dataset TODO
#' @param ... TODO
#' @param wait TODO
#' @param check_quotum TODO
#' @param check_licence TODO
#' @inheritParams cds_check_authentication
#' @returns TODO
#' @examples
#' # TODO
#' if (interactive() && cds_token_works()) {
#'   job <- cds_submit_job(
#'       dataset        = "reanalysis-era5-pressure-levels",
#'       variable       = "geopotential",
#'       product_type   = "reanalysis",
#'       year           = "2024",
#'       month          = "03",
#'       day            = "01",
#'       pressure_level = "1000",
#'       format         = "netcdf"
#'     )
#' }
#' @include helpers.R
#' @export
cds_submit_job <- function(
    dataset, ..., wait = TRUE, check_quotum = TRUE, check_licence = TRUE,
    token = cds_get_token()) {
  #https://cds.climate.copernicus.eu/api/retrieve/v1/docs
  message("Building request")
  form <- cds_build_request(dataset, ...)
  if (check_quotum) {
    message("Checking quotum")
    quota <- .cds_estimate_costs(dataset, form, token)
    if (quota$cost > quota$limit) {
      rlang::abort(c(x = sprintf("This request (%i) exceeds your quotum (%i)",
                                 quota$cost, quota$limit),
                     i = "Try narrowing your request"))
    }
  }
  if (check_licence) {
    message("Checking license")
    missing_licence <- attributes(form)$licences$id
    missing_licence <- missing_licence[!missing_licence %in% cds_accepted_licences()$id]
    if (length(missing_licence) > 0) {
      rlang::abort(c(
        x = sprintf("Dataset requires you to accept these licences: %s",
                    paste(missing_licence, collapse = ", ")),
        i = "Use `cds_accept_licence()` to accept the required licences and try again"
      ))
    }
  }
  message("Submitting job")
  job <-
    .base_url |>
    paste("retrieve/v1/processes", dataset, "execution", sep = "/") |>
    .execute_request(token, "POST", list(inputs = form)) |>
    list() |>
    .simplify()
  
  if (wait) {
    wait_anim <- c("-", "\\", "|", "/")
    i <- 1
    repeat {
      job <- cds_list_jobs(job$jobID, token = token)
      if ("finished" %in% names(job)) {wait_anim <- " "; i <- 1}
      message(paste("\rChecking job status:", wait_anim[i], job$status, "    "),
              appendLF = FALSE)
      if ("finished" %in% names(job)) {
        message("")
        break
      }
      i <- i + 1
      if (i > length(wait_anim)) i <- 1
      Sys.sleep(1)
    }
  }
  return (job)
}

#' Prepare a request for downloading a dataset
#' 
#' TODO
#' @param dataset TODO
#' @param ... TODO
#' @returns TODO
#' @examples
#' if (interactive()) {
#'   cds_build_request(
#'     dataset        = "reanalysis-era5-pressure-levels",
#'     variable       = "geopotential",
#'     product_type   = "reanalysis",
#'     year           = "2024",
#'     month          = "03",
#'     day            = "01",
#'     pressure_level = "1000",
#'     format         = "netcdf"
#'   )
#' }
#'@export
cds_build_request <- function(dataset, ...) {
  form_result <- list(...)
  form <- cds_dataset_form(dataset) |>
    dplyr::mutate(
      required = ifelse(is.na(.data$required), FALSE, .data$required),
      name = ifelse(.data$name == "data_format", "format", .data$name)
    )
  known <- names(form_result) %in% form$name
  for (nm in names(form_result)) {
    details <- form |> dplyr::filter(.data$name == nm)
    details <- details$details[[1]]$details
    if (!form_result[[nm]] %in% unlist(details$values)) {
      rlang::abort(c(x = paste("Unknown value", paste(form_result[[nm]], collapse = ", ")),
                     i = paste("Expected one of", paste(unlist(details$values),
                                                        collapse = ", "))))
    }
  }
  for (unknown in names(form_result)[!known]) {
    message("Removing unknown field ", unknown)
    form_result[[unknown]] <- NULL
  }
  required_elements <- form$name[form$required]
  not_included <- required_elements[!required_elements %in% names(form_result)]
  for (missing_element in not_included) {
    ## Fill all missing fields with all possible values
    details <-
      form |>
      dplyr::filter(.data$name == missing_element) |>
      dplyr::pull("details")
    details <- details[[1]]$details
    if (!is.null(details$default)) {
      form_result[[missing_element]] <- details$default |> unlist()
    } else {
      form_result[[missing_element]] <- details$values |> unlist()
    }
  }
  # Check lengths
  for (nm in names(form_result)) {
    details <- form |> dplyr::filter(.data$name == nm)
    type <- details$type
    switch(
      type,
      StringListWidget = {
        form_result[[nm]] <- as.list(unlist(form_result[[nm]]))
      },
      StringChoiceWidget = {
        if (length(form_result[[nm]]) != 1) {
          rlang::abort(c(x = sprintf("Found multiple values for field '%s'", nm),
                         i = "Select only one value and try again"))
        } else {
          form_result[[nm]] <- unlist(form_result[[nm]])
        }
      },
      LicenceWidget = {
        form_result[[nm]] <- NULL
      },
      rlang::abort(c(x = paste("Unknown field type", type),
                     i = "Please report at <https://github.com/pepijn-devries/CopernicusClimate/issues> with a reprex"))
    )
  }
  
  licences <- form |>
    dplyr::filter(.data$name == "licences") |>
    dplyr::pull("details")
  licences <- licences[[1]]$details$licences |> .simplify()
  attributes(form_result)$licences <- licences
  return( form_result )
}

#' Check the cost of a request against your quotum
#' 
#' TODO
#' @param dataset TODO
#' @param ... TODO
#' @inheritParams cds_check_authentication
#' @returns TODO
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_estimate_costs(
#'     dataset        = "reanalysis-era5-pressure-levels",
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
cds_estimate_costs <- function(dataset, ..., token = cds_get_token()) {
  .cds_estimate_costs(dataset, cds_build_request(dataset, ...), token)
}

.cds_estimate_costs <- function(dataset, form, token) {
  .base_url |>
    paste("retrieve/v1/processes", dataset, "costing", sep = "/") |>
    .execute_request(token, "POST", list(inputs = form))
}

#' Download specific jobs
#' 
#' TODO
#' @param job_id TODO
#' @param destination Destination path to store downloaded files
#' @param names File names for the downloaded files. If missing, it is taken from the job.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns A `data.frame` of all downloaded files. Contains a column `local` with the path
#' to the locally stored files.
#' @examples
#' # TODO
#' 
#' @include helpers.R
#' @export
cds_download_jobs <- function(job_id, destination, names, ..., token = cds_get_token()) {
  if (!missing(names) && length(job_id) != length(names))
    stop("Argument `names` should have the same length as `job_id`.")
  missing_names <- missing(names)
  repeat {
    
    jobs <-
      cds_list_jobs(limit = 1000) |>
      dplyr::filter(.data$jobID %in% job_id)
    busy_jobs <- jobs$status %in% c("accepted", "running")
    if (any(busy_jobs)) {
      message("\rWaiting for", sum(busy_jobs), "to complete   ", appendLF = FALSE)
    } else break
    Sys.sleep(1)
  }
  message("")
  jobs <-
    data.frame(jobID = job_id) |>
    dplyr::left_join(jobs, by = "jobID") |>
    dplyr::mutate(
      href = lapply(.data$metadata, \(x) x$results$asset$value$href),
      href = lapply(.data$href, \(x) if (is.null(x)) "" else x) |>
        unlist(),
      name = if(missing_names) basename(.data$href) else .env$names
    )
  success <- jobs$status == "successful"
  if (any(!success)) message("Skipping ", sum(!success), " unsuccessful jobs")
  jobs <- jobs |> dplyr::filter(.data$status == "successful")
  if (nrow(jobs) == 0) stop("No successful jobs found to download")
  dupes <- duplicated(jobs$href)
  if (any(dupes)) message("Skipped ", sum(dupes), " identical files")
  jobs <- jobs |> dplyr::filter(!.env$dupes)
  requests <-
    lapply(jobs$href, httr2::request)
  message("Start downloading files:")
  responses <- httr2::req_perform_parallel(
    requests,
    paths = file.path(destination, jobs$name)
  )
  jobs |>
    dplyr::mutate(
      responses = responses,
      local = lapply(responses, \(x) x$body |> unclass()) |> unlist()
    )
}