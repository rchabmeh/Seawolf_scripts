##### Models- single day ####
###### Libraries #####
library(raster)
library(sp)
library(ggplot2)
library(sf)
library(dplyr)
library(fields)
library(paletteer)
library(tidyr)
library(cowplot)
library(FNN)
###### Tower Sites ####
twrs <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twrs <- subset(twrs, SiteCode %in% c("LEW", "TMD", "WNJ"))
###### Carbon Tracker  ####
#CT-NRT CO2 (4/10/22 all day)
CT_CO2_NRT <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/carbon_tracker_test/co2-nrt',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #33 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
  )
  CT_CO2_NRT[[i]] <- nc
}
#CT CO2 (4/10/22 all day)
CT_CO2 <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/carbon_tracker_test/co2',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #33 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
  )
  CT_CO2[[i]] <- nc
}
#CT CH4 (4/10/22 all day)
CT_CH4 <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/carbon_tracker_test',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #34.5 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
  )
  CT_CH4[[i]] <- nc
}
#Setting time intervals to figure out which times to grab
library(ncdf4)
library(raster)
library(lubridate)

files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/carbon_tracker_test/co2-nrt',
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

interval_labels$Times_NY <- paste0(format(start_ny, "%H:%M"), "–", format(end_ny, "%H:%M %Z"))

print(interval_labels)
#subsetting time intervals chosen above
CTCO2_NRT_6 <- list()
for (i in seq_along(CT_CO2_NRT)) {
  CTCO2_NRT_6[[i]] <- CT_CO2_NRT[[i]][[6]]
}
CTCO2_6 <- list()
for (i in seq_along(CT_CO2)) {
  CTCO2_6[[i]] <- CT_CO2[[i]][[6]]
}
CTCH4_6 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_6[[i]] <- CT_CH4[[i]][[6]]
}
###### Load in state files for domain #####
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
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states) %>%
  st_transform(crs = st_crs(CT_CO2[[1]]))
east_extent <- extent(-85, -65, 25, 47)


###### CAMS #####
#Load in CAMS files
CAMS <- list(CH4 = list(), CO2 = list())

files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/cams_test',
  pattern = '\\.nc$',
  full.names = TRUE
)

level_co2 <- 3  # 43.3 m for CAMS CO2
level_ch4 <- 1 #378.3 m for CAMS CH4 (lowest)

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
  
  r_stack <- brick(f, varname = var_to_use, level = lvl)
  
  CAMS[[var_to_use]] <- r_stack
}
#Timestamps
get_timestamps <- function(nc_file) {
  nc <- nc_open(nc_file)
  on.exit(nc_close(nc), add = TRUE)
  
  if (!("time" %in% names(nc$dim))) {
    warning(paste("No 'time' dimension in:", nc_file))
    return(NULL)
  }
  
  time_vals <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  
  origin <- sub("hours since ", "", time_units)
  
  timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  
  return(timestamps)
}
all_timestamps <- lapply(files, get_timestamps)
names(all_timestamps) <- basename(files)

target_date_alt <- as.POSIXct("2022-04-10 16:00:00", tz = "UTC")
closest_times <- data.frame(
  file = character(),
  variable = character(),
  closest_time = as.POSIXct(character()),
  closest_time_str = character(),
  layer_num = character(),
  stringsAsFactors = FALSE
)

for (i in seq_along(files)) {
  timestamps <- all_timestamps[[i]]
  
  layer_number <- which.min(abs(difftime(timestamps, target_date_alt, units = "secs")))
  
  plot_date <- timestamps[layer_number]
  file_type <- if (grepl("CO2", basename(files[i]), ignore.case = TRUE)) {
    "CO2"
  } else if (grepl("CH4", basename(files[i]), ignore.case = TRUE)) {
    "CH4"
  } else {
    "Unknown"
  }
  
  closest_times <- rbind(
    closest_times,
    data.frame(
      file = basename(files[i]),
      variable = file_type,
      closest_time = plot_date,
      closest_time_str = format(plot_date, "%Y-%m-%d %H:%M UTC"),
      layer_num = layer_number
    )
  )
}

