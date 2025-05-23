#tdump trajectory files 
#NAM-12 CRUISE #4
#THERE ARE 26 FILES TO READ
Seawolf <-read.csv("/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 4 (4-5-22 to 4-16-22)/2022-04-07__2022-04-16_Seawolf_1hz.csv")

library(ggplot2)
library(sf)
library(sp)
library(terra)
library(tmap)
states <- st_read('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')

#CRUISE DAY 1
Ap9_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-09-22/tdump/tdump.158692.txt',
                    skip =13, header = F)

colnames(Ap9_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                      "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                      "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap9_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-09-22/tdump/tdump.159091.txt',
                     skip =13, header = F)

colnames(Ap9_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap9_18h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-09-22/tdump/tdump.159183.txt',
                     skip =13, header = F)

colnames(Ap9_18h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap9_23h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-09-22/tdump/tdump.159275.txt',
                     skip =13, header = F)

colnames(Ap9_23h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj_9_6 <- Ap9_6h[Ap9_6h$`Trajectory Number`==1, ]
traj_9_12 <- Ap9_12h[Ap9_12h$`Trajectory Number`==1, ]
traj_9_18 <- Ap9_18h[Ap9_18h$`Trajectory Number`==1, ]
traj_9_23 <- Ap9_23h[Ap9_23h$`Trajectory Number`==1, ]


#Cruise DAY 2
Ap10_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-10-22/tdump/tdump.159413.txt',
                     skip =13, header = F)

colnames(Ap10_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap10_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-10-22/tdump/tdump.159481.txt',
                      skip =13, header = F)

colnames(Ap10_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap10_18h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-10-22/tdump/tdump.159543.txt',
                      skip =13, header = F)

colnames(Ap10_18h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap10_23h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-10-22/tdump/tdump.159624.txt',
                      skip =13, header = F)

colnames(Ap10_23h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj_10_6 <- Ap10_6h[Ap10_6h$`Trajectory Number`==1, ]
traj_10_12 <- Ap10_12h[Ap10_12h$`Trajectory Number`==1, ]
traj_10_18 <- Ap10_18h[Ap10_18h$`Trajectory Number`==1, ]
traj_10_23 <- Ap10_23h[Ap10_23h$`Trajectory Number`==1, ]


#CRUISE DAY 3
Ap11_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-11-22/tdump/tdump.159739.txt',
                     skip =13, header = F)

colnames(Ap11_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap11_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-11-22/tdump/tdump.159827.txt',
                      skip =13, header = F)

colnames(Ap11_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap11_18h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-11-22/tdump/tdump.159864.txt',
                      skip =13, header = F)

colnames(Ap11_18h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap11_23h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-11-22/tdump/tdump.159908.txt',
                      skip =13, header = F)

colnames(Ap11_23h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj_11_6 <- Ap11_6h[Ap11_6h$`Trajectory Number`==1, ]
traj_11_12 <- Ap11_12h[Ap11_12h$`Trajectory Number`==1, ]
traj_11_18 <- Ap11_18h[Ap11_18h$`Trajectory Number`==1, ]
traj_11_23 <- Ap11_23h[Ap11_23h$`Trajectory Number`==1, ]

#CRUISE DAY 4
Ap12_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-12-22/tdump/tdump.159995.txt',
                     skip =13, header = F)

colnames(Ap12_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap12_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-12-22/tdump/tdump.160033.txt',
                      skip =13, header = F)

colnames(Ap12_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap12_18h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-12-22/tdump/tdump.160101.txt',
                      skip =13, header = F)

colnames(Ap12_18h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap12_23h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-12-22/tdump/tdump.160192.txt',
                      skip =13, header = F)

colnames(Ap12_23h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj_12_6 <- Ap12_6h[Ap12_6h$`Trajectory Number`==1, ]
traj_12_12 <- Ap12_12h[Ap12_12h$`Trajectory Number`==1, ]
traj_12_18 <- Ap12_18h[Ap12_18h$`Trajectory Number`==1, ]
traj_12_23 <- Ap12_23h[Ap12_23h$`Trajectory Number`==1, ]


#CRUISE DAY 5
Ap13_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-13-22/tdump/tdump.163828.txt',
                     skip =13, header = F)

colnames(Ap13_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap13_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-13-22/tdump/tdump.164187.txt',
                      skip =13, header = F)

colnames(Ap13_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap13_18h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-13-22/tdump/tdump.164251.txt',
                      skip =13, header = F)

