# Orlando Crime Data
# Get ACS data



# 0. Install packages & Update the most recent packages
# install.packages(c("tidyverse", "tidycensus", "viridis", "tigris",
#                   "censusapi", "sp", "sf", "ggplot2", "ggthemes",
#                    "totalcensus", "mapview", "cowplot", "googleway", 
#                   "ggrepel", "ggspatial", "libwgeom", "rnaturalearth", 
#                   "rnaturalearthdata", "devtools", "purrr", "gridExtra",
#                   "terra" ))
# update.packages()



# 1. Library
suppressPackageStartupMessages({
  library(dplyr, warn.conflicts = FALSE)  
  library(sf)
  library(tidyr)
  library(devtools)
  library(ggplot2)
  library(stringi)
  library(tidyverse)
  library(tidycensus)
  library(leaflet)
  library(purrr)
  library(geosphere)
  library(rmapshaper)
  library(htmltools)
  library(scales)
  library(RColorBrewer)
  library(psych)
  library(reshape)
  library(rlang)
  library(purrr)
  library(timetk)
  library(kableExtra)
  library(highcharter)
  library(viridis)
  library(tigris)
  library(ggthemes)
  library(gridExtra)
  library(terra)
})
# rm(list = ls())


# 2. Access and request ACS data
# Request the census api key
census_api_key("42e1b9b3b73ee4990e7c15500d52250286ba72cc", overwrite = FALSE, install = FALSE)
readRenviron("~/.Renviron") # restarts R session in order to use tidycensus api key

# Check the whole variables in each year
var.acs5.19 <- load_variables(2019, "acs5", cache = TRUE)
var.acs5.17 <- load_variables(2017, "acs5", cache = TRUE)
var.acs5.16 <- load_variables(2016, "acs5", cache = TRUE)
var.acs5.15 <- load_variables(2015, "acs5", cache = TRUE)

view(var.acs5.19)
view(var.acs5.17)
view(var.acs5.16)
view(var.acs5.15)

