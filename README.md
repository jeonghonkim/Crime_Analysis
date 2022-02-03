# Crime Analysis in Orlando [22.01.13-]
![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) 'Analysis of Crime Incidents in Orlando using Python, R, ArcGIS Pro and ArcGIS Online'
<br />In Progress

```diff

[Progress Notes]

* Feb 1, 2022, Tuesday
    * 

* Jan 31, 2022, Monday
    * Complete the getting ACS block data in 2015 and 2019 in R
    * Trying to solve the error issue on exporting the completed spatial dataframe to a shapefile in a local drive 
      as well as to a layer in ArcGIS Online - Not solved yet

* Jan 28, 2022, Friday
    * Spatial joined the neighborhood crime data with the census block data in 2019 and 2015.
    * Included more variables into ACS block data, such as Housing monthly owner costs, available vehicles by 
      household, and transportation means to work - did not finish

* Jan 27, 2022, Thursday
    * Created the new census data based on census blocks in 2015, 2019 (ACS-5 years estiamtes)
    * Trying to solve the error issue on exporting the completed spatial dataframe to a shapefile in a local drive 
      as well as to a layer in ArcGIS Online - Not solved yet

* Jan 26, 2022, Wednesday
     * Referenced the Esri's Crime Analysis Solutions
     * Create the following layers and compared them 
         * Emerging Hotspot Analysis based on the Space-Time Cube Analysis
         * Optimized Hotspot Analysis
         * Kerned Density Analysis

* Jan 25, 2022, Tuesday
     * Referenced the Esri's Crime Analysis Solutions
     * Import the Collected ACS data to the Notebook in ArcgIS Pro, and merge it with the Orlando Crime data
     * Create scatter plots and charts
     * Issues on installing Geopandas
         * => Could not solve, instead solved the issue with R. 

* Jan 24, 2022, Monday
    * Manpulate ACS data and create new columns and maps by using R (OPD_Crime_Analysis_220124.R)
    * Craete a barplot for densities as well as a heatmap of crime incidents by day of week and hour of day
    
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
