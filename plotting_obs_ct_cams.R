##### Loading in Data #####
c4_5min_daylight <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_4/cruise4_info_5_min_avg_daylight.csv")
c14_5min_daylight <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_14/cruise14_info_5_min_avg_daylight.csv")
c24_5min_daylight <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_24/cruise24_info_5_min_avg_daylight.csv")

c4_5min_daylight <- na.omit(c4_5min_daylight)
c14_5min_daylight <- na.omit(c14_5min_daylight)
c24_5min_daylight <- na.omit(c24_5min_daylight)


c4_5min_daylight$Date_UTC <- as.POSIXct(c4_5min_daylight$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c14_5min_daylight$Date_UTC <- as.POSIXct(c14_5min_daylight$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c24_5min_daylight$Date_UTC <- as.POSIXct(c24_5min_daylight$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")


##### Subsetting to days/hours of interest #####

dates_c4 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors4.RData")
dates_c4 <-dates_c4$time

dates_c14 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors14.RData")
dates_c14 <-dates_c14$time

dates_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")
dates_c24 <-dates_c24$time

subset_c4 <- c4_5min_daylight[c4_5min_daylight$Date_UTC %in% dates_c4, ]
subset_c14 <- c14_5min_daylight[c14_5min_daylight$Date_UTC %in% dates_c14, ]
subset_c24 <- c24_5min_daylight[c24_5min_daylight$Date_UTC %in% dates_c24, ]


##### Getting ready for plotting #####
library(maps)
states <- map_data("state")

ne_states <- c(
  "maine", "new hampshire", "vermont",
  "massachusetts", "rhode island", "connecticut",
  "new york", "new jersey", "pennsylvania"
)

states_ne <- states[states$region %in% ne_states, ]

xlim_use <- range(subset_c4$Longitude_deg, na.rm = TRUE) + c(-0.05, 1)
ylim_use <- range(subset_c4$Latitude_deg,  na.rm = TRUE) + c(-0.05, 1)

sites <- data.frame(
  site = c("Cape May", "Point Pleasant"),
  lat  = c(38.9316, 40.0829),
  lon  = c(-74.9108, -74.0683)
)

##### Plotting #####
library(ggplot2)
### Cruise 4 ####
co2_limits <- range(
  c(
    subset_c4$Observed_CO2,
    subset_c4$CT_CO2,
    subset_c4$CAMS_CO2
  ),
  na.rm = TRUE
)

scale_co2 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = co2_limits,
  name = expression(CO[2]~"(ppm)")
)

ch4_limits <- range(
  c(
    subset_c4$Observed_CH4,
    subset_c4$CT_CH4,
    subset_c4$CAMS_CH4
  ),
  na.rm = TRUE
)

scale_ch4 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = ch4_limits,
  name = expression(CH[4]~"(ppm)")
)

### CO2 ####
#OBS
plot_c4_obs <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c4,
    aes(x = Longitude_deg, y = Latitude_deg, colour = Observed_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 4 Observed Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CT
plot_c4_ct <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c4,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CT_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 4 CT Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CAMS
plot_c4_cams <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c4,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CAMS_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 4 CAMS Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

library(cowplot)

plot_grid(plot_c4_obs,plot_c4_ct,plot_c4_cams, ncol = 3)

### CH4 ####
#OBS
plot_c4_obs <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c4,
    aes(x = Longitude_deg, y = Latitude_deg, colour = Observed_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CH[4]),
    title = "Cruise 4 Observed Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CT
plot_c4_ct <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c4,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CT_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 4 CT Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CAMS
plot_c4_cams <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c4,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CAMS_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CH[4]),
    title = "Cruise 4 CAMS Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

library(cowplot)

plot_grid(plot_c4_obs,plot_c4_ct,plot_c4_cams, ncol = 3)

### Cruise 14 ####
co2_limits <- range(
  c(
    subset_c14$Observed_CO2,
    subset_c14$CT_CO2,
    subset_c14$CAMS_CO2
  ),
  na.rm = TRUE
)

scale_co2 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = co2_limits,
  name = expression(CO[2]~"(ppm)")
)

ch4_limits <- range(
  c(
    subset_c14$Observed_CH4,
    subset_c14$CT_CH4,
    subset_c14$CAMS_CH4
  ),
  na.rm = TRUE
)

scale_ch4 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = ch4_limits,
  name = expression(CH[4]~"(ppm)")
)
 
### CO2 ####
#OBS
plot_c14_obs <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c14,
    aes(x = Longitude_deg, y = Latitude_deg, colour = Observed_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 14 Observed Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CT
plot_c14_ct <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c14,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CT_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 14 CT Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CAMS
plot_c14_cams <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c14,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CAMS_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 14 CAMS Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

library(cowplot)

plot_grid(plot_c14_obs,plot_c14_ct,plot_c14_cams, ncol = 3)

### CH4 ####
#OBS
plot_c14_obs <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c14,
    aes(x = Longitude_deg, y = Latitude_deg, colour = Observed_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CH[4]),
    title = "Cruise 14 Observed Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CT
plot_c14_ct <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c14,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CT_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CH[4]),
    title = "Cruise 14 CT Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CAMS
plot_c14_cams <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c14,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CAMS_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 14 CAMS Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

library(cowplot)

plot_grid(plot_c14_obs,plot_c14_ct,plot_c14_cams, ncol = 3)

### Cruise 24 ####
co2_limits <- range(
  c(
    subset_c24$Observed_CO2,
    subset_c24$CT_CO2,
    subset_c24$CAMS_CO2
  ),
  na.rm = TRUE
)

scale_co2 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = co2_limits,
  name = expression(CO[2]~"(ppm)")
)

ch4_limits <- range(
  c(
    subset_c24$Observed_CH4,
    subset_c24$CT_CH4,
    subset_c24$CAMS_CH4
  ),
  na.rm = TRUE
)

scale_ch4 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = ch4_limits,
  name = expression(CH[4]~"(ppm)")
)

### CO2 ####
#OBS
plot_c24_obs <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c24,
    aes(x = Longitude_deg, y = Latitude_deg, colour = Observed_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 24 Observed Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CT
plot_c24_ct <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c24,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CT_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 24 CT Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CAMS
plot_c24_cams <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c24,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CAMS_CO2),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 24 CAMS Carbon Dioxide (ppm)"
  ) +
  theme_grey() + 
  scale_co2 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

library(cowplot)

plot_grid(plot_c24_obs,plot_c24_ct,plot_c24_cams, ncol = 3)

### CH4 ####
#OBS
plot_c24_obs <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c24,
    aes(x = Longitude_deg, y = Latitude_deg, colour = Observed_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CH[4]),
    title = "Cruise 24 Observed Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CT
plot_c24_ct <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c24,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CT_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 24 CT Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

#CAMS
plot_c24_cams <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_line(
    data = subset_c24,
    aes(x = Longitude_deg, y = Latitude_deg, colour = CAMS_CH4),
    linewidth = 1
  ) +
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CH[4]),
    title = "Cruise 24 CAMS Methane (ppm)"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  )

library(cowplot)

plot_grid(plot_c24_obs,plot_c24_ct,plot_c24_cams, ncol = 3)
