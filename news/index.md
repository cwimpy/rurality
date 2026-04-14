# Changelog

## rurality 0.1.0

CRAN release: 2026-04-10

Initial CRAN release (2026-04-10).

### Core

- [`get_rurality()`](https://cwimpy.github.io/rurality/reference/get_rurality.md)
  returns the composite rurality score, classification, and RUCC code
  for a U.S. county identified by 5-digit FIPS.
- [`get_rucc()`](https://cwimpy.github.io/rurality/reference/get_rucc.md)
  and
  [`rurality_score()`](https://cwimpy.github.io/rurality/reference/rurality_score.md)
  return their respective scalar values for one-off lookups.
- [`get_ruca()`](https://cwimpy.github.io/rurality/reference/get_ruca.md)
  returns the primary RUCA code for a ZIP code tabulation area.
- [`classify_rurality()`](https://cwimpy.github.io/rurality/reference/classify_rurality.md)
  converts a numeric rurality score (0-100) into an ordered
  classification: Urban, Suburban, Mixed, Rural, Very Rural.
- [`add_rurality()`](https://cwimpy.github.io/rurality/reference/add_rurality.md)
  joins rurality variables onto an existing data frame by FIPS column,
  with optional selection of the full variable set.

### Data

- `county_rurality`: all 3,235 U.S. counties with 24 variables,
  including composite score, classification, RUCC 2023, population
  density, distance to nearest large metro, and ACS 2022 demographics.
- `ruca_codes`: USDA RUCA 2020 codes for 41,146 ZIP code tabulation
  areas.

### Methodology

Composite score is a weighted average of RUCC code (55%), population
density (28%), and distance to nearest large metro (17%), rescaled to
0-100.
