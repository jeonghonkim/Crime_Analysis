# Orlando Crime Data
# Get ACS data



# 0. Install packages & Update the most recent packages
# install.packages("tidyverse")
# install.packages("tidycensus")
# install.packages("viridis")
# install.packages("tigris")
# install.packages("censusapi")
# install.packages("sp")
# install.packages("sf")
# install.packages("ggplot2")
# install.packages("ggthemes")
# install.packages("gridExtra")
# install.packages("totalcensus")
# install.packages("mapview")
# install.packages("terra")
# update.packages()



# 1. Library
library(dplyr)
library(tidyverse)
library(tidycensus)
library(viridis)
library(sp)
library(sf)
library(tigris)
library(ggplot2)
library(ggthemes)
library(gridExtra)
library(terra)



# 2. Access and request ACS data
# Request the census api key
census_api_key("42e1b9b3b73ee4990e7c15500d52250286ba72cc", overwrite = FALSE, install = FALSE)
readRenviron("~/.Renviron") # restarts R session in order to use tidycensus api key

# Check the whole variables in each year
acs2019 <- load_variables(2019, "acs5", cache = TRUE)
acs2015 <- load_variables(2015, "acs5", cache = TRUE)
dec2010 <- load_variables(2010, "sf1", cache = TRUE)
view(acs2019)
view(acs2015)
view(dec2010)

# Get the census blcok group data in Orange County, FL
dat.acs5.19 <- get_acs(geography = "block group", county = "Orange", state = "FL", 
                 year = 2019, survey = "acs5", geometry = TRUE,
                 variables = c(
                   pp_totl_19c = "B02001_001",      # Population - Total
                   rc_totl_19c = "B03002_001",      # Race - Total
                   rc_whit_19c = "B03002_003",      # Race - White population
                   rc_afam_19c = "B03002_004",      # Race - African-american
                   rc_hisp_19c = "B03002_012",      # Race - Hispanic
                   rc_asan_19c = "B03002_006",      # Race - Asian
                   hs_totl_19c = "B25002_001",      # House - Total
                   hs_occp_19c = "B25002_002",      # House - Occupied
                   hs_vcnt_19c = "B25002_003",      # House - Vacant
                   hs_mrnt_19d = "B25064_001",      # House - Median gross rent
                   fn_minc_19d = "B19013_001",      # Finance - Median household income in the past 12 months
                   fn_prnt_19p = "B25071_001",      # Finance - Median gross rent as a percentage of household income
                   em_cttl_19c = "B23025_003",      # Employment - Total civilian labor force
                   em_cemp_19c = "B23025_004",      # Employment - Employed civilian labor force
                   em_cnot_19c = "B23025_005",      # Employment - Unemployed civilian labor force
                   em_lttl_19c = "B23025_001",      # Employment - Total labor force
                   em_lnot_19c = "B23025_007",      # Employment - Not in labor force
                   pv_totl_19c = "B17001_001",      # Poverty - Total population
                   pv_belw_19c = "B17001_002",      # Poverty - Below poverty status in the past 12 months
                   ed_totl_19c = "B15003_001",      # Education - Total
                   ed_hisc_19c = "B15003_017",      # Education - High School Diploma
                   ed_gedd_19c = "B15003_018",      # Education - GED
                   ed_col1_19c = "B15003_019",      # Education - Some college, less than 1 year
                   ed_col2_19c = "B15003_020",      # Education - Some college, 1 or more years, no degree
                   ed_assc_19c = "B15003_021",      # Education - Associate's degree
                   ed_bach_19c = "B15003_022",      # Education - Bachelor's degree
                   ed_mast_19c = "B15003_023",      # Education - Master's degree
                   ed_prof_19c = "B15003_024",      # Education - Professional school degree
                   ed_phdd_19c = "B15003_025"       # Education - Doctorate degree
                ))