# Get the census blcok group data in Orange County, FL
# Only acs-5 survey offers census tract and census block group level (acs-1 does not offer cnesus tracts and census block groups level)
dat.acs5.19 <-
get_acs(geography = "block group", county = "Orange", state = "FL",
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
          hs_cstt_19d = "B25088_001",      # House - Median selected monthly owner costs - Total
          hs_cstm_19d = "B25088_002",      # House - Median selected monthly owner costs - With a mortgage
          hs_cstx_19d = "B25088_003",      # House - Median selected monthly owner costs - Without a mortgage
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
# NA      pv_totl_19c = "B17020_001",      # Poverty - Total population
# NA      pv_belw_19c = "B17020_002",      # Poverty - Below poverty status in the past 12 months
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
# NA      vc_httl_19c = "B08201_001",      # Vehicle - Total, Available Vehicles by household
# NA      vc_hh00_19c = "B08201_002",      # Vehicle - No vehicle available
# NA      vc_hh01_19c = "B08201_003",      # Vehicle - 1 vehicle available
# NA      vc_hh02_19c = "B08201_004",      # Vehicle - 2 vehicle available
# NA      vc_hh03_19c = "B08201_005",      # Vehicle - 3 vehicle available
# NA      vc_hh04_19c = "B08201_006",      # Vehicle - 4 or more vehicle 
          tp_totl_19c = "B08301_001",      # MEANS OF TRANSPORTATION TO WORK - Total
          tp_vhcl_19c = "B08301_002",      # MEANS OF TRANSPORTATION TO WORK - 1) Car, truck, or van
          tp_drv1_19c = "B08301_003",      # MEANS OF TRANSPORTATION TO WORK - 1-1) Drive alone 
          tp_crpl_19c = "B08301_004",      # MEANS OF TRANSPORTATION TO WORK - 1-2) Carpool
          tp_publ_19c = "B08301_010",      # MEANS OF TRANSPORTATION TO WORK - 2) Public Transportation
          tp_taxi_19c = "B08301_016",      # MEANS OF TRNAPSORTATION TO WORK - 3) Taxicab
          tp_mtcy_19c = "B08301_017",      # MEANS OF TRNAPSORTATION TO WORK - 4) Motorcycle
          tp_bicy_19c = "B08301_018",      # MEANS OF TRNAPSORTATION TO WORK - 5) Bicycle
          tp_walk_19c = "B08301_019",      # MEANS OF TRNAPSORTATION TO WORK - 6) Walk
          tp_othr_19c = "B08301_020",      # MEANS OF TRNAPSORTATION TO WORK - 7) Other means
          tp_home_19c = "B08301_021",      # MEANS OF TRNASPORTATION TO WORK - 8) Work from home
# NA      oc_totl_19c = "C24060_001",      # Occupation - 1) Total
# NA      oc_mngm_19c = "C24060_002",      # Occupation - 2) Management, business, science, and arts occupations
# NA      oc_srvc_19c = "C24060_003",      # Occupation - 3) Service occupations
# NA      oc_sale_19c = "C24060_004",      # Occupation - 4) Sales and office occupations
# NA      oc_cnst_19c = "C24060_005",      # Occupation - 5) Natural resources, construction, and maintenance occupations
# NA      oc_trns_19c = "C24060_006",      # Occupation - 6) Production, transportation, and material moving occupations
# NA      oc_prvt_19c = "C24060_007",      # Occupation - 7) Employee of private company workers
# NA      oc_slfi_19c = "C24060_013",      # Occupation - 13) Self-employed in own incorporated business workers
# NA      oc_nprf_19c = "C24060_019",      # Occupation - 19) Private not-for-profit wage and salary workers:
# NA      oc_govm_19c = "C24060_025",      # Occupation - 25) Local, state, and federal government workers
# NA      oc_slfn_19c = "C24060_031",      # Occupation - 31) Self-employed in own not incorporated business workers and unpaid family workers
          cp_totl_19c = "B28001_001",      # Computing - 1) Total
          cp_01dv_19c = "B28001_002",      # Computing - 2) One or more types of devices
          cp_smtp_19c = "B28001_005",      # Computing - 5) One or more types of devices - Smartphone
          cp_00dv_19c = "B28001_011",      # Computing - 11) No devices
          in_totl_19c = "B28002_001",      # Internet - 1) Total
          in_ysub_19c = "B28002_002",      # Internet - 2) With an subscription
          in_broa_19c = "B28002_007",      # Internet - 7) With an subscription - Broadband
          in_nsub_19c = "B28002_012",      # Internet - 12) Access without an subscription
          in_nacc_19c = "B28002_013"       # Internet - 13) No Access 
                 )) %>%
  select(GEOID, variable, estimate, geometry) %>%
  spread(variable, estimate) %>%
  mutate(
          rc_othr_19c = rc_totl_19c - (rc_whit_19c + rc_afam_19c + rc_hisp_19c + rc_asan_19c),   # Race - Others
          rc_whit_19p = (rc_whit_19c / rc_totl_19c) * 100,                                       # Race - % of White population
          rc_afam_19p = (rc_afam_19c / rc_totl_19c) * 100,                                       # Race - % of African-american population
          rc_hisp_19p = (rc_hisp_19c / rc_totl_19c) * 100,                                       # Race - % of Hispanic population
          rc_asan_19p = (rc_asan_19c / rc_totl_19c) * 100,                                       # Race - % of Asian population
          rc_othr_19p = (rc_othr_19c / rc_totl_19c) * 100,                                       # Race - % of Others population
          hs_vcnt_19p = (hs_vcnt_19c / hs_totl_19c) * 100,                               # House - % of vacant house
          hs_10yy_19p = ((hs_14yy_19c + hs_1013_19c) / hs_yttl_19c) * 100 ,              # House - % of built 2010 or later
          hs_0009_19p = (hs_0009_19c / hs_yttl_19c) * 100,                               # House - % of built 2000 to 2009
          hs_8099_19p = ((hs_9099_19c + hs_8089_19c) / hs_yttl_19c) * 100,               # House - % of built 1980 to 1999
          hs_6079_19p = ((hs_7079_19c + hs_6069_19c) / hs_yttl_19c) * 100,               # House - % of built 1960 to 1979
          hs_yy59_19p = ((hs_5059_19c + hs_4049_19c + hs_yy39_19c) / hs_yttl_19c) * 100, # House - % of built 1959 or earlier
          em_cnot_19p = (em_cnot_19c / em_cttl_19c) * 100,                               # Employment - % of Unemployed civilian labor
          em_lnot_19p = (em_lnot_19c / em_lttl_19c) * 100,                               # Employment - % of Not in labor
# NA      pv_belw_19p = (pv_belw_19c / pv_totl_19c) * 100,                               # Poverty - % of below poverty status
          ed_lged_19c = ed_totl_19c - (ed_hisc_19c + ed_gedd_19c + ed_col1_19c
                                       + ed_col2_19c + ed_assc_19c + ed_bach_19c
                                       + ed_mast_19c + ed_prof_19c + ed_phdd_19c),       # Education - # of less than GED
          ed_lged_19p = (ed_lged_19c / ed_totl_19c) * 100,                               # Education - % of less than GED
          ed_hged_19p = ((ed_hisc_19c + ed_gedd_19c) / ed_totl_19c) * 100,               # Education - % of high school diploma and GED
          ed_scol_19p = ((ed_col1_19c + ed_col2_19c + ed_assc_19c) / ed_totl_19c) * 100, # Education - % of some collegel level degree
          ed_bach_19p = (ed_bach_19c / ed_totl_19c) * 100,                               # Education - % of bachelor's degree
          ed_advn_19p = ((ed_mast_19c + ed_prof_19c + ed_phdd_19c) / ed_totl_19c) * 100, # Education - % of advanced degree
# NA      vc_hh00_19p = (vc_hh00_19c / vc_httl_19c) * 100,                 # Vehicle - % of no vehicle available
# NA      vc_hh01_19p = (vc_hh01_19c / vc_httl_19c) * 100,                 # Vehicle - % of 1 vehicle available
# NA      vc_hh02_19p = (vc_hh02_19c / vc_httl_19c) * 100,                 # Vehicle - % of 2 vehicle available
# NA      vc_03hh_19p = ((vc_hh03_19c + vc_hh04_19c) / vc_httl_19c) * 100, # Vehicle - % of 3 or more vehicle available
          tp_drv1_19p = (tp_drv1_19c / tp_totl_19c) * 100,                 # Transportation - % of drive alone
          tp_crpl_19p = (tp_crpl_19c / tp_totl_19c) * 100,                 # Transportation - % of carpool
          tp_publ_19p = ((tp_publ_19c + tp_taxi_19c) / tp_totl_19c) * 100, # Transportation - % of public transportation
          tp_bicy_19p = (tp_bicy_19c / tp_totl_19c) * 100,                 # Transportation - % of bicycle
          tp_walk_19p = (tp_walk_19c / tp_totl_19c) * 100,                 # Transportation - % of walk
          tp_othr_19p = ((tp_mtcy_19c + tp_othr_19c) / tp_totl_19c) * 100, # Transportation - % of other mode
          tp_home_19p = (tp_home_19c / tp_totl_19c) * 100,                 # Transportation - % of work at home
# NA      oc_mngm_19p = (oc_mngm_19c / oc_totl_19c) * 100,                 # Occupation - % of management, business, science, and arts
# NA      oc_srvc_19p = (oc_srvc_19c / oc_totl_19c) * 100,                 # Occupation - % of service
# NA      oc_sale_19p = (oc_sale_19c / oc_totl_19c) * 100,                 # Occupation - % of sales and office
# NA      oc_cnst_19p = (oc_cnst_19c / oc_totl_19c) * 100,                 # Occupation - % of natural resources, construction, and maintenance
# NA      oc_trns_19p = (oc_trns_19c / oc_totl_19c) * 100,                 # Occupation - % of production, transportation, and material moving
# NA      oc_prvt_19p = (oc_prvt_19c / oc_totl_19c) * 100,                 # Occupation - % of private company 
# NA      oc_slfi_19p = (oc_slfi_19c / oc_totl_19c) * 100,                 # Occupation - % of self-employed in own incorporated business
# NA      oc_nprf_19p = (oc_nprf_19c / oc_totl_19c) * 100,                 # Occupation - % of private non-for-profit wage and salary
# NA      oc_govm_19p = (oc_govm_19c / oc_totl_19c) * 100,                 # Occupation - % of local, state, and federal government
# NA      oc_slfn_19p = (oc_slfn_19c / oc_totl_19c) * 100,                 # Occupation - % of self-employed in own not incorporated business
          cp_01dv_19p = (cp_01dv_19c / cp_totl_19c) * 100,                 # Computing - % of one or more types of devices
          cp_smtp_19p = (cp_smtp_19c / cp_totl_19c) * 100,                 # Computing - % of one or more types of devices - Smartphoene accessibility
          cp_00dv_19p = (cp_00dv_19c / cp_totl_19c) * 100,                 # Computing - % of no devices 
          in_yacc_19p = ((in_ysub_19c + in_nsub_19c) / in_totl_19c) * 100, # Internet - % of Access
          in_broa_19p = (in_broa_19c / in_totl_19c) * 100,                 # Internet - % of Access with an subscription - Broadband
          in_nacc_19p = (in_nacc_19c / in_totl_19c) * 100                  # Internet - % of No Access
  ) %>%
  mutate(across(where(is.numeric), round, 1)) %>%
  select(GEOID,                                                                                                                 # GEOID
         pp_totl_19c, rc_whit_19p, rc_afam_19p, rc_hisp_19p, rc_asan_19p, rc_othr_19p,                                          # Population & Race
         hs_vcnt_19p, hs_mrnt_19d, hs_cstt_19d, hs_10yy_19p, hs_0009_19p, hs_8099_19p, hs_6079_19p, hs_yy59_19p, hs_mdyr_19y,   # Housing
         fn_minc_19d, fn_prnt_19p, em_cnot_19p, em_lnot_19p,                                                                    # Finance and Employment
         ed_lged_19p, ed_hged_19p, ed_scol_19p, ed_bach_19p, ed_advn_19p,                                                       # Education
         tp_drv1_19p, tp_crpl_19p, tp_publ_19p, tp_bicy_19p, tp_walk_19p, tp_othr_19p, tp_home_19p,                             # Transportation
         cp_01dv_19p, cp_smtp_19p, cp_00dv_19p, in_yacc_19p, in_broa_19p, in_nacc_19p,                                          # Computing and Internet
         geometry                                                                                                               # geometry
         )

