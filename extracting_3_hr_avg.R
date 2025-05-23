directory <- "/Users/reneechabot/hysplit/working/cruise_4_hrrr_tdump_files"
setwd(directory)
tdump_files = list.files(
  pattern = glob2rx("tdump?*"),
  recursive = T,
  full.names = T
)
sorted <- order(basename(tdump_files))
tdump_files <- (tdump_files[sorted])
trajectory_list <- list()
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
  Single_Example_file_traj1$Starting.Date.Time <- format(Single_Example_file_traj1$Starting.Date.Time,
                                                         tz = "America/New_York",
                                                         usetz = TRUE)
  trajectory_list <- append(trajectory_list, list(Single_Example_file_traj1))
  i = i + 1
}

final_filtered_trajectories <- trajectory_list
traj_dates <- vector("list", length(final_filtered_trajectories))
for (i in seq_along(final_filtered_trajectories)) {
  traj_dates[[i]] <- as.Date(final_filtered_trajectories[[i]][[14]][[1]], tz = "America/New_York")
}
#NOT SURE IF I NEED TRAJECTORY INFO REALLY
cruise <- "Cruise 4"
#need full cruise information
cruise_info <- read.delim(
  "/Users/reneechabot/Desktop/cruise_4_all_data.csv",
  sep = ",",
  dec = "."
)

names(cruise_info)[names(cruise_info) == "co2_subrange"] <- "CO2_dry_cal_moving_day"
names(cruise_info)[names(cruise_info) == "ch4_subrange"] <- "CH4_dry_cal_moving_day"
names(cruise_info)[names(cruise_info) == "time_local_subrange"] <- "Time_local"
names(cruise_info)[names(cruise_info) == "latitude_deg_subrange"] <- "Latitude_deg"
names(cruise_info)[names(cruise_info) == "longitude_deg_subrange"] <- "Longitude_deg"

cruise_info <- cruise_info[!is.na(cruise_info$Longitude_deg), ]
cruise_info <- cruise_info[!is.na(cruise_info$CO2_dry_cal_moving_day), ]
cruise_info$Time_local <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "America/New_York")