# Extract cropped rasters for the selected time layer
CH4_cropped <- crop(CAMS[[1]][[closest_times$layer_num[1]]], east_extent)
CO2_cropped <- crop(CAMS[[2]][[closest_times$layer_num[2]]], east_extent)
CO2_cropped <- CO2_cropped * 1e6  # Convert to ppm

# Convert to dataframes for plotting
ch4_df <- as.data.frame(CH4_cropped, xy = TRUE)
co2_df <- as.data.frame(CO2_cropped, xy = TRUE)

names(ch4_df)[3] <- "CH4"
names(co2_df)[3] <- "CO2"

ch4_df$Source = "CAMS"
ch4_df$time = closest_times$closest_time[1]
CAMS_CH4.df <-  ch4_df

co2_df$Source = "CAMS"
co2_df$time = closest_times$closest_time[2]
CAMS_CO2.df <- co2_df

###### Color Scales #####
#Setting color scale for CO2 Plots
target_date <- as.Date("2022-04-10")
all_vals_co2 <- c()
for (i in seq_along(CTCO2_NRT_6)) {
  name_string <- CTCO2_NRT_6[[i]]@data@names[[1]]
  
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  
  if (as.Date(date_string) == target_date) {
    cropped <- crop(CTCO2_NRT_6[[i]], east_extent)
    
    all_vals_co2 <- c(all_vals_co2, values(cropped))
  }
}

for (i in seq_along(CTCO2_6)) {
  name_string <- CTCO2_6[[i]]@data@names[[1]]
  
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  
  if (as.Date(date_string) == target_date) {
    cropped <- crop(CTCO2_6[[i]], east_extent)
    
    all_vals_co2 <- c(all_vals_co2, values(cropped))
  }
}

