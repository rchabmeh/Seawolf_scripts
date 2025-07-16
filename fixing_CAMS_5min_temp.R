cruise <- "Cruise 24"
##### Loading in cruise information #####
cruise_info <- read.delim(
  "/Users/reneechabot-mehlin/Desktop/cruise24_eulerian/all_data_cruise24.txt",
  sep = ",",
  dec = "."
)

names(cruise_info)[names(cruise_info) == "co2_subrange"] <- "CO2_dry_cal_moving_day"
names(cruise_info)[names(cruise_info) == "ch4_subrange"] <- "CH4_dry_cal_moving_day"
names(cruise_info)[names(cruise_info) == "time_local_subrange"] <- "Time_local"
names(cruise_info)[names(cruise_info) == "time_utc_subrange"] <- "Time_UTC"
names(cruise_info)[names(cruise_info) == "latitude_deg_subrange"] <- "Latitude_deg"
names(cruise_info)[names(cruise_info) == "longitude_deg_subrange"] <- "Longitude_deg"

cruise_info <- cruise_info[!is.na(cruise_info$Longitude_deg), ]
cruise_info <- cruise_info[!is.na(cruise_info$CO2_dry_cal_moving_day), ]
cruise_info$Time_local <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "America/New_York")
cruise_info$Time_UTC <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "UTC")

library(openair)
colnames(cruise_info)[colnames(cruise_info) == "Time_UTC"] <- "date"
cruise_info$Day <- as.Date(cruise_info$date)
cruise_info_5min <- timeAverage(
  cruise_info,
  avg.time = "5 min",
  data.thresh = 0,
  statistic = "mean",
  start.date = min(cruise_info$Day),
  end.date =  max(cruise_info$Day) + 1)

library(hms)
cruise_info_5min$time_only <- as_hms(cruise_info_5min$date)
cruise_info_5min <- cruise_info_5min[!is.na(cruise_info_5min$Longitude_deg), ]

