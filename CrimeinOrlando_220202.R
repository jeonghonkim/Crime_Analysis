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
  library(sp)
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
  library(rgdal)
})
# rm(list = ls())
 

# 2. Access and request ACS data
# Request the census api key
census_api_key("42e1b9b3b73ee4990e7c15500d52250286ba72cc", overwrite = FALSE, install = FALSE)
readRenviron("~/.Renviron") # restarts R session in order to use tidycensus api key

# Check the whole variables in each year
var.acs5.19 <- load_variables(2019, "acs5", cache = TRUE)
var.acs5.18 <- load_variables(2018, "acs5", cache = TRUE)
var.acs5.17 <- load_variables(2017, "acs5", cache = TRUE)
var.acs5.16 <- load_variables(2016, "acs5", cache = TRUE)
var.acs5.15 <- load_variables(2015, "acs5", cache = TRUE)

view(var.acs5.19)
view(var.acs5.18)
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
          hh_totl_19c = "B11001_001",      # Household - Total
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
  select(GEOID, variable, estimate, geometry
         ) %>%
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
         pp_totl_19c, hh_totl_19c, rc_whit_19p, rc_afam_19p, rc_hisp_19p, rc_asan_19p, rc_othr_19p,                             # Population & Race
         hs_vcnt_19p, hs_mrnt_19d, hs_cstt_19d, hs_10yy_19p, hs_0009_19p, hs_8099_19p, hs_6079_19p, hs_yy59_19p, hs_mdyr_19y,   # Housing
         fn_minc_19d, fn_prnt_19p, em_cnot_19p, em_lnot_19p,                                                                    # Finance and Employment
         ed_lged_19p, ed_hged_19p, ed_scol_19p, ed_bach_19p, ed_advn_19p,                                                       # Education
         tp_drv1_19p, tp_crpl_19p, tp_publ_19p, tp_bicy_19p, tp_walk_19p, tp_othr_19p, tp_home_19p,                             # Transportation
         cp_01dv_19p, cp_smtp_19p, cp_00dv_19p, in_yacc_19p, in_broa_19p, in_nacc_19p,                                          # Computing and Internet
         geometry                                                                                                               # geometry
         )

