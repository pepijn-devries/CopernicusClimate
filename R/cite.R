#' Cite a dataset
#' 
#' Use this function to obtain citation details for a specific dataset
#' @param dataset The name of a dataset to be cited.
#' @param ... Ignored
#' @returns Returns a `BibEntry`-class object, with citation details for the requested
#' dataset
#' @examples
#' if (interactive()) {
#'   cds_cite_dataset("reanalysis-era5-pressure-levels")
#' }
#' @export
cds_cite_dataset <- function(dataset, ...) {
  if (requireNamespace("RefManageR")) {
    ds <- cds_list_datasets(dataset)
    RefManageR::GetBibEntryWithDOI(ds$`sci:doi`)
  } else {
    rlang::abort(c(x = "This function needs package RefManageR",
                   i = "Pleas install and try again"))
  }
}