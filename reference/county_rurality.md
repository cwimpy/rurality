# County-Level Rurality Data for the United States

A dataset containing rurality scores, USDA classifications, and
demographic data for all U.S. counties. Includes RUCC 2023 codes,
population density, distance to metro areas, and a composite rurality
score.

## Usage

``` r
county_rurality
```

## Format

A tibble with approximately 3,233 rows and 23 columns:

- fips:

  5-digit county FIPS code (character)

- state_fips:

  2-digit state FIPS code (character)

- county_fips:

  3-digit county FIPS code (character)

- state_abbr:

  Two-letter state abbreviation

- county_name:

  County name

- pop_2020:

  2020 Census population

- acs_pop:

  ACS 2022 5-year population estimate

- land_area_sqmi:

  Land area in square miles

- pop_density:

  Population per square mile

- rucc_2023:

  USDA Rural-Urban Continuum Code (1-9)

- rucc_description:

  RUCC code description

- omb_designation:

  OMB designation: Metropolitan, Micropolitan, or Nonmetro

- lat:

  County centroid latitude

- lng:

  County centroid longitude

- dist_large_metro:

  Distance to nearest large metro (\>1M pop) in miles

- dist_medium_metro:

  Distance to nearest medium metro (250K-1M) in miles

- dist_small_metro:

  Distance to nearest small metro (50K-250K) in miles

- rucc_score:

  RUCC-derived score component (0-100)

- density_score:

  Population density score component (0-100)

- distance_score:

  Distance to metro score component (0-100)

- rurality_score:

  Composite rurality score (0-100)

- rurality_classification:

  Classification: Urban, Suburban, Mixed, Rural, Very Rural

- median_income:

  ACS 2022 median household income

- median_age:

  ACS 2022 median age

## Source

- USDA Economic Research Service, Rural-Urban Continuum Codes 2023

- U.S. Census Bureau, American Community Survey 2022 5-Year Estimates

- U.S. Census Bureau, TIGER/Line Shapefiles 2020

## Details

The composite rurality score is calculated as a weighted average:

- RUCC score: 55\\

- Population density score: 28\\

- Distance to metro score: 17\\

Classifications:

- 80-100: Very Rural

- 60-79: Rural

- 40-59: Mixed

- 20-39: Suburban

- 0-19: Urban

## Examples

``` r
# View the data
county_rurality
#> # A tibble: 3,235 × 24
#>    fips  state_fips county_fips state_abbr county_name     pop_2020 acs_pop
#>    <chr> <chr>      <chr>       <chr>      <chr>              <dbl>   <dbl>
#>  1 01001 01         001         AL         Autauga County     58805   58761
#>  2 01003 01         003         AL         Baldwin County    231767  233420
#>  3 01005 01         005         AL         Barbour County     25223   24877
#>  4 01007 01         007         AL         Bibb County        22293   22251
#>  5 01009 01         009         AL         Blount County      59134   59077
#>  6 01011 01         011         AL         Bullock County     10357   10328
#>  7 01013 01         013         AL         Butler County      19051   18981
#>  8 01015 01         015         AL         Calhoun County    116441  116162
#>  9 01017 01         017         AL         Chambers County    34772   34612
#> 10 01019 01         019         AL         Cherokee County    24971   25069
#> # ℹ 3,225 more rows
#> # ℹ 17 more variables: land_area_sqmi <dbl>, pop_density <dbl>,
#> #   rucc_2023 <int>, rucc_description <chr>, omb_designation <chr>, lat <dbl>,
#> #   lng <dbl>, dist_large_metro <dbl>, dist_medium_metro <dbl>,
#> #   dist_small_metro <dbl>, rucc_score <dbl>, density_score <dbl>,
#> #   distance_score <dbl>, rurality_score <dbl>, rurality_classification <chr>,
#> #   median_income <dbl>, median_age <dbl>

# Filter to rural counties
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
county_rurality |> filter(rurality_classification == "Very Rural")
#> # A tibble: 783 × 24
#>    fips  state_fips county_fips state_abbr county_name          pop_2020 acs_pop
#>    <chr> <chr>      <chr>       <chr>      <chr>                   <dbl>   <dbl>
#>  1 01023 01         023         AL         Choctaw County          12665   12669
#>  2 01025 01         025         AL         Clarke County           23087   23058
#>  3 01027 01         027         AL         Clay County             14236   14209
#>  4 01035 01         035         AL         Conecuh County          11597   11576
#>  5 01093 01         093         AL         Marion County           29341   29203
#>  6 01119 01         119         AL         Sumter County           12345   12196
#>  7 01129 01         129         AL         Washington County       15388   15434
#>  8 01131 01         131         AL         Wilcox County           10600   10441
#>  9 02013 02         013         AK         Aleutians East Boro…     3420    3407
#> 10 02016 02         016         AK         Aleutians West Cens…     5232    5219
#> # ℹ 773 more rows
#> # ℹ 17 more variables: land_area_sqmi <dbl>, pop_density <dbl>,
#> #   rucc_2023 <int>, rucc_description <chr>, omb_designation <chr>, lat <dbl>,
#> #   lng <dbl>, dist_large_metro <dbl>, dist_medium_metro <dbl>,
#> #   dist_small_metro <dbl>, rucc_score <dbl>, density_score <dbl>,
#> #   distance_score <dbl>, rurality_score <dbl>, rurality_classification <chr>,
#> #   median_income <dbl>, median_age <dbl>

# Arkansas counties
county_rurality |> filter(state_abbr == "AR")
#> # A tibble: 75 × 24
#>    fips  state_fips county_fips state_abbr county_name     pop_2020 acs_pop
#>    <chr> <chr>      <chr>       <chr>      <chr>              <dbl>   <dbl>
#>  1 05001 05         001         AR         Arkansas County    17149   17024
#>  2 05003 05         003         AR         Ashley County      19062   19018
#>  3 05005 05         005         AR         Baxter County      41627   41801
#>  4 05007 05         007         AR         Benton County     284333  286528
#>  5 05009 05         009         AR         Boone County       37373   37662
#>  6 05011 05         011         AR         Bradley County     10545   10461
#>  7 05013 05         013         AR         Calhoun County      4739    4773
#>  8 05015 05         015         AR         Carroll County     28260   28362
#>  9 05017 05         017         AR         Chicot County      10208   10234
#> 10 05019 05         019         AR         Clark County       21446   21469
#> # ℹ 65 more rows
#> # ℹ 17 more variables: land_area_sqmi <dbl>, pop_density <dbl>,
#> #   rucc_2023 <int>, rucc_description <chr>, omb_designation <chr>, lat <dbl>,
#> #   lng <dbl>, dist_large_metro <dbl>, dist_medium_metro <dbl>,
#> #   dist_small_metro <dbl>, rucc_score <dbl>, density_score <dbl>,
#> #   distance_score <dbl>, rurality_score <dbl>, rurality_classification <chr>,
#> #   median_income <dbl>, median_age <dbl>
```
