# IMPORT MODUELS
import pandas as pd
import numpy as np
from arcpy import env
from arcgis.gis import GIS
from arcgis.features import SpatialDataFrame
from arcgis.geocoding import geocode
from arcgis.geometry import lengths, areas_and_lengths, project
from arcgis.geometry import Point, Polyline, Polygon, Geometry
from arcgis.features import GeoAccessor, GeoSeriesAccessor
from datetime import datetime

# LOG-IN TO ARCGIS ONLINE
gis = GIS("https://www.arcgis.com", "kjhoon", "Apotheosis3267!")

# CREATE BASEMAP
map1 = gis.map('Orlando, FL', 13)
map1.basemap = "satellite"
map1

# IMPORT CSV & GET SUMMARY INFO OF DF
crime_df = pd.read_csv(r'C:/Users/KIM36105/Downloads/OPD_Crimes.csv')
crime_df1 = crime_df
crime_df1.info()

# CHECK DF
crime_df1.head()

# REMOVE UNNECESSARY STRINGS IN COORDINATE COLUMN
crime_df1['Location'] = crime_df['Location'].str.replace("(","")
crime_df1['Location'] = crime_df['Location'].str.replace(")","")
crime_df1.head()

# CREATE SEPARTE COLUMNS FOR LATITUDE AND LONGITUDE
lat = []
lon = []

for row in crime_df1['Location']:
    try:
        lat.append(row.split(',')[0])
        lon.append(row.split(',')[1])
    except:
        lat.append(np.NaN)
        lon.append(np.NaN)

crime_df1['Latitude'] = lat
crime_df1['Longitude'] = lon
crime_df1.head()

# CREATE SEPARATE COLUMNS FOR DAY MONTH YEAR
crime_df1['Case Date Time'] = pd.to_datetime(crime_df1['Case Date Time'], format = '%m/%d/%Y %I:%M:%S %p')
crime_df1.head()

# CREATE SEPARATE COLUMNS FOR YEAR, MONTH, DAY
crime_df1['Year'] = pd.DatetimeIndex(crime_df1['Case Date Time']).year
crime_df1['Month'] = pd.DatetimeIndex(crime_df1['Case Date Time']).month
crime_df1['Day'] = pd.DatetimeIndex(crime_df1['Case Date Time']).day
crime_df1.head()

# DEFINE THE COLUMNS AS INTEGER 
crime_df1['Year'] = crime_df1['Year'].fillna(0)
crime_df1['Year'] = crime_df1['Year'].astype(int)
crime_df1['Month'] = crime_df1['Month'].fillna(0)
crime_df1['Month'] = crime_df1['Month'].astype(int)
crime_df1['Day'] = crime_df1['Day'].fillna(0)
crime_df1['Day'] = crime_df1['Day'].astype(int)
crime_df1.head()

# CHEKC THE SUMMARY OF DATA
crime_df1.info()

# CREATE SUBSET WITH 2020 YEAR
crime_df1_2020 = crime_df1.loc[:][crime_df1['Year'] == 2020]
crime_df1_2020.head()

# READ INTO SPATIALLY ENABLED DATAFRAME SEDF
crime_sedf1_2020 = pd.DataFrame.spatial.from_xy(crime_df1_2020, 'Longitude', 'Latitude')
crime_sedf1_2020.head()

# Plot the Crime SDEF and Check it
crime_sedf1_2020.spatial.plot(map1)

# Export to ArcGIS Online Repository
Orlando_Crime = crime_sedf1_2020.spatial.to_featurelayer('Orlando_Crimes_2020')
Orlando_Crime

# Time series analysis
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
plt.style.use('classic')
%matplotlib inline

# Useful datetime tools
from datetime import datetime
from dateutil import parser

# conda install seaborn
# The above line is for installing seaborn

# Read original csv
crime_df = pd.read_csv(r'C:/Users/KIM36105/Downloads/OPD_Crimes.csv')
crime_analysis_df = crime_df
crime_analysis_df.head()

