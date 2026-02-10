# use this link to grab data: https://cds.climate.copernicus.eu/datasets/reanalysis-era5-pressure-levels?tab=download
#grab: reanalysis, u, v, and geopotential, 750-1000 hPa 

##### ______ adding wind vectors to 2.2.26 & 2.5.26 _________ #####

winds_2.2.26 <- data.frame(wd_dir = c(345,316,330,317,360,303,320,320,318), 
                           wd_spd = c(17, 17, 19, 18,15, 21, 12,16,22),
                           ht_ft = c(1400, 1400,1400, 1400, 1400, 1400, 1000, 1000, 1000),
                           local_time = c("4:05:00 PM", "4:30:00 PM", "4:37:00 PM", "4:45:00 PM", "4:50:00 PM",
                                          "4:57:00 PM", "5:04:00 PM", "5:06:00 PM", "5:11:00 PM"))

winds_2.5.26 <- data.frame(wd_dir = c(41, 46, 62, 28, 84, 58, 350, 360, 25, 64, 65, 322, 17, 14), 
                           wd_spd = c(13, 17, 11, 16, 16, 18, 11, 10, 10, 20, 18, 10, 11, 12),
                           ht_ft = c(1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200, 1200),
                           local_time = c("9:33:00 AM", "9:40:00 AM", "9:47:00 AM", "9:56:00 AM",
                                          "10:13:00 AM", "10:19:00 AM", "10:25:00 AM", "10:30:00 AM",
                                          "10:33:00 AM", "10:37:00 AM", "10:38:00 AM", "10:49:00 AM",
                                          "11:10:00 AM", "11:13:00 AM"))

winds_2.2.26$local_time <- as.POSIXct(
  paste("2026-02-02", winds_2.2.26$local_time),
  format = "%Y-%m-%d %I:%M:%S %p",
  tz = "America/New_York"
)

winds_2.2.26$utc_time <- as.POSIXct(format(winds_2.2.26$local_time, tz = "UTC", usetz = TRUE), tz = "UTC")


winds_2.5.26$local_time <- as.POSIXct(
  paste("2026-02-05", winds_2.5.26$local_time),
  format = "%Y-%m-%d %I:%M:%S %p",
  tz = "America/New_York"
)

winds_2.5.26$utc_time <- as.POSIXct(format(winds_2.5.26$local_time, tz = "UTC", usetz = TRUE), tz = "UTC")


flight_2.2.26 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2026_Flights/2-2-26/2026-02-02_ALAR_1hz.csv')
flight_2.5.26 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2026_Flights/2-5-26/2026-02-05_ALAR_1hz.csv')

flight_2.2.26$Time_local <- as.POSIXct(flight_2.2.26$Time_local, origin = "1904-01-01", tz = "UTC") # it is in EST
flight_2.2.26$Time_UTC <- as.POSIXct(flight_2.2.26$Time_UTC, origin = "1904-01-01", tz = "UTC")

flight_2.5.26$Time_local <- as.POSIXct(flight_2.5.26$Time_local, origin = "1904-01-01", tz = "UTC") # it is in EST
flight_2.5.26$Time_UTC <- as.POSIXct(flight_2.5.26$Time_UTC, origin = "1904-01-01", tz = "UTC")


library(openair)
colnames(flight_2.2.26)[colnames(flight_2.2.26) == "Time_UTC"] <- "date"

avg5_flight_2.2.26 <- timeAverage(flight_2.2.26,
                         avg.time = "5 min",
                         data.thresh = 0,
                         statistic = "mean")
avg5_flight_2.2.26 <- avg5_flight_2.2.26[!is.na(avg5_flight_2.2.26$Latitude_deg), ]


colnames(flight_2.5.26)[colnames(flight_2.5.26) == "Time_UTC"] <- "date"

avg5_flight_2.5.26 <- timeAverage(flight_2.5.26,
                                  avg.time = "5 min",
                                  data.thresh = 0,
                                  statistic = "mean")
avg5_flight_2.5.26 <- avg5_flight_2.5.26[!is.na(avg5_flight_2.5.26$Latitude_deg), ]


avg5_flight_2.2.26 <- avg5_flight_2.2.26[order(avg5_flight_2.2.26$date), ]
avg5_flight_2.2.26$utc_time <- avg5_flight_2.2.26$date
winds_2.2.26 <- winds_2.2.26[order(winds_2.2.26$utc_time), ]

avg5_flight_2.5.26 <- avg5_flight_2.5.26[order(avg5_flight_2.5.26$date), ]
avg5_flight_2.5.26$utc_time <- avg5_flight_2.5.26$date
winds_2.5.26 <- winds_2.5.26[order(winds_2.5.26$utc_time), ]


cols_to_add <- c("wd_dir", "wd_spd", "ht_ft")

