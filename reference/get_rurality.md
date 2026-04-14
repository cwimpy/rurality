# Look Up Rurality Data by FIPS Code

Returns the full rurality record for one or more county FIPS codes.

## Usage

``` r
get_rurality(fips)
```

## Arguments

- fips:

  A character vector of 5-digit county FIPS codes.

## Value

A tibble with rurality data for the matched counties.

## Examples

``` r
get_rurality("05031")
#> # A tibble: 1 × 24
#>   fips  state_fips county_fips state_abbr county_name      pop_2020 acs_pop
#>   <chr> <chr>      <chr>       <chr>      <chr>               <dbl>   <dbl>
#> 1 05031 05         031         AR         Craighead County   111231  111038
#> # ℹ 17 more variables: land_area_sqmi <dbl>, pop_density <dbl>,
#> #   rucc_2023 <int>, rucc_description <chr>, omb_designation <chr>, lat <dbl>,
#> #   lng <dbl>, dist_large_metro <dbl>, dist_medium_metro <dbl>,
#> #   dist_small_metro <dbl>, rucc_score <dbl>, density_score <dbl>,
#> #   distance_score <dbl>, rurality_score <dbl>, rurality_classification <chr>,
#> #   median_income <dbl>, median_age <dbl>
get_rurality(c("05031", "06037", "48453"))
#> # A tibble: 3 × 24
#>   fips  state_fips county_fips state_abbr county_name        pop_2020 acs_pop
#>   <chr> <chr>      <chr>       <chr>      <chr>                 <dbl>   <dbl>
#> 1 05031 05         031         AR         Craighead County     111231  111038
#> 2 06037 06         037         CA         Los Angeles County 10014009 9936690
#> 3 48453 48         453         TX         Travis County       1290188 1289054
#> # ℹ 17 more variables: land_area_sqmi <dbl>, pop_density <dbl>,
#> #   rucc_2023 <int>, rucc_description <chr>, omb_designation <chr>, lat <dbl>,
#> #   lng <dbl>, dist_large_metro <dbl>, dist_medium_metro <dbl>,
#> #   dist_small_metro <dbl>, rucc_score <dbl>, density_score <dbl>,
#> #   distance_score <dbl>, rurality_score <dbl>, rurality_classification <chr>,
#> #   median_income <dbl>, median_age <dbl>
```