all_vals_co2 <- c(all_vals_co2, co2_df$CO2)
shared_z_range_co2 <- range(all_vals_co2, na.rm = TRUE)
#Setting color scale for CH4 Plots
all_vals_ch4 <- c()
for (i in seq_along(CTCH4_6)) {
  name_string <- CTCH4_6[[i]]@data@names[[1]]
  
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  
  if (as.Date(date_string) == target_date) {
    cropped <- crop(CTCH4_6[[i]], east_extent)
    
    all_vals_ch4 <- c(all_vals_ch4, values(cropped))
  }
}
all_vals_ch4 <- c(all_vals_ch4, ch4_df$CH4)
shared_z_range_ch4 <- range(all_vals_ch4, na.rm = TRUE)
###### Plots CT #####
#CT-NRT CO2 Plot
target_date <- as.Date("2022-04-10")
CT_NRT.list <-list()
for (i in seq_along(CTCO2_NRT_6)) {
  name_string <- CTCO2_NRT_6[[i]]@data@names[[1]]
  
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  
  file_date <- as.Date(date_string)
  
  if (file_date == target_date) {
    # choose 11–14 EDT layer
    cropped_raster <- crop(CTCO2_NRT_6[[i]], east_extent)
    raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
    colnames(raster_df) <- c("x", "y", "CO2_ppm")
    raster_df$Source = "CT_NRT"
    raster_df$time = file_date
    CT_NRT.list[[i]] <- raster_df
    
  
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
      geom_point(
        data = twrs,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 3,
        stroke = 1
      ) +
      
      geom_text(
        data = twrs,
        aes(x = Lon, y = Lat, label = SiteCode),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
      scale_fill_gradientn(
        colors = fields::tim.colors(),
        limits = shared_z_range_co2,
        name = "ppm CO2"
      ) +
      
      coord_sf(
        xlim = c(-80, -70),
        ylim = c(38, 42),
        expand = FALSE
      ) +
      
      labs(title = "CT-NRT CO2: 2022-04-10, (11–14 EDT average)", x = "Longitude", y = "Latitude") +
      
      theme_minimal()
    
    print(p)
  }
}
#CT CO2 Plot
target_date <- as.Date("2022-04-10")
CT_CO2.list <- list()
for (i in seq_along(CTCO2_6)) {
  name_string <- CTCO2_6[[i]]@data@names[[1]]
  
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  
  file_date <- as.Date(date_string)
  
  if (file_date == target_date) {
    # choose 11–14 EDT layer
    cropped_raster <- crop(CTCO2_6[[i]], east_extent)
    raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
    colnames(raster_df) <- c("x", "y", "CO2_ppm")
    raster_df$Source = "CT"
    raster_df$time = file_date
    CT_CO2.list[[i]] <- raster_df
    
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
      geom_point(
        data = twrs,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 3,
        stroke = 1
      ) +
      
      geom_text(
        data = twrs,
        aes(x = Lon, y = Lat, label = SiteCode),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
      scale_fill_gradientn(
        colors = fields::tim.colors(),
        limits = shared_z_range_co2,
        name = "ppm CO2"
      ) +
      
      coord_sf(
        xlim = c(-80, -70),
        ylim = c(38, 42),
        expand = FALSE
      ) +
      
      labs(title = "CT CO2: 2022-04-10, (11–14 EDT average)", x = "Longitude", y = "Latitude") +
      
      theme_minimal()
    
    print(p)
  }
}
#CT CH4
target_date <- as.Date("2022-04-10")

for (i in seq_along(CTCH4_6)) {
  name_string <- CTCH4_6[[i]]@data@names[[1]]
  
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  
  file_date <- as.Date(date_string)
  
  if (file_date == target_date) {
    # choose 11–14 EDT layer
    cropped_raster <- crop(CTCH4_6[[i]], east_extent)
    raster_df <- as.data.frame(cropped_raster, xy = TRUE, na.rm = TRUE)
    colnames(raster_df) <- c("x", "y", "CH4_ppb")
    raster_df$Source = "CT"
    raster_df$time = file_date
    CT_CH4.df <- raster_df
    
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
      geom_point(
        data = twrs,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 4,
        stroke = 1
      ) +
      
      geom_text(
        data = twrs,
        aes(x = Lon, y = Lat, label = SiteCode),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
      scale_fill_gradientn(
        colors = fields::tim.colors(),
        limits = shared_z_range_ch4,
        name = "ppb CH4"
      ) +
      
      coord_sf(
        xlim = c(-80, -70),
        ylim = c(38, 42),
        expand = FALSE
      ) +
      
      labs(title = "CT CH4: 2022-04-10, (11–14 EDT average)", x = "Longitude", y = "Latitude") +
      
      theme_minimal()
    
    print(p)
  }
}

###### Plots CAMS #####
# Plot CO2
p_co2 <- ggplot() +
  
  geom_tile(data = co2_df, aes(x = x, y = y, fill = CO2)) +
  
  geom_text(
    data = co2_df,
    aes(
      x = x,
      y = y,
      label = round(CO2, 3)
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
                       limits = shared_z_range_co2,
                       name = "CO2 ppm") +
  
  coord_sf(xlim = c(-80, -70),
           ylim = c(38, 42),
           expand = FALSE) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +
  labs(
    title = paste("CAMS CO2 Concentration on", closest_times$closest_time_str[2]),
    x = "Longitude",
    y = "Latitude"
  ) +
  
  theme_minimal()

print(p_co2)

# Plot CH4
z_range_ch4 <- range(ch4_df$CH4, na.rm = TRUE)
p_ch4 <- ggplot() +
  
  geom_tile(data = ch4_df, aes(x = x, y = y, fill = CH4)) +
  
  geom_text(
    data = ch4_df,
    aes(
      x = x,
      y = y,
      label = round(CH4, 3)
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
                       limits = shared_z_range_ch4,
                       name = "CH4 ppb") +
  
  coord_sf(xlim = c(-80, -70),
           ylim = c(38, 42),
           expand = FALSE) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +
  labs(
    title = paste("CAMS CH4 Concentration on", closest_times$closest_time_str[1]),
    x = "Longitude",
    y = "Latitude"
  ) +
  
  theme_minimal()

print(p_co2)
print(p_ch4)




###### Combining dfs and plotting differences #####
#CO2 
CAMS_CO2.df <- CAMS_CO2.df %>% 
  rename(CO2_ppm = CO2)

CO2.1x1.df <- bind_rows(
  CAMS_CO2.df,
  CT_NRT.list[[2]],
  CT_CO2.list[[2]]
)

wide_df <- CO2.1x1.df %>%
  select(x, y, Source, CO2_ppm) %>%
  pivot_wider(
    names_from = Source,
    values_from = CO2_ppm
  )
wide_df$diff_CAMS_CT_NRT <- wide_df$CAMS - wide_df$CT_NRT
wide_df$diff_CAMS_CT <- wide_df$CAMS - wide_df$CT
wide_df$diff_CT_CT_NRT <- wide_df$CT_NRT - wide_df$CT

dif.1 <- ggplot(wide_df) +
  geom_tile(aes(x = x, y = y, fill = diff_CAMS_CT_NRT)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CAMS - CT-NRT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.13,
    size = 3,
    fontface = "bold"
  ) +
  theme_minimal()


dif.2 <- ggplot(wide_df) +
  geom_tile(aes(x = x, y = y, fill = diff_CAMS_CT)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CAMS - CT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.13,
    size = 3,
    fontface = "bold"
  ) +
  theme_minimal()

dif.3 <- ggplot(wide_df) +
  geom_tile(aes(x = x, y = y, fill = diff_CT_CT_NRT)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CT-NRT - CT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.13,
    size = 3,
    fontface = "bold"
  ) +
  theme_minimal()


CO2.3x2.df <- bind_rows(
  CT_NRT.list[[1]],
  CT_CO2.list[[1]]
)

wide_df_3x2 <- CO2.3x2.df %>%
  select(x, y, Source, CO2_ppm) %>%
  pivot_wider(
    names_from = Source,
    values_from = CO2_ppm
  )
wide_df_3x2$diff_CT_CT_NRT <- wide_df_3x2$CT_NRT - wide_df_3x2$CT
dif.4 <- ggplot(wide_df_3x2) +
  geom_tile(aes(x = x, y = y, fill = diff_CT_CT_NRT)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CT-NRT - CT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.13,
    size = 3,
    fontface = "bold"
  ) +
  theme_minimal()

grid <- plot_grid(dif.1,dif.2,dif.3,dif.4, ncol = 2)
title <- ggdraw() + 
  draw_label(
    "Differences in Modelled CO2",
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    plot.margin = margin(0, 0, 0, 7)
  )
plot_grid(
  title, grid,
  ncol = 1,
  rel_heights = c(0.1, 1)
)

#CH4
View(CT_CH4.df) #3 x 2
View(CAMS_CH4.df) #1 x 1

CAMS_CH4.df <- CAMS_CH4.df %>% 
  rename(CH4_ppb = CH4)

n <- get.knnx(
  data = CAMS_CH4.df[, c("x","y")],
  query = CT_CH4.df[, c("x","y")],
  k = 1
)

CT_CH4.df$cams_match <- CAMS_CH4.df$CH4_ppb[n$nn.index]
CT_CH4.df$diff <-   CT_CH4.df$cams_match - CT_CH4.df$CH4_ppb

ch4.plot <-ggplot(CT_CH4.df) +
  geom_tile(aes(x = x, y = y, fill = diff)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CAMS - CT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +
  theme_minimal()

title <- ggdraw() + 
  draw_label(
    "Differences in Modelled CH4",
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    plot.margin = margin(0, 0, 0, 7)
  )
plot_grid(
  title, ch4.plot,
  ncol = 1,
  rel_heights = c(0.1, 1)
)

##### Models- full cruise ####
###### Libraries #####
library(raster)
library(sp)
library(ggplot2)
library(sf)
library(dplyr)
library(fields)
library(paletteer)
library(tidyr)
library(cowplot)
library(FNN)
library(terra)
###### Tower Sites ####
twrs <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twrs <- subset(twrs, SiteCode %in% c("LEW", "TMD", "WNJ"))
nw.gridcell <- c(41.5, -77.5)
w.gridcell <- c(39.6, -78.5)
alt.gridcells <- data.frame(
  Lat = c(nw.gridcell[1], w.gridcell[1]),
  Lon = c(nw.gridcell[2], w.gridcell[2]),
  relative_to = c("LEW", "TMD"),
  name = c("NW.GC", "W.GC")
)
###### Cruise time ####
c4_5min <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_5min_daylight.csv")
c4_5min$date <- as.POSIXct(c4_5min$date, tz = "UTC")
###### Carbon Tracker####
#CT-NRT CO2 
CT_CO2_NRT <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/cruise_24_nrt_co2',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #33 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
  )
  CT_CO2_NRT[[i]] <- nc
}

#CT CH4 
CT_CH4 <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/cruise_24_ch4_ct',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #34.5 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
  )
  CT_CH4[[i]] <- nc
}
#Setting time intervals to figure out which times to grab
library(ncdf4)
library(raster)
library(lubridate)

files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/cruise_24_nrt_co2',
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

interval_labels$Times_NY <- paste0(format(start_ny, "%H:%M"), "–", format(end_ny, "%H:%M %Z"))

print(interval_labels)


###### Load in state files for domain #####
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
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states) %>%
  st_transform(crs = st_crs(CT_CO2_NRT[[1]]))
east_extent <- extent(-85, -65, 25, 47)


###### CT ######
#subsetting time intervals chosen above
CTCO2_NRT_6 <- list()
for (i in seq_along(CT_CO2_NRT)) {
  CTCO2_NRT_6[[i]] <- CT_CO2_NRT[[i]][[6]]
}
CTCO2_NRT_7 <- list()
for (i in seq_along(CT_CO2_NRT)) {
  CTCO2_NRT_7[[i]] <- CT_CO2_NRT[[i]][[7]]
}
CTCO2_NRT_5 <- list()
for (i in seq_along(CT_CO2_NRT)) {
  CTCO2_NRT_5[[i]] <- CT_CO2_NRT[[i]][[5]]
}

all_ct_nrt_co2_rasters <- c(
  CTCO2_NRT_5,
  CTCO2_NRT_6,
  CTCO2_NRT_7
)

r <- stack(all_ct_nrt_co2_rasters)

CTNRT_CO2_mean <- calc(r, mean, na.rm = TRUE)
CTNRT_CO2_mean <- crop(CTNRT_CO2_mean, east_extent)
co2_df_ct <- as.data.frame(CTNRT_CO2_mean, xy = TRUE)
names(co2_df_ct)[3] <- "CO2"
co2_df_ct$Source = "CT-NRT"

CTCH4_6 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_6[[i]] <- CT_CH4[[i]][[6]]
}
CTCH4_7 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_7[[i]] <- CT_CH4[[i]][[7]]
}
CTCH4_5 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_5[[i]] <- CT_CH4[[i]][[5]]
}

