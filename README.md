# Repository-Petryshen-2023-Spatial-Distribution-of-Selenium-and-other-Potentially-Toxic-Elements
 Data repository and supplementary information for the article Petryshen W. 2023. Spatial Distribution of Selenium and other Potentially Toxic Elements associated with Mountaintop Coal Mining in the Elk Valley, British Columbia, Canada.

 W. Petryshen<sup>1</sup>
 <br/> <sup>1</sup> Wildsight, Kimberley, British Columbia, Canada

 This repository contains the scripts, data, and shapefiles from the study. You should be able to run all the analysis as well as recreate all the plots from the below scripts. Many of the R scripts are dependent on previously run and transformed data. Either run all the code in the order presented below, within a single R environment, or important required data as indicated in the scripts.

 The provided code was run in R Studio (RStudio Team, 2020; Version 2022.02.0 Build 443) running R Software (R Core Team 2021; Version 4.1.2).

 Full Datasets are included in the Publication_Data.xlsx file within the Publication Data Folder. The 'Original Data' sheet is the initial import in the data analysis and is duplicated from the ALS lab reports which are titled "ALS Report".

 Note that for the Contamination Factor Data sheet within the Publication_Data.xlsx file, sample 11 is included. Sample 11 needs to be removed for additional analysis in the generalized additive models and when calculating the Pearson correlation coefficients. Within the R scripts, if following it step-by-step, sample 11 will be removed.

 Data processing and analysis was run with the following R code:
 1) Code - Processing, Cleaning, and Summary Statistics.R
 2) Code - Contamination Factor.R
 3) Code - Generalized Additive Models.R
 4) Code - Element Correlations.R
 5) Code - Map Plot.R
 6) Code - Original Sample Site Boxplots.R

 Python Scripts below to calculate azimuth positions and to create wind rose plots. The above analysis is not dependent on these scripts.
 * Code - Azimuth Calculation.py
 * Code - Wind Rose.py

 To reproduce the Tables and Figures:
 * Table 1 data can be retrieved from the 'Summary Statistics No Site 11' sheet in Publication_Data.xlsx
 * Table 2 data can be retrieved by running line 19, 26, and 29 in 'Code - Generalized Additive Models.R'
 * Table 3 data can be retrieved from the 'Pearson Correlation Coefficient' sheet in Publication_Data.xlsx
 * Figure 1 was completed in QGIS
 * Figure 2 run 'Code - Map Plot.R' following full analysis of data
 * Figure 3 run lines 75-220 following creation of the GAMs in 'Code - Generalized Additive Models.R'
 * Figure 4 run lines 37-103 following calculations in 'Code - Element Correlations.R'

 Data outputs from each R script is included in the CSV Files of R Exports folder:
 * Cleaned Moss Data.csv
 * Summary_Statistics.csv
 * Summary_Statistics_No_11.csv
 * Contamination Factor Data.csv

 Shape files used in Code - Map Plots.R can be found in the Shapefiles folder. The centroid locations for the Elkview Mine, the Line Creek Coal Processing Plant, and the Line Creek Mine were calculated in QGIS from these shapefiles. Centorid location shapefiles are also included in this folder.

 Shapefiles folder:
 * Elkview Mine Shapefile
 * Line Creek Processing Plant Shapefile
 * Line Creek Mine Shapefile
 * Elkview Mine Centroid
 * Line Creek Processing Plant Centroid
 * Line Creek Mine Centroid
 * No Data Moss Sample Locations
