library(ncdf4)
library(terra)
library(ggplot2)
library(sf)
library(dplyr)

nc_file <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/202204121600_-74.424_39.378_11.1_foot.nc"
footprint <- nc_open(nc_file)

fp_lon  <- ncvar_get(footprint, "lon")
fp_lat  <- ncvar_get(footprint, "lat")
fp_time <- ncvar_get(footprint, "time")
fp_time <- as.POSIXct(fp_time, tz =  "UTC")
fp_data <- ncvar_get(footprint, "foot")
nc_close(footprint)

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

n_times <- (if (length(dim(fp_data)) == 3)
  dim(fp_data)[3]
  else
    1)

out_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/footprints_png4"
dir.create(out_dir, showWarnings = FALSE)

min_val <- min(fp_data[fp_data > 0], na.rm = TRUE)
max_val <- max(fp_data, na.rm = TRUE)

date_label <- as.Date(fp_time[length(fp_time)])
if (is.na(date_label)) date_label <- fp_time[length(fp_time)]

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
      size = 3,
      fill = "black"
    ) +
    geom_text(
      data = twr,
      aes(x = Lon, y = Lat, label = SiteCode),
      inherit.aes = FALSE,
      hjust = -0.3,
      vjust = 0.3,
      size = 3
    ) +
    coord_sf(xlim = c(-80, -70),
             ylim = c(38, 42),
             expand = FALSE) +
    scale_fill_viridis_c(
      option = "plasma",
      name = "ppm (umol-1 m2 s)",
      limits = c(min_val, max_val)
     # trans = "sqrt"
    ) +
    labs(
      title = paste("Stilt Surface Influence Footprint for", date_label),
      x = "Longitude",
      y = "Latitude"
      #subtitle = "SQRT transformation"
    ) +
    theme_minimal()
  
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

png_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/footprints_png4"

png_files <- list.files(png_dir, pattern = "^footprint_\\d+\\.png$", full.names = TRUE)
png_files <- sort(png_files, decreasing = T)

imgs <- image_read(png_files)

gif <- image_animate(imgs, fps = 2)
gif_file <- file.path(png_dir, "footprints_animation.gif")
image_write(gif, gif_file)

message("GIF saved at: ", gif_file)
