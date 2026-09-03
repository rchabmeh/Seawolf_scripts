##### Basic Setup- Always run. #####
#Alternative background approach pt 2: gridcell NW of LEW && W of TMD
twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "TMD"), ]
nw.gridcell <- c(41.5, -77.5)
w.gridcell <- c(39.6, -78.5)
alt.gridcells <- data.frame(
  Lat = c(nw.gridcell[1], w.gridcell[1]),
  Lon = c(nw.gridcell[2], w.gridcell[2]),
  relative_to = c("LEW", "TMD"),
  name = c("NW.GC", "W.GC")
)
##### Check location via plot- only need to run once for visual confirmation #####
#check via basic plot to see area/confirm location is good!
library(ggplot2)
library(sf)
library(sp)
library(terra)
library(tmap)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")
states <- st_transform(states, crs = 4326)
plot(
  st_geometry((states)),
  xlim = c(-79, -74),
  ylim = c(39, 41.8),
  xlab = "Longitude",
  ylab = "Latitude",
  border = "grey",
  axes = T,
  las = 1,
  asp = 1
)
points(twr$Lon,twr$Lat, pch = 23, col = "black", bg = "black")
text(twr$Lon, twr$Lat, labels = twr$SiteCode, pos = 4, cex = 0.8)

points(alt.gridcells$Lon,alt.gridcells$Lat, pch = 23, col = "red", bg = "red")
text(alt.gridcells$Lon, alt.gridcells$Lat, labels = alt.gridcells$name, pos = 4, cex = 0.8)
#ok might as well try this bitchhhh out!

##### Alternative enh pt 2!! #####
#c4.5m <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/c4_alt_models_5min_daylight.csv")
c14.5m <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/c14_alt_models_3hr_daylight.csv")

#c14.5m <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/c14_alt_models_5min_daylight.csv")
c24.5m <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_3hr_daylight.csv")

c4.5m$date <- as.POSIXct(c4.5m$date, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

c14.5m$date <- as.POSIXct(c14.5m$date, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c14.5m$date = c14.5m$date - 120

c24.5m$date <- as.POSIXct(c24.5m$date, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c24.5m$date = c24.5m$date - 60

#nw.c4.df <- data.frame(date = c4.5m$date, lon = alt.gridcells$Lon[1], lat = alt.gridcells$Lat[1])
nw.c24.df <- data.frame(date = c24.5m$date, lon = alt.gridcells$Lon[1], lat = alt.gridcells$Lat[1])
w.c14.df <- data.frame(date = c14.5m$date, lon = alt.gridcells$Lon[2], lat = alt.gridcells$Lat[2])


cruise <- "Cruise 24" ##changing variable here
cruise_squish <- tolower(gsub(" ", "_", cruise))

start_date <- as.Date(min(nw.c24.df$date)) ##changing variable here
end_date <- as.Date(max(nw.c24.df$date)) ##changing variable here

#CT
library(raster)


co2_files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_nrt_co2"
  ),
  pattern = '*.nc',
  full.names = TRUE
)

CT_CO2 <- lapply(co2_files, function(f) {
  brick(
    f,
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #lowest height
  )
})

ch4_files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_ch4_ct"
  ),
  pattern = '*.nc',
  full.names = TRUE
)

CT_CH4 <- lapply(ch4_files, function(f) {
  brick(
    f,
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #lowest height
  )
})


CT_CO2_cropped <- list()
for (i in seq_along(CT_CO2)) {
  ras_date <- as.Date(floor(as.numeric((getZ(
    CT_CO2[[i]]
  )[1]))))
  if (ras_date >= start_date && ras_date <= end_date) {
    CT_CO2_cropped[[i]] <- CT_CO2[[i]]
  }
  
}

CT_CO2_cropped <- CT_CO2_cropped[!sapply(CT_CO2_cropped, is.null)]

