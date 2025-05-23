#SeaWolf Tracks
library(raster)
dir <- setwd("~/Desktop/Raster")

# These are the ship datafiles in ALAR archive drive

df <- read.csv('2022-06-16__2022-06-21_Seawolf_1hz.csv') 
df1 <- read.csv('2022-06-01__2022-06-06_Seawolf_1hz.csv')
df2 <- read.csv('2022-05-12__2022-05-15_Seawolf_1hz.csv')
df3 <- read.csv('2022-04-28__2022-05-04_Seawolf_1hz.csv')
df4 <- read.csv('2022-04-22__2022-04-22_Seawolf_1hz.csv')
df5 <- read.csv("2022-04-07__2022-04-16_Seawolf_1hz.csv")
df6 <- read.csv("2022-03-10__2022-03-14_Seawolf_1hz.csv")
df7 <- read.csv("2022-02-23__2022-02-27_Seawolf_1hz.csv")
df8 <- read.csv("2022-02-01__2022-02-07_Seawolf_1hz.csv")

#downloaded from EDGAR v7 
#inventory is EDGARv.7
r <- raster(paste0('v7.0_FT2021_CH4_2021_TOTALS.0.1x0.1.nc'))   

#change longitude from 0-360 to -180-180 (https://gis.stackexchange.com/questions/284224/convert-over-360-degree-range-of-coordinates-to-180-longitude-range-in-r/284228#284228)
Eastern <- extent(c(xmin=0,xmax=180,ymin=-90,ymax=90))
Western <- extent(c(xmin=180, xmax=360, ymin=-90, ymax=90))

r1 <- crop(r,Eastern)
r2 <- crop(r,Western)

xmin(r2) <- xmin(r2)-360
xmax(r2) <- xmax(r2)-360

R <- merge(r1,r2)

# convert the units to nmol/m2/s as units are in kg ch4/m2/s
K <-  1000 * (1/16.04) * (1*10^9)

Final <- R*K 

# always use log10 when plotting world scale
#plotting Edgar v7 for our specific region
png("test.png")
par(mar=c(5,4,4,2) + 0.1 + c(0,0,0,5))
plot(log10(Final), main= "SeaWolf Sea Tracks", xlab= "Longitude",
     ylab= "Latitude", xlim=c(-85,-65), ylim=c(34,46),zlim=c(-2,3),legend=T, col=fields::tim.colors(),
      legend.width=.75, legend.shrink=0.75, horizontal = T,
     legend.args=list(text='CH4 (nmol/m2/s)', side=1, font=2, line=2, cex=0.8))

