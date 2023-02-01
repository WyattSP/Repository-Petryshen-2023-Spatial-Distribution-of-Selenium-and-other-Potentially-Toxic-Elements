# -*- coding: utf-8 -*-
"""
Created on Fri Jan 21 10:04:20 2022

@author: wyattpetryshen
"""
#Data Source: https://climate.weather.gc.ca/climate_data/hourly_data_e.html?hlyRange=2014-10-23%7C2022-01-20&dlyRange=2018-10-29%7C2022-01-20&mlyRange=%7C&StationID=52959&Prov=BC&urlExtension=_e.html&searchType=stnProx&optLimit=specDate&Month=6&Day=1&StartYear=1840&EndYear=2019&Year=2021&selRowPerPage=25&Line=2&txtRadius=25&optProxType=navLink&txtLatDecDeg=49.745&txtLongDecDeg=-114.8839&timeframe=1

###
#Windrose improperly labels wind rose axes... this is an issue within the package itself.
#Please plot in a histogram to determine correct axes labels which are manually added on lines 56 and 81

import pandas as pd
import numpy as np
import os
from windrose import WindroseAxes
import matplotlib.pyplot as plt
from datetime import datetime
import matplotlib
import seaborn as sns

#All of the wind data is stored within the Wind Data folder.

#Set directory to Publication Data folder
directory = ''

#2020
os.chdir(directory + '/Wind Data/2020')

files_2020 = os.listdir()
files_2020 = [x for x in files_2020 if "DS_Store" not in x]

y2020 = [pd.read_csv(i, sep=",", header = [0])for i in files_2020]

columns = ['Year','Month','Day','Date/Time (LST)','Temp (°C)','Rel Hum (%)',
           'Wind Dir (10s deg)', 'Wind Spd (km/h)']

df2020 = pd.concat(y2020,ignore_index=True)

df2020 = df2020.sort_values("Date/Time (LST)")
df2020["WD"] = df2020["Wind Dir (10s deg)"] * 10

#FILTERED BY WORKING HOURS ONLY
DT_2020 = df2020
DT_2020["Date/Time (LST)"] = pd.to_datetime(DT_2020["Date/Time (LST)"])

DT_2020 = DT_2020.set_index("Date/Time (LST)")
DT_2020 = DT_2020.between_time('00:00','23:59')

#2021
os.chdir(directory + '/Wind Data/2021')

files_2021 = os.listdir()
files_2021 = [x for x in files_2021 if "DS_Store" not in x]

y2021 = [pd.read_csv(i, sep=",", header = [0])for i in files_2021]

columns = ['Year','Month','Day','Date/Time (LST)','Temp (°C)','Rel Hum (%)',
           'Wind Dir (10s deg)', 'Wind Spd (km/h)']

df2021 = pd.concat(y2021,ignore_index=True)

df2021 = df2021.sort_values("Date/Time (LST)")
df2021["WD"] = df2021["Wind Dir (10s deg)"] * 10

#FILTERED BY WORKING HOURS ONLY
DT_2021 = df2021
DT_2021["Date/Time (LST)"] = pd.to_datetime(DT_2021["Date/Time (LST)"])

DT_2021 = DT_2021.set_index("Date/Time (LST)")
DT_2021 = DT_2021.between_time('00:00','23:59')

#2022
os.chdir(directory + '/Wind Data/2022')

files_2022 = os.listdir()
files_2022 = [x for x in files_2022 if "DS_Store" not in x]

y2022 = [pd.read_csv(i, sep=",", header = [0])for i in files_2022]

columns = ['Year','Month','Day','Date/Time (LST)','Temp (°C)','Rel Hum (%)',
           'Wind Dir (10s deg)', 'Wind Spd (km/h)']

df2022 = pd.concat(y2022,ignore_index=True)

df2022 = df2022.sort_values("Date/Time (LST)")
df2022["WD"] = df2022["Wind Dir (10s deg)"] * 10

#FILTERED BY WORKING HOURS ONLY
DT_2022 = df2022
DT_2022["Date/Time (LST)"] = pd.to_datetime(DT_2022["Date/Time (LST)"])

DT_2022 = DT_2022.set_index("Date/Time (LST)")
DT_2022 = DT_2022.between_time('00:00','23:59')


###Concatenate all years together
con_frames = [DT_2020,DT_2021,DT_2022]
con_frames = pd.concat(con_frames)

#SINGLE PLOT for all years
sns.set_style('darkgrid')
sns.distplot(con_frames["WD"])

def plot_single(data,save_path = None ,save = False):
    '''
    Parameters
    ----------
    data : DataFrame
        Wind Date.
    save_path : Str, optional
        Save Path for figure. The default is None.
    save : Boolean, optional
        Logical value indicating if figure should be saved. The default is False.

    Returns
    -------
    Figure

    '''

    wd = data["WD"]
    ws = data['Wind Spd (km/h)']
    ax = WindroseAxes.from_ax()
    ax.bar(wd,ws, normed=True, opening=0.8, edgecolor='white')
    ax.set_legend()
    matplotlib.projections.polar.PolarAxes.set_thetagrids(ax, angles=[90,45,0,315,270,225,180,135], labels=["N","NE","E","SE","S","SW","W","NW"], fmt='str')
    if save == True:
        save_path = save_path
        plt.savefig(save_path,dpi=600)
    return

#Run to create Wind Rose plot for all years. Can plot individual years if desired by changing con_frames to DT_2020, DT_2021, or DT_2022 in plot_single() function.
#To save figure to path change last parameter to True
plot_single(con_frames,'WindRose.tiff',False)


#MONTHLY SUBPLOTS
def plot_multi(data, time, year, save_path = None ,save = False):
    '''
    Parameters
    ----------
    data : DataFrame
        Dataframe of wind data; Data can only be for a single year.
    time : Str
        Filter wind data based on time over 24hrs.
    year : Num
        Year of data; Can only be for single year
    save_path : Str, optional
        Save Path for figure. The default is None.
    save : Boolean, optional
        Logical value indicating if figure should be saved. The default is False.

    Returns
    -------
    Figure

    '''
    name_add = str(time)
    nrows, ncols = 3, 4
    fig = plt.figure()

    year = year
    month = [1,2,3,4,5,6,7,8,9,10,11,12]

    fig.suptitle(f"Wind Speed - {year} - {name_add}")
    for month in range(1, 13):
        ax = fig.add_subplot(nrows, ncols, month, projection="windrose")
        title = datetime(year, month, 1).strftime("%b")
        ax.set_title(title)


        direction = data[data.loc[:,'Month'] == month]["WD"]
        var = data[data.loc[:,'Month'] == month]["Wind Spd (km/h)"]

        ax.bar(direction, var, nsector= 36,opening=0.94, bins=np.arange(0, 31, 5),edgecolor='gray',lw=0.1)
        matplotlib.projections.polar.PolarAxes.set_thetagrids(ax, angles=[90,45,0,315,270,225,180,135], labels=["N","NE","E","SE","S","SW","W","NW"], fmt='str')
    plt.subplots_adjust(wspace = 0.4, hspace = 0.4)
    if save == True:
        save_path = save_path
        plt.savefig(save_path,dpi=600)
    plt.show()
    return

#Plot Wind Rose by individual years; Can specificy time of time collection in a day.
#To save figure to path change the last parameter to Trur.
plot_multi(DT_2021, '00:00 to 23:59', 2021,'Month_2021.tiff', False)
