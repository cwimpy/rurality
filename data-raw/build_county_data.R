# build_county_data.R
# Build the master county-level rurality dataset
# Sources: USDA RUCC 2023, USDA RUCA 2020, Census ACS, metro area coordinates

library(tidyverse)
library(tidycensus)

# ── 1. Load RUCC 2023 ───────────────────────────────────────────────────────
rucc_raw <- read_csv(here::here("data-raw", "rucc2023.csv"), col_types = "ccccn")

rucc <- rucc_raw |>
  pivot_wider(
    id_cols = c(FIPS, State, County_Name),
    names_from = Attribute,
    values_from = Value
  ) |>
  rename(
    fips = FIPS,
    state_abbr = State,
    county_name = County_Name,
    pop_2020 = Population_2020,
    rucc_2023 = RUCC_2023
  ) |>
  mutate(
    fips = str_pad(fips, 5, pad = "0"),
    state_fips = str_sub(fips, 1, 2),
    county_fips = str_sub(fips, 3, 5),
    rucc_2023 = as.integer(rucc_2023),
    pop_2020 = as.numeric(pop_2020)
  )

cat("RUCC counties:", nrow(rucc), "\n")

# ── 2. RUCC-to-score mapping (matches app methodology) ──────────────────────
rucc_score_map <- c(
  `1` = 8, `2` = 18, `3` = 28,
  `4` = 42, `5` = 52, `6` = 62,
  `7` = 72, `8` = 82, `9` = 92
)

rucc_description_map <- c(
  `1` = "Metro - Counties in metro areas of 1 million+",
  `2` = "Metro - Counties in metro areas of 250,000 to 1 million",
  `3` = "Metro - Counties in metro areas of fewer than 250,000",
  `4` = "Nonmetro - Urban pop 20,000+, adjacent to metro",
  `5` = "Nonmetro - Urban pop 20,000+, not adjacent to metro",
  `6` = "Nonmetro - Urban pop 2,500-19,999, adjacent to metro",
  `7` = "Nonmetro - Urban pop 2,500-19,999, not adjacent to metro",
  `8` = "Nonmetro - Completely rural or <2,500 urban, adjacent to metro",
  `9` = "Nonmetro - Completely rural or <2,500 urban, not adjacent to metro"
)

rucc <- rucc |>
  mutate(
    rucc_score = rucc_score_map[as.character(rucc_2023)],
    rucc_description = rucc_description_map[as.character(rucc_2023)],
    omb_designation = case_when(
      rucc_2023 <= 3 ~ "Metropolitan",
      rucc_2023 <= 5 ~ "Micropolitan",
      TRUE ~ "Nonmetro"
    )
  )

# ── 3. Get county land area and population density from Census ──────────────
cat("Fetching Census data...\n")

# Get land area from tigris
county_area <- tigris::counties(cb = FALSE, year = 2020) |>
  sf::st_drop_geometry() |>
  transmute(
    fips = paste0(STATEFP, COUNTYFP),
    land_area_sqmi = as.numeric(ALAND) / 2589988.11  # sq meters to sq miles
  )

# Get ACS data
acs_vars <- c(
  total_pop = "B01003_001",
  median_income = "B19013_001",
  median_age = "B01002_001"
)

acs_data <- get_acs(
  geography = "county",
  variables = acs_vars,
  year = 2022,
  survey = "acs5",
  output = "wide"
) |>
  transmute(
    fips = GEOID,
    acs_pop = total_popE,
    median_income = median_incomeE,
    median_age = median_ageE
  )

cat("ACS counties:", nrow(acs_data), "\n")

# ── 4. Metro areas for distance calculation ─────────────────────────────────
# Pulled from the app's metroAreas.js
large_metros <- tribble(
  ~name, ~lat, ~lng, ~pop,
  "New York, NY", 40.7128, -74.0060, 19768458,
  "Los Angeles, CA", 34.0522, -118.2437, 13214799,
  "Chicago, IL", 41.8781, -87.6298, 9618502,
  "Dallas-Fort Worth, TX", 32.7767, -96.7970, 7637387,
  "Houston, TX", 29.7604, -95.3698, 7122240,
  "Washington, DC", 38.9072, -77.0369, 6385162,
  "Philadelphia, PA", 39.9526, -75.1652, 6245051,
  "Miami, FL", 25.7617, -80.1918, 6138333,
  "Atlanta, GA", 33.7490, -84.3880, 6089815,
  "Boston, MA", 42.3601, -71.0589, 4941632,
  "Phoenix, AZ", 33.4484, -112.0740, 4845832,
  "San Francisco, CA", 37.7749, -122.4194, 4749008,
  "Riverside, CA", 33.9533, -117.3962, 4600396,
  "Detroit, MI", 42.3314, -83.0458, 4392041,
  "Seattle, WA", 47.6062, -122.3321, 4018762
)