dat.acs5.17 <-
  get_acs(geography = "block group", county = "Orange", state = "FL",
          year = 2017, survey = "acs5", geometry = FALSE,
          variables = c(
            pp_totl_17c = "B02001_001",      # Population - Total
            hh_totl_17c = "B11001_001",      # Household - Total
            rc_totl_17c = "B03002_001",      # Race - Total
            rc_whit_17c = "B03002_003",      # Race - White population
            rc_afam_17c = "B03002_004",      # Race - African-american
            rc_hisp_17c = "B03002_012",      # Race - Hispanic
            rc_asan_17c = "B03002_006",      # Race - Asian
            hs_totl_17c = "B25002_001",      # House - Total
            hs_occp_17c = "B25002_002",      # House - Occupied
            hs_vcnt_17c = "B25002_003",      # House - Vacant
            hs_mrnt_17d = "B25064_001",      # House - Median gross rent
            hs_cstt_17d = "B25088_001",      # House - Median selected monthly owner costs - Total
            hs_cstm_17d = "B25088_002",      # House - Median selected monthly owner costs - With a mortgage
            hs_cstx_17d = "B25088_003",      # House - Median selected monthly owner costs - Without a mortgage
            hs_yttl_17c = "B25034_001",      # House - Year structure built - Total
            hs_14yy_17c = "B25034_002",      # House - Year structure built - Built 2014 or later
            hs_1013_17c = "B25034_003",      # House - Year structure built - Built 2010 to 2013
            hs_0009_17c = "B25034_004",      # House - Year structure built - Built 2000 to 2009
            hs_9099_17c = "B25034_005",      # House - Year structure built - Built 1990 to 1999
            hs_8089_17c = "B25034_006",      # House - Year structure built - Built 1980 to 1989
            hs_7079_17c = "B25034_007",      # House - Year structure built - Built 1970 to 1979
            hs_6069_17c = "B25034_008",      # House - Year structure built - Built 1960 to 1969
            hs_5059_17c = "B25034_009",      # House - Year structure built - Built 1950 to 1959
            hs_4049_17c = "B25034_010",      # House - Year structure built - Built 1940 to 1949
            hs_yy39_17c = "B25034_011",      # House - Year structure built - Built 1939 or earlier
            hs_mdyr_17y = "B25035_001",      # House - Median Year structure built
            fn_minc_17d = "B19013_001",      # Finance - Median household income in the past 12 months
            fn_prnt_17p = "B25071_001",      # Finance - Median gross rent as a percentage of household income
            em_cttl_17c = "B23025_003",      # Employment - Total civilian labor force
            em_cemp_17c = "B23025_004",      # Employment - Employed civilian labor force
            em_cnot_17c = "B23025_005",      # Employment - Unemployed civilian labor force
            em_lttl_17c = "B23025_001",      # Employment - Total labor force
            em_lnot_17c = "B23025_007",      # Employment - Not in labor force
# NA        pv_totl_19c = "B17020_001",      # Poverty - Total population
# NA        pv_belw_19c = "B17020_002",      # Poverty - Below poverty status in the past 12 months
            ed_totl_17c = "B15003_001",      # Education - Total
            ed_hisc_17c = "B15003_017",      # Education - High School Diploma
            ed_gedd_17c = "B15003_018",      # Education - GED
            ed_col1_17c = "B15003_019",      # Education - Some college, less than 1 year
            ed_col2_17c = "B15003_020",      # Education - Some college, 1 or more years, no degree
            ed_assc_17c = "B15003_021",      # Education - Associate's degree
            ed_bach_17c = "B15003_022",      # Education - Bachelor's degree
            ed_mast_17c = "B15003_023",      # Education - Master's degree
            ed_prof_17c = "B15003_024",      # Education - Professional school degree
            ed_phdd_17c = "B15003_025",      # Education - Doctorate degree
# NA        vc_httl_19c = "B08201_001",      # Vehicle - Total, Available Vehicles by household
# NA        vc_hh00_19c = "B08201_002",      # Vehicle - No vehicle available
# NA        vc_hh01_19c = "B08201_003",      # Vehicle - 1 vehicle available
# NA        vc_hh02_19c = "B08201_004",      # Vehicle - 2 vehicle available
# NA        vc_hh03_19c = "B08201_005",      # Vehicle - 3 vehicle available
# NA        vc_hh04_19c = "B08201_006",      # Vehicle - 4 or more vehicle 
            tp_totl_17c = "B08301_001",      # MEANS OF TRANSPORTATION TO WORK - Total
            tp_vhcl_17c = "B08301_002",      # MEANS OF TRANSPORTATION TO WORK - 1) Car, truck, or van
            tp_drv1_17c = "B08301_003",      # MEANS OF TRANSPORTATION TO WORK - 1-1) Drive alone 
            tp_crpl_17c = "B08301_004",      # MEANS OF TRANSPORTATION TO WORK - 1-2) Carpool
            tp_publ_17c = "B08301_010",      # MEANS OF TRANSPORTATION TO WORK - 2) Public Transportation
            tp_taxi_17c = "B08301_016",      # MEANS OF TRNAPSORTATION TO WORK - 3) Taxicab
            tp_mtcy_17c = "B08301_017",      # MEANS OF TRNAPSORTATION TO WORK - 4) Motorcycle
            tp_bicy_17c = "B08301_018",      # MEANS OF TRNAPSORTATION TO WORK - 5) Bicycle
            tp_walk_17c = "B08301_019",      # MEANS OF TRNAPSORTATION TO WORK - 6) Walk
            tp_othr_17c = "B08301_020",      # MEANS OF TRNAPSORTATION TO WORK - 7) Other means
            tp_home_17c = "B08301_021",      # MEANS OF TRNASPORTATION TO WORK - 8) Work from home
# NA        oc_totl_19c = "C24060_001",      # Occupation - 1) Total
# NA        oc_mngm_19c = "C24060_002",      # Occupation - 2) Management, business, science, and arts occupations
# NA        oc_srvc_19c = "C24060_003",      # Occupation - 3) Service occupations
# NA        oc_sale_19c = "C24060_004",      # Occupation - 4) Sales and office occupations
# NA        oc_cnst_19c = "C24060_005",      # Occupation - 5) Natural resources, construction, and maintenance occupations
# NA        oc_trns_19c = "C24060_006",      # Occupation - 6) Production, transportation, and material moving occupations
# NA        oc_prvt_19c = "C24060_007",      # Occupation - 7) Employee of private company workers
# NA        oc_slfi_19c = "C24060_013",      # Occupation - 13) Self-employed in own incorporated business workers
# NA        oc_nprf_19c = "C24060_019",      # Occupation - 19) Private not-for-profit wage and salary workers:
# NA        oc_govm_19c = "C24060_025",      # Occupation - 25) Local, state, and federal government workers
# NA        oc_slfn_19c = "C24060_031",      # Occupation - 31) Self-employed in own not incorporated business workers and unpaid family workers
            cp_totl_17c = "B28001_001",      # Computing - 1) Total
            cp_01dv_17c = "B28001_002",      # Computing - 2) One or more types of devices
            cp_smtp_17c = "B28001_005",      # Computing - 5) One or more types of devices - Smartphone
            cp_00dv_17c = "B28001_011",      # Computing - 11) No devices
            in_totl_17c = "B28002_001",      # Internet - 1) Total
            in_ysub_17c = "B28002_002",      # Internet - 2) With an subscription
            in_broa_17c = "B28002_007",      # Internet - 7) With an subscription - Broadband
            in_nsub_17c = "B28002_012",      # Internet - 12) Access without an subscription
            in_nacc_17c = "B28002_013"       # Internet - 13) No Access 
          )) %>%
  select(GEOID, variable, estimate
         # , geometry
         ) %>%
  spread(variable, estimate) %>%
  mutate(
          rc_othr_17c = rc_totl_17c - (rc_whit_17c + rc_afam_17c + rc_hisp_17c + rc_asan_17c),   # Race - Others
          rc_whit_17p = (rc_whit_17c / rc_totl_17c) * 100,                                       # Race - % of White population
          rc_afam_17p = (rc_afam_17c / rc_totl_17c) * 100,                                       # Race - % of African-american population
          rc_hisp_17p = (rc_hisp_17c / rc_totl_17c) * 100,                                       # Race - % of Hispanic population
          rc_asan_17p = (rc_asan_17c / rc_totl_17c) * 100,                                       # Race - % of Asian population
          rc_othr_17p = (rc_othr_17c / rc_totl_17c) * 100,                                       # Race - % of Others population
          hs_vcnt_17p = (hs_vcnt_17c / hs_totl_17c) * 100,                               # House - % of vacant house
          hs_10yy_17p = ((hs_14yy_17c + hs_1013_17c) / hs_yttl_17c) * 100 ,              # House - % of built 2010 or later
          hs_0009_17p = (hs_0009_17c / hs_yttl_17c) * 100,                               # House - % of built 2000 to 2009
          hs_8099_17p = ((hs_9099_17c + hs_8089_17c) / hs_yttl_17c) * 100,               # House - % of built 1980 to 1999
          hs_6079_17p = ((hs_7079_17c + hs_6069_17c) / hs_yttl_17c) * 100,               # House - % of built 1960 to 1979
          hs_yy59_17p = ((hs_5059_17c + hs_4049_17c + hs_yy39_17c) / hs_yttl_17c) * 100, # House - % of built 1959 or earlier
          em_cnot_17p = (em_cnot_17c / em_cttl_17c) * 100,                               # Employment - % of Unemployed civilian labor
          em_lnot_17p = (em_lnot_17c / em_lttl_17c) * 100,                               # Employment - % of Not in labor
# NA      pv_belw_19p = (pv_belw_19c / pv_totl_19c) * 100,                               # Poverty - % of below poverty status
          ed_lged_17c = ed_totl_17c - (ed_hisc_17c + ed_gedd_17c + ed_col1_17c
                                       + ed_col2_17c + ed_assc_17c + ed_bach_17c
                                       + ed_mast_17c + ed_prof_17c + ed_phdd_17c),       # Education - # of less than GED
          ed_lged_17p = (ed_lged_17c / ed_totl_17c) * 100,                               # Education - % of less than GED
          ed_hged_17p = ((ed_hisc_17c + ed_gedd_17c) / ed_totl_17c) * 100,               # Education - % of high school diploma and GED
          ed_scol_17p = ((ed_col1_17c + ed_col2_17c + ed_assc_17c) / ed_totl_17c) * 100, # Education - % of some college level degree
          ed_bach_17p = (ed_bach_17c / ed_totl_17c) * 100,                               # Education - % of bachelor's degree
          ed_advn_17p = ((ed_mast_17c + ed_prof_17c + ed_phdd_17c) / ed_totl_17c) * 100, # Education - % of advanced degree
# NA      vc_hh00_19p = (vc_hh00_19c / vc_httl_19c) * 100,                 # Vehicle - % of no vehicle available
# NA      vc_hh01_19p = (vc_hh01_19c / vc_httl_19c) * 100,                 # Vehicle - % of 1 vehicle available
# NA      vc_hh02_19p = (vc_hh02_19c / vc_httl_19c) * 100,                 # Vehicle - % of 2 vehicle available
# NA      vc_03hh_19p = ((vc_hh03_19c + vc_hh04_19c) / vc_httl_19c) * 100, # Vehicle - % of 3 or more vehicle available
          tp_drv1_17p = (tp_drv1_17c / tp_totl_17c) * 100,                 # Transportation - % of drive alone
          tp_crpl_17p = (tp_crpl_17c / tp_totl_17c) * 100,                 # Transportation - % of carpool
          tp_publ_17p = ((tp_publ_17c + tp_taxi_17c) / tp_totl_17c) * 100, # Transportation - % of public transportation
          tp_bicy_17p = (tp_bicy_17c / tp_totl_17c) * 100,                 # Transportation - % of bicycle
          tp_walk_17p = (tp_walk_17c / tp_totl_17c) * 100,                 # Transportation - % of walk
          tp_othr_17p = ((tp_mtcy_17c + tp_othr_17c) / tp_totl_17c) * 100, # Transportation - % of other mode
          tp_home_17p = (tp_home_17c / tp_totl_17c) * 100,                 # Transportation - % of work at home
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
          cp_01dv_17p = (cp_01dv_17c / cp_totl_17c) * 100,                 # Computing - % of one or more types of devices
          cp_smtp_17p = (cp_smtp_17c / cp_totl_17c) * 100,                 # Computing - % of one or more types of devices - Smartphoene accessibility
          cp_00dv_17p = (cp_00dv_17c / cp_totl_17c) * 100,                 # Computing - % of no devices 
          in_yacc_17p = ((in_ysub_17c + in_nsub_17c) / in_totl_17c) * 100, # Internet - % of Access
          in_broa_17p = (in_broa_17c / in_totl_17c) * 100,                 # Internet - % of Access with an subscription - Broadband
          in_nacc_17p = (in_nacc_17c / in_totl_17c) * 100                  # Internet - % of No Access
) %>%
    mutate(across(where(is.numeric), round, 1)) %>%
    select(GEOID,
           pp_totl_17c, hh_totl_17c, rc_whit_17p, rc_afam_17p, rc_hisp_17p, rc_asan_17p, rc_othr_17p,                             # Population & Race
           hs_vcnt_17p, hs_mrnt_17d, hs_cstt_17d, hs_10yy_17p, hs_0009_17p, hs_8099_17p, hs_6079_17p, hs_yy59_17p, hs_mdyr_17y,   # Housing
           fn_minc_17d, fn_prnt_17p, em_cnot_17p, em_lnot_17p,                                                                    # Finance and Employment
           ed_lged_17p, ed_hged_17p, ed_scol_17p, ed_bach_17p, ed_advn_17p,                                                       # Education
           tp_drv1_17p, tp_crpl_17p, tp_publ_17p, tp_bicy_17p, tp_walk_17p, tp_othr_17p, tp_home_17p,                             # Transportation
           cp_01dv_17p, cp_smtp_17p, cp_00dv_17p, in_yacc_17p, in_broa_17p, in_nacc_17p                                           # Computing and Internet
           #, geometry                                                                                                               # geometry
  )

