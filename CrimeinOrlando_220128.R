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
# rm(list = ls())


# 2. Access and request ACS data
# Request the census api key
census_api_key("42e1b9b3b73ee4990e7c15500d52250286ba72cc", overwrite = FALSE, install = FALSE)
readRenviron("~/.Renviron") # restarts R session in order to use tidycensus api key

# Check the whole variables in each year
var.acs5.19 <- load_variables(2019, "acs5", cache = TRUE)
var.acs5.15 <- load_variables(2015, "acs5", cache = TRUE)
var.dec.10 <- load_variables(2010, "sf1", cache = TRUE)
view(var.acs5.19)
view(var.acs5.15)
view(var.dec.10)

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
                   hs_mcst_19d = "B25088_001",      # House - Median selected monthly owner costs - Total
                   hs_mcst_19d = "B25088_002",      # House - Median selected monthly owner costs - With a mortgage
                   hs_mcst_19d = "B25088_003",      # House - Median selected monthly owner costs - Without a mortgage
                   hs_yttl_19c = "B25034_001",      # House - Year structure built - Total
                   hs_14yy_19c = "B25034_002",      # House - Year structure built - Built 2014 or later
                   hs_1013_19c = "B25034_003",      # House - Year structure built - Built 2010 to 2013
                   hs_0009_19c = "B25034_004",      # House - Year structure built - Built 2000 to 2009
                   hs_9099_19c = "B25034_005",      # House - Year structure built - Built 1990 to 1999
                   hs_8089_19c = "B25034_006",      # House - Year structure built - Built 1980 to 1989
                   hs_7079_19c = "B25034_007",      # House - Year structure built - Built 1970 to 1979
                   hs_6069_19c = "B25034_008",      # House - Year structure built - Built 1960 to 1969
                   hs_5059_19c = "B25034_009",      # House - Year structure built - Built 1950 to 1959
                   hs_4049_19c = "B25034_010",      # House - Year structure built - Built 1940 to 1949
                   hs_yy39_19c = "B25034_011",      # House - Year structure built - Built 1939 or earlier
                   hs_mdyr_19y = "B25035_001",      # House - Median Year structure built
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
                   ed_phdd_19c = "B15003_025",      # Education - Doctorate degree
                   vc_httl_19c = "B08201_001",      # Vehicle - Total, Available Vehicles by household
                   vc_hh00_19c = "B08201_002",      # Vehicle - No vehicle available
                   vc_hh01_19c = "B08201_003",      # Vehicle - 1 vehicle available
                   vc_hh02_19c = "B08201_004",      # Vehicle - 2 vehicle available
                   vc_hh03_19c = "B08201_005",      # Vehicle - 3 vehicle available
                   vc_hh04_19c = "B08201_006",      # Vehicle - 4 or more vehicle 
                   tp_totl_19c = "B08301_001",      # MEANS OF TRANSPORTATION TO WORK - Total
                   tp_vhcl_19c = "B08301_002",      # MEANS OF TRANSPORTATION TO WORK - 1) Car, truck, or van
                   tp_drv1_19c = "B08301_003",      # MEANS OF TRANSPORTATION TO WORK - 1-1) Drive alone 
                   tp_crpl_19c = "B08301_004",      # MEANS OF TRANSPORTATION TO WORK - 1-2) Carpool
                   tp_pbtp_19c = "B08301_010",      # MEANS OF TRANSPORTATION TO WORK - 2) Public Transportation
                   tp_taxi_19c = "B08301_016",      # MEANS OF TRNAPSORTATION TO WORK - 3) Taxicab
                   tp_mtcy_19c = "B08301_017",      # MEANS OF TRNAPSORTATION TO WORK - 4) Motorcycle
                   tp_bicy_19c = "B08301_018",      # MEANS OF TRNAPSORTATION TO WORK - 5) Bicycle
                   tp_walk_19c = "B08301_019",      # MEANS OF TRNAPSORTATION TO WORK - 6) Walk
                   tp_othr_19c = "B08301_020",      # MEANS OF TRNAPSORTATION TO WORK - 7) Other means
                   tp_home_19c = "B08301_021",      # MEANS OF TRNASPORTATION TO WORK - 8) Work from home
                   oc_totl_19c = "C24060_001",      # Occupation by Class - 1) Total
                   oc_mngm_19c = "C24060_002",      # Occupation by Class - 2) Management, business, science, and arts occupations
                   oc_srvc_19c = "C24060_003",      # Occupation by Class - 3) Service occupations
                   oc_sale_19c = "C24060_004",      # Occupation by Class - 4) Sales and office occupations
                   oc_cnst_19c = "C24060_005",      # Occupation by Class - 5) Natural resources, construction, and maintenance occupations
                   oc_trsp_19c = "C24060_006",      # Occupation by Class - 6) Production, transportation, and material moving occupations
                   oc_prvt_19c = "C24060_007",      # Occupation by Class - 7) Employee of private company workers
                   oc_self_19c = "C24060_013",      # Occupation by Class - 13) Self-employed in own incorporated business workers
                   oc_nprf_19c = "C24060_019",      # Occupation by Class - 19) Private not-for-profit wage and salary workers:
                   oc_govm_19c = "C24060_025",      # Occupation by Class - 25) Local, state, and federal government workers
                   oc_self_19c = "C24060_031"       # Occupation by Class of Worker for the Civilian Population - 31) Self-employed in own not incorporated business workers and unpaid family workers
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
                         hs_mcst_15d = "B25088_001",      # House - Median selected monthly owner costs - Total
                         hs_mcst_15d = "B25088_002",      # House - Median selected monthly owner costs - With a mortgage
                         hs_mcst_15d = "B25088_003",      # House - Median selected monthly owner costs - Without a mortgage
                         hs_yttl_15c = "B25034_001",      # House - Year structure built - Total
                         hs_14yy_15c = "B25034_002",      # House - Year structure built - Built 2014 or later
                         hs_1013_15c = "B25034_003",      # House - Year structure built - Built 2010 to 2013
                         hs_0009_15c = "B25034_004",      # House - Year structure built - Built 2000 to 2009
                         hs_9099_15c = "B25034_005",      # House - Year structure built - Built 1990 to 1999
                         hs_8089_15c = "B25034_006",      # House - Year structure built - Built 1980 to 1989
                         hs_7079_15c = "B25034_007",      # House - Year structure built - Built 1970 to 1979
                         hs_6069_15c = "B25034_008",      # House - Year structure built - Built 1960 to 1969
                         hs_5059_15c = "B25034_009",      # House - Year structure built - Built 1950 to 1959
                         hs_4049_15c = "B25034_010",      # House - Year structure built - Built 1940 to 1949
                         hs_yy39_15c = "B25034_011",      # House - Year structure built - Built 1939 or earlier
                         hs_mdyr_15y = "B25035_001",      # House - Median Year structure built
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
                         ed_phdd_15c = "B15003_025",      # Education - Doctorate degree
                         vc_httl_15c = "B08201_001",      # Vehicle - Total, Available Vehicles by household
                         vc_hh00_15c = "B08201_002",      # Vehicle - No vehicle available
                         vc_hh01_15c = "B08201_003",      # Vehicle - 1 vehicle available
                         vc_hh02_15c = "B08201_004",      # Vehicle - 2 vehicle available
                         vc_hh03_15c = "B08201_005",      # Vehicle - 3 vehicle available
                         vc_hh04_15c = "B08201_006",      # Vehicle - 4 or more vehicle
                         tp_totl_15c = "B08301_001",      # MEANS OF TRANSPORTATION TO WORK - Total
                         tp_vhcl_15c = "B08301_002",      # MEANS OF TRANSPORTATION TO WORK - 1) Car, truck, or van
                         tp_drv1_15c = "B08301_003",      # MEANS OF TRANSPORTATION TO WORK - 1-1) Drive alone 
                         tp_crpl_15c = "B08301_004",      # MEANS OF TRANSPORTATION TO WORK - 1-2) Carpool
                         tp_pbtp_15c = "B08301_010",      # MEANS OF TRANSPORTATION TO WORK - 2) Public Transportation
                         tp_taxi_15c = "B08301_016",      # MEANS OF TRNAPSORTATION TO WORK - 3) Taxicab
                         tp_mtcy_15c = "B08301_017",      # MEANS OF TRNAPSORTATION TO WORK - 4) Motorcycle
                         tp_bicy_15c = "B08301_018",      # MEANS OF TRNAPSORTATION TO WORK - 5) Bicycle
                         tp_walk_15c = "B08301_019",      # MEANS OF TRNAPSORTATION TO WORK - 6) Walk
                         tp_othr_15c = "B08301_020",      # MEANS OF TRNAPSORTATION TO WORK - 7) Other means
                         tp_home_15c = "B08301_021",      # MEANS OF TRNASPORTATION TO WORK - 8) Work from home
                         oc_totl_15c = "C24060_001",      # Occupation by Class - 1) Total
                         oc_mngm_15c = "C24060_002",      # Occupation by Class - 2) Management, business, science, and arts occupations
                         oc_srvc_15c = "C24060_003",      # Occupation by Class - 3) Service occupations
                         oc_sale_15c = "C24060_004",      # Occupation by Class - 4) Sales and office occupations
                         oc_cnst_15c = "C24060_005",      # Occupation by Class - 5) Natural resources, construction, and maintenance occupations
                         oc_trsp_15c = "C24060_006",      # Occupation by Class - 6) Production, transportation, and material moving occupations
                         oc_prvt_15c = "C24060_007",      # Occupation by Class - 7) Employee of private company workers
                         oc_self_15c = "C24060_013",      # Occupation by Class - 13) Self-employed in own incorporated business workers
                         oc_nprf_15c = "C24060_019",      # Occupation by Class - 19) Private not-for-profit wage and salary workers:
                         oc_govm_15c = "C24060_025",      # Occupation by Class - 25) Local, state, and federal government workers
                         oc_self_15c = "C24060_031"       # Occupation by Class - 31) Self-employed in own not incorporated business workers and unpaid family workers
                       ))
