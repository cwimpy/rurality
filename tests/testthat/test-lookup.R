test_that("get_rurality returns correct county", {
  result <- get_rurality("05031")
  expect_equal(nrow(result), 1)
  expect_equal(result$state_abbr, "AR")
  expect_true(grepl("Craighead", result$county_name))
})

test_that("get_rurality handles multiple FIPS", {
  result <- get_rurality(c("05031", "06037"))
  expect_equal(nrow(result), 2)
})

test_that("get_rurality handles zero-padding", {
  result <- get_rurality("5031")
  expect_equal(nrow(result), 1)
})

test_that("get_rurality returns empty for invalid FIPS", {
  result <- get_rurality("99999")
  expect_equal(nrow(result), 0)
})

test_that("rurality_score returns numeric", {
  score <- rurality_score("05031")
  expect_true(is.numeric(score))
  expect_length(score, 1)
  expect_true(score >= 0 && score <= 100)
})

test_that("rurality_score returns NA for invalid FIPS", {
  expect_true(is.na(rurality_score("99999")))
})

test_that("rurality_score handles multiple FIPS", {
  scores <- rurality_score(c("05031", "06037", "48453"))
  expect_length(scores, 3)
  expect_true(all(!is.na(scores)))
})

test_that("get_rucc returns integer", {
  rucc <- get_rucc("05031")
  expect_true(is.integer(rucc) || is.numeric(rucc))
  expect_true(rucc >= 1 && rucc <= 9)
})

test_that("get_rucc returns NA for invalid FIPS", {
  expect_true(is.na(get_rucc("99999")))
})

test_that("get_ruca returns data for valid ZIP", {
  result <- get_ruca("72401")
  expect_equal(nrow(result), 1)
  expect_true(result$primary_ruca >= 1 && result$primary_ruca <= 10)
})

test_that("get_ruca returns empty for invalid ZIP", {
  result <- get_ruca("00000")
  expect_equal(nrow(result), 0)
})

test_that("classify_rurality produces correct labels", {
  labels <- classify_rurality(c(5, 25, 45, 65, 90))
  expect_equal(labels, c("Urban", "Suburban", "Mixed", "Rural", "Very Rural"))
})

test_that("classify_rurality handles edge cases", {
  expect_equal(classify_rurality(0), "Urban")
  expect_equal(classify_rurality(20), "Suburban")
  expect_equal(classify_rurality(80), "Very Rural")
  expect_equal(classify_rurality(100), "Very Rural")
})
