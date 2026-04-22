test_that("county_crosswalk has expected structure", {
  expect_s3_class(county_crosswalk, "data.frame")
  expect_gt(nrow(county_crosswalk), 3000)
  expect_true(all(c(
    "fips", "state_fips", "county_name", "state_abbr",
    "rucc_2023", "ruca_2020_county", "nchs_2023", "omb_class",
    "pct_urban_2020", "pop_total", "median_inc",
    "pct_ba_plus", "pct_nh_white", "log_inc", "log_pop", "pop_density"
  ) %in% names(county_crosswalk)))
})

test_that("county_crosswalk FIPS codes are 5 digits", {
  expect_true(all(nchar(county_crosswalk$fips) == 5))
})

test_that("county_crosswalk scheme codes are in valid ranges", {
  rucc <- county_crosswalk$rucc_2023[!is.na(county_crosswalk$rucc_2023)]
  expect_true(all(rucc >= 1 & rucc <= 9))

  ruca <- county_crosswalk$ruca_2020_county[!is.na(county_crosswalk$ruca_2020_county)]
  expect_true(all(ruca >= 1 & ruca <= 10))

  nchs <- county_crosswalk$nchs_2023[!is.na(county_crosswalk$nchs_2023)]
  expect_true(all(nchs >= 1 & nchs <= 6))

  expect_true(all(county_crosswalk$omb_class[!is.na(county_crosswalk$omb_class)] %in%
                    c("metro", "micro", "noncore")))
})

test_that("rurality_spec returns a tidy data frame with expected columns", {
  set.seed(1)
  df <- data.frame(
    fips = county_crosswalk$fips,
    y    = stats::rnorm(nrow(county_crosswalk))
  )

  res <- rurality_spec(df, outcome = "y", plot = FALSE)

  expect_s3_class(res, "data.frame")
  expected_cols <- c("outcome", "scheme", "form", "covars", "n",
                     "estimate", "std.error", "statistic", "p.value",
                     "conf.low", "conf.high", "r.squared")
  expect_true(all(expected_cols %in% names(res)))

  # 1 outcome x 4 schemes x 2 forms x 3 covariate sets = 24 rows
  expect_equal(nrow(res), 24)
})

test_that("rurality_spec honors scheme/form/covar_set subsetting", {
  set.seed(1)
  df <- data.frame(
    fips = county_crosswalk$fips,
    y    = stats::rnorm(nrow(county_crosswalk))
  )

  res <- rurality_spec(
    df, outcome = "y",
    schemes    = c("rucc", "omb"),
    forms      = "binary",
    covar_sets = "minimal",
    plot       = FALSE
  )

  # 1 outcome x 2 schemes x 1 form x 1 covariate set = 2 rows
  expect_equal(nrow(res), 2)
  expect_setequal(res$scheme, c("rucc", "omb"))
  expect_true(all(res$form == "binary"))
  expect_true(all(res$covars == "minimal"))
})

test_that("rurality_spec errors on missing fips or outcome columns", {
  df <- data.frame(
    bad_id = county_crosswalk$fips,
    y      = stats::rnorm(nrow(county_crosswalk))
  )
  expect_error(rurality_spec(df, outcome = "y", plot = FALSE),
               "not found in `data`")

  df2 <- data.frame(
    fips = county_crosswalk$fips,
    y    = stats::rnorm(nrow(county_crosswalk))
  )
  expect_error(rurality_spec(df2, outcome = "nonexistent", plot = FALSE),
               "Outcome column")
})

test_that("rurality_spec handles multiple outcomes", {
  set.seed(1)
  df <- data.frame(
    fips = county_crosswalk$fips,
    y1   = stats::rnorm(nrow(county_crosswalk)),
    y2   = stats::rnorm(nrow(county_crosswalk))
  )

  res <- rurality_spec(df, outcome = c("y1", "y2"),
                      schemes    = "rucc",
                      forms      = "ordinal",
                      covar_sets = "minimal",
                      plot       = FALSE)

  expect_equal(nrow(res), 2)
  expect_setequal(res$outcome, c("y1", "y2"))
})
