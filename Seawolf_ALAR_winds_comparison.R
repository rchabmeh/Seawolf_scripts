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
####Using GRIB file ####
library(terra)
library(lubridate)

grib_file <- rast("/Users/reneechabot-mehlin/Downloads/ALAR.grib")

u.wind.comp.10m <- grib_file[[seq(2, nlyr(grib_file), by = 2)]]
v.wind.comp.10m <- grib_file[[seq(1, nlyr(grib_file), by = 2)]]

tvals <- time(grib_file)[seq(2, nlyr(grib_file), by = 2)]

names(u.wind.comp.10m) <- paste0("u10_", format(tvals, "%Y%m%d_%H"))
names(v.wind.comp.10m) <- paste0("v10_", format(tvals, "%Y%m%d_%H"))

wind_speed <- sqrt(u.wind.comp.10m^2 + v.wind.comp.10m^2)
names(wind_speed) <- paste0("speed_", format(tvals, "%Y%m%d_%H"))


wind_dir <- atan2(u.wind.comp.10m, v.wind.comp.10m) * 180 / pi
wind_dir <- (wind_dir + 360) %% 360
names(wind_dir) <- paste0("dir_", format(tvals, "%Y%m%d_%H"))

df <- data.frame(
  lon = ALAR_5min$Longitude_deg,
  lat = ALAR_5min$Latitude_deg,
  date_ny = ALAR_5min$Time_local
)

df$date_utc <- with_tz(df$date_ny, "UTC")
df$datetime_rounded <- lubridate::round_date(df$date_utc, "hour")
df$datetime_rounded <- as.POSIXct(df$datetime_rounded)

df$datetime_formatted <- format(df$datetime_rounded, "%Y%m%d_%H")

pts <- vect(df, geom = c("lon", "lat"), crs = "EPSG:4326")
pts <- project(pts, crs(wind_speed))

results_list <- list()

for (t in unique(df$datetime_formatted)) {
  layer_name <- paste0("speed_", t)
  if (layer_name %in% names(wind_speed)) {
    idx <- which(df$datetime_formatted == t)
    spd_vals <- terra::extract(wind_speed[[layer_name]], pts[idx, ])[, 2]
    s_index <- paste0(as.character(t), "_speed")
    results_list[[as.character(s_index)]] <- data.frame(idx = idx, wind_speed = spd_vals)
  }
  layer_name <- paste0("dir_", t)
  if (layer_name %in% names(wind_dir)) {
    idx <- which(df$datetime_formatted == t)
    dir_vals <- terra::extract(wind_dir[[layer_name]], pts[idx, ])[, 2]
    d_index <- paste0(as.character(t), "_dir")
    results_list[[as.character(d_index)]] <- data.frame(idx = idx, wind_dir = dir_vals)
  }
}

speed_df <- do.call(rbind, results_list[grep("_speed$", names(results_list))])
dir_df   <- do.call(rbind, results_list[grep("_dir$", names(results_list))])

results_df <- merge(speed_df, dir_df, by = "idx", all = TRUE)

df$wind_speed <- NA
df$wind_dir <- NA
df$wind_speed[results_df$idx] <- results_df$wind_speed
df$wind_dir[results_df$idx] <- results_df$wind_dir
df <- na.omit(df)

final_df <- data.frame(df[, c("date_utc",
                              "datetime_rounded",
                              "date_ny",
                              "lat",
                              "lon",
                              "wind_speed",
                              "wind_dir")])

u_model <- -final_df$wind_speed * sin(pi * final_df$wind_dir / 180)
v_model <- -final_df$wind_speed * cos(pi * final_df$wind_dir / 180)
lon_model <- final_df$lon
lat_model <- final_df$lat

wind_df_model <- data.frame(u = u_model,
                            v = v_model,
                            lon = lon_model,
                            lat = lat_model)

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
    data = wind_df_model,
    aes(
      x = lon,
      y = lat,
      xend = lon + u * arrow_scale,
      yend = lat + v * arrow_scale,
      color = df$wind_speed
    ),
    arrow = arrow(length = unit(0.15, "cm")),
    linewidth = 0.5
  ) +
  geom_point(data = wind_df_model,
             aes(
               x = lon,
               y = lat,
               color = df$wind_speed
             ),
             size = 1) +
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(39.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged ERA5-Reanalysis (10m) Hourly Wind Vectors over ALAR Flight Path (7/2/2025)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

ALAR_5min$Time_local == final_df$date_ny

#### Comparison of wind dir vectors #####
library(ggplot2)
library(tidyr)
library(dplyr)

plot_df <- bind_rows(
  final_df %>% select(time = date_ny, wind_dir) %>% mutate(Source = "ERA5"),
  ALAR_5min %>% select(time = Time_local, wind_dir = w_dir) %>% mutate(Source = "Measurement")
)

ggplot(plot_df, aes(x = time, y = wind_dir, color = Source)) +
  geom_line(size = 1) +
  scale_color_manual(values = c("Measurement" = "red", "ERA5" = "black")) +
  scale_y_continuous(limits = c(0, 350), expand = c(0,0)) +
  labs(
    x = "Local Time",
    y = "Wind Direction (°)",
    title = "Comparison of Wind Direction: Measured vs. ERA_Reanalysis for ALAR 7/2/25 Flight"
  ) +
  theme(
    legend.position = "bottom") +
theme_minimal(base_size = 14)

boxplot(
  wind_dir ~ Source,
  data = plot_df,
  main =  "Wind Direction sorted by Wind Source",
  ylab = "Wind Direction (°)"
) 
#### Comparison of wind speed vectors #####
library(ggplot2)
library(tidyr)
library(dplyr)

plot_df <- bind_rows(
  final_df %>% select(time = date_ny, wind_speed) %>% mutate(Source = "ERA5"),
  ALAR_5min %>% select(time = Time_local, wind_speed = w_spd) %>% mutate(Source = "Measurement")
)

ggplot(plot_df, aes(x = time, y = wind_speed, color = Source)) +
  geom_line(size = 1) +
  scale_color_manual(values = c("Measurement" = "red", "ERA5" = "black")) +
  scale_y_continuous(limits = c(0, 10), expand = c(0,0)) +
  labs(
    x = "Local Time",
    y = "Wind Speed (m/s)",
    title = "Comparison of Wind Speed: Measured vs. ERA_Reanalysis for ALAR 7/2/25 Flight"
  ) +
  theme(
    legend.position = "bottom") +
  theme_minimal(base_size = 14)

boxplot(
  wind_speed ~ Source,
  data = plot_df,
  main =  "Wind Speeds sorted by Wind Source",
  ylab = "Wind Speed (m/s)"
)


##### .nc files ####
#they are in here: /Users/reneechabot-mehlin/Downloads/alar_winds_file