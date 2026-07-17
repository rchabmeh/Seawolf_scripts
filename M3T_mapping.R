library(M3T)
M3T_set_config()
run_dir <- "/Users/reneechabot-mehlin/Desktop/M3T_output"
dir.create(run_dir, showWarnings = FALSE)
options(error = recover)
CH4_inventory_build(
  run_directory = run_dir,
  inventory_year = 2022,
  domain = as.data.frame(cbind(c(-80, -70), c(38, 42))),
  domain_res = 0.1, #was originally 1 degree, run when not using R for other projects
  domain_crs = "epsg:4326",
  verbose = T,
  Zenodo_record = "17328718"
)



#Description: Wastewater() fails when ghgrp_crop contains zero facilities.
#After terra::crop() and terra::mask(), ghgrp_crop is empty, and as.data.frame() returns only the emiss column.
#The subsequent subsetting of facility_id, facility_name.x, and state fails because those columns no longer exist.
#The function should handle the zero-feature case and write an empty output table instead of erroring.
library(terra)
library(ggplot2)
library(tidyterra)

r <- rast(
  "/Users/reneechabot-mehlin/Desktop/M3T_output/out/Combined_files/summary_combinations/Summary_combination_inventories.nc"
)
ch4_total <- sum(r)
names(ch4_total) <- "CH4_total"

log_ch4 <- log10(ch4_total)

states <- vect(
  "/Users/reneechabot-mehlin/Downloads/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
cities <- read.csv(
  '/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Misc. RCM /Major NE cities lat_long.csv'
)
cities <- cities[cities$City %in% c("Philadelphia",
                                    "Baltimore",
                                    "Washington D.C.",
                                    "New York",
                                    "Trenton"), ]

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
limits <- data.frame(
  Lon = c(point_pleasant_nj["Lon"], cape_may_nj["Lon"]),
  Lat = c(point_pleasant_nj["Lat"], cape_may_nj["Lat"]),
  name = c("Point Pleasant", "Cape May")) 

ggplot() +
  geom_spatraster(data = log_ch4) +
  geom_spatvector(
    data = states,
    fill = NA,
    color = "black",
    linewidth = 0.3
  ) +
  coord_sf(xlim = c(-80, -70), ylim = c(38, 42)) +
  scale_fill_viridis_c(name = expression(log[10] * "(CH"[4] * ")"), na.value = "transparent") +
  labs(
    title = "M3T: Total CH4 Emissions",
    subtitle = "Summary combination inventories",
    x = NULL,
    y = NULL
  ) +
  theme_minimal(base_size = 18) +
  theme(
    plot.title = element_text(face = "bold", size = 22),
    plot.subtitle = element_text(size = 18),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18),
    axis.text = element_text(size = 16)
  ) +
  # cities
  geom_point(
    data = cities,
    aes(x = Longitude, y = Latitude),
    color = "white",
    shape = 21,
    fill = "black",
    size = 2.5
  ) +
  geom_text(
    data = cities,
    aes(x = Longitude, y = Latitude, label = City),
    color = "black",
    size = 5,
    vjust = -0.8,
    fontface = "bold"
  ) +
  # towers
  geom_point(
    data = twr,
    aes(x = Lon, y = Lat),
    color = "red",
    shape = 17,
    size = 3
  ) +
  geom_text(
    data = twr,
    aes(x = Lon, y = Lat, label = SiteCode),
    color = "red",
    size = 5,
    vjust = -0.8,
    fontface = "bold"
  ) +
  # alt gridcells
  geom_point(
    data = alt.gridcells,
    aes(x = Lon, y = Lat),
    color = "blue",
    shape = 4,
    size = 3,
    stroke = 1.2
  ) +
  geom_text(
    data = alt.gridcells,
    aes(x = Lon, y = Lat, label = name),
    color = "blue",
    size = 5,
    vjust = -0.8,
    fontface = "bold"
  ) +
  # point pleasant & cape may
  geom_point(
    data = limits,
    aes(x = Lon, y = Lat),
    color = "black",
    shape = 18,
    size = 3
  ) +
  geom_text(
    data = limits,
    aes(x = Lon, y = Lat, label = name),
    color = "black",
    size = 5,
    vjust = -0.8,
    fontface = "bold"
  )  