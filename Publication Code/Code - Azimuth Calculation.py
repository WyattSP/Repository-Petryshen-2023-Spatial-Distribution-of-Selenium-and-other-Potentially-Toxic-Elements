#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 19:39:54 2022

@author: wyattpetryshen
"""

#Calculate bearing from source centroid to sample location
import pyproj
path = "Path to Publication Data/Moss_Data.xlsx"
Moss = pd.read_excel(path,'Original Data')

#Coordinates of centroid locations
Elkview_cent = [-114.8187556,49.7439499]
LineCreek_cent = [-114.767912,49.95192297]
LineCreekProp_cent = [-114.8512769,49.88011736]

#Set ellipse
geodesic = pyproj.Geod(ellps='WGS84')

#Functions to calculate azimuths
def bearing(source,target):
    fwd_azimuth,back_azimuth,distance = geodesic.inv(source[0],source[1],target[0],target[1])
    return([fwd_azimuth,back_azimuth,distance])

def find_bearing(source,sample_df):
    temp_l = []
    for i in np.arange(0,len(sample_df)):
        row_name = sample_df['Site'][i]
        vals = bearing(source,[float(sample_df.iloc[i,4]),float(sample_df.iloc[i,5])])
        t = [row_name,vals[0],vals[1],vals[2]]
        temp_l.append(t)
    return(temp_l)

def convert_to_360(azimuth_list):
    out = []
    for i in azimuth_list:
        if i > 0:
            v1 = i
            out.append(v1)
        elif i < 0:
            v1 = 360 + i
            out.append(v1)
    return(out)


#Lists of output; [Site ID, fwd_azimuth, back_azimuth, distance]
Elkview_b = find_bearing(Elkview_cent,Moss)
LineCreek_b = find_bearing(LineCreek_cent,Moss)
LineCreekProp_b = find_bearing(LineCreekProp_cent,Moss)

#Retrieve only fwd_azimuth
Elkview_fwd_azimuth = [i[1] for i in Elkview_b]
LineCreek_fwd_azimuth = [i[1] for i in LineCreek_b]
LineCreekProp_fwd_azimuth = [i[1] for i in LineCreekProp_b]

#Convert to 360 degrees
Elkview_360 = convert_to_360(Elkview_fwd_azimuth)
LineCreek_360 = convert_to_360(LineCreek_fwd_azimuth)
LineCreekProp_360 = convert_to_360(LineCreekProp_fwd_azimuth)
