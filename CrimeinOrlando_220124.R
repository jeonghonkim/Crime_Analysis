# Orlando Crime Data
# Get ACS data

# 0. install packages

# install.packages("tidyverse")
# install.packages("tidycensus")
# install.packages("viridis")
# install.packages("sp")
# install.packages("sf")
# install.packages("ggplot2")
# install.packages("ggthemes")
# install.packages("gridExtra")

# 1. Library

library(dplyr)
library(tidyverse)
library(tidycensus)
library(viridis)
library(sp)
library(sf)
library(ggplot2)
library(ggthemes)
library(gridExtra)

  # Save the census api key

census_api_key("42e1b9b3b73ee4990e7c15500d52250286ba72cc", overwrite = FALSE, install = FALSE)
readRenviron("~/.Renviron") # restarts R session in order to use tidycensus api key

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
                   house.medrent = "B25064_001",    # House - Median gross rentV
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
                   edu.somecol2 = "B15003_020",     # Education - Some college, 1 or more years, no degree
                   edu.associate = "B15003_021",    # Education - Associate's degree
                   edu.bachelor = "B15003_022",     # Education - Bachelor's degree
                   edu.master = "B15003_023",       # Education - Master's degree
                   edu.profession = "B15003_024",   # Education - Professional school degree
                   edu.phd = "B15003_025"           # Education - Doctorate degree
                ))
view(dat.acs5.19)

    # Plot for checking the location data

plot1 <- dat.acs5.19%>%
  filter(variable == "fin.medincome") %>%
  ggplot() +
  geom_sf(aes(fill = estimate)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Meidna Household Income",
                       low = "white",
                       high = "orange"
                       )
plot1
    
    # correct information


# 3) Change to the long dataframe to wide dataframe
dat.acs5.19_total =
dat.acs5.19[, c(1, 3, 4, 6)] %>%
  spread(variable, estimate) %>%  
  mutate(
    edu.lessged = edu.total - (edu.associate + edu.bachelor + edu.ged + edu.hischool + 
                                 edu.master + edu.phd + edu.profession + edu.somecol1 +
                                 edu.somecol2),
    eud.higed = edu.ged + edu.hischool,
    edu.somecol = edu.associate + edu.somecol1 + edu.somecol2,
    edu.advanced = edu.master + edu.phd + edu.profession,
    race.other = race.total - (race.white + race.afam + race.hisp + race.asian),
    pct.edu.lessged = (edu.lessged / edu.total) * 100,
    pct.edu.higed = (eud.higed / edu.total) * 100,
    pct.edu.somecol = (edu.somecol / edu.total) * 100,
    pct.edu.bachelor = (edu.bachelor / edu.total) * 100,
    pct.edu.advanced = (edu.advanced / edu.total) * 100,
    pct.emp.emp = (emp.civil.emp / emp.civil.total) * 100,
    pct.emp.not = (emp.civil.not / emp.civil.total) * 100,
    pct.emp.nlabor = (emp.labor.not / emp.labor.total) * 100,
    pct.hom.vacant = (house.vacant / house.total) * 100,
    pct.pov.below = (poverty.below / poverty.total) * 100,
    pct.rac.white = (race.white / race.total) * 100,
    pct.rac.afam = (race.afam / race.total) * 100,
    pct.rac.hisp = (race.hisp / race.total) * 100,
    pct.rac.asian = (race.asian / race.total) * 100,
    pct.rac.other = (race.other / race.total) * 100
  ) %>%
  mutate(across(where(is.numeric), round, 1))

head(dat.acs5.19_total)


# 4-1) Create a subset for 'education'
dat.acs5.19_edu <-
dat.acs5.19_total %>%
  select(edu.total, edu.lessged:edu.somecol, edu.bachelor, edu.advanced, pct.edu.lessged:pct.edu.advanced) %>%
  mutate(
    pct.edu.lessged_higed = pct.edu.lessged + pct.edu.higed, 
    pct.edu.bach_advanced = pct.edu.bachelor + pct.edu.advanced
  )
head(dat.acs5.19_edu)

# 4-2) Create a subset for 'House and Finance'
dat.acs5.19_housefinance <-
  dat.acs5.19_total %>%
  select(edu.lessged:edu.somecol, edu.bachelor, edu.advanced, pct.edu.lessged:pct.edu.advanced)

colnames(dat.acs5.19_total)


# 4-x) create sample plots with the percentage of advanced degree and less than GED Degree
p1 <- dat.acs5.19_edu %>%
  ggplot() +
  geom_sf(aes(fill = pct.edu.lessged)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Less than GED Degree, %",
                       low = "white",
                       high = "orange"
  )
p2 <- dat.acs5.19_edu %>%
  ggplot() +
  geom_sf(aes(fill = pct.edu.advanced)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Advanced Degree, %",
                       low = "white",
                       high = "orange"
  )
p3 <- dat.acs5.19_edu %>%
  ggplot() +
  geom_sf(aes(fill = pct.edu.lessged_higed)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Less GED + GED, %",
                       low = "white",
                       high = "Red"
  )
p4 <- dat.acs5.19_edu %>%
  ggplot() +
  geom_sf(aes(fill = pct.edu.bach_advanced)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Bachelor + Advanced, %",
                       low = "white",
                       high = "Red"
  )

grid.arrange(p1, p2, p3, p4, ncol=2)

# 4-2) Create a subset shapefile for joining it with orlando crime data

colnames(dat.acs5.19_total)

dat.acs5.19_export =
dat.acs5.19_total[, c(22, 46:50, 17, 19, 18, 44, 42, 43, 45, 36:40)]

head(dat.acs5.19_export)

# Write sdf to shpaefile for the cnesus tracts
st_write(dat.acs5.19_export, "C:/Users/KIM36105/Downloads/Orlando_Crime_Analysis/acs5_19_export.shp")