medium_metros <- tribble(
  ~name, ~lat, ~lng, ~pop,
  "Fresno, CA", 36.7378, -119.7871, 1008654,
  "Omaha, NE", 41.2565, -95.9345, 967604,
  "Albuquerque, NM", 35.0844, -106.6504, 916774,
  "Albany, NY", 42.6526, -73.7562, 899262,
  "Boise, ID", 43.6150, -116.2023, 764718,
  "Colorado Springs, CO", 38.8339, -104.8214, 755105,
  "Spokane, WA", 47.6588, -117.4260, 573493,
  "Fayetteville, AR", 36.0626, -94.1574, 534904,
  "Little Rock, AR", 34.7465, -92.2896, 742384
)

small_metros <- tribble(
  ~name, ~lat, ~lng, ~pop,
  "Missoula, MT", 46.8721, -113.9940, 119600,
  "Billings, MT", 45.7833, -108.5007, 184167,
  "Flagstaff, AZ", 35.1983, -111.6513, 145101,
  "Jonesboro, AR", 35.8423, -90.7043, 135613,
  "Ithaca, NY", 42.4440, -76.5019, 105740
)

# Haversine distance in miles
haversine_miles <- function(lat1, lon1, lat2, lon2) {
  R <- 3958.8
  dlat <- (lat2 - lat1) * pi / 180
  dlon <- (lon2 - lon1) * pi / 180
  a <- sin(dlat / 2)^2 + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dlon / 2)^2
  R * 2 * asin(sqrt(a))
}

nearest_metro <- function(lat, lng, metros) {
  dists <- map_dbl(seq_len(nrow(metros)), ~ haversine_miles(lat, lng, metros$lat[.x], metros$lng[.x]))
  min(dists)
}

# ── 5. Get county centroids ─────────────────────────────────────────────────
cat("Computing county centroids...\n")

county_centroids <- tigris::counties(cb = TRUE, year = 2020) |>
  sf::st_centroid() |>
  mutate(
    fips = paste0(STATEFP, COUNTYFP),
    lat = sf::st_coordinates(geometry)[, 2],
    lng = sf::st_coordinates(geometry)[, 1]
  ) |>
  sf::st_drop_geometry() |>
  select(fips, lat, lng)

# ── 6. Calculate distances ──────────────────────────────────────────────────
cat("Calculating metro distances...\n")

county_centroids <- county_centroids |>
  mutate(
    dist_large_metro = map2_dbl(lat, lng, ~ nearest_metro(.x, .y, large_metros)),
    dist_medium_metro = map2_dbl(lat, lng, ~ nearest_metro(.x, .y, medium_metros)),
    dist_small_metro = map2_dbl(lat, lng, ~ nearest_metro(.x, .y, small_metros))
  )

# Distance score (matches app methodology)
calc_distance_score <- function(dist_large, dist_medium, dist_small) {
  score_large <- pmin(100, pmax(0, dist_large / 3))
  score_medium <- pmin(100, pmax(0, dist_medium / 2))
  score_small <- pmin(100, pmax(0, dist_small / 1))
  round(score_large * 0.5 + score_medium * 0.3 + score_small * 0.2)
}

county_centroids <- county_centroids |>
  mutate(
    distance_score = calc_distance_score(dist_large_metro, dist_medium_metro, dist_small_metro)
  )

# ── 7. Merge everything ────────────────────────────────────────────────────
cat("Merging datasets...\n")

county_data <- rucc |>
  left_join(county_area, by = "fips") |>
  left_join(acs_data, by = "fips") |>
  left_join(county_centroids, by = "fips") |>
  mutate(
    pop_density = round(acs_pop / land_area_sqmi, 1),
    # Density score (matches app methodology): 100 - log10(density) * 25
    density_score = round(pmin(100, pmax(0, 100 - log10(pmax(1, pop_density)) * 25)))
  )

# ── 8. Composite rurality score ─────────────────────────────────────────────
# Weights: RUCC 50%, density 25%, distance 15%, (broadband 10% — unavailable, redistributed)
# Without broadband: RUCC 55%, density 28%, distance 17%
county_data <- county_data |>
  mutate(
    rurality_score = round(rucc_score * 0.55 + density_score * 0.28 + distance_score * 0.17),
    rurality_classification = case_when(
      rurality_score >= 80 ~ "Very Rural",
      rurality_score >= 60 ~ "Rural",
      rurality_score >= 40 ~ "Mixed",
      rurality_score >= 20 ~ "Suburban",
      TRUE ~ "Urban"
    )
  )

# ── 9. Final output ────────────────────────────────────────────────────────
county_rurality <- county_data |>
  select(
    fips, state_fips, county_fips, state_abbr, county_name,
    pop_2020, acs_pop, land_area_sqmi, pop_density,
    rucc_2023, rucc_description, omb_designation,
    lat, lng,
    dist_large_metro = dist_large_metro,
    dist_medium_metro = dist_medium_metro,
    dist_small_metro = dist_small_metro,
    rucc_score, density_score, distance_score,
    rurality_score, rurality_classification,
    median_income, median_age
  ) |>
  arrange(fips)

cat("Final dataset:", nrow(county_rurality), "counties\n")
cat("Score distribution:\n")
county_rurality |> count(rurality_classification) |> print()

# Write CSV
write_csv(county_rurality, here::here("data-raw", "county_rurality.csv"))
cat("Written to data-raw/county_rurality.csv\n")

# Save as package data
usethis::use_data(county_rurality, overwrite = TRUE)
cat("Saved as package data\n")