library(rgdal)
states <- readOGR('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
states.p <- spTransform(states,CRSobj=CRS(projection(Final)))
lines(states.p,xlim=c(-85,-65), ylim=c(34,46))

projection(states.p) # check again and double check it worked

#Cartographic Boundary files are a separate dataset produced by the US census bureau. 
#These are simplified areas that are a bit smaller than equivalent tigerline files might be and 
#also are not necessarily consistent year-to-year.  As such it can be a smoother/cleaner outline 
#for states/coastlines, but shouldn't be used for anything other than visuals.  #
#These are available at a variety of scales for similar divisions as tigerline files.  
#https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html

#adding  SeaWolf tracks
lines(df$Longitude_deg,df$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df1$Longitude_deg,df1$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df2$Longitude_deg,df2$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df3$Longitude_deg,df3$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df4$Longitude_deg,df4$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df5$Longitude_deg,df5$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df6$Longitude_deg,df6$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df7$Longitude_deg,df7$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df8$Longitude_deg,df8$Latitude_deg, col = ('red'), lwd= 1.5) 

#creating a legend
par(xpd = TRUE)
legend(x= "right",legend=c("SeaWolf Tracks"), 
       col = c("red"), 
       lty= 1:2, cex=0.8, inset = -0.3, -0.7)

graphics.off()
#rm(list=ls()) = clear environment [just a reminder]


#Part two
##############
png("test-zoomed.png")
par(mar=c(5,4,4,2) + 0.1 + c(0,0,0,5))
plot(log10(Final), main= "SeaWolf Sea Tracks", xlab= "Longitude",
     ylab= "Latitude", xlim=c(-79, -70), ylim=c(37, 44),zlim=c(-2,3),legend=T, col=fields::tim.colors(),
     legend.width=.75, legend.shrink=0.75, horizontal = T,
     legend.args=list(text='CH4 (nmol/m2/s) log scale', side=1, font=2, line=2, cex=0.8))


library(rgdal)
states <- readOGR('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
states.p <- spTransform(states,CRSobj=CRS(projection(Final)))
lines(states.p,xlim=c(-78.5, -69.5), ylim=c(37.5, 43))

projection(states.p) # check again and double check it worked

#Cartographic Boundary files are a separate dataset produced by the US census bureau. 
#These are simplified areas that are a bit smaller than equivalent tigerline files might be and 
#also are not necessarily consistent year-to-year.  As such it can be a smoother/cleaner outline 
#for states/coastlines, but shouldn't be used for anything other than visuals.  #
#These are available at a variety of scales for similar divisions as tigerline files.  
#https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html

#adding  SeaWolf tracks
lines(df$Longitude_deg,df$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df1$Longitude_deg,df1$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df2$Longitude_deg,df2$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df3$Longitude_deg,df3$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df4$Longitude_deg,df4$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df5$Longitude_deg,df5$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df6$Longitude_deg,df6$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df7$Longitude_deg,df7$Latitude_deg, col = ('red'), lwd= 1.5) 
lines(df8$Longitude_deg,df8$Latitude_deg, col = ('red'), lwd= 1.5) 

#adding box around part Israel is interested in:
lines(extent(c(-77,-75.8,39.7,40.5)),lwd=3)

#adding airports
MTP <-points(-71.92333,41.07306, pch=21, col= "black", bg="white", lwd= 3)
JFK <-points(-73.76222,40.63861, pch=22, col="black", bg="white", lwd= 3)
SWF <-points(-74.10483,41.50411, pch=23, col="black", bg="white", lwd= 3)
WRI <-points(-74.59171,40.01558, pch=24, col="black", bg="white", lwd= 3)
BLM <-points(-74.13000,40.18000, pch=25, col="black", bg="white", lwd= 3)

#creating a legend
par(xpd = TRUE)
legend(x= -69.5,44,legend=c("SeaWolf Tracks","MTP", "JFK", "SWF", "WRI", "BLM"), 
       title = "Legend",  
       text.font= 4,
       col = c("red", "black", "black", "black", "black","black"), 
       pch = c( NA,21, 22, 23, 24, 25),
       lty= c(1, NA, NA, NA, NA, NA),
       cex= 0.8,
       pt.cex= 1,
       pt.lwd= 3,
       lwd= 1.5)

graphics.off()
#rm(list=ls()) = clear environment [just a reminder]




#Part three
##############
png("cruises_2_&_4-zoomed.png")
par(mar=c(5,4,4,2) + 0.1 + c(0,0,0,5))
plot(log10(Final), main= "SeaWolf Sea Tracks", xlab= "Longitude",
     ylab= "Latitude", xlim=c(-79, -70), ylim=c(37, 44),zlim=c(-2,3),legend=T, col=fields::tim.colors(),
     legend.width=.75, legend.shrink=0.75, horizontal = T,
     legend.args=list(text='CH4 (nmol/m2/s) log scale', side=1, font=2, line=2, cex=0.8))


library(rgdal)
states <- readOGR('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
states.p <- spTransform(states,CRSobj=CRS(projection(Final)))
lines(states.p,xlim=c(-78.5, -69.5), ylim=c(37.5, 43))

projection(states.p) # check again and double check it worked

#Cartographic Boundary files are a separate dataset produced by the US census bureau. 
#These are simplified areas that are a bit smaller than equivalent tigerline files might be and 
#also are not necessarily consistent year-to-year.  As such it can be a smoother/cleaner outline 
#for states/coastlines, but shouldn't be used for anything other than visuals.  #
#These are available at a variety of scales for similar divisions as tigerline files.  
#https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html

#adding  SeaWolf tracks
lines(df7$Longitude_deg,df7$Latitude_deg, col = ('orangered'), lwd= 2) 
lines(df5$Longitude_deg,df5$Latitude_deg, col = ('magenta'), lwd= 2, lty=4) 

#adding airports
MTP <-points(-71.92333,41.07306, pch=21, col= "black", bg="white", lwd= 3)
JFK <-points(-73.76222,40.63861, pch=22, col="black", bg="white", lwd= 3)
SWF <-points(-74.10483,41.50411, pch=23, col="black", bg="white", lwd= 3)
WRI <-points(-74.59171,40.01558, pch=24, col="black", bg="white", lwd= 3)
BLM <-points(-74.13000,40.18000, pch=25, col="black", bg="white", lwd= 3)


#add wind arrow-I am having trouble with this (how to make sure arrow is the perfect angle?)
#CRUISE 2 DAY WINDS- 2/23 = 257±25, 2/24= 25±29, 2/25= 283±27, 2/26= 260±25, 2/27=262±12
#CRUISE 4 DAY WINDS- 4/8 = 203±34, 4/9=270±9.5, 4/10=307±22, 4/11=190±15, 4/12=300±100, 
#                        = 4/13=153±18, 4/14=187±34, 4/15=190±23, 4/16=182±8.1
#SHOULD I USE AN ARROW VECTOR?
#winds2 <-arrows(x0 = -79,y0= 40,x1=-76,y1=41, code=2, length =.1, lwd =2, col = "orangered")
#winds4 <-arrows(x0 = -79,y0= 40,x1=-76,y1=41, code=2, length =.1, lwd =2, col = "magenta")

#creating a legend
par(xpd = TRUE)
legend(x= -69.5,44,legend=c("2/23-2/27","4/8-4/16", "MTP", "JFK", "SWF", "WRI", "BLM"), 
       title = "Legend",  
       text.font= 4,
       col = c("orangered","magenta", "black", "black", "black", "black","black"), 
       pch = c( NA, NA, 21, 22, 23, 24, 25),
       lty= c(1, 4, NA, NA, NA, NA, NA),
       cex= 0.8,
       pt.cex= 1,
       pt.lwd= 3,
       lwd= 2)

graphics.off()
#rm(list=ls()) = clear environment [just a reminder]
#cat("\f") clears console