colnames(Ap13_18h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap13_23h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-13-22/tdump/tdump.164357.txt',
                      skip =13, header = F)

colnames(Ap13_23h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj_13_6 <- Ap13_6h[Ap13_6h$`Trajectory Number`==1, ]
traj_13_12 <- Ap13_12h[Ap13_12h$`Trajectory Number`==1, ]
traj_13_18 <- Ap13_18h[Ap13_18h$`Trajectory Number`==1, ]
traj_13_23 <- Ap13_23h[Ap13_23h$`Trajectory Number`==1, ]

#CRUISE DAY 6
Ap14_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-14-22/tdump/tdump.164484.txt',
                     skip =13, header = F)

colnames(Ap14_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap14_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-14-22/tdump/tdump.164603.txt',
                      skip =13, header = F)

colnames(Ap14_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap14_18h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-14-22/tdump/tdump.164645.txt',
                      skip =13, header = F)

colnames(Ap14_18h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap14_23h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-14-22/tdump/tdump.164753.txt',
                      skip =13, header = F)

colnames(Ap14_23h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj14_6 <- Ap14_6h[Ap14_6h$`Trajectory Number`==1, ]
traj14_12 <- Ap14_12h[Ap14_12h$`Trajectory Number`==1, ]
traj14_18 <- Ap14_18h[Ap14_18h$`Trajectory Number`==1, ]
traj14_23 <- Ap14_23h[Ap14_23h$`Trajectory Number`==1, ]

#CRUISE DAY 7
Ap15_6h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-15-22/tdump/tdump.164928.txt',
                     skip =13, header = F)

colnames(Ap15_6h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                       "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                       "Latitude","Longitude","Height (m)","Pressure (mbar)")

Ap15_12h <-read.table('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/back_traj_tests/CRUISE_4_attempt_2/04-15-22/tdump/tdump.165003.txt',
                      skip =13, header = F)

colnames(Ap15_12h) <- c("Trajectory Number","Pressure Number","Year","Month","Day",
                        "'Current' Hour","Not sure yet!","Trajectory Time (Forward)","Elapsed Time (Backwards)",
                        "Latitude","Longitude","Height (m)","Pressure (mbar)")

#number = 1 -> 11.1m
#number = 2 -> 100m
#number = 3 -> 300m
traj_15_6 <- Ap15_6h[Ap15_6h$`Trajectory Number`==1, ]
traj_15_12 <- Ap15_12h[Ap15_12h$`Trajectory Number`==1, ]

#PLOT TIME______________________________________________________
#adjust x/y min and maxes to fit data needs 

#box <- c( xmin = -90, ymin = 35, xmax = -73, ymax = 43)

#states_cropped <- st_crop(st_geometry(states),y= box)
#par(xpd = F)
#plot(states_cropped, axes = T,xlab = "Longitude", ylab="Latitude",
    # main= "Back Trajectories in NAM: Cruise #4", sub= "[Height at 300m]", border= "grey",
    # xlim = c(-80,-73))

par(xpd = F, mar = c(3, 4, 2, 2), mgp = c(2, 0.5, 0), las = 1)
plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38.7,41), xlab = "[Height at 11.1 m]", ylab="",
     main= "Back Trajectories in NAM: Cruise #4", border= "grey", axes=T, las = 1)

lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='black',lwd= "2")

#I want to add dots on each line for every hour backwards, each column has 25 data points
#0-24, so I can just do type="b" and that should work fine.
par(xpd = F)
lines(traj_9_6$Longitude,traj_9_6$Latitude, col= 'pink',lwd= "0.5", type = "o", pch= 20, cex = .6)
lines(traj_9_12$Longitude,traj_9_12$Latitude, col = "hotpink",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_9_18$Longitude,traj_9_18$Latitude, col = "deeppink",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_9_23$Longitude,traj_9_23$Latitude, col = "deeppink4",lwd= "0.5",  type = "o", pch= 20, cex = .6)

lines(traj_10_6$Longitude,traj_10_6$Latitude, col = "lightblue",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_10_12$Longitude,traj_10_12$Latitude, col = "cadetblue2",lwd= "0.5", type = "o", pch= 20, cex = .6)
lines(traj_10_18$Longitude,traj_10_18$Latitude, col = "darkturquoise",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_10_23$Longitude,traj_10_23$Latitude, col = "cadetblue",lwd= "0.5",  type = "o", pch= 20, cex = .6)

