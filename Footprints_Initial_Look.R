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
  geom_point(
    data = particles,
    aes(x = long, y = lati, colour = dens)
  ) +
  geom_sf(
    data = east_states_sf,
    inherit.aes = F,
    fill = NA,
    color = "grey",
    linewidth = 0.4
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42), expand = FALSE) +
  labs(
    title = paste("Particles from", receptors$run_time, "(using .rds file) colored by ρ"),
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
  scale_linetype_manual(
    name = "", 
    values = c("Cruise Path" = 1)
  )
