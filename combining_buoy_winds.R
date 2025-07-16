#Buoy information:

if(length(find.package("rstudioapi",quiet = TRUE))<1){
  install.packages("rstudioapi")
  #install package rstudioapi quickly if it is not already installed.
  #Searches for it with find.package which is quiet so it won't 
  #fail if there is no such package.  Location folder is always 
  #length >1, so if it exists this will be skipped.
}

library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)
#choose and set where you save files to.  Alternatively in Rstudio go to the
#files tab and manually choose your working directory (navigate to
#folder->more->set as working directory)


#load in buoys_vs_airport_buoys.csv

Buoy_windsfiles= list.files(pattern=glob2rx('*.txt'))
order <- order(basename(Buoy_windsfiles))
Buoy_windsfiles <-Buoy_windsfiles[order]

Buoy_winds <- read.delim(Buoy_windsfiles[1], header = T, skip =1, sep = "")
Buoy_winds$Station <- substring(Buoy_windsfiles[1], 1,5)

i=2
while(i<=length(Buoy_windsfiles)){
  SingleBuoy_windsfile=read.delim(Buoy_windsfiles[i], header= T, skip= 1, sep = "")
  #read the files, save as singleAirport_windsfile, force classes based on the above
  SingleBuoy_windsfile$Station <- substring(Buoy_windsfiles[i], 1,5)
  
  Buoy_winds=rbind(Buoy_winds,SingleBuoy_windsfile)
  #rbind(x,y) just adds y as new rows in x under the original data in x.
  cat("\rFinished Loading Buoy_winds File",i,"of",length(Buoy_windsfiles),"             ")
  #add a simple user update as it progresses.  \r = return line (start at the
  #beginning of the line, overwriting previous output)
  i=i+1
}

#KEEPING COLUMNS WITH RELEVANT DATA ONLY
Buoy_winds <- Buoy_winds[, c(1:7,19)]
Buoy_winds <- Buoy_winds[!Buoy_winds$degT == 999, ]
Buoy_winds <- as.data.frame(Buoy_winds)
#TIME ADDED
Buoy_winds$Date <- paste(Buoy_winds$X.yr,Buoy_winds$mo, Buoy_winds$dy, sep = "-")
Buoy_winds$Date  = as.Date(Buoy_winds$Date)
Buoy_winds$Time = paste(Buoy_winds$hr,Buoy_winds$mn,sep= ":")
Buoy_winds$Date_Time <- paste(Buoy_winds$Date, Buoy_winds$Time, sep = " ")
Buoy_winds$Date_Time <- as.POSIXct(Buoy_winds$Date_Time, tz = "UTC")

Buoy_winds$Time = NULL
Buoy_winds$Date = NULL
Buoy_winds$X.yr = NULL
Buoy_winds$mo = NULL
Buoy_winds$dy = NULL
Buoy_winds$hr = NULL
Buoy_winds$mn = NULL

#adding lat/long info
buoys <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Wind data (airports, buoy, & MET)/buoys 2/buoys_vs_airport_buoys.csv')
station_info <- data.frame(buoys$Station, buoys$Longitude, buoys$Latitude)
colnames(station_info) <- c("Station", "Longitude","Latitude")

all_buoy_information <-merge(station_info,Buoy_winds, by = c("Station"),all=F)

airports <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Wind data (airports, buoy, & MET)/buoys 2/buoys_vs_airport_airports.csv')
setwd('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/towers in LI')
Tower_windsfiles= list.files(pattern=glob2rx('*.csv'))
order <- order(basename(Tower_windsfiles))
Tower_windsfiles <-Tower_windsfiles[order]
Tower_winds <- read.csv(Tower_windsfiles[1], header = T, sep = ",")
i=2
while(i<=length(Tower_windsfiles)){
  SingleTower_windsfile=read.csv(Tower_windsfiles[i], header= T, sep = ",")
  Tower_winds=rbind(Tower_winds,SingleTower_windsfile)
  cat("\rFinished Loading Tower_winds File",i,"of",length(Tower_windsfiles),"             ")
  i=i+1
}
tower_lat_lon <- data.frame(unique(Tower_winds$station),unique(Tower_winds$latitude..degrees_north.),unique(Tower_winds$longitude..degrees_east.))
Seawolf_cruise_14 <-read.csv("/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 4 (4-5-22 to 4-16-22)/2022-04-07__2022-04-16_Seawolf_1hz.csv")
Seawolf_cruise_14 <- Seawolf_cruise_14[!is.na(Seawolf_cruise_14$Latitude_deg), ]
library(ggplot2)
library(sf)
library(sp)
library(terra)
library(tmap)
states <- st_read('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
NEC_towers <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-01-30T15-24-2/mds2-2491/NEC_sites.csv')
cities <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major NE cities lat_long.csv')

par(xpd = F)
plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38,42), 
     xlab = "[Height at 11.1 m]", ylab="",
     main= "Cruise #4", border= "grey",
     axes=T, las = 1)