lines(traj_11_6$Longitude,traj_11_6$Latitude, col = "lightsalmon",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_11_12$Longitude,traj_11_12$Latitude, col = "lightsalmon2",lwd= "0.5", type = "o", pch= 20, cex = .6)
lines(traj_11_18$Longitude,traj_11_18$Latitude, col = "salmon2",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_11_23$Longitude,traj_11_23$Latitude, col = "sienna",lwd= "0.5",  type = "o", pch= 20, cex = .6)

lines(traj_12_6$Longitude,traj_12_6$Latitude, col = "springgreen",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_12_12$Longitude,traj_12_12$Latitude, col = "springgreen3",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_12_18$Longitude,traj_12_18$Latitude, col = "springgreen4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_12_23$Longitude,traj_12_23$Latitude, col = "darkgreen",lwd= "0.5",  type = "o", pch= 20, cex = .6)

lines(traj_13_6$Longitude,traj_13_6$Latitude, col = "gold",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_13_12$Longitude,traj_13_12$Latitude, col = "goldenrod",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_13_18$Longitude,traj_13_18$Latitude, col = "goldenrod4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_13_23$Longitude,traj_13_23$Latitude, col = "tan4",lwd= "0.5",  type = "o", pch= 20, cex = .6)

lines(traj14_6$Longitude,traj14_6$Latitude, col = "purple",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj14_12$Longitude,traj14_12$Latitude, col = "mediumorchid",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj14_18$Longitude,traj14_18$Latitude, col = "purple3",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj14_23$Longitude,traj14_23$Latitude, col = "purple4",lwd= "0.5",  type = "o", pch= 20, cex = .6)

lines(traj_15_6$Longitude,traj_15_6$Latitude, col = "red",lwd= "0.5",  type = "o", pch= 20, cex = .6)
lines(traj_15_12$Longitude,traj_15_12$Latitude, col = "darkred",lwd= "0.5",  type = "o", pch= 20, cex = .6)


par(xpd = T)
legend("right",legend=c("SeaWolf Tracks","4/9", "4/10", "4/11", "4/12","4/13","4/14", "4/15"), 
       title = "Back trajectories",  
       text.font=3,
       col = c("black", "hotpink2", "cadetblue3", "salmon", "springgreen","gold","purple","red"), 
       pch = c( NA,NA, NA, NA, NA,NA,NA,NA),
       lty= c(1, 1, 1, 1, 1, 1,1,1),
       cex= 0.60,
       pt.cex= 1,
       pt.lwd= 3,
       lwd= 1.5,
       bg="aliceblue")



#Figure with 2 plots________________________________________________________-

layout(matrix(c(1,2,3,3), ncol=2, byrow=TRUE), heights=c(4, 1))

par(mai=rep(0.5, 4))
    
    par(xpd = F, mar = c(3, 4, 2, 2), mgp = c(2, 0.5, 0), las = 1)
    plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38.7,41), xlab = "[Height at 11.1 m]", ylab="",
         main= "Zoomed Back Trajectories in NAM: Cruise #4", border= "grey", axes=T, las = 1)
    
    lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='black',lwd= "2")
    
    #I want to add dots on each line for every hour backwards, each column has 25 data points
    #0-24, so I can just do type="b" and that should work fine.
    par(xpd = F)
    lines(traj_9_6$Longitude,traj_9_6$Latitude, col= 'pink',lwd= "0.5", type = "o", pch= 20, cex = .6)
    lines(traj_9_12$Longitude,traj_9_12$Latitude, col = "hotpink",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_9_18$Longitude,traj_9_18$Latitude, col = "deeppink",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_9_23$Longitude,traj_9_23$Latitude, col = "deeppink4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_10_6$Longitude,traj_10_6$Latitude, col = "lightblue",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_10_12$Longitude,traj_10_12$Latitude, col = "cadetblue2",lwd= "0.5", type = "o", pch= 20, cex = .6)
    lines(traj_10_18$Longitude,traj_10_18$Latitude, col = "darkturquoise",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_10_23$Longitude,traj_10_23$Latitude, col = "cadetblue",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_11_6$Longitude,traj_11_6$Latitude, col = "lightsalmon",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_11_12$Longitude,traj_11_12$Latitude, col = "lightsalmon2",lwd= "0.5", type = "o", pch= 20, cex = .6)
    lines(traj_11_18$Longitude,traj_11_18$Latitude, col = "salmon2",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_11_23$Longitude,traj_11_23$Latitude, col = "sienna",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_12_6$Longitude,traj_12_6$Latitude, col = "springgreen",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_12_12$Longitude,traj_12_12$Latitude, col = "springgreen3",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_12_18$Longitude,traj_12_18$Latitude, col = "springgreen4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_12_23$Longitude,traj_12_23$Latitude, col = "darkgreen",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_13_6$Longitude,traj_13_6$Latitude, col = "gold",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_13_12$Longitude,traj_13_12$Latitude, col = "goldenrod",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_13_18$Longitude,traj_13_18$Latitude, col = "goldenrod4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_13_23$Longitude,traj_13_23$Latitude, col = "tan4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj14_6$Longitude,traj14_6$Latitude, col = "purple",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj14_12$Longitude,traj14_12$Latitude, col = "mediumorchid",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj14_18$Longitude,traj14_18$Latitude, col = "purple3",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj14_23$Longitude,traj14_23$Latitude, col = "purple4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_15_6$Longitude,traj_15_6$Latitude, col = "red",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_15_12$Longitude,traj_15_12$Latitude, col = "darkred",lwd= "0.5",  type = "o", pch= 20, cex = .6)
  
    
   par(xpd = F, mar = c(3, 4, 2, 2), mgp = c(2, 0.5, 0), las = 1)
    plot(st_geometry((states)), xlim =c(-88,-73.5), ylim= c(35,45), xlab = "[Height at 11.1 m]", ylab="",
         main= "Full Back Trajectories in NAM: Cruise #4", border= "grey", axes=T, las = 1)
    
    lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='black',lwd= "2")
    
    #I want to add dots on each line for every hour backwards, each column has 25 data points
    #0-24, so I can just do type="b" and that should work fine.
    par(xpd = F)
    lines(traj_9_6$Longitude,traj_9_6$Latitude, col= 'pink',lwd= "0.5", type = "o", pch= 20, cex = .6)
    lines(traj_9_12$Longitude,traj_9_12$Latitude, col = "hotpink",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_9_18$Longitude,traj_9_18$Latitude, col = "deeppink",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_9_23$Longitude,traj_9_23$Latitude, col = "deeppink4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_10_6$Longitude,traj_10_6$Latitude, col = "lightblue",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_10_12$Longitude,traj_10_12$Latitude, col = "cadetblue2",lwd= "0.5", type = "o", pch= 20, cex = .6)
    lines(traj_10_18$Longitude,traj_10_18$Latitude, col = "darkturquoise",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_10_23$Longitude,traj_10_23$Latitude, col = "cadetblue",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_11_6$Longitude,traj_11_6$Latitude, col = "lightsalmon",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_11_12$Longitude,traj_11_12$Latitude, col = "lightsalmon2",lwd= "0.5", type = "o", pch= 20, cex = .6)
    lines(traj_11_18$Longitude,traj_11_18$Latitude, col = "salmon2",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_11_23$Longitude,traj_11_23$Latitude, col = "sienna",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_12_6$Longitude,traj_12_6$Latitude, col = "springgreen",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_12_12$Longitude,traj_12_12$Latitude, col = "springgreen3",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_12_18$Longitude,traj_12_18$Latitude, col = "springgreen4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_12_23$Longitude,traj_12_23$Latitude, col = "darkgreen",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_13_6$Longitude,traj_13_6$Latitude, col = "gold",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_13_12$Longitude,traj_13_12$Latitude, col = "goldenrod",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_13_18$Longitude,traj_13_18$Latitude, col = "goldenrod4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_13_23$Longitude,traj_13_23$Latitude, col = "tan4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj14_6$Longitude,traj14_6$Latitude, col = "purple",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj14_12$Longitude,traj14_12$Latitude, col = "mediumorchid",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj14_18$Longitude,traj14_18$Latitude, col = "purple3",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj14_23$Longitude,traj14_23$Latitude, col = "purple4",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    lines(traj_15_6$Longitude,traj_15_6$Latitude, col = "red",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    lines(traj_15_12$Longitude,traj_15_12$Latitude, col = "darkred",lwd= "0.5",  type = "o", pch= 20, cex = .6)
    
    par(mai=c(0,0,0,0))
    plot.new()
    par(xpd = T)
    legend("center",legend=c("SeaWolf Tracks","4/9", "4/10", "4/11", "4/12","4/13","4/14", "4/15"), 
           title = "Dates",  
           text.font=3,
           ncol = 4,
           col = c("black", "hotpink2", "cadetblue3", "salmon", "springgreen","gold","purple","red"), 
           pch = c( NA,NA, NA, NA, NA,NA,NA,NA),
           lty= c(1, 1, 1, 1, 1, 1,1,1),
           cex= 0.75,
           pt.cex= 1,
           pt.lwd= 3,
           lwd= 1.5,
           bg="aliceblue")