CT_CH4_cropped <- list()
for (i in seq_along(CT_CH4)) {
  ras_date <- as.Date(getZ(CT_CH4[[i]])[1]) #starts at 03:00 and ends the next day at 00:00
  if (ras_date >= start_date &&
      ras_date <= end_date) {
    #this is why it is mismatched later on and can't be fixed
    CT_CH4_cropped[[i]] <- CT_CH4[[i]] #but why CT_CO2 can and has been fixed
  }
  
}

CT_CH4_cropped <- CT_CH4_cropped[!sapply(CT_CH4_cropped, is.null)]

CTCO2_lists <- lapply(1:8, function(k)
  lapply(CT_CO2_cropped, function(x)
    x[[k]]))
CTCH4_lists <- lapply(1:8, function(k)
  lapply(CT_CH4_cropped, function(x)
    x[[k]]))

library(raster)
CTCO2_lists <- unlist(CTCO2_lists, recursive = FALSE)
coords <- unique(nw.c24.df[, c("lon", "lat")]) ##changing variable here
all_results <- list()


for (i in seq_along(CTCO2_lists)) {
  r_brick <- CTCO2_lists[[i]]
  
  dates <- getZ(r_brick)
  
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  hours <- as.numeric(format(dates_posix, "%H"))
  rounded_hours <- floor(hours / 3) * 3 #choosing floor instead of ceiling so 01:30 -> 00:00
  dates_posix_aligned <- as.POSIXct(paste0(
    format(dates_posix, "%Y-%m-%d "),
    sprintf("%02d:00:00", rounded_hours)
  ), tz = "UTC")
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  
  df <- data.frame(
    date = rep(as.POSIXct(dates_posix_aligned), each = nrow(coords)),
    lon  = rep(coords$lon, times = nlayers(r_brick)),
    lat  = rep(coords$lat, times = nlayers(r_brick)),
    CT.NRT_co2  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CO2_df <- do.call(rbind, all_results)

library(raster)

CTCH4_lists <- unlist(CTCH4_lists, recursive = FALSE)
coords <- unique(nw.c24.df[, c("lon", "lat")]) ##changing variable here
all_results <- list()

for (i in seq_along(CTCH4_lists)) {
  r_brick <- CTCH4_lists[[i]]
  
  dates <- getZ(r_brick)
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  
  df <- data.frame(
    date = rep(as.POSIXct(dates_posix), each = nrow(coords)),
    lon  = rep(coords$lon, times = nlayers(r_brick)),
    lat  = rep(coords$lat, times = nlayers(r_brick)),
    CT_ch4  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CH4_df <- do.call(rbind, all_results)

nw.c24.df <- merge(nw.c24.df, CT_CO2_df, by = c("date","lon", "lat")) ##changing variables here
nw.c24.df <- merge(nw.c24.df, CT_CH4_df, by = c("date","lon", "lat")) ##changing variables here


#CAMS
library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)

CAMS <- list(CH4 = list(), CO2 = list())
files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_cams"
  ),
  pattern = '\\.nc$',
  full.names = TRUE
)

level_co2 <- 1   # 0 m (lowest cuz we are not in a tower babyyyyyyy)
level_ch4 <- 1   # 378.3 m (lowest)

for (f in files) {
  
  cat("Processing:", basename(f), "\n")
  
  nc <- nc_open(f)
  var_names <- names(nc$var)
  
  if ("CH4" %in% var_names) {
    var_to_use <- "CH4"
    lvl <- level_ch4
    
  } else if ("CO2" %in% var_names) {
    var_to_use <- "CO2"
    lvl <- level_co2
    
  } else {
    nc_close(nc)
    next
  }
  
  nc_close(nc)
  
  CAMS[[var_to_use]][[length(CAMS[[var_to_use]]) + 1]] <- brick(
    f,
    varname = var_to_use,
    level = lvl
  )
}

get_timestamps <- function(nc_file) {
  
  nc <- nc_open(nc_file)
  on.exit(nc_close(nc), add = TRUE)
  
  if (!("time" %in% names(nc$dim))) {
    warning(paste("No time dimension in:", nc_file))
    return(NULL)
  }
  
  time_vals  <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  
  origin <- sub("hours since ", "", time_units)
  
  as.POSIXct(
    time_vals * 3600,
    origin = origin,
    tz = "UTC"
  )
}

all_timestamps <- lapply(files, get_timestamps)
names(all_timestamps) <- basename(files)

# optional: save matched layer info
closest_times <- data.frame()

time_tolerance_secs <- 0

# CO2 loop — only process CO2 files
for (j in seq_len(nrow(nw.c24.df))) { ##changing variable here
  target_time <- nw.c24.df$date[j] ##changing variable here
  lon <- nw.c24.df$lon[j] ##changing variable here
  lat <- nw.c24.df$lat[j] ##changing variable here
  coords <- matrix(c(lon, lat), ncol = 2)
  
  for (i in seq_along(files)) {
    # Skip non-CO2 files entirely
    if (!grepl("CO2", basename(files[i]), ignore.case = TRUE)) next
    
    timestamps <- all_timestamps[[i]]
    if (is.null(timestamps)) next
    
    file_start <- min(timestamps)
    file_end   <- max(timestamps)
    if (target_time < (file_start - time_tolerance_secs) |
        target_time > (file_end   + time_tolerance_secs)) next
    
    layer_number <- which.min(abs(difftime(timestamps, target_time, units = "secs")))
    matched_time <- timestamps[layer_number]
    
    brick_index <- sum(sapply(files[1:i], function(x)
      grepl("CO2", basename(x), ignore.case = TRUE)))
    
    r_layer <- CAMS[["CO2"]][[brick_index]][[layer_number]]
    model_value <- raster::extract(r_layer, coords)
    
    nw.c24.df$CAMS_CO2[j] <- model_value * 1e6 ##changing variable here
    
    closest_times <- rbind(closest_times, data.frame(
      cruise_row  = j,
      file        = basename(files[i]),
      variable    = "CO2",
      cruise_time = target_time,
      matched_time = matched_time,
      layer_num   = layer_number
    ))
  }
}

# CH4 loop — only process CH4 files
for (j in seq_len(nrow(nw.c24.df))) { ##changing variable here
  target_time <- nw.c24.df$date[j] ##changing variable here
  lon <- nw.c24.df$lon[j] ##changing variable here
  lat <- nw.c24.df$lat[j] ##changing variable here
  coords <- matrix(c(lon, lat), ncol = 2)
  
  for (i in seq_along(files)) {
    # Skip non-CH4 files entirely
    if (!grepl("CH4", basename(files[i]), ignore.case = TRUE)) next
    
    timestamps <- all_timestamps[[i]]
    if (is.null(timestamps)) next
    
    file_start <- min(timestamps)
    file_end   <- max(timestamps)
    if (target_time < (file_start - time_tolerance_secs) |
        target_time > (file_end   + time_tolerance_secs)) next
    
    layer_number <- which.min(abs(difftime(timestamps, target_time, units = "secs")))
    matched_time <- timestamps[layer_number]
    
    brick_index <- sum(sapply(files[1:i], function(x)
      grepl("CH4", basename(x), ignore.case = TRUE)))
    
    r_layer <- CAMS[["CH4"]][[brick_index]][[layer_number]]
    model_value <- raster::extract(r_layer, coords)
    
    nw.c24.df$CAMS_CH4[j] <- model_value  #changing variable here
    
    closest_times <- rbind(closest_times, data.frame(
      cruise_row  = j,
      file        = basename(files[i]),
      variable    = "CH4",
      cruise_time = target_time,
      matched_time = matched_time,
      layer_num   = layer_number
    ))
  }
}

write.csv(nw.c24.df,"/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/alt_gridcell_bkgrd_c24_3hr.csv")




write.csv(nw.c24.df,"/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/alt_gridcell_bkgrd_c24.csv")
write.csv(w.c14.df,"/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/alt_gridcell_bkgrd_c14.csv")






##### Testing some plots outtttt ######
#### CRUISE 4 #####
c4 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/c4_alt_models_5min_daylight.csv"
)
library(dplyr)
c4 <- c4 %>% rename(datetime_utc = date)
c4 <- c4 %>% rename(CAMS_CO2_tile = CAMS_CO2)
c4 <- c4 %>% rename(CAMS_CH4_tile = CAMS_CH4)
c4$Day = NULL
c4$time_only = NULL
c4$X = NULL
c4$datetime_utc <- as.POSIXct(c4$datetime_utc, tz = "UTC")