###### Loading in CAMS information #####
library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)
CAMS <- list()
all_timestamps <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/cruise24_eulerian/cams_global_inversion_optimized_ghg_fluxes',
  pattern = '\\.nc$',
  full.names = TRUE
)
states <- st_read(
  "/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
east_coast_states <- c(
  "Maine", "New Hampshire", "Massachusetts", "Rhode Island", "Connecticut",
  "New York", "New Jersey", "Delaware", "Maryland", "Virginia",
  "North Carolina", "South Carolina", "Georgia", "Florida", "Pennsylvania", "Vermont"
)
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states)
east_extent <- extent(-85, -65, 25, 47)

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
  
  # Read timestamps
  if ("time" %in% names(nc$dim)) {
    time_vals <- ncvar_get(nc, "time")
    time_units <- ncatt_get(nc, "time", "units")$value
    origin <- sub("hours since ", "", time_units)
    timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  } else {
    warning("No time dimension in:", f)
    nc_close(nc)
    next
  }
  nc_close(nc)
  
  # Load all time layers
  r <- stack(f, varname = var_to_use)
  
  # Ensure CRS matches shapefile
  if (is.na(crs(r))) {
    crs(r) <- st_crs(east_states_sf)$proj4string
  }
  
  # Crop and mask
  r <- crop(r, east_extent)
  r <- mask(r, east_states_sf)
  
  # Unit fix for CO2
  if (var_to_use == "CO2") {
    r <- calc(r, function(x) x * 1e6)
  }
  
  file_key <- basename(f)  # Use file name as key
  CAMS[[file_key]] <- r
  all_timestamps[[file_key]] <- timestamps
}
east_states_sf <- st_transform(east_states_sf, crs = st_crs(CAMS[[1]]))
CAMS_df_list <- lapply(names(CAMS), function(file_key) {
  ras <- CAMS[[file_key]]
  
  if (is.null(ras)) return(NULL)
  
  df <- as.data.frame(ras, xy = TRUE)
  df <- na.omit(df)
  # Example dataframe df with first two columns lon, lat and the rest timestamp columns
  # Rename only from column 3 onward
  
  names(df)[3:ncol(df)] <- {
    cn <- names(df)[3:ncol(df)]         # subset column names
    cn <- sub("^X", "", cn)             # remove leading X
    
    # Use regmatches + regexec to extract date/time parts
    parts <- regmatches(cn, regexec("^([0-9]{4})\\.([0-9]{2})\\.([0-9]{2})(.*)$", cn))
    
    sapply(parts, function(p) {
      if (length(p) == 0) return(NA_character_)
      date_part <- paste0(p[2], "-", p[3], "-", p[4])
      time_part <- p[5]
      if (time_part == "") {
        time_part <- " 00:00:00"
      } else {
        time_part <- gsub("\\.", ":", sub("^\\.", " ", time_part))
      }
      paste0(date_part, time_part)
    })
  }
  library(tidyr)
  df_long <- pivot_longer(
    df,
    cols = -(1:2),               # all columns except lat and long
    names_to = "date",           # new column name for former column headers
    values_to = "concentration"  # new column name for values
  )
  df_long$date <- as.POSIXct(df_long$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

  df_long$gas <- ifelse(grepl("CO2", file_key, ignore.case = TRUE), "CO2", "CH4")
  df_long$source <- file_key
  
  df_long
})

##### Plotting- probably will need to edit ####
# Choose Layer and Plot Date
layer_number <- 1 #this will change depending on date/time (out of 120)
co2_file <- files[3]
nc <- nc_open(co2_file)
time_vals <- ncvar_get(nc, "time")
time_units <- ncatt_get(nc, "time", "units")$value
nc_close(nc)
origin <- sub("hours since ", "", time_units)
timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
plot_date <- timestamps[layer_number]
plot_date_str <- format(plot_date, "%Y-%m-%d %H:%M UTC")
#co2
ggplot() +
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
#Choose Layer and plot date
ch4_file <- files[1]  
nc <- nc_open(ch4_file)
time_vals <- ncvar_get(nc, "time")
time_units <- ncatt_get(nc, "time", "units")$value
nc_close(nc)

origin <- sub("hours since ", "", time_units)
timestamps_ch4 <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
plot_date_ch4 <- timestamps_ch4[layer_number]
plot_date_str_ch4 <- format(plot_date_ch4, "%Y-%m-%d %H:%M UTC")
#ch4
ggplot() +
  geom_raster(data = ch4_df, aes(x = x, y = y, fill = CH4)) +
  geom_sf(data = east_states_sf, fill = NA, color = "black", linewidth = 0.3) +
  scale_fill_viridis_c(option = "C") +
  coord_sf(xlim = c(-85, -65), ylim = c(25, 47), expand = FALSE) +
  labs(
    title = paste("CH4 Concentration on", plot_date_str_ch4),
    fill = "CH4 (ppb)",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal()

##matching dates 
##### EDITS ######
library(raster)
cam_times <- c(
  all_timestamps[[1]], 
  all_timestamps[[2]],
  all_timestamps[[3]],
  all_timestamps[[4]]
)
library(raster)
library(dplyr)

CAMS_flat <- unlist(lapply(CAMS, function(r) {
  if (nlayers(r) > 1) {
    raster::unstack(r)
  } else {
    r
  }
}), recursive = FALSE)
# Flatten timestamps into single vector
cam_times <- unlist(all_timestamps)

if (length(cam_times) != length(CAMS_flat)) {
  stop(paste0("Mismatch: cam_times length = ", length(cam_times),
              ", CAMS_flat length = ", length(CAMS_flat)))
}

gas_types <- sapply(names(CAMS_flat), function(nm) {
  if (grepl("co2", nm, ignore.case = TRUE)) {
    "CO2"
  } else if (grepl("ch4", nm, ignore.case = TRUE)) {
    "CH4"
  } else {
    NA  # fallback if neither string found
  }
})


co2_idx <- which(gas_types == "CO2")
ch4_idx <- which(gas_types == "CH4")

CAMS_CO2 <- CAMS_flat[co2_idx]
times_CO2 <- cam_times[co2_idx]

CAMS_CH4 <- CAMS_flat[ch4_idx]
times_CH4 <- cam_times[ch4_idx]

extract_closest_value <- function(lat, lon, datetime, raster_list, raster_times, max_time_diff = 1800) {
  time_diffs <- abs(difftime(raster_times, datetime, units = "secs"))
  closest_idx <- which.min(time_diffs)
  if (time_diffs[closest_idx] > max_time_diff) return(NA)
  val <- raster::extract(raster_list[[closest_idx]], matrix(c(lon, lat), ncol = 2))
  return(val)
}

cruise_info_5min$CO2_value <- mapply(
  extract_closest_value,
  lat = cruise_info_5min$Latitude_deg,
  lon = cruise_info_5min$Longitude_deg,
  datetime = cruise_info_5min$date,
  MoreArgs = list(raster_list = CAMS_CO2, raster_times = times_CO2)
)

cruise_info_5min$CH4_value <- mapply(
  extract_closest_value,
  lat = cruise_info_5min$Latitude_deg,
  lon = cruise_info_5min$Longitude_deg,
  datetime = cruise_info_5min$date,
  MoreArgs = list(raster_list = CAMS_CH4, raster_times = times_CH4)
)

# Remove rows where either CO2_value or CH4_value is NA
cruise_info_5min <- cruise_info_5min[ !is.na(cruise_info_5min$CO2_value) & !is.na(cruise_info_5min$CH4_value), ]
cruise_info_5min$CH4_value <- cruise_info_5min$CH4_value/1000

cruise_info_5min$CAMS_bias_co2 <- cruise_info_5min$CO2_value - cruise_info_5min$CO2_dry_cal_moving_day
cruise_info_5min$CAMS_bias_ch4 <- cruise_info_5min$CH4_value - cruise_info_5min$CH4_dry_cal_moving_day
cruise_info_5min$CAMS_bias_co2_sd <- sd(cruise_info_5min$CAMS_bias_co2, na.rm = T)
cruise_info_5min$CAMS_bias_ch4_sd <- sd(cruise_info_5min$CAMS_bias_ch4, na.rm =T)

