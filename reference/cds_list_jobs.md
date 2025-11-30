# List jobs submitted to the Climate Data Service

Once submitted with
[`cds_submit_job()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_submit_job.md)
you can check the status of the job with this function. You can list all
available jobs, or specific jobs.

## Usage

``` r
cds_list_jobs(
  job_id = NULL,
  status = NULL,
  limit = 50,
  ...,
  token = cds_get_token()
)
```

## Arguments

- job_id:

  The id of a specific job, if you want the results for that job. If
  `NULL` (default) it is ignored.

- status:

  Only return jobs with the status stated by this argument. Default is
  `NULL` meaning that jobs with any status are returned. Should be any
  of `"accepted"`, `"running"`, `"successful"`, `"failed"`, or
  `"rejected"`.

- limit:

  Use to limit the number of listed results. Defaults to `50`.

- ...:

  Ignored

- token:

  An API key to be used for authentication. Will use
  [`cds_get_token()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_get_token.md)
  by default.

## Value

Returns a `data.frame` of submitted jobs.

## Examples

``` r
if (interactive() && cds_token_works()) {
  cds_list_jobs()
}
```
