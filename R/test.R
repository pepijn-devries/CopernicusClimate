#' @export
test_cds <- function() {
# https://cds.climate.copernicus.eu/stac-browser/collections/derived-era5-single-levels-daily-statistics
#   "https://github.com/ecmwf/ecmwf-datastores-client" # <- this is the jackpot!
#   "https://github.com/mathworks/climatedatastore"
#   "https://github.com/ecmwf/cdsapi/"
#   getOption("copernicus_era_api")
#   {COLLECTION_URL}/execution
#   "https://cds.climate.copernicus.eu/api/tasks/services"
#   "https://cds.climate.copernicus.eu/api/profiles/v1/account/"
#   "https://cds.climate.copernicus.eu/api/catalogue/v1/collections"
#   "https://cds.climate.copernicus.eu/api/retrieve/v1/processes/reanalysis-era5-land/constraints"
#   "https://cds.climate.copernicus.eu/api/catalogue/v1/collections/reanalysis-era5-land/messages"
#   "https://cds.climate.copernicus.eu/api/retrieve/v1/processes/reanalysis-era5-land/api-request"
#   "https://cds.climate.copernicus.eu/api/retrieve/v1/processes"
# 
#   "https://cds.climate.copernicus.eu/api/profiles" |>
#     httr2::request() |>
#     httr2::req_perform()
#   
#   "https://cds.climate.copernicus.eu/api/catalogue" |>
#     httr2::request() |>
#     httr2::req_headers(`User-Agent` = "cdsapi/0.7.6") |>
#     httr2::req_perform()
#   
#     
#   "https://cds.climate.copernicus.eu/api/profiles/v1/account/verification/pat" |>
#     httr2::request() |>
#     httr2::req_headers(
#       `PRIVATE-TOKEN` = getOption("copernicus_era_api"),
#       `User-Agent` = "cdsapi/0.7.6") |>
#     httr2::req_method("POST") |>
#     httr2::req_perform() |>
#     httr2::resp_body_json()
# 
#   "https://cds.climate.copernicus.eu/api" |>
#     httr2::request() |>
#     httr2::req_headers(
#       `PRIVATE-TOKEN` = getOption("copernicus_era_api"),
#       `User-Agent` = "cdsapi/0.7.6") |>
#     httr2::req_method("POST") |>
#     httr2::req_perform() |>
#     httr2::resp_body_json()
#   
#   auth <-
#     httr2::oauth_client(id = "", "https://cds.climate.copernicus.eu/api",
#                         secret = getOption("copernicus_era_api"), auth = "header")
#   "https://cds.climate.copernicus.eu/api/v2" |>
#     httr2::request() |>
#     httr2::req_perform() |>
#     httr2::resp_body_json()
#   browser() #TODO
}