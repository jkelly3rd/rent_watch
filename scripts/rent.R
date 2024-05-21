library(tidyverse)
library(tidycensus)

# Import zillow rent data
rent_metro <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/Metro_zori_uc_sfrcondomfr_sm_sa_month.csv")
# Repeat with counties
rent_county <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/County_zori_uc_sfrcondomfr_tier_0.33_0.67_sm_sa_mon.csv")
# Repeat with zip codes
rent_zip <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/Zip_zori_uc_sfrcondomfr_tier_0.33_0.67_sm_sa_mon.csv")
# Repeat with cities
rent_city <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/City_zori_uc_sfrcondomfr_tier_0.33_0.67_sm_sa_mon.csv")