# Checking the total number of rows
len(crime_analysis_df.index)

# 1) Remove NA values in Case Date Time and Case Location columns (Time and Location) / Compare the outcome
crime_analysis_df1 = crime_analysis_df.dropna(subset=['Case Date Time','Case Location'])
len(crime_analysis_df1.index)

# Two cases removed.

# To sillence SettingWithCopyWarning
pd.options.mode.chained_assignment = None
crime_analysis_df1.dtypes

# 2) DateTime
# 2-1) Set DateTime format
crime_analysis_df1['Case Date Time'] = pd.to_datetime(crime_analysis_df1['Case Date Time'])
crime_analysis_df1.dtypes

# Create Year, Month, Day Columns
crime_analysis_df1['Date'] = crime_analysis_df1['Case Date Time'].dt.date
crime_analysis_df1['Time'] = crime_analysis_df1['Case Date Time'].dt.time
crime_analysis_df1['YearMonth'] = crime_analysis_df1['Case Date Time'].dt.strftime('%Y-%m')
crime_analysis_df1['Year'] = crime_analysis_df1['Case Date Time'].dt.year
crime_analysis_df1['Month'] = crime_analysis_df1['Case Date Time'].dt.month
crime_analysis_df1['Day'] = crime_analysis_df1['Case Date Time'].dt.day
crime_analysis_df1['Weekday'] = crime_analysis_df1['Case Date Time'].dt.dayofweek
crime_analysis_df1['Hour'] = crime_analysis_df1['Case Date Time'].dt.hour
crime_analysis_df1['Minute'] = crime_analysis_df1['Case Date Time'].dt.minute
crime_analysis_df1['Second'] = crime_analysis_df1['Case Date Time'].dt.second

crime_analysis_df1.head()

# Check datatypes of each column
crime_analysis_df1.dtypes

# Convert to Year, Month as integer after filling in 0 instead of na.
crime_analysis_df1['Year'] = crime_analysis_df1['Year'].fillna(0)
crime_analysis_df1['Month'] = crime_analysis_df1['Month'].fillna(0)
crime_analysis_df1['Day'] = crime_analysis_df1['Day'].fillna(0)
crime_analysis_df1['Weekday'] = crime_analysis_df1['Weekday'].fillna(33) # since 0 represents monday in this column

crime_analysis_df1['Year'] = crime_analysis_df1['Year'].astype(int)
crime_analysis_df1['Month'] = crime_analysis_df1['Month'].astype(str)
crime_analysis_df1['Day'] = crime_analysis_df1['Day'].astype(int)
crime_analysis_df1['Weekday'] = crime_analysis_df1['Weekday'].astype(str)
crime_analysis_df1.dtypes

# Replace values in Month and Weekday
crime_analysis_df1['Month'] = crime_analysis_df1['Month'].replace(
    ['1','2','3','4','5','6','7','8','9','10','11','12'],
    ['January','February','March','April','May','June','July','August','September','October','November','December'])

crime_analysis_df1['Weekday'] = crime_analysis_df1['Weekday'].replace(
    ['0', '1', '2', '3', '4', '5', '6'],
    ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
)
crime_analysis_df1.head()

# b-1. Total crime cases from 2010 to 2020
crime_Date_df1 = crime_analysis_df1.groupby(['Date']).size().reset_index().rename(columns={0: 'Crime Incidents'})
crime_Date_df1

# Assign plot size
plt.figure(figsize = (15,8))

# Assign styles
sns.set_style("darkgrid")
pal = sns.color_palette('Set2', 12)

# Create line-plot
sns.lineplot(data=crime_Date_df1, 
             x="Date", y="Crime Incidents",
            palette=pal)

# Shows the plot
plt.show()

# b-2. Total crime cases by Case Offense Category from 2010 to 2020
crime_Date_df2 = crime_analysis_df1.groupby(['Date', 'Case Offense Category']).size().reset_index().rename(columns={0: 'Crime Incidents'})
crime_Date_df2

# Plot from 2010 to 2020
# Assign plot size
plt.figure(figsize = (18,10))

