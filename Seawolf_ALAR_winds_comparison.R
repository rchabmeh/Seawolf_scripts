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

min_time <- as.POSIXct(min(ALAR_5min$Time_local), tz = "America/New_York")
max_time <- as.POSIXct(max(ALAR_5min$Time_local), tz = "America/New_York")

min_time <- format(min_time, tz = "UTC", usetz = TRUE)
min_time <- as.POSIXct(min_time, tz = "UTC")
max_time <- format(max_time, tz = "UTC", usetz = TRUE)
max_time <- as.POSIXct(max_time, tz = "UTC")


u_list <- list()
for (nc_file in u_files) {
  u <- nc_open(nc_file)
  lon  <- ncvar_get(u, "longitude")
  lat  <- ncvar_get(u, "latitude")
  time <- ncvar_get(u, "time")
  time <- as.POSIXct(time * 3600, origin = "1900-01-01 00:00:00", tz = "UTC")
  
  time_sel <- time[time >= min_time & time <= max_time]
  time_indices <- which(time >= min_time & time <= max_time)
  if (length(time_indices) == 0) {
    message("No overlapping times for file: ", nc_file)
    nc_close(u)
    next
  }
  
  level <- u$dim$level$vals
  selected_levels <- level[100:137]
  
  for (lvl in selected_levels) {
    lvl_index <- which(level == lvl)
    
    if (length(time_indices) > 0) {
      U_component <- ncvar_get(
        u,
        "U",
        start = c(1, 1, lvl_index, min(time_indices)),
        count = c(-1, -1, 1, length(time_indices))
      )
    } else {
      next
    }
    
    lon_sel <- lon[lon >= min_lon & lon <= max_lon]
    lat_sel <- lat[lat >= min_lat & lat <= max_lat]
    
    df <- expand.grid(
      lon = lon_sel,
      lat = lat_sel,
      time = time_sel,
      level = lvl
    )
    
    lon_idx <- which(lon >= min_lon & lon <= max_lon)
    lat_idx <- which(lat >= min_lat & lat <= max_lat)
    if (length(lon_idx) == 0 | length(lat_idx) == 0) {
      message("No overlapping lon/lat for file: ", nc_file)
      next
    }
    
    U_sub <- U_component[lon_idx, lat_idx, , drop = FALSE]
    
    df$U <- as.vector(U_sub)
    
    new_name <- sub(
      ".*_u\\.regn320uv\\.(\\d{8})(\\d{2})_\\d{8}(\\d{2})\\.nc",
      "u_\\1_\\2-\\3",
      basename(nc_file)
    )
    df_name <- paste0(new_name, "_lvl", lvl)
    u_list[[df_name]] <- df
  }
  nc_close(u)
}

v_list <- list()
for (nc_file in v_files) {
  v <- nc_open(nc_file)
  lon  <- ncvar_get(v, "longitude")
  lat  <- ncvar_get(v, "latitude")
  time <- ncvar_get(v, "time")
  time <- as.POSIXct(time * 3600, origin = "1900-01-01 00:00:00", tz = "UTC")
  
  time_sel <- time[time >= min_time & time <= max_time]
  time_indices <- which(time >= min_time & time <= max_time)
  if (length(time_indices) == 0) {
    message("No overlapping times for file: ", nc_file)
    nc_close(v)
    next
  }
  
  level <- v$dim$level$vals
  selected_levels <- level[100:137]
  
  for (lvl in selected_levels) {
    lvl_index <- which(level == lvl)
    
    if (length(time_indices) > 0) {
      V_component <- ncvar_get(
        v,
        "V",
        start = c(1, 1, lvl_index, min(time_indices)),
        count = c(-1, -1, 1, length(time_indices))
      )
    } else {
      next
    }
    
    lon_sel <- lon[lon >= min_lon & lon <= max_lon]
    lat_sel <- lat[lat >= min_lat & lat <= max_lat]
    
    df <- expand.grid(
      lon = lon_sel,
      lat = lat_sel,
      time = time_sel,
      level = lvl
    )
    
    lon_idx <- which(lon >= min_lon & lon <= max_lon)
    lat_idx <- which(lat >= min_lat & lat <= max_lat)
    if (length(lon_idx) == 0 | length(lat_idx) == 0) {
      message("No overlapping lon/lat for file: ", nc_file)
      next
    }
    
    V_sub <- V_component[lon_idx, lat_idx, , drop = FALSE]
    
    df$V <- as.vector(V_sub)
    
    new_name <- sub(
      ".*_v\\.regn320uv\\.(\\d{8})(\\d{2})_\\d{8}(\\d{2})\\.nc",
      "u_\\1_\\2-\\3",
      basename(nc_file)
    )
    df_name <- paste0(new_name, "_lvl", lvl)
    v_list[[df_name]] <- df
  }
  nc_close(v)
}

merged_list <- mapply(function(df_u, df_v) {
  common_cols <- setdiff(names(df_u), "U")
  merge(df_u, df_v, by = common_cols, all = TRUE)
}, u_list, v_list, SIMPLIFY = FALSE)

names(merged_list) <- sapply(merged_list, function(df) {
  paste0("df_lvl_", unique(df$level))
})

nc <- nc_open(nc_file)
a_model <- ncvar_get(nc, "a_model")
b_model <- ncvar_get(nc, "b_model")

nc_close(nc)

# Approximate heights (meters) assuming standard surface pressure and constant temp
ps <- 101325          # Pa, standard surface pressure
T <- 273.15 + 15      # K, approx temperature
R <- 287.05           # J/(kg·K)
g <- 9.80665          # m/s^2

pressure <- a_model + b_model * ps
height <- -R * T / g * log(pressure / ps)
level_height <- data.frame(level = seq_along(a_model), height_m = height)
merged_list <- lapply(merged_list, function(df) {
  merge(df, level_height, by = "level", all.x = TRUE)
})

ALAR_COMPARISON <- data.frame(
  lon = ALAR_5min$Longitude_deg,
  lat = ALAR_5min$Latitude_deg,
  height_m = ALAR_5min$heightabvground_m,
  time = ALAR_5min$date
)
full_model_df <- do.call(rbind, merged_list)
find_closest <- function(df_model, df_obs) {
  # For each row in the obs dataset, find the closest model point
  df_obs$U <- NA
  df_obs$V <- NA
  
  for (i in seq_len(nrow(df_obs))) {
    obs <- df_obs[i, ]
    
    # Compute Euclidean distance in lon/lat/height (could weight height differently)
    dist <- (df_model$lon - obs$lon)^2 +
      (df_model$lat - obs$lat)^2 +
      (df_model$height - obs$height)^2
    
    # Optionally, also include time difference:
    time_diff <- as.numeric(difftime(df_model$time, obs$time, units = "secs"))
    dist <- dist + (time_diff / 3600)^2  # scale time in hours^2
    
    closest_idx <- which.min(dist)
    
    df_obs$U[i] <- df_model$U[closest_idx]
    df_obs$V[i] <- df_model$V[closest_idx]
  }
  
  return(df_obs)
}

obs_with_model <- find_closest(full_model_df, ALAR_COMPARISON)
obs_with_model$wind_speed <- sqrt(obs_with_model$U^2 + obs_with_model$V^2)

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
      xend = lon + U * arrow_scale,
      yend = lat + V * arrow_scale,
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