idx <- findInterval(
  avg5_flight_2.2.26$utc_time,
  winds_2.2.26$utc_time
)

idx.2 <- findInterval(
  avg5_flight_2.5.26$utc_time,
  winds_2.5.26$utc_time
)

idx[idx == 0] <- NA

idx.2[idx.2 == 0] <- NA

avg5_flight_2.2.26[cols_to_add] <- winds_2.2.26[idx, cols_to_add]
avg5_flight_2.5.26[cols_to_add] <- winds_2.5.26[idx.2, cols_to_add]

cols_to_keep <- c("utc_time", "wd_dir", "wd_spd", "ht_ft", "Latitude_deg", "Longitude_deg", "HeightAbvMSL_m", "heightabvground_m")

final_2.2.26 <- avg5_flight_2.2.26[, cols_to_keep]
final_2.2.26 <- final_2.2.26[!is.na(final_2.2.26$wd_dir), ]

final_2.5.26 <- avg5_flight_2.5.26[, cols_to_keep]
final_2.5.26 <- final_2.5.26[!is.na(final_2.5.26$wd_dir), ]


##### ______ plot for 2.2.26 _________ #####
wind_speed <- (final_2.2.26$wd_spd/1.944) #knots to m/s
wind_dir <- final_2.2.26$wd_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- final_2.2.26$Longitude_deg
lat <- final_2.2.26$Latitude_deg

wind_df <- data.frame(u, v, lon, lat)

library(sf)
library(ggplot2)
library(raster)
library(viridis)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")

east_coast_states <- c(
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)

east_states_sf <- states |>
  dplyr::filter(NAME %in% east_coast_states)

east_extent <- extent(-85, -65, 25, 47)

