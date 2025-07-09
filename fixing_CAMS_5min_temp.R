cruise <- "Cruise 24"
#need full cruise information
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
  statistic = "mean"
)
library(hms)
cruise_info_5min$time_only <- as_hms(cruise_info_5min$date)


library(raster)
library(ncdf4)
library(ggplot2)
library(sf)
library(dplyr)
CAMS <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/cruise24_eulerian/cams_global_inversion_optimized_ghg_fluxes',
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
  "/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)

east_coast_states <- c(
  "Maine", "New Hampshire", "Massachusetts", "Rhode Island", "Connecticut",
  "New York", "New Jersey", "Delaware", "Maryland", "Virginia",
  "North Carolina", "South Carolina", "Georgia", "Florida", "Pennsylvania", "Vermont"
)

east_states_sf <- states %>%
  filter(NAME %in% east_coast_states)
east_states_sf <- st_transform(east_states_sf, crs = st_crs(CAMS[[1]]))
east_extent <- extent(-85, -65, 25, 47)
names(CAMS)
CAMS_cropped <- mapply(function(ras, ras_name) {
  if (grepl("CO2", ras_name, ignore.case = TRUE)) {
    cat("Cropping CO2:", ras_name, "\n")
    ras <- crop(ras, east_extent)
    ras <- mask(ras, east_states_sf)
    ras <- ras * 1e6  # unit fix for CO2
  } else if (grepl("CH4", ras_name, ignore.case = TRUE)) {
    cat("Cropping CH4:", ras_name, "\n")
    ras <- crop(ras, east_extent)
    ras <- mask(ras, east_states_sf)
    # no unit fix for CH4
  } else {
    cat("Skipping:", ras_name, "\n")
  }
  return(ras)
}, CAMS, names(CAMS), SIMPLIFY = FALSE)
CAMS_df_list <- lapply(seq_along(CAMS_cropped), function(i) {
  ras <- CAMS_cropped[[i]]
  ras_name <- names(CAMS_cropped)[i]
  
  if (is.null(ras)) return(NULL)  # skip if it wasn't matched
  
  df <- as.data.frame(ras, xy = TRUE)
  
  if (grepl("CO2", ras_name, ignore.case = TRUE)) {
    names(df)[3] <- "CO2"
  } else if (grepl("CH4", ras_name, ignore.case = TRUE)) {
    names(df)[3] <- "CH4"
  }
  
  df$source <- ras_name
  return(df)
})
# Remove any NULLs if some rasters were skipped
CAMS_df_list <- Filter(Negate(is.null), CAMS_df_list)

#can now choose from CAMS_cropped
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


#problem is not going through all CAMS times (full month data)
#Date info is cruise_info_5min$date in UTC
library(ncdf4)
library(raster)
library(dplyr)
traj_dates_utc <- as.POSIXct(cruise_info_5min$date, tz = "UTC")
extract_cams_values_by_traj_dates <- function(nc_files, variable, traj_dates) {
  results_list <- list()  # more efficient than rbind in a loop
  row_idx <- 1
  
  for (f in nc_files) {
    cat("Checking:", f, "\n")
    nc <- nc_open(f)
    
    if (!(variable %in% names(nc$var))) {
      nc_close(nc)
      next
    }
    # Get timestamps from NetCDF
    time_vals <- ncvar_get(nc, "time")
    time_units <- ncatt_get(nc, "time", "units")$value
    origin <- sub("hours since ", "", time_units)
    timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
    
    for (td in traj_dates) {
      idx <- which.min(abs(difftime(timestamps, td, units = "secs")))
      
      if (length(idx) == 0 || is.na(idx)) next
      
      if (abs(difftime(timestamps[idx], td, units = "hours")) <= 1) {
        band <- (idx - 1) * 34 + 1  # adjust for your band structure
        
        val <- tryCatch({
          r <- raster(f, varname = variable, band = band)
          mean(values(r), na.rm = TRUE)
        }, error = function(e) {
          warning(paste("Failed at", f, "band", band, ":", e$message))
          NA
        })
        
        if (!is.na(val)) {
          results_list[[row_idx]] <- data.frame(
            traj_datetime_utc = as.POSIXct(td, tz = "UTC"),
            matched_cams_datetime = as.POSIXct(timestamps[idx], tz = "UTC"),
            value = val,
            stringsAsFactors = FALSE
          )
          row_idx <- row_idx + 1
        }
      }
    }
    nc_close(nc)
  }
  results <- bind_rows(results_list)
  
  return(results)
}

co2_df <- extract_cams_values_by_traj_dates(files, "CO2", traj_dates_utc)
ch4_df <- extract_cams_values_by_traj_dates(files, "CH4", traj_dates_utc)

