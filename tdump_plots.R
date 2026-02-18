#tdump trajectory files

#First, load in your cruise of interest and the states outline:

library(ggplot2)
library(sf)
library(sp)
library(terra)
library(tmap)

#Seawolf <-read.csv("PATH_TO_CRUISE_TRACKS.csv")
#Seawolf <-read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 24 (10 11 23-11 7 23)/1904-01-01__1904-01-01_Seawolf_1hz.csv')
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2021_us_state_500k/cb_2021_us_state_500k.shp")
#
# Seawolf <-read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 24 (10 11 23-11 7 23)/1904-01-01__1904-01-01_Seawolf_1hz.csv')
# Seawolf_lat_lon <- data.frame(Seawolf$Latitude_deg,Seawolf$Longitude_deg)
# colnames(Seawolf_lat_lon) <- c("Latitude_deg", "Longitude_deg")
# write.csv(Seawolf_lat_lon, '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 24 (10 11 23-11 7 23)/Seawolf_24_lat_lon')

Seawolf_lat_lon <- read.csv("/Users/reneechabot-mehlin/Downloads/2023-03-22__2023-04-19_Seawolf_1hz.csv")

directory <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/hrrr/c19"
#directory <- "/Users/reneechabot-mehlin/hysplit/working/cruise_4_hrrr_tdump_files"
setwd(directory)

#Get a vector of all filenames and read them one by one
#appending the trajectories to the list of trajectories.

tdump_files = list.files(
  pattern = glob2rx("tdump?*"),
  recursive = T,
  full.names = T
)
sorted <- order(basename(tdump_files))
tdump_files <- (tdump_files[sorted])

