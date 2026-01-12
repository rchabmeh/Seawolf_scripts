##### figuring out how to parallelize ####
final_filtered_trajectories <- readRDS("/Users/reneechabot-mehlin/Desktop/4final_traj.RData")
traj_times <- vector("list", length(final_filtered_trajectories))
traj_lat <- vector("list", length(final_filtered_trajectories))
traj_lon <- vector("list", length(final_filtered_trajectories))
traj_ht <- vector("list", length(final_filtered_trajectories))
for (i in seq_along(final_filtered_trajectories)) {
  traj_lat[[i]] <- (final_filtered_trajectories[[i]]$Latitude[[1]])
  traj_lon[[i]] <- (final_filtered_trajectories[[i]]$Longitude[[1]])
  traj_times[[i]] <- as.POSIXct(final_filtered_trajectories[[i]][[14]][[1]], tz = "America/New_York")
  traj_ht[[i]] <- (final_filtered_trajectories[[i]]$`Height (m)`[[1]])
}

receptors <- data.frame(
  time = unlist(traj_times),
  lat = unlist(traj_lat),
  lon = unlist(traj_lon),
  ht = unlist(traj_ht)
)
library(lubridate)
receptors$time <- as.POSIXct(receptors$time, tz = "America/New_York")
receptors$time <- with_tz(receptors$time, tzone = "UTC")
saveRDS(receptors,
        "/Users/reneechabot-mehlin/Desktop/receptors.RData")

##### plotting footprints gifs#####
library(ncdf4)
library(terra)
library(ggplot2)
library(sf)
library(dplyr)

nc_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/nc_files"
nc_files <- list.files(nc_dir, pattern = "\\.nc$", full.names = TRUE)

