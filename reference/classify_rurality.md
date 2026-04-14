# Classify a Rurality Score

Converts numeric rurality scores to classification labels.

## Usage

``` r
classify_rurality(score)
```

## Arguments

- score:

  A numeric vector of rurality scores (0-100).

## Value

A character vector of classifications.

## Examples

``` r
classify_rurality(c(15, 35, 55, 75, 90))
#> [1] "Urban"      "Suburban"   "Mixed"      "Rural"      "Very Rural"
```
