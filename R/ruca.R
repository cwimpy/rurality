#' Look Up RUCA Code by ZIP Code
#'
#' Returns the USDA Rural-Urban Commuting Area code (2020) for one or more
#' ZIP codes or ZCTAs.
#'
#' @param zip A character vector of 5-digit ZIP codes.
#'
#' @return A tibble with columns: zip, primary_ruca, secondary_ruca, state.
#'   Returns NA values for ZIPs not in the RUCA dataset.
#'
#' @details
#' RUCA codes range from 1 (metropolitan core) to 10 (rural). The primary
#' code reflects the majority commuting pattern; the secondary code captures
#' additional commuting flows.
#'
#' @examples
#' get_ruca("72401")
#' get_ruca(c("72401", "90210", "59801"))
#'
#' @export
get_ruca <- function(zip) {
  zip <- stringr::str_pad(zip, 5, pad = "0")
  dplyr::filter(ruca_codes, .data$zip %in% !!zip)
}

#' RUCA Code Data for U.S. ZIP Codes
#'
#' USDA Rural-Urban Commuting Area codes (2020) for approximately 41,000 ZCTAs.
#'
#' @format A tibble with columns:
#' \describe{
#'   \item{zip}{5-digit ZIP/ZCTA code (character)}
#'   \item{state}{Two-letter state abbreviation}
#'   \item{primary_ruca}{Primary RUCA code (1-10)}
#'   \item{secondary_ruca}{Secondary RUCA code (1-10)}
#' }
#'
#' @source USDA Economic Research Service, Rural-Urban Commuting Area Codes 2020
"ruca_codes"