lines(Seawolf_cruise_14$Longitude_deg,Seawolf_cruise_14$Latitude_deg, col='grey4',lwd= "2")
points(buoys$Longitude,buoys$Latitude, col = "red",pch = 17)
points(airports$Longitude, airports$Latitude, col = "green", pch =15)
points(tower_lat_lon$unique.Tower_winds.longitude..degrees_east..,tower_lat_lon$unique.Tower_winds.latitude..degrees_north.., col = "blue", pch= 16)
points(NEC_towers$Lon, NEC_towers$Lat, col = "purple", pch= 16)
points(cities$Longitude, cities$Latitude, col = "black", pch = 18 )

legend("topleft",legend=c("cruise tracks","buoys","airports","MESONET towers", "NEC towers", "Major Cities"), 
       title = "Wind Receptors",  
       text.font=3,
       col = c("grey4","red","green","blue", "purple","black"), 
       lty= c(1,NA,NA,NA,NA,NA),
       lwd= 1.5,
       pch = c(NA,17,15,16,16,18),
       bg="aliceblue",
       cex = 0.5)



all_buoy_information$degT[all_buoy_information$degT == 0] <- 360
w_dir_rads <- all_buoy_information$degT*(pi/180) #radians
w_spd <- all_buoy_information$m.s
all_buoy_information$U <- -w_spd * sin(w_dir_rads) * 0.15
all_buoy_information$V <- -w_spd * cos(w_dir_rads) * 0.15


#filtering buoy information by cruise times- results in 290 obs________________#
all_buoy_information$Date <- as.Date(all_buoy_information$Date_Time)

buoy_firsthalf <- subset(all_buoy_information, Date > as.Date("2022-04-05") )
buoy_cruise <-  subset(buoy_firsthalf, Date < as.Date("2022-04-16") )

buoy_cruise$Date = NULL
buoy_firsthalf = NULL
buoys_filtered <- buoy_cruise

#_______________________ ______________________________________________________#
Seawolf_cruise_14$Date_Time <- as.POSIXct(Seawolf_cruise_14$Time_UTC,tz="UTC",origin="1904-01-01")
start_time <- min(buoy_cruise$Date_Time)
end_time <- max(buoy_cruise$Date_Time)
time_points <- seq(from = start_time, to = end_time, by = "6 hours")
buoys_filtered <- buoy_cruise[buoy_cruise$Date_Time %in% time_points, ]
Seawolf_filtered <- Seawolf_cruise_14[Seawolf_cruise_14$Date_Time %in% time_points, ]
#______________________________________________________________________________#

test <-buoys_filtered[order(as.Date(buoys_filtered$Date_Time)), ]
split_test <- split(test, f=test$Date_Time)
names <- names(split_test)

library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)

for (i in 1:length(split_test)){
  png(paste("test", i,".png", sep = "_"))
  par(xpd = F)
  plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38,42), 
       xlab = names[i], ylab="",
       main= "Winds from buoys", border= "grey",
       axes=T, las = 1)
  lines(Seawolf_cruise_14$Longitude_deg,Seawolf_cruise_14$Latitude_deg, col='grey4',lwd= "2")
  points(buoys$Longitude,buoys$Latitude,  col = "red",pch = 17)
arrows(split_test[[i]][[2]],
      split_test[[i]][[3]],
      split_test[[i]][[2]] + split_test[[i]][[7]], 
      split_test[[i]][[3]]+split_test[[i]][[8]], col = "darkred",length = 0.1, lwd= 1.5)
graphics.off()
}


#_____towers___________________________________________________________________#

library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load towers_winds files from")
setwd(directory)

Tower_windsfiles= list.files(pattern=glob2rx('*.csv'))
order <- order(basename(Tower_windsfiles))
Tower_windsfiles <-Tower_windsfiles[order]

