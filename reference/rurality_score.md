# Get Rurality Score for a County

Returns the composite rurality score (0-100) for one or more counties.

## Usage

``` r
rurality_score(fips)
```

## Arguments

- fips:

  A character vector of 5-digit county FIPS codes.

## Value

A numeric vector of rurality scores, or NA for unmatched FIPS.

## Examples

``` r
rurality_score("05031")
#>  3 
#> 33 
rurality_score(c("05031", "06037", "48453"))
#>  3  1  1 
#> 33 15 15 
```
