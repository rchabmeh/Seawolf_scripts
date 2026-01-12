##Adding ALAR flight comparison info______####
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

##### .nc files ####
#they are in here: /Users/reneechabot-mehlin/Downloads/alar_winds_file
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

library(ncdf4)
library(dplyr)
nc_dir <- "/Users/reneechabot-mehlin/Downloads/alar_winds_file"
nc_files <- list.files(nc_dir, pattern = "\\.nc$", full.names = TRUE)

u_files <- nc_files[grepl("_u", nc_files, ignore.case = TRUE)]
v_files <- nc_files[grepl("_v", nc_files, ignore.case = TRUE)]

min_lon <- 72
max_lon <- 77
min_lat <- 39.5
max_lat <- 41.5

min_time <- as.POSIXct(min(ALAR_5min$date), tz = "UTC")
max_time <- as.POSIXct(max(ALAR_5min$date), tz = "UTC")

u_list <- list()
for (nc_file in u_files) {
  u <- nc_open(nc_file)
  lon  <- ncvar_get(u, "longitude")
  lat  <- ncvar_get(u, "latitude")
  time <- ncvar_get(u, "time")
  #I was having problems with time converting right before so need to multiply by 3600
  time <- as.POSIXct(time * 3600, origin = "1900-01-01 00:00:00", tz = "UTC") #3600 converts hrs -> sec
  
  time_indices <- which(time >= min_time & time <= max_time)
  if (length(time_indices) == 0) {
    message("No overlapping times for file: ", nc_file) #check to basically make sure I load in the right file
    nc_close(u)
    next
  }
  
  time_sel <- time[time_indices]
  
  message("File: ",
          basename(nc_file),
          " -- time_sel: ",
          paste(time_sel, collapse = ", "))
  
  level <- u$dim$level$vals #this is pressure levels (no units)
  selected_levels <- level[100:137] #this is the bottom of the atmosphere, used picture to help determine
  #picture link: https://confluence.ecmwf.int/plugins/viewsource/viewpagesrc.action?pageId=158636068
  
  for (lvl in selected_levels) {
    lvl_index <- which(level == lvl)
    
    U_component <- ncvar_get(
      u,
      "U",
      start = c(1, 1, lvl_index, min(time_indices)),
      count = c(-1, -1, 1, length(time_indices))
    )
    
    U_component <- array(U_component, dim = c(
      dim(U_component)[1],
      dim(U_component)[2],
      length(time_indices)
    ))
    
    lon_idx <- which(lon >= min_lon &
                       lon <= max_lon) #index lon and lat so U can match, saves memory
    lat_idx <- which(lat >= min_lat & lat <= max_lat)
    if (length(lon_idx) == 0 | length(lat_idx) == 0) {
      message("No overlapping lon/lat for file: ", nc_file)
      next
    }
    
    df <- expand.grid(
      lon = lon[lon_idx],
      lat = lat[lat_idx],
      time = time_sel,
      level = lvl
    )
    
    #dim(U_component) [1280 ,640] so now you need to remove comma (went from 4 dim to 2 dim which makes sense) first .nc file
    #dim(U_component) [1280, 640, 6] so now you add the comma (went from 4 dim to 3 dim which makes sense) second .nc file
    # explanation: we have 1 level and 1 time we are looping through so only lon/lat will change for the first file, second file time changes too so lon/lat/time changes
    U_sub <- U_component[lon_idx, lat_idx, , drop = FALSE]
    df$U <- as.vector(U_sub)
    
    new_name <- sub(
      ".*_u\\.regn320uv\\.(\\d{8})(\\d{2})_\\d{8}(\\d{2})\\.nc",
      "u_\\1_\\2-\\3",
      basename(nc_file)
    ) #rename for clarity
    df_name <- paste0(new_name, "_lvl", lvl)
    u_list[[df_name]] <- df
  } #to the next level!
  nc_close(u) #to the next file (if there)
}