#all_trajectories_list <- list()
trajectory1_list <- list()
#trajectory2_list <- list()
#trajectory3_list <- list()
i = 1
while (i <= length(tdump_files)) {
  #skip 8 for nams
  #skip 16 for hrrr
  Single_Example_file = suppressWarnings(read.table(tdump_files[i], header =
                                                      F, skip = 16))
  colnames(Single_Example_file) <- c(
    "Trajectory Number",
    "Pressure Number",
    "Year",
    "Month",
    "Day",
    "Current_Hour",
    "Not sure yet!",
    "Trajectory Time (Forward)",
    "Elapsed Time (Backwards)",
    "Latitude",
    "Longitude",
    "Height (m)",
    "Pressure (mbar)"
  )
  Single_Example_file_traj1 <- Single_Example_file[Single_Example_file$`Trajectory Number` ==
                                                     1, ]
  Single_Example_file_traj1$Starting.Date.Time <- as.POSIXct(with(
    Single_Example_file_traj1,
    paste(Year, Month, Day, (Current_Hour), sep = "-")
  ), tz = "UTC", "%y-%m-%d-%H")
  print("Timezone is UTC.")
 #  Single_Example_file_traj1$Starting.Date.Time <- format(Single_Example_file_traj1$Starting.Date.Time,
 #                                                         tz = "America/New_York",
 #                                                         usetz = TRUE)
 # print("Timezone is America/New_York.")
  # Single_Example_file_traj2 <- Single_Example_file[Single_Example_file$`Trajectory Number`==2, ]
  # Single_Example_file_traj2$Starting.Date.Time <- as.POSIXct(with(Single_Example_file_traj2, paste(Year, Month,
  #                                                                                                  Day,Current_Hour, sep = "-")),
  #                                                            tz = "UTC", "%y-%m-%d-%H")
  # Single_Example_file_traj3 <- Single_Example_file[Single_Example_file$`Trajectory Number`==3, ]
  # Single_Example_file_traj3$Starting.Date.Time <- as.POSIXct(with(Single_Example_file_traj3, paste(Year, Month,
  #                                                                                                  Day,Current_Hour, sep = "-")),
  #                                                            tz = "UTC", "%y-%m-%d-%H")
  # all_trajectories_list <- append(all_trajectories_list, c(list(Single_Example_file_traj1),list(Single_Example_file_traj2), list(Single_Example_file_traj3)))
  #
  trajectory1_list <- append(trajectory1_list, list(Single_Example_file_traj1))
  # trajectory2_list <- append(trajectory2_list, list(Single_Example_file_traj2))
  # trajectory3_list <- append(trajectory3_list, list(Single_Example_file_traj3))
  
  i = i + 1
}
#______________________________________________________________________________#
# trajectory_distances = list()
# j=1
# library(geosphere)
# while (j <= length(tdump_files)){
#   distances<-distm(c(trajectory1_list[[j]][[11]][[1]],trajectory1_list[[j]][[10]][[1]]), c(trajectory1_list[[j+1]][[11]][[1]],trajectory1_list[[j+1]][[10]][[1]]), fun = distHaversine)
#   trajectory_distances <- append(trajectory_distances, list(distances))
#   j=j+1
# }
#
# avg_m_btwn_receptors <- mean(unlist(trajectory_distances))
# std_btwn_receptors <- sd(unlist(trajectory_distances))
# print(avg_m_btwn_receptors)
# print(std_btwn_receptors)
#______________________________________________________________________________#
#PLOTTING:
#______________________________________________________________________________#
# library(paletteer)
# colors = paletteer_c("grDevices::rainbow", n=length(trajectory1_list))
# #"grDevices::Plasma" <- try that maybe?
# #"oompaBase::jetColors" <- or this?
# #jpeg("/Users/reneechabot-mehlin/Desktop/Seawolf/24/trajectory_hrrr.jpeg")
# #par(xpd = F, mar = c(5.5, 4, 3, 10), mgp = c(2, 0.5, 0), las = 1)
# #make sure you change main for NAM or HRRR
# plot(st_geometry((states)), xlim =c(-76,-70), ylim= c(38,42),
#      xlab = "", ylab="",
#      main= "Back Trajectories in HRRR: Cruise #24", border= "grey",
#      axes=T, las = 1)
# lines(Seawolf_lat_lon$Seawolf.Longitude_deg,Seawolf_lat_lon$Seawolf.Latitude_deg, col='grey4',lwd= "2")
# #lines(Seawolf$longitude_deg,Seawolf$latitude_deg, col='grey4',lwd= "2")
# #text(-71.5,38,'577/600 receptors plotted- will fix ASAP', cex = 0.8)
# j=517
# while (j <= 535){
#   par(xpd = F)
#   lines(trajectory1_list[[j]][[11]],trajectory1_list[[j]][[10]], col= colors[j],lwd= "0.5",
#         type = "o", pch= 20, cex=0.6)
#   j=j+1
# }
#________________________________________________________________________________
#Setting everything up
cities <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major NE cities lat_long.csv'
)
landfills <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Lat_Lon_Locations-landfills.csv'
)
powerplants <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Lat_Lon_Locations-powerplants.csv'
)
setwd(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/towers in LI'
)
Tower_windsfiles = list.files(pattern = glob2rx('*.csv'))
order <- order(basename(Tower_windsfiles))
Tower_windsfiles <- Tower_windsfiles[order]
Tower_winds <- read.csv(Tower_windsfiles[1], header = T, sep = ",")
i = 2
while (i <= length(Tower_windsfiles)) {
  SingleTower_windsfile = read.csv(Tower_windsfiles[i], header = T, sep = ",")
  Tower_winds = rbind(Tower_winds, SingleTower_windsfile)
  cat("\rFinished Loading Tower_winds File",
      i,
      "of",
      length(Tower_windsfiles),
      "             ")
  i = i + 1
}
tower_lat_lon <- data.frame(
  unique(Tower_winds$station),
  unique(Tower_winds$latitude..degrees_north.),
  unique(Tower_winds$longitude..degrees_east.)
)
NEC_towers <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-01-30T15-24-2/mds2-2491/NEC_sites.csv'
)
trainline <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /MTA_LIRR_Branches.csv'
)
train_tracks <- st_as_sfc(trainline$the_geom, crs = 4326)

states <- st_transform(states, crs = 4326)
#Plotting tracks and trajectories
library(paletteer)
colors <- as.character(paletteer_c("grDevices::rainbow", n = length(trajectory1_list)))
plot(
  st_geometry((states)),
  xlim = c(-78, -70),
  ylim = c(38, 42),
  xlab = "",
  ylab = "",
  main = "Potential Sources of GHGs",
  border = "grey",
  axes = T,
  las = 1,
  asp = 1
)
lines(
  Seawolf_lat_lon$Longitude_deg,
  Seawolf_lat_lon$Latitude_deg,
  col = 'grey4',
  lwd = 2
)
for (i in 1:length(trajectory1_list)) {
  lon <- trajectory1_list[[i]][[11]]
  lat <- trajectory1_list[[i]][[10]]
  
  #print(paste("i =", i, "length(lon) =", length(lon), "length(lat) =", length(lat)))
  
  #if (all(is.finite(lon)) && all(is.finite(lat)) && length(lon) > 1) {
   lines(lon, lat, col = colors[i], lwd = 0.5, type = "o", pch = 20, cex = 0.6)
  #  points(lon[1],lat[1], col = colors[i],pch = 20)
 # } else {
  #  message("Skipped trajectory ", i)
 # }
}

