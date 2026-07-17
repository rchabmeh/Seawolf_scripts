#alar load in 
ALAR <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2024_Flights/July 2024/2024-07-11/2024-07-11_ALAR_1hz.csv'
)



ALAR$Time_local <- as.POSIXct(ALAR$Time_local, origin = "1904-01-01", tz = "America/New_York")
ALAR$Time_UTC <- as.POSIXct(ALAR$Time_UTC, origin = "1904-01-01", tz = "UTC")

library(openair)
colnames(ALAR)[colnames(ALAR) == "Time_UTC"] <- "date"

ALAR_10sec <- timeAverage(ALAR,
                          avg.time = "10 sec",
                          data.thresh = 0,
                          statistic = "mean")

ALAR_10sec <- ALAR_10sec[!is.na(ALAR_10sec$Latitude_deg), ]
ALAR_10sec <- ALAR_10sec[!is.na(ALAR_10sec$CO2), ]
t <- format(ALAR_10sec$date, "%H:%M:%S")

ALAR_10sec <- ALAR_10sec[
  !(t >= "16:07:00" & t <= "16:15:59"),
]

cols_to_keep <- c("date",  "Latitude_deg", "Longitude_deg", "HeightAbvMSL_m", "heightabvground_m","CO2","CH4")
ALAR_10sec <- ALAR_10sec[, cols_to_keep]

#land vs water
library(sf)
library(maps)
sf_use_s2(FALSE)
df_sf <- st_as_sf(ALAR_10sec,
                  coords = c("Longitude_deg", "Latitude_deg"),
                  crs = 4326)
df_sf$Latitude_deg <- ALAR_10sec$Latitude_deg
df_sf$Longitude_deg <- ALAR_10sec$Longitude_deg
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_sf <- st_set_crs(world_sf, 4326)

df_sf$land <- lengths(st_intersects(df_sf, world_sf)) > 0

land_points  <- df_sf[df_sf$land, ]
ocean_points <- df_sf[!df_sf$land, ]
#plot
plot_df <- data.frame(
  time = ALAR_10sec$date,
  co2  = ALAR_10sec$CO2,
  ch4  = ALAR_10sec$CH4,
  surface = ifelse(df_sf$land, "Land", "Ocean"),
  lat = ALAR_10sec$Latitude_deg,
  lon = ALAR_10sec$Longitude_deg
)
plot_long <- rbind(
  data.frame(time = plot_df$time,
             species = "CO2",
             value = plot_df$co2,
             surface = plot_df$surface,
             lon = plot_df$lon,
             lat = plot_df$lat),
  
  data.frame(time = plot_df$time,
             species = "CH4",
             value = plot_df$ch4,
             surface = plot_df$surface,
             lon = plot_df$lon,
             lat = plot_df$lat)
)

co2_min <- 397
co2_max <- 405

ch4_min <- 1.95
ch4_max <- 2.10


plot_long$value <- ifelse(
  plot_long$species == "CO2",
  pmin(pmax(plot_long$value, co2_min), co2_max),
  pmin(pmax(plot_long$value, ch4_min), ch4_max)
)

library(ggplot2)

cc <- ggplot(plot_long,
       aes(x = time, y = value, color = surface)) +
  geom_point(size = 3) +
  geom_line(aes(group = 1, colour = "black"), alpha = 0.6) +
  facet_wrap(~species, scales = "free_y") +
  scale_color_manual(values = c("Land" = "forestgreen",
                                "Ocean" = "royalblue")) +
         coord_cartesian(xlim = as.POSIXct(c("2024-07-11 16:00:00",
                                            "2024-07-11 16:45:00"), tz = "UTC"))+
  labs(x = "Time (UTC)",
       y = "(ppm)",
       color = "Surface Type",
       title = "CO2 and CH4 Along Flight Path: Land vs Ocean 10s average 7/11/24") + 
  theme_bw()


cc

#### Plotting #####

library(ggplot2)
library(sf)
library(maps)

