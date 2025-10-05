#File comparing Eulerian .nc files to cruise data
#####Trajectory data_______________________________________________________#####
final_filtered_trajectories <- readRDS('/Volumes/Seagate/cruise14_eulerian/14final_traj.RData')
traj_dates <- vector("list", length(final_filtered_trajectories))
for (i in seq_along(final_filtered_trajectories)) {
  traj_dates[[i]] <- as.Date(final_filtered_trajectories[[i]][[14]][[1]], tz = "America/New_York")
}
traj_times <-vector("list", length(final_filtered_trajectories))
for (i in seq_along(final_filtered_trajectories)){
  traj_times[[i]] <- as.POSIXct(final_filtered_trajectories[[i]][[14]][[1]], tz = "America/New_York")
}

#####Time intervals________________________________________________________#####
library(ncdf4)
library(raster)
library(lubridate)

files <- list.files(
  '/Volumes/Seagate/cruise14_eulerian/carbon_tracker_co2_total',
  pattern = '*.nc',
  full.names = TRUE
)
nc <- nc_open(files[[1]])
time_vals <- nc$dim$time$vals
origin <- as.POSIXct("2000-01-01 00:00:00", tz = "UTC")
actual_time <- origin + time_vals * 86400

# Define time window (±1.5 hours)
start_times <- actual_time - 1.5 * 3600
end_times   <- actual_time + 1.5 * 3600

# Labels in UTC
interval_labels <- data.frame(
  Times_UTC = paste0(
    format(start_times, "%H:%M"),
    "–",
    format(end_times, "%H:%M UTC")
  ),
  Grouping = 1:length(start_times)
)

# Convert to America/New_York time
start_ny <- lubridate::with_tz(start_times, tzone = "America/New_York")
end_ny   <- lubridate::with_tz(end_times, tzone = "America/New_York")

interval_labels$Times_NY <- paste0(
  format(start_ny, "%H:%M"),
  "–",
  format(end_ny, "%H:%M %Z")
)

# If you're dealing with daylight saving, use %Z instead of hardcoding "EST"
# format(start_ny, "%H:%M %Z")

print(interval_labels)

#####LOADING IN TOWERS_____________________________________________________#####
twr <-read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv") 
#twr <- twr[twr$SiteCode == "LEW", ] 
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]

#####Carbon tracker CO2___________________________________________________######
#This file contains CarbonTracker mole fractions averaged over each time interval.
#The times on the date axis are the centers of each averaging period in UTC:
#The vertical resolution of TM5 in CarbonTracker is 34 hybrid sigma-pressure levels.
#These levels are unevenly spaced, with more levels near the surface.
#Approximate heights of the mid-levels (in meters, with a surface pressure of 1012 hPa) are:
#1	34.5 meters
#2	111.9	meters
#3	256.9	meters
#4	490.4	meters
#5	826.4	meters
#6	1274.1 meters
#7	1839.0 meters
#8	2524.0 meters
#9	3329.9 meters
#10	4255.6 meters
library(raster)
CT_CO2 <- list()
files <- list.files(
  '/Volumes/Seagate/cruise14_eulerian/carbon_tracker_co2_total',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
  CT_CO2[[i]] <- nc
}
library(ggplot2)
library(sf)
library(raster)
library(dplyr)
library(fields)
library(paletteer)
states <- st_read(
  "/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k"
)
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
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states) %>%
  st_transform(crs = st_crs(CT_CO2[[1]]))