alt_grdcl.4 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/alt_gridcell_bkgrd_c4.csv")
alt_grdcl.4$datetime_utc <- as.POSIXct(alt_grdcl.4$date, tz = "UTC")

c4.LEW.co2 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/towers/merged_co2_cruise_4_LEW.csv"
)
c4.LEW.ch4 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/towers/merged_ch4_cruise_4_LEW.csv"
)

library(lubridate)
c4.LEW.co2 <- c4.LEW.co2 %>% mutate(datetime_utc = ymd_hms(datetime_utc, truncated = 3, tz = "UTC"))
c4.LEW.ch4 <- c4.LEW.ch4 %>% mutate(datetime_utc = ymd_hms(datetime_utc, truncated = 3, tz = "UTC"))



 test_1 <- merge(c4, c4.LEW.co2, by = "datetime_utc")
 test_2 <- merge(test_1,
                 c4.LEW.ch4,
                 by = c("datetime_utc", "SiteCode", "Lon", "Lat"))

test_3 <- merge(c4, alt_grdcl.4, by = "datetime_utc")

point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)

c4_loc.filter <- test_2 %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
c4_loc.filter <- c4_loc.filter %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])


c4_loc.filter.2 <- test_3 %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
c4_loc.filter.2 <- c4_loc.filter.2 %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])