for (nc_file in nc_files) {
  footprint <- nc_open(nc_file)
  
  fp_lon  <- ncvar_get(footprint, "lon")
  fp_lat  <- ncvar_get(footprint, "lat")
  fp_time <- ncvar_get(footprint, "time")
  fp_time <- as.POSIXct(fp_time, tz =  "UTC")
  fp_data <- ncvar_get(footprint, "foot")
  nc_close(footprint)
  
  all_min <- Inf
  all_max <- -Inf
  
  for (nc_file in nc_files) {
    footprint <- nc_open(nc_file)
    fp_data <- ncvar_get(footprint, "foot")
    nc_close(footprint)
    
    if (length(dim(fp_data)) == 3) {
      summed_fp <- apply(fp_data, c(1, 2), sum, na.rm = TRUE)
    } else {
      summed_fp <- fp_data
    }
    
    local_min <- min(summed_fp[summed_fp > 0], na.rm = TRUE)
    local_max <- max(summed_fp, na.rm = TRUE)
    
    if (is.finite(local_min) && local_min < all_min) all_min <- local_min
    if (is.finite(local_max) && local_max > all_max) all_max <- local_max
  }
  
  message("Global color scale limits: ", signif(all_min, 3), " to ", signif(all_max, 3))
  
  
  states <- suppressMessages(st_read(
    "/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k"
  ))
  
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
    st_transform(crs = 4326)
  
  twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
  twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]
  
  cities <- tibble(
    lat = c(39.9526, 40.7128, 38.9072, 39.2905),
    lon = c(-75.1652, -74.0060, -77.0369, -76.6104),
    city = c("Philadelphia", "New York City", "DC", "Baltimore")
  )
  
  
  n_times <- (if (length(dim(fp_data)) == 3)
    dim(fp_data)[3]
    else
      1)
  
  out_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/footprints_gifs"
  dir.create(out_dir, showWarnings = FALSE)
  
  min_val <- min(fp_data[fp_data > 0], na.rm = TRUE)
  max_val <- max(fp_data, na.rm = TRUE)
  
  date_label <- fp_time[length(fp_time)]
  if (is.na(date_label))
    date_label <- fp_time[length(fp_time)]
  
  for (i in seq_len(n_times)) {
    fp_df <- expand.grid(lon = fp_lon, lat = fp_lat)
    fp_df$value <- as.vector(if (n_times > 1)
      fp_data[, , i]
      else
        fp_data)
    
    p <- ggplot() +
      geom_raster(data = fp_df, aes(x = lon, y = lat, fill = value)) +
      geom_sf(
        data = east_states_sf,
        inherit.aes = FALSE,
        fill = NA,
        color = "grey",
        linewidth = 0.4
      ) +
      geom_point(
        data = twr,
        aes(x = Lon, y = Lat),
        shape = 23,
        size = 1,
        fill = "grey4"
      ) +
      geom_text(
        data = twr,
        aes(x = Lon, y = Lat, label = SiteCode),
        inherit.aes = FALSE,
        hjust = -0.5,
        vjust = 0.3,
        size = 4
      ) +
      geom_point(
        data = cities,
        aes(x = lon, y = lat),
        shape = 21,
        size = 1,
        fill = "red"
      ) +
      geom_text(
        data = cities,
        aes(x = lon, y = lat, label = city),
        inherit.aes =  F,
        hjust = -0.5,
        vjust = 0.3,
        size = 4
      ) +
      coord_sf(
        xlim = c(-80, -70),
        ylim = c(38, 42),
        expand = FALSE
      ) +
      scale_fill_viridis_c(
        option = "plasma",
        name = "log 10 (ppm µmol-1 m2 s)",
        limits = c(all_min, all_max),
        trans = "log"
      ) +
      labs(
        title = paste("STILT Surface Influence Footprint"),
        subtitle = paste("Date:", date_label),
        x = "Longitude",
        y = "Latitude"
      ) +
      theme_minimal(base_size = 12)
    
    png_filename <- file.path(out_dir, sprintf("footprint_%02d.png", i))
    ggsave(
      filename = png_filename,
      plot = p,
      width = 6,
      height = 5,
      dpi = 300
    )
    
    message("Saved: ", png_filename)
  }
  
  library(magick)
  
  png_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/footprints_gifs"
  
  png_files <- list.files(png_dir, pattern = "^footprint_\\d+\\.png$", full.names = TRUE)
  png_files <- sort(png_files, decreasing = T)
  
  imgs <- image_read(png_files)
  
  gif <- image_animate(imgs, fps = 2)
  label <- format(as.POSIXct(date_label, tz = "UTC"), "%Y%m%d%H")
  
  gif_file <- file.path(png_dir, paste0("footprints_", label, ".gif"))
  image_write(gif, gif_file)
  
  message("GIF saved at: ", gif_file)
  
  png_files <- list.files(png_dir, pattern = "\\.png$", full.names = TRUE)
  file.remove(png_files)
  
}
##### summed footprint plots #####
library(ncdf4)
library(ggplot2)
library(sf)
library(dplyr)

nc_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/nc_files/GFS_files/cruise_24"
nc_files <- list.files(nc_dir, pattern = "\\.nc$", full.names = TRUE)

all_min <- Inf
all_max <- -Inf

for (nc_file in nc_files) {
  footprint <- nc_open(nc_file)
  fp_data <- ncvar_get(footprint, "foot")
  
  fp_time <- ncvar_get(footprint, "time")
  fp_time <- as.POSIXct(fp_time, tz = "UTC")
  
  nc_close(footprint)
  
  
  if (length(dim(fp_data)) == 3) {
    summed_fp <- apply(fp_data, c(1, 2), sum, na.rm = TRUE)
  } else {
    summed_fp <- fp_data
  }
  
  local_min <- min(summed_fp[summed_fp > 0], na.rm = TRUE)
  local_max <- max(summed_fp, na.rm = TRUE)
  
  if (is.finite(local_min) && local_min < all_min) all_min <- local_min
  if (is.finite(local_max) && local_max > all_max) all_max <- local_max
}