# Not yet
dat.acs5.17
  get_acs(geography = "block group", county = "Orange", state = "FL",
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
            hs_cstt_15d = "B25088_001",      # House - Median selected monthly owner costs - Total
            hs_cstm_15d = "B25088_002",      # House - Median selected monthly owner costs - With a mortgage
            hs_cstx_15d = "B25088_003",      # House - Median selected monthly owner costs - Without a mortgage
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
            # NA      pv_totl_19c = "B17020_001",      # Poverty - Total population
            # NA      pv_belw_19c = "B17020_002",      # Poverty - Below poverty status in the past 12 months
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
            # NA      vc_httl_19c = "B08201_001",      # Vehicle - Total, Available Vehicles by household
            # NA      vc_hh00_19c = "B08201_002",      # Vehicle - No vehicle available
            # NA      vc_hh01_19c = "B08201_003",      # Vehicle - 1 vehicle available
            # NA      vc_hh02_19c = "B08201_004",      # Vehicle - 2 vehicle available
            # NA      vc_hh03_19c = "B08201_005",      # Vehicle - 3 vehicle available
            # NA      vc_hh04_19c = "B08201_006",      # Vehicle - 4 or more vehicle 
            tp_totl_15c = "B08301_001",      # MEANS OF TRANSPORTATION TO WORK - Total
            tp_vhcl_15c = "B08301_002",      # MEANS OF TRANSPORTATION TO WORK - 1) Car, truck, or van
            tp_drv1_15c = "B08301_003",      # MEANS OF TRANSPORTATION TO WORK - 1-1) Drive alone 
            tp_crpl_15c = "B08301_004",      # MEANS OF TRANSPORTATION TO WORK - 1-2) Carpool
            tp_publ_15c = "B08301_010",      # MEANS OF TRANSPORTATION TO WORK - 2) Public Transportation
            tp_taxi_15c = "B08301_016",      # MEANS OF TRNAPSORTATION TO WORK - 3) Taxicab
            tp_mtcy_15c = "B08301_017",      # MEANS OF TRNAPSORTATION TO WORK - 4) Motorcycle
            tp_bicy_15c = "B08301_018",      # MEANS OF TRNAPSORTATION TO WORK - 5) Bicycle
            tp_walk_15c = "B08301_019",      # MEANS OF TRNAPSORTATION TO WORK - 6) Walk
            tp_othr_15c = "B08301_020",      # MEANS OF TRNAPSORTATION TO WORK - 7) Other means
            tp_home_15c = "B08301_021",      # MEANS OF TRNASPORTATION TO WORK - 8) Work from home
            # NA      oc_totl_19c = "C24060_001",      # Occupation - 1) Total
            # NA      oc_mngm_19c = "C24060_002",      # Occupation - 2) Management, business, science, and arts occupations
            # NA      oc_srvc_19c = "C24060_003",      # Occupation - 3) Service occupations
            # NA      oc_sale_19c = "C24060_004",      # Occupation - 4) Sales and office occupations
            # NA      oc_cnst_19c = "C24060_005",      # Occupation - 5) Natural resources, construction, and maintenance occupations
            # NA      oc_trns_19c = "C24060_006",      # Occupation - 6) Production, transportation, and material moving occupations
            # NA      oc_prvt_19c = "C24060_007",      # Occupation - 7) Employee of private company workers
            # NA      oc_slfi_19c = "C24060_013",      # Occupation - 13) Self-employed in own incorporated business workers
            # NA      oc_nprf_19c = "C24060_019",      # Occupation - 19) Private not-for-profit wage and salary workers:
            # NA      oc_govm_19c = "C24060_025",      # Occupation - 25) Local, state, and federal government workers
            # NA      oc_slfn_19c = "C24060_031",      # Occupation - 31) Self-employed in own not incorporated business workers and unpaid family workers
            cp_totl_15c = "B28001_001",      # Computing - 1) Total
            cp_01dv_15c = "B28001_002",      # Computing - 2) One or more types of devices
            cp_smtp_15c = "B28001_005",      # Computing - 5) One or more types of devices - Smartphone
            cp_00dv_15c = "B28001_011",      # Computing - 11) No devices
            in_totl_15c = "B28002_001",      # Internet - 1) Total
            in_ysub_15c = "B28002_002",      # Internet - 2) With an subscription
            in_broa_15c = "B28002_007",      # Internet - 7) With an subscription - Broadband
            in_nsub_15c = "B28002_012",      # Internet - 12) Access without an subscription
            in_nacc_15c = "B28002_013"       # Internet - 13) No Access 
          )) %>%
  select(GEOID, variable, estimate, geometry) %>%
  spread(variable, estimate) %>%
  mutate(
    rc_othr_15c = rc_totl_15c - (rc_whit_15c + rc_afam_15c + rc_hisp_15c + rc_asan_15c),   # Race - Others
    rc_whit_15p = (rc_whit_15c / rc_totl_15c) * 100,                                       # Race - % of White population
    rc_afam_15p = (rc_afam_15c / rc_totl_15c) * 100,                                       # Race - % of African-american population
    rc_hisp_15p = (rc_hisp_15c / rc_totl_15c) * 100,                                       # Race - % of Hispanic population
    rc_asan_15p = (rc_asan_15c / rc_totl_15c) * 100,                                       # Race - % of Asian population
    rc_othr_15p = (rc_othr_15c / rc_totl_15c) * 100,                                       # Race - % of Others population
    hs_vcnt_15p = (hs_vcnt_15c / hs_totl_15c) * 100,                               # House - % of vacant house
    hs_10yy_15p = ((hs_14yy_15c + hs_1013_15c) / hs_yttl_15c) * 100 ,              # House - % of built 2010 or later
    hs_0009_15p = (hs_0009_15c / hs_yttl_15c) * 100,                               # House - % of built 2000 to 2009
    hs_8099_15p = ((hs_9099_15c + hs_8089_15c) / hs_yttl_15c) * 100,               # House - % of built 1980 to 1999
    hs_6079_15p = ((hs_7079_15c + hs_6069_15c) / hs_yttl_15c) * 100,               # House - % of built 1960 to 1979
    hs_yy59_15p = ((hs_5059_15c + hs_4049_15c + hs_yy39_15c) / hs_yttl_15c) * 100, # House - % of built 1959 or earlier
    em_cnot_15p = (em_cnot_15c / em_cttl_15c) * 100,                               # Employment - % of Unemployed civilian labor
    em_lnot_15p = (em_lnot_15c / em_lttl_15c) * 100,                               # Employment - % of Not in labor
    # NA      pv_belw_19p = (pv_belw_19c / pv_totl_19c) * 100,                               # Poverty - % of below poverty status
    ed_lged_15c = ed_totl_15c - (ed_hisc_15c + ed_gedd_15c + ed_col1_15c
                                 + ed_col2_15c + ed_assc_15c + ed_bach_15c
                                 + ed_mast_15c + ed_prof_15c + ed_phdd_15c),       # Education - # of less than GED
    ed_lged_15p = (ed_lged_15c / ed_totl_15c) * 100,                               # Education - % of less than GED
    ed_hged_15p = ((ed_hisc_15c + ed_gedd_15c) / ed_totl_15c) * 100,               # Education - % of high school diploma and GED
    ed_scol_15p = ((ed_col1_15c + ed_col2_15c + ed_assc_15c) / ed_totl_15c) * 100, # Education - % of some collegel level degree
    ed_bach_15p = (ed_bach_15c / ed_totl_15c) * 100,                               # Education - % of bachelor's degree
    ed_advn_15p = ((ed_mast_15c + ed_prof_15c + ed_phdd_15c) / ed_totl_15c) * 100, # Education - % of advanced degree
    # NA      vc_hh00_19p = (vc_hh00_19c / vc_httl_19c) * 100,                 # Vehicle - % of no vehicle available
    # NA      vc_hh01_19p = (vc_hh01_19c / vc_httl_19c) * 100,                 # Vehicle - % of 1 vehicle available
    # NA      vc_hh02_19p = (vc_hh02_19c / vc_httl_19c) * 100,                 # Vehicle - % of 2 vehicle available
    # NA      vc_03hh_19p = ((vc_hh03_19c + vc_hh04_19c) / vc_httl_19c) * 100, # Vehicle - % of 3 or more vehicle available
    tp_drv1_15p = (tp_drv1_15c / tp_totl_15c) * 100,                 # Transportation - % of drive alone
    tp_crpl_15p = (tp_crpl_15c / tp_totl_15c) * 100,                 # Transportation - % of carpool
    tp_publ_15p = ((tp_publ_15c + tp_taxi_15c) / tp_totl_15c) * 100, # Transportation - % of public transportation
    tp_bicy_15p = (tp_bicy_15c / tp_totl_15c) * 100,                 # Transportation - % of bicycle
    tp_walk_15p = (tp_walk_15c / tp_totl_15c) * 100,                 # Transportation - % of walk
    tp_othr_15p = ((tp_mtcy_15c + tp_othr_15c) / tp_totl_15c) * 100, # Transportation - % of other mode
    tp_home_15p = (tp_home_15c / tp_totl_15c) * 100,                 # Transportation - % of work at home
    # NA      oc_mngm_19p = (oc_mngm_19c / oc_totl_19c) * 100,                 # Occupation - % of management, business, science, and arts
    # NA      oc_srvc_19p = (oc_srvc_19c / oc_totl_19c) * 100,                 # Occupation - % of service
    # NA      oc_sale_19p = (oc_sale_19c / oc_totl_19c) * 100,                 # Occupation - % of sales and office
    # NA      oc_cnst_19p = (oc_cnst_19c / oc_totl_19c) * 100,                 # Occupation - % of natural resources, construction, and maintenance
    # NA      oc_trns_19p = (oc_trns_19c / oc_totl_19c) * 100,                 # Occupation - % of production, transportation, and material moving
    # NA      oc_prvt_19p = (oc_prvt_19c / oc_totl_19c) * 100,                 # Occupation - % of private company 
    # NA      oc_slfi_19p = (oc_slfi_19c / oc_totl_19c) * 100,                 # Occupation - % of self-employed in own incorporated business
    # NA      oc_nprf_19p = (oc_nprf_19c / oc_totl_19c) * 100,                 # Occupation - % of private non-for-profit wage and salary
    # NA      oc_govm_19p = (oc_govm_19c / oc_totl_19c) * 100,                 # Occupation - % of local, state, and federal government
    # NA      oc_slfn_19p = (oc_slfn_19c / oc_totl_19c) * 100,                 # Occupation - % of self-employed in own not incorporated business
    cp_01dv_15p = (cp_01dv_15c / cp_totl_15c) * 100,                 # Computing - % of one or more types of devices
    cp_smtp_15p = (cp_smtp_15c / cp_totl_15c) * 100,                 # Computing - % of one or more types of devices - Smartphoene accessibility
    cp_00dv_15p = (cp_00dv_15c / cp_totl_15c) * 100,                 # Computing - % of no devices 
    in_yacc_15p = ((in_ysub_15c + in_nsub_15c) / in_totl_15c) * 100, # Internet - % of Access
    in_broa_15p = (in_broa_15c / in_totl_15c) * 100,                 # Internet - % of Access with an subscription - Broadband
    in_nacc_15p = (in_nacc_15c / in_totl_15c) * 100                  # Internet - % of No Access
  ) %>%
  mutate(across(where(is.numeric), round, 1)) %>%
  select(GEOID,                                                                                                                 # GEOID
         pp_totl_15c, rc_whit_15p, rc_afam_15p, rc_hisp_15p, rc_asan_15p, rc_othr_15p,                                          # Population & Race
         hs_vcnt_15p, hs_mrnt_15d, hs_cstt_15d, hs_10yy_15p, hs_0009_15p, hs_8099_15p, hs_6079_15p, hs_yy59_15p, hs_mdyr_15y,   # Housing
         fn_minc_15d, fn_prnt_15p, em_cnot_15p, em_lnot_15p,                                                                    # Finance and Employment
         ed_lged_15p, ed_hged_15p, ed_scol_15p, ed_bach_15p, ed_advn_15p,                                                       # Education
         tp_drv1_15p, tp_crpl_15p, tp_publ_15p, tp_bicy_15p, tp_walk_15p, tp_othr_15p, tp_home_15p,                             # Transportation
         cp_01dv_15p, cp_smtp_15p, cp_00dv_15p, in_yacc_15p, in_broa_15p, in_nacc_15p,                                          # Computing and Internet
         geometry                                                                                                               # geometry
  ) %>%
  head()