fifth_bkgrd <- readRDS("/Users/reneechabot-mehlin/Desktop/model_plotting/5th_per_bkgrds.RDS")

ct_co2_enh_L4 <- c4_loc.filter$CT_CO2_tile - c4_loc.filter$CT.NRT_co2
ct_ch4_enh_L4 <- (c4_loc.filter$CT_CH4_tile * 1000) - c4_loc.filter$CT_ch4

cams_co2_enh_L4 <- c4_loc.filter$CAMS_CO2_tile - c4_loc.filter$CAMS_CO2
cams_ch4_enh_L4 <- (c4_loc.filter$CAMS_CH4_tile * 1000) - c4_loc.filter$CAMS_CH4

ct_co2_enh_L4.A <- c4_loc.filter.2$CT_CO2_tile - c4_loc.filter.2$CT.NRT_co2
ct_ch4_enh_L4.A <- (c4_loc.filter.2$CT_CH4_tile * 1000) - c4_loc.filter.2$CT_ch4

cams_co2_enh_L4.A <- c4_loc.filter.2$CAMS_CO2_tile - c4_loc.filter.2$CAMS_CO2
cams_ch4_enh_L4.A <- (c4_loc.filter.2$CAMS_CH4_tile * 1000) - c4_loc.filter.2$CAMS_CH4


obs_co2_enh_L4 <- c4_loc.filter$CO2_dry_cal_moving_day - c4_loc.filter$co2_ppm
obs_ch4_enh_L4 <- (c4_loc.filter$CH4_dry_cal_moving_day * 1000) - c4_loc.filter$ch4_ppb

fifth_co2_enh_L4 <- c4_loc.filter$CO2_dry_cal_moving_day - fifth_bkgrd$co2[1] 
fifth_ch4_enh_L4 <- (c4_loc.filter$CH4_dry_cal_moving_day * 1000) - (fifth_bkgrd$ch4[1] * 1000) 

library(ggplot2)