indices <- 227:233 #55:62, 130:136, 227:233
colors  <- as.character(paletteer_c("grDevices::rainbow", n = length(indices)))
plot(
  st_geometry((states)),
  xlim = c(-78, -70),
  ylim = c(38, 42),
  xlab = "",
  ylab = "",
  main = "Potential Sources of GHGs",
  border = "grey",
  axes = T,
  las = 1,
  asp = 1
)
for (j in seq_along(indices)) {
  i <- indices[j]
  
  lon <- trajectory1_list[[i]][[11]]
  lat <- trajectory1_list[[i]][[10]]
  
  lines(lon, lat,
        col = colors[j],
        lwd = 0.5,
        type = "o",
        pch = 20,
        cex = 0.6)
}


#plot(st_geometry(train_tracks), col = "blue", lwd = 2, add = TRUE)

#Plotting cities
library(paletteer)
colors2 = paletteer_d("ggthemes::calc", n = length(cities$Longitude))
for (j in 1:length(cities$Longitude)) {
  par(xpd = F)
  points(
    cities$Longitude[j],
    cities$Latitude[j],
    col = "black",
    bg = colors2[j],
    pch = 22,
    cex = 1.5
  )
}
#Plotting landfills
library(paletteer)
colors3 = paletteer_d("tvthemes::EarthKingdom", n = length(landfills$Longitude))
for (j in 1:length(landfills$Longitude)) {
  par(xpd = F)
  points(
    landfills$Longitude[j],
    landfills$Latitude[j],
    col = "black",
    bg = colors3[j],
    pch = 24,
    cex = 1.5
  )
}
#Plotting powerplants
library(paletteer)
colors6 = paletteer_d("tvthemes::WaterTribe", n = length(powerplants$Longitude))
for (j in 1:length(landfills$Longitude)) {
  par(xpd = F)
  points(
    powerplants$Longitude[j],
    powerplants$Latitude[j],
    col = "black",
    bg = colors6[j],
    pch = 25,
    cex = 1.5
  )
}
#Plotting towers
library(paletteer)
colors4 = paletteer_d("tvthemes::FireNation",
                      n = length(tower_lat_lon$unique.Tower_winds.station.))
for (j in 1:length(tower_lat_lon$unique.Tower_winds.station.)) {
  par(xpd = F)
  points(
    tower_lat_lon$unique.Tower_winds.longitude..degrees_east..[j],
    tower_lat_lon$unique.Tower_winds.latitude..degrees_north..[j],
    col = "black",
    bg = colors4[j],
    pch = 21,
    cex = 1.5
  )
}
colors5 = paletteer_c("ggthemes::Sunset-Sunrise Diverging",
                      n = length(NEC_towers$SiteCode))
for (j in 1:length(NEC_towers$SiteCode)) {
  par(xpd = F)
  points(
    NEC_towers$Lon[j],
    NEC_towers$Lat[j],
    col = "black",
    bg = colors5[j],
    pch = 23,
    cex = 1.5
  )
}
#Plotting legends----
#Trajectories Legend
k = 83
legend_text2 <- c("SeaWolf Tracks")
while (k <= 89) {
  date <- lapply(trajectory1_list[[k]][[14]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
  k = k + 1
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 8",
  text.font = 3,
  col = c("grey4", colors[1:7]),
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)

#Cities Legend
k = 2
legend_text <- cities$City[1]
while (k <= length(cities$Longitude)) {
  cities2 <- cities$City[k]
  legend_text <- append(legend_text, c(cities2))
  k = k + 1
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text),
  title = "Cities",
  text.font = 3,
  col = "black",
  pt.bg = colors2[1:length(cities$City)],
  pch = 22,
  ncol = 2,
  bg = "aliceblue"
)

#Landfill Legend
legend_text <- landfills$Name
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text),
  title = "Landfills",
  bg = "aliceblue",
  col = "black",
  pt.bg = colors3[1:length(landfills$Longitude)],
  pch = 24,
  cex = 0.8
)