# B28001 data does not exist in 2015, The data exists from 2017 acs-5 survey.

view(dat.acs5.19)



# 4. Create sample plots
colnames(dat.acs5.19)

p1 <- dat.acs5.19 %>%
  ggplot() +
  geom_sf(aes(fill = hs_mrnt_19d)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Med Rent', $",
                       low = "white",
                       high = "red"
  )
p2 <- dat.acs5.19 %>%
  ggplot() +
  geom_sf(aes(fill = hs_cstt_19d)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Med Cost', $",
                       low = "white",
                       high = "green"
  )
p3 <- dat.acs5.19 %>%
  ggplot() +
  geom_sf(aes(fill = fn_minc_19d)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Med Income', $",
                       low = "white",
                       high = "orange"
  )
p4 <- dat.acs5.19 %>%
  ggplot() +
  geom_sf(aes(fill = hs_vcnt_19p)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Vacancy', %",
                       low = "navy",
                       high = "purple"
  )
grid.arrange(p1, p2, p3, p4, ncol=2)



# 5. Change the spatial reference & Export to a shapefile
# Check and change spatial reference
st_crs(dat.acs5.19) # 4269
dat.acs5.19 <- st_transform(dat.acs5.19, 4326)
st_crs(dat.acs5.19)

# Export to a shapefile
st_write(dat.acs5.19, "C:/Users/KIM36105/Downloads/Orlando_Crime_Analysis/ACS19_220131.shp")