Tower_winds <- read.csv(Tower_windsfiles[1], header = T, sep = ",")
i=2
while(i<=length(Tower_windsfiles)){
  SingleTower_windsfile=read.csv(Tower_windsfiles[i], header= T, sep = ",")
  Tower_winds=rbind(Tower_winds,SingleTower_windsfile)
  #rbind(x,y) just adds y as new rows in x under the original data in x.
  cat("\rFinished Loading Tower_winds File",i,"of",length(Tower_windsfiles),"             ")
  #add a simple user update as it progresses.  \r = return line (start at the
  #beginning of the line, overwriting previous output)
  i=i+1
}

Tower_winds$Date <- as.Date(Tower_winds$time)

Tower_firsthalf <- subset(Tower_winds, Date > as.Date("2022-04-05") )
Tower_cruise <-  subset(Tower_firsthalf, Date < as.Date("2022-04-16") )

Tower_cruise$Date = NULL
Tower_firsthalf = NULL
Tower_cruise$time <- as.POSIXct(Tower_cruise$time, tz = "UTC")


start_time <- min(Tower_cruise$time)
end_time <- max(Tower_cruise$time)
time_points <- seq(from = start_time, to = end_time, by = "6 hours")
Tower_filtered <- Tower_cruise[Tower_cruise$time %in% time_points, ]

#grab merged winds
Tower_filtered$wind_direction_merge..degrees.[Tower_filtered$wind_direction_merge..degrees. == 0] <- 360
w_dir_rads <- Tower_filtered$wind_direction_merge..degrees.*(pi/180) #radians
w_spd <- Tower_filtered$max_wind_speed_merge..m.s.
Tower_filtered$U <- -w_spd * sin(w_dir_rads) * 0.15
Tower_filtered$V <- -w_spd * cos(w_dir_rads) * 0.15


test2 <-Tower_filtered[order(as.Date(Tower_filtered$time)), ]
split_test2 <- split(test2, f=test2$time)
names2 <- names(split_test2)

#just towers
library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)

for (i in 1:length(split_test2)){
  png(paste("test2", i,".png", sep = "_"))
  par(xpd = F)
  plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(39,44), 
       xlab = names[i], ylab="",
       main= "Winds from towers", border= "grey",
       axes=T, las = 1)
  lines(Seawolf_cruise_14$Longitude_deg,Seawolf_cruise_14$Latitude_deg, col='grey4',lwd= "2")
  points(towers$longitude,towers$latitude, col = "blue", pch= 16)
  arrows(split_test2[[i]][[4]],
         split_test2[[i]][[3]],
         split_test2[[i]][[4]] + split_test2[[i]][[21]], 
         split_test2[[i]][[3]]+split_test2[[i]][[22]], col = "cyan",length = 0.1, lwd= 1.5)
  graphics.off()
}



#towers and buoys
library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)

for (i in 1:length(split_test2)){
  png(paste("test3", i,".png", sep = "_"))
  par(xpd = F)
  plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38,44), 
       xlab = names[i], ylab="",
       main= "Winds from towers", border= "grey",
       axes=T, las = 1)
  lines(Seawolf_cruise_14$Longitude_deg,Seawolf_cruise_14$Latitude_deg, col='grey4',lwd= "2")
  points(buoys$Longitude,buoys$Latitude,  col = "red",pch = 17)
  points(towers$longitude,towers$latitude, col = "blue", pch= 16)
  
  arrows(split_test2[[i]][[4]],
         split_test2[[i]][[3]],
         split_test2[[i]][[4]] + split_test2[[i]][[21]], 
         split_test2[[i]][[3]]+split_test2[[i]][[22]], col = "cyan",length = 0.1, lwd= 1.5)
  arrows(split_test[[i]][[2]],
         split_test[[i]][[3]],
         split_test[[i]][[2]] + split_test[[i]][[7]], 
         split_test[[i]][[3]]+split_test[[i]][[8]], col = "darkred",length = 0.1, lwd= 1.5)
  legend("topleft",legend=c("cruise tracks","buoys","towers","buoy trajectories", "tower trajectories"), 
         title = "Wind Receptors",  
         text.font=3,
         col = c("grey4","red","blue","darkred","cyan"), 
         lty= c(1,NA,NA,1,1),
         lwd= 1.5,
         pch = c(NA,17,16,NA,NA),
         bg="aliceblue",
         cex = 0.7)
   graphics.off()
}




#_______________________________AIRPORTS_______________________________________#
library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)