#Power Plants Legend
legend_text <- powerplants$Name
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text),
  title = "Power Plants",
  bg = "aliceblue",
  col = "black",
  pt.bg = colors6[1:length(powerplants$Longitude)],
  pch = 25,
  cex = 0.8
)

#Long Island Towers Legend
legend_text <- tower_lat_lon$unique.Tower_winds.station.
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text),
  title = "NYS Mesonet Data",
  bg = "aliceblue",
  col = "black",
  pt.bg = colors4[1:length(tower_lat_lon$unique.Tower_winds.station.)],
  pch = 21
)

#NEC Towers Legend
legend_text <- NEC_towers$SiteCode
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text),
  bg = "aliceblue",
  title = "NEC Tower Network",
  col = colors5[1:length(NEC_towers$SiteCode)],
  pt.bg = colors5[1:length(NEC_towers$SiteCode)],
  ncol = 4,
  pch = 23
)
#_____________________
#Adding VULCAN 3.0
library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(fields)
library(ggplot2) # package for plotting
raster_data <- raster(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/Vulcan_V3_Annual_Emissions_1741/data/Vulcan_v3_US_annual_1km_total_mn.nc4',
  band = 6
)
new_crs <- CRS("+proj=longlat +datum=WGS84")
raster_reproject <- projectRaster(raster_data, crs = new_crs)

library(sf)
states <- st_read(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp'
)
states_sf <- st_as_sf(states)
states_transformed <- st_transform(states_sf, crs = "EPSG:4326")

library(viridis)
library(maps)
#from Mg*km2/yr C to mol*m2/sec CO2
raster_grams <- raster_reproject * 1000000
raster_moles <- raster_grams / 12.01 #C:CO2 1:1 ratio
raster_m2 <- raster_moles * 1000000
raster_secs <- 31556952 * raster_m2

epsilon <- 1e-6
plot(
  log10(raster_secs + epsilon),
  main = "Vulcan v3.0 CO2 Emissions 2015",
  xlab = "Longitude",
  ylab = "Latitude",
  asp = NA,
  xlim = c(-80, -70),
  ylim = c(38, 42),
  col = fields::tim.colors(),
  legend.args = list(text = "log10(mol m2/sec) CO2"),
  zlim = c(18, 23.5)
)
lines(states_transformed)

#_Adding EDGAR
#this is to make sure they have the right info inside
r <- raster(
  "~/Google Drive/My Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/EDGAR_yearly_inventory/EDGAR_v7.0_TOTAL_1970-2021_nc/v7.0_FT2021_CH4_2021_TOTALS.0.1x0.1.nc"
)
#this works for pulling things from an .nc file, but doesn't need to be this complicated!
#change longitude from 0-360 to -180-180 (https://gis.stackexchange.com/questions/284224/convert-over-360-degree-range-of-coordinates-to-180-longitude-range-in-r/284228#284228)
Eastern <- extent(c(
  xmin = 0,
  xmax = 180,
  ymin = -90,
  ymax = 90
))
Western <- extent(c(
  xmin = 180,
  xmax = 360,
  ymin = -90,
  ymax = 90
))
r1 <- crop(r, Eastern)
r2 <- crop(r, Western)
xmin(r2) <- xmin(r2) - 360
xmax(r2) <- xmax(r2) - 360
R <- merge(r1, r2)
# convert the units to nmol/m2/s as units are in kg ch4/m2/s
K <-  1000 * (1 / 16.04) * (1 * 10^9)
Final <- R * K
library(sf)
states <- st_read(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp'
)
states_sf <- st_as_sf(states)
states_transformed <- st_transform(states_sf, crs = "EPSG:4326")
#Plot emissions
par(mar = c(2, 2, 1, 1))
plot(
  log10(Final),
  main = 'EDGAR CH4 total emissions 2021',
  xlab = "longitude",
  ylab = "latitude",
  col = fields::tim.colors(),
  xlim = c(-80, -70),
  ylim = c(38, 42),
  zlim= c(-0.75,2.75),
  legend.width = .75,
  legend.shrink = 0.75,
  horizontal = T,
  legend.args = list(
    text = 'CH4 (nmol/m2/s) log scale',
    side = 1,
    font = 2,
    line = 2,
    cex = 0.8
  ),
  asp = NA
)
lines(states_transformed)

