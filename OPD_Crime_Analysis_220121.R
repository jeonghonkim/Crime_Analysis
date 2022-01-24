# Orlando Crime Data
# Get ACS data

# 0. install packages

# install.packages("tidyverse")
# install.packages("tidycensus")
# install.packages("viridis")
# install.packages("sp")
# install.packages("sf")


# 1. Library

library(tidyverse)
library(tidycensus)
library(viridis)
library(sp)
library(sf)

  # Save the census api key

census_api_key("42e1b9b3b73ee4990e7c15500d52250286ba72cc", overwrite = FALSE, install = FALSE)


# 2. Access and request ACS data

  # 1) Check the whole variables in each year

acs2019 <- load_variables(2019, "acs5", cache = TRUE)
dec2010 <- load_variables(2010, "sf1", cache = TRUE)
view(acs2019)
view(dec2010)

  # 2) Get the variables in Orange County, FL

dat.acs5.19 <- get_acs(geography = "tract", county = "Orange", state = "FL", 
                 year = 2019, survey = "acs5", geometry = TRUE,
                 variables = c(
                   pop.total = "B02001_001",        # Population - Total
                   race.total = "B03002_001",       # Race - Total
                   race.white = "B03002_003",       # Race - White population
                   race.afam = "B03002_004",        # Race - African-american
                   race.hisp = "B03002_012",        # Race - Hispanic
                   race.asian = "B03002_006",       # Race - Asian
                   house.total = "B25002_001",      # House - Total
                   house.vacant = "B25002_003",     # House - Vacant
                   house.medrent = "B25064_001",    # House - Median gross rent
                   fin.medincome = "B19013_001",    # Finance - Median household income in the past 12 months
                   fin.rentpct = "B25071_001",      # Finance - Median gross rent as a percentage of household income
                   emp.civil.total = "B23025_003",  # Employment - Total civilian labor force
                   emp.civil.emp = "B23025_004",    # Employment - Employed civilian labor force
                   emp.civil.not = "B23025_005",    # Employment - Unemployed civilian labor force
                   emp.labor.total = "B23025_001",  # Employment - Total labor force
                   emp.labor.not = "B23025_007",    # Employment - Not in labor force
                   poverty.total = "B17001_001",    # Poverty - Total population
                   poverty.below = "B17001_002",    # Poverty - Below poverty status in the past 12 months
                   edu.total = "B15003_001",        # Education - Total
                   edu.hischool = "B15003_017",     # Education - High School Diploma
                   edu.ged = "B15003_018",          # Education - GED
                   edu.somecol1 = "B15003_019",     # Education - Some college, less than 1 year
                   edu.somecol1p = "B15003_020",    # Education - Some college, 1 or more years, no degree
                   edu.associate = "B15003_021",    # Education - Associate's degree
                   edu.bachelor = "B15003_022",     # Education - Bachelor's degree
                   edu.master = "B15003_023",       # Education - Master's degree
                   edu.profession = "B15003_024",   # Education - Professional school degree
                   edu.phd = "B15003_025"           # Education - Doctorate degree
                ))

# Change to the long dataframe to wide dataframe
dat.acs5.19_sdf <- as.data.frame(dat.acs5.19)[,c(1,3,4,6)] %>%
  spread(variable, estimate) 

View(dat.acs5.19_sdf)

st_write(dat.acs5.19_sdf, "C:/Users/KIM36105/Downloads/Orlando_Crime_Analysis/R/shpacs5_19.shp")





