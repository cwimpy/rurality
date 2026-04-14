## R CMD check results

0 errors | 0 warnings | 0 notes

## Release summary

This is a data-correctness patch release for rurality 0.1.0.

The shipped `county_rurality` dataset was built against an incomplete
internal metro list (only 15 large / 9 medium / 5 small metros), so
distance-to-metro fields for counties near major metros outside that
top-15 list — Denver, Minneapolis, Portland, Las Vegas, Charlotte,
Indianapolis, Cleveland, Cincinnati, Columbus, Kansas City, and
others — were measured to New York, Chicago, or Los Angeles. This
misclassified several urban-core counties as "Suburban" when they
are metro cores. Example: Denver County shipped with
`dist_large_metro = 591`, classified Suburban.

0.1.1 rebuilds `county_rurality` against the full metro list shared
with the rurality-app web project (52 large / 57 medium / 36 small).
No API changes; only the underlying data.

## Test environments

* macOS Tahoe 26.4, R 4.5.3 (local)

## Downstream dependencies

No reverse dependencies on CRAN.
