#WORKSHOP R FILE_______________________________________________________________#
#_______________________________tdump_plots.R__________________________________#
#______________________________________________________________________________#
library(paletteer)
colors = paletteer_c("grDevices::rainbow", n=length(trajectory1_list))
#"grDevices::Plasma" <- try that maybe? 
#"oompaBase::jetColors" <- or this? 
par(xpd = F, mar = c(5.5, 4, 3, 8), mgp = c(2, 0.5, 0), las = 1)
plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38.7,41), 
     xlab = "[Height at 11.1 m]", ylab="",
     main= "Back Trajectories in NAM: Cruise #4", border= "grey",
     axes=T, las = 1)
lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='grey4',lwd= "2")

for (j in 1:length(trajectory1_list)){
  par(xpd = F)
  lines(trajectory1_list[[j]][[11]],trajectory1_list[[j]][[10]], col= colors[j],lwd= "0.5", 
        type = "o", pch= 20, cex = .6)
}

k=1
legend_text <-c("SeaWolf Tracks")
while (k<=length(trajectory1_list)){
  date <- lapply(trajectory1_list[[k]][[14]][[1]], as.character)
  legend_text <- append(legend_text,c(date))
  k=k+1
} 

par(xpd = T)
legend("topright",legend=c(legend_text), 
       title = "Back trajectories",  
       inset=c(-.4,0),
       text.font=3,
       col = c("grey4",colors[1:length(trajectory1_list)]), 
       lty= 1,
       cex= 0.40,
       pt.cex= 1,
       pt.lwd= 3,
       lwd= 1.5,
       bg="aliceblue")


#______________________________TIME MATCHING______________________________________#
#Seawolf$DATE_TIME <- as.POSIXct(Seawolf$Time_UTC,tz="UTC",origin="1904-01-01")
# Seawolf <- na.omit(Seawolf)
# specific_times <- c("06:00:00", "12:00:00","18:00:00","23:00:00")
# 
# # Extract the time part from the datetime column
# time_only <- format(Seawolf$DATE_TIME, format = "%H:%M:%S")
# 
# # Subset the dataframe based on the specific times
# subset_df <- Seawolf[time_only %in% specific_times, ]
# 
# # Print the subset dataframe
# print(subset_df)
# subset_df$Longitude_deg <- round(subset_df$Longitude_deg, 3)
# subset_df$Latitude_deg <- round(subset_df$Latitude_deg, 3)
# 
# subset_df$w_dir[subset_df$w_dir == 0] <-360 #degrees
# 
# w_dir_rads <- subset_df$w_dir*(pi/180) #radians
# w_spd <- as.numeric(subset_df$w_spd)
# u <- w_spd * cos(w_dir_rads) * 0.1 #can normalize look up 
# v <- w_spd * sin(w_dir_rads) * 0.1
#______________________________________________________________________________#
# plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38.7,41), 
#      xlab = "[Height at 11.1 m]", ylab="",
#      main= "Back Trajectories in NAM: Cruise #4", border= "grey",
#      axes=T, las = 1)
# lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='grey4',lwd= "2")
# 
# arrows(subset_df$Longitude_deg, subset_df$Latitude_deg, 
#        subset_df$Longitude_deg + u, subset_df$Latitude_deg + v, 
#        length = 0.1, col = "blue", lwd = "1.5")
# 
# for (j in 1:length(trajectory1_list)){
#   par(xpd = F)
#   lines(trajectory1_list[[j]][[11]][1],trajectory1_list[[j]][[10]][1], col= colors[j], 
#         pch= 16, type = "p")
# }

#________________________LOCATION MATCHING______________________________________________#
lat_long=data.frame()
j=1
while (j <= length(trajectory1_list)){
lat_long_1<- c(trajectory1_list[[j]][[11]][1],trajectory1_list[[j]][[10]][1])
lat_long <- rbind(lat_long,lat_long_1)
j=j+1
}
 lat_long <- cbind(lat_long, "TEST" =1:26)
long_lat_seawolf <- data.frame(Seawolf$Longitude_deg,Seawolf$Latitude_deg)
long_lat_seawolf <-round(long_lat_seawolf,3)


Seawolf$Latitude_deg <- round(Seawolf$Latitude_deg, 3)
Seawolf$Longitude_deg <- round(Seawolf$Longitude_deg, 3)

testing <-merge(lat_long,Seawolf, by.x = c("X.73.845","X40.07"), by.y = c("Longitude_deg","Latitude_deg") , all=F)
testing <- na.omit(testing)

table(testing$TEST)

testing <- testing[!(testing$TEST %in% c(5,13,16,24)),  ]

testing$wdir_ptwise[testing$wdir_ptwise == 0] <-360 #degrees
w_dir_rads <- testing$wdir_ptwise*(pi/180) #radians
w_spd <- as.numeric(testing$wsp_ptwise)
testing$u <- w_spd * cos(w_dir_rads) * 0.1
testing$v <- w_spd * sin(w_dir_rads) * 0.1
testing<- aggregate(testing, by = list(testing$TEST), mean)

testing$w_dir_arrow_pointing <- atan2(testing$u,testing$v)/pi*180+360
testing$w_dir_arrow_pointing[testing$w_dir_arrow_pointing> 360] <- testing$w_dir_arrow_pointing[testing$w_dir_arrow_pointing> 360] -360
testing$w_dir_IGOR = testing$w_dir_arrow_pointing - 180
testing$w_dir_IGOR[testing$w_dir_IGOR< 0] <- testing$w_dir_IGOR[testing$w_dir_IGOR< 0] +360

plot(st_geometry((states)), xlim =c(-75,-73.5), ylim= c(38.7,41), 
     xlab = "[Height at 11.1 m]", ylab="",
     main= "Back Trajectories in NAM12: Cruise #4", border= "grey",
     axes=T, las = 1)
lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='grey4',lwd= "2")


par(xpd = F)
for (l in 1:length(trajectory1_list)){
  arrows(testing$X.73.845[l], 
       testing$X40.07[l], 
       testing$X.73.845[l] + testing$u[l], 
       testing$X40.07[l] + testing$v[l], 
       length = 0.1, col = "black", lwd = "2")
  }

for (j in 1:length(trajectory1_list)){
  par(xpd = F)
  lines(trajectory1_list[[j]][[11]][1],trajectory1_list[[j]][[10]][1], col= colors[j], 
        pch= 16, type = "p")
}


#It looks like the hysplit traj are a little off location wise (times do not align with Seawolf locations)
#However they're close but not an exact match
#Can see in previous plot of the by hour matching
#Grabbed info from the Seawolf at each lat/long trajectory within 3 decimal places (HYSPLIT seems to round to)
#Each trajectory coordinate had MANY MANY matches because of the rounding (some more than others)
#Seawolf is slowwwwwww that's why
#We grouped by trajectory and then we averaged within groups wind direction/speed for the groups that had under 260 observations
#The ones that had more than 260 observations we disregarded (as they had over 100,000 observations and could not be averaged to obtain an useful average wind direction/speed)
#we averaged u and v 