view(dat.acs5.19)
view(dat.acs5.17)



# 4. Combine two dataframe and create new columns 
dat.acs5.1917 <- merge(dat.acs5.19, dat.acs5.17, by.X="GEOID", by.X= "GEOID")

# Create new columns including changes during the period
dat.acs5.1917 <-
dat.acs5.1917 %>%
  mutate(
    pp_totl_97p  = ((pp_totl_19c - pp_totl_17c) / pp_totl_17c) * 100,
    hh_totl_97p  = ((hh_totl_19c - hh_totl_17c) / hh_totl_17c) * 100,
    rc_whit_97pp = rc_whit_19p - rc_whit_17p,
    rc_afam_97pp = rc_afam_19p - rc_afam_17p,
    rc_hisp_97pp = rc_afam_19p - rc_afam_17p,
    rc_asan_97pp = rc_asan_19p - rc_asan_17p,
    rc_othr_97pp = rc_othr_19p - rc_othr_17p,
    hs_vcnt_97pp = hs_vcnt_19p - hs_vcnt_17p,
    hs_mrnt_97p  = ((hs_mrnt_19d - hs_mrnt_17d) / hs_mrnt_17d) * 100,
    hs_cstt_97p  = ((hs_cstt_19d - hs_cstt_17d) / hs_cstt_17d) * 100,
    hs_10yy_97pp = hs_10yy_19p - hs_10yy_17p,
    hs_0009_97pp = hs_0009_19p - hs_0009_17p,
    hs_8099_97pp = hs_8099_19p - hs_8099_17p, 
    hs_6079_97pp = hs_6079_19p - hs_6079_17p,
    hs_yy59_97pp = hs_yy59_19p - hs_yy59_17p,
    hs_mdyr_97y  = hs_mdyr_19y - hs_mdyr_17y,
    fn_minc_97p  = ((fn_minc_19d - fn_minc_17d) / fn_minc_17d) * 100,
    fn_prnt_97pp = fn_prnt_19p - fn_prnt_17p,
    em_cnot_97pp = em_cnot_19p - em_cnot_17p,
    em_lnot_97pp = em_lnot_19p - em_lnot_17p,
    ed_lged_97pp = ed_lged_19p - ed_lged_17p,
    ed_hged_97pp = ed_hged_19p - ed_hged_17p,
    ed_scol_97pp = ed_scol_19p - ed_scol_17p,
    ed_bach_97pp = ed_bach_19p - ed_bach_17p,
    ed_advn_97pp = ed_advn_19p - ed_advn_17p,
    tp_drv1_97pp = tp_drv1_19p - tp_drv1_17p,
    tp_crpl_97pp = tp_crpl_19p - tp_crpl_17p,
    tp_publ_97pp = tp_publ_19p - tp_publ_17p,
    tp_bicy_97pp = tp_bicy_19p - tp_bicy_17p,
    tp_walk_97pp = tp_walk_19p - tp_walk_17p,
    tp_othr_97pp = tp_othr_19p - tp_othr_17p,
    tp_home_97pp = tp_home_19p - tp_home_17p,
    cp_01dv_97pp = cp_01dv_19p - cp_01dv_17p,
    cp_smtp_97pp = cp_smtp_19p - cp_smtp_17p,
    cp_00dv_97pp = cp_00dv_19p - cp_00dv_17p,
    in_yacc_97pp = in_yacc_19p - in_yacc_17p,
    in_broa_97pp = in_broa_19p - in_broa_17p,
    in_nacc_97pp = in_nacc_19p - in_nacc_17p
  ) %>%
  select(
    GEOID,                                                                          # GEOID
    pp_totl_19c, pp_totl_17c, pp_totl_97p, hh_totl_19c, hh_totl_17c, hh_totl_97p,   # Population and Household
    rc_whit_19p, rc_afam_19p, rc_hisp_19p, rc_asan_19p, rc_othr_19p,                # Race 
    rc_whit_17p, rc_afam_17p, rc_hisp_17p, rc_asan_17p, rc_othr_17p,
    rc_whit_97pp, rc_afam_97pp, rc_hisp_97pp, rc_asan_97pp, rc_othr_97pp,
    hs_vcnt_19p, hs_vcnt_17p, hs_vcnt_97pp,                                         # Housing - Vacancy
    hs_mrnt_19d, hs_mrnt_17d, hs_mrnt_97p, hs_cstt_19d, hs_cstt_17d, hs_cstt_97p,   # Housing - Rent & Housing Costs
    hs_10yy_19p, hs_0009_19p, hs_8099_19p, hs_6079_19p, hs_yy59_19p, hs_mdyr_19y,   # Housing - Built Years
    hs_10yy_17p, hs_0009_17p, hs_8099_17p, hs_6079_17p, hs_yy59_17p, hs_mdyr_17y, 
    fn_minc_19d, fn_minc_17d, fn_minc_97p, fn_prnt_19p, fn_prnt_17p, fn_prnt_97pp,  # Housing - Income & Percentage of Rent
    em_cnot_19p, em_cnot_17p, em_cnot_97pp, em_lnot_19p, em_lnot_17p, em_lnot_97pp, # Labor - Unemployment, Not in Labor
    ed_lged_19p, ed_hged_19p, ed_scol_19p, ed_bach_19p, ed_advn_19p,                # Education - Attainment Level
    ed_lged_17p, ed_hged_17p, ed_scol_17p, ed_bach_17p, ed_advn_17p,
    ed_lged_97pp, ed_hged_97pp, ed_scol_97pp, ed_bach_97pp, ed_advn_97pp,
    tp_drv1_19p, tp_crpl_19p, tp_publ_19p, tp_bicy_19p, tp_walk_19p, tp_othr_19p, tp_home_19p, # Transportation to Work
    tp_drv1_17p, tp_crpl_17p, tp_publ_17p, tp_bicy_17p, tp_walk_17p, tp_othr_17p, tp_home_17p,
    tp_drv1_97pp, tp_crpl_97pp, tp_publ_97pp, tp_bicy_97pp, tp_walk_97pp, tp_othr_97pp, tp_home_97pp,
    cp_01dv_19p, cp_smtp_19p, cp_00dv_19p, in_yacc_19p, in_broa_19p, in_nacc_19p,   # Computer & Interent
    cp_01dv_17p, cp_smtp_17p, cp_00dv_17p, in_yacc_17p, in_broa_17p, in_nacc_17p,
    cp_01dv_97pp, cp_smtp_97pp, cp_00dv_97pp, in_yacc_97pp, in_broa_97pp, in_nacc_97pp,
    geometry
  ) %>%
  mutate(across(where(is.numeric), round, 1))
  