# get US states as sf
states <- st_as_sf(map("state", plot = FALSE, fill = TRUE))
philly_co2 <- ggplot() +
  geom_sf(data = states, fill = "gray95", color = "gray70") +
  geom_point(data = ALAR_10sec,
             aes(Longitude_deg, Latitude_deg, color = CO2),
             size = 1.5) +
  scale_color_viridis_c(option = "magma", direction = -1, limits = c(393,410)) +
coord_sf(xlim = range(ALAR_10sec$Longitude_deg, na.rm = TRUE),
           ylim = range(ALAR_10sec$Latitude_deg, na.rm = TRUE)) +
  theme_minimal() + labs(x = "Longitude",
                      y = "Latitude",
                      color = "CO2 (ppm)",
                      title = "CO2 Along Flight Path: Land vs Ocean 10s average 7/11/24")  

philly_co2


philly_ch4 <- ggplot() +
  geom_sf(data = states, fill = "gray95", color = "gray70") +
  geom_point(data = ALAR_10sec,
             aes(Longitude_deg, Latitude_deg, color = CH4),
             size = 1.5) +
  scale_color_viridis_c(option = "magma", direction = -1, limits = c(1.93,2.1)) +
  coord_sf(xlim = range(ALAR_10sec$Longitude_deg, na.rm = TRUE),
           ylim = range(ALAR_10sec$Latitude_deg, na.rm = TRUE)) + 
  theme_minimal() +
  labs(x = "Longitude",
       y = "Latitude",
       color = "CH4 (ppm)",
       title = "CH4 Along Flight Path: Land vs Ocean 10s average 7/11/24")  

philly_ch4

library(ggplot2)
library(sf)
library(maps)
states <- st_as_sf(map("state", plot = FALSE, fill = TRUE))
lines_co2 <- ggplot() +
  geom_sf(data = states, fill = "gray95", color = "gray70") +
  
  geom_segment(data = ALAR_10sec,
               aes(x = Longitude_deg,
                   xend = Longitude_deg,
                   y = Latitude_deg,
                   yend = Latitude_deg + (CO2 - 393) * 0.06,  # scale factor
                   color = CO2),        # map color inside aes
               linewidth = 0.7,
               alpha = 0.5) +
  
  scale_color_viridis_c(option = "magma", direction = -1, limits = c(393, 410)) +
  
  coord_sf(
    xlim = c(-74.5, -73),   # longitude range
    ylim = c(40, 41)      # latitude range
  ) +
  
  theme_minimal() +
  labs(x = "Longitude",
       y = "Latitude",
       color = "CO2 (ppm)",
       title = "CO2 Along Flight Path: Land vs Ocean 10s average 7/11/24") 

lines_co2

lines_ch4 <- ggplot() +
  geom_sf(data = states, fill = "gray95", color = "gray70") +
  
  geom_segment(data = ALAR_10sec,
               aes(x = Longitude_deg,
                   xend = Longitude_deg,
                   y = Latitude_deg,
                   yend = Latitude_deg + (CH4 - 1.93) * 4,  # scale factor
                   color = CH4),        # map color inside aes
               linewidth = 0.7,
               alpha = 0.5) +
  
  scale_color_viridis_c(option = "magma", direction = -1, limits = c(1.93, 2.1)) +
  
  coord_sf(
    xlim = c(-74.5, -73),   # longitude range
    ylim = c(40, 41)      # latitude range
  ) +
  
  theme_minimal() +
  labs(x = "Longitude",
       y = "Latitude",
       color = "CH4 (ppm)",
       title = "CH4 Along Flight Path: Land vs Ocean 10s average 7/11/24") 

lines_ch4

library(cowplot)

top_row <- plot_grid(cc, ncol = 1)
bottom_row <- plot_grid(lines_co2, lines_ch4, ncol = 2)

plot_grid(top_row, bottom_row, ncol = 1, rel_heights = c(1, 1))



plot_grid(lines_co2,lines_ch4, ncol = 2)