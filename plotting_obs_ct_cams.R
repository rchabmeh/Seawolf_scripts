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


##### Subset to days/hours of interest #####

dates_c4 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors4.RData")
dates_c4 <-dates_c4$time

dates_c14 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors14.RData")
dates_c14 <-dates_c14$time

dates_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")
dates_c24 <-dates_c24$time

subset_c4 <- c4_5min_daylight[c4_5min_daylight$Date_UTC %in% dates_c4, ]
subset_c14 <- c14_5min_daylight[c14_5min_daylight$Date_UTC %in% dates_c14, ]
subset_c24 <- c24_5min_daylight[c24_5min_daylight$Date_UTC %in% dates_c24, ]


##### All Subset ####
library(dplyr)
library(ggplot2)
all_subset <- bind_rows(subset_c4,subset_c14,subset_c24)


library(dplyr)

all_subset_filtered <- all_subset %>%
  filter({
    local_time <- format(Date_UTC, "%H:%M:%S", tz = "America/New_York")
    local_time >= "10:00:00" & local_time <= "16:00:00"
  })



make_lm_plot <- function(df, xvar, yvar, xlab, ylab, y_offset = 0) {
  
  fit <- lm(df[[yvar]] ~ df[[xvar]])
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))
  
  ggplot(df, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_point(color = "grey4", size = 3) +
    geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
    labs(x = xlab, y = ylab) +
    annotate(
      "text",
      x = min(df[[xvar]], na.rm = TRUE),
      y = max(df[[yvar]], na.rm = TRUE) + y_offset,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
}
p1 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CH4",
  yvar = "CAMS_CH4",
  xlab = "Observed CH4 (ppm)",
  ylab = "CAMS CH4"
)

p2 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CH4",
  yvar = "CT_CH4",
  xlab = "Observed CH4 (ppm)",
  ylab = "CT CH4"
)

p3 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CO2",
  yvar = "CAMS_CO2",
  xlab = "Observed CO2 (ppm)",
  ylab = "CAMS CO2"
)

p4 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CO2",
  yvar = "CT_CO2",
  xlab = "Observed CO2 (ppm)",
  ylab = "CT CO2"
)

# CH4 limits
ch4_x_lim <- range(all_subset_filtered$Observed_CH4, na.rm = TRUE)
ch4_y_lim <- range(c(all_subset_filtered$CAMS_CH4, all_subset$CT_CH4), na.rm = TRUE)

# CO2 limits
co2_x_lim <- range(all_subset_filtered$Observed_CO2, na.rm = TRUE)
co2_y_lim <- range(c(all_subset_filtered$CAMS_CO2, all_subset$CT_CO2), na.rm = TRUE)

p1 <- p1 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)
p2 <- p2 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p3 <- p3 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)
p4 <- p4 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

library(cowplot)

four_panel <- plot_grid(
  p1, p2,
  p3, p4,
  ncol = 2
)

four_panel

four_panel_spaced <- four_panel +
  theme(plot.margin = margin(t = 22, r = 5, b = 5, l = 5))

four_panel_titled <- ggdraw(four_panel_spaced) +
  draw_label(
    "Observed vs Modeled CO2 and CH4 for Cruises #4, 14, & 24",
    x = 0.5, y = 0.99,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 16
  ) +
  draw_label(
    "10:00-16:00 Local Time (between Point Pleasant & Cape May)",
    x = 0.5, y = 0.97,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 12
  )

four_panel_titled



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
### Cruise 4__________________ ####
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

### Cruise 14_________________ ####
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

### Cruise 24_________________ ####
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

