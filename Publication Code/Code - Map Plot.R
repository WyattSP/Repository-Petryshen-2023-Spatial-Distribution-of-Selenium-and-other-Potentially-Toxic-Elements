#Map plot of data
library(ggplot2)
library(ggmap)
library(rgdal)
library(ggsn)
library(ggpubr)

#Data import if not already done from before
path = "File Path to Publication_Data.xlsx" #Alternatively, CF_data from previous 'Code - Contamination Factor.R' is the same
CF_data <- read_excel(path, sheet = "Contamination Factor Data")
#or for Moss Data
path = "File Path to Publication_Data.xlsx" #Alternatively, CF_data from previous 'Code - Processing, Cleaning, and Summary Statistics.R' is the same
moss_data <- read_excel(path, sheet = "Moss Data")

#Remove sample site 11; trim data to only contain elemental data
input_plot_data = moss_data[-c(5),21:73]

#Bounding Box
loc <- c(left = -115.178487, bottom = 49.471568, right = -114.35254726834049, top = 50.0322870785824)

#Import of Shape Files
#Paths to shapefiles need to be changed
elkview <- readOGR(dsn = "~Path to shapefiles/Elkview.shp", stringsAsFactors = F)
elkview <- spTransform(elkview, CRS("EPSG:4326"))
linecreek <- readOGR(dsn ="~Path to shapefiles/Line Creek.shp", stringsAsFactors = F)
linecreek <- spTransform(linecreek, CRS("EPSG:4326"))
linecreekprocessingplant <- readOGR(dsn ="~Path to shapefiles/Line Creek Processing Plant.shp", stringsAsFactors = F)
linecreekprocessingplant <- spTransform(linecreekprocessingplant, CRS("EPSG:4326"))

elkview_cent <- readOGR(dsn ="~Path to shapefiles/Elkview Centroid.shp", stringsAsFactors = F)
elkview_cent <- spTransform(elkview_cent, CRS("EPSG:4326"))

linecreek_cent <- readOGR(dsn ="~Path to shapefiles/Line Creek Centroid.shp", stringsAsFactors = F)
linecreek_cent <- spTransform(linecreek_cent, CRS("EPSG:4326"))

linecreekprocessing_cent <- readOGR(dsn ="~Path to shapefiles/Line Creek Processing Plant Centroid.shp", stringsAsFactors = F)
linecreekprocessing_cent <- spTransform(linecreekprocessing_cent, CRS("EPSG:4326"))

#Moss Species, Lat, and Long set to their own variables; remove sample site 11
Species.Tent = moss_data[-c(5),]$Species.Tent
Lat = moss_data[-c(5),]$Lat
Long = moss_data[-c(5),]$Long


#Spatial Distibutions plots
#Map Plot Figure for Selenium
Se_Plot = get_stamenmap(loc, maptype = "terrain") %>% ggmap() +
  geom_polygon(data = elkview, aes(x = long, y = lat), colour = "black", fill = 'black', alpha = 0.5) +
  geom_polygon(data = linecreek, aes(x = long, y = lat), colour = "black", fill = 'black', alpha = 0.5) +
  geom_point(aes(x = elkview_cent@coords[1], y = elkview_cent@coords[2]), colour = "black") +
  geom_point(aes(x = linecreek_cent@coords[1], y = linecreek_cent@coords[2]), colour = "blue") +
  geom_point(input_plot_data, mapping=aes(Lat,Long, color = Se), colour = 'black', size = 5, show.legend = FALSE) +
  geom_point(input_plot_data, mapping=aes(Lat,Long, color = Se), size = 4, show.legend = FALSE) +
  geom_point(input_plot_data, mapping=aes(Lat,Long, color = Se), size = 0, fill = "NA") +
  scale_color_gradient(low = "white", high = "red") +
  scalebar(x.min = -114.7, x.max = -114.4,
           y.min = 49.50, y.max = 50.2, dist = 5, dist_unit = "km",
           transform = TRUE)
Se_Plot = Se_Plot + theme(legend.position = c(0.91, 0.87),
                          legend.background = element_rect(fill = "white", color = "black")) +
  labs(colour="Se (mg/kg dw)") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x = element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.title.y = element_blank())
Se_Plot
ggsave("~/Google Drive/My Drive/Geoscience:Engineering/Moss Study/Figures/Se_Plot_Solo.tiff", Se_Plot,  dpi=300, units = "in")
