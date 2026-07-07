##### ALAR file #####
ALAR <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/csv files/2025-07-02_ALAR_1hz.csv')
ALAR$Time_local <- as.POSIXct(ALAR$Time_local, origin = "1904-01-01", tz = "America/New_York")
ALAR$Time_UTC <- as.POSIXct(ALAR$Time_UTC, origin = "1904-01-01", tz = "UTC")

library(openair)
colnames(ALAR)[colnames(ALAR) == "Time_UTC"] <- "date"

ALAR_10sec <- timeAverage(ALAR,
                         #avg.time = "10 sec",
                         avg.time = "5 min",
                         data.thresh = 0,
                         statistic = "mean")

ALAR_10sec <- ALAR_10sec[!is.na(ALAR_10sec$Latitude_deg), ]
#ALAR_10sec <- ALAR_10sec[!is.na(ALAR_10sec$CO2), ]
t <- format(ALAR_10sec$date, "%H:%M:%S")

# ALAR_10sec <- ALAR_10sec[
#   !(t >= "16:07:00" & t <= "16:15:59"),
# ]
cols_to_keep <- c("date", 
                  "w_dir" ,
                  "w_spd", 
                  "Latitude_deg", "Longitude_deg", "HeightAbvMSL_m", "heightabvground_m","CO2","CH4")
ALAR_10sec <- ALAR_10sec[, cols_to_keep]

##### ERA5 file #######
library(ncdf4)
library(dplyr)
era5 <- nc_open('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/era5 files/7-2-25-era5-reanalysis.nc')
lon  <- ncvar_get(era5, "longitude")
lat  <- ncvar_get(era5, "latitude")

time <- ncvar_get(era5, "valid_time")
time <- as.POSIXct(time , origin = "1970-01-01 00:00:00", tz = "UTC") #3600 converts hrs -> sec


u <- ncvar_get(era5, "u")
v <- ncvar_get(era5, "v")
z <- ncvar_get(era5, "z")

g <- 9.80665
height_msl <- z / g


min_time <- as.POSIXct(min(ALAR_10sec$date), tz = "UTC")
max_time <- as.POSIXct(max(ALAR_10sec$date), tz = "UTC")

time_indices <- which(time >= min_time & time <= max_time)
if (length(time_indices) == 0) {
  message("No overlapping times for file: ", era5) #check to basically make sure I load in the right file
  nc_close(era5)
  next
}
time_sel <- time[time_indices]

level <- ncvar_get(era5, "pressure_level") 


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


final <- ALAR_10sec


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
  
  if (nrow(era_space) == 0) {
    matched[[i]] <- NULL
    next
  }
  
  hi <- nearest_index(era_space$ht, obs_h)
  
  if (length(hi) == 0 || is.na(hi) || hi > nrow(era_space)) {
    matched[[i]] <- NULL
    next
  }
  
  matched[[i]] <- cbind(
    final[i, ],
    era_space[hi, c("u", "v", "pressure_level", "ht")]
  )
}

matched_clean <- matched[!sapply(matched, is.null)]

matched_df <- do.call(rbind, matched_clean)


##### comparing heights #####
library(ggplot2)

# Prepare long-format data
height_df <- data.frame(
  time = matched_df$date,
  height_agl = matched_df$heightabvground_m,
  height_msl = matched_df$HeightAbvMSL_m,
  ht_ERA5 = matched_df$ht
)

height_long <- rbind(
  data.frame(time = height_df$time, variable = "Height Above Ground (m)", value = height_df$height_ag),
  data.frame(time = height_df$time, variable = "Height Above MSL (m)", value = height_df$height_msl),
  data.frame(time = height_df$time, variable = "Height calculated ERA5 (m)", value = height_df$ht_ERA5)
)

# Plot
ht <- ggplot(height_long, aes(x = time, y = value, color = variable)) +
  geom_line(size = 0.8) +
  geom_point(size = 1) +
  labs(
    x = "Time (UTC)",
    y = "Height (m)",
    color = "Variable",
    title = "Comparison of Height Variables Over Time (10s average)"
  ) +
  theme_bw() +
  theme(legend.position = "top")

ht

##### combined plotting #####