#### Other cruises #####
cruise_13 <- read.csv("/Volumes/Seagate/cruise13_eulerian/cruise13_info_5_min_avg_daylight.csv")
cruise_13 <- na.omit(cruise_13)
cruise_13$Date_UTC <- as.POSIXct(cruise_13$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

c13_dates <- c(
  "2022-09-27 19:00:00 UTC",
  "2022-09-27 20:00:00 UTC",
  "2022-09-27 21:00:00 UTC",
  "2022-09-27 22:00:00 UTC",
  "2022-09-27 23:00:00 UTC",
  "2022-09-28 00:00:00 UTC",
  "2022-09-28 01:00:00 UTC",
  "2022-09-28 02:00:00 UTC",
  "2022-09-28 03:00:00 UTC",
  "2022-09-28 04:00:00 UTC",
  "2022-09-28 05:00:00 UTC",
  "2022-09-28 06:00:00 UTC",
  "2022-09-28 07:00:00 UTC",
  "2022-09-28 08:00:00 UTC",
  "2022-09-28 09:00:00 UTC",
  "2022-09-28 10:00:00 UTC",
  "2022-09-28 11:00:00 UTC",
  "2022-09-28 12:00:00 UTC",
  "2022-09-28 13:00:00 UTC",
  "2022-09-28 14:00:00 UTC",
  "2022-09-28 15:00:00 UTC",
  "2022-09-28 16:00:00 UTC",
  "2022-09-28 17:00:00 UTC",
  "2022-09-28 18:00:00 UTC",
  "2022-09-28 19:00:00 UTC",
  "2022-09-28 20:00:00 UTC",
  "2022-09-28 21:00:00 UTC",
  "2022-09-28 22:00:00 UTC",
  "2022-09-28 23:00:00 UTC",
  "2022-09-29 00:00:00 UTC"
)
c13_dates <- as.POSIXct(
  c13_dates,
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC"
)
cruise_13$Date_UTC_min_fix <- cruise_13$Date_UTC - as.difftime(1, units = "mins")

subset_13 <- cruise_13[cruise_13$Date_UTC_min_fix %in% c13_dates, ]
subset_13$Date_UTC <- subset_13$Date_UTC_min_fix #just for plotting only

cruise_19 <- read.csv("/Volumes/Seagate/cruise19_eulerian/cruise19_info_5_min_avg_daylight.csv")
cruise_19 <- na.omit(cruise_19)
cruise_19$date <- as.POSIXct(cruise_19$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

c19_dates <- c(
  "2023-03-30 22:00:00 UTC",
  "2023-03-30 23:00:00 UTC",
  "2023-03-31 00:00:00 UTC",
  "2023-03-31 01:00:00 UTC",
  "2023-03-31 02:00:00 UTC",
  "2023-03-31 03:00:00 UTC",
  "2023-03-31 04:00:00 UTC",
  "2023-03-31 05:00:00 UTC",
  "2023-04-03 01:00:00 UTC",
  "2023-04-03 02:00:00 UTC",
  "2023-04-03 03:00:00 UTC",
  "2023-04-03 04:00:00 UTC",
  "2023-04-03 05:00:00 UTC",
  "2023-04-03 06:00:00 UTC",
  "2023-04-03 07:00:00 UTC",
  "2023-04-07 02:00:00 UTC",
  "2023-04-07 03:00:00 UTC",
  "2023-04-07 04:00:00 UTC",
  "2023-04-07 05:00:00 UTC",
  "2023-04-07 06:00:00 UTC",
  "2023-04-07 07:00:00 UTC",
  "2023-04-07 08:00:00 UTC"
)
c19_dates <- as.POSIXct(c19_dates, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
subset_19 <- cruise_19[cruise_19$date %in% c19_dates, ]




library(dplyr)
library(ggplot2)
all_subset <- bind_rows(subset_c4,subset_c14,subset_c24, subset_13)

all_subset_filtered <- all_subset %>%
  filter({
    local_time <- format(Date_UTC, "%H:%M:%S", tz = "America/New_York")
    local_time >= "10:00:00" & local_time <= "16:00:00"
  })



make_lm_plot <- function(df, xvar, yvar, xlab, ylab, y_offset = 0) {
  
  fit <- lm(df[[yvar]] ~ df[[xvar]])
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))
  
  ggplot(df, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_point(color = "grey4", size = 3) +
    geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
    labs(x = xlab, y = ylab) +
    annotate(
      "text",
      x = min(df[[xvar]], na.rm = TRUE),
      y = max(df[[yvar]], na.rm = TRUE) + y_offset,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
}
p1 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CH4",
  yvar = "CAMS_CH4",
  xlab = "Observed CH4 (ppm)",
  ylab = "CAMS CH4"
)

p2 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CH4",
  yvar = "CT_CH4",
  xlab = "Observed CH4 (ppm)",
  ylab = "CT CH4"
)

p3 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CO2",
  yvar = "CAMS_CO2",
  xlab = "Observed CO2 (ppm)",
  ylab = "CAMS CO2"
)

p4 <- make_lm_plot(
  all_subset_filtered,
  xvar = "Observed_CO2",
  yvar = "CT_CO2",
  xlab = "Observed CO2 (ppm)",
  ylab = "CT CO2"
)

# CH4 limits
ch4_x_lim <- range(all_subset_filtered$Observed_CH4, na.rm = TRUE)
ch4_y_lim <- range(c(all_subset_filtered$CAMS_CH4, all_subset$CT_CH4), na.rm = TRUE)

# CO2 limits
co2_x_lim <- range(all_subset_filtered$Observed_CO2, na.rm = TRUE)
co2_y_lim <- range(c(all_subset_filtered$CAMS_CO2, all_subset$CT_CO2), na.rm = TRUE)

p1 <- p1 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)
p2 <- p2 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p3 <- p3 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)
p4 <- p4 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

library(cowplot)

four_panel <- plot_grid(
  p1, p2,
  p3, p4,
  ncol = 2
)

four_panel

four_panel_spaced <- four_panel +
  theme(plot.margin = margin(t = 22, r = 5, b = 5, l = 5))

four_panel_titled <- ggdraw(four_panel_spaced) +
  draw_label(
    "Observed vs Modeled CO2 and CH4 for Cruises #4, 13, 14, & 24",
    x = 0.5, y = 0.99,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 16
  ) +
  draw_label(
    "10:00-16:00 Local Time",
    x = 0.5, y = 0.97,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 12
  )

four_panel_titled