dat.acs5.15 <- get_acs(geography = 'block group', county = "Orange", state = "FL",
                       year = 2015, survey = "acs5", geometry = TRUE,
                       variables = c(
                         pp_totl_15c = "B02001_001",      # Population - Total
                         rc_totl_15c = "B03002_001",      # Race - Total
                         rc_whit_15c = "B03002_003",      # Race - White population
                         rc_afam_15c = "B03002_004",      # Race - African-american
                         rc_hisp_15c = "B03002_012",      # Race - Hispanic
                         rc_asan_15c = "B03002_006",      # Race - Asian
                         hs_totl_15c = "B25002_001",      # House - Total
                         hs_occp_15c = "B25002_002",      # House - Occupied
                         hs_vcnt_15c = "B25002_003",      # House - Vacant
                         hs_mrnt_15d = "B25064_001",      # House - Median gross rent
                         fn_minc_15d = "B19013_001",      # Finance - Median household income in the past 12 months
                         fn_prnt_15p = "B25071_001",      # Finance - Median gross rent as a percentage of household income
                         em_cttl_15c = "B23025_003",      # Employment - Total civilian labor force
                         em_cemp_15c = "B23025_004",      # Employment - Employed civilian labor force
                         em_cnot_15c = "B23025_005",      # Employment - Unemployed civilian labor force
                         em_lttl_15c = "B23025_001",      # Employment - Total labor force
                         em_lnot_15c = "B23025_007",      # Employment - Not in labor force
                         pv_totl_15c = "B17001_001",      # Poverty - Total population
                         pv_belw_15c = "B17001_002",      # Poverty - Below poverty status in the past 12 months
                         ed_totl_15c = "B15003_001",      # Education - Total
                         ed_hisc_15c = "B15003_017",      # Education - High School Diploma
                         ed_gedd_15c = "B15003_018",      # Education - GED
                         ed_col1_15c = "B15003_019",      # Education - Some college, less than 1 year
                         ed_col2_15c = "B15003_020",      # Education - Some college, 1 or more years, no degree
                         ed_assc_15c = "B15003_021",      # Education - Associate's degree
                         ed_bach_15c = "B15003_022",      # Education - Bachelor's degree
                         ed_mast_15c = "B15003_023",      # Education - Master's degree
                         ed_prof_15c = "B15003_024",      # Education - Professional school degree
                         ed_phdd_15c = "B15003_025"       # Education - Doctorate degree
                       ))
view(dat.acs5.19)
view(dat.acs5.15)



# 3. Change to the long dataframe to wide dataframe
dat.acs5.19_total <-
dat.acs5.19[, c(1, 3, 4, 6)] %>%
  spread(variable, estimate) %>%  
  mutate(
    ed_lged_19c = ed_totl_19c - (ed_assc_19c + ed_bach_19c + ed_gedd_19c + ed_hisc_19c + 
                                 ed_mast_19c + ed_phdd_19c + ed_prof_19c + ed_col1_19c +
                                 ed_col2_19c),
    ed_hige_19c = ed_gedd_19c + ed_hisc_19c,
    ed_scol_19c = ed_assc_19c + ed_col1_19c + ed_col2_19c,
    ed_advn_19c = ed_mast_19c + ed_phdd_19c + ed_prof_19c,
    rc_othr_19c = rc_totl_19c - (rc_whit_19c + rc_afam_19c + rc_hisp_19c + rc_asan_19c),
    ed_lged_19p = (ed_lged_19c / ed_totl_19c) * 100,
    ed_hige_19p = (ed_hige_19c / ed_totl_19c) * 100,
    ed_scol_19p = (ed_scol_19c / ed_totl_19c) * 100,
    ed_bach_19p = (ed_bach_19c / ed_totl_19c) * 100,
    ed_advn_19p = (ed_advn_19c / ed_totl_19c) * 100,
    em_cnot_19p = (em_cnot_19c / em_cttl_19c) * 100,
    em_lnot_19p = (em_lnot_19c / em_lttl_19c) * 100,
    hs_vcnt_19p = (hs_vcnt_19c / hs_totl_19c) * 100,
    pv_belw_19p = (pv_belw_19c / pv_totl_19c) * 100,
    rc_whit_19p = (rc_whit_19c / rc_totl_19c) * 100,
    rc_afam_19p = (rc_afam_19c / rc_totl_19c) * 100,
    rc_hisp_19p = (rc_hisp_19c / rc_totl_19c) * 100,
    rc_asan_19p = (rc_asan_19c / rc_totl_19c) * 100,
    rc_othr_19p = (rc_othr_19c / rc_totl_19c) * 100
  ) %>%
  mutate(across(where(is.numeric), round, 1)) %>%
  select(
    GEOID, 
    pp_totl_19c,   # 1) Population - # 
    rc_whit_19p,   # 2) Race       - %
    rc_afam_19p, 
    rc_hisp_19p, 
    rc_asan_19p, 
    rc_othr_19p,   
    ed_lged_19p,   # 3) Education  - %
    ed_hige_19p,
    ed_scol_19p,
    ed_bach_19p,
    ed_advn_19p,
    fn_minc_19d,   # 4) Finance    - $, %     
    fn_prnt_19p,    
    hs_mrnt_19d,     
    hs_vcnt_19p,   # 5) Housing    - $, %
    pv_belw_19p,   # 6) Poverty    - %
    em_cnot_19p,   # 7) Employment - %
    em_lnot_19p,
    geometry       # 8) Geometry
  )

