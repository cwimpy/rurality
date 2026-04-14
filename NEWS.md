# rurality 0.1.1

Data-correctness patch (2026-04-13).

## Bug fixes

- `county_rurality`: distances to the nearest large/medium/small metro
  were computed against an incomplete metro list (15 large / 9 medium
  / 5 small). Counties near any large metro outside the top 15 —
  Denver, Minneapolis, Portland, Las Vegas, Charlotte, Indianapolis,
  Cleveland, Cincinnati, Columbus, Kansas City, Austin, San Antonio,
  Nashville, Jacksonville, Oklahoma City, Memphis, Louisville, and
  others — were being measured to New York, Chicago, or Los Angeles
  and classified as "Suburban" rather than "Urban". Example: Denver
  County shipped with `dist_large_metro = 591`, classified Suburban.
- Rebuilt with a full metro list shared with the rurality-app web
  project (52 large / 57 medium / 36 small). After this patch the
  major urban-core counties (Denver, Hennepin, Multnomah, Mecklenburg,
  Cuyahoga, Marion-IN, and similar) classify as Urban.

## Data

- `county_rurality`: 3,235 rows, unchanged schema. Score distribution
  (Urban / Suburban / Mixed / Rural / Very Rural):
  184 / 908 / 669 / 976 / 498.

# rurality 0.1.0

Initial CRAN release (2026-04-10).

## Core

- `get_rurality()` returns the composite rurality score, classification,
  and RUCC code for a U.S. county identified by 5-digit FIPS.
- `get_rucc()` and `rurality_score()` return their respective scalar
  values for one-off lookups.
- `get_ruca()` returns the primary RUCA code for a ZIP code tabulation
  area.
- `classify_rurality()` converts a numeric rurality score (0-100) into
  an ordered classification: Urban, Suburban, Mixed, Rural, Very Rural.
- `add_rurality()` joins rurality variables onto an existing data
  frame by FIPS column, with optional selection of the full variable
  set.

## Data

- `county_rurality`: all 3,235 U.S. counties with 24 variables, including
  composite score, classification, RUCC 2023, population density, distance
  to nearest large metro, and ACS 2022 demographics.
- `ruca_codes`: USDA RUCA 2020 codes for 41,146 ZIP code tabulation areas.

## Methodology

Composite score is a weighted average of RUCC code (55%), population
density (28%), and distance to nearest large metro (17%), rescaled to
0-100.
