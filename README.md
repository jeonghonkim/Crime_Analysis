# Crime Analysis in Orlando [22.01.13-]
![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) 'Analysis of Crime Incidents in Orlando using Python, R, ArcGIS Pro and ArcGIS Online'
<br />In Progress

```diff

[Progress Notes]

* Feb 11, 2022 Friday
    * Spatial join OPD Grids with Crime Points and ACS Census Block Group layer for analysis

* Feb 10, 2022 Thursday
    * OPD Grids uploaded to ArcGIS Online
    * Converting process from multipolygon csv to ArcGIS Online layer
        * Import csv and convert it to gdf
        * Export the gdf to shp
        * Re-import shp as sdf
        * Re-export sdf as lyer to ArcGIS Online

* Feb 9, 2022 Wednesday
    * Crated a webmap of Crime Points, ACS Census Block Groups, and Heatmaps of Crime Points from 2010 to 2020
    * Research the issue on the jurisdiction differences between Census Block Groups and Neighborhoods in the City of Orlando
    * Aggregate number of crimes by Census Block Group / Neighborhoods for the City of Orlando

* Feb 8, 2022 Tuesday
    * Problem solved - issue on the "You need to be signed in to use spatial analysis"
        * => 1) After restart kernel, log-in to arcgis online account again: 
        gis = GIS("https://www.arcgis.com", "your_id", "your_password")
        * => 2) Use a projected shapefile with no missing value
        * https://community.esri.com/t5/arcgis-api-for-python-questions/you-need-to-be-signed-in-to-use-spatial-analysis/td-p/751603
        * https://github.com/danioxoli/HotSpotAnalysis_Plugin/issues/36#issuecomment-509184014
    * Created a crime hotspots map with map widget
    * Exported a web map from map widget to ArcGIS Online

* Feb 7, 2022 Monday
    * Created a correlation plot of all ACS data by crime offense cateogry
    * Created two maps of crime points and ACS block data using Map Widget

* Feb 4. 2022, Thursday
    * Create crime heatmaps of Day of week and Hours by Crime Categories
    * Craete correlation plots of ACS data (Housing vacancy change, Median housing rent, Un-employment rate, 
    Precetange of educational attainment less than high school diploma) 

* Feb 2, 2022, Wednesday
    * Complete all spatial join and exporting sdf to ArcGIS Online
    * Finally complete the troubleshooting on intsalling geopandas and exporting layers to ArcGIS Online
        * 1) Deleted all environments excepting base and arcgispro-py3 base in Python Prompt Command
        * 2) After rebooting, set the environment to arcgispro-py3 base, and created clone environment in 
        Python Prompt Command: 'conda create -n yourclooneenv --clone arcgispro-py3
        * 3) After rebooting again, installed the anaconda in Python Prompt Command: 'conda install 
        anaconda'
        * 4) After rebooting one more time, updated all environments in Python Prompt Command: 'conda 
        update --all'
        * 5) After reboooting, installed geopandas in Python Prompt Command: 'conda install geopandas'
        * 6) Successfully imported geopandas in Jupyter Notebook in ArcGIS Proo

* Feb 1, 2022, Tuesday
    * Spatial join the crime-neighborhood sdf with the census block data
    * Trying to solve the issue on installing Geopandas - Not solved yet

* Jan 31, 2022, Monday
    * Complete the getting ACS block data in 2015 and 2019 in R
    * Trying to solve the error issue on exporting the completed spatial dataframe to a shapefile in a 
    local drive as well as to a layer in ArcGIS Online - Not solved yet

* Jan 28, 2022, Friday
    * Spatial joined the neighborhood crime data with the census block data in 2019 and 2015.
    * Included more variables into ACS block data, such as Housing monthly owner costs, available vehicles 
    by household, and transportation means to work - did not finish

* Jan 27, 2022, Thursday
    * Created the new census data based on census blocks in 2015, 2019 (ACS-5 years estiamtes)
    * Trying to solve the error issue on exporting the completed spatial dataframe to a shapefile in a 
    local drive as well as to a layer in ArcGIS Online - Not solved yet

* Jan 26, 2022, Wednesday
     * Referenced the Esri's Crime Analysis Solutions
     * Create the following layers and compared them 
         * Emerging Hotspot Analysis based on the Space-Time Cube Analysis
         * Optimized Hotspot Analysis
         * Kerned Density Analysis

* Jan 25, 2022, Tuesday
     * Referenced the Esri's Crime Analysis Solutions
     * Import the Collected ACS data to the Notebook in ArcgIS Pro, and merge it with the Orlando Crime 
     data
     * Create scatter plots and charts
     * Issues on installing Geopandas
         * => Could not solve, instead solved the issue with R. 

* Jan 24, 2022, Monday
    * Manpulate ACS data and create new columns and maps by using R (OPD_Crime_Analysis_220124.R)
    * Craete a barplot for densities as well as a heatmap of crime incidents by day of week and hour
    
* Jan 21, 2022, Friday
    * sovle the isuse on python environment: cannot install python module with pip install, 
      conda install
        * => create new python environment: Command Prompt, conda create -k --clone arcgispro-py3 --name 
          arcgispro-py3-clone
    * Research census data related to the crime data (modeling for crime)
    * Collect ACS in R and import them (OPD_Crime_Analysis_220121.R)
    
* Jan 20, 2022, Thursday
    * Spatial join crime data with neighborhoods shapefile
    * Create a bar plot of crime cases by neighborhoods in 2020
    
* Jan 19, 2022, Wednesday
    * Develop and re-organize analysis process
    * Data Wrangling - 1) Read CSV, 2) Check data, 3) Clean data
    
* Jan 18. 2022, Tuesday
    * Develop datetime analysis and create three plots

```
