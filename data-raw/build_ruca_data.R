# build_ruca_data.R
# Build RUCA lookup dataset for the rurality package

library(tidyverse)

ruca_codes <- read_csv(
  here::here("data-raw", "ruca2020_zcta.csv"),
  col_types = "ccccnn"
) |>
  transmute(
    zip = str_pad(ZIPCode, 5, pad = "0"),
    state = State,
    primary_ruca = as.integer(PrimaryRUCA),
    secondary_ruca = as.integer(SecondaryRUCA)
  )

cat("RUCA ZCTAs:", nrow(ruca_codes), "\n")

usethis::use_data(ruca_codes, overwrite = TRUE)
cat("Saved as package data\n")