airport_info <- read.delim("Airport_winds-2022.txt")
airport_info$Date_Time <- paste(airport_info$Date_part,airport_info$Time_part, sep = " ")
airport_info$Date_Time <- as.POSIXct(airport_info$Date_Time, tz = "UTC", format= "%m/%d/%Y %H:%M%OS")
airport_info$Date <- as.Date(airport_info$Date_part, format = "%m/%d/%Y")



airport_info_1 <- subset(airport_info, Date > as.Date("2022-04-05") )
airport_cruise <-  subset(airport_info_1, Date < as.Date("2022-04-16") )

start_time3 <- min(airport_cruise$Date_Time)
end_time3 <- max(airport_cruise$Date_Time)
time_points <- seq(from = start_time3, to = end_time3, by = "6 hours")
airport_filtered <- airport_cruise[airport_cruise$Date_Time %in% time_points, ]



w_dir_rads <- airport_filtered$Wind_direction*(pi/180) #radians
w_spd <- airport_filtered$Wind_speed
airport_filtered$U <- -w_spd * sin(w_dir_rads) * 0.15
airport_filtered$V <- -w_spd * cos(w_dir_rads) * 0.15


test4 <-airport_filtered[order(as.Date(airport_filtered$Date_Time)), ]
split_test3 <- split(test4, f=test4$Date_Time)
names3 <- names(split_test3)



#just airports
library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)

for (i in 1:length(split_test3)){
  png(paste("test4", i,".png", sep = "_"))
  par(xpd = F)
  plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38,44), 
       xlab = names3[i], ylab="",
       main= "Winds from airports", border= "grey",
       axes=T, las = 1)
  lines(Seawolf_cruise_14$Longitude_deg,Seawolf_cruise_14$Latitude_deg, col='grey4',lwd= "2")
  points(airports$Longitude, airports$Latitude, col = "green", pch =15)
  arrows(split_test3[[i]][[2]],
         split_test3[[i]][[1]],
         split_test3[[i]][[2]] + split_test3[[i]][[10]], 
         split_test3[[i]][[1]]+split_test3[[i]][[11]], col = "darkgreen",length = 0.1, lwd= 1.5)
  graphics.off()
}


#all three 
library("rstudioapi")
#load rstudioapi into the current R session
print("A window should have opened in the background!",quote=FALSE)
directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
setwd(directory)

for (i in 1:length(split_test2)){
  png(paste("test5", i,".png", sep = "_"))
  par(xpd = F)
  plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38,44), 
       xlab = names[i], ylab="",
       main= "Winds from towers", border= "grey",
       axes=T, las = 1)
  lines(Seawolf_cruise_14$Longitude_deg,Seawolf_cruise_14$Latitude_deg, col='grey4',lwd= "2")
  points(buoys$Longitude,buoys$Latitude,  col = "red",pch = 17)
  points(towers$longitude,towers$latitude, col = "blue", pch= 16)
  points(airports$Longitude, airports$Latitude, col = "green", pch =15)
  arrows(split_test2[[i]][[4]],
         split_test2[[i]][[3]],
         split_test2[[i]][[4]] + split_test2[[i]][[21]], 
         split_test2[[i]][[3]]+split_test2[[i]][[22]], col = "cyan",length = 0.1, lwd= 1.5)
  arrows(split_test[[i]][[2]],
         split_test[[i]][[3]],
         split_test[[i]][[2]] + split_test[[i]][[7]], 
         split_test[[i]][[3]]+split_test[[i]][[8]], col = "darkred",length = 0.1, lwd= 1.5)
  points(airports$Longitude, airports$Latitude, col = "green", pch =15)
  arrows(split_test3[[i]][[2]],
         split_test3[[i]][[1]],
         split_test3[[i]][[2]] + split_test3[[i]][[10]], 
         split_test3[[i]][[1]]+split_test3[[i]][[11]], col = "darkgreen",length = 0.1, lwd= 1.5)
  legend("topleft",legend=c("cruise tracks","buoys","towers","buoy trajectories", "tower trajectories", "airport trajectories"), 
         title = "Wind Receptors",  
         text.font=3,
         col = c("grey4","red","blue","green", "darkred","cyan","darkgreen"), 
         lty= c(1,NA,NA,1,1,1),
         lwd= 1.5,
         pch = c(NA,17,16,15,NA,NA),
         bg="aliceblue",
         cex = 0.7)
  graphics.off()
}