east_extent <- extent(-85, -65, 25, 47)
all_vals <- c()
for (j in seq(final_filtered_trajectories)) {
  hr <- (format(as.POSIXct(final_filtered_trajectories[[j]][["Starting.Date.Time"]][[1]]), format = '%H:%M'))
  final_filtered_trajectories[[j]] <- cbind(final_filtered_trajectories[[j]], Hour = hr)
}
CTCO2_5 <- list()
CTCO2_6 <- list()
CTCO2_7 <- list()
for (i in seq_along(CT_CO2)) {
  CTCO2_5[[i]] <- CT_CO2[[i]][[5]] 
  CTCO2_6[[i]] <- CT_CO2[[i]][[6]] 
  CTCO2_7[[i]] <- CT_CO2[[i]][[7]] 
}
#####TIME FIVE_____________________________________________________________#####
traj_df_5 <- list()
for (k in seq_along(CT_CO2)) {
  name_string <- CT_CO2[[k]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  for (m in 1:8) {
    if (identical(CTCO2_5[[k]], CT_CO2[[k]][[m]])) {
      match_indices <- which(traj_dates == target_date)
      
      legend_info <- list()
      for (j in match_indices) {
        traj_data <- final_filtered_trajectories[[j]]
        if (!is.null(traj_data) && "Hour" %in% names(traj_data)) {
          matched_rows <- traj_data[traj_data$Hour %in% c("08:00", "09:00", "10:00", "11:00"), ]
          
          if (nrow(matched_rows) > 0) {
            traj_df_5[[length(traj_df_5) + 1]] <- matched_rows
          
            print(paste(
              "Date is",
              target_date,
              "and time is",
              paste(unique(matched_rows$Hour), collapse = ", ")
            
            ))
          }
        }
      }
    }
  }
}
all_vals_5EAST <- c()
for (i in seq_along(CT_CO2)) {
  CTCO2_5EAST <- crop(CTCO2_5[[i]][[1]], east_extent)
  all_vals_5EAST <- c(all_vals_5EAST, values(CTCO2_5EAST))
}
z_range_5EAST <- range(all_vals_5EAST, na.rm = TRUE)

traj_dates5 <- vector("list", length(traj_df_5))
for (i in seq_along(traj_df_5)) {
  traj_dates5[[i]] <- as.Date(traj_df_5[[i]][[14]][[1]], tz = "America/New_York")
}
start_tile_values <- list()
for (i in seq_along(CTCO2_5)) {
  cropped_raster <- crop(CTCO2_5[[i]][[1]], east_extent)
  raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
  colnames(raster_df) <- c("x", "y", "CO2_ppm")
  
  name_string <- CTCO2_5[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*", "\\1-\\2-\\3", name_string)
  target_date <- as.Date(date_string)
  
  p <- ggplot() +
    geom_tile(data = raster_df, aes(x = x, y = y, fill = CO2_ppm)) +
    geom_text(
      data = raster_df,
      aes(x = x, y = y, label = round(CO2_ppm, 3)),
      size = 2.5,
      color = "black"
    ) +
    geom_sf(data = east_states_sf, fill = NA, color = "grey", linewidth = 0.4) +
    scale_fill_gradientn(colors = fields::tim.colors(),
                         limits = z_range_5EAST,
                         name = "ppm CO2") +
    coord_sf(xlim = c(-80, -70), ylim = c(38, 42), expand = FALSE) +
    labs(
      title = paste(
        "CT CO2: Cruise #14 averaged",
        date_string,
        "(time period 8-11 EDT)"
      ),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  
  # Add trajectories
  colors <- paletteer_c("grDevices::rainbow", n = length(traj_dates5))
  match_indices <- which(traj_dates5 == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      traj_df <- traj_df_5[[match_indices[j]]]
      start_point <- traj_df[1, c("Longitude", "Latitude")]
      tile_value <- raster::extract(cropped_raster,
                                    matrix(c(start_point$Longitude, start_point$Latitude), ncol = 2))
      key <- paste0(as.character(target_date), "_traj", j)
      start_tile_values[[key]] <- as.numeric(tile_value)
      traj_color <- colors[match_indices[j]]
      p <- p +
        geom_path(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          color = "black",
          size = 0.5
        ) +
        geom_point(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          bg = traj_color,
          color = "black",
          size = 1.2,
          stroke = 0.5,
          shape = 21
        )
    }
  }
  
  # ---- Add tower locations ----
  p <- p +
    geom_point(
      data = twr,
      aes(x = Lon, y = Lat),
      shape = 23,          # diamond shape
      size = 3,
      fill = "black",
      color = "black"
    ) +
    geom_text(
      data = twr,
      aes(x = Lon, y = Lat, label = SiteCode),
      hjust = -0.3,        # label slightly to the right
      vjust = 0.3,
      size = 3
    )
  
  print(p)
}
legend_text2 <- c()
for (i in seq_along(traj_dates5)) {
  date <- lapply(traj_df_5[[1]][["Starting.Date.Time"]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 14",
  text.font = 3,
  col = colors,
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#####TIME SIX______________________________________________________________#####
for (k in seq_along(CT_CO2)) {
  name_string <- CT_CO2[[k]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  for (m in 1:8) {
    if (identical(CTCO2_6[[k]], CT_CO2[[k]][[m]])) {
      match_indices <- which(traj_dates == target_date)
      
      for (j in match_indices) {
        traj_data <- final_filtered_trajectories[[j]]
        if (!is.null(traj_data) && "Hour" %in% names(traj_data)) {
          matched_rows <- traj_data[traj_data$Hour %in% c("11:00", "12:00", "13:00", "14:00"), ]
          
          if (nrow(matched_rows) > 0) {
            traj_df_6[[length(traj_df_6) + 1]] <- matched_rows
            print(paste(
              "Date is",
              target_date,
              "and time is",
              paste(unique(matched_rows$Hour), collapse = ", ")
            ))
          }
        }
      }
    }
  }
}
all_vals_6EAST <- c()
for (i in seq_along(CT_CO2)) {
  CTCO2_6EAST <- crop(CTCO2_6[[i]][[1]], east_extent)
  all_vals_6EAST <- c(all_vals_6EAST, values(CTCO2_6EAST))
}
z_range_6EAST <- range(all_vals_6EAST, na.rm = TRUE)

traj_dates6 <- vector("list", length(traj_df_6))
for (i in seq_along(traj_df_6)) {
  traj_dates6[[i]] <- as.Date(traj_df_6[[i]][[14]][[1]], tz = "America/New_York")
}
start_tile_values <- list()
for (i in seq_along(CTCO2_6)) {
  cropped_raster <- crop(CTCO2_6[[i]][[1]], east_extent)
  raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
  colnames(raster_df) <- c("x", "y", "CO2_ppm")
  
  name_string <- CTCO2_6[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  p <- ggplot() +
    geom_tile(data = raster_df, aes(x = x, y = y, fill = CO2_ppm)) +
    geom_text(
      data = raster_df,
      aes(
        x = x,
        y = y,
        label = round(CO2_ppm, 3)
      ),
      size = 2.5,
      color = "black"
    ) +
    geom_sf(
      data = east_states_sf,
      fill = NA,
      color = "grey",
      linewidth = 0.4
    ) +
    scale_fill_gradientn(colors = fields::tim.colors(),
                         limits = z_range_6EAST,
                         name = "ppm CO2") +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    labs(
      title = paste(
        "CT CO2: Cruise #14 averaged",
        date_string,
        "(time period 11-14 EDT)"
      ),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  colors <- paletteer_c("grDevices::rainbow", n = length(traj_dates6))
  match_indices <- which(traj_dates6 == target_date)
  if (length(match_indices) > 0) {
    for (j in match_indices) {
      traj_df <- traj_df_6[[j]]
      start_point <- traj_df[1, c("Longitude", "Latitude")]
      tile_value <- raster::extract(cropped_raster, matrix(c(
        start_point$Longitude, start_point$Latitude
      ), ncol = 2))
      key <- paste0(as.character(target_date), "_traj", j)
      start_tile_values[[key]] <- as.numeric(tile_value)
      p <- p +
        geom_path(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          color = "black",
          size = 0.5
        ) +
        geom_point(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          bg = colors[j],
          color = "black",
          size = 1.2,
          stroke = 0.5,
          shape = 21
        )
    }
  }
  # ---- Add tower locations ----
  p <- p +
    geom_point(
      data = twr,
      aes(x = Lon, y = Lat),
      shape = 23,          # diamond shape
      size = 3,
      fill = "black",
      color = "black"
    ) +
    geom_text(
      data = twr,
      aes(x = Lon, y = Lat, label = SiteCode),
      hjust = -0.3,        # label slightly to the right
      vjust = 0.3,
      size = 3
    )
  print(p)

}
legend_text2 <- c()
for (i in seq_along(traj_dates6)) {
  date <- lapply(traj_df_6[[i]][["Starting.Date.Time"]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 14",
  text.font = 3,
  col = colors,
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#####TIME SEVEN____________________________________________________________#####
traj_df_7 <- list()
for (k in seq_along(CT_CO2)) {
  name_string <- CT_CO2[[k]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  for (m in 1:8) {
    if (identical(CTCO2_7[[k]], CT_CO2[[k]][[m]])) {
      match_indices <- which(traj_dates == target_date)
      
      for (j in match_indices) {
        traj_data <- final_filtered_trajectories[[j]]
        if (!is.null(traj_data) && "Hour" %in% names(traj_data)) {
          matched_rows <- traj_data[traj_data$Hour %in% c("14:00", "15:00", "16:00", "17:00"), ]
          
          if (nrow(matched_rows) > 0) {
            traj_df_7[[length(traj_df_7) + 1]] <- matched_rows
            print(paste(
              "Date is",
              target_date,
              "and time is",
              paste(unique(matched_rows$Hour), collapse = ", ")
            ))
          }
        }
      }
    }
  }
}
all_vals_7EAST <- c()
for (i in seq_along(CT_CO2)) {
  CTCO2_7EAST <- crop(CTCO2_7[[i]][[1]], east_extent)
  all_vals_7EAST <- c(all_vals_7EAST, values(CTCO2_7EAST))
}
z_range_7EAST <- range(all_vals_7EAST, na.rm = TRUE)
traj_dates7 <- vector("list", length(traj_df_7))
for (i in seq_along(traj_df_7)) {
  traj_dates7[[i]] <- as.Date(traj_df_7[[i]][[14]][[1]], tz = "America/New_York")
}
start_tile_values <- list()
for (i in seq_along(CTCO2_7)) {
  cropped_raster <- crop(CTCO2_7[[i]][[1]], east_extent)
  raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
  colnames(raster_df) <- c("x", "y", "CO2_ppm")
  
  name_string <- CTCO2_7[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  p <- ggplot() +
    geom_tile(data = raster_df, aes(x = x, y = y, fill = CO2_ppm)) +
    geom_text(
      data = raster_df,
      aes(
        x = x,
        y = y,
        label = round(CO2_ppm, 3)
      ),
      size = 2.5,
      color = "black"
    ) +
    geom_sf(
      data = east_states_sf,
      fill = NA,
      color = "grey",
      linewidth = 0.4
    ) +
    scale_fill_gradientn(colors = fields::tim.colors(),
                         limits = z_range_7EAST,
                         name = "ppm CO2") +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    labs(
      title = paste(
        "CT CO2: Cruise #14 averaged",
        date_string,
        "(time period 14-17 EDT)"
      ),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  colors <- paletteer_c("grDevices::rainbow", n = length(traj_dates7))
  match_indices <- which(traj_dates7 == target_date)
  if (length(match_indices) > 0) {
    for (j in match_indices) {
      traj_df <- traj_df_7[[j]]
      start_point <- traj_df[1, c("Longitude", "Latitude")]
      tile_value <- raster::extract(cropped_raster, matrix(c(
        start_point$Longitude, start_point$Latitude
      ), ncol = 2))
      key <- paste0(as.character(target_date), "_traj", j)
      start_tile_values[[key]] <- as.numeric(tile_value)
      p <- p +
        geom_path(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          color = "black",
          size = 0.5
        ) +
        geom_point(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          bg = colors[j],
          color = "black",
          size = 1.2,
          stroke = 0.5,
          shape = 21
        )
    }
  }
  # ---- Add tower locations ----
  p <- p +
    geom_point(
      data = twr,
      aes(x = Lon, y = Lat),
      shape = 23,          # diamond shape
      size = 3,
      fill = "black",
      color = "black"
    ) +
    geom_text(
      data = twr,
      aes(x = Lon, y = Lat, label = SiteCode),
      hjust = -0.3,        # label slightly to the right
      vjust = 0.3,
      size = 3
    )
  print(p)
}
legend_text2 <- c()
for (i in seq_along(traj_dates7)) {
  date <- lapply(traj_df_7[[i]][["Starting.Date.Time"]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 14",
  text.font = 3,
  col = colors,
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#_______________________________________________________________________________
#####STATISTICS CT CO2___________________________________________________#######
#Cruise Data____________________________________________________________________
cruise <- "Cruise 8"
cruise_info <- read.delim(
"/Users/reneechabot/Desktop/moving_data.txt"  ,
  sep = ",",
  dec = "."
)
cruise_info <- cruise_info[!is.na(cruise_info$Longitude_deg), ]
cruise_info <- cruise_info[!is.na(cruise_info$CO2_dry_cal_moving_day), ]
cruise_info$Time_local <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "America/New_York")
library(openair)
colnames(cruise_info)[colnames(cruise_info) == "Time_local"] <- "date"
point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)
timespan <- sprintf("%02d:00", 10:16)
library(dplyr)
cruise_loc_filter <- cruise_info %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
cruise_loc_filter <- cruise_loc_filter %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])
cruise_loc_filter$Time_local <- as.POSIXct(cruise_loc_filter$date, origin = "1904-01-01", tz = "America/New_York")
cruise_loc_filter$closest_hr <- format(round(cruise_loc_filter$date, units =
                                               "hours"), format = "%H:%M")
cruise_loc_filter <- cruise_loc_filter[cruise_loc_filter$closest_hr >= 10 &
                                         cruise_loc_filter$closest_hr <= 16, , drop = FALSE]
cruise_loc_filter$Day <- as.Date(cruise_loc_filter$date)
cruise_info_3hr <- timeAverage(
  cruise_loc_filter,
  avg.time = "3 hour", 
  data.thresh = 0,
  statistic = "mean"
)
cruise_info_5min <- timeAverage(
  cruise_loc_filter,
  avg.time = "5 min",
  data.thresh = 0,
  statistic = "mean"
)
#final_cruise_info <- cruise_info_3hr
# final_cruise_info <- cruise_info_5min
# xy_data_list <- list()
# for (current_date in as.character(seq.Date(as.Date("2022-04-09"), as.Date("2022-04-12"), by = "day"))) {
#   if (any(final_cruise_info$Day == current_date)) {
#     temp_data <- final_cruise_info[final_cruise_info$Day == current_date, ]
#     x <- temp_data$Time_local
#     y <- temp_data$CO2_dry_cal_moving_day
#     xy_df <- data.frame(
#       Time_local = x,
#       CO2_dry_cal_moving_day = y,
#       Time_for_CT = x
#     )
#     xy_data_list[[current_date]] <- xy_df
#     sd_val <- sd(y, na.rm = TRUE)
#     time_range <- as.numeric(difftime(max(x), min(x), units = "secs"))
#     dynamic_width <- time_range / 20
#     
#     q <- qplot(x, y) +
#       geom_line() +
#      # scale_x_continuous(breaks=temp_data$Time_local)+
#       geom_errorbar(aes(
#         x = x,
#         ymin = y - sd_val,
#         ymax = y + sd_val
#       ), width = dynamic_width) +
#       labs(
#         title = paste("Cruise #4: Measured CO2 for", temp_data$Day, "(5 minute average)"), #"(3 hour average)",
#         x = "Time (local)",
#         y = "CO2 (ppm)"
#       )
#     
#     print(current_date)
#     print(quantile(y, na.rm = TRUE))
#     print(sd_val)
#     print(q)
#   }
# }

#To add multiple lines: 
# q + geom_segment(
#   aes(
#     x = as.POSIXct("2022-04-10 09:00:00", tz = "America/New_York"),
#     xend = as.POSIXct("2022-04-10 12:00:00", tz = "America/New_York"),
#     y = 435.1758,
#     yend = 435.1758
#   ),
#   color = "red"
# ) +
#   geom_segment(
#     aes(
#       x = as.POSIXct("2022-04-10 12:00:00", tz = "America/New_York"),
#       xend = as.POSIXct("2022-04-10 14:00:00", tz = "America/New_York"),
#       y = 433.0398,
#       yend = 433.0398
#     ),
#     color = "red")


#To add one line: 
#q + geom_hline(yintercept = 429.3834, color = "red")

#_______________________________________________________________________________
#####Carbon tracker CH4____________________________________________________#####
CT_CH4 <- list()
library(raster)
files = list.files(
  '/Users/reneechabot/Desktop/cruise8_eulerian/carbon_tracker_ch4_total',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
  CT_CH4[[i]] <- nc
}
library(ggplot2)
library(sf)
library(raster)
library(dplyr)
library(fields)
library(paletteer)
states <- st_read(
  "/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
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
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states) %>%
  st_transform(crs = st_crs(CT_CH4[[1]]))
east_extent <- extent(-85, -65, 25, 47)
all_vals <- c()
for (j in seq(final_filtered_trajectories)) {
  hr <- (format(as.POSIXct(final_filtered_trajectories[[j]][["Starting.Date.Time"]][[1]]), format = '%H:%M'))
  final_filtered_trajectories[[j]] <- cbind(final_filtered_trajectories[[j]], Hour = hr)
}
CTCH4_5 <- list()
CTCH4_6 <- list()
CTCH4_7 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_5[[i]] <- CT_CH4[[i]][[4]]
  CTCH4_6[[i]] <- CT_CH4[[i]][[5]]
  CTCH4_7[[i]] <- CT_CH4[[i]][[6]]
}
#####TIME FIVE_____________________________________________________________#####
traj_df_5 <- list()
for (k in seq_along(CT_CH4)) {
  name_string <- CT_CH4[[k]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  for (m in 1:8) {
    if (identical(CTCH4_5[[k]], CT_CH4[[k]][[m]])) {
      match_indices <- which(traj_dates == target_date)
      
      for (j in match_indices) {
        traj_data <- final_filtered_trajectories[[j]]
        if (!is.null(traj_data) && "Hour" %in% names(traj_data)) {
          matched_rows <- traj_data[traj_data$Hour %in% c("08:00", "09:00", "10:00", "11:00"), ]
          
          if (nrow(matched_rows) > 0) {
            traj_df_5[[length(traj_df_5) + 1]] <- matched_rows
            print(paste(
              "Date is",
              target_date,
              "and time is",
              paste(unique(matched_rows$Hour), collapse = ", ")
            ))
          }
        }
      }
    }
  }
}
all_vals_5EAST <- c()
for (i in seq_along(CT_CH4)) {
  CTCH4_5EAST <- crop(CTCH4_5[[i]][[1]], east_extent)
  all_vals_5EAST <- c(all_vals_5EAST, values(CTCH4_5EAST))
}
z_range_5EAST <- range(all_vals_5EAST, na.rm = TRUE)

traj_dates5 <- vector("list", length(traj_df_5))
for (i in seq_along(traj_df_5)) {
  traj_dates5[[i]] <- as.Date(traj_df_5[[i]][[14]][[1]], tz = "America/New_York")
}
start_tile_values <- list()
for (i in seq_along(CTCH4_5)) {
  cropped_raster <- crop(CTCH4_5[[i]][[1]], east_extent)
  raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
  colnames(raster_df) <- c("x", "y", "CH4_ppb")
  
  name_string <- CTCH4_5[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  p <- ggplot() +
    geom_tile(data = raster_df, aes(x = x, y = y, fill = CH4_ppb)) +
    geom_text(
      data = raster_df,
      aes(
        x = x,
        y = y,
        label = round(CH4_ppb, 3)
      ),
      size = 2.5,
      color = "black"
    ) +
    geom_sf(
      data = east_states_sf,
      fill = NA,
      color = "grey",
      linewidth = 0.4
    ) +
    scale_fill_gradientn(colors = fields::tim.colors(),
                         limits = z_range_5EAST,
                         name = "ppb CH4") +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    labs(
      title = paste(
        "CT CH4: Cruise #8 averaged",
        date_string,
        "(time period 8-11 EDT)"
      ),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  colors <- paletteer_c("grDevices::rainbow", n = length(traj_dates5))
  match_indices <- which(traj_dates5 == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      traj_df <- traj_df_5[[match_indices[j]]]
      traj_df <- traj_df[, !duplicated(names(traj_df))]
      start_point <- traj_df[1, c("Longitude", "Latitude")]
      tile_value <- raster::extract(cropped_raster, matrix(c(
        start_point$Longitude, start_point$Latitude
      ), ncol = 2))
      key <- paste0(as.character(target_date), "_traj", j)
      start_tile_values[[key]] <- as.numeric(tile_value)
      traj_color <- colors[match_indices[j]]
      p <- p +
        geom_path(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          color = "black",
          size = 0.5
        ) +
        geom_point(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          bg = traj_color,
          color = "black",
          size = 1.2,
          stroke = 0.5,
          shape = 21
        )
    }
  }
  print(p)
}
legend_text2 <- c()
for (i in seq_along(traj_dates5)) {
  date <- lapply(traj_df_5[[i]][["Starting.Date.Time"]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 8",
  text.font = 3,
  col = colors,
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#####TIME SIX______________________________________________________________#####
traj_df_6 <- list()
for (k in seq_along(CT_CH4)) {
  name_string <- CT_CH4[[k]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  for (m in 1:8) {
    if (identical(CTCH4_6[[k]], CT_CH4[[k]][[m]])) {
      match_indices <- which(traj_dates == target_date)
      
      for (j in match_indices) {
        traj_data <- final_filtered_trajectories[[j]]
        if (!is.null(traj_data) && "Hour" %in% names(traj_data)) {
          matched_rows <- traj_data[traj_data$Hour %in% c("11:00", "12:00", "13:00", "14:00"), ]
          
          if (nrow(matched_rows) > 0) {
            traj_df_6[[length(traj_df_6) + 1]] <- matched_rows
            print(paste(
              "Date is",
              target_date,
              "and time is",
              paste(unique(matched_rows$Hour), collapse = ", ")
            ))
          }
        }
      }
    }
  }
}
all_vals_6EAST <- c()
for (i in seq_along(CT_CH4)) {
  CTCH4_6EAST <- crop(CTCH4_6[[i]][[1]], east_extent)
  all_vals_6EAST <- c(all_vals_6EAST, values(CTCH4_6EAST))
}
z_range_6EAST <- range(all_vals_6EAST, na.rm = TRUE)

traj_dates6 <- vector("list", length(traj_df_6))
for (i in seq_along(traj_df_6)) {
  traj_dates6[[i]] <- as.Date(traj_df_6[[i]][[14]][[1]], tz = "America/New_York")
}
start_tile_values <- list()
for (i in seq_along(CTCH4_6)) {
  cropped_raster <- crop(CTCH4_6[[i]][[1]], east_extent)
  raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
  colnames(raster_df) <- c("x", "y", "CH4_ppb")
  
  name_string <- CTCH4_6[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  p <- ggplot() +
    geom_tile(data = raster_df, aes(x = x, y = y, fill = CH4_ppb)) +
    geom_text(
      data = raster_df,
      aes(
        x = x,
        y = y,
        label = round(CH4_ppb, 3)
      ),
      size = 2.5,
      color = "black"
    ) +
    geom_sf(
      data = east_states_sf,
      fill = NA,
      color = "grey",
      linewidth = 0.4
    ) +
    scale_fill_gradientn(colors = fields::tim.colors(),
                         limits = z_range_6EAST,
                         name = "ppb CH4") +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    labs(
      title = paste(
        "CT CH4: Cruise #8 averaged",
        date_string,
        "(time period 11-14 EDT)"
      ),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  colors <- paletteer_c("grDevices::rainbow", n = length(traj_dates6))
  match_indices <- which(traj_dates6 == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      traj_df <- traj_df_6[[match_indices[j]]]
      traj_df <- traj_df[, !duplicated(names(traj_df))]
      start_point <- traj_df[1, c("Longitude", "Latitude")]
      tile_value <- raster::extract(cropped_raster, matrix(c(
        start_point$Longitude, start_point$Latitude
      ), ncol = 2))
      key <- paste0(as.character(target_date), "_traj", j)
      start_tile_values[[key]] <- as.numeric(tile_value)
      traj_color <- colors[match_indices[j]]
      p <- p +
        geom_path(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          color = "black",
          size = 0.5
        ) +
        geom_point(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          bg = traj_color,
          color = "black",
          size = 1.2,
          stroke = 0.5,
          shape = 21
        )
    }
  }
  print(p)
}
legend_text2 <- c()
for (i in seq_along(traj_dates6)) {
  date <- lapply(traj_df_6[[i]][["Starting.Date.Time"]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 8",
  text.font = 3,
  col = colors,
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#####TIME SEVEN____________________________________________________________#####
traj_df_7 <- list()
for (k in seq_along(CT_CH4)) {
  name_string <- CT_CH4[[k]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  for (m in 1:8) {
    if (identical(CTCH4_7[[k]], CT_CH4[[k]][[m]])) {
      match_indices <- which(traj_dates == target_date)
      
      for (j in match_indices) {
        traj_data <- final_filtered_trajectories[[j]]
        if (!is.null(traj_data) && "Hour" %in% names(traj_data)) {
          matched_rows <- traj_data[traj_data$Hour %in% c("14:00", "15:00", "16:00", "17:00"), ]
          
          if (nrow(matched_rows) > 0) {
            traj_df_7[[length(traj_df_7) + 1]] <- matched_rows
            print(paste(
              "Date is",
              target_date,
              "and time is",
              paste(unique(matched_rows$Hour), collapse = ", ")
            ))
          }
        }
      }
    }
  }
}
#--
all_vals_7EAST <- c()
for (i in seq_along(CT_CH4)) {
  CTCH4_7EAST <- crop(CTCH4_7[[i]][[1]], east_extent)
  all_vals_7EAST <- c(all_vals_7EAST, values(CTCH4_7EAST))
}
z_range_7EAST <- range(all_vals_7EAST, na.rm = TRUE)

traj_dates7 <- vector("list", length(traj_df_7))
for (i in seq_along(traj_df_7)) {
  traj_dates7[[i]] <- as.Date(traj_df_7[[i]][[14]][[1]], tz = "America/New_York")
}
start_tile_values <- list()
for (i in seq_along(CTCH4_7)) {
  cropped_raster <- crop(CTCH4_7[[i]][[1]], east_extent)
  raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
  colnames(raster_df) <- c("x", "y", "CH4_ppb")
  
  name_string <- CTCH4_7[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  
  p <- ggplot() +
    geom_tile(data = raster_df, aes(x = x, y = y, fill = CH4_ppb)) +
    geom_text(
      data = raster_df,
      aes(
        x = x,
        y = y,
        label = round(CH4_ppb, 3)
      ),
      size = 2.5,
      color = "black"
    ) +
    geom_sf(
      data = east_states_sf,
      fill = NA,
      color = "grey",
      linewidth = 0.4
    ) +
    scale_fill_gradientn(colors = fields::tim.colors(),
                         limits = z_range_7EAST,
                         name = "ppb CH4") +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    labs(
      title = paste(
        "CT CH4: Cruise #8 averaged",
        date_string,
        "(time period 14-17 EDT)"
      ),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  colors <- paletteer_c("grDevices::rainbow", n = length(traj_dates7))
  match_indices <- which(traj_dates7 == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      traj_df <- traj_df_7[[match_indices[j]]]
      traj_df <- traj_df[, !duplicated(names(traj_df))]
      start_point <- traj_df[1, c("Longitude", "Latitude")]
      tile_value <- raster::extract(cropped_raster, matrix(c(
        start_point$Longitude, start_point$Latitude
      ), ncol = 2))
      key <- paste0(as.character(target_date), "_traj", j)
      start_tile_values[[key]] <- as.numeric(tile_value)
      traj_color <- colors[match_indices[j]]
      p <- p +
        geom_path(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          color = "black",
          size = 0.5
        ) +
        geom_point(
          data = traj_df,
          aes(x = Longitude, y = Latitude),
          bg = traj_color,
          color = "black",
          size = 1.2,
          stroke = 0.5,
          shape = 21
        )
    }
  }
  print(p)
}
legend_text2 <- c()
for (i in seq_along(traj_dates7)) {
  date <- lapply(traj_df_7[[i]][["Starting.Date.Time"]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 8",
  text.font = 3,
  col = colors,
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#_______________________________________________________________________________
#####STATISTICS CT CH4_____________________________________________________#####
cruise <- "Cruise 8"
cruise_info <- read.delim(
"/Users/reneechabot/Desktop/moving_data.txt"  ,
  sep = ",",
  dec = "."
)
cruise_info <- cruise_info[!is.na(cruise_info$Longitude_deg), ]
cruise_info <- cruise_info[!is.na(cruise_info$CO2_dry_cal_moving_day), ]
cruise_info$Time_local <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "America/New_York")
library(openair)
colnames(cruise_info)[colnames(cruise_info) == "Time_local"] <- "date"
point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)
timespan <- sprintf("%02d:00", 10:16)
library(dplyr)
cruise_loc_filter <- cruise_info %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
cruise_loc_filter <- cruise_loc_filter %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])
cruise_loc_filter$Time_local <- as.POSIXct(cruise_loc_filter$date, origin = "1904-01-01", tz = "America/New_York")
cruise_loc_filter$closest_hr <- format(round(cruise_loc_filter$date, units =
                                               "hours"), format = "%H:%M")
cruise_loc_filter <- cruise_loc_filter[cruise_loc_filter$closest_hr >= 10 &
                                         cruise_loc_filter$closest_hr <= 16, , drop = FALSE]
cruise_loc_filter$Day <- as.Date(cruise_loc_filter$date)
cruise_info_3hr <- timeAverage(
  cruise_loc_filter,
  avg.time = "3 hour", 
  data.thresh = 0,
  statistic = "mean"
)
cruise_info_5min <- timeAverage(
  cruise_loc_filter,
  avg.time = "5 min",
  data.thresh = 0,
  statistic = "mean"
)
#final_cruise_info <- cruise_info_3hr
# final_cruise_info <- cruise_info_5min
# xy_data_list <- list()
# for (current_date in as.character("2022-04-09")) {
#   if (any(final_cruise_info$Day == current_date)) {
#     temp_data <- final_cruise_info[final_cruise_info$Day == current_date, ]
#     x <- temp_data$Time_local
#     y <- temp_data$CH4_dry_cal_moving_day
#     xy_df <- data.frame(
#       Time_local = x,
#       CO2_dry_cal_moving_day = y,
#       Time_for_CT = x
#     )
#     xy_data_list[[current_date]] <- xy_df
#     sd_val <- sd(y, na.rm = TRUE)
#     time_range <- as.numeric(difftime(max(x), min(x), units = "secs"))
#     dynamic_width <- time_range / 20
#     library(ggplot2)
#     q <- qplot(x, y) +
#       geom_line() +
#      #scale_x_continuous(breaks=temp_data$Time_local)+
#       geom_errorbar(aes(
#         x = x,
#         ymin = y - sd_val,
#         ymax = y + sd_val
#       ), width = dynamic_width) +
#       labs(
#         title = paste("Cruise #8: Measured CH4 for", temp_data$Day, "(5 minute average)"), #"(3 hour average)",
#         x = "Time (local)",
#         y = "CO2 (ppm)"
#       )
#     
#     print(current_date)
#     print(quantile(y, na.rm = TRUE))
#     print(sd_val)
#     print(q)
#   }
# }

#To add multiple lines:
# q + geom_segment(
#   aes(
#     x = as.POSIXct("2022-04-10 08:00:00", tz = "America/New_York"),
#     xend = as.POSIXct("2022-04-10 11:00:00", tz = "America/New_York"),
#     y = 2.057925,
#     yend = 2.057925
#   ),
#   color = "red"
# ) +
#   geom_segment(
#     aes(
#       x = as.POSIXct("2022-04-10 11:00:00", tz = "America/New_York"),
#       xend = as.POSIXct("2022-04-10 14:00:00", tz = "America/New_York"),
#       y = 2.044399,
#       yend = 2.044399
#     ),
#     color = "red")


#To add one line: 
#q + geom_hline(yintercept = 2.031191, color = "red")

#####FIGURING OUT CAMS____________________________________________________######
#_______________________________________________________________________________
#CAMS CO2 & CH4___
## Info:
#there are 34 levels 
#lowest level is 2935.616 meters
library(raster)
library(ncdf4)
library(ggplot2)
library(sf)
library(dplyr)
CAMS <- list()
files <- list.files(
  '/Users/reneechabot/Desktop/cruise4_eulerian /cams_global_inversion_optimized_ghg_fluxes',
  pattern = '\\.nc$',
  full.names = TRUE
)
for (f in files) {
  cat("Processing:", f, "\n")
  nc <- nc_open(f)
  var_names <- names(nc$var)
  
  if ("CH4" %in% var_names) {
    var_to_use <- "CH4"
  } else if ("CO2" %in% var_names) {
    var_to_use <- "CO2"
  } else {
    warning("No CH4 or CO2 found in:", f)
    nc_close(nc)
    next
  }
  dims <- nc$var[[var_to_use]]$varsize
  print(paste("Variable", var_to_use, "dimensions:", paste(dims, collapse = " x ")))
  nc_close(nc)
  if (length(dims) < 3 || any(dims == 0)) {
    warning(paste("Skipping", f, "- invalid dimensions"))
    next
  }
  tryCatch({
    r <- raster(f, varname = var_to_use, band = 1)
    CAMS[[paste0(var_to_use, "_", length(CAMS) + 1)]] <- r
  }, error = function(e) {
    warning(paste("Skipping", f, "- could not load raster:", e$message))
  })
}
#grabbing timestamps
all_timestamps <- list()

for (i in seq_along(files)) {
  cat("Reading time info from:", files[i], "\n")
  nc <- nc_open(files[i])
  if (!("time" %in% names(nc$dim))) {
    warning(paste("No 'time' dimension in:", files[i]))
    nc_close(nc)
    next
  }
  time_vals <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  nc_close(nc)
  origin <- sub("hours since ", "", time_units)
  timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  all_timestamps[[basename(files[i])]] <- timestamps
}
#shapefile load
states <- st_read(
  "/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
east_coast_states <- c(
  "Maine", "New Hampshire", "Massachusetts", "Rhode Island", "Connecticut",
  "New York", "New Jersey", "Delaware", "Maryland", "Virginia",
  "North Carolina", "South Carolina", "Georgia", "Florida", "Pennsylvania", "Vermont"
)
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states) %>%
  st_transform(crs = st_crs(CAMS[[1]]))
east_extent <- extent(-85, -65, 25, 47)

#edits 
# Load timestamps from NetCDF files
get_timestamps <- function(nc_file) {
  nc <- nc_open(nc_file)
  time_vals <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  origin <- sub("hours since ", "", time_units)
  timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  nc_close(nc)
  return(timestamps)
}

timestamps <- get_timestamps(files[2])  

# Loop through each trajectory time
for (i in seq_along(traj_dates_utc)) {
  target_time <- traj_dates_utc[i]
  
  # Find closest time in NetCDF
  layer_number <- which.min(abs(difftime(timestamps, target_time, units = "secs")))
  plot_date <- timestamps[layer_number]
  plot_date_str <- format(plot_date, "%Y-%m-%d %H:%M UTC")
  
  # Extract cropped rasters for the selected time layer
  CH4_cropped <- crop(CAMS[[1]][[layer_number]], east_extent)
  CO2_cropped <- crop(CAMS[[2]][[layer_number]], east_extent)
  CO2_cropped <- CO2_cropped * 1e6  # Convert to ppm
  
  # Convert to dataframes for plotting
  ch4_df <- as.data.frame(CH4_cropped, xy = TRUE)
  co2_df <- as.data.frame(CO2_cropped, xy = TRUE)
  names(ch4_df)[3] <- "CH4"
  names(co2_df)[3] <- "CO2"
  
  # Plot CO2
  p_co2 <- ggplot() +
    geom_raster(data = co2_df, aes(x = x, y = y, fill = CO2)) +
    geom_sf(data = east_states_sf, fill = NA, color = "black", linewidth = 0.3) +
    scale_fill_viridis_c(option = "C") +
    coord_sf(xlim = c(-85, -65), ylim = c(25, 47), expand = FALSE) +
    labs(
      title = paste("CO2 Concentration on", plot_date_str),
      fill = "CO2 (ppm)",
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  
  # Plot CH4
  p_ch4 <- ggplot() +
    geom_raster(data = ch4_df, aes(x = x, y = y, fill = CH4)) +
    geom_sf(data = east_states_sf, fill = NA, color = "black", linewidth = 0.3) +
    scale_fill_viridis_c(option = "C") +
    coord_sf(xlim = c(-85, -65), ylim = c(25, 47), expand = FALSE) +
    labs(
      title = paste("CH4 Concentration on", plot_date_str),
      fill = "CH4 (ppb)",
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  
  print(p_co2)
  print(p_ch4)
  
}

###
# Pre-allocate results list
co2_ch4_extracted <- list()

# Get CAMS timestamps (assume CO2 is representative)
timestamps <- get_timestamps(files[2])

for (i in seq_along(traj_dates_utc)) {
  target_time <- traj_dates_utc[i]
  layer_number <- which.min(abs(difftime(timestamps, target_time, units = "secs")))
  
  # Get corresponding trajectory dataframe
  traj_df <- final_filtered_trajectories[[i]]
  lat_lon_df <- data.frame(x = traj_df$Longitude[1], y = traj_df$Latitude[1])
  
  # Extract from CH4 (ppb) and CO2 (ppm) layers
  ch4_layer <- CAMS[[1]][[layer_number]]
  co2_layer <- CAMS[[2]][[layer_number]] * 1e6  # Convert to ppm
  
  # Extract values at trajectory points
  ch4_vals <- extract(ch4_layer, lat_lon_df)
  co2_vals <- extract(co2_layer, lat_lon_df)
  
  # Store the results
  co2_ch4_extracted[[i]] <- data.frame(
    datetime = rep(timestamps[layer_number], length(ch4_vals)),
    lat = lat_lon_df$y,
    lon = lat_lon_df$x,
    ch4_ppb = ch4_vals,
    co2_ppm = co2_vals
  )
}
library(dplyr)
all_traj_gas_data <- bind_rows(co2_ch4_extracted)

#quicklooks
plot(all_traj_gas_data$datetime, y= all_traj_gas_data$ch4_ppb, type ="o")
plot(all_traj_gas_data$datetime, y= all_traj_gas_data$co2_ppm, type ="o")





