# Specification Curve Analysis Across Rurality Classification Schemes

Runs a specification curve across four rurality classification schemes
(RUCC, RUCA, NCHS, OMB), two functional forms (ordinal and binary
metro/nonmetro), and three covariate sets, for one or more user-supplied
county-level outcome variables. Returns a tidy data frame of coefficient
estimates suitable for plotting or further analysis.

## Usage

``` r
rurality_spec(
  data,
  outcome,
  fips_col = "fips",
  covariates = NULL,
  schemes = c("rucc", "ruca", "nchs", "omb"),
  forms = c("ordinal", "binary"),
  covar_sets = c("minimal", "full", "state_fe"),
  plot = TRUE
)
```

## Arguments

- data:

  A data frame containing a 5-digit county FIPS column and at least one
  numeric outcome variable.

- outcome:

  A character vector naming one or more outcome columns in `data`.

- fips_col:

  Name of the FIPS column in `data`. Default `"fips"`.

- covariates:

  Optional character vector of additional covariate column names already
  present in `data`. These are added on top of the three built-in
  covariate sets (see Details). Default `NULL`.

- schemes:

  Character vector of schemes to include. Any subset of
  `c("rucc", "ruca", "nchs", "omb")`. Default: all four.

- forms:

  Character vector of functional forms. Any subset of
  `c("ordinal", "binary")`. Default: both.

- covar_sets:

  Character vector of built-in covariate sets to use. Any subset of
  `c("minimal", "full", "state_fe")`. Default: all three. See Details.

- plot:

  Logical. If `TRUE` (default), print a specification curve plot.
  Requires ggplot2.

## Value

A tibble with one row per specification per outcome, containing:

- outcome:

  Outcome variable name

- scheme:

  Rurality scheme (`rucc`, `ruca`, `nchs`, `omb`)

- form:

  Functional form (`ordinal` or `binary`)

- covars:

  Covariate set label

- n:

  Number of observations

- estimate:

  Coefficient on the rurality predictor

- std.error:

  Standard error

- statistic:

  t-statistic

- p.value:

  p-value

- conf.low:

  Lower 95% confidence interval

- conf.high:

  Upper 95% confidence interval

- r.squared:

  Model R-squared

## Details

`rurality_spec()` joins the package's `county_crosswalk` dataset (FIPS
backbone with RUCC, RUCA, NCHS, OMB, and ACS covariates) onto `data` by
FIPS code, then fits OLS models for every combination of scheme, form,
and covariate set requested.

**Built-in covariate sets** (using ACS 2022 variables from the
crosswalk):

- `"minimal"`: log(population) + log(median income)

- `"full"`: minimal + percent BA or higher + percent non-Hispanic white

- `"state_fe"`: full + state fixed effects (`factor(state_fips)`)

**Ordinal predictors** are standardized (mean 0, SD 1) so that
coefficients are comparable across schemes with different scale lengths
(RUCC: 1-9, RUCA: 1-10, NCHS: 1-6, OMB: 1-3).

**Binary predictors** code metropolitan = 0, nonmetropolitan = 1, using
standard cutpoints: RUCC \>= 4, RUCA \>= 4, NCHS \>= 5, OMB != "metro".

Any user-supplied `covariates` are appended to all three built-in
covariate sets.

## Examples

``` r
if (FALSE) { # \dontrun{
# Minimal example with a built-in outcome proxy
library(dplyr)

# Attach a synthetic outcome to the crosswalk
df <- county_rurality |>
  select(fips) |>
  mutate(y = rnorm(n()))

results <- rurality_spec(df, outcome = "y")
print(results)
} # }
```
