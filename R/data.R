#' County-Level Rurality Data for the United States
#'
#' A dataset containing rurality scores, USDA classifications, and demographic
#' data for all U.S. counties. Includes RUCC 2023 codes, population density,
#' distance to metro areas, and a composite rurality score.
#'
#' @format A tibble with approximately 3,233 rows and 23 columns:
#' \describe{
#'   \item{fips}{5-digit county FIPS code (character)}
#'   \item{state_fips}{2-digit state FIPS code (character)}
#'   \item{county_fips}{3-digit county FIPS code (character)}
#'   \item{state_abbr}{Two-letter state abbreviation}
#'   \item{county_name}{County name}
#'   \item{pop_2020}{2020 Census population}
#'   \item{acs_pop}{ACS 2022 5-year population estimate}
#'   \item{land_area_sqmi}{Land area in square miles}
#'   \item{pop_density}{Population per square mile}
#'   \item{rucc_2023}{USDA Rural-Urban Continuum Code (1-9)}
#'   \item{rucc_description}{RUCC code description}
#'   \item{omb_designation}{OMB designation: Metropolitan, Micropolitan, or Nonmetro}
#'   \item{lat}{County centroid latitude}
#'   \item{lng}{County centroid longitude}
#'   \item{dist_large_metro}{Distance to nearest large metro (>1M pop) in miles}
#'   \item{dist_medium_metro}{Distance to nearest medium metro (250K-1M) in miles}
#'   \item{dist_small_metro}{Distance to nearest small metro (50K-250K) in miles}
#'   \item{rucc_score}{RUCC-derived score component (0-100)}
#'   \item{density_score}{Population density score component (0-100)}
#'   \item{distance_score}{Distance to metro score component (0-100)}
#'   \item{rurality_score}{Composite rurality score (0-100)}
#'   \item{rurality_classification}{Classification: Urban, Suburban, Mixed, Rural, Very Rural}
#'   \item{median_income}{ACS 2022 median household income}
#'   \item{median_age}{ACS 2022 median age}
#' }
#'
#' @details
#' The composite rurality score is calculated as a weighted average:
#' \itemize{
#'   \item RUCC score: 55\%
#'   \item Population density score: 28\%
#'   \item Distance to metro score: 17\%
#' }
#'
#' Classifications:
#' \itemize{
#'   \item 80-100: Very Rural
#'   \item 60-79: Rural
#'   \item 40-59: Mixed
#'   \item 20-39: Suburban
#'   \item 0-19: Urban
#' }
#'
#' @source
#' \itemize{
#'   \item USDA Economic Research Service, Rural-Urban Continuum Codes 2023
#'   \item U.S. Census Bureau, American Community Survey 2022 5-Year Estimates
#'   \item U.S. Census Bureau, TIGER/Line Shapefiles 2020
#' }
#'
#' @examples
#' # View the data
#' county_rurality
#'
#' # Filter to rural counties
#' library(dplyr)
#' county_rurality |> filter(rurality_classification == "Very Rural")
#'
#' # Arkansas counties
#' county_rurality |> filter(state_abbr == "AR")
"county_rurality"

#' County Crosswalk with Multiple Rurality Classification Schemes
#'
#' A county-level crosswalk combining the four major U.S. rurality
#' classification schemes (USDA RUCC, USDA RUCA, NCHS Urban-Rural, and OMB
#' Metropolitan/Micropolitan), along with Census urban/rural percentage and
#' ACS 2022 5-year demographic covariates. Used by [rurality_spec()] to run
#' specification curve analyses comparing schemes.
#'
#' @format A tibble with 3,143 rows and the following columns:
#' \describe{
#'   \item{fips}{5-digit county FIPS code (character)}
#'   \item{state_fips}{2-digit state FIPS code (character)}
#'   \item{county_fips}{3-digit county FIPS code (character)}
#'   \item{county_name}{County name}
#'   \item{state_abbr}{Two-letter state abbreviation}
#'   \item{rucc_2023}{USDA Rural-Urban Continuum Code 2023 (1-9)}
#'   \item{ruca_2020_county}{County-level RUCA 2020 (modal ZCTA code, 1-10)}
#'   \item{nchs_2023}{NCHS Urban-Rural Classification 2023 (1-6)}
#'   \item{omb_class}{OMB class: "metro", "micro", or "noncore"}
#'   \item{pct_urban_2020}{Percent of county population in Census urban areas (2020)}
#'   \item{pop_total}{ACS 2022 5-year total population}
#'   \item{median_inc}{ACS 2022 5-year median household income}
#'   \item{pct_ba_plus}{Percent of adults 25+ with bachelor's degree or higher}
#'   \item{pct_nh_white}{Percent non-Hispanic white}
#'   \item{log_inc}{log(median household income)}
#'   \item{log_pop}{log(total population)}
#'   \item{pop_density}{Population per square mile of land area}
#' }
#'
#' @source
#' \itemize{
#'   \item USDA Economic Research Service: RUCC 2023, RUCA 2020
#'   \item NCHS Urban-Rural Classification Scheme for Counties 2023
#'   \item U.S. Office of Management and Budget, CBSA delineations
#'   \item U.S. Census Bureau: 2020 Decennial (urban/rural), ACS 2022 5-year
#' }
#'
#' @examples
#' county_crosswalk
"county_crosswalk"