message("Global color scale limits: ", signif(all_min, 3), " to ", signif(all_max, 3))

states <- suppressMessages(st_read(
  "/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k"
))

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
  st_transform(crs = 4326)

twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]

cities <- tibble(
  lat = c(39.9526, 40.7128, 38.9072, 39.2905),
  lon = c(-75.1652, -74.0060, -77.0369, -76.6104),
  city = c("Philadelphia", "New York City", "DC", "Baltimore")
)

for (nc_file in nc_files) {
  footprint <- nc_open(nc_file)
  
  fp_lon  <- ncvar_get(footprint, "lon")
  fp_lat  <- ncvar_get(footprint, "lat")
  fp_time <- ncvar_get(footprint, "time")
  fp_time <- as.POSIXct(fp_time, tz = "UTC")
  fp_data <- ncvar_get(footprint, "foot")
  fp_time_intial <- tail(fp_time, 1)
  nc_close(footprint)
  
  if (length(dim(fp_data)) == 3) {
    summed_fp <- apply(fp_data, c(1, 2), sum, na.rm = TRUE)
  } else {
    summed_fp <- fp_data
  }
  
  fp_df <- expand.grid(lon = fp_lon, lat = fp_lat)
  fp_df$value <- as.vector(summed_fp)
  
  min_val <- min(fp_df$value[fp_df$value > 0], na.rm = TRUE)
  max_val <- max(fp_df$value, na.rm = TRUE)
  
  date_label <- fp_time_intial
  
  p <- ggplot() +
    geom_raster(data = fp_df, aes(x = lon, y = lat, fill = value)) +
    geom_sf(
      data = east_states_sf,
      fill = NA,
      color = "grey",
      linewidth = 0.4
    ) +
    geom_point(
      data = twr,
      aes(x = Lon, y = Lat),
      shape = 23,
      size = 1.5,
      fill = "grey4"
    ) +
    geom_text(
      data = twr,
      aes(x = Lon, y = Lat, label = SiteCode),
      hjust = -0.5,
      vjust = 0.3,
      size = 4
    ) +
    geom_point(
      data = cities,
      aes(x = lon, y = lat),
      shape = 21,
      size = 1.5,
      fill = "red"
    ) +
    geom_text(
      data = cities,
      aes(x = lon, y = lat, label = city),
      hjust = -0.5,
      vjust = 0.3,
      size = 4
    ) +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    scale_fill_viridis_c(
      option = "plasma",
      name = "log 10 (ppm µmol-1 m2 s)",
      limits = c(all_min, all_max),
      trans = "log"
    ) +
    labs(
      title = paste("STILT Surface Influence Footprint"),
      subtitle = paste("Date:", date_label),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal(base_size = 12)
  
  sum_footprint_out <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/summed_footprint_png/GFS_pngs/cruise_24"
  out_file <- file.path(
    sum_footprint_out,
    paste0(
      "summed_footprint_", 
      format(fp_time_intial, "%Y%m%d%H"), "_",
      tools::file_path_sans_ext(basename(nc_file)), ".png"
    )
  ) 
  ggsave(
    out_file,
    plot = p,
    width = 10,
    height = 9,
    dpi = 300
  )
  message("Saved summed footprint: ", out_file)
}



# 
# 
# # What files were written?
# png_out_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/summed_footprint_png"
# png_files <- list.files(png_out_dir, pattern = "\\.png$", full.names = FALSE)
# 
# # Extract timestamps printed in PNG names
# png_keys <- sub("summed_footprint_(.*)\\.png", "\\1", png_files)
# 
# # Extract timestamps from nc files
# nc_times <- sapply(nc_files, function(f) {
#   nc <- nc_open(f)
#   t <- ncvar_get(nc, "time")
#   nc_close(nc)
#   format(as.POSIXct(t[1], tz="UTC"), "%Y%m%d%H")
# })
# 
# # Compare
# missing <- setdiff(nc_times, png_keys)
# missing
 