wind_speed <- (matched_df$w_spd/1.944) #knots to m/s
wind_dir <- matched_df$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- matched_df$Longitude_deg
lat <- matched_df$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat, wind_speed)

era5_wind_speed <- sqrt(matched_df$u^2 + matched_df$v^2)
wind_df_era5 <- data.frame(u = matched_df$u, v = matched_df$v, lon, lat, wd_sd = era5_wind_speed)
##comparing scaling same
library(ggplot2)
wind_comp <- data.frame(
   u_obs  = wind_df_obs$u,
   v_obs  = wind_df_obs$v,
  u_era5 = wind_df_era5$u,
  v_era5 = wind_df_era5$v,
   speed_obs = wind_df_obs$wind_speed,
  speed_era5 = wind_df_era5$wd_sd
)
 wind_comp$dir_obs  <- (270 - atan2(wind_comp$v_obs,  wind_comp$u_obs)  * 180/pi) %% 360
wind_comp$dir_era5 <- (270 - atan2(wind_comp$v_era5, wind_comp$u_era5) * 180/pi) %% 360
wind_long <- data.frame(
  component = rep(c("speed", "direction"), each = nrow(wind_comp)),
   obs  = c(wind_comp$speed_obs,
            wind_comp$dir_obs),
  era5 = c(wind_comp$speed_era5,
           wind_comp$dir_era5)
)
library(dplyr)
lims_df <- wind_long %>%
  group_by(component) %>%
  summarise(
    min_val = min(c(
      obs, 
      era5), na.rm = TRUE),
    max_val = max(c(
      obs, 
      era5), na.rm = TRUE)
  )
