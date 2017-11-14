### Introduction to R as a GIS: reading and writing data, processing and mapping data, overlays with raster data
### By Lotem Taylor for Audubon R tutorial (November 2017)

###########################################
#                                         #
# reading and writing shapefiles          #
#                                         #
###########################################

setwd(dir="C:/Users/ltaylor/Box Sync/9_Admin_Conservation_Science/R series/data_for_R_tutorial2")

library(rgdal)

# reading in
states <- readOGR(dsn="ne_50m_usa.shp", # dsn = full folder path to file, including extension
                  layer="ne_50m_usa") # layer = file name without extension

# writing out
writeOGR(obj=states, 
         dsn="ne_50m_usa_copy.shp", 
         layer="ne_50m_usa_copy", 
         driver="ESRI Shapefile")

library(raster)

# reading in
states <- shapefile(x="ne_50m_usa.shp")

# writing out
shapefile(x=states, 
          filename="ne_50m_usa_copy.shp", 
          overwrite=TRUE)

###########################################
#                                         #
# processing data                         #
#                                         #
###########################################

# reading in point data from a CSV
AMOY <- read.csv(file="amoy.csv", stringsAsFactors=FALSE)

# converting to spatial object
AMOY <- SpatialPointsDataFrame(coords=cbind(AMOY$long, AMOY$lat), # create coordinates from numeric matrix of points
                               data=AMOY, # add data frame of attribute data
                               proj4string=CRS("+proj=longlat +ellps=WGS84")) # specify spatial reference system

# subsetting by attributes
AMOY_copy <- AMOY # copy data into a new object
AMOY_copy <- AMOY_copy[AMOY_copy@data$year==2017, ] # only include records from 2017
AMOY_copy[is.na(AMOY_copy@data$fledglings)] <- 0 # fill in NAs in the fledglings field as zeros
AMOY_copy <- AMOY_copy[AMOY_copy@data$fledglings > 0, ] 

# how would you subset the dataset to only include records within 1 mile of the coastline?
# hint: fill in the blanks below...
# AMOY_copy <- AMOY_copy[AMOY_copy@data$__ < __, ]



###########################################
#                                         #
# mapping data                            #
#                                         #
###########################################

# default plotting
plot(x=states)

# making a more customized map
bbox(AMOY)
plot(x=states, 
     xlim=c(bbox(AMOY)[1], bbox(AMOY)[3]), # set extent of x-coordinate based on AMOY extent
     ylim=c(bbox(AMOY)[2], bbox(AMOY)[4]), # set extent of y-coordinate based on AMOY extent
     col="gray90", 
     border="gray70", 
     lwd=0.5)
points(x=AMOY, 
       pch=21, 
       col=rgb(red=7, green=152, blue=242, alpha=150, maxColorValue=255), # you can create colors in R based on RGB values
       bg=rgb(red=125, green=203, blue=251, alpha=150, maxColorValue=255), # alpha: 0=transparent, 255=opaque
       cex=AMOY@data$pairs.b)

AMOY@data$color.field <- ifelse(AMOY@data$type=="Beach", 
                                rgb(red=0, green=0, blue=150, alpha=50, maxColorValue=255), # if type is "Beach", this will be the color
                                rgb(red=150, green=0, blue=0, alpha=50, maxColorValue=255)) # if type is not "Beach", this will be the color
plot(x=states, 
     xlim=c(bbox(AMOY)[1], bbox(AMOY)[3]), 
     ylim=c(bbox(AMOY)[2], bbox(AMOY)[4]), 
     col="gray90", 
     border="gray70", 
     lwd=0.5)
points(x=AMOY, 
       pch=21, 
       col="black", 
       bg=AMOY@data$color.field, 
       cex=2)

# how would you visualize the data by both type (Beach or Island) and number of breeding pairs?
# hint: fill in the blanks below...
# plot(states, xlim=c(bbox(AMOY)[1], bbox(AMOY)[3]), ylim=c(bbox(AMOY)[2], bbox(AMOY)[4]), col="gray90", border="gray70", lwd=0.5)
# points(AMOY, pch=21, col="black", 
#     bg=__,
#     cex=__)



###########################################
#                                         #
# spatial overlays with raster data       #
#                                         #
###########################################

# read in landcover data
landcover <- raster("CEC_landcover_2010.tif")
plot(landcover)

# do the spatial reference systems of the landcover and AMOY datasets match?
# hint: crs(AMOY) and crs(landcover) give the spatial reference systems of these objects

# transforming CRS of points to match raster (albers equal area)
AMOY <- spTransform(x=AMOY, CRSobj=landcover@crs)

# cropping extent of landcover data to match point data
lc_cropped <- crop(x=landcover, y=bbox(AMOY))
plot(lc_cropped)

# save cropped raster
writeRaster(x=lc_cropped, filename="CEC_landcover_2010_crop_to_AMOY.tif")

# extract landcover values at points
AMOY.lc <- extract(x=landcover, y=AMOY, method="simple")
AMOY@data <- cbind(AMOY@data, AMOY.lc) # bind extracted values back into AMOY data

# merge in classes from lookup table
lc_lookup <- read.csv("cec_landcover_classes.csv", stringsAsFactors=FALSE)
AMOY@data <- merge(AMOY@data, lc_lookup, by.x="AMOY.lc", by.y="value")
table(AMOY@data$class)

# how would you crop the landcover raster to match the extent of your state? (hint: be careful of spatial references here!)
# hint: fill in the blanks below...
# 1. subset states object to your state: my_state <- states[states@data$name=="__", ]
# 2. transform CRS of your state to match the landcover raster: my_state <- spTransform(x=__, CRSobj=__)
# 3. crop landcover raster by your state: lc_my_state <- crop(x=__, y=bbox(__))