all_ct_ch4_rasters <- c(
  CTCH4_5,
  CTCH4_6,
  CTCH4_7
)

r <- stack(all_ct_ch4_rasters)

CT_CH4_mean <- calc(r, mean, na.rm = TRUE)
CT_CH4_mean <- crop(CT_CH4_mean, east_extent)
ch4_df_ct <- as.data.frame(CT_CH4_mean, xy = TRUE)
names(ch4_df_ct)[3] <- "CH4"
ch4_df_ct$Source = "CT"

###### CAMS #####
#Load in CAMS files
CAMS <- list(CH4 = list(), CO2 = list())

files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/cruise_24_cams',
  pattern = '\\.nc$',
  full.names = TRUE
)

level_co2 <- 1  
level_ch4 <- 1 #378.3 m for CAMS CH4 (lowest)

for (f in files) {
  
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
  
  r_stack <- brick(f, varname = var_to_use, level = lvl)
  
  CAMS[[var_to_use]][[basename(f)]] <- r_stack
}

#Timestamps
get_timestamps <- function(nc_file) {
  nc <- nc_open(nc_file)
  on.exit(nc_close(nc), add = TRUE)
  
  if (!("time" %in% names(nc$dim))) {
    warning(paste("No 'time' dimension in:", nc_file))
    return(NULL)
  }
  
  time_vals <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  
  origin <- sub("hours since ", "", time_units)
  
  timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  
  return(timestamps)
}
all_timestamps <- lapply(files, get_timestamps)
names(all_timestamps) <- basename(files)