wind_long <- merge(wind_long, lims_df, by = "component")
##regression
stats_df <- do.call(rbind, lapply(split(wind_long, wind_long$component), function(df) {
  fit <- lm(era5 ~ obs, data = df)
  data.frame(
    component = unique(df$component),
    intercept = coef(fit)[1],
    slope = coef(fit)[2],
    r2 = summary(fit)$r.squared
  )
}))
wind_long <- merge(wind_long, stats_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text(
    data = stats_df,
    aes(
      x = -Inf,
      y = Inf,
      label = paste0(
        "y = ",
        round(slope, 2), "x + ",
        round(intercept, 2),
        "\nR² = ",
        round(r2, 3)
      )
    ),
    hjust = -0.1,
    vjust = 1.1,
    inherit.aes = FALSE
  ) +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison") +
  theme_bw()
##
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
all_speeds <- c(wind_df_obs$speed, era5_wind_speed)

spd_min <- min(all_speeds, na.rm = TRUE)
spd_max <- max(all_speeds, na.rm = TRUE)






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
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(limits = c(spd_min, spd_max), option = "plasma", name = "Wind speed (m/s)") +
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
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(limits = c(spd_min, spd_max), option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "ERA5-Reanalysis Wind Vectors over ALAR Flight Path (7/2/2025)",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

library(cowplot)

plot_grid(p1, p2)

#### separate land and water #####
library(sf)
library(maps)
sf_use_s2(FALSE)
df_sf <- st_as_sf(matched_df,
                  coords = c("Longitude_deg", "Latitude_deg"),
                  crs = 4326)
df_sf$Latitude_deg <- matched_df$Latitude_deg
df_sf$Longitude_deg <- matched_df$Longitude_deg
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_sf <- st_set_crs(world_sf, 4326)

df_sf$land <- lengths(st_intersects(df_sf, world_sf)) > 0

land_points  <- df_sf[df_sf$land, ]
ocean_points <- df_sf[!df_sf$land, ]

##### colored land vs water #####
plot_df <- data.frame(
  time = matched_df$date,
  co2  = matched_df$CO2,
  ch4  = matched_df$CH4,
  surface = ifelse(df_sf$land, "Land", "Ocean")
)
plot_long <- rbind(
  data.frame(time = plot_df$time,
             species = "CO2",
             value = plot_df$co2,
             surface = plot_df$surface),
  
  data.frame(time = plot_df$time,
             species = "CH4",
             value = plot_df$ch4,
             surface = plot_df$surface)
)

co2_min <- 425
co2_max <- 445

ch4_min <- 2
ch4_max <- 2.3

plot_long$value <- ifelse(
  plot_long$species == "CO2",
  pmin(pmax(plot_long$value, co2_min), co2_max),
  pmin(pmax(plot_long$value, ch4_min), ch4_max)
)

library(ggplot2)

cc <- ggplot(plot_long,
       aes(x = time, y = value, color = surface)) +
  geom_point(size = 3) +
  geom_line(aes(group = 1, colour = "black"), alpha = 0.6) +
  facet_wrap(~species, scales = "free_y") +
  scale_color_manual(values = c("Land" = "forestgreen",
                                "Ocean" = "royalblue")) +
  coord_cartesian(xlim = as.POSIXct(c("2024-03-18 15:00:00",
                                      "2024-03-18 16:30:00"), tz = "UTC"))+
  
  labs(x = "Time (UTC)",
       y = "(ppm)",
       color = "Surface Type",
       title = "CO2 and CH4 Along Flight Path: Land vs Ocean 10s average 3/18/24") +
  theme_bw()


cc


##### combined plotting #####
library(cowplot)

p3 <- ggplot() +
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
  
  coord_sf(
    xlim = c(-77, -72),
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  labs(
    title = "ALAR Flight Path (3/18/2024)",
    x = "Longitude",
    y = "Latitude",
  ) +
  theme_minimal(base_size = 12)


library(cowplot)

top_row <- plot_grid(p3, ht, ncol = 2)
bottom_row <- plot_grid(cc, ncol = 1)

plot_grid(top_row, bottom_row, ncol = 1, rel_heights = c(1, 1))




##### ocean plots #####
wind_speed <- (ocean_points$w_spd/1.944) #knots to m/s
wind_dir <- ocean_points$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- ocean_points$Longitude_deg
lat <- ocean_points$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat, wind_speed)

era5_wind_speed <- sqrt(ocean_points$u^2 + ocean_points$v^2)
wind_df_era5 <- data.frame(u = ocean_points$u, v = ocean_points$v, lon, lat, wd_sd = era5_wind_speed)
##comparing scaling same
library(ggplot2)
wind_comp <- data.frame(
  u_obs  = wind_df_obs$u,
  v_obs  = wind_df_obs$v,
  u_era5 = wind_df_era5$u,
  v_era5 = wind_df_era5$v,
  speed_obs = wind_df_obs$wind_speed,
  speed_era5 = wind_df_era5$wd_sd
)
wind_comp$dir_obs  <- (270 - atan2(wind_comp$v_obs,  wind_comp$u_obs)  * 180/pi) %% 360
wind_comp$dir_era5 <- (270 - atan2(wind_comp$v_era5, wind_comp$u_era5) * 180/pi) %% 360
wind_long <- data.frame(
  component = rep(c("speed", "direction"), each = nrow(wind_comp)),
  obs  = c(wind_comp$speed_obs,
           wind_comp$dir_obs),
  era5 = c(wind_comp$speed_era5,
           wind_comp$dir_era5)
)
library(dplyr)
lims_df <- wind_long %>%
  group_by(component) %>%
  summarise(
    min_val = min(c(obs, era5), na.rm = TRUE),
    max_val = max(c(obs, era5), na.rm = TRUE)
  )
wind_long <- merge(wind_long, lims_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_wrap(~ component, scales = "free") +
  geom_blank(aes(x = min_val, y = min_val)) +
  geom_blank(aes(x = max_val, y = max_val)) +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison Over Ocean") +
  theme_bw()
##comparing scaling diff

ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Ocean") +
  theme_bw()
##regression
stats_df <- do.call(rbind, lapply(split(wind_long, wind_long$component), function(df) {
  fit <- lm(era5 ~ obs, data = df)
  data.frame(
    component = unique(df$component),
    intercept = coef(fit)[1],
    slope = coef(fit)[2],
    r2 = summary(fit)$r.squared
  )
}))
wind_long <- merge(wind_long, stats_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text(
    data = stats_df,
    aes(
      x = -Inf,
      y = Inf,
      label = paste0(
        "y = ",
        round(slope, 2), "x + ",
        round(intercept, 2),
        "\nR² = ",
        round(r2, 3)
      )
    ),
    hjust = -0.1,
    vjust = 1.1,
    inherit.aes = FALSE
  ) +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Ocean") +
  theme_bw()
##
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
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (3/18/2024) Ocean Only",
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
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "ERA5-Reanalysis Wind Vectors over ALAR Flight Path (3/18/2024) Ocean Only",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

library(cowplot)

plot_grid(p1, p2)

##### land plots #####
wind_speed <- (land_points$w_spd/1.944) #knots to m/s
wind_dir <- land_points$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- land_points$Longitude_deg
lat <- land_points$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat, wind_speed)

era5_wind_speed <- sqrt(land_points$u^2 + land_points$v^2)
wind_df_era5 <- data.frame(u = land_points$u, v = land_points$v, lon, lat, wd_sd = era5_wind_speed)
##comparing scaling same
library(ggplot2)
wind_comp <- data.frame(
  u_obs  = wind_df_obs$u,
  v_obs  = wind_df_obs$v,
  u_era5 = wind_df_era5$u,
  v_era5 = wind_df_era5$v,
  speed_obs = wind_df_obs$wind_speed,
  speed_era5 = wind_df_era5$wd_sd
)
wind_comp$dir_obs  <- (270 - atan2(wind_comp$v_obs,  wind_comp$u_obs)  * 180/pi) %% 360
wind_comp$dir_era5 <- (270 - atan2(wind_comp$v_era5, wind_comp$u_era5) * 180/pi) %% 360
wind_long <- data.frame(
  component = rep(c("speed", "direction"), each = nrow(wind_comp)),
  obs  = c(wind_comp$speed_obs,
           wind_comp$dir_obs),
  era5 = c(wind_comp$speed_era5,
           wind_comp$dir_era5)
)
library(dplyr)
lims_df <- wind_long %>%
  group_by(component) %>%
  summarise(
    min_val = min(c(obs, era5), na.rm = TRUE),
    max_val = max(c(obs, era5), na.rm = TRUE)
  )
wind_long <- merge(wind_long, lims_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_wrap(~ component, scales = "free") +
  geom_blank(aes(x = min_val, y = min_val)) +
  geom_blank(aes(x = max_val, y = max_val)) +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Land") +
  theme_bw()
##comparing scaling diff

ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Land") +
  theme_bw()
##regression
stats_df <- do.call(rbind, lapply(split(wind_long, wind_long$component), function(df) {
  fit <- lm(era5 ~ obs, data = df)
  data.frame(
    component = unique(df$component),
    intercept = coef(fit)[1],
    slope = coef(fit)[2],
    r2 = summary(fit)$r.squared
  )
}))
wind_long <- merge(wind_long, stats_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text(
    data = stats_df,
    aes(
      x = -Inf,
      y = Inf,
      label = paste0(
        "y = ",
        round(slope, 2), "x + ",
        round(intercept, 2),
        "\nR² = ",
        round(r2, 3)
      )
    ),
    hjust = -0.1,
    vjust = 1.1,
    inherit.aes = FALSE
  ) +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Land") +
  theme_bw()
##
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
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "5-Minute Averaged Wind Vectors over ALAR Flight Path (3/18/2024) Land Only",
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
    ylim = c(38.5, 41.5),
    expand = FALSE
  ) +
  scale_color_viridis_c(option = "plasma", name = "Wind speed (m/s)") +
  labs(
    title = "ERA5-Reanalysis Wind Vectors over ALAR Flight Path (3/18/2024) Land Only",
    x = "Longitude",
    y = "Latitude",
    subtitle = paste0("The arrow scaling is: ", arrow_scale, "%")
  ) +
  theme_minimal(base_size = 12)

library(cowplot)

plot_grid(p1, p2)

##### saving ocean/land .csv for future comparison #####
land_path <- '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/land csv files/'
ocean_path <- '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/ocean csv files/'
date_of_interest <- "3-18-2024"
write.csv(ocean_points,paste0(ocean_path,date_of_interest, ".csv") )
write.csv(land_points, paste0(land_path, date_of_interest, ".csv") )
##### future comparison- combined sources for ocean #####
df1 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/ocean csv files/1-22-2023.csv') 
df2 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/ocean csv files/3-2-2021.csv')
df3 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/ocean csv files/3-3-2021.csv')
df4 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/ocean csv files/3-18-2024.csv')
df5 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/ocean csv files/7-2-2025.csv')

library(dplyr)
df_list <- list(df1,df2,df3,df4,df5)
ocean_points <- bind_rows(df_list)
# Example: remove all column names
colnames(ocean_points) <- NULL

# Now assign new names
colnames(ocean_points) <- c("date", "w_dir", "w_spd", "HeightAbvMSL_m", 
                  "heightabvground_m", "u", "v", "pressure_level", 
                  "ht", "geometry", "geometry_pt2", "Latitude_deg", "Longitude_deg", "land")

wind_speed <- (ocean_points$w_spd/1.944) #knots to m/s
wind_dir <- ocean_points$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- ocean_points$Longitude_deg
lat <- ocean_points$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat, wind_speed)

era5_wind_speed <- sqrt(ocean_points$u^2 + ocean_points$v^2)
wind_df_era5 <- data.frame(u = ocean_points$u, v = ocean_points$v, lon, lat, wd_sd = era5_wind_speed)
##comparing scaling same
library(ggplot2)
wind_comp <- data.frame(
  u_obs  = wind_df_obs$u,
  v_obs  = wind_df_obs$v,
  u_era5 = wind_df_era5$u,
  v_era5 = wind_df_era5$v,
  speed_obs = wind_df_obs$wind_speed,
  speed_era5 = wind_df_era5$wd_sd
)
wind_comp$dir_obs  <- (270 - atan2(wind_comp$v_obs,  wind_comp$u_obs)  * 180/pi) %% 360
wind_comp$dir_era5 <- (270 - atan2(wind_comp$v_era5, wind_comp$u_era5) * 180/pi) %% 360
wind_long <- data.frame(
  component = rep(c("speed", "direction"), each = nrow(wind_comp)),
  obs  = c(wind_comp$speed_obs,
           wind_comp$dir_obs),
  era5 = c(wind_comp$speed_era5,
           wind_comp$dir_era5)
)
library(dplyr)
lims_df <- wind_long %>%
  group_by(component) %>%
  summarise(
    min_val = min(c(obs, era5), na.rm = TRUE),
    max_val = max(c(obs, era5), na.rm = TRUE)
  )
wind_long <- merge(wind_long, lims_df, by = "component")

##regression
stats_df <- do.call(rbind, lapply(split(wind_long, wind_long$component), function(df) {
  fit <- lm(era5 ~ obs, data = df)
  data.frame(
    component = unique(df$component),
    intercept = coef(fit)[1],
    slope = coef(fit)[2],
    r2 = summary(fit)$r.squared
  )
}))
wind_long <- merge(wind_long, stats_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text(
    data = stats_df,
    aes(
      x = -Inf,
      y = Inf,
      label = paste0(
        "y = ",
        round(slope, 2), "x + ",
        round(intercept, 2),
        "\nR² = ",
        round(r2, 3)
      )
    ),
    hjust = -0.1,
    vjust = 1.1,
    inherit.aes = FALSE
  ) +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Ocean") +
  theme_bw()
##### future comparison- combined sources for land #####
df1 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/land csv files/1-22-2023.csv')
df2 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/land csv files/3-2-2021.csv')
df3 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/land csv files/3-3-2021.csv')
df4 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/land csv files/3-18-2024.csv')
df5 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/winds_comparison_alar_over_ocean/land csv files/7-2-2025.csv')

library(dplyr)
df_list <- list(df1,df2,df3,df4,df5)
land_points <- bind_rows(df_list)

colnames(land_points) <- NULL

# Now assign new names
colnames(land_points) <- c("date", "w_dir", "w_spd", "HeightAbvMSL_m", 
                            "heightabvground_m", "u", "v", "pressure_level", 
                            "ht", "geometry", "geometry_pt2", "Latitude_deg", "Longitude_deg", "land")



wind_speed <- (land_points$w_spd/1.944) #knots to m/s
wind_dir <- land_points$w_dir
u <- -wind_speed * sin(pi * wind_dir / 180)
v <- -wind_speed * cos(pi * wind_dir / 180)
lon <- land_points$Longitude_deg
lat <- land_points$Latitude_deg

wind_df_obs <- data.frame(u, v, lon, lat, wind_speed)

era5_wind_speed <- sqrt(land_points$u^2 + land_points$v^2)
wind_df_era5 <- data.frame(u = land_points$u, v = land_points$v, lon, lat, wd_sd = era5_wind_speed)
##comparing scaling same
library(ggplot2)
wind_comp <- data.frame(
  u_obs  = wind_df_obs$u,
  v_obs  = wind_df_obs$v,
  u_era5 = wind_df_era5$u,
  v_era5 = wind_df_era5$v,
  speed_obs = wind_df_obs$wind_speed,
  speed_era5 = wind_df_era5$wd_sd
)
wind_comp$dir_obs  <- (270 - atan2(wind_comp$v_obs,  wind_comp$u_obs)  * 180/pi) %% 360
wind_comp$dir_era5 <- (270 - atan2(wind_comp$v_era5, wind_comp$u_era5) * 180/pi) %% 360
wind_long <- data.frame(
  component = rep(c("speed", "direction"), each = nrow(wind_comp)),
  obs  = c(wind_comp$speed_obs,
           wind_comp$dir_obs),
  era5 = c(wind_comp$speed_era5,
           wind_comp$dir_era5)
)
library(dplyr)
lims_df <- wind_long %>%
  group_by(component) %>%
  summarise(
    min_val = min(c(obs, era5), na.rm = TRUE),
    max_val = max(c(obs, era5), na.rm = TRUE)
  )
wind_long <- merge(wind_long, lims_df, by = "component")

##regression
stats_df <- do.call(rbind, lapply(split(wind_long, wind_long$component), function(df) {
  fit <- lm(era5 ~ obs, data = df)
  data.frame(
    component = unique(df$component),
    intercept = coef(fit)[1],
    slope = coef(fit)[2],
    r2 = summary(fit)$r.squared
  )
}))
wind_long <- merge(wind_long, stats_df, by = "component")
ggplot(wind_long, aes(x = obs, y = era5)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text(
    data = stats_df,
    aes(
      x = -Inf,
      y = Inf,
      label = paste0(
        "y = ",
        round(slope, 2), "x + ",
        round(intercept, 2),
        "\nR² = ",
        round(r2, 3)
      )
    ),
    hjust = -0.1,
    vjust = 1.1,
    inherit.aes = FALSE
  ) +
  facet_wrap(~ component, scales = "free") +
  labs(x = "Observed",
       y = "ERA5",
       title = "Observed vs ERA5 Wind Comparison over Land") +
  theme_bw()




# CO2 map with manual scaling
p_co2 <- ggplot() +
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
  geom_point(
    data = matched_df,
    aes(x = Longitude_deg, y = Latitude_deg, color = CO2),
    size = 2
  ) +
  coord_sf(xlim = c(-76, -72), ylim = c(40, 41.5), expand = FALSE) +
  scale_color_viridis_c(
    option = "plasma",
    limits = c(417, 424),   # manual range for CO2
    na.value = "grey80",
    name = "CO2 (ppm)"
  ) +
  labs(title = "CO2 over ALAR Flight Path", x = "Longitude", y = "Latitude") +
  theme_minimal(base_size = 12)

# CH4 map with manual scaling
p_ch4 <- ggplot() +
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
  geom_point(
    data = matched_df,
    aes(x = Longitude_deg, y = Latitude_deg, color = CH4),
    size = 2
  ) +
  coord_sf(xlim = c(-76, -72), ylim = c(40, 41.5), expand = FALSE) +
  scale_color_viridis_c(
    option = "plasma",
    limits = c(1.959709, 2.002),  # manual range for CH4
    na.value = "grey80",
    name = "CH4 (ppb)"
  ) +
  labs(title = "CH4 over ALAR Flight Path", x = "Longitude", y = "Latitude") +
  theme_minimal(base_size = 12)

# Combine plots
plot_grid(p_co2, p_ch4, labels = c("A", "B"), ncol = 2, align = "hv")