enh_df <- data.frame(
  datetime_utc = c4_loc.filter$datetime_utc,
  
  obs_co2  = obs_co2_enh_L4,
  ct_co2   = ct_co2_enh_L4,
  cams_co2 = cams_co2_enh_L4,
  ct_co2.A = ct_co2_enh_L4.A,
  cams_co2.A = cams_co2_enh_L4.A,
  
   obs_ch4  = obs_ch4_enh_L4,
  ct_ch4   = ct_ch4_enh_L4,
  cams_ch4 = cams_ch4_enh_L4,
  ct_ch4.A = ct_ch4_enh_L4.A,
  cams_ch4.A = cams_ch4_enh_L4.A
)
enh_df.c4.match <- enh_df

# Long format using base R
enh_long <- rbind(
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$obs_co2,
    Source = "Observations",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_co2,
    Source = "CarbonTracker",
    Gas = "CO2"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_co2.A,
    Source = "CarbonTracker (alternative gridcell)",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_co2,
    Source = "CAMS",
    Gas = "CO2"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_co2.A,
    Source = "CAMS (alternative gridcell)",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$obs_ch4,
    Source = "Observations",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_ch4,
    Source = "CarbonTracker",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_ch4.A,
    Source = "CarbonTracker (alternative gridcell)",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_ch4,
    Source = "CAMS",
    Gas = "CH4"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_ch4.A,
    Source = "CAMS (alternative gridcell)",
    Gas = "CH4"
  )
)

enh_long$ShapeGroup <- ifelse(
  grepl("CarbonTracker", enh_long$Source), "CT",
  ifelse(
    grepl("CAMS", enh_long$Source), "CAMS",
    "OBS"
  )
)

p1.4 <- ggplot(enh_long, aes(x = datetime_utc, y = Enhancement, color = Source, shape = ShapeGroup)) +
  geom_line() + geom_point(size = 4, alpha = 0.5) +
  scale_shape_manual(values = c(
    "OBS"  = 16,  # filled circle
    "CT"   = 17,  # triangle
    "CAMS" = 15   # square
  )) +
  scale_color_manual(values = c(
    "CAMS" = "black",
    "CAMS (alternative gridcell)" = "red",
    "CarbonTracker" = "green",
    "CarbonTracker (alternative gridcell)" = "blue",
    "Observations" = "orange"
  )) +
  facet_wrap( ~ Gas, scales = "free_y", ncol = 1) +
  theme_bw() +
  labs(
    x = "Date/Time (UTC)",
    y = "Enhancement",
    color = "Source",
    title = "Cruise 4 Enhancements",
    subtitle = "Exact Time Match"
  ) + 
  theme(text = element_text(size = 20))
#### CRUISE 14 #####
c14 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/c14_alt_models_5min_daylight.csv"
)
library(dplyr)
c14 <- c14 %>% rename(datetime_utc = date)
c14 <- c14 %>% rename(CAMS_CO2_tile = CAMS_CO2)
c14 <- c14 %>% rename(CAMS_CH4_tile = CAMS_CH4)
c14$Day = NULL
c14$time_only = NULL
c14$X = NULL
c14$datetime_utc <- as.POSIXct(c14$datetime_utc, tz = "UTC")
c14$datetime_utc <- c14$datetime_utc -120

alt_grdcl.14 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/alt_gridcell_bkgrd_c14.csv")
alt_grdcl.14$datetime_utc <- as.POSIXct(alt_grdcl.14$date, tz = "UTC")

c14.TMD.co2 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/towers/merged_co2_cruise_14_TMD.csv"
)
c14.TMD.ch4 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/towers/merged_ch4_cruise_14_TMD.csv"
)

library(lubridate)
c14.TMD.co2 <- c14.TMD.co2 %>% mutate(datetime_utc = ymd_hms(datetime_utc, truncated = 3, tz = "UTC"))
c14.TMD.ch4 <- c14.TMD.ch4 %>% mutate(datetime_utc = ymd_hms(datetime_utc, truncated = 3, tz = "UTC"))