target_date_alt <- c4_5min$date
closest_times <- data.frame()

for (i in seq_along(files)) {
  
  timestamps <- all_timestamps[[i]]
  
  for (j in seq_along(target_date_alt)) {
    
    layer_number <- which.min(
      abs(difftime(timestamps, target_date_alt[j], units = "secs"))
    )
    
    plot_date <- timestamps[layer_number]
    
    closest_times <- rbind(
      closest_times,
      data.frame(
        file = basename(files[i]),
        obs_time = target_date_alt[j],
        closest_time = plot_date,
        layer_num = layer_number
      )
    )
  }
}

cams.list.closest.times <- split(closest_times, closest_times$file)

ch4.oct_layers <- cams.list.closest.times$cams73_latest_ch4_conc_surface_inst_202310.nc$layer_num

ch4.nov_layers <- cams.list.closest.times$cams73_latest_ch4_conc_surface_inst_202311.nc$layer_num

ch4.oct_mean <- mean(
  CAMS$CH4[["cams73_latest_ch4_conc_surface_inst_202310.nc"]][[ch4.oct_layers]]
)

ch4.nov_mean <- mean(
  CAMS$CH4[["cams73_latest_ch4_conc_surface_inst_202311.nc"]][[ch4.nov_layers]]
)

 ch4.cams.avg <- mean(stack(ch4.oct_mean, ch4.nov_mean))

