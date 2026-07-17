library(ggplot2)
library(sf)
library(ggrepel)
library(sf)
library(sp)
library(terra)
library(tmap)
library(paletteer)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2021_us_state_500k/cb_2021_us_state_500k.shp")
Seawolf <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 4 (4-5-22 to 4-16-22)/Lat:Long.csv')
Seawolf <- na.omit(Seawolf)
#directory <- "/Users/reneechabot-mehlin/hysplit/working/cruise_4_hrrr_tdump_files"
#setwd(directory)

#Setting everything up
cities <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major NE cities lat_long.csv'
)
cities <- cities[cities$City %in% c("Philadelphia", "Baltimore", "Washington D.C.", "New York", "Trenton"), ]

twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "TMD", "WNJ"), ]

nw.gridcell <- c(41.5, -77.5)
w.gridcell <- c(39.6, -78.5)
alt.gridcells <- data.frame(
  Lat = c(nw.gridcell[1], w.gridcell[1]),
  Lon = c(nw.gridcell[2], w.gridcell[2]),
  relative_to = c("LEW", "TMD"),
  name = c("NW.GC", "W.GC")
)

point_pleasant_nj <- c(Lon = -74.066910, Lat = 40.083721)
cape_may_nj      <- c(Lon = -74.9108, Lat = 38.9316)

states <- st_transform(states, crs = 4326)

# Highlight portion of cruise
highlight <- with(
  Seawolf,
  Latitude_deg <= point_pleasant_nj["Lat"] &
    Latitude_deg >= cape_may_nj["Lat"]
)

Seawolf_highlight <- Seawolf[highlight, ]

ggplot() +
  # States
  geom_sf(data = states,
          fill = "white",
          color = "grey50",
          linewidth = 0.4) +
  
  # Full cruise track
  geom_path(data = Seawolf,
            aes(Longitude_deg, Latitude_deg),
            color = "grey40",
            linewidth = 0.8) +
  
  # Highlighted segment
  geom_path(data = Seawolf_highlight,
            aes(Longitude_deg, Latitude_deg),
            color = "orange2",
            linewidth = 1.3) +
  
  # Major cities
  geom_point(data = cities,
             aes(Longitude, Latitude),
             shape = 22,
             fill = "green",
             color = "black",
             size = 3) +
  
  geom_text(
    data = cities,
    aes(Longitude, Latitude, label = City),
    hjust = 1,      # right-align text
    nudge_x = -0.12, # move left
    size = 5
  ) +
  
  # Point Pleasant & Cape May
  geom_point(
    data = data.frame(
      Lon = c(point_pleasant_nj["Lon"], cape_may_nj["Lon"]),
      Lat = c(point_pleasant_nj["Lat"], cape_may_nj["Lat"]),
      Name = c("Point Pleasant, NJ", "Cape May, NJ")
    ),
    aes(Lon, Lat),
    shape = 22,
    fill = "darkgreen",
    color = "black",
    size = 3
  ) +
  
  geom_text(
    data = data.frame(
      Lon = c(point_pleasant_nj["Lon"], cape_may_nj["Lon"]),
      Lat = c(point_pleasant_nj["Lat"], cape_may_nj["Lat"]),
      Name = c("Point Pleasant", "Cape May")
    ),
    aes(Lon, Lat, label = Name),
    hjust = 1,      # right-align text
    nudge_x = -0.12, # move left
    size = 5) +
  
  # Towers
  geom_point(data = twr,
             aes(Lon, Lat),
             shape = 21,
             fill = "red",
             color = "black",
             size = 3) +
  
  geom_text(
    data = twr,
    aes(Lon, Lat, label = SiteCode),
    hjust = 1,
    nudge_x = -0.12,
    size = 5
  ) +
  
  # Alternate grid cells
  geom_point(data = alt.gridcells,
             aes(Lon, Lat),
             shape = 21,
             fill = "blue",
             color = "black",
             size = 3) +
  
  geom_text(
    data = alt.gridcells,
    aes(Lon, Lat, label = name),
    hjust = 1,
    nudge_x = -0.12,
    size = 5
  ) +
  
  coord_sf(
    xlim = c(-80, -70),
    ylim = c(38, 42),
    expand = FALSE
  ) +
  
  labs(title = "Area of Interest",
       x = NULL,
       y = NULL) +
  
  theme_bw(base_size = 16) +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5)
  )