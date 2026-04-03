#' Look Up Rurality Data by FIPS Code
#'
#' Returns the full rurality record for one or more county FIPS codes.
#'
#' @param fips A character vector of 5-digit county FIPS codes.
#'
#' @return A tibble with rurality data for the matched counties.
#'
#' @examples
#' get_rurality("05031")
#' get_rurality(c("05031", "06037", "48453"))
#'
#' @export
get_rurality <- function(fips) {
  fips <- stringr::str_pad(fips, 5, pad = "0")
  dplyr::filter(county_rurality, .data$fips %in% !!fips)
}

#' Get RUCC Code for a County
#'
#' Returns the USDA Rural-Urban Continuum Code (2023) for one or more counties.
#'
#' @param fips A character vector of 5-digit county FIPS codes.
#'
#' @return An integer vector of RUCC codes (1-9), or NA for unmatched FIPS.
#'
#' @examples
#' get_rucc("05031")
#' get_rucc(c("05031", "06037"))
#'
#' @export
get_rucc <- function(fips) {
  fips <- stringr::str_pad(fips, 5, pad = "0")
  idx <- match(fips, county_rurality$fips)
  county_rurality$rucc_2023[idx]
}

#' Get Rurality Score for a County
#'
#' Returns the composite rurality score (0-100) for one or more counties.
#'
#' @param fips A character vector of 5-digit county FIPS codes.
#'
#' @return A numeric vector of rurality scores, or NA for unmatched FIPS.
#'
#' @examples
#' rurality_score("05031")
#' rurality_score(c("05031", "06037", "48453"))
#'
#' @export
rurality_score <- function(fips) {
  fips <- stringr::str_pad(fips, 5, pad = "0")
  idx <- match(fips, county_rurality$fips)
  county_rurality$rurality_score[idx]
}

#' Classify a Rurality Score
#'
#' Converts numeric rurality scores to classification labels.
#'
#' @param score A numeric vector of rurality scores (0-100).
#'
#' @return A character vector of classifications.
#'
#' @examples
#' classify_rurality(c(15, 35, 55, 75, 90))
#'
#' @export
classify_rurality <- function(score) {
  dplyr::case_when(
    score >= 80 ~ "Very Rural",
    score >= 60 ~ "Rural",
    score >= 40 ~ "Mixed",
    score >= 20 ~ "Suburban",
    TRUE ~ "Urban"
  )
}

#' Merge Rurality Data onto a Data Frame
#'
#' Joins rurality data onto an existing data frame by FIPS code.
#'
#' @param data A data frame with a FIPS code column.
#' @param fips_col The name of the FIPS code column (default: "fips").
#' @param vars Which rurality variables to add. Default adds score and
#'   classification. Use "all" for all variables.
#'
#' @return The input data frame with rurality columns appended.
#'
#' @examples
#' my_data <- data.frame(fips = c("05031", "06037", "48453"), value = 1:3)
#' add_rurality(my_data)
#' add_rurality(my_data, vars = "all")
#'
#' @export
add_rurality <- function(data, fips_col = "fips", vars = c("rurality_score", "rurality_classification", "rucc_2023")) {
  if (identical(vars, "all")) {
    join_data <- county_rurality
  } else {
    join_data <- dplyr::select(county_rurality, "fips", dplyr::all_of(vars))
  }

  data[[fips_col]] <- stringr::str_pad(data[[fips_col]], 5, pad = "0")
  dplyr::left_join(data, join_data, by = stats::setNames("fips", fips_col))
}
