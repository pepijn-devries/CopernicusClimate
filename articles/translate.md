# Translate API Code

## Locating a dataset

You could use the R functions
[`cds_search_datasets()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_search_datasets.md)
and
[`cds_list_datasets()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_search_datasets.md)
to look for [Copernicus Climate Change Service
(C3S)](https://climate.copernicus.eu/) data. If you prefer using a
graphical user interface, you can use the website to find a suitable
dataset: <https://cds.climate.copernicus.eu/datasets>.

The screen recording below shows how to look for a dataset on the
website, and then copy the request code for that dataset to the
clipboard. Note this recording is only showing the essentials, and no
specific subsetting selections are made, causing the actual request to
be incomplete. But the principle remains the same.

![Demonstration of copying request code to
clipboard](https://raw.githubusercontent.com/pepijn-devries/CopernicusClimate/refs/heads/main/pkgdown/media/copy_api_code.gif)

Demonstration of copying request code to clipboard

## Downloading the dataset

Once the request code is on your system’s clipboard, you can go to your
R console and download the dataset, by first submitting the request with
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md).
By omitting the dataset argument, the function will automatically look
for a request on the clipboard. After the request has been processed,
you can download the dataset with
[`cds_download_jobs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_download_jobs.md).
All of this is illustrated in the screen recording below.

![Demonstration of downloading using a request on the
clipboard](https://raw.githubusercontent.com/pepijn-devries/CopernicusClimate/refs/heads/main/pkgdown/media/download_from_clipboard.gif)

Demonstration of downloading using a request on the clipboard

You can also arrange your workflow completely in R, without using a web
browser. For more details on this workflow check out
[`vignette("download")`](https://pepijn-devries.github.io/CopernicusClimate/articles/download.md).

## Translation

Under the hood of all this is the function
[`cds_python_to_r()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_python_to_r.md).
It is used to translate request code from the website to a request that
can be handled by this R package. In essence it extracts all relevant
information from the Python codes and turns it into a named list.
