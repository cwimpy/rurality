# Suppress R CMD check NOTEs for data objects and .data pronoun
utils::globalVariables(c("county_rurality", "ruca_codes"))

#' @importFrom rlang .data
NULL
