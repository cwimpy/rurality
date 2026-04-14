# Look Up RUCA Code by ZIP Code

Returns the USDA Rural-Urban Commuting Area code (2020) for one or more
ZIP codes or ZCTAs.

## Usage

``` r
get_ruca(zip)
```

## Arguments

- zip:

  A character vector of 5-digit ZIP codes.

## Value

A tibble with columns: zip, primary_ruca, secondary_ruca, state. Returns
NA values for ZIPs not in the RUCA dataset.

## Details

RUCA codes range from 1 (metropolitan core) to 10 (rural). The primary
code reflects the majority commuting pattern; the secondary code
captures additional commuting flows.

## Examples

``` r
get_ruca("72401")
#> # A tibble: 1 × 4
#>   zip   state primary_ruca secondary_ruca
#>   <chr> <chr>        <int>          <int>
#> 1 72401 AR               1              1
get_ruca(c("72401", "90210", "59801"))
#> # A tibble: 3 × 4
#>   zip   state primary_ruca secondary_ruca
#>   <chr> <chr>        <int>          <int>
#> 1 59801 MT               1              1
#> 2 72401 AR               1              1
#> 3 90210 CA               1              1
```
