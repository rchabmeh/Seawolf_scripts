library(ncdf4)
library(terra)
library(ggplot2)
library(sf)
library(dplyr)

nc_file <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/202204101400_-74.594_39.226_11.1_foot.nc"
footprint <- nc_open(nc_file)

fp_lon  <- ncvar_get(footprint, "lon")
fp_lat  <- ncvar_get(footprint, "lat")
fp_time <- ncvar_get(footprint, "time")
fp_data <- ncvar_get(footprint, "foot")  
nc_close(footprint)

states <- suppressMessages(
  st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")
)

east_coast_states <- c(
  "Maine","New Hampshire","Massachusetts","Rhode Island","Connecticut",
  "New York","New Jersey","Delaware","Maryland","Virginia",
  "North Carolina","South Carolina","Georgia","Florida","Pennsylvania","Vermont"
)

east_states_sf <- states %>%
  filter(NAME %in% east_coast_states) %>%
  st_transform(crs = 4326)

twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]

n_times <- if (length(dim(fp_data)) == 3) dim(fp_data)[3] else 1

out_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/footprints_png"
dir.create(out_dir, showWarnings = FALSE)

for (i in seq_len(n_times)) {
  fp_df <- expand.grid(lon = fp_lon, lat = fp_lat)
  fp_df$value <- as.vector(if (n_times > 1) fp_data[,,i] else fp_data)
  
  p <- ggplot() +
    geom_raster(data = fp_df, aes(x = lon, y = lat, fill = value)) +
    geom_sf(data = east_states_sf, inherit.aes = FALSE, fill = NA, color = "grey", linewidth = 0.4) +
    geom_point(data = twr, aes(x = Lon, y = Lat), shape = 23, size = 3, fill = "black") +
    geom_text(data = twr, aes(x = Lon, y = Lat, label = SiteCode),
              inherit.aes = FALSE, hjust = -0.3, vjust = 0.3, size = 3) +
    coord_sf(xlim = c(-80, -70), ylim = c(38, 42), expand = FALSE) +
    scale_fill_viridis_c(option = "plasma", name = "Footprint") +
    labs(
      title = paste("Footprint time step", i),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
  

  png_filename <- file.path(out_dir, sprintf("footprint_%02d.png", i))
  ggsave(filename = png_filename, plot = p, width = 6, height = 5, dpi = 300)
  
  message("Saved: ", png_filename)
}

library(magick)

# Folder with saved PNGs
png_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/footprints_png"

# Get all PNG files in order
png_files <- list.files(png_dir, pattern = "^footprint_\\d+\\.png$", full.names = TRUE)
png_files <- sort(png_files)  # ensure correct time order

# Read all images
imgs <- image_read(png_files)

# Animate images (10 frames per second)
gif <- image_animate(imgs, fps = 2)  # adjust fps as desired

# Save GIF
gif_file <- file.path(png_dir, "footprints_animation.gif")
image_write(gif, gif_file)

message("GIF saved at: ", gif_file)


  ##### rds particle file #####
traj <- readRDS("~/Desktop/Seawulf_files/202204101400_-74.594_39.226_11.1_traj.rds")
receptors <- traj$receptor
particles <- traj$particle

library(ggplot2)
library(sf)
library(raster)
library(dplyr)
library(fields)
library(paletteer)
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
  st_transform(crs = 4326)
east_extent <- extent(-85, -65, 25, 47)

twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]


cruise <- read.delim("/Volumes/Seagate/cruise4_eulerian/all_data_cruise4.txt",
                     sep = ",")
cruise <- na.omit(cruise)



ggplot() +
  geom_point(data = particles, aes(x = long, y = lati, colour = dens)) +
  geom_sf(
    data = east_states_sf,
    inherit.aes = F,
    fill = NA,
    color = "grey",
    linewidth = 0.4
  ) +
  coord_sf(xlim = c(-80, -70),
           ylim = c(38, 42),
           expand = FALSE) +
  labs(
    title = paste(
      "Particles from",
      receptors$run_time,
      "(using .rds file) colored by ρ"
    ),
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  geom_point(
    data = twr,
    aes(x = Lon, y = Lat),
    shape = 23,
    size = 3,
    fill = "black",
    color = "black"
  ) +
  geom_text(
    data = twr,
    aes(x = Lon, y = Lat, label = SiteCode),
    inherit.aes = F,
    hjust = -0.3,
    vjust = 0.3,
    size = 3
  ) +
  geom_path(
    data = cruise,
    aes(x = longitude_deg_subrange, y = latitude_deg_subrange, linetype = "Cruise Path"),
    color = "black",
    lwd = 1.5
  ) +
  scale_color_viridis_c(option = "plasma", name = "Particle Density") +
  scale_linetype_manual(name = "", values = c("Cruise Path" = 1))
