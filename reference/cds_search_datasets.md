# List or search Climate Data Service datasets

This will help you decide which datasets you wish to obtain.

## Usage

``` r
cds_list_datasets(dataset, ...)

cds_search_datasets(search, keywords, page = 0, limit = 50, ...)
```

## Arguments

- dataset:

  A specific dataset for which to list details. If missing all datasets
  are listed.

- ...:

  Ignored

- search:

  A string containing free text search terms to look for in the
  available datasets.

- keywords:

  A (vector of) string containing specific keywords. Should be listed in
  [`cds_catalogue_vocabulary()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_catalogue_vocabulary.md)

- page:

  When there are more search results than `limit`, results are
  paginated. Use `page` to specify which page to return starting at `0`
  (default).

- limit:

  Use to limit the number of search results. Defaults to `50`.

## Value

A `data.frame` listing the datasets from the Climate Data Service. In
case of `cds_search_datasets()`, attributes named `SearchMeta` are added
containing the number of matching and number of returned datasets.

## Examples

``` r
if (interactive()) {
  cds_list_datasets()
  cds_search_datasets("rain", "Temporal coverage: Future")
}
```
