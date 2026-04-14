# Merge Rurality Data onto a Data Frame

Joins rurality data onto an existing data frame by FIPS code.

## Usage

``` r
add_rurality(
  data,
  fips_col = "fips",
  vars = c("rurality_score", "rurality_classification", "rucc_2023")
)
```

## Arguments

- data:

  A data frame with a FIPS code column.

- fips_col:

  The name of the FIPS code column (default: "fips").

- vars:

  Which rurality variables to add. Default adds score and
  classification. Use "all" for all variables.

## Value

The input data frame with rurality columns appended.

## Examples

``` r
my_data <- data.frame(fips = c("05031", "06037", "48453"), value = 1:3)
add_rurality(my_data)
#>    fips value rurality_score rurality_classification rucc_2023
#> 1 05031     1             33                Suburban         3
#> 2 06037     2             15                   Urban         1
#> 3 48453     3             15                   Urban         1
add_rurality(my_data, vars = "all")
#>    fips value state_fips county_fips state_abbr        county_name pop_2020
#> 1 05031     1         05         031         AR   Craighead County   111231
#> 2 06037     2         06         037         CA Los Angeles County 10014009
#> 3 48453     3         48         453         TX      Travis County  1290188
#>   acs_pop land_area_sqmi pop_density rucc_2023
#> 1  111038       707.1583       157.0         3
#> 2 9936690      4059.2816      2447.9         1
#> 3 1289054       994.0526      1296.8         1
#>                                        rucc_description omb_designation
#> 1 Metro - Counties in metro areas of fewer than 250,000    Metropolitan
#> 2         Metro - Counties in metro areas of 1 million+    Metropolitan
#> 3         Metro - Counties in metro areas of 1 million+    Metropolitan
#>        lat        lng dist_large_metro dist_medium_metro dist_small_metro
#> 1 35.83091  -90.63290        57.407969         119.76309         4.076085
#> 2 34.32080 -118.22485        18.590200          85.52511       377.962597
#> 3 30.33436  -97.78182         5.183159          54.17805        88.541611
#>   rucc_score density_score distance_score rurality_score
#> 1         28            45             28             33
#> 2          8            15             36             15
#> 3          8            22             27             15
#>   rurality_classification median_income median_age
#> 1                Suburban         55169       34.4
#> 2                   Urban         83411       37.4
#> 3                   Urban         92731       35.1
```
