# data-raw/build_county_crosswalk.R
#
# Builds the county_crosswalk package dataset from the Rural Measurement
# paper's processed crosswalk file. Run this script once from the package
# root after the paper pipeline (01_assemble_crosswalk.R) has been executed.
#
# Requires: ~/Documents/projects/Rural Measurement/data/processed/county_crosswalk.rds
# Output:   data/county_crosswalk.rda

paper_crosswalk <- readRDS(
  "~/Documents/projects/Rural Measurement/data/processed/county_crosswalk.rds"
)

# Keep only the columns needed by rurality_spec() and document in data.R
county_crosswalk <- paper_crosswalk |>
  dplyr::select(
    fips, state_fips, county_name, state_abbr,
    # Scheme ordinals
    rucc_2023, ruca_2020_county, nchs_2023,
    # OMB class (character: "metro"/"micro"/"noncore")
    omb_class,
    # Census % urban (continuous)
    pct_urban_2020,
    # ACS covariates used in spec curve
    pop_total, median_inc, pct_ba_plus, pct_nh_white,
    log_inc, log_pop, pop_density
  )

usethis::use_data(county_crosswalk, overwrite = TRUE)
message("county_crosswalk saved: ", nrow(county_crosswalk), " counties")