#_________
#Adding Kris's inventory
kris_inventory <- sum(
  brick(
    '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Kris/Conferences/AGU/2024/mean_across_ensemble.nc'
  )
)
K_inventory <- projectRaster(kris_inventory, crs = new_crs)
K_inventory_log10 <- log10(K_inventory + epsilon)
library(sf)
states <- st_read(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp'
)
states_sf <- st_as_sf(states)
states_transformed <- st_transform(states_sf, crs = "EPSG:4326")
plot(
  K_inventory_log10,
  xlim = c(-78, -70),
  ylim = c(39, 42),
  zlim = c(0.2,2.2),
  col = fields::tim.colors(),
  main = "Kris's Inventory"
  ,
  xlab = "Longitude",
  ylab = "Latitude",
  asp = NA,
  legend.args = list(text = "log10(nmol m2/sec) CH4")
)
lines(states_transformed)

# Optionally, add custom text to the color legend
# Here we manually add text labels at key positions
# #________
# j=100
# while (j <= 150){
#   par(xpd = F)
#   lines(trajectory1_list[[j]][[11]][[1]],trajectory1_list[[j]][[10]][[1]], col= colors[j],lwd= "0.5",
#         type = "o", pch= 20, cex=0.6)
#   j=j+1
# }
# j=515
# while (j <= 536){
#   par(xpd = F)
#   lines(trajectory1_list[[j]][[11]][[1]],trajectory1_list[[j]][[10]][[1]], col= colors[j],lwd= "0.5",
#         type = "o", pch= 19)
#   j=j+1
# }
# # for (j in 1:length(trajectory1_list)){
# #   par(xpd = F)
# #   lines(trajectory1_list[[j]][[11]],trajectory1_list[[j]][[10]], col= colors[j],lwd= "0.5",
# #         type = "o", pch= 20, cex = .6)
# # }
# #dev.off()
# cities <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major NE cities lat_long.csv')
# library(paletteer)
# colors2 = paletteer_c("grDevices::Plasma", n=length(cities$Longitude))
# for (j in 1:length(cities$Longitude)){
#   par(xpd = F)
#   points(cities$Longitude[j],cities$Latitude[j], col = "black", bg = colors2[j], pch = 24, cex=.6)
# }
#
# k=2
# legend_text <- cities$City[1]
# while(k<= length(cities$Longitude)){
#   cities2 <-cities$City[k]
#   legend_text <-append(legend_text, c(cities2))
#   k=k+1
# }
#
# legend("right", legend=c(legend_text),
#        bg = "aliceblue",
#        col = "black",
#        pt.bg=colors2[1:length(cities$Longitude)],
#        pch =24)
# #______
# k=1
# legend_text2 <-c("SeaWolf Tracks")
# while (k<=length(trajectory1_list)){
#   date <- lapply(trajectory1_list[[k]][[14]][[1]], as.character)
#   legend_text2 <- append(legend_text2,c(date))
#   k=k+1
# }
# plot.new()
# par(xpd = T)
# legend("center",legend=c(legend_text2),
#        title = "Back trajectories",
#       # inset=c(-1.2,-1),
#        text.font=3,
#        col = c("grey4",colors[1:length(trajectory1_list)]),
#        lty= 1,
#        ncol=6,
#        cex= 0.25,
#        pt.cex= 1,
#        pt.lwd= 3,
#        lwd= 1.5,
#        bg="aliceblue")

# k=517
# legend_text2 <-c("SeaWolf Tracks")
# while (k<=535){
#   date <- lapply(trajectory1_list[[k]][[14]][[1]], as.character)
#   legend_text2 <- append(legend_text2,c(date))
#   k=k+1
# }
# plot.new()
# par(xpd = T)
# legend("bottomright",legend=c(legend_text2),
#        title = "Dates-Cruise 24",
#        text.font=3,
#        col = c("grey4",colors[1:18]),
#        lty= 1,
#        ncol=3,
#        cex= .4,
#        pt.cex= 3,
#        pt.lwd= 3,
#        lwd= 3,
#        bg="aliceblue")
#dev.off()
#______________________________________________________________________________#