view(dat.acs5.1917)

  

# 5. Create sample plots
colnames(dat.acs5.1917)

p1 <- dat.acs5.1917 %>%
  ggplot() +
  geom_sf(aes(fill = fn_minc_97p)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Med Incm, %",
                       low = "red",
                       high = "green"
  )
p2 <- dat.acs5.1917 %>%
  ggplot() +
  geom_sf(aes(fill = hs_mrnt_97p)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Med Rent, %",
                       low = "red",
                       high = "green"
  )
p3 <- dat.acs5.1917 %>%
  ggplot() +
  geom_sf(aes(fill = hs_cstt_97p)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Hos Cost, %",
                       low = "red",
                       high = "green"
  )
p4 <- dat.acs5.1917 %>%
  ggplot() +
  geom_sf(aes(fill = fn_prnt_97pp)) +
  ggthemes::theme_map() +
  theme(legend.position = "right") +
  scale_fill_gradient2(name = "Pcn Rent, %p",
                       low = "red",
                       high = "green"
  )
grid.arrange(p1, p2, p3, p4, ncol=2)



# 5. Change the spatial reference & Export to a shapefile
# Check and change spatial reference
st_crs(dat.acs5.1917) # 4269

# Change it to 4326
dat.acs5.1917 <- st_transform(dat.acs5.1917, 4326)
st_crs(dat.acs5.1917) # 4326

# Export to a shapefile
st_write(dat.acs5.1917, "C:/Users/KIM36105/Downloads/Orlando_Crime_Analysis/ACS1917_220202.shp")

