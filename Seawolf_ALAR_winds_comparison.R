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
    
    df_model_near <- df_model[abs(difftime(df_model$time, obs$time, units = "hours")) <= time_window_hours, ]
    if (nrow(df_model_near) == 0)
      next
    
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