# all_layers <- stack(CAMS$CH4)
# 
# ch4.cams.avg <- calc(all_layers, mean, na.rm = TRUE)

CH4_cropped <- crop(ch4.cams.avg, east_extent)

co2.oct_layers <- cams.list.closest.times$cams73_latest_co2_conc_surface_inst_202310.nc$layer_num

co2.nov_layers <- cams.list.closest.times$cams73_latest_co2_conc_surface_inst_202311.nc$layer_num

co2.oct_mean <- mean(
  CAMS$CO2[["cams73_latest_co2_conc_surface_inst_202310.nc"]][[co2.oct_layers]]
)

co2.nov_mean <- mean(
  CAMS$CO2[["cams73_latest_co2_conc_surface_inst_202311.nc"]][[co2.nov_layers]]
)

co2.cams.avg <- mean(stack(co2.oct_mean, co2.nov_mean))

# all_layers <- stack(CAMS$CO2)
# 
# co2.cams.avg <- calc(all_layers, mean, na.rm = TRUE)

CO2_cropped <- crop(co2.cams.avg, east_extent)

CO2_cropped <- CO2_cropped * 1e6

# Convert to dataframes for plotting
ch4_df_cams <- as.data.frame(CH4_cropped, xy = TRUE)
co2_df_cams <- as.data.frame(CO2_cropped, xy = TRUE)

names(ch4_df_cams)[3] <- "CH4"
names(co2_df_cams)[3] <- "CO2"

ch4_df_cams$Source = "CAMS"

co2_df_cams$Source = "CAMS"

