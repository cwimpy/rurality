test_that("county_rurality has expected structure", {
  expect_s3_class(county_rurality, "data.frame")
  expect_gt(nrow(county_rurality), 3000)
  expect_true(all(c("fips", "rurality_score", "rurality_classification",
                     "rucc_2023", "state_abbr", "county_name") %in% names(county_rurality)))
})

test_that("county_rurality FIPS codes are 5 digits", {
  expect_true(all(nchar(county_rurality$fips) == 5))
})

test_that("rurality scores are in valid range", {
  scores <- county_rurality$rurality_score[!is.na(county_rurality$rurality_score)]
  expect_true(all(scores >= 0 & scores <= 100))
  # Allow a small number of NAs (counties with missing Census data)
  expect_lt(sum(is.na(county_rurality$rurality_score)), 50)
})

test_that("RUCC codes are 1-9", {
  valid_rucc <- county_rurality$rucc_2023[!is.na(county_rurality$rucc_2023)]
  expect_true(all(valid_rucc >= 1 & valid_rucc <= 9))
})

test_that("classifications are valid labels", {
  valid_labels <- c("Urban", "Suburban", "Mixed", "Rural", "Very Rural")
  expect_true(all(county_rurality$rurality_classification %in% valid_labels))
})

test_that("all 50 states plus DC are represented", {
  expect_gte(length(unique(county_rurality$state_abbr)), 50)
})

test_that("ruca_codes has expected structure", {
  expect_s3_class(ruca_codes, "data.frame")
  expect_gt(nrow(ruca_codes), 40000)
  expect_true(all(c("zip", "primary_ruca", "state") %in% names(ruca_codes)))
})

test_that("RUCA codes are in valid range", {
  ruca_vals <- ruca_codes$primary_ruca
  expect_true(min(ruca_vals, na.rm = TRUE) >= 1)
  expect_true(max(ruca_vals, na.rm = TRUE) <= 10)
})