library(openair)
anchor_time <- as.POSIXct("2022-04-07 20:00:00:00", tz = "America/New_York")
colnames(cruise_info)[colnames(cruise_info) == "Time_local"] <- "date"
cruise_info$Day <- as.Date(cruise_info$date)
cruise_info_3hr <- timeAverage(
  cruise_info,
  avg.time = "3 hour",
  data.thresh = 0,
  statistic = "mean",
  start.date = anchor_time
)
library(hms)
cruise_info_3hr$time_only <- as_hms(cruise_info_3hr$date)
library(raster)
CT_CO2 <- list()
files <- list.files(
  '/Users/reneechabot/Desktop/cruise4_eulerian /carbon_tracker_co2_total/',
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

for (j in seq(final_filtered_trajectories)) {
  hr <- (format(as.POSIXct(final_filtered_trajectories[[j]][["Starting.Date.Time"]][[1]]), format = '%H:%M'))
  final_filtered_trajectories[[j]] <- cbind(final_filtered_trajectories[[j]], Hour = hr)
}

CTCO2_1 <- list()
CTCO2_2 <- list()
CTCO2_3 <- list()
CTCO2_4 <- list()
CTCO2_5 <- list()
CTCO2_6 <- list()
CTCO2_7 <- list()
CTCO2_8 <- list()
for (i in seq_along(CT_CO2)) {
  CTCO2_1[[i]] <- CT_CO2[[i]][[1]]
  CTCO2_2[[i]] <- CT_CO2[[i]][[2]]
  CTCO2_3[[i]] <- CT_CO2[[i]][[3]]
  CTCO2_4[[i]] <- CT_CO2[[i]][[4]]
  CTCO2_5[[i]] <- CT_CO2[[i]][[5]]
  CTCO2_6[[i]] <- CT_CO2[[i]][[6]]
  CTCO2_7[[i]] <- CT_CO2[[i]][[7]]
  CTCO2_8[[i]] <- CT_CO2[[i]][[8]]
}
CT_CH4 <- list()
library(raster)
files = list.files(
  '/Users/reneechabot/Desktop/cruise4_eulerian /carbon_tracker_ch4_total',
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
for (j in seq(final_filtered_trajectories)) {
  hr <- (format(as.POSIXct(final_filtered_trajectories[[j]][["Starting.Date.Time"]][[1]]), format = '%H:%M'))
  final_filtered_trajectories[[j]] <- cbind(final_filtered_trajectories[[j]], Hour = hr)
}
CTCH4_1 <- list()
CTCH4_2 <- list()
CTCH4_3 <- list()
CTCH4_4 <- list()
CTCH4_5 <- list()
CTCH4_6 <- list()
CTCH4_7 <- list()
CTCH4_8 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_1[[i]] <- CT_CH4[[i]][[1]]
  CTCH4_2[[i]] <- CT_CH4[[i]][[2]]
  CTCH4_3[[i]] <- CT_CH4[[i]][[3]]
  CTCH4_4[[i]] <- CT_CH4[[i]][[4]]
  CTCH4_5[[i]] <- CT_CH4[[i]][[5]]
  CTCH4_6[[i]] <- CT_CH4[[i]][[6]]
  CTCH4_7[[i]] <- CT_CH4[[i]][[7]]
  CTCH4_8[[i]] <- CT_CH4[[i]][[8]]
}

library(ncdf4)
library(raster)
library(lubridate)

CT_CO2 <- list()
files <- list.files(
  '/Users/reneechabot/Desktop/cruise4_eulerian /carbon_tracker_co2_total/',
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
interval_labels <- data.frame(
  Times_UTC = paste0(
    format(start_times, "%H:%M"),
    "–",
    format(end_times, "%H:%M UTC")
  ),
  Grouping = 1:length(start_times)
)
start_ny <- lubridate::with_tz(start_times, tzone = "America/New_York")
end_ny   <- lubridate::with_tz(end_times, tzone = "America/New_York")
interval_labels$Times_NY <- paste0(format(start_ny, "%H:%M"), "–", format(end_ny, "%H:%M %Z"))
print(interval_labels)

#CO2
library(hms)
cruise_info_3hr$CT_CO2_tile <- NA_real_

start_time <- as_hms("20:00:00")
end_time   <- as_hms("24:00:00") #23:00:00

for (i in seq_along(CTCO2_1)) {
  cropped_raster <- CTCO2_1[[i]][[1]]
  name_string <- CTCO2_1[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c1_df <- cruise_info_3hr[row_index, ]
      this_time <- c1_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c1_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("00:00:00") #23:00:00
end_time   <- as_hms("02:00:00")

for (i in seq_along(CTCO2_2)) {
  cropped_raster <- CTCO2_2[[i]][[1]]
  name_string <- CTCO2_2[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c2_df <- cruise_info_3hr[row_index, ]
      this_time <- c2_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c2_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("02:00:00")
end_time   <- as_hms("05:00:00")

for (i in seq_along(CTCO2_3)) {
  cropped_raster <- CTCO2_3[[i]][[1]]
  name_string <- CTCO2_3[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c3_df <- cruise_info_3hr[row_index, ]
      this_time <- c3_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c3_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("05:00:00")
end_time   <- as_hms("08:00:00")

for (i in seq_along(CTCO2_4)) {
  cropped_raster <- CTCO2_4[[i]][[1]]
  name_string <- CTCO2_4[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c4_df <- cruise_info_3hr[row_index, ]
      this_time <- c4_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c4_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("08:00:00")
end_time   <- as_hms("11:00:00")

for (i in seq_along(CTCO2_5)) {
  cropped_raster <- CTCO2_5[[i]][[1]]
  name_string <- CTCO2_5[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c5_df <- cruise_info_3hr[row_index, ]
      this_time <- c5_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c5_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

library(hms)
start_time <- as_hms("11:00:00")
end_time   <- as_hms("14:00:00")

for (i in seq_along(CTCO2_6)) {
  cropped_raster <- CTCO2_6[[i]][[1]]
  name_string <- CTCO2_6[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c6_df <- cruise_info_3hr[row_index, ]
      this_time <- c6_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c6_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

library(hms)
start_time <- as_hms("14:00:00")
end_time   <- as_hms("17:00:00")

for (i in seq_along(CTCO2_7)) {
  cropped_raster <- CTCO2_7[[i]][[1]]
  name_string <- CTCO2_7[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c7_df <- cruise_info_3hr[row_index, ]
      this_time <- c7_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c7_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("17:00:00")
end_time   <- as_hms("20:00:00")

for (i in seq_along(CTCO2_8)) {
  cropped_raster <- CTCO2_8[[i]][[1]]
  name_string <- CTCO2_8[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c8_df <- cruise_info_3hr[row_index, ]
      this_time <- c8_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c8_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

cruise_info_3hr$co2_mean_bias <- cruise_info_3hr$CT_CO2_tile - cruise_info_3hr$CO2_dry_cal_moving_day
cruise_info_3hr$co2_SD <- sd(cruise_info_3hr$co2_mean_bias)

co2_plot_text <- paste("Mean bias is ",
                       round(mean(cruise_info_3hr$co2_mean_bias), 2),
                       "±",
                       round(cruise_info_3hr$co2_SD[1], 2))

library(ggplot2)
library(ggpmisc)

ggplot(cruise_info_3hr,
       aes(x = CO2_dry_cal_moving_day, y = CT_CO2_tile)) + geom_point() +
  labs(
    title = paste(
      "CT CO2: Cruise #4 averaged every 3 hours vs measured concentrations"
    ),
    x = "Observed CO2 (ppm)",
    y = "CT CO2 (ppm)"
  ) +
  geom_smooth(method = lm) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) +
  xlim(420, 443) + ylim(420, 443) + geom_abline(slope = 1,
                                                linetype = "dashed",
                                                color = "red") +
  geom_text(
    x = min(cruise_info_3hr$CO2_dry_cal_moving_day +2),
    y = max(cruise_info_3hr$CT_CO2_tile - 1),
    label = co2_plot_text,
    hjust = 0.5,
    family = "serif"
  ) +
  stat_poly_eq(aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               formula = y ~ x, parse =T, fontface= "italic", family = "serif")


#pdfs
df <- data.frame(
  value = c(cruise_info_3hr$CO2_dry_cal_moving_day, cruise_info_3hr$CT_CO2_tile),
  group = factor(c(rep("Observed", length(cruise_info_3hr$CO2_dry_cal_moving_day)),
                   rep("CT", length(cruise_info_3hr$CT_CO2_tile))))
)
ggplot(df, aes(x = value, group = group, fill= group)) +
  geom_density(alpha=0.4) +
  labs(title = "Overlayed PDFs for CO2", x = "Concentration", y = "Density") + theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) 

#time of day coloring
ggplot(cruise_info_3hr,
       aes(x = CO2_dry_cal_moving_day, y = CT_CO2_tile, color = date)) + geom_point(size=3) +
  labs(
    title = paste(
      "CT CO2: Cruise #4 averaged every 3 hours vs measured concentrations"
    ),
    x = "Observed CO2 (ppm)",
    y = "CT CO2 (ppm)"
  ) +

  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) +
  xlim(420, 443) + ylim(420, 443) + geom_abline(slope = 1,
                                                linetype = "dashed",
                                                color = "red")  + 
  theme(legend.text = element_text(size = 16), legend.title=element_text(size = 16))
 
#bias coloring by day
library(lubridate)
library(hms)
library(ggplot2)
library(dplyr)

cruise_info_3hr$time_parsed <- hms::as_hms(cruise_info_3hr$time_only)
hour_val <- hour(cruise_info_3hr$time_parsed)
cruise_info_3hr$TimeOfDay <- case_when(
  hour_val >= 21 | hour_val < 5 ~ "Night",
  hour_val >= 5 & hour_val < 12 ~ "Morning",
  hour_val >= 12 & hour_val < 16 ~ "Afternoon",
  hour_val >= 16 & hour_val < 21 ~ "Evening"
)
cruise_info_3hr$TimeOfDay <- factor(
  cruise_info_3hr$TimeOfDay,
  levels = c("Morning", "Afternoon", "Evening", "Night")
)
cruise_info_3hr$time_only_factor <- as.factor(cruise_info_3hr$time_only)
ggplot(cruise_info_3hr, aes(x = date, y = co2_mean_bias, color = time_only_factor, shape=TimeOfDay)) +
  geom_point(size = 3) + scale_shape_manual(values = c("Night" = 15, "Morning" = 16, "Afternoon" = 17, "Evening" = 18)) +
  labs(
    title = "CO2 bias vs Date",
    x = "Date",
    y = "Bias",
    color = "Time (local)"  # legend title
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )

library(sf)
library(sp)
library(terra)
library(tmap)

final_traj_filter <- trajectory_list
traj_datetimes_char <- sapply(trajectory_list, function(df) df$Starting.Date.Time[1])

traj_datetimes <- as.POSIXct(traj_datetimes_char, format = "%Y-%m-%d %H:%M", tz = "America/New_York")
cruise_datetimes <- as.POSIXct(cruise_info_3hr$date, tz = "America/New_York")
matching_indices <- which(traj_datetimes %in% cruise_datetimes)
final_traj_filter <- final_traj_filter[matching_indices]
final_traj_filter <- final_traj_filter[sapply(final_traj_filter, nrow) == 25]

states <- st_read("/Users/reneechabot/Downloads/cb_2023_us_state_500k/cb_2023_us_state_500k.shp")

lon_all <- c()
lat_all <- c()
datetime_all <- c()


for (i in seq_along(final_traj_filter)) {
  lon <- final_traj_filter[[i]][[11]][[25]]
  lat <- final_traj_filter[[i]][[10]][[25]]
  datetime <- final_traj_filter[[i]][["Starting.Date.Time"]][[1]]  
  datetime_repeated <- rep(datetime, length(lon))
  
  lon_all <- c(lon_all, lon)
  lat_all <- c(lat_all, lat)
  datetime_all <- c(datetime_all, datetime_repeated)
  
}

points_df <- data.frame(lon = lon_all, lat = lat_all,   datetime = datetime_all)
points_sf <- st_as_sf(points_df, coords = c("lon", "lat"), crs = st_crs(states))
inside <- st_within(points_sf, states, sparse = FALSE)
over_land <- apply(inside, 1, any)
points_df$over_land <- over_land
blank_rows <- points_df[1:2, ]
blank_rows[] <- NA  
points_df_padded <- rbind(blank_rows, points_df)
cruise_info_3hr$over_land <- points_df_padded$over_land

ggplot(cruise_info_3hr, aes(x = date, y = co2_mean_bias, fill = over_land)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "CO2 bias vs Date",
    x = "Date",
    y = "Bias",
    fill = "Over land?"  
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )






#CH4
library(hms)
cruise_info_3hr$CT_CH4_tile <- NA_real_

start_time <- as_hms("20:00:00")
end_time   <- as_hms("24:00:00")

for (i in seq_along(CTCH4_1)) {
  cropped_raster <- CTCH4_1[[i]][[1]]
  name_string <- CTCH4_1[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("00:00:00")
end_time   <- as_hms("02:00:00")

for (i in seq_along(CTCH4_2)) {
  cropped_raster <- CTCH4_2[[i]][[1]]
  name_string <- CTCH4_2[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("02:00:00")
end_time   <- as_hms("05:00:00")

for (i in seq_along(CTCH4_3)) {
  cropped_raster <- CTCH4_3[[i]][[1]]
  name_string <- CTCH4_3[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("05:00:00")
end_time   <- as_hms("08:00:00")

for (i in seq_along(CTCH4_4)) {
  cropped_raster <- CTCH4_4[[i]][[1]]
  name_string <- CTCH4_4[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("08:00:00")
end_time   <- as_hms("11:00:00")

for (i in seq_along(CTCH4_5)) {
  cropped_raster <- CTCH4_5[[i]][[1]]
  name_string <- CTCH4_5[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("11:00:00")
end_time   <- as_hms("14:00:00")

for (i in seq_along(CTCH4_6)) {
  cropped_raster <- CTCH4_6[[i]][[1]]
  name_string <- CTCH4_6[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("14:00:00")
end_time   <- as_hms("17:00:00")

for (i in seq_along(CTCH4_7)) {
  cropped_raster <- CTCH4_7[[i]][[1]]
  name_string <- CTCH4_7[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("17:00:00")
end_time   <- as_hms("20:00:00")

for (i in seq_along(CTCH4_8)) {
  cropped_raster <- CTCH4_8[[i]][[1]]
  name_string <- CTCH4_8[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

cruise_info_3hr$CT_CH4_tile <- cruise_info_3hr$CT_CH4_tile / 1000
cruise_info_3hr$ch4_mean_bias <- cruise_info_3hr$CT_CH4_tile - cruise_info_3hr$CH4_dry_cal_moving_day
cruise_info_3hr$ch4_SD <- sd(cruise_info_3hr$ch4_mean_bias)

ch4_plot_text <- paste("Mean bias is ",
                       round(mean(cruise_info_3hr$ch4_mean_bias), 3),
                       "±",
                       round(cruise_info_3hr$ch4_SD[1], 3))

library(ggplot2)
library(ggpmisc)

ggplot(cruise_info_3hr,
       aes(x = CH4_dry_cal_moving_day, y = CT_CH4_tile)) + geom_point() +
  labs(
    title = paste(
      "CT CO2: Cruise #4 averaged every 3 hours vs measured concentrations"
    ),
    x = "Observed CH4 (ppb)",
    y = "CT CH4 (ppb)"
  ) +
  geom_smooth(method = lm) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) +
  xlim(1.94, 2.11) + ylim(1.94, 2.11) + geom_abline(slope = 1,
                                                linetype = "dashed",
                                                color = "red") +
  geom_text(
    x = min(cruise_info_3hr$CH4_dry_cal_moving_day +0.004),
    y = max(cruise_info_3hr$CT_CH4_tile - 0.001),
    label = ch4_plot_text,
    hjust = 0.5,
    family = "serif"
  ) +
  stat_poly_eq(aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               formula = y ~ x, parse =T, fontface= "italic", family = "serif")
#pdfs
df <- data.frame(
  value = c(cruise_info_3hr$CH4_dry_cal_moving_day, cruise_info_3hr$CT_CH4_tile),
  group = factor(c(rep("Observed", length(cruise_info_3hr$CH4_dry_cal_moving_day)),
                   rep("CT", length(cruise_info_3hr$CT_CH4_tile))))
)
ggplot(df, aes(x = value, group = group, fill= group)) +
  geom_density(alpha=0.4) +
  labs(title = "Overlayed PDFs for CH4", x = "Concentration", y = "Density") + theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) 

#time of day coloring
ggplot(cruise_info_3hr,
       aes(x = CH4_dry_cal_moving_day, y = CT_CH4_tile, color = date)) + geom_point(size=3) +
  labs(
    title = paste(
      "CT CH4: Cruise #4 averaged every 3 hours vs measured concentrations"
    ),
    x = "Observed CH4 (ppb)",
    y = "CT CH4 (ppb)"
  ) +
  
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) +
  xlim(1.94, 2.11) + ylim(1.94, 2.11) + geom_abline(slope = 1,
                                                linetype = "dashed",
                                                color = "red")  + 
  theme(legend.text = element_text(size = 16), legend.title=element_text(size = 16))

#bias v time
library(lubridate)
library(hms)
library(ggplot2)
library(dplyr)

cruise_info_3hr$time_parsed <- hms::as_hms(cruise_info_3hr$time_only)

# Extract the hour
hour_val <- hour(cruise_info_3hr$time_parsed)

# Define TimeOfDay categories
cruise_info_3hr$TimeOfDay <- case_when(
  hour_val >= 21 | hour_val < 5 ~ "Night",
  hour_val >= 5 & hour_val < 12 ~ "Morning",
  hour_val >= 12 & hour_val < 16 ~ "Afternoon",
  hour_val >= 16 & hour_val < 21 ~ "Evening"
)

# Convert to factor for consistent ordering (optional)
cruise_info_3hr$TimeOfDay <- factor(
  cruise_info_3hr$TimeOfDay,
  levels = c("Morning", "Afternoon", "Evening", "Night")
)

cruise_info_3hr$time_only_factor <- as.factor(cruise_info_3hr$time_only)
ggplot(cruise_info_3hr, aes(x = date, y = ch4_mean_bias, color = time_only_factor, shape=TimeOfDay)) +
  geom_point(size = 3) + scale_shape_manual(values = c("Night" = 15, "Morning" = 16, "Afternoon" = 17, "Evening" = 18)) +
  labs(
    title = "CH4 bias vs Date",
    x = "Date",
    y = "Bias",
    color = "Time (local)"  # legend title
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )

# write.csv(
#   cruise_info_3hr,
#   "/Users/reneechabot/Desktop/Seawolf/cruise4_info_3hr_avg_ALL.csv"
# )


#looking at land v water
library(sf)
library(sp)
library(terra)
library(tmap)

final_traj_filter <- trajectory_list
traj_datetimes_char <- sapply(trajectory_list, function(df) df$Starting.Date.Time[1])

traj_datetimes <- as.POSIXct(traj_datetimes_char, format = "%Y-%m-%d %H:%M", tz = "America/New_York")
cruise_datetimes <- as.POSIXct(cruise_info_3hr$date, tz = "America/New_York")
matching_indices <- which(traj_datetimes %in% cruise_datetimes)
final_traj_filter <- final_traj_filter[matching_indices]
final_traj_filter <- final_traj_filter[sapply(final_traj_filter, nrow) == 25]

states <- st_read("/Users/reneechabot/Downloads/cb_2023_us_state_500k/cb_2023_us_state_500k.shp")

lon_all <- c()
lat_all <- c()
datetime_all <- c()


for (i in seq_along(final_traj_filter)) {
  lon <- final_traj_filter[[i]][[11]][[25]]
  lat <- final_traj_filter[[i]][[10]][[25]]
  datetime <- final_traj_filter[[i]][["Starting.Date.Time"]][[1]]  
  datetime_repeated <- rep(datetime, length(lon))

  lon_all <- c(lon_all, lon)
  lat_all <- c(lat_all, lat)
  datetime_all <- c(datetime_all, datetime_repeated)
  
}

points_df <- data.frame(lon = lon_all, lat = lat_all,   datetime = datetime_all)
points_sf <- st_as_sf(points_df, coords = c("lon", "lat"), crs = st_crs(states))
inside <- st_within(points_sf, states, sparse = FALSE)
over_land <- apply(inside, 1, any)
points_df$over_land <- over_land
blank_rows <- points_df[1:2, ]
blank_rows[] <- NA  
points_df_padded <- rbind(blank_rows, points_df)
cruise_info_3hr$over_land <- points_df_padded$over_land

ggplot(cruise_info_3hr, aes(x = date, y = ch4_mean_bias, fill = over_land)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "CH4 bias vs Date",
    x = "Date",
    y = "Bias",
    fill = "Over land?"  
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )
