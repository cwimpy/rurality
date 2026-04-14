# Get RUCC Code for a County

Returns the USDA Rural-Urban Continuum Code (2023) for one or more
counties.

## Usage

``` r
get_rucc(fips)
```

## Arguments

- fips:

  A character vector of 5-digit county FIPS codes.

## Value

An integer vector of RUCC codes (1-9), or NA for unmatched FIPS.

## Examples

``` r
get_rucc("05031")
#> [1] 3
get_rucc(c("05031", "06037"))
#> [1] 3 1
```