# #Figure with 2 plots___________________________________________________________#
#
# library(paletteer)
# colors = paletteer_c("ggthemes::Orange-Blue-White Diverging", n=length(trajectory1_list))
#
# layout(matrix(c(1,2,3,3), ncol=2, byrow=TRUE), heights=c(4, 1))
# par(mai=rep(0.5, 4))
#
# par(xpd = F, mar = c(3, 4, 2, 2), mgp = c(2, 0.5, 0), las = 1)
# plot(st_geometry((states)), xlim =c(-73.2,-72.8), ylim= c(40.9,41.3),
#      xlab = "[Height at 11.1 m]", ylab="",
#      main= "Back Trajectories in NAM: Cruise #17", border= "grey",
#      axes=T, las = 1)
# lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='grey4',lwd= "2")
#
# for (j in 1:length(trajectory1_list)){
#   par(xpd = F)
#   lines(trajectory1_list[[j]][[11]],trajectory1_list[[j]][[10]], col= colors[j],lwd= "0.5",
#         type = "o", pch= 20, cex = .6)
# }
#
# par(xpd = F, mar = c(3, 4, 2, 2), mgp = c(2, 0.5, 0), las = 1)
# plot(st_geometry((states)), xlim =c(-78,-73.5), ylim= c(38,42),
#      xlab = "[Height at 11.1 m]", ylab="",
#      main= "Full Back Trajectories (NAM)",
#      border= "grey", axes=T, las = 1)
#
# lines(Seawolf$Longitude_deg,Seawolf$Latitude_deg, col='grey4',lwd= "2")
#
# for (j in 1:length(trajectory1_list)){
#   par(xpd = F)
#   lines(trajectory1_list[[j]][[11]],trajectory1_list[[j]][[10]], col= colors[j],lwd= "0.5",
#         type = "o", pch= 20, cex = .6)
# }
#
#
# k=1
# legend_text <-c("SeaWolf Tracks")
# while (k<=length(trajectory1_list)){
#   date <- lapply(trajectory1_list[[k]][[14]][[1]], as.character)
#   legend_text <- append(legend_text,c(date))
#   k=k+1
# }
# par(mai=c(0,0,0,0))
# plot.new()
# par(xpd = T)
# legend("center",legend=c(legend_text),
#        title = "Back trajectories",
#        ncol = 10,
#        text.font=3,
#        col = c("grey4",colors[1:length(trajectory1_list)]),
#        lty= 1,
#        cex= 0.20,
#        pt.cex= 1,
#        pt.lwd= 3,
#        lwd= 1.5,
#        bg="aliceblue")
#
#
#
#
#
#
#
# jpeg("/Users/reneechabot-mehlin/Desktop/Seawolf/Cities.jpeg")
#
# plot(st_geometry((states)), xlim =c(-80,-65), ylim= c(38,42),
#      xlab = "", ylab="",
#      main= "Cities", border= "grey",
#      axes=T, las = 1)
#
# cities <- read.csv("/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major_NE_cities_lat_long.csv")
# library(paletteer)
# colors2 = paletteer_c("grDevices::Plasma", n=length(cities$Longitude))
# for (j in 1:length(cities$Longitude)){
#   par(xpd = F)
#   points(cities$Longitude[j],cities$Latitude[j], col = "black", bg = colors2[j], pch = 24, cex = 1)
# }
# k=2
# legend_text <- cities$City[1]
# while(k<= length(cities$Longitude)){
#   cities2 <-cities$City[k]
#   legend_text <-append(legend_text, c(cities2))
#   k=k+1
# }
#
# legend("topright", legend=c(legend_text), col = "black",pt.bg=colors2[1:length(cities$Longitude)],pch =24, cex = .8)
# dev.off()
#
#
#
#



pdf("/Users/reneechabot-mehlin/Desktop/Seawolf/04/hrrr_w_cities.pdf")
#jpeg("/Users/reneechabot-mehlin/Desktop/Seawolf/02/hrrr_w_cities.jpeg")
par(mar = c(5, 4, 4, 16)) # Increase right margin
plot(
  st_geometry((states)),
  xlim = c(-78, -72),
  ylim = c(38, 42),
  xlab = "[Height at 11.1 m]",
  ylab = "",
  main = "Back Trajectories in HRRR: Cruise #4",
  border = "black",
  axes = T,
  las = 1,
  col = "lightgrey",
  bg = "lightblue"
)
cities <- read.csv(
  "/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major_NE_cities_lat_long.csv"
)
library(paletteer)
#colors2 = rainbow(n=length(cities$Longitude))
colors2 = paletteer_d("ggsci::category10_d3", n = length(cities$Longitude))
for (j in 1:length(cities$Longitude)) {
  par(xpd = F)
  points(
    cities$Longitude[j],
    cities$Latitude[j],
    col = "darkgrey",
    bg = colors2[j],
    pch = 24,
    cex = 2
  )
}