# Assign styles
sns.set_style("darkgrid")
pal = sns.color_palette('Set2', 12)
sns.set(rc={'axes.facecolor': 'darkgray'})

# Create line-plot
sns.lineplot(data=crime_Date_df2, 
             x="Date", y="Crime Incidents", hue='Case Offense Category',
            palette=pal)

# Shows the plot
plt.show()

# b-3. Create a subset Crime Data in 2020
crime_Date_df3 = crime_Date_df2
crime_Date_df3['Date'] = pd.to_datetime(crime_Date_df3['Date'])
crime_Date_df3 = crime_Date_df3.loc[crime_Date_df3['Date'].dt.year >= 2020]
crime_Date_df3.head()

# Plot in 2020
# Assign plot size
plt.figure(figsize = (18,10))

# Assign styles
sns.set_style("whitegrid")
pal = sns.color_palette('Set2', 11)
sns.set(rc={'axes.facecolor': 'darkgray'})

# Create line-plot
sns.lineplot(data=crime_Date_df3, 
             x="Date", y="Crime Incidents", hue='Case Offense Category',
            palette=pal)

# Shows the plot
plt.show()

# Converted 
crime_Date_df3_1=crime_Date_df3.pivot(index='Date', columns='Case Offense Category', values='Crime Incidents').reset_index()
crime_Date_df3_1.head()

# Theft
crime_Date_df3_2 = crime_Date_df3_1.loc[:, ['Date', 'Theft']].reset_index(drop=True).rename_axis('',axis=1).set_index('Date', drop=True)
crime_Date_df3_2.head()

plt.figure(figsize=(8,16))

crime_Date_df3_2.plot()
crime_Date_df3_2.rolling(30).mean().plot(style='--');

plt.show()

crime_Date_df2['Date'] = pd.to_datetime(crime_Date_df2['Date'])
crime_Date_df2_1=crime_Date_df2.pivot(index='Date', columns='Case Offense Category', values='Crime Incidents').reset_index()
crime_Date_df2_1.head()

crime_Date_df2['Date'] = pd.to_datetime(crime_Date_df2['Date'])
crime_Date_df2_1=crime_Date_df2.pivot(index='Date', columns='Case Offense Category', values='Crime Incidents').reset_index()
crime_Date_df2_2 = crime_Date_df2_1.loc[:, ['Date', 'Theft']].reset_index(drop=True).rename_axis('',axis=1).set_index('Date', drop=True)
crime_Date_df2_2.head()

plt.figure(figsize=(20,10))

crime_Date_df2_2.plot()
crime_Date_df2_2.rolling(250).mean().plot(style='--');

plt.show()









plt.figure(figsize=(15,8))

# plot data
ge.plot()

# plot 250 day rolling mean
ge.rolling(250).mean().plot(style='--');



# Rolling plot with average 250days values
# Assign plot size
plt.figure(figsize = (15,8))

# Assign styles
sns.set_style("darkgrid")

# Create line-plot
sns.lineplot(data=crime_Date_df1, 
             x="Date", y="Crime Incidents",
            palette=pal)

# Shows the plot
plt.show()


print(crime_Date_df2['Case Offense Category'].value_counts())

# In the case you can't install cnesus extension with pip install, please use the following codes.

# conda install censusdata
# conda install census
# codna install us













from census import Census
from us import states

c = Census("42e1b9b3b73ee4990e7c15500d52250286ba72cc")
c.acs5.get(('NAME', 'B25034_010E'),
          {'for': 'state:{}'.format(states.MD.fips)})

import pandas as pd
df = pd.DataFrame(columns=col_names, data = r.jason()[1:])

# Import the feature layer's data frame from ArcGIS Online Account
# In the previous step, logged-in to the account using "gis = GIS("https://www.arcgis.com", "kjhoon", "Apotheosis3267!")"
item = gis.content.get("19903ebe9bfc44c9bf5bd8bc110d7282")
flayer = item.layers[0]
flayer