v_list <- list()
for (nc_file in v_files) {
  v <- nc_open(nc_file)
  lon  <- ncvar_get(v, "longitude")
  lat  <- ncvar_get(v, "latitude")
  time <- ncvar_get(v, "time")
  #I was having problems with time converting right before so need to multiply by 3600
  time <- as.POSIXct(time * 3600, origin = "1900-01-01 00:00:00", tz = "UTC") #3600 converts hrs -> sec
  
  time_indices <- which(time >= min_time & time <= max_time)
  if (length(time_indices) == 0) {
    message("No overlapping times for file: ", nc_file) #check to basically make sure I load in the right file
    nc_close(v)
    next
  }
  
  time_sel <- time[time_indices]
  
  message("File: ",
          basename(nc_file),
          " -- time_sel: ",
          paste(time_sel, collapse = ", "))
  
  level <- v$dim$level$vals #this is pressure levels (no units)
  selected_levels <- level[100:137] #this is the bottom of the atmosphere, used picture to help determine
  #picture link: https://confluence.ecmwf.int/plugins/viewsource/viewpagesrc.action?pageId=158636068
  
  for (lvl in selected_levels) {
    lvl_index <- which(level == lvl)
    
    V_component <- ncvar_get(
      v,
      "V",
      start = c(1, 1, lvl_index, min(time_indices)),
      count = c(-1, -1, 1, length(time_indices))
    )
    
    V_component <- array(V_component, dim = c(
      dim(V_component)[1],
      dim(V_component)[2],
      length(time_indices)
    ))
    
    lon_idx <- which(lon >= min_lon &
                       lon <= max_lon) #index lon and lat so V can match, saves memory
    lat_idx <- which(lat >= min_lat & lat <= max_lat)
    if (length(lon_idx) == 0 | length(lat_idx) == 0) {
      message("No overlapping lon/lat for file: ", nc_file)
      next
    }
    
    df <- expand.grid(
      lon = lon[lon_idx],
      lat = lat[lat_idx],
      time = time_sel,
      level = lvl
    )
    
    #dim(U_component) [1280 ,640] so now you need to remove comma (went from 4 dim to 2 dim which makes sense) first .nc file
    #dim(U_component) [1280, 640, 6] so now you add the comma (went from 4 dim to 3 dim which makes sense) second .nc file
    # explanation: we have 1 level and 1 time we are looping through so only lon/lat will change for the first file, second file time changes too so lon/lat/time changes
    V_sub <- V_component[lon_idx, lat_idx, , drop = FALSE]
    df$V <- as.vector(V_sub)
    
    new_name <- sub(
      ".*_v\\.regn320uv\\.(\\d{8})(\\d{2})_\\d{8}(\\d{2})\\.nc",
      "v_\\1_\\2-\\3",
      basename(nc_file)
    ) #rename for clarity
    df_name <- paste0(new_name, "_lvl", lvl)
    v_list[[df_name]] <- df
  } #to the next level!
  nc_close(v) #to the next file (if there)
}


merged_list <- mapply(function(df_u, df_v) {
  #applies a given function to multiple arguments simultaneously
  common_cols <- setdiff(names(df_u), "U") #used to find the elements that are present in the first df but not in the second df (so all but U)
  merge(df_u, df_v, by = common_cols, all = TRUE) #merge by common columns and preserves unique columns (keeps U and V and no duplicates of lat/lon/time)
}, u_list, v_list, SIMPLIFY = FALSE) #SIMPLIFY = F makes sure it keeps it as a list of df and not a matrix or vector

names(merged_list) <- sapply(names(merged_list), function(nm) {
  # extract the time part (12-17) using regex
  time_part <- sub(".*_(\\d{2}-\\d{2})_lvl.*", "\\1", nm)
  level_part <- sub(".*_lvl(\\d+)", "\\1", nm)
  paste0("df_", time_part, "_lvl_", level_part)
})


nc <- nc_open(nc_file)
#we want to now convert the pressure levels to actual pressure, then height so we need a and b
#p = a + b*ps
a_model <- ncvar_get(nc, "a_model")
b_model <- ncvar_get(nc, "b_model")
nc_close(nc)

#average temperature for 7/2/25 btwn 10-14 EDT is 80 F or ~27 C
#average temperature link: https://www.timeanddate.com/weather/usa/jersey-city/historic?month=7&year=2025

ps <- 101325          # Pa, standard surface pressure
tK <- 300.15           # K, approx temperature
R <- 287.05           # J/(kg·K)
g <- 9.80665          # m/s^2