###### Color Scales #####
#Setting color scale for CO2 Plots
all_vals_co2 <- c(co2_df_ct$CO2, co2_df_cams$CO2)
#shared_z_range_co2 <- c(417,435)
shared_z_range_co2 <- range(all_vals_co2, na.rm = TRUE)
#Setting color scale for CH4 Plots
all_vals_ch4 <- c(ch4_df_ct$CH4, ch4_df_cams$CH4)
shared_z_range_ch4 <- range(all_vals_ch4, na.rm = TRUE)
#shared_z_range_ch4 <- c(1986,2094)
###### Plots CT #####
#CT-NRT CO2 Plot

    p <- ggplot() +
      
      geom_tile(data = co2_df_ct, aes(x = x, y = y, fill = CO2)) +
      
      geom_text(
        data = co2_df_ct,
        aes(
          x = x,
          y = y,
          label = round(CO2, 3)
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
      geom_point(
        data = twrs,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 3,
        stroke = 1
      ) +
      
      geom_text(
        data = twrs,
        aes(x = Lon, y = Lat, label = SiteCode),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
  
  geom_point(
    data = alt.gridcells,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) + 
  geom_text(
    data = alt.gridcells,
    aes(x = Lon, y = Lat, label = name),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +
      scale_fill_gradientn(
        colors = fields::tim.colors(),
        limits = shared_z_range_co2,
        name = "ppm CO2"
      ) +
      
      coord_sf(
        xlim = c(-80, -70),
        ylim = c(38, 42),
        expand = FALSE
      ) +
      
      labs(title = "CT-NRT CO2 Cruise 24 Average", x = "Longitude", y = "Latitude") +
      
      theme_minimal()
    
    print(p)


#CT CH4
    p <- ggplot() +
      
      geom_tile(data = ch4_df_ct, aes(x = x, y = y, fill = CH4)) +
      
      geom_text(
        data = ch4_df_ct,
        aes(
          x = x,
          y = y,
          label = round(CH4, 3)
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
      geom_point(
        data = twrs,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 4,
        stroke = 1
      ) +
      
      geom_text(
        data = twrs,
        aes(x = Lon, y = Lat, label = SiteCode),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
      
      geom_point(
        data = alt.gridcells,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 3,
        stroke = 1
      ) + 
      geom_text(
        data = alt.gridcells,
        aes(x = Lon, y = Lat, label = name),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
      scale_fill_gradientn(
        colors = fields::tim.colors(),
        limits = shared_z_range_ch4,
        name = "ppb CH4"
      ) +
      
      coord_sf(
        xlim = c(-80, -70),
        ylim = c(38, 42),
        expand = FALSE
      ) +
      
      labs(title = "CT CH4: Cruise 24 Average", x = "Longitude", y = "Latitude") +
      
      theme_minimal()
    
    print(p)

###### Plots CAMS #####
# Plot CO2
p_co2 <- ggplot() +
  
  geom_tile(data = co2_df_cams, aes(x = x, y = y, fill = CO2)) +
  
  geom_text(
    data = co2_df_cams,
    aes(
      x = x,
      y = y,
      label = round(CO2, 3)
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
                       limits = shared_z_range_co2,
                       name = "CO2 ppm") +
  
  coord_sf(xlim = c(-80, -70),
           ylim = c(38, 42),
           expand = FALSE) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +
      
      geom_point(
        data = alt.gridcells,
        aes(x = Lon, y = Lat),
        color = "black",
        fill = "white",
        shape = 21,
        size = 3,
        stroke = 1
      ) + 
      geom_text(
        data = alt.gridcells,
        aes(x = Lon, y = Lat, label = name),
        nudge_y = 0.08,
        size = 4,
        fontface = "bold"
      ) +
  labs(
    title = "CAMS CO2 Cruise 24 Average",
    x = "Longitude",
    y = "Latitude"
  ) +
  
  theme_minimal()

print(p_co2)

# Plot CH4
p_ch4 <- ggplot() +
  
  geom_tile(data = ch4_df_cams, aes(x = x, y = y, fill = CH4)) +
  
  geom_text(
    data = ch4_df_cams,
    aes(
      x = x,
      y = y,
      label = round(CH4, 3)
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
                       limits = shared_z_range_ch4,
                       name = "CH4 ppb") +
  
  coord_sf(xlim = c(-80, -70),
           ylim = c(38, 42),
           expand = FALSE) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) +
  
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +

  geom_point(
    data = alt.gridcells,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) + 
  geom_text(
    data = alt.gridcells,
    aes(x = Lon, y = Lat, label = name),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) +
  labs(
    title = "CAMS CH4 Cruise 24 Average",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal()

print(p_co2)
print(p_ch4)




###### Combining dfs and plotting differences #####
#CO2 
CO2.1x1.df <- bind_rows(co2_df_cams, co2_df_ct
)

wide_df <- CO2.1x1.df %>%
  dplyr::select(x, y, Source, CO2) %>%
  pivot_wider(
    names_from = Source,
    values_from = CO2
  )

wide_df$diff_CAMS_CT_NRT <- wide_df$CAMS - wide_df$`CT-NRT`

dif.1 <- ggplot(wide_df) +
  geom_tile(aes(x = x, y = y, fill = diff_CAMS_CT_NRT)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CAMS - CT-NRT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 4,
    stroke = 1
  ) +
  geom_text(
    data = wide_df,
    aes(
      x = x,
      y = y,
      label = round(diff_CAMS_CT_NRT, 3)
    ),
    size = 2.5,
    color = "black"
  ) +
  geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.13,
    size = 4,
    fontface = "bold"
  ) +
  theme_minimal() +
   geom_point(
    data = alt.gridcells,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) + 
  geom_text(
    data = alt.gridcells,
    aes(x = Lon, y = Lat, label = name),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) 

print(dif.1)

#CH4

n <- get.knnx(
  data = ch4_df_cams[, c("x","y")],
  query = ch4_df_ct[, c("x","y")],
  k = 1
)

ch4_df_ct$cams_match <- ch4_df_cams$CH4[n$nn.index]
ch4_df_ct$diff <-   ch4_df_ct$cams_match - ch4_df_ct$CH4
ch4_df_ct <- subset(
  ch4_df_ct,
  x >= -81 & x <= -69 &
    y >= 37  & y <= 43
)

ch4.plot <-ggplot(ch4_df_ct) +
  geom_tile(aes(x = x, y = y, fill = diff)) +
  geom_sf(data = east_states_sf, fill = NA) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    name = "CAMS - CT"
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  geom_point(
    data = twrs,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 4,
    stroke = 1
  ) +
   geom_text(
    data = twrs,
    aes(x = Lon, y = Lat, label = SiteCode),
    nudge_y = 0.13,
    size = 4,
    fontface = "bold"
  ) +
  theme_minimal() + 
  geom_text(
    data = ch4_df_ct,
    aes(
      x = x,
      y = y,
      label = round(diff, 3)
    ),
    size = 2.5,
    color = "black"
  )  +
  geom_point(
    data = alt.gridcells,
    aes(x = Lon, y = Lat),
    color = "black",
    fill = "white",
    shape = 21,
    size = 3,
    stroke = 1
  ) + 
  geom_text(
    data = alt.gridcells,
    aes(x = Lon, y = Lat, label = name),
    nudge_y = 0.08,
    size = 4,
    fontface = "bold"
  ) 

print(ch4.plot)

plot_row <- plot_grid(dif.1, ch4.plot, ncol = 2)
title <- ggdraw() + 
  draw_label(
    "Average Model Differences for Cruise #24 (CAMS - CT)",
    fontface = 'bold', size = 18) 

final_plot <- plot_grid(
  title, plot_row,
  ncol = 1,
  rel_heights = c(0.1, 1) 
)
print(final_plot)

