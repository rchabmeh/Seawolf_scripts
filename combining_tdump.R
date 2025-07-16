
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
directory <- rstudioapi::selectDirectory(caption = "select where to load tdump file from")
setwd(directory)

tdump_files= list.files(pattern=glob2rx("tdump?*.txt"), recursive = T, full.names = T)
sorted <- order(basename(tdump_files))
tdump_files <-(tdump_files[sorted])

i=1
Example_file=data.frame("","","","","","","","","","","","","")

colnames(Example_file) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                            "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                            "Latitude","Longitude","Height (m)","Pressure (mbar)")
while(i<=length(tdump_files)){
  Single_Example_file=suppressWarnings(read.table(tdump_files[i],header=F,skip=13))
  colnames(Single_Example_file) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                                     "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                                     "Latitude","Longitude","Height (m)","Pressure (mbar)")
  
  Example_file=suppressWarnings(rbind(Example_file[ ,c("Trajectory Number","Pressure Number","Year","Month","Day",
                                                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                                                       "Latitude","Longitude","Height (m)","Pressure (mbar)")],
                                      Single_Example_file[ ,c("Trajectory Number","Pressure Number","Year","Month","Day",
                                                              "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                                                              "Latitude","Longitude","Height (m)","Pressure (mbar)")]))
  #rbind(x,y) just adds y as new rows in x under the original data in x.
  cat("\rFinished Loading Example_file File",i,"of",length(tdump_files),"             ")
  #add a simple user update as it progresses.  \r = return line (start at the
  #beginning of the line, overwriting previous output)
  i=i+1
  
}
#combining tdump files
Example_file <- Example_file[-c(1), ]

Seawolf <-read.csv("/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 4 (4-5-22 to 4-16-22)/2022-04-07__2022-04-16_Seawolf_1hz.csv")

library(ggplot2)
library(sf)
library(sp)
library(terra)
try <- vect('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
states <- st_read('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')

plot(Example_file$Longitude,Example_file$Latitude,xlab = "Longitude", ylab="Latitude",
     main= "Back Trajectories in NAM: Cruise #4", sub= "[First day (4/9/22) only]", col = "red",
     xlim =c(-85,-72), ylim= c(38.5,42.5))

lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg)

#instead of combining into one file, maybe plot in each example file

#subsetting to 11.1m:  
traj_11m <- Example_file[Example_file$`Trajectory Number`==1, ]
plot(traj_11m$Longitude,traj_11m$Latitude,xlab = "Longitude", ylab="Latitude",
     main= "Back Trajectories in NAM: Cruise #4", sub= "[11.1 m only]", col = "red",
     xlim =c(-85,-72), ylim= c(38.5,42.5))
lines(states[ ,10], col = "gray")
lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg)