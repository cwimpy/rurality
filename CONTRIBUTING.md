# Contributing to rurality

Thanks for your interest in contributing. This package is developed in
the open and improvements from the community are welcome.

## Asking questions

If you have a usage question that is not a bug, please open a [GitHub
Discussion](https://github.com/cwimpy/rurality/discussions) rather than
an issue. Use the issue tracker for bugs, data errors, and concrete
feature requests.

## Reporting issues

Please report bugs, data errors, and feature requests using the [GitHub
issue tracker](https://github.com/cwimpy/rurality/issues).

A useful bug report includes:

- The package version (`packageVersion("rurality")`) and your R version.
- A minimal reproducible example — ideally using `reprex::reprex()` —
  that shows the problem.
- The expected behavior and what actually happened.

For data issues (e.g., a county that looks misclassified), please
include the FIPS code and a pointer to the authoritative source you are
comparing against (USDA ERS, Census, NCHS, etc.).

## Reporting security issues

Please do not report security vulnerabilities through public GitHub
issues. Instead, email the maintainer directly at <cwimpy@astate.edu>.
You will receive an acknowledgement within a reasonable time frame.

## Pull requests

1.  Fork the repository and create a branch off `main`.
2.  Make your changes. Keep the diff focused — one feature or fix per
    PR.
3.  Add or update tests in `tests/testthat/` that cover the change.
4.  Run `devtools::check()` locally and ensure it passes with no errors,
    warnings, or notes.
5.  Update `NEWS.md` with a short description of the change under the
    development version heading.
6.  Open a pull request describing what changed and why. Reference any
    related issue numbers.

New contributors are encouraged to open an issue first to discuss larger
changes before investing significant effort.

## Running tests

The test suite uses `testthat` (3rd edition). To run it locally:

``` r
# Install dev dependencies
install.packages(c("devtools", "testthat"))

# Run the full test suite
devtools::test()

# Run R CMD check (what CI runs)
devtools::check()
```

The package is also checked on every push via GitHub Actions
(`R-CMD-check.yaml`) across the current R release, the previous release,
and the development version on Ubuntu, macOS, and Windows.

## Adding or updating data

The package ships USDA, Census, and NCHS data as package datasets. If
you are adding or updating one of these:

- Place the raw source file in `data-raw/` with a clear filename.
- Add or update the build script in `data-raw/` that processes the raw
  file into the `.rda` in `data/`.
- Update the `roxygen2` documentation in `R/data.R` to reflect the
  source, vintage, and schema.
- Include the source URL and access date in the PR description.

## Style

- Use `styler::style_pkg()` before opening a PR.
- Follow tidyverse style conventions; prefer pipes and `dplyr`.
- Document all exported functions with `roxygen2`.

## Code of conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://cwimpy.github.io/rurality/CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.