view(dat.acs5.19)
view(dat.acs5.15)


## Need to develop more on selecting variables
# 3. Change to the long dataframe to wide dataframe
dat.acs5.19_total <-
dat.acs5.19[, c(1, 3, 4, 6)] %>%
  spread(variable, estimate) %>%  
  mutate(
    ed_lged_19c = ed_totl_19c - (ed_assc_19c + ed_bach_19c + ed_gedd_19c        # Number of Education: Less than GED
                                 + ed_hisc_19c + ed_mast_19c + ed_phdd_19c
                                 + ed_prof_19c + ed_col1_19c + ed_col2_19c),  
    ed_hige_19c = ed_gedd_19c + ed_hisc_19c,                                    # Number of Education: High school and GED
    ed_scol_19c = ed_assc_19c + ed_col1_19c + ed_col2_19c,                      # Number of Education: Some college level
    ed_advn_19c = ed_mast_19c + ed_phdd_19c + ed_prof_19c,                      # Number of Education: Advanced degree
    rc_othr_19c = rc_totl_19c - (rc_whit_19c + rc_afam_19c                      # Number of Race: Other races
                                 + rc_hisp_19c + rc_asan_19c),
    ed_lged_19p = (ed_lged_19c / ed_totl_19c) * 100,                            # % of Education: Less than GED
    ed_hige_19p = (ed_hige_19c / ed_totl_19c) * 100,                            # % of Education: High school and GED
    ed_scol_19p = (ed_scol_19c / ed_totl_19c) * 100,                            # % of Education: Some college level
    ed_bach_19p = (ed_bach_19c / ed_totl_19c) * 100,                            # % of Education: Bachelor's Degree
    ed_advn_19p = (ed_advn_19c / ed_totl_19c) * 100,                            # % of Education: Advanced Degree
    em_cnot_19p = (em_cnot_19c / em_cttl_19c) * 100,                            # % of Employment: Un-employed
    em_lnot_19p = (em_lnot_19c / em_lttl_19c) * 100,                            # % of Employment: Not in civil-labor
    hs_vcnt_19p = (hs_vcnt_19c / hs_totl_19c) * 100,                            # % of Vacant housing
    pv_belw_19p = (pv_belw_19c / pv_totl_19c) * 100,                            # % of below Poverty
    rc_whit_19p = (rc_whit_19c / rc_totl_19c) * 100,                            # % of Race: White
    rc_afam_19p = (rc_afam_19c / rc_totl_19c) * 100,                            # % of Race: African-american
    rc_hisp_19p = (rc_hisp_19c / rc_totl_19c) * 100,                            # % of Race: Hispanic
    rc_asan_19p = (rc_asan_19c / rc_totl_19c) * 100,                            # % of Race: Asian
    rc_othr_19p = (rc_othr_19c / rc_totl_19c) * 100,                            # % of Race: Others
    hs_10yy_19p = ((hs_14yy_19c + hs_1013_19c) / hs_yttl_19c ) * 100,           # % of house built 2010-
    hs_0009_19p = (hs_0009_15c / hs_yttl_19c ) * 100,                           # % of house built 2000-2009
    hs_9099_19p = (hs_9099_15c / hs_yttl_19c ) * 100,                           # % of house built 1990-1999
    hs_7089_19p = ((hs_7079_15c + hs_8089_15c) / hs_yttl_19c ) * 100,           # % of house built 1970-1989
    hs_5069_19p = ((hs_5059_15c + hs_6069_15c) / hs_yttl_19c ) * 100,           # % of house built 1950-1969
    hs_yy49_19p = ((hs_yy39_15c + hs_4049_15c) / hs_yttl_19c ) * 100,           # % of house built -1949
    vc_hh00_19p = (vc_hh00_15c / vc_httl_15c) * 100,                            # % of household having 0 vehicle
    vc_hh01_19p = (vc_hh01_15c / vc_httl_15c) * 100,                            # % of household having 1 vehicle
    vc_hh02_19p = (vc_hh02_15c / vc_httl_15c) * 100,                            # % of household having 2 vehicles
    vc_hh03_19p = ((vc_hh03_15c + vc_hh04_15c) / vc_httl_15c) * 100,            # % of household having over 3 vehicles
    tp_drv1_19p = (tp_drv1_19c / tp_totl_19c) * 100,                            # % of driving alone to work
    tp_crpl_19p = (tp_crpl_19c / tp_totl_19c) * 100,                            # % of carpool to work
    tp_pbtp_19p = ((tp_pbtp_19c + tp_taxi_19c) / tp_totl_19c) * 100,            # % of public transportation to work
    tp_walk_19p = (tp_walk_19c / tp_totl_19c) * 100,                            # % of walk to work
    tp_bicy_19p = (tp_bicy_19c / tp_totl_19c) * 100,                            # % of bicycle to work
    tp_othr_19p = ((tp_mtcy_19c + tp_othr_19c) / tp_totl_19c) * 100,            # % of other modes to work
    tp_home_19p = (tp_home_19c / tp_totl_19c) * 100,                            # % of work from home
    oc_mngm_19p = (oc_mngm_19c / oc_totl_19c) * 100,                            # % of Management, business, science, and arts occupations
    oc_srvc_19p = (oc_srvc_19c / oc_totl_19c) * 100,                            # % of Service occupations
    oc_sale_19p = (oc_sale_19c / oc_totl_19c) * 100,                            # % of Sales and office occupations
    oc_cnst_19p = (oc_cnst_19c / oc_totl_19c) * 100,                            # % of Natural resources, construction, and maintenance occupations
    oc_trsp_19p = (oc_trsp_19c / oc_totl_19c) * 100,                            # % of Production, transportation, and material moving occupations
    oc_prvt_19p = (oc_prvt_19c / oc_totl_19c) * 100,                            # % of Employee of private company workers
    oc_self_19p = (oc_self_19c / oc_totl_19c) * 100,                            # % of Self-employed in own incorporated business workers
    oc_nprf_19p = (oc_nprf_19c / oc_totl_19c) * 100,                            # % of not-for-profit wage and salary workers
    oc_govm_19p = (oc_govm_19c / oc_totl_19c) * 100,                            # % of Local, state, and federal government workers
    oc_self_19p = (oc_self_19c / oc_totl_19c) * 100                             # % of Self-employed in own not incorporated business workers and unpaid family workers
  ) %>%
  mutate(across(where(is.numeric), round, 1)) %>%
  select(          ########################################### Start from here ###################################
    GEOID,         # Select only columns for using analysis
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
    ed_lged_15c = ed_totl_15c - (ed_assc_15c + ed_bach_15c + ed_gedd_15c        # Number of Education: Less than GED
                                 + ed_hisc_15c + ed_mast_15c + ed_phdd_15c      
                                 + ed_prof_15c + ed_col1_15c + ed_col2_15c),    
    ed_hige_15c = ed_gedd_15c + ed_hisc_15c,                                    # Number of Education: High school and GED
    ed_scol_15c = ed_assc_15c + ed_col1_15c + ed_col2_15c,                      # Number of Education: Some college level
    ed_advn_15c = ed_mast_15c + ed_phdd_15c + ed_prof_15c,                      # Number of Education: Advanced degree
    rc_othr_15c = rc_totl_15c - (rc_whit_15c + rc_afam_15c                      # Number of Race: Other races
                                 + rc_hisp_15c + rc_asan_15c),
    ed_lged_15p = (ed_lged_15c / ed_totl_15c) * 100,                            # % of Education: Less than GED
    ed_hige_15p = (ed_hige_15c / ed_totl_15c) * 100,                            # % of Education: High school and GED
    ed_scol_15p = (ed_scol_15c / ed_totl_15c) * 100,                            # % of Education: Some college level
    ed_bach_15p = (ed_bach_15c / ed_totl_15c) * 100,                            # % of Education: Bachelor's Degree
    ed_advn_15p = (ed_advn_15c / ed_totl_15c) * 100,                            # % of Education: Advanced Degree
    em_cnot_15p = (em_cnot_15c / em_cttl_15c) * 100,                            # % of Employment: Un-employed
    em_lnot_15p = (em_lnot_15c / em_lttl_15c) * 100,                            # % of Employment: Not in civil-labor
    hs_vcnt_15p = (hs_vcnt_15c / hs_totl_15c) * 100,                            # % of Vacant housing
    pv_belw_15p = (pv_belw_15c / pv_totl_15c) * 100,                            # % of below Poverty
    rc_whit_15p = (rc_whit_15c / rc_totl_15c) * 100,                            # % of Race: White
    rc_afam_15p = (rc_afam_15c / rc_totl_15c) * 100,                            # % of Race: African-american
    rc_hisp_15p = (rc_hisp_15c / rc_totl_15c) * 100,                            # % of Race: Hispanic
    rc_asan_15p = (rc_asan_15c / rc_totl_15c) * 100,                            # % of Race: Asian
    rc_othr_15p = (rc_othr_15c / rc_totl_15c) * 100                             # % of Race: Others
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