test_1 <- merge(c14, c14.TMD.co2, by = "datetime_utc")
test_2 <- merge(test_1,
                c14.TMD.ch4,
                by = c("datetime_utc", "SiteCode", "Lon", "Lat"))

test_3 <- merge(c14, alt_grdcl.14, by = "datetime_utc")

point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)

c14_loc.filter <- test_2 %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
c14_loc.filter <- c14_loc.filter %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])


c14_loc.filter.2 <- test_3 %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
c14_loc.filter.2 <- c14_loc.filter.2 %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])

fifth_bkgrd <- readRDS("/Users/reneechabot-mehlin/Desktop/model_plotting/5th_per_bkgrds.RDS")

ct_co2_enh_L14 <- c14_loc.filter$CT_CO2_tile - c14_loc.filter$CT.NRT_co2.x
ct_ch4_enh_L14 <- (c14_loc.filter$CT_CH4_tile * 1000) - c14_loc.filter$CT_ch4.x

cams_co2_enh_L14 <- c14_loc.filter$CAMS_CO2_tile - c14_loc.filter$CAMS_CO2
cams_ch4_enh_L14 <- (c14_loc.filter$CAMS_CH4_tile * 1000) - c14_loc.filter$CAMS_CH4

ct_co2_enh_L14.A <- c14_loc.filter.2$CT_CO2_tile - c14_loc.filter.2$CT.NRT_co2
ct_ch4_enh_L14.A <- (c14_loc.filter.2$CT_CH4_tile * 1000) - c14_loc.filter.2$CT_ch4

cams_co2_enh_L14.A <- c14_loc.filter.2$CAMS_CO2_tile - c14_loc.filter.2$CAMS_CO2
cams_ch4_enh_L14.A <- (c14_loc.filter.2$CAMS_CH4_tile * 1000) - c14_loc.filter.2$CAMS_CH4

obs_co2_enh_L14 <- c14_loc.filter$CO2_dry_cal_moving_day - c14_loc.filter$co2_ppm
obs_ch4_enh_L14 <- (c14_loc.filter$CH4_dry_cal_moving_day * 1000) - c14_loc.filter$ch4_ppb

fifth_co2_enh_L14 <- c14_loc.filter$CO2_dry_cal_moving_day - fifth_bkgrd$co2[2] 
fifth_ch4_enh_L14 <- (c14_loc.filter$CH4_dry_cal_moving_day * 1000) - (fifth_bkgrd$ch4[2] * 1000) 

library(ggplot2)

enh_df <- data.frame(
  datetime_utc = c14_loc.filter$datetime_utc,
  
  obs_co2  = obs_co2_enh_L14,
  ct_co2   = ct_co2_enh_L14,
  cams_co2 = cams_co2_enh_L14,
  ct_co2.A = ct_co2_enh_L14.A,
  cams_co2.A = cams_co2_enh_L14.A,
  
  obs_ch4  = obs_ch4_enh_L14,
  ct_ch4   = ct_ch4_enh_L14,
  cams_ch4 = cams_ch4_enh_L14,
  ct_ch4.A = ct_ch4_enh_L14.A,
  cams_ch4.A = cams_ch4_enh_L14.A
)
enh_df.c14.match <- enh_df

# Long format using base R
enh_long <- rbind(
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$obs_co2,
    Source = "Observations",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_co2,
    Source = "CarbonTracker",
    Gas = "CO2"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_co2.A,
    Source = "CarbonTracker (alternative gridcell)",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_co2,
    Source = "CAMS",
    Gas = "CO2"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_co2.A,
    Source = "CAMS (alternative gridcell)",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$obs_ch4,
    Source = "Observations",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_ch4,
    Source = "CarbonTracker",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_ch4.A,
    Source = "CarbonTracker (alternative gridcell)",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_ch4,
    Source = "CAMS",
    Gas = "CH4"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_ch4.A,
    Source = "CAMS (alternative gridcell)",
    Gas = "CH4"
  )
)

