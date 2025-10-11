#' Translate Python Climate Data Store request to R request
#' 
#' When looking for a dataset on <https://cds.climate.copernicus.eu/datasets>,
#' you have the option to copy the API request code to the clipboard. However,
#' this is Python code and cannot be used directly in this package.
#' Use this function to translate the code to a request that can be handled by
#' the package.
#' @param text A `character` string containing the Python code copied
#' from a dataset download website <https://cds.climate.copernicus.eu/datasets>.
#' When missing, the function will use any text on the system clipboard.
#' This means that you can copy the API request code from the website to the
#' clipboard, then call this function without arguments.
#' @param ... Ignored
#' @returns A named `list` that can be used as input for the functions
#' `cds_submit_job()` and `cds_estimate_costs()`
#' @examples
#' python_code <-
#' "import cdsapi
#' dataset = \"reanalysis-era5-land\"
#' request = {
#'   \"variable\": [\"2m_dewpoint_temperature\"],
#'   \"year\": \"2025\",
#'   \"month\": \"01\",
#'   \"day\": [\"01\"],
#'   \"time\": [
#'     \"00:00\", \"01:00\", \"02:00\",
#'     \"03:00\", \"04:00\", \"05:00\",
#'     \"06:00\", \"07:00\", \"08:00\",
#'     \"09:00\", \"10:00\", \"11:00\",
#'     \"12:00\", \"13:00\", \"14:00\",
#'     \"15:00\", \"16:00\", \"17:00\",
#'     \"18:00\", \"19:00\", \"20:00\",
#'     \"21:00\", \"22:00\", \"23:00\"
#'   ],
#'   \"data_format\": \"netcdf\",
#'   \"download_format\": \"unarchived\"
#' }
#' 
#' client = cdsapi.Client()
#' client.retrieve(dataset, request).download()
#' "
#' 
#' cds_python_to_r(python_code)
#' @export
cds_python_to_r <- function(text, ...) {
  if (missing(text)) {
    if (requireNamespace("clipr")) {
      text <- clipr::read_clip()
    } else {
      rlang::abort(
        c(x = "Trying to get 'text' from clipboard, but missing required 'clipr' package",
          i = "Install package 'clipr' and try again")
      )
    }
  }
  ## collapse + strip spaces and tabs:
  text <- gsub("[ \t]", "", paste(text, collapse = "\n"))
  # tryCatch({
    ## extract dataset from text:
    dataset <-
      text |>
      stringr::str_extract("dataset=\".*\"") |>
      stringr::str_replace_all("(\"|dataset=)", "")
    
    ## extract request args from text:
    req <-
      text |>
      stringr::str_extract("request=\\{(.|\n)*\\}") |>
      stringr::str_replace("^request=", "") |>
      jsonlite::fromJSON(req)
    attributes(req)$dataset <- dataset
    req
  # }, error = function(e) rlang::abort(
  #   c(x = "Failed to convert text to CDSAPI request",
  #     i = "Check the input text (also the clipboard if relevant)")))
}