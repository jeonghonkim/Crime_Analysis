# Crime Analysis in Orlando [22.01.13-]
![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) 'Analysis of Crime Incidents in Orlando using Python, R and ArcGIS Pro'
<br />In Progress

```diff

[Progress Notes]

* Jan 26, 2022
     * Referenced the Esri's Crime Analysis Solutions
     * Create the following layers and compared them 
         * Emerging Hotspot Analysis based on the Space-Time Cube Analysis
         * Optimized Hotspot Analysis
         * Kerned Density Analysis

* Jan 25, 2022
     * Referenced the Esri's Crime Analysis Solutions
     * Import the Collected ACS data to the Notebook in ArcgIS Pro, and merge it with the Orlando Crime data
     * Create scatter plots and charts
     * Issues on installing Geopandas
         * => Could not solve, instead solved the issue with R. 

* Jan 24, 2022
    * Manpulate ACS data and create new columns and maps by using R (OPD_Crime_Analysis_220124.R)
    * Craete a barplot for densities as well as a heatmap of crime incidents by day of week and hour of day
    
* Jan 21, 2022
    * sovle the isuse on python environment: cannot install python module with pip install, conda install
        * => create new python environment: Command Prompt, conda create -k --clone arcgispro-py3 --name arcgispro-py3-clone
    * Research census data related to the crime data (modeling for crime)
    * Collect ACS in R and import them (OPD_Crime_Analysis_220121.R)
    
* Jan 20, 2022
    * Spatial join crime data with neighborhoods shapefile
    * Create a bar plot of crime cases by neighborhoods in 2020
    
* Jan 19, 2022
    * Develop and re-organize analysis process
    * Data Wrangling - 1) Read CSV, 2) Check data, 3) Clean data
    
* Jan 18. 2022
    * Develop datetime analysis and create three plots

```