pressure <- a_model + b_model * ps #calculating pressure in Pa
height <- -R * tK / g * log(pressure / ps) #calculating height in meters
level_height <- data.frame(level = seq_along(a_model), height_m = height) #matching levels to heights
merged_list <- lapply(merged_list, function(df) {
  merge(df, level_height, by = "level", all.x = TRUE)
})

ALAR_COMPARISON <- data.frame(
  #making a smaller dataframe to match with, only what I need which is lat/lon/ht/time
  lon = ALAR_5min$Longitude_deg,
  lat = ALAR_5min$Latitude_deg,
  height_m = ALAR_5min$heightabvground_m,
  time = ALAR_5min$date
)
full_model_df <- do.call(rbind, merged_list) #making one long df with all levels of interest so I can find the closest match to ALAR_COMPARISON

find_closest <- function(df_model, df_obs, time_window_hours = 1) {
  df_obs$U_model <- NA #creating new columns to hold U and V model info
  df_obs$V_model <- NA
  
  for (i in seq_len(nrow(df_obs))) {
    obs <- df_obs[i, ] #loops through observations
   
     #time first
    df_model_near <- df_model[abs(difftime(df_model$time, obs$time, units = "hours")) <= time_window_hours, ]
    if (nrow(df_model_near) == 0)
      next
    #distance next 
    dist <- (df_model_near$lon - obs$lon)^2 +
      (df_model_near$lat - obs$lat)^2 +
      (df_model_near$height - obs$height)^2
    
    #we only care about which distance is smallest, not the actual numeric value of the distance so no sqrt is needed
    closest_idx <- which.min(dist) #closest distance overall to the point of interest
    
    df_obs$U_model[i] <- df_model_near$U[closest_idx] #matches U and V within the closest value
    df_obs$V_model[i] <- df_model_near$V[closest_idx]
  }
  
  return(df_obs)
}

