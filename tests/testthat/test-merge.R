test_that("add_rurality merges default columns", {
  df <- data.frame(fips = c("05031", "06037"), y = 1:2)
  result <- add_rurality(df)
  expect_true("rurality_score" %in% names(result))
  expect_true("rurality_classification" %in% names(result))
  expect_true("rucc_2023" %in% names(result))
  expect_equal(nrow(result), 2)
})

test_that("add_rurality with vars='all' adds many columns", {
  df <- data.frame(fips = c("05031"), y = 1)
  result <- add_rurality(df, vars = "all")
  expect_gt(ncol(result), 10)
})

test_that("add_rurality handles custom fips_col", {
  df <- data.frame(county_fips = c("05031", "06037"), y = 1:2)
  result <- add_rurality(df, fips_col = "county_fips")
  expect_true("rurality_score" %in% names(result))
})

test_that("add_rurality returns NA for unmatched FIPS", {
  df <- data.frame(fips = c("05031", "99999"), y = 1:2)
  result <- add_rurality(df)
  expect_true(!is.na(result$rurality_score[1]))
  expect_true(is.na(result$rurality_score[2]))
})

test_that("add_rurality zero-pads numeric-like FIPS", {
  df <- data.frame(fips = c("5031"), y = 1)
  result <- add_rurality(df)
  expect_true(!is.na(result$rurality_score[1]))
})
