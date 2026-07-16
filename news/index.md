# Changelog

## CopernicusClimate v0.0.5.0004

- Corrected NEWS file
- Fixed test to pass CRAN checks
- Fixed passing of token in
  [`cds_download_jobs()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_download_jobs.md)
  calls
- Fixed download vignette, by wrapping code in
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html) when contacting
  online resources
- Updated documentation

## CopernicusClimate v0.0.5

CRAN release: 2026-01-07

- Added
  [`cds_job_results()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_job_results.md)
- Fixed downloading jobs by relying on
  [`cds_job_results()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_job_results.md)
- Improved test coverage

## CopernicusClimate v0.0.4

CRAN release: 2025-12-05

- Corrected DESCRIPTION file
- Correction in handling of bbox
- Updated documentation
- Fixed broken test

## CopernicusClimate v0.0.3

CRAN release: 2025-10-23

- New features:
  - Translator for Python request:
    [`cds_python_to_r()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_python_to_r.md)
  - Added
    [`cds_list_licences()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_list_licences.md)
- Updated documentation
- Fixes in
  [`cds_build_request()`](https://pepijn-devries.github.io/CopernicusClimate/reference/cds_build_request.md)
- improved test coverage

## CopernicusClimate v0.0.2

CRAN release: 2025-10-09

- Initial version which can:
  - Explore the catalogue
  - Explore the user profile
  - Set up a download job
  - Download files resulting from submitted jobs