enh_long$ShapeGroup <- ifelse(
  grepl("CarbonTracker", enh_long$Source), "CT",
  ifelse(
    grepl("CAMS", enh_long$Source), "CAMS",
    "OBS"
  )
)

p1.14 <- ggplot(enh_long, aes(x = datetime_utc, y = Enhancement, color = Source, shape = ShapeGroup)) +
  geom_line() + geom_point(size = 4, alpha = 0.5) +
  scale_shape_manual(values = c(
    "OBS"  = 16,  # filled circle
    "CT"   = 17,  # triangle
    "CAMS" = 15   # square
  )) +
  scale_color_manual(values = c(
    "CAMS" = "black",
    "CAMS (alternative gridcell)" = "red",
    "CarbonTracker" = "green",
    "CarbonTracker (alternative gridcell)" = "blue",
    "Observations" = "orange"
  )) +
  facet_wrap( ~ Gas, scales = "free_y", ncol = 1) +
  theme_bw() +
  labs(
    x = "Date/Time (UTC)",
    y = "Enhancement",
    color = "Source",
    title = "Cruise 14 Enhancements",
    subtitle = "Exact Time Match"
  ) + 
  theme(text = element_text(size = 20))
#### CRUISE 24 #####
c24 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_5min_daylight.csv"
)
library(dplyr)
c24 <- c24 %>% rename(datetime_utc = date)
c24 <- c24 %>% rename(CAMS_CO2_tile = CAMS_CO2)
c24 <- c24 %>% rename(CAMS_CH4_tile = CAMS_CH4)
c24$Day = NULL
c24$time_only = NULL
c24$X = NULL
c24$datetime_utc <- as.POSIXct(c24$datetime_utc, tz = "UTC")
c24$datetime_utc <- c24$datetime_utc -60

alt_grdcl.24 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/alt_gridcell_bkgrd_c24.csv")
alt_grdcl.24$datetime_utc <- as.POSIXct(alt_grdcl.24$date, tz = "UTC")

c24.LEW.co2 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/towers/merged_co2_cruise_24_LEW.csv"
)
c24.LEW.ch4 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/towers/merged_ch4_cruise_24_LEW.csv"
)

library(lubridate)
c24.LEW.co2 <- c24.LEW.co2 %>% mutate(datetime_utc = ymd_hms(datetime_utc, truncated = 3, tz = "UTC"))
c24.LEW.ch4 <- c24.LEW.ch4 %>% mutate(datetime_utc = ymd_hms(datetime_utc, truncated = 3, tz = "UTC"))



test_1 <- merge(c24, c24.LEW.co2, by = "datetime_utc")
test_2 <- merge(test_1,
                c24.LEW.ch4,
                by = c("datetime_utc", "SiteCode", "Lon", "Lat"))

test_3 <- merge(c24, alt_grdcl.24, by = "datetime_utc")

point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)

c24_loc.filter <- test_2 %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
c24_loc.filter <- c24_loc.filter %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])


c24_loc.filter.2 <- test_3 %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
c24_loc.filter.2 <- c24_loc.filter.2 %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])

fifth_bkgrd <- readRDS("/Users/reneechabot-mehlin/Desktop/model_plotting/5th_per_bkgrds.RDS")

ct_co2_enh_L24 <- c24_loc.filter$CT_CO2_tile - c24_loc.filter$CT.NRT_co2
ct_ch4_enh_L24 <- (c24_loc.filter$CT_CH4_tile * 1000) - c24_loc.filter$CT_ch4

cams_co2_enh_L24 <- c24_loc.filter$CAMS_CO2_tile - c24_loc.filter$CAMS_CO2
cams_ch4_enh_L24 <- (c24_loc.filter$CAMS_CH4_tile * 1000) - c24_loc.filter$CAMS_CH4

ct_co2_enh_L24.A <- c24_loc.filter.2$CT_CO2_tile - c24_loc.filter.2$CT.NRT_co2
ct_ch4_enh_L24.A <- (c24_loc.filter.2$CT_CH4_tile * 1000) - c24_loc.filter.2$CT_ch4