obs_with_model <- find_closest(full_model_df, ALAR_COMPARISON)
obs_with_model$wind_speed <- sqrt(obs_with_model$U^2 + obs_with_model$V^2) #add in wind speed

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
    data = obs_with_model,
    aes(
      x = lon,
      y = lat,
      xend = lon + U_model * arrow_scale,
      yend = lat + V_model * arrow_scale,
      color = wind_speed
    ),
    arrow = arrow(length = unit(0.15, "cm")),
    linewidth = 0.5
  ) +
  geom_point(data = obs_with_model,
             aes(x = lon, y = lat, color = wind_speed),
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
###### Comparison Time ######

ALAR_COMPARISON$U <- ALAR_5min$U
ALAR_COMPARISON$V <- ALAR_5min$V
ALAR_COMPARISON$wind_dir <- ALAR_5min$w_dir
ALAR_COMPARISON$CALC_wind_dir <- round((atan2(-ALAR_COMPARISON$U, -ALAR_COMPARISON$V) * 180 / pi) %% 360, 0)

mean(abs(ALAR_COMPARISON$CALC_wind_dir - ALAR_COMPARISON$wind_dir), na.rm = TRUE)

calc_dir <- (atan2(-ALAR_COMPARISON$U, -ALAR_COMPARISON$V) * 180/pi) %% 360  # calculated "from" direction
err_deg  <- ( (calc_dir - ALAR_COMPARISON$wind_dir + 180) %% 360 ) - 180  # circular difference (-180,180)
mean(err_deg, na.rm=TRUE)

ALAR_COMPARISON$wind_speed <- ALAR_5min$w_spd

obs_with_model$wind_dir <- round((atan2(-obs_with_model$U, -obs_with_model$V) * 180 / pi) %% 360, 0)

saveRDS(obs_with_model, "/Users/reneechabot-mehlin/Downloads/obs_with_model.RData")
saveRDS(ALAR_COMPARISON, "/Users/reneechabot-mehlin/Downloads/ALAR_COMPARISON.RData")

##### plots and such-- load in here! ####
obs_with_model <- readRDS("/Users/reneechabot-mehlin/Downloads/obs_with_model.RData")
ALAR_COMPARISON <- readRDS("/Users/reneechabot-mehlin/Downloads/ALAR_COMPARISON.RData")

# obs_with_model$wind_dir <- obs_with_model$wind_dir - 90
# ALAR_COMPARISON$wind_dir <- ALAR_COMPARISON$wind_dir - 90


library(ggplot2)
ggplot() +
  geom_point(data = obs_with_model, aes(x = time, y = wind_dir, color = "Modeled")) +
  geom_line(data = obs_with_model, aes(x = time, y = wind_dir, color = "Modeled")) +
  geom_point(data = ALAR_COMPARISON, aes(x = time, y = wind_dir, color = "Observations")) +
  geom_line(data = ALAR_COMPARISON, aes(x = time, y = wind_dir, color = "Observations")) +
  labs(
    title = "Comparison of ERA5 wind direction vs measured wind direction",
    x = "Time",
    y = "Wind direction",
    subtitle = "July 2nd, 2025",
    color = "Dataset"
  ) +
  scale_color_manual(values = c("Modeled" = "blue", "Observations" = "red")) +
  theme_minimal(base_size = 14)

bias_df <- data.frame(
  time = obs_with_model$time,
  bias = obs_with_model$wind_dir - ALAR_COMPARISON$wind_dir
)

ggplot(bias_df, aes(x = time, y = bias)) +
  geom_line() +
  geom_hline(yintercept = 1, color = "red") +
  labs(
    x = "Time",
    y = "Model Bias",
    title = "Wind Direction Model Bias",
    subtitle = "July 2nd, 2025"
  ) +
  theme_minimal(base_size = 14)

mse <- round(mean((ALAR_COMPARISON$wind_dir - obs_with_model$wind_dir)^2, na.rm = T), 0)
rmse <- round(sqrt(mean((ALAR_COMPARISON$wind_dir - obs_with_model$wind_dir)^2, na.rm = T)), 0)
rsq <- round(summary(lm(ALAR_COMPARISON$wind_dir ~ obs_with_model$wind_dir))$r.squared, 2)

lm_df <- data.frame(observation = ALAR_COMPARISON$wind_dir, modelled = obs_with_model$wind_dir)

lin <-lm(observation ~ modelled, data = lm_df)
par(mfrow = c(2,2))
plot(lin)




#plot 1
plot(
  obs_with_model$lon,
  obs_with_model$lat,
  type = "l",
  col = "black",
  lwd = 1.5,
  xlab = "Longitude",
  ylab = "Latitude"
)
lines(obs_with_model$lon[12:18],
      obs_with_model$lat[12:18],
      col = "green",
      lwd = 2)
lines(obs_with_model$lon[24:31],
      obs_with_model$lat[24:31],
      col = "red",
      lwd = 2)
lines(obs_with_model$lon[37:41],
      obs_with_model$lat[37:41],
      col = "blue",
      lwd = 2)

#plot 2
plot(obs_with_model$time,
     obs_with_model$height_m,
     type = "l",
     lwd = 2, xlab = "Time", ylab = "Height [m]")
lines(
  obs_with_model$time[12:18],
  obs_with_model$height_m[12:18],
  col = "green",
  lwd = 2
)
lines(
  obs_with_model$time[24:31],
  obs_with_model$height_m[24:31],
  col = "red",
  lwd = 2
)
lines(
  obs_with_model$time[37:41],
  obs_with_model$height_m[37:41],
  col = "blue",
  lwd = 2
)
lines(
  obs_with_model$time[44:48],
  obs_with_model$height_m[44:48],
  col = "orange",
  lwd = 2
)
#plot 3
plot(
  obs_with_model$lon,
  obs_with_model$height_m,
  type = "l",
  col = "black",
  lwd = 1.5,
  xlim = c(-75.4, -73.85),
  ylim = c(200, 600), xlab = "Longitude", ylab = "Height [m]"
)
lines(
  obs_with_model$lon[12:18],
  obs_with_model$height_m[12:18],
  col = "green",
  lwd = 2
)
lines(obs_with_model$lon[24:31],
      obs_with_model$height_m[24:31],
      col = "red",
      lwd = 2)
lines(
  obs_with_model$lon[37:41],
  obs_with_model$height_m[37:41],
  col = "blue",
  lwd = 2
)

#plot 4
plot(
  ALAR_COMPARISON$U[12:18],
  ALAR_COMPARISON$V[12:18],
  pch = 21 ,
  bg = "green",
  xlim = c(-3, 8), xlab = "U-wind component",
ylab = "V-wind component")
points(ALAR_COMPARISON$U[24:31],
       ALAR_COMPARISON$V[24:31],
       pch = 21 ,
       bg = "red")
points(ALAR_COMPARISON$U[37:41],
       ALAR_COMPARISON$V[37:41],
       pch = 21 ,
       bg = "blue")

points(
  obs_with_model$U_model[12:18],
  obs_with_model$V_model[12:18],
  pch = 23,
  bg = "green"
)
points(
  obs_with_model$U_model[24:31],
  obs_with_model$V_model[24:31],
  pch = 23,
  bg = "red"
)
points(
  obs_with_model$U_model[37:41],
  obs_with_model$V_model[37:41],
  pch = 23,
  bg = "blue"
)

#plot 5
plot(
  ALAR_COMPARISON$wind_dir[12:18],
  obs_with_model$wind_dir[12:18],
  xlim = c(0, 360),
  ylim = c(0,360),
  col = "green",
  pch = 19,
  xlab = "ALAR measured wind direction (degrees)",
  ylab = "ERA5 Reanalysis modeled wind direction (degrees)"
)
points(ALAR_COMPARISON$wind_dir[24:31],
       obs_with_model$wind_dir[24:31], pch = 19, col = "red")
points(ALAR_COMPARISON$wind_dir[37:41],
       obs_with_model$wind_dir[37:41], pch = 19, col = "blue")
abline(a = 0, b = 1, col = "grey", lty = 2)



obs_with_model$group <- "black"
obs_with_model$group[12:18] <- "green"
obs_with_model$group[24:31] <- "red"
obs_with_model$group[37:41] <- "blue"
obs_with_model$group[44:48] <- "orange"

ALAR_COMPARISON$group <- NA
ALAR_COMPARISON$group[12:18] <- "green"
ALAR_COMPARISON$group[24:31] <- "red"
ALAR_COMPARISON$group[37:41] <- "blue"
ALAR_COMPARISON$group[44:48] <- "orange"




library(ggplot2)
p1 <- ggplot(obs_with_model, aes(x = lon, y = lat)) +
  geom_path(color = "black", linewidth = 1.2) +
  geom_path(data = obs_with_model[12:18,], color = "green", linewidth = 1.2) +
  geom_path(data = obs_with_model[24:31,], color = "red", linewidth = 1.2) +
  geom_path(data = obs_with_model[37:41,], color = "blue", linewidth = 1.2) +
  geom_path(data = obs_with_model[44:48,], color = "orange", linewidth = 1.2) +
  labs(x = "Longitude", y = "Latitude")

p2 <- ggplot(obs_with_model, aes(x = time, y = height_m)) +
  geom_line(linewidth = 1.2) +
  geom_line(data = obs_with_model[12:18,], color = "green", linewidth = 1.2) +
  geom_line(data = obs_with_model[24:31,], color = "red", linewidth = 1.2) +
  geom_line(data = obs_with_model[37:41,], color = "blue", linewidth = 1.2) +
  geom_line(data = obs_with_model[44:48,], color = "orange", linewidth = 1.2) +
  labs(x = "Time", y = "Height [m]")

p3 <- ggplot(obs_with_model, aes(x = lon, y = height_m)) +
  geom_line(color = "black", linewidth = 0.5) +
  geom_line(data = obs_with_model[12:18,], color = "green", linewidth = 1.2) +
  geom_line(data = obs_with_model[24:31,], color = "red", linewidth = 1.2) +
  geom_line(data = obs_with_model[37:41,], color = "blue", linewidth = 1.2) +
  geom_line(data = obs_with_model[44:48,], color = "orange", linewidth = 1.2) +
  
  coord_cartesian(xlim = c(-75.4, -73.7), ylim = c(200, 3100)) +
  labs(x = "Longitude", y = "Height [m]")

#plot circular
library(ggplot2)
library(dplyr)

ranges <- list(
  12:18,
  24:31,
  37:41,
  44:48
)

# Colors for each segment
segment_colors <- c("green", "red", "blue", "orange")

df_all <- do.call(rbind, lapply(seq_along(ranges), function(i) {
  idx <- ranges[[i]]
  data.frame(
    angle_deg_obs  = obs_with_model$wind_dir[idx],
    angle_deg_alar = ALAR_COMPARISON$wind_dir[idx],
    r_obs = 0.8,
    r_ALAR = 0.5, 
    segment = i                 # segment id (1–4)
  )
}))

convert_xy <- function(angle_deg, r)
{
  angle_rad <- (90 - angle_deg) * pi / 180
  data.frame(
    x = r * cos(angle_rad),
    y = r * sin(angle_rad)
  )
}

# obs (diamonds)
obs_xy <- df_all %>%
  rowwise() %>%
  do({
    cbind(
      convert_xy(.$angle_deg_obs, .$r_obs),
      segment = .$segment,
      dataset = "obs"
    )
  })

# alar (circles)
alar_xy <- df_all %>%
  rowwise() %>%
  do({
    cbind(
      convert_xy(.$angle_deg_alar, .$r_ALAR),
      segment = .$segment,
      dataset = "alar"
    )
  })

# Combine both
plot_df <- rbind(obs_xy, alar_xy)

circle <- data.frame(
  angle = seq(0, 2*pi, length.out = 360)
) %>% mutate(
  x = cos(angle),
  y = sin(angle)
)

ticks <- data.frame(
  angle_deg = seq(0, 330, 30)
) %>%
  mutate(
    angle_rad = (90 - angle_deg) * pi/180,
    x = 1.1 * cos(angle_rad),
    y = 1.1 * sin(angle_rad),
    label = angle_deg
  )

p4 <- ggplot() +
  geom_path(data = circle, aes(x, y), linewidth = 1) +
  
  # Horizontal diameter (0°–180°)
  geom_segment(aes(x = -1, y = 0, xend = 1, yend = 0), linewidth = 0.6) +
  
  # Vertical diameter (90°–270°)
  geom_segment(aes(x = 0, y = -1, xend = 0, yend = 1), linewidth = 0.6) +
  
  # ALAR (circles)
  geom_point(
    data = subset(plot_df, dataset == "alar"),
    aes(x, y, color = factor(segment)),
    size = 3, shape = 16
  ) +
  
  # OBS (diamonds)
  geom_point(
    data = subset(plot_df, dataset == "obs"),
    aes(x, y, color = factor(segment)),
    size = 3, shape = 18
  ) +
  
  geom_text(data = ticks, aes(x, y, label = label), size = 4) +
  
  scale_color_manual(values = segment_colors, guide = "none") +  # remove legend
  coord_equal() +
  theme_void()                                                   # remove axes/title/etc.

p5 <- ggplot() +
  geom_point(data = data.frame(ALAR = ALAR_COMPARISON$wind_dir[12:18] -90 ,
                               ERA5 = obs_with_model$wind_dir[12:18]- 90),
             aes(x = ALAR, y = ERA5), color = "green", size = 5) +
  geom_point(data = data.frame(ALAR = ALAR_COMPARISON$wind_dir[24:31]-90,
                               ERA5 = obs_with_model$wind_dir[24:31]-90),
             aes(x = ALAR, y = ERA5), color = "red", size = 5) +
  geom_point(data = data.frame(ALAR = ALAR_COMPARISON$wind_dir[37:41]-90,
                               ERA5 = obs_with_model$wind_dir[37:41]-90),
             aes(x = ALAR, y = ERA5), color = "blue", size = 5) +
  geom_point(data = data.frame(ALAR = ALAR_COMPARISON$wind_dir[44:48]-90,
                               ERA5 = obs_with_model$wind_dir[44:48]-90),
             aes(x = ALAR, y = ERA5), color = "orange", size = 5) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  coord_cartesian(xlim = c(-90,360), ylim = c(-90,360)) +
  labs(
    x = "ALAR measured wind direction (°) - 90° ",
    y = "ERA5 modeled wind direction (°) - 90° "
  )



t_fmt <- function(x) format(x, "%H:%M")

range1 <- paste0(t_fmt(min(obs_with_model$time[12:18])), "–", t_fmt(max(obs_with_model$time[12:18])))
range2 <- paste0(t_fmt(min(obs_with_model$time[24:31])), "–", t_fmt(max(obs_with_model$time[24:31])))
range3 <- paste0(t_fmt(min(obs_with_model$time[37:41])), "–", t_fmt(max(obs_with_model$time[37:41])))
range4 <- paste0(t_fmt(min(obs_with_model$time[44:48])), "–", t_fmt(max(obs_with_model$time[44:48])))


legend_labels <- c(
  "Full Flight Time Range",
  "17:47–18:17 UTC",
  "18:47–19:22 UTC",
  "19:52–20:12 UTC",
  "20:27–20:47 UTC"
)

legend_data <- data.frame(
  x = 1:5,
  y = 1:5,
  segment = factor(legend_labels, levels = legend_labels)
)

seg_colors <- c(
  "Full Flight Time Range" = "black",
  "17:47–18:17 UTC" = "green",
  "18:47–19:22 UTC" = "red",
  "19:52–20:12 UTC"= "blue",
  "20:27–20:47 UTC" = "orange"
)

legend_data_shapes <- data.frame(
  x = 1:2,
  y = 1:2,
  type = factor(c("Observed", "Modeled"), levels = c("Observed", "Modeled")),
  pch  = c(21, 23)
)

library(ggplot2)
library(cowplot)

legend_plot <- ggplot(legend_data, aes(x, y, color = segment)) +
  geom_point(size = 5) +
  scale_color_manual(values = seg_colors, name = "Time Range") +
  theme_void() +
  theme(
    legend.position = "right",
    legend.title = element_text(size = 16),
    legend.text  = element_text(size = 14)
  )

legend_shapes <- ggplot(legend_data_shapes, aes(x, y, shape = type)) +
  geom_point(size = 5, fill = "grey") +
  scale_shape_manual(values = c(21, 23), name = "Data Type") +
  theme_void() +
  theme(
    legend.position = "right",
    legend.title = element_text(size = 16),
    legend.text  = element_text(size = 14)
  )

legend1 <- get_legend(legend_plot)
legend2 <- get_legend(legend_shapes)
combined_legend <- plot_grid(
  legend1, legend2,
  ncol = 1
)


four_panel <- plot_grid(
  p1, p2, p3, p4,
  labels = c("A", "B", "C", "D"),
  ncol = 2
)

final_plot <- plot_grid(
  four_panel,
  combined_legend,
  ncol = 2,
  rel_widths = c(4, 1)
)
p5.1 <- plot_grid(p5, legend1, ncol = 2, rel_widths = c(4,1))
final_plot
p5.1


##### 12/9/25 ####
obs_with_model <- readRDS("/Users/reneechabot-mehlin/Downloads/obs_with_model.RData")
ALAR_COMPARISON <- readRDS("/Users/reneechabot-mehlin/Downloads/ALAR_COMPARISON.RData")
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
library(sf)
ALAR_COMPARISON_sf <- st_as_sf(ALAR_COMPARISON, coords = c("lon", "lat"), crs = 4326)
ALAR_COMPARISON_sf <- st_transform(ALAR_COMPARISON_sf, st_crs(east_states_sf))
ALAR_COMPARISON_sf$over_land <- lengths(st_intersects(ALAR_COMPARISON_sf, east_states_sf)) > 0

ggplot() +
  geom_sf(
    data = east_states_sf,
    fill = "gray90",
    color = "gray50",
    linewidth = 0.3
  ) +
  geom_path(
    data = ALAR_COMPARISON,
    aes(x = lon, y = lat),
    color = "black",
    linewidth = 1
  ) +
  geom_sf(
    data = ALAR_COMPARISON_sf,
    aes(color = over_land),
    size = 2
  ) +
  theme_minimal(base_size = 12) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_manual(values = c("blue", "red"), labels = c("Water", "Land"))


ALAR_COMPARISON_sf_split <- split(ALAR_COMPARISON_sf, ALAR_COMPARISON_sf$over_land)
land_ALAR <- ALAR_COMPARISON_sf_split$`TRUE`
water_ALAR <- ALAR_COMPARISON_sf_split$`FALSE`

library(sf)
obs_sf <- st_as_sf(obs_with_model, coords = c("lon", "lat"), crs = 4326)
obs_sf <- st_transform(obs_sf, st_crs(east_states_sf))
obs_sf$over_land <- lengths(st_intersects(obs_sf, east_states_sf)) > 0

obs_sf_split <- split(obs_sf, obs_sf$over_land)
land_model <- obs_sf_split$`TRUE`
water_model <- obs_sf_split$`FALSE`

keep <- c("land_model", "land_ALAR", "water_model", "water_ALAR")
rm(list= setdiff(ls(), keep))


sf_to_df <- function(sf_obj) {
  df <- cbind(st_drop_geometry(sf_obj), st_coordinates(sf_obj))
  names(df)[(ncol(df)-1):ncol(df)] <- c("lon", "lat")
  return(df)
}


water_ALAR <- sf_to_df(water_ALAR)
water_model <- sf_to_df(water_model)
land_ALAR <- sf_to_df(land_ALAR)
land_model <- sf_to_df(land_model)


library(ggplot2)
library(cowplot)
library(dplyr)
library(tidyr)

all_times <- seq(
  from = min(c(land_ALAR$time, water_ALAR$time)),
  to   = max(c(land_ALAR$time, water_ALAR$time)),
  by   = "10 min"  
)

land_complete <- land_ALAR %>%
  complete(time = all_times, fill = list(height_m = NA))

water_complete <- water_ALAR %>%
  complete(time = all_times, fill = list(height_m = NA))

p1 <- ggplot(land_complete, aes(x = time, y = height_m)) +
  geom_line() +
  geom_point() +
  labs(x = "Time", y = "Height (m)", title = "Land ALAR") +
  theme_minimal()

p2 <- ggplot(water_complete, aes(x = time, y = height_m)) +
  geom_line() +
  geom_point() +
  labs(x = "Time", y = "Height (m)", title = "Water ALAR") +
  theme_minimal()

plot_grid(p1, p2, ncol = 1)

# plot(land_ALAR$height_m[8:12])
# plot(land_ALAR$height_m[19:24])
# plot(land_ALAR$height_m[25:28])
# plot(land_ALAR$height_m[31:33])
# 
# plot(water_ALAR$height_m[14:15])


library(ggplot2)
library(dplyr)

land_ALAR <- land_ALAR %>%
  mutate(group = case_when(
    row_number() %in% 8:12  ~ "Segment1",
    row_number() %in% 19:24 ~ "Segment2",
    row_number() %in% 25:28 ~ "Segment3",
    row_number() %in% 31:33 ~ "Segment4",
    TRUE                     ~ "Other"
  ))

p_land <- ggplot(land_ALAR, aes(x = time, y = height_m, color = group, group = 1)) +
  geom_point() +
  scale_color_manual(values = c(
    "Segment1" = "red",
    "Segment2" = "blue",
    "Segment3" = "green",
    "Segment4" = "purple",
    "Other"    = "black"
  )) +
  labs(x = "Time", y = "Height (m)", title = "Land ALAR") +
  theme_minimal() 


water_ALAR <- water_ALAR %>%
  mutate(group = case_when(
    row_number() %in% 14:15 ~ "Segment1",
    TRUE                     ~ "Other"
  ))

p_water <- ggplot(water_ALAR, aes(x = time, y = height_m, color = group, group = 1)) +
  geom_point() +
  scale_color_manual(values = c(
    "Segment1" = "red",
    "Other"    = "black"
  )) +
  labs(x = "Time", y = "Height (m)", title = "Water ALAR") +
  theme_minimal()
library(cowplot)
plot_grid(p_land, p_water, ncol = 1)


idx_list <- list(8:12, 19:24, 25:28, 31:33)
cols <- c("red", "blue", "green", "purple")
plot(
  land_ALAR$wind_dir[idx_list[[1]]],
  land_model$wind_dir[idx_list[[1]]],
  xlab = "ALAR Wind Dir (°)",
  ylab = "Model Wind Dir (°)",
  main = "ALAR vs ERA5 Reanalysis Winds",
  col = cols[1],
  pch = 19,
  xlim = c(0,375),
  ylim = c(0,375)
)
for(i in 2:length(idx_list)) {
  points(
    land_ALAR$wind_dir[idx_list[[i]]],
    land_model$wind_dir[idx_list[[i]]],
    col = cols[i],
    pch = 19
  )
}
abline(a = 0, b = 1, lty = 2)


section_labels <- sapply(idx_list, function(ix) {
  start_time <- land_ALAR$time[min(ix)]
  end_time   <- land_ALAR$time[max(ix)]
  paste(format(start_time, "%H:%M"), format(end_time, "%H:%M"), sep = "–")
})
cols <- c("red", "blue", "green", "purple")
plot.new()
legend(
  "center",
  legend = section_labels,
  col = cols,
  pch = 19,
  title = "Time Range EDT",
  cex = 0.6
)