arrow_scale <- 0.04
ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = final_2.2.26,
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
  geom_point(data = wind_df,
             aes(x = lon, y = lat, color = wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (2/2/2026)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

##### ______ plot for 2.5.26 _________ #####
wind_speed <- (final_2.5.26$wd_spd/1.944) #knots to m/s
wind_dir <- final_2.5.26$wd_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- final_2.5.26$Longitude_deg
lat <- final_2.5.26$Latitude_deg

wind_df <- data.frame(u, v, lon, lat)

library(sf)
library(ggplot2)
library(raster)
library(viridis)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")

east_coast_states <- c(
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)

east_states_sf <- states |>
  dplyr::filter(NAME %in% east_coast_states)

east_extent <- extent(-85, -65, 25, 47)

arrow_scale <- 0.04
ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = final_2.5.26,
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
  geom_point(data = wind_df,
             aes(x = lon, y = lat, color = wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (2/5/2026)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)


##### ______ loading in ERA5-Reanalysis winds 2.2.26 ________######
library(ncdf4)
library(dplyr)
era5_2.2.26 <- nc_open("/Users/reneechabot-mehlin/Downloads/2-2-26-era5-reanalysis.nc")

lon  <- ncvar_get(era5_2.2.26, "longitude")
lat  <- ncvar_get(era5_2.2.26, "latitude")

time <- ncvar_get(era5_2.2.26, "valid_time")
time <- as.POSIXct(time , origin = "1970-01-01 00:00:00", tz = "UTC") #3600 converts hrs -> sec


u <- ncvar_get(era5_2.2.26, "u")
v <- ncvar_get(era5_2.2.26, "v")
z <- ncvar_get(era5_2.2.26, "z")

g <- 9.80665
height_msl <- z / g


min_time <- as.POSIXct(min(final_2.2.26$utc_time), tz = "UTC")
max_time <- as.POSIXct(max(final_2.2.26$utc_time), tz = "UTC")

time_indices <- which(time >= min_time & time <= max_time)
if (length(time_indices) == 0) {
  message("No overlapping times for file: ", era5_2.2.26) #check to basically make sure I load in the right file
  nc_close(era5_2.2.26)
  next
}
time_sel <- time[time_indices]

level <- ncvar_get(era5_2.2.26, "pressure_level") 


u_sel <- u[ , , , time_indices, drop = FALSE]
v_sel <- v[ , , , time_indices, drop = FALSE]
height_sel <- height_msl[ , , , time_indices, drop = FALSE]


wind_by_level <- vector("list", length(level))
names(wind_by_level) <- paste0("p", level)
for (k in seq_along(level)) {
  
  u_k <- u_sel[ , , k, ]  
  v_k <- v_sel[ , , k, ]
  h_k <- height_sel[ , , k, ]
  
  df <- expand.grid(
    lon  = lon,
    lat  = lat,
    time = time_sel
  )
  
  df$u <- as.vector(u_k)
  df$v <- as.vector(v_k)
  df$ht <- as.vector(h_k)
  
  df$pressure_level <- level[k]
  
  wind_by_level[[k]] <- df
}

wind_all <- do.call(rbind, wind_by_level)


final <- final_2.2.26

final$height_m <- final$ht_ft * 0.3048

nearest_index <- function(x, x0) {
  which.min(abs(x - x0))
}


matched <- vector("list", nrow(final))

for (i in seq_len(nrow(final))) {
  
  obs_time <- final$utc_time[i]
  obs_lat  <- final$Latitude_deg[i]
  obs_lon  <- final$Longitude_deg[i]
  obs_h    <- final$HeightAbvMSL_m[i]
  
  # subset ERA5 to nearest time
  ti <- nearest_index(unique(wind_all$time), obs_time)
  t_sel <- unique(wind_all$time)[ti]
  
  era_t <- wind_all[wind_all$time == t_sel, ]
  
  # nearest grid point
  li <- nearest_index(era_t$lat, obs_lat)
  loi <- nearest_index(era_t$lon, obs_lon)
  
  era_space <- era_t[
    era_t$lat == era_t$lat[li] &
      era_t$lon == era_t$lon[loi],
  ]
  
  hi <- nearest_index(era_space$ht, obs_h)
  
  matched[[i]] <- cbind(
    final[i, ],
    era_space[hi, c("u", "v", "pressure_level", "ht")]
  )
}


matched_df <- do.call(rbind, matched)

##### ______ plotting 2.2.26 comparison _________ #####

wind_speed <- (matched_df$wd_spd/1.944) #knots to m/s
wind_dir <- matched_df$wd_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- matched_df$Longitude_deg
lat <- matched_df$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat)

era5_wind_speed <- sqrt(matched_df$u^2 + matched_df$v^2)
wind_df_era5 <- data.frame(u = matched_df$u, v = matched_df$v, lon, lat)


library(sf)
library(ggplot2)
library(raster)
library(viridis)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")

east_coast_states <- c(
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)

east_states_sf <- states |>
  dplyr::filter(NAME %in% east_coast_states)

east_extent <- extent(-85, -65, 25, 47)

arrow_scale <- 0.04
p1 <- ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = final,
    aes(x = Longitude_deg, y = Latitude_deg),
    color = "black",
    linewidth = 1
  ) +
  geom_segment(
    data = wind_df_obs,
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
  geom_point(data = wind_df_obs,
             aes(x = lon, y = lat, color = wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (2/2/2026)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

p2 <- ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = final,
    aes(x = Longitude_deg, y = Latitude_deg),
    color = "black",
    linewidth = 1
  ) +
  geom_segment(
    data = wind_df_era5,
    aes(
      x = lon,
      y = lat,
      xend = lon + u * arrow_scale,
      yend = lat + v * arrow_scale,
      color = era5_wind_speed
    ),
    arrow = arrow(length = unit(0.15, "cm")),
    linewidth = 0.5
  ) +
  geom_point(data = wind_df_era5,
             aes(x = lon, y = lat, color = era5_wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "ERA5-Reanalysis Wind Vectors over ALAR Flight Path (2/2/2026)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

library(cowplot)

plot_grid(p1, p2)



##### 7.2.25 initial plot and load in #####
ALAR <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2025_Flights/July_WINDS_TEST/7-2-25/2025-07-02_ALAR_1hz.csv'
)
ALAR$Time_local <- as.POSIXct(ALAR$Time_local, origin = "1904-01-01", tz = "America/New_York")
ALAR$Time_UTC <- as.POSIXct(ALAR$Time_UTC, origin = "1904-01-01", tz = "UTC")

library(openair)
colnames(ALAR)[colnames(ALAR) == "Time_UTC"] <- "date"

ALAR_5min <- timeAverage(ALAR,
                         avg.time = "5 min",
                         data.thresh = 0,
                         statistic = "mean")

ALAR_5min <- ALAR_5min[!is.na(ALAR_5min$Latitude_deg), ]

cols_to_keep <- c("date", "w_dir" ,"w_spd",  "Latitude_deg", "Longitude_deg", "HeightAbvMSL_m", "heightabvground_m")
ALAR_5min <- ALAR_5min[, cols_to_keep]

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
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)

east_states_sf <- states |>
  dplyr::filter(NAME %in% east_coast_states)

east_extent <- extent(-85, -65, 25, 47)

arrow_scale <- 0.08
ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
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
  geom_point(data = wind_df,
             aes(x = lon, y = lat, color = wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (7/2/2025)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)


##### loading in 7.2.25 ERA5 #######
library(ncdf4)
library(dplyr)
era5_7.2.25 <- nc_open("/Users/reneechabot-mehlin/Downloads/7-2-25-era5-reanalysis.nc")

lon  <- ncvar_get(era5_7.2.25, "longitude")
lat  <- ncvar_get(era5_7.2.25, "latitude")

time <- ncvar_get(era5_7.2.25, "valid_time")
time <- as.POSIXct(time , origin = "1970-01-01 00:00:00", tz = "UTC") #3600 converts hrs -> sec


u <- ncvar_get(era5_7.2.25, "u")
v <- ncvar_get(era5_7.2.25, "v")
z <- ncvar_get(era5_7.2.25, "z")

g <- 9.80665
height_msl <- z / g


min_time <- as.POSIXct(min(ALAR_5min$date), tz = "UTC")
max_time <- as.POSIXct(max(ALAR_5min$date), tz = "UTC")

time_indices <- which(time >= min_time & time <= max_time)
if (length(time_indices) == 0) {
  message("No overlapping times for file: ", era5_7.2.25) #check to basically make sure I load in the right file
  nc_close(era5_7.2.25)
  next
}
time_sel <- time[time_indices]

level <- ncvar_get(era5_7.2.25, "pressure_level") 


u_sel <- u[ , , , time_indices, drop = FALSE]
v_sel <- v[ , , , time_indices, drop = FALSE]
height_sel <- height_msl[ , , , time_indices, drop = FALSE]


wind_by_level <- vector("list", length(level))
names(wind_by_level) <- paste0("p", level)
for (k in seq_along(level)) {
  
  u_k <- u_sel[ , , k, ]  
  v_k <- v_sel[ , , k, ]
  h_k <- height_sel[ , , k, ]
  
  df <- expand.grid(
    lon  = lon,
    lat  = lat,
    time = time_sel
  )
  
  df$u <- as.vector(u_k)
  df$v <- as.vector(v_k)
  df$ht <- as.vector(h_k)
  
  df$pressure_level <- level[k]
  
  wind_by_level[[k]] <- df
}

wind_all <- do.call(rbind, wind_by_level)


final <- ALAR_5min


nearest_index <- function(x, x0) {
  which.min(abs(x - x0))
}


matched <- vector("list", nrow(final))

for (i in seq_len(nrow(final))) {
  
  obs_time <- final$date[i]
  obs_lat  <- final$Latitude_deg[i]
  obs_lon  <- final$Longitude_deg[i]
  obs_h    <- final$HeightAbvMSL_m[i]
  
  # subset ERA5 to nearest time
  ti <- nearest_index(unique(wind_all$time), obs_time)
  t_sel <- unique(wind_all$time)[ti]
  
  era_t <- wind_all[wind_all$time == t_sel, ]
  
  # nearest grid point
  li <- nearest_index(era_t$lat, obs_lat)
  loi <- nearest_index(era_t$lon, obs_lon)
  
  era_space <- era_t[
    era_t$lat == era_t$lat[li] &
      era_t$lon == era_t$lon[loi],
  ]
  
  hi <- nearest_index(era_space$ht, obs_h)
  
  matched[[i]] <- cbind(
    final[i, ],
    era_space[hi, c("u", "v", "pressure_level", "ht")]
  )
}


matched_df <- do.call(rbind, matched)




##### ______ plotting 7.2.25 comparison _________ #####

wind_speed <- (matched_df$w_spd/1.944) #knots to m/s
wind_dir <- matched_df$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- matched_df$Longitude_deg
lat <- matched_df$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat)

era5_wind_speed <- sqrt(matched_df$u^2 + matched_df$v^2)
wind_df_era5 <- data.frame(u = matched_df$u, v = matched_df$v, lon, lat)


library(sf)
library(ggplot2)
library(raster)
library(viridis)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")

east_coast_states <- c(
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)

east_states_sf <- states |>
  dplyr::filter(NAME %in% east_coast_states)

east_extent <- extent(-85, -65, 25, 47)

arrow_scale <- 0.08
p1 <- ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = final,
    aes(x = Longitude_deg, y = Latitude_deg),
    color = "black",
    linewidth = 1
  ) +
  geom_segment(
    data = wind_df_obs,
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
  geom_point(data = wind_df_obs,
             aes(x = lon, y = lat, color = wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (7/2/2025)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

p2 <- ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = final,
    aes(x = Longitude_deg, y = Latitude_deg),
    color = "black",
    linewidth = 1
  ) +
  geom_segment(
    data = wind_df_era5,
    aes(
      x = lon,
      y = lat,
      xend = lon + u * arrow_scale,
      yend = lat + v * arrow_scale,
      color = era5_wind_speed
    ),
    arrow = arrow(length = unit(0.15, "cm")),
    linewidth = 0.5
  ) +
  geom_point(data = wind_df_era5,
             aes(x = lon, y = lat, color = era5_wind_speed),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "ERA5-Reanalysis Wind Vectors over ALAR Flight Path (7/2/2025)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

library(cowplot)

plot_grid(p1, p2)