cams_co2_enh_L24.A <- c24_loc.filter.2$CAMS_CO2_tile - c24_loc.filter.2$CAMS_CO2
cams_ch4_enh_L24.A <- (c24_loc.filter.2$CAMS_CH4_tile * 1000) - c24_loc.filter.2$CAMS_CH4


obs_co2_enh_L24 <- c24_loc.filter$CO2_dry_cal_moving_day - c24_loc.filter$co2_ppm
obs_ch4_enh_L24 <- (c24_loc.filter$CH4_dry_cal_moving_day * 1000) - c24_loc.filter$ch4_ppb

fifth_co2_enh_L24 <- c24_loc.filter$CO2_dry_cal_moving_day - fifth_bkgrd$co2[3] 
fifth_ch4_enh_L24 <- (c24_loc.filter$CH4_dry_cal_moving_day * 1000) - (fifth_bkgrd$ch4[3] * 1000) 

library(ggplot2)

enh_df <- data.frame(
  datetime_utc = c24_loc.filter$datetime_utc,
  
  obs_co2  = obs_co2_enh_L24,
  ct_co2   = ct_co2_enh_L24,
  cams_co2 = cams_co2_enh_L24,
  ct_co2.A = ct_co2_enh_L24.A,
  cams_co2.A = cams_co2_enh_L24.A,
  
  obs_ch4  = obs_ch4_enh_L24,
  ct_ch4   = ct_ch4_enh_L24,
  cams_ch4 = cams_ch4_enh_L24,
  ct_ch4.A = ct_ch4_enh_L24.A,
  cams_ch4.A = cams_ch4_enh_L24.A
)
enh_df.c24.match <- enh_df

# Long format using base R
enh_long <- rbind(
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$obs_co2,
    Source = "Observations",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_co2,
    Source = "CarbonTracker",
    Gas = "CO2"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_co2.A,
    Source = "CarbonTracker (alternative gridcell)",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_co2,
    Source = "CAMS",
    Gas = "CO2"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_co2.A,
    Source = "CAMS (alternative gridcell)",
    Gas = "CO2"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$obs_ch4,
    Source = "Observations",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_ch4,
    Source = "CarbonTracker",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$ct_ch4.A,
    Source = "CarbonTracker (alternative gridcell)",
    Gas = "CH4"
  ),
  
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_ch4,
    Source = "CAMS",
    Gas = "CH4"
  ),
  data.frame(
    datetime_utc = enh_df$datetime_utc,
    Enhancement = enh_df$cams_ch4.A,
    Source = "CAMS (alternative gridcell)",
    Gas = "CH4"
  )
)

enh_long$ShapeGroup <- ifelse(
  grepl("CarbonTracker", enh_long$Source), "CT",
  ifelse(
    grepl("CAMS", enh_long$Source), "CAMS",
    "OBS"
  )
)

p1.24 <- ggplot(enh_long, aes(x = datetime_utc, y = Enhancement, color = Source, shape = ShapeGroup)) +
  geom_line() + geom_point(size = 4, alpha = 0.5) +
  scale_shape_manual(values = c(
    "OBS"  = 16,  # filled circle
    "CT"   = 17,  # triangle
    "CAMS" = 15   # square
  )) +
  scale_color_manual(values = c(
    "CAMS" = "black",
    "CAMS (alternative gridcell)" = "red",
    "CarbonTracker" = "green",
    "CarbonTracker (alternative gridcell)" = "blue",
    "Observations" = "orange"
  )) +
  facet_wrap( ~ Gas, scales = "free_y", ncol = 1) +
  theme_bw() +
  labs(
    x = "Date/Time (UTC)",
    y = "Enhancement",
    color = "Source",
    title = "Cruise 24 Enhancements",
    subtitle = "Exact Time Match"
  ) + 
  theme(text = element_text(size = 20))


p1.4
p1.14
p1.24