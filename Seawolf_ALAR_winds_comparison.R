##Adding ALAR flight comparison info______####
ALAR <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2025_Flights/WINDS_TEST/7-2-25/2025-07-02_ALAR_1hz.csv'
)
ALAR$Time_local <- as.POSIXct(ALAR$Time_local, origin = "1904-01-01", tz = "America/New_York")
ALAR$Time_UTC <- as.POSIXct(ALAR$Time_UTC, origin = "1904-01-01", tz = "UTC")

library(openair)
colnames(ALAR)[colnames(ALAR) == "Time_UTC"] <- "date"

ALAR_5min <- timeAverage(ALAR,
                         avg.time = "5 min",
                         data.thresh = 0,
                         statistic = "mean")

wind_speed <- ALAR_5min$w_spd
wind_dir <- ALAR_5min$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- ALAR_5min$Longitude_deg
lat <- ALAR_5min$Latitude_deg

wind_df <- data.frame(u, v, lon, lat)

library(sf)
library(ggplot2)
library(raster)  
library(viridis)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")

east_coast_states <- c(
  "Maine", "New Hampshire", "Massachusetts", "Rhode Island", "Connecticut",
  "New York", "New Jersey", "Delaware", "Maryland", "Virginia",
  "North Carolina", "South Carolina", "Georgia", "Florida", "Pennsylvania", "Vermont"
)

east_states_sf <- states |>
  dplyr::filter(NAME %in% east_coast_states) 

east_extent <- extent(-85, -65, 25, 47)

arrow_scale <- 0.08
ggplot() +
  geom_sf(data = east_states_sf, fill = "gray90", color = "gray50", linewidth = 0.3) +
    geom_path(
    data = ALAR,
    aes(x = Longitude_deg, y = Latitude_deg),
    color = "black",
    linewidth = 1
  ) +
  geom_segment(
    data = wind_df,
    aes(
      x = lon,
      y = lat,
      xend = lon + u * arrow_scale,
      yend = lat + v * arrow_scale,
      color = wind_speed
    ),
    arrow = arrow(length = unit(0.15, "cm")),
    linewidth = 0.5
  ) +
  geom_point(data = wind_df, aes(x = lon, y = lat, color = wind_speed), size = 1) +
  coord_sf(xlim = c(-77, -72), ylim = c(39.5, 41.5), expand = FALSE) +
    scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (7/2/2025)",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal(base_size = 12)
###___________________ starting lat/lon is wrong for traj___________________####
directory <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/flight"
setwd(directory)

tdump_files = list.files(
  pattern = glob2rx("tdump?*"),
  recursive = T,
  full.names = T
)
sorted <- order(basename(tdump_files))
tdump_files <- (tdump_files[sorted])

trajectory1_list <- list()

i = 1
while (i <= length(tdump_files)) {
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
 
  trajectory1_list <- append(trajectory1_list, list(Single_Example_file_traj1))
  i = i + 1
}


library(paletteer)
colors <- as.character(paletteer_c("grDevices::rainbow", n = length(trajectory1_list)))
plot(
  st_geometry((states)),
  xlim = c(-78, -70),
  ylim = c(38, 42),
  xlab = "",
  ylab = "",
  main = "Trajs",
  border = "grey",
  axes = T,
  las = 1,
  asp = 1
)
lines(ALAR$Longitude_deg,ALAR$Latitude_deg, col = "black")
for (i in 1:length(trajectory1_list)) {
  lon <- trajectory1_list[[i]][[11]]
  lat <- trajectory1_list[[i]][[10]]
  
  print(paste("i =", i, "length(lon) =", length(lon), "length(lat) =", length(lat)))
  
  if (all(is.finite(lon)) && all(is.finite(lat)) && length(lon) > 1) {
    lines(lon, lat, col = colors[i], lwd = 0.5, type = "o", pch = 20, cex = 0.6)
    points(lon[1],lat[1], col = colors[i],pch = 20)
  } else {
    message("Skipped trajectory ", i)
  }
}

