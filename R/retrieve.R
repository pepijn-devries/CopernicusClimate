#' Submit a download job for a dataset
#' 
#' Submit a request to the Copernicus Climate Data Service to download
#' (part of) a dataset. If the request is successful, a job identifier is
#' returned which can be used to actually download the data (`cds_download_jobs()`).
#' 
#' @param dataset The dataset name to be downloaded
#' @param ... Subsetting parameters passed onto `cds_build_request()`.
#' @param wait A `logical` value indicating if the function should wait for the
#' submitted job to finish. Set it to `FALSE` to continue without waiting
#' @param check_quota Each account has a quota of data that can be downloaded.
#' If this argument is set to `TRUE` (default) it is checked if the request doesn't
#' exceed your quota. Set it to `FALSE` to skip this step and speed up the submission.
#' @param check_licence Datasets generally require you to accept certain terms of use.
#' If this argument is set to `TRUE` (default), it will be checked if you have accepted all
#' required licences for the submitted request. Set it to `FALSE` to skip this step and
#'  speed up the submission.
#' @inheritParams cds_check_authentication
#' @returns Returns a `data.frame` containing information about the submitted job.
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
#'       format         = "netcdf"
#'     )
#' }
#' @include helpers.R
#' @export
cds_submit_job <- function(
    dataset, ..., wait = TRUE, check_quota = TRUE, check_licence = TRUE,
    token = cds_get_token()) {
  #https://cds.climate.copernicus.eu/api/retrieve/v1/docs
  message("Building request")
  form <- cds_build_request(dataset, ...)
  if (check_quota) {
    message("Checking quota")
    quota <- .cds_estimate_costs(dataset, form, token)
    if (quota$cost > quota$limit) {
      rlang::abort(c(x = sprintf("This request (%i) exceeds your quota (%i)",
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
#' This function is used by `cds_estimate_costs()` and `cds_submit_job()`
#' to subset a dataset before downloading. It will also help you to explore
#' which parameters are available for subsetting.
#' @param dataset The dataset name to be used for setting up a request.
#' @param ... Parameters for subsetting the dataset. Use `cds_dataset_form()` to inquiry
#' which parameters and parameter values are available for a specific dataset.
#' If left blank it will take default parameter values.
#' @returns Returns a named list, which can be used to submit a job (`cds_submit_job()`)
#' or inquiry its cost (`cds_estimate_costs()`).
#' @examples
#' if (interactive()) {
#'   cds_build_request(
#'     dataset        = "reanalysis-era5-pressure-levels",
#'     variable       = "geopotential",
#'     product_type   = "reanalysis",
#'     area           = c(n = 55, w = -1, s = 50, e = 10),
#'     year           = "2024",
#'     month          = "03",
#'     day            = "01",
#'     pressure_level = "1000",
#'     data_format    = "netcdf"
#'   )
#' }
#'@export
cds_build_request <- function(dataset, ...) {
  form_result <- list(...)

  constraints_all <- .cds_constraints(dataset,  structure(list(), names = character(0)))
  form <- cds_dataset_form(dataset) |>
    dplyr::mutate(
      required = ifelse(is.na(.data$required), FALSE, .data$required)
    )
  known <- names(form_result) %in% form$name
  for (nm in names(form_result)) {
    details <- form |> dplyr::filter(.data$name == nm)
    details <- details$details[[1]]$details
    if (!is.null(details$values) &&
        !form_result[[nm]] %in% unlist(details$values)) {
      rlang::abort(c(x = paste("Unknown value", paste(form_result[[nm]], collapse = ", ")),
                     i = paste("Expected one of", paste(unlist(details$values),
                                                        collapse = ", "))))
    }
    form_result[[nm]] <- methods::as(unlist(form_result[[nm]]),
                                     typeof(details$values[[1]]))
  }
  for (unknown in names(form_result)[!known]) {
    message("Removing unknown field ", unknown)
    form_result[[unknown]] <- NULL
  }
  required_elements <- form$name[form$required]
  not_included <- required_elements[!required_elements %in% names(form_result)]
  
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
      GeographicExtentWidget = {
        geo_details <- details$details[[1]]$details
        ## TODO also handle bbox
        current <- unlist(form_result[[nm]])
        if (length(current) != 4)
          rlang::abort(c(x = sprintf("Expected rectangular bounding box, with 4 values (%s)",
                                     paste(names(geo_details$default))),
                         i = "Provide a correct bounding box"))
        if (is.null(names(current))) names(current) <- names(geo_details$default)
        if (current["s"] > current["n"] || current["w"] > current["e"])
          rlang::abort(c(x = "North should be larger than South. West should be larget than East",
                         i = "Check your bounding box for correctness"))
        if (current[["n"]] > geo_details$range$n ||
            current[["s"]] < geo_details$range$s ||
            current[["e"]] > geo_details$range$e ||
            current[["w"]] < geo_details$range$w)
          rlang::abort(c(x = "Coordinates of `area` out of range",
                         i = sprintf("Check if your coordinates are in range (%s)",
                                     paste(unlist(geo_details$range), collapse = ", "))))
        form_result[[nm]] <- as.list(current)
      },
      LicenceWidget = {
        form_result[[nm]] <- NULL
      },
      rlang::abort(c(x = paste("Unknown field type", type),
                     i = "Please report at <https://github.com/pepijn-devries/CopernicusClimate/issues> with a reprex"))
    )
  }

  constraints <- .cds_constraints(dataset, form_result)
  for (missing_element in not_included) {
    if (!is.null(constraints[[missing_element]])) {
      details <-
        form |>
        dplyr::filter(.data$name == missing_element)
      type <- details$type
      details <- details$details[[1]]$details
      if (!is.null(details$default)) {
        form_result[[missing_element]] <- details$default |> unlist()
      } else {
        dat <- constraints[[missing_element]]
        if (type %in% "StringChoiceWidget") dat <- dat[[1]]
        
        if (length(dat) == 0) form_result[[missing_element]] <- NULL else
          form_result[[missing_element]] <- dat
      }
    }
  }
  
  licences <- form |>
    dplyr::filter(.data$name == "licences") |>
    dplyr::pull("details")
  licences <- licences[[1]]$details$licences |> .simplify()
  attributes(form_result)$licences <- licences
  return( form_result )
}

.cds_constraints <- function(dataset, form) {
  .base_url |>
    paste("retrieve/v1/processes", dataset, "constraints", sep = "/") |>
    .execute_request(token = "", "POST", list(inputs = form))
}

#' Check the cost of a request against your quota
#' 
#' Each account has a limit to the amount of data that can be downloaded.
#' Use this function to check if a request exceeds your quota.
#' @param dataset A dataset name to be inspected
#' @param ... Parameters passed on to `cds_build_request()`
#' @inheritParams cds_check_authentication
#' @returns Returns a named list indicating the available quota and
#' the estimated cost for a request specified with `...`-arguments.
#' @examples
#' if (interactive() && cds_token_works()) {
#'   cds_estimate_costs(
#'     dataset        = "reanalysis-era5-pressure-levels",
#'     variable       = "geopotential",
#'     product_type   = "reanalysis",
#'     area           = c(n = 55, w = -1, s = 50, e = 10),
#'     year           = "2024",
#'     month          = "03",
#'     day            = "01",
#'     pressure_level = "1000",
#'     data_format    = "netcdf"
#'   )
#'   
#'   cds_estimate_costs(dataset = "reanalysis-era5-pressure-levels")
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
#' After submitting one or more jobs with `cds_submit_job()`, you can download the resulting
#' files with `cds_download_jobs()`
#' @param job_id If a specific job identifier is listed here, only the files resulting
#' from those jobs are downloaded. If left blank, all successful jobs are downloaded.
#' @param destination Destination path to store downloaded files.
#' @param names File names for the downloaded files. If missing, the cryptic hexadecimal
#' file name is taken from the job.
#' @param ... Ignored
#' @inheritParams cds_check_authentication
#' @returns A `data.frame` of all downloaded files. Contains a column `local` with the path
#' to the locally stored files.
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
#'   cds_download_jobs(job$jobID, tempdir())
#' }
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
