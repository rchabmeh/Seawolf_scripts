##### Calculating Enhancement via lowest 5th % ######
#### Calculating background ####
c4_5min_daylight <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/c4_alt_models_5min_daylight.csv"
)
c14_5min_daylight <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/c14_alt_models_5min_daylight.csv"
)
c24_5min_daylight <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_5min_daylight.csv"
)

c4_5min_daylight <- na.omit(c4_5min_daylight)
c14_5min_daylight <- na.omit(c14_5min_daylight)
c24_5min_daylight <- na.omit(c24_5min_daylight)


c4_5min_daylight$date <- as.POSIXct(c4_5min_daylight$date, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c14_5min_daylight$date <- as.POSIXct(c14_5min_daylight$date, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c14_5min_daylight$date <- c14_5min_daylight$date - 120
c24_5min_daylight$date <- as.POSIXct(c24_5min_daylight$date, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
c24_5min_daylight$date <- c24_5min_daylight$date - 60
dates_c4 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors4.RData")
dates_c4 <- dates_c4$time

dates_c14 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors14.RData")
dates_c14 <- dates_c14$time

dates_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")
dates_c24 <- dates_c24$time

subset_c4 <- c4_5min_daylight[c4_5min_daylight$date %in% dates_c4, ]
subset_c14 <- c14_5min_daylight[c14_5min_daylight$date %in% dates_c14, ]
subset_c24 <- c24_5min_daylight[c24_5min_daylight$date %in% dates_c24, ]

sites <- data.frame(
  site = c("Cape May", "Point Pleasant"),
  lat  = c(38.9316, 40.0829),
  lon  = c(-74.9108, -74.0683)
)

subset_c4 <- subset_c4[subset_c4$Latitude_deg >= sites$lat[1] &
                         subset_c4$Latitude_deg <= sites$lat[2] &
                         subset_c4$Longitude_deg >= sites$lon[1] &
                         subset_c4$Longitude_deg <= sites$lon[2], ]

subset_c14 <- subset_c14[subset_c14$Latitude_deg >= sites$lat[1] &
                           subset_c14$Latitude_deg <= sites$lat[2] &
                           subset_c14$Longitude_deg >= sites$lon[1] &
                           subset_c14$Longitude_deg <= sites$lon[2], ]

subset_c24 <- subset_c24[subset_c24$Latitude_deg >= sites$lat[1] &
                           subset_c24$Latitude_deg <= sites$lat[2] &
                           subset_c24$Longitude_deg >= sites$lon[1] &
                           subset_c24$Longitude_deg <= sites$lon[2], ]

c4_co2 <- sort(subset_c4$CO2_dry_cal_moving_day, decreasing = F)
c4_ch4 <- sort(subset_c4$CH4_dry_cal_moving_day, decreasing = F)

c14_co2 <- sort(subset_c14$CO2_dry_cal_moving_day, decreasing = F)
c14_ch4 <- sort(subset_c14$CH4_dry_cal_moving_day, decreasing = F)

c24_co2 <- sort(subset_c24$CO2_dry_cal_moving_day, decreasing = F)
c24_ch4 <- sort(subset_c24$CH4_dry_cal_moving_day, decreasing = F)


c4_co2_L5th <- c4_co2[c4_co2 <= quantile(c4_co2, 0.05)]
c4_co2_bkgrd <- round(mean(c4_co2_L5th), 3)
c4_ch4_L5th <- c4_ch4[c4_ch4 <= quantile(c4_ch4, 0.05)]
c4_ch4_bkgrd <- round(mean(c4_ch4_L5th), 3)

c14_co2_L5th <- c14_co2[c14_co2 <= quantile(c14_co2, 0.05)]
c14_co2_bkgrd <- round(mean(c14_co2_L5th), 3)
c14_ch4_L5th <- c14_ch4[c14_ch4 <= quantile(c14_ch4, 0.05)]
c14_ch4_bkgrd <- round(mean(c14_ch4_L5th), 3)

c24_co2_L5th <- c24_co2[c24_co2 <= quantile(c24_co2, 0.05)]
c24_co2_bkgrd <- round(mean(c24_co2_L5th), 3)
c24_ch4_L5th <- c24_ch4[c24_ch4 <= quantile(c24_ch4, 0.05)]
c24_ch4_bkgrd <- round(mean(c24_ch4_L5th), 3)


background.values <- data.frame(
  cruise = c("C4", "C14", "C24"),
  
  co2 = c(c4_co2_bkgrd, c14_co2_bkgrd, c24_co2_bkgrd),
  
  ch4 = c(c4_ch4_bkgrd, c14_ch4_bkgrd, c24_ch4_bkgrd)
  
  
)

#### Calculating enhancement (daylight/lat-lon sorted w/ NO tower comparison) ####

enh.c4 <- data.frame(
  co2_enh = (subset_c4$CO2_dry_cal_moving_day - c4_co2_bkgrd),
  ch4_enh = (subset_c4$CH4_dry_cal_moving_day - c4_ch4_bkgrd),
  date = subset_c4$date,
  lat = subset_c4$Latitude_deg,
  lon = subset_c4$Longitude_deg
)


enh.c14 <- data.frame(
  co2_enh = (subset_c14$CO2_dry_cal_moving_day - c14_co2_bkgrd),
  ch4_enh = (subset_c14$CH4_dry_cal_moving_day - c14_ch4_bkgrd),
  date = subset_c14$date,
  lat = subset_c14$Latitude_deg,
  lon = subset_c14$Longitude_deg
)

enh.c24 <- data.frame(
  co2_enh = (subset_c24$CO2_dry_cal_moving_day - c24_co2_bkgrd),
  ch4_enh = (subset_c24$CH4_dry_cal_moving_day - c24_ch4_bkgrd),
  date = subset_c24$date,
  lat = subset_c24$Latitude_deg,
  lon = subset_c24$Longitude_deg
)

#### Loading in dfs w/ tower data ####
lew.enh.c4 <- read.csv("/Volumes/Seagate/cruise4_eulerian/all_models_merged_cruise4.csv")
lew.enh.c4$date <- ifelse(nchar(lew.enh.c4$date) == 10,
                          paste0(lew.enh.c4$date, " 00:00:00"),
                          lew.enh.c4$date)
lew.enh.c4$date <- as.POSIXct(lew.enh.c4$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

lew.enh.c14 <- read.csv("/Volumes/Seagate/cruise14_eulerian/all_models_merged_cruise14.csv")
lew.enh.c14$date <- ifelse(
  nchar(lew.enh.c14$date) == 10,
  paste0(lew.enh.c14$date, " 00:00:00"),
  lew.enh.c14$date
)

lew.enh.c14$date <- as.POSIXct(lew.enh.c14$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

lew.enh.c24 <- read.csv("/Volumes/Seagate/cruise24_eulerian/all_models_merged_cruise24.csv")

lew.enh.c24$date <- ifelse(
  nchar(lew.enh.c24$date) == 10,
  paste0(lew.enh.c24$date, " 00:00:00"),
  lew.enh.c24$date
)

lew.enh.c24$date <- as.POSIXct(lew.enh.c24$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

df_names <- c("lew.enh.c4", "lew.enh.c14", "lew.enh.c24")

for (df_name in df_names) {
  df <- get(df_name)
  
  df$DATE_NY_AMERICA <- as.POSIXct(format(df$date, tz = "America/New_York", usetz = TRUE), tz = "America/New_York")
  
  hour_ny <- as.numeric(format(df$DATE_NY_AMERICA, "%H"))
  
  df <- df[hour_ny >= 10 & hour_ny < 16, ]
  
  assign(df_name, df)
}

#### c4 plot w LEW ####
library(ggplot2)

plot_df_4co2 <- data.frame(
  date = lew.enh.c4$date,
  
  lew_enh = lew.enh.c4$obs_co2_enh_via_LEW,
  
  fifth_percent = lew.enh.c4$ship_co2_obs -
    background.values$co2[background.values$cruise == "C4"]
)

ggplot(plot_df_4co2, aes(x = date)) +
  
  geom_line(aes(y = lew_enh, color = "LEW")) +
  geom_point(aes(y = lew_enh, color = "LEW")) +
  
  geom_line(aes(y = fifth_percent, color = "Lowest 5th %")) +
  geom_point(aes(y = fifth_percent, color = "Lowest 5th %")) +
  
  
  labs(
    x = "Date UTC",
    y = expression(CO[2] ~ enh ~ "(ppm)"),
    title = "Cruise 4 CO2 enhancement comparison",
    color = "Method"
  ) +
  
  theme_bw()

plot_df_4ch4 <- data.frame(
  date = lew.enh.c4$date,
  
  lew_enh = lew.enh.c4$obs_ch4_enh_via_LEW,
  
  fifth_percent = lew.enh.c4$ship_ch4_cams.x -
    (1000 * background.values$ch4[background.values$cruise == "C4"])
)

ggplot(plot_df_4ch4, aes(x = date)) +
  
  geom_line(aes(y = lew_enh, color = "LEW")) +
  geom_point(aes(y = lew_enh, color = "LEW")) +
  
  geom_line(aes(y = fifth_percent, color = "Lowest 5th %")) +
  geom_point(aes(y = fifth_percent, color = "Lowest 5th %")) +
  
  labs(
    x = "Date UTC",
    y = expression(CH[4] ~ enh ~ "(ppm)"),
    title = "Cruise 4 CH4 enhancement comparison",
    color = "Method"
  ) +
  
  theme_bw()

#### c14 plot w TMD #####

plot_df_14co2 <- data.frame(
  date = lew.enh.c14$date,
  
  lew_enh = lew.enh.c14$obs_co2_enh_via_TMD,
  
  fifth_percent = lew.enh.c14$ship_co2_obs -
    background.values$co2[background.values$cruise == "C14"]
)

ggplot(plot_df_14co2, aes(x = date)) +
  
  geom_line(aes(y = lew_enh, color = "TMD")) +
  geom_point(aes(y = lew_enh, color = "TMD")) +
  
  geom_line(aes(y = fifth_percent, color = "Lowest 5th %")) +
  geom_point(aes(y = fifth_percent, color = "Lowest 5th %")) +
  
  labs(
    x = "Date UTC",
    y = expression(CO[2] ~ enh ~ "(ppm)"),
    title = "Cruise 14 CO2 enhancement comparison",
    color = "Method"
  ) +
  scale_color_manual(values = c(
    "TMD" = "#F8766D",
    "Lowest 5th %" = "#00BFC4"
  )) +
  theme_bw()

plot_df_14ch4 <- data.frame(
  date = lew.enh.c14$date,
  
  lew_enh = lew.enh.c14$obs_ch4_enh_via_TMD,
  
  fifth_percent = lew.enh.c14$ship_ch4_cams.x -
    (1000 * background.values$ch4[background.values$cruise == "C14"])
)

ggplot(plot_df_14ch4, aes(x = date)) +
  
  geom_line(aes(y = lew_enh, color = "TMD")) +
  geom_point(aes(y = lew_enh, color = "TMD")) +
  
  geom_line(aes(y = fifth_percent, color = "Lowest 5th %")) +
  geom_point(aes(y = fifth_percent, color = "Lowest 5th %")) +
  
  labs(
    x = "Date UTC",
    y = expression(CH[4] ~ enh ~ "(ppm)"),
    title = "Cruise 14 CH4 enhancement comparison",
    color = "Method"
  ) +
  scale_color_manual(values = c(
    "TMD" = "#F8766D",
    "Lowest 5th %" = "#00BFC4"
  )) +
  theme_bw()



#### c24 plot w LEW #####

plot_df_24co2 <- data.frame(
  date = lew.enh.c24$date,
  
  lew_enh = lew.enh.c24$obs_co2_enh_via_LEW,
  
  fifth_percent = lew.enh.c24$ship_co2_obs -
    background.values$co2[background.values$cruise == "C24"]
)

ggplot(plot_df_24co2, aes(x = date)) +
  
  geom_line(aes(y = lew_enh, color = "LEW")) +
  geom_point(aes(y = lew_enh, color = "LEW")) +
  
  geom_line(aes(y = fifth_percent, color = "Lowest 5th %")) +
  geom_point(aes(y = fifth_percent, color = "Lowest 5th %")) +
  
  labs(
    x = "Date UTC",
    y = expression(CO[2] ~ enh ~ "(ppm)"),
    title = "Cruise 24 CO2 enhancement comparison",
    color = "Method"
  ) +
  
  theme_bw()

plot_df_24ch4 <- data.frame(
  date = lew.enh.c24$date,
  
  lew_enh = lew.enh.c24$obs_ch4_enh_via_LEW,
  
  fifth_percent = lew.enh.c24$ship_ch4_cams.x -
    (1000 * background.values$ch4[background.values$cruise == "C24"])
)

ggplot(plot_df_24ch4, aes(x = date)) +
  
  geom_line(aes(y = lew_enh, color = "LEW")) +
  geom_point(aes(y = lew_enh, color = "LEW")) +
  
  geom_line(aes(y = fifth_percent, color = "Lowest 5th %")) +
  geom_point(aes(y = fifth_percent, color = "Lowest 5th %")) +
  
  labs(
    x = "Date UTC",
    y = expression(CH[4] ~ enh ~ "(ppm)"),
    title = "Cruise 24 CH4 enhancement comparison",
    color = "Method"
  ) +
  
  theme_bw()

#### _________________ EXTRA ___________________ #####
#### create dfs for initial tower comparison #####
df4 <- data.frame(
  date = lew.enh.c4$date,
  obs_co2 = lew.enh.c4$ship_co2_obs,
  obs_ch4 = lew.enh.c4$ship_ch4_cams.x,
  obs_co2_enh_lew = lew.enh.c4$obs_co2_enh_via_LEW,
  obs_ch4_enh_lew = lew.enh.c4$obs_ch4_enh_via_LEW,
  obs_co2_enh_5th = lew.enh.c4$ship_co2_obs - background.values$co2[1],
  obs_ch4_enh_5th = lew.enh.c4$ship_ch4_cams.x - (1000 * background.values$ch4[1]),
  ct_co2_enh = lew.enh.c4$ct_co2_enh_via_LEW,
  ct_ch4_enh = lew.enh.c4$ct_ch4_enh_via_LEW,
  cams_co2_enh = lew.enh.c4$cams_co2_enh_via_LEW,
  cams_ch4_enh = lew.enh.c4$cams_ch4_enh_via_LEW
)

df14 <- data.frame(
  date = lew.enh.c14$date,
  obs_co2 = lew.enh.c14$ship_co2_obs,
  obs_ch4 = lew.enh.c14$ship_ch4_cams.x,
  obs_co2_enh_tmd = lew.enh.c14$obs_co2_enh_via_TMD,
  obs_ch4_enh_tmd = lew.enh.c14$obs_ch4_enh_via_TMD,
  obs_co2_enh_5th = lew.enh.c14$ship_co2_obs - background.values$co2[2],
  obs_ch4_enh_5th = lew.enh.c14$ship_ch4_cams.x - (1000 * background.values$ch4[2]),
  ct_co2_enh = lew.enh.c14$ct_co2_enh_via_TMD,
  ct_ch4_enh = lew.enh.c14$ct_ch4_enh_via_TMD,
  cams_co2_enh = lew.enh.c14$cams_co2_enh_via_TMD,
  cams_ch4_enh = lew.enh.c14$cams_ch4_enh_via_TMD
)

df24 <- data.frame(
  date = lew.enh.c24$date,
  obs_co2 = lew.enh.c24$ship_co2_obs,
  obs_ch4 = lew.enh.c24$ship_ch4_cams.x,
  obs_co2_enh_lew = lew.enh.c24$obs_co2_enh_via_LEW,
  obs_ch4_enh_lew = lew.enh.c24$obs_ch4_enh_via_LEW,
  obs_co2_enh_5th = lew.enh.c24$ship_co2_obs - background.values$co2[3],
  obs_ch4_enh_5th = lew.enh.c24$ship_ch4_cams.x - (1000 * background.values$ch4[3]),
  ct_co2_enh = lew.enh.c24$ct_co2_enh_via_LEW,
  ct_ch4_enh = lew.enh.c24$ct_ch4_enh_via_LEW,
  cams_co2_enh = lew.enh.c24$cams_co2_enh_via_LEW,
  cams_ch4_enh = lew.enh.c24$cams_ch4_enh_via_LEW
)

df4$CRUISE <- "C4"
df4$SOURCE <- "LEW"

df14$CRUISE <- "C14"
df14$SOURCE <- "TMD"

df24$CRUISE <- "C24"
df24$SOURCE <- "LEW"

names(df4)[names(df4) == "obs_co2_enh_lew"] <- "obs_co2_enh_tower"
names(df4)[names(df4) == "obs_ch4_enh_lew"] <- "obs_ch4_enh_tower"

names(df14)[names(df14) == "obs_co2_enh_tmd"] <- "obs_co2_enh_tower"
names(df14)[names(df14) == "obs_ch4_enh_tmd"] <- "obs_ch4_enh_tower"

names(df24)[names(df24) == "obs_co2_enh_lew"] <- "obs_co2_enh_tower"
names(df24)[names(df24) == "obs_ch4_enh_lew"] <- "obs_ch4_enh_tower"

all_df <- rbind(df4, df14, df24)

all_df <- all_df[!is.na(all_df$obs_co2), ]


co2_df <- data.frame(
  DATE = all_df$date,
  CRUISE = all_df$CRUISE,
  SOURCE = all_df$SOURCE,
  OBS_ENH_TWR = all_df$obs_co2_enh_tower,
  OBS_ENH_5TH = all_df$obs_co2_enh_5th,
  CT_ENH = all_df$ct_co2_enh,
  CAMS_ENH = all_df$cams_co2_enh,
  GAS = "CO2"
)

ch4_df <- data.frame(
  DATE = all_df$date,
  CRUISE = all_df$CRUISE,
  SOURCE = all_df$SOURCE,
  OBS_ENH_TWR = all_df$obs_ch4_enh_tower,
  OBS_ENH_5TH = all_df$obs_ch4_enh_5th,
  CT_ENH = all_df$ct_ch4_enh,
  CAMS_ENH = all_df$cams_ch4_enh,
  GAS = "CH4"
)

#### plots against towers ####
#co2 - 5th %
library(reshape2)
library(dplyr)
library(ggplot2)

long_co2 <- melt(
  co2_df,
  id.vars = c("OBS_ENH_5TH", "CRUISE"),
  measure.vars = c("CAMS_ENH", "CT_ENH"),
  variable.name = "MODEL",
  value.name = "MODEL_ENH"
)

stats_co2 <- long_co2 %>%
  group_by(MODEL) %>%
  summarise(
    m = coef(lm(MODEL_ENH ~ OBS_ENH_5TH))[2],
    b = coef(lm(MODEL_ENH ~ OBS_ENH_5TH))[1],
    r2 = summary(lm(MODEL_ENH ~ OBS_ENH_5TH))$r.squared,
    .groups = "drop"
  )

stats_co2$label <- paste0(
  "y = ",
  round(stats_co2$m, 3),
  "x + ",
  round(stats_co2$b, 3),
  "\nR² = ",
  round(stats_co2$r2, 3)
)

p1_co2 <- ggplot(long_co2, aes(x = OBS_ENH_5TH, y = MODEL_ENH, color = CRUISE)) +
  
  geom_point() +
  
  geom_smooth(method = "lm",
              se = FALSE,
              color = "black") +
  
  facet_wrap( ~ MODEL) +
  
  geom_abline(slope = 1,
              intercept = 0,
              linetype = "dashed") +
  
  geom_text(
    data = stats_co2,
    aes(
      x = min(long_co2$OBS_ENH_5TH, na.rm = TRUE),
      y = max(long_co2$MODEL_ENH, na.rm = TRUE),
      label = label
    ),
    inherit.aes = FALSE,
    hjust = 0,
    vjust = 1.2,
    size = 4
  ) +
  
  theme_bw() +
  
  labs(x = "5th percentile Observed CO2 enhancement (ppm)", y = "Modeled CO2 enhancement (ppm)", color = "Cruise")

#ch4 - 5th %
library(reshape2)
library(dplyr)
library(ggplot2)

long_ch4 <- melt(
  ch4_df,
  id.vars = c("OBS_ENH_5TH", "CRUISE"),
  measure.vars = c("CAMS_ENH", "CT_ENH"),
  variable.name = "MODEL",
  value.name = "MODEL_ENH"
)

stats_ch4 <- long_ch4 %>%
  group_by(MODEL) %>%
  summarise(
    m = coef(lm(MODEL_ENH ~ OBS_ENH_5TH))[2],
    b = coef(lm(MODEL_ENH ~ OBS_ENH_5TH))[1],
    r2 = summary(lm(MODEL_ENH ~ OBS_ENH_5TH))$r.squared,
    .groups = "drop"
  )

stats_ch4$label <- paste0(
  "y = ",
  round(stats_ch4$m, 3),
  "x + ",
  round(stats_ch4$b, 3),
  "\nR² = ",
  round(stats_ch4$r2, 3)
)


p1_ch4 <- ggplot(long_ch4, aes(x = OBS_ENH_5TH, y = MODEL_ENH, color = CRUISE)) +
  
  geom_point() +
  geom_smooth(method = "lm",
              se = FALSE,
              color = "black") +
  facet_wrap( ~ MODEL) +
  
  geom_abline(slope = 1,
              intercept = 0,
              linetype = "dashed") +
  
  geom_text(
    data = stats_ch4,
    aes(
      x = min(long_ch4$OBS_ENH_5TH, na.rm = TRUE),
      y = max(long_ch4$MODEL_ENH, na.rm = TRUE),
      label = label
    ),
    inherit.aes = FALSE,
    hjust = 0,
    vjust = 1.2,
    size = 4
  ) +
  
  theme_bw() +
  
  labs(x = "5th percentile Observed CH4 enhancement (ppb)", y = "Modeled CH4 enhancement (ppb)", color = "Cruise")

#co2 - tower
long_co2_twr <- melt(
  co2_df,
  id.vars = c("OBS_ENH_TWR", "CRUISE"),
  measure.vars = c("CAMS_ENH", "CT_ENH"),
  variable.name = "MODEL",
  value.name = "MODEL_ENH"
)

stats_co2_twr <- long_co2_twr %>%
  group_by(MODEL) %>%
  summarise(
    m = coef(lm(MODEL_ENH ~ OBS_ENH_TWR))[2],
    b = coef(lm(MODEL_ENH ~ OBS_ENH_TWR))[1],
    r2 = summary(lm(MODEL_ENH ~ OBS_ENH_TWR))$r.squared,
    .groups = "drop"
  )

stats_co2_twr$label <- paste0(
  "y = ",
  round(stats_co2_twr$m, 3),
  "x + ",
  round(stats_co2_twr$b, 3),
  "\nR² = ",
  round(stats_co2_twr$r2, 3)
)

p2_co2 <- ggplot(long_co2_twr, aes(x = OBS_ENH_TWR, y = MODEL_ENH, color = CRUISE)) +
  
  geom_point() +
  facet_wrap( ~ MODEL) +
  geom_smooth(method = "lm",
              se = FALSE,
              color = "black") +
  geom_abline(slope = 1,
              intercept = 0,
              linetype = "dashed") +
  
  geom_text(
    data = stats_co2_twr,
    aes(
      x = min(long_co2_twr$OBS_ENH_TWR, na.rm = TRUE),
      y = max(long_co2_twr$MODEL_ENH, na.rm = TRUE),
      label = label
    ),
    inherit.aes = FALSE,
    hjust = 0,
    vjust = 1.2,
    size = 4
  ) +
  
  theme_bw() +
  labs(x = "Tower CO2 enhancement Using Tower (ppm)", y = "Modeled CO2 enhancement (ppm)", color = "Cruise")

# ch4 - tower
long_ch4_twr <- melt(
  ch4_df,
  id.vars = c("OBS_ENH_TWR", "CRUISE"),
  measure.vars = c("CAMS_ENH", "CT_ENH"),
  variable.name = "MODEL",
  value.name = "MODEL_ENH"
)

stats_ch4_twr <- long_ch4_twr %>%
  group_by(MODEL) %>%
  summarise(
    m = coef(lm(MODEL_ENH ~ OBS_ENH_TWR))[2],
    b = coef(lm(MODEL_ENH ~ OBS_ENH_TWR))[1],
    r2 = summary(lm(MODEL_ENH ~ OBS_ENH_TWR))$r.squared,
    .groups = "drop"
  )

stats_ch4_twr$label <- paste0(
  "y = ",
  round(stats_ch4_twr$m, 3),
  "x + ",
  round(stats_ch4_twr$b, 3),
  "\nR² = ",
  round(stats_ch4_twr$r2, 3)
)

p2_ch4 <- ggplot(long_ch4_twr, aes(x = OBS_ENH_TWR, y = MODEL_ENH, color = CRUISE)) +
  
  geom_point() +
  facet_wrap( ~ MODEL) +
  geom_smooth(method = "lm",
              se = FALSE,
              color = "black") +
  geom_abline(slope = 1,
              intercept = 0,
              linetype = "dashed") +
  
  geom_text(
    data = stats_ch4_twr,
    aes(
      x = min(long_ch4_twr$OBS_ENH_TWR, na.rm = TRUE),
      y = max(long_ch4_twr$MODEL_ENH, na.rm = TRUE),
      label = label
    ),
    inherit.aes = FALSE,
    hjust = 0,
    vjust = 1.2,
    size = 4
  ) +
  
  theme_bw() +
  labs(x = "Observed CH4 enhancement using Tower (ppb)", y = "Modeled CH4 enhancement (ppb)", color = "Cruise")

library(cowplot)
plot_grid(p1_co2, p2_co2, ncol = 1)
plot_grid(p1_ch4, p2_ch4, ncol = 1)



#### exploring... not sure if I need it ####
ct_co2.c4 <- lew.enh.c4$ship_co2_ct
ct_co2_L5th.c4 <- ct_co2.c4[ct_co2.c4 <= quantile(ct_co2.c4, 0.05, na.rm =
                                                    T)]
ct_co2_bkgrd.c4 <- round(mean(ct_co2_L5th.c4, na.rm = T), 3)

ct_ch4.c4 <- lew.enh.c4$ship_ch4_ct
ct_ch4_L5th.c4 <- ct_ch4.c4[ct_co2.c4 <= quantile(ct_ch4.c4, 0.05, na.rm =
                                                    T)]
ct_ch4_bkgrd.c4 <- round(mean(ct_ch4_L5th.c4, na.rm = T), 3)


cams_co2.c4 <- lew.enh.c4$ship_co2_cams
cams_co2_L5th.c4 <- cams_co2.c4[cams_co2.c4 <= quantile(cams_co2.c4, 0.05, na.rm =
                                                          T)]
cams_co2_bkgrd.c4 <- round(mean(cams_co2_L5th.c4, na.rm = T), 3)

cams_ch4.c4 <- lew.enh.c4$ship_ch4_cams.y
cams_ch4_L5th.c4 <- cams_ch4.c4[cams_ch4.c4 <= quantile(cams_ch4.c4, 0.05, na.rm =
                                                          T)]
cams_ch4_bkgrd.c4 <- round(mean(cams_ch4_L5th.c4, na.rm = T), 3)

df4_alt <- data.frame(
  date = lew.enh.c4$date,
  obs_co2 = lew.enh.c4$ship_co2_obs,
  obs_ch4 = lew.enh.c4$ship_ch4_cams.x,
  
  obs_co2_enh_lew = lew.enh.c4$obs_co2_enh_via_LEW,
  obs_ch4_enh_lew = lew.enh.c4$obs_ch4_enh_via_LEW,
  
  obs_co2_enh_5th = lew.enh.c4$ship_co2_obs - background.values$co2[1],
  obs_ch4_enh_5th = lew.enh.c4$ship_ch4_cams.x - (1000 * background.values$ch4[1]),
  
  ct_co2_enh_alt = lew.enh.c4$ship_co2_ct - ct_co2_bkgrd.c4,
  ct_ch4_enh_alt = lew.enh.c4$ship_ch4_ct - ct_ch4_bkgrd.c4,
  
  cams_co2_enh_alt = lew.enh.c4$ship_co2_cams - cams_co2_bkgrd.c4,
  cams_ch4_enh_alt = lew.enh.c4$ship_ch4_cams.x - cams_ch4_bkgrd.c4
)


ct_co2.c14 <- lew.enh.c14$ship_co2_ct
ct_co2_L5th.c14 <- ct_co2.c14[ct_co2.c14 <= quantile(ct_co2.c14, 0.05, na.rm =
                                                       T)]
ct_co2_bkgrd.c14 <- round(mean(ct_co2_L5th.c14, na.rm = T), 3)

ct_ch4.c14 <- lew.enh.c14$ship_ch4_ct
ct_ch4_L5th.c14 <- ct_ch4.c14[ct_ch4.c14 <= quantile(ct_ch4.c14, 0.05, na.rm =
                                                       T)]
ct_ch4_bkgrd.c14 <- round(mean(ct_ch4_L5th.c14, na.rm = T), 3)


cams_co2.c14 <- lew.enh.c14$ship_co2_cams
cams_co2_L5th.c14 <- cams_co2.c4[cams_co2.c14 <= quantile(cams_co2.c14, 0.05, na.rm =
                                                            T)]
cams_co2_bkgrd.c14 <- round(mean(cams_co2_L5th.c14, na.rm = T), 3)

cams_ch4.c14 <- lew.enh.c14$ship_ch4_cams.y
cams_ch4_L5th.c14 <- cams_ch4.c4[cams_ch4.c14 <= quantile(cams_ch4.c14, 0.05, na.rm =
                                                            T)]
cams_ch4_bkgrd.c14 <- round(mean(cams_ch4_L5th.c14, na.rm = T), 3)

df14_alt <- data.frame(
  date = lew.enh.c14$date,
  obs_co2 = lew.enh.c14$ship_co2_obs,
  obs_ch4 = lew.enh.c14$ship_ch4_cams.x,
  
  obs_co2_enh_tmd = lew.enh.c14$obs_co2_enh_via_TMD,
  obs_ch4_enh_tmd = lew.enh.c14$obs_ch4_enh_via_TMD,
  
  obs_co2_enh_5th = lew.enh.c14$ship_co2_obs - background.values$co2[2],
  obs_ch4_enh_5th = lew.enh.c14$ship_ch4_cams.x - (1000 * background.values$ch4[2]),
  
  ct_co2_enh_alt = lew.enh.c14$ship_co2_ct - ct_co2_bkgrd.c14,
  ct_ch4_enh_alt = lew.enh.c14$ship_ch4_ct - ct_ch4_bkgrd.c14,
  
  cams_co2_enh_alt = lew.enh.c14$ship_co2_cams - cams_co2_bkgrd.c14,
  cams_ch4_enh_alt = lew.enh.c14$ship_ch4_cams.x - cams_ch4_bkgrd.c14
)


ct_co2.c24 <- lew.enh.c24$ship_co2_ct
ct_co2_L5th.c24 <- ct_co2.c4[ct_co2.c24 <= quantile(ct_co2.c24, 0.05, na.rm =
                                                      T)]
ct_co2_bkgrd.c24 <- round(mean(ct_co2_L5th.c24, na.rm = T), 3)

ct_ch4.c24 <- lew.enh.c24$ship_ch4_ct
ct_ch4_L5th.c24 <- ct_ch4.c24[ct_co2.c24 <= quantile(ct_ch4.c24, 0.05, na.rm =
                                                       T)]
ct_ch4_bkgrd.c24 <- round(mean(ct_ch4_L5th.c24, na.rm = T), 3)


cams_co2.c24 <- lew.enh.c24$ship_co2_cams
cams_co2_L5th.c24 <- cams_co2.c4[cams_co2.c24 <= quantile(cams_co2.c24, 0.05, na.rm =
                                                            T)]
cams_co2_bkgrd.c24 <- round(mean(cams_co2_L5th.c24, na.rm = T), 3)

cams_ch4.c24 <- lew.enh.c24$ship_ch4_cams.y
cams_ch4_L5th.c24 <- cams_ch4.c24[cams_ch4.c24 <= quantile(cams_ch4.c24, 0.05, na.rm =
                                                             T)]
cams_ch4_bkgrd.c24 <- round(mean(cams_ch4_L5th.c24, na.rm = T), 3)

df24_alt <- data.frame(
  date = lew.enh.c24$date,
  obs_co2 = lew.enh.c24$ship_co2_obs,
  obs_ch4 = lew.enh.c24$ship_ch4_cams.x,
  
  obs_co2_enh_lew = lew.enh.c24$obs_co2_enh_via_LEW,
  obs_ch4_enh_lew = lew.enh.c24$obs_ch4_enh_via_LEW,
  
  obs_co2_enh_5th = lew.enh.c24$ship_co2_obs - background.values$co2[3],
  obs_ch4_enh_5th = lew.enh.c24$ship_ch4_cams.x - (1000 * background.values$ch4[3]),
  
  ct_co2_enh_alt = lew.enh.c24$ship_co2_ct - ct_co2_bkgrd.c24,
  ct_ch4_enh_alt = lew.enh.c24$ship_ch4_ct - ct_ch4_bkgrd.c24,
  
  cams_co2_enh_alt = lew.enh.c24$ship_co2_cams - cams_co2_bkgrd.c24,
  cams_ch4_enh_alt = lew.enh.c24$ship_ch4_cams.x - cams_ch4_bkgrd.c24
)

df4_alt$CRUISE <- "C4"
df4_alt$SOURCE <- "LEW"

df14_alt$CRUISE <- "C14"
df14_alt$SOURCE <- "TMD"

df24_alt$CRUISE <- "C24"
df24_alt$SOURCE <- "LEW"

names(df4_alt)[names(df4_alt) == "obs_co2_enh_lew"] <- "obs_co2_enh_tower"
names(df4_alt)[names(df4_alt) == "obs_ch4_enh_lew"] <- "obs_ch4_enh_tower"

names(df14_alt)[names(df14_alt) == "obs_co2_enh_tmd"] <- "obs_co2_enh_tower"
names(df14_alt)[names(df14_alt) == "obs_ch4_enh_tmd"] <- "obs_ch4_enh_tower"

names(df24_alt)[names(df24_alt) == "obs_co2_enh_lew"] <- "obs_co2_enh_tower"
names(df24_alt)[names(df24_alt) == "obs_ch4_enh_lew"] <- "obs_ch4_enh_tower"

all_df <- rbind(df4_alt, df14_alt, df24_alt)

all_df <- all_df[!is.na(all_df$obs_co2), ]


co2_df_alt <- data.frame(
  DATE = all_df$date,
  CRUISE = all_df$CRUISE,
  SOURCE = all_df$SOURCE,
  OBS_ENH_TWR = all_df$obs_co2_enh_tower,
  OBS_ENH_5TH = all_df$obs_co2_enh_5th,
  CT_ENH_ALT_5TH = all_df$ct_co2_enh_alt,
  CAMS_ENH_ALT_5TH = all_df$cams_co2_enh_alt,
  GAS = "CO2"
)

ch4_df_alt <- data.frame(
  DATE = all_df$date,
  CRUISE = all_df$CRUISE,
  SOURCE = all_df$SOURCE,
  OBS_ENH_TWR = all_df$obs_ch4_enh_tower,
  OBS_ENH_5TH = all_df$obs_ch4_enh_5th,
  CT_ENH_ALT_5TH = all_df$ct_ch4_enh_alt,
  CAMS_ENH_ALT_5TH = all_df$cams_ch4_enh_alt,
  GAS = "CH4"
)