lines(Seawolf$Longitude_deg,
      Seawolf$Latitude_deg,
      col = 'grey4',
      lwd = "2")
#lines(Seawolf$longitude_deg,Seawolf$latitude_deg, col='grey4',lwd= "2")
#text(-72,38,'252/278 receptors plotted', cex = 0.8)
colors = paletteer_c("ggthemes::Orange-Blue Diverging", n = length(trajectory1_list))
for (j in 1:length(trajectory1_list)) {
  par(xpd = F)
  lines(
    trajectory1_list[[j]][[11]],
    trajectory1_list[[j]][[10]],
    col = colors[j],
    lwd = "0.5",
    type = "o",
    pch = 20,
    cex = .6
  )
}

k = 2
legend_text <- cities$City[1]
while (k <= length(cities$Longitude)) {
  cities2 <- cities$City[k]
  legend_text <- append(legend_text, c(cities2))
  k = k + 1
}
par(xpd = T)
legend(
  "topright",
  legend = c(legend_text),
  bg = "white",
  col = "black",
  pt.bg = colors2[1:length(cities$Longitude)],
  pch = 24,
  cex = .7,
  ncol = 3,
  inset = c(-1.08, 0)
)

legend_text2 <- c("SeaWolf Tracks")
while (k <= length(trajectory1_list)) {
  date <- lapply(trajectory1_list[[k]][[14]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
  k = k + 1
}

par(xpd = T)
legend(
  "bottomright",
  legend = c(legend_text2),
  title = "Back trajectories",
  inset = c(-1.05, 0),
  text.font = 3,
  col = c("grey4", colors[1:length(trajectory1_list)]),
  lty = 1,
  ncol = 4,
  cex = .35,
  pt.cex = 1,
  pt.lwd = 3,
  lwd = 2,
  bg = "white"
)
dev.off()

#
# jpeg("/Users/reneechabot-mehlin/Desktop/Seawolf/Cities.jpeg")
# plot(st_geometry((states)), xlim =c(-78,-72), ylim= c(38,42),
#      xlab = "[Height at 11.1 m]", ylab="",
#      main= "Cities", border= "black",
#      axes=T, las = 1, col="lightgrey",bg="lightblue")
# cities <- read.csv("/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major_NE_cities_lat_long.csv")
# library(paletteer)
# #colors2 = rainbow(n=length(cities$Longitude))
# colors2 = paletteer_d("ggsci::category10_d3", n=length(cities$Longitude))
# for (j in 1:length(cities$Longitude)){
#   par(xpd = F)
#   points(cities$Longitude[j],cities$Latitude[j], col = "darkgrey",
#          bg = colors2[j], pch = 24, cex = 2)
# }
# k=2
# legend_text <- cities$City[1]
# while(k<= length(cities$Longitude)){
#   cities2 <-cities$City[k]
#   legend_text <-append(legend_text, c(cities2))
#   k=k+1
# }
# par(xpd = T)
# legend("bottomright", legend=c(legend_text),
#        bg = "white",col = "black",pt.bg=colors2[1:length(cities$Longitude)],pch =24,
#        cex = .7, ncol=2)
# dev.off()
#



STON <- Tower_winds[Tower_winds$station == "STON", ]
STON$time = strptime(STON$time, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
STON$time <- with_tz(STON$time, tz = "America/New_York", format = "%Y-%m-%d %H:%M:%S")
STON <- STON[STON$time >= "2023-11-04 00:00:00", ]
STON <- STON[STON$time <= "2023-11-04 14:00:00", ]

plot(
  STON$time,
  STON$wind_direction_merge..degrees.,
  xlab = "Time (EST)",
  ylab = "Wind Direction",
  type = "p",
  pch = 20,
  col = "black",
  main = "STON Tower"
)
abline(h = 180, col = "red", lwd = 2)
abline(h = 270, col = "red", lwd = 2)