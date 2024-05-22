library(tidyverse)
library(tidycensus)

# Import zillow rent data
rent_metro <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/Metro_zori_uc_sfrcondomfr_sm_month.csv")
# Repeat with counties
rent_county <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/County_zori_uc_sfrcondomfr_sm_month.csv")
# Repeat with zip codes
rent_zip <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/Zip_zori_uc_sfrcondomfr_sm_month.csv")
# Repeat with cities
rent_city <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/City_zori_uc_sfrcondomfr_sm_month.csv")

# Filter the most recent month and the same month from the five previous years
rent_metro_5yrs <- rent_metro %>%
  select(3,5,57,69,81,93,105,117)
rent_county_5yrs <- rent_county %>%
  select(3,5,61,73,85,97,109,121)
rent_zip_5yrs <- rent_zip %>%
  select(3,5,61,73,85,97,109,121)
rent_city_5yrs <- rent_city %>%
  select(3,5,60,72,84,96,108,120)

# Format the five year tables with rounded figures in the last five columns with no demical places
rent_metro_5yrs <- rent_metro_5yrs %>%
  mutate(across(3:8, round, digits = 0))
rent_county_5yrs <- rent_county_5yrs %>%
  mutate(across(3:8, round, digits = 0))
rent_zip_5yrs <- rent_zip_5yrs %>%
  mutate(across(3:8, round, digits = 0))
rent_city_5yrs <- rent_city_5yrs %>%
  mutate(across(3:8, round, digits = 0))

# Rename the last five columns to the first four characters of the current column name
rent_metro_5yrs <- rent_metro_5yrs %>%
  rename_with(~substr(., 1, 4), 3:8)
rent_county_5yrs <- rent_county_5yrs %>%
  rename_with(~substr(., 1, 4), 3:8)
rent_zip_5yrs <- rent_zip_5yrs %>%
  rename_with(~substr(., 1, 4), 3:8)
rent_city_5yrs <- rent_city_5yrs %>%
  rename_with(~substr(., 1, 4), 3:8)

# In metro data, add a percentage change from column named 2023 to 2024
rent_metro_5yrs <- rent_metro_5yrs %>%
  mutate(change1yr = ((`2024` - `2023`) / `2023`) * 100)
rent_metro_5yrs$change1yr <- round(rent_metro_5yrs$change1yr,1)
# Repeat for change from 2020 to 2024
rent_metro_5yrs <- rent_metro_5yrs %>%
  mutate(change5yr = ((`2024` - `2019`) / `2019`) * 100)
rent_metro_5yrs$change5yr <- round(rent_metro_5yrs$change5yr,1)
# Repeat for other geographies county, city and zip
rent_county_5yrs <- rent_county_5yrs %>%
  mutate(change1yr = ((`2024` - `2023`) / `2023`) * 100)
rent_county_5yrs$change1yr <- round(rent_county_5yrs$change1yr,1)
rent_county_5yrs <- rent_county_5yrs %>%
  mutate(change5yr = ((`2024` - `2019`) / `2019`) * 100)
rent_county_5yrs$change5yr <- round(rent_county_5yrs$change5yr,1)
rent_zip_5yrs <- rent_zip_5yrs %>%
  mutate(change1yr = ((`2024` - `2023`) / `2023`) * 100)
rent_zip_5yrs$change1yr <- round(rent_zip_5yrs$change1yr,1)
rent_zip_5yrs <- rent_zip_5yrs %>%
  mutate(change5yr = ((`2024` - `2019`) / `2019`) * 100)
rent_zip_5yrs$change5yr <- round(rent_zip_5yrs$change5yr,1)
rent_city_5yrs <- rent_city_5yrs %>%
  mutate(change1yr = ((`2024` - `2023`) / `2023`) * 100)
rent_city_5yrs$change1yr <- round(rent_city_5yrs$change1yr,1)
rent_city_5yrs <- rent_city_5yrs %>%
  mutate(change5yr = ((`2024` - `2019`) / `2019`) * 100)
rent_city_5yrs$change5yr <- round(rent_city_5yrs$change5yr,1)


# use tidycensus to get the median income for miami-dade county and broward county
# get the median income for miami-dade county
miami_dade_income <- get_acs(geography = "county", variables = "B19013_001", state = "FL", county = "Miami-Dade", survey = "acs5", year = 2019)
# get the median income for broward county
broward_income <- get_acs(geography = "county", variables = "B19013_001", state = "FL", county = "Broward", survey = "acs5", year = 2019)


# create a table with the first column being values from state.name and the second being the state.abbr
states <- data.frame(state.name, state.abb)
# add a third row called swing and assign as true if the state is PA, WI, MI, OH, FL, NC, AZ, GA, NV or TX
states$swing <- states$state.abb %in% c("PA", "WI", "MI", "NC", "AZ", "GA", "NV")

# Remove from rent_metro_5yrs all rows where the any of columns 3:8 are NA
rent_metro_5yrs <- rent_metro_5yrs %>%
  filter(!is.na(`2024`), !is.na(`2023`), !is.na(`2019`))
# Remove if region name is United States
rent_metro_5yrs <- rent_metro_5yrs %>%
  filter(RegionName != "United States")
# Append swing state column to rent_metro_5yrs by joining with states on state abbreviation
rent_metro_5yrs <- rent_metro_5yrs %>%
  left_join(states %>% select(2:3), by = c("StateName" = "state.abb"))

# Remove from rent_city_5yrs all rows where the any of columns 3:8 are NA
rent_city_5yrs <- rent_city_5yrs %>%
  filter(!is.na(`2024`), !is.na(`2023`), !is.na(`2019`))
# Remove if region name is United States
rent_city_5yrs <- rent_city_5yrs %>%
  filter(RegionName != "United States")
# Append swing state column to rent_city_5yrs by joining with states on state abbreviation
rent_city_5yrs <- rent_city_5yrs %>%
  left_join(states %>% select(2:3), by = c("StateName" = "state.abb"))