dat.acs5.15_total <-
  dat.acs5.15[, c(1, 3, 4, 6)] %>%
  spread(variable, estimate) %>%  
  mutate(
    ed_lged_15c = ed_totl_15c - (ed_assc_15c + ed_bach_15c + ed_gedd_15c + ed_hisc_15c + 
                                   ed_mast_15c + ed_phdd_15c + ed_prof_15c + ed_col1_15c +
                                   ed_col2_15c),
    ed_hige_15c = ed_gedd_15c + ed_hisc_15c,
    ed_scol_15c = ed_assc_15c + ed_col1_15c + ed_col2_15c,
    ed_advn_15c = ed_mast_15c + ed_phdd_15c + ed_prof_15c,
    rc_othr_15c = rc_totl_15c - (rc_whit_15c + rc_afam_15c + rc_hisp_15c + rc_asan_15c),
    ed_lged_15p = (ed_lged_15c / ed_totl_15c) * 100,
    ed_hige_15p = (ed_hige_15c / ed_totl_15c) * 100,
    ed_scol_15p = (ed_scol_15c / ed_totl_15c) * 100,
    ed_bach_15p = (ed_bach_15c / ed_totl_15c) * 100,
    ed_advn_15p = (ed_advn_15c / ed_totl_15c) * 100,
    em_cnot_15p = (em_cnot_15c / em_cttl_15c) * 100,
    em_lnot_15p = (em_lnot_15c / em_lttl_15c) * 100,
    hs_vcnt_15p = (hs_vcnt_15c / hs_totl_15c) * 100,
    pv_belw_15p = (pv_belw_15c / pv_totl_15c) * 100,
    rc_whit_15p = (rc_whit_15c / rc_totl_15c) * 100,
    rc_afam_15p = (rc_afam_15c / rc_totl_15c) * 100,
    rc_hisp_15p = (rc_hisp_15c / rc_totl_15c) * 100,
    rc_asan_15p = (rc_asan_15c / rc_totl_15c) * 100,
    rc_othr_15p = (rc_othr_15c / rc_totl_15c) * 100
  ) %>%
  mutate(across(where(is.numeric), round, 1)) %>%
  select(
    GEOID, 
    pp_totl_15c,   # 1) Population - # 
    rc_whit_15p,   # 2) Race       - %
    rc_afam_15p, 
    rc_hisp_15p, 
    rc_asan_15p, 
    rc_othr_15p,   
    ed_lged_15p,   # 3) Education  - %
    ed_hige_15p,
    ed_scol_15p,
    ed_bach_15p,
    ed_advn_15p,
    fn_minc_15d,   # 4) Finance    - $, %     
    fn_prnt_15p,    
    hs_mrnt_15d,     
    hs_vcnt_15p,   # 5) Housing    - $, %
    pv_belw_15p,   # 6) Poverty    - %
    em_cnot_15p,   # 7) Employment - %
    em_lnot_15p,
    geometry       # 8) Geometry
  )

view(dat.acs5.19_total)
view(dat.acs5.15_total)



# 4. Create sample plots
p1 <- dat.acs5.19_total %>%
  ggplot() +
  geom_sf(aes(fill = fn_minc_19d)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Median Income 19', $",
                       low = "white",
                       high = "green"
  )
p2 <- dat.acs5.19_total %>%
  ggplot() +
  geom_sf(aes(fill = ed_advn_19p)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Advanced Degree 19', %",
                       low = "white",
                       high = "green"
  )
p3 <- dat.acs5.15_total %>%
  ggplot() +
  geom_sf(aes(fill = fn_minc_15d)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Median Income 15', $",
                       low = "white",
                       high = "orange"
  )
p4 <- dat.acs5.15_total %>%
  ggplot() +
  geom_sf(aes(fill = ed_advn_15p)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Advanced Degree 15', %",
                       low = "white",
                       high = "orange"
  )
grid.arrange(p1, p2, p3, p4, ncol=2)



# 5. Check the spatial reference
st_crs(dat.acs5.19_total) # 4269
st_crs(dat.acs5.15_total) # 4269
dat.acs5.19_total_prj <- st_transform(dat.acs5.19_total, 4326)
dat.acs5.15_total_prj <- st_transform(dat.acs5.15_total, 4326)
st_crs(dat.acs5.19_total_prj)
st_crs(dat.acs5.15_total_prj)



# 6. Exporting the completed sdf to a shapefile in a local drive
st_write(dat.acs5.19_total_prj, "C:/Users/KIM36105/Downloads/Orlando_Crime_Analysis/ACS19_220127.shp")
st_write(dat.acs5.15_total_prj, "C:/Users/KIM36105/Downloads/Orlando_Crime_Analysis/ACS15_220127.shp")


