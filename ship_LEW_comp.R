#Comparing ship to LEW!

#GOALS: OBS CRUISE - OBS LEW for cruise 4 and cruise 24
##Use another tower for cruise 14 maybe TMD or BVA
##### Only have to run once __________________________ #####
### ----- LEW 2022 ------
## ---- CH4 ----
LEW_22_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-50m-1-hour-20230425.csv'
)
LEW_22_CH4_50$DATE <- as.Date(LEW_22_CH4_50$datetime_UTC)
LEW_22_CH4_50$HH <- sprintf("%02d:00:00", LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_combined <- paste(LEW_22_CH4_50$DATE, LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_UTC <- as.POSIXct(LEW_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CH4_50$datetime_EDT <- with_tz(LEW_22_CH4_50$datetime_UTC, tzone = "America/New_York")

## ---- CO2----
LEW_22_CO2_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-co2-50m-1-hour-20230425.csv'
)
LEW_22_CO2_50$DATE <- as.Date(LEW_22_CO2_50$datetime_UTC)
LEW_22_CO2_50$HH <- sprintf("%02d:00:00", LEW_22_CO2_50$HH)
LEW_22_CO2_50$datetime_combined <- paste(LEW_22_CO2_50$DATE, LEW_22_CO2_50$HH)
LEW_22_CO2_50$datetime_UTC <- as.POSIXct(LEW_22_CO2_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CO2_50$datetime_EDT <- with_tz(LEW_22_CO2_50$datetime_UTC, tzone = "America/New_York")

## ---- SET DATE/TIME ----
start_time <- as.POSIXct("2022-04-08 14:00:00", tz = "America/New_York")
end_time   <- as.POSIXct("2022-04-15 20:45:00", tz = "America/New_York")

LEW_22_CO2_50 <- LEW_22_CO2_50[
  LEW_22_CO2_50$datetime_EDT >= start_time &
    LEW_22_CO2_50$datetime_EDT <= end_time,
]

LEW_22_CH4_50 <- LEW_22_CH4_50[
  LEW_22_CH4_50$datetime_EDT >= start_time &
    LEW_22_CH4_50$datetime_EDT <= end_time,
]

saveRDS(LEW_22_CO2_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise4/LEW_CO2.RData")
saveRDS(LEW_22_CH4_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise4/LEW_CH4.RData")

### ----- LEW 2023 ------
## ---- CH4 ----
LEW_23_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2023-ch4-50m-1-hour-v20250319.csv'
)
LEW_23_CH4_50$DATE <- as.Date(LEW_23_CH4_50$datetime_UTC)
LEW_23_CH4_50$HH <- sprintf("%02d:00:00", LEW_23_CH4_50$HH)
LEW_23_CH4_50$datetime_combined <- paste(LEW_23_CH4_50$DATE, LEW_23_CH4_50$HH)
LEW_23_CH4_50$datetime_UTC <- as.POSIXct(LEW_23_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_23_CH4_50$datetime_EDT <- with_tz(LEW_23_CH4_50$datetime_UTC, tzone = "America/New_York")

## ---- CO2----
LEW_23_CO2_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2023-co2-50m-1-hour-v20250319.csv'
)
LEW_23_CO2_50$DATE <- as.Date(LEW_23_CO2_50$datetime_UTC)
LEW_23_CO2_50$HH <- sprintf("%02d:00:00", LEW_23_CO2_50$HH)
LEW_23_CO2_50$datetime_combined <- paste(LEW_23_CO2_50$DATE, LEW_23_CO2_50$HH)
LEW_23_CO2_50$datetime_UTC <- as.POSIXct(LEW_23_CO2_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_23_CO2_50$datetime_EDT <- with_tz(LEW_23_CO2_50$datetime_UTC, tzone = "America/New_York")

## ---- SET DATE/TIME ----
start_time <- as.POSIXct("2023-10-11 12:00:00", tz = "America/New_York")
end_time   <- as.POSIXct("2023-11-07 04:00:00", tz = "America/New_York")

LEW_23_CO2_50 <- LEW_23_CO2_50[
  LEW_23_CO2_50$datetime_EDT >= start_time &
    LEW_23_CO2_50$datetime_EDT <= end_time,
]

LEW_23_CH4_50 <- LEW_23_CH4_50[
  LEW_23_CH4_50$datetime_EDT >= start_time &
    LEW_23_CH4_50$datetime_EDT <= end_time,
]

saveRDS(LEW_23_CO2_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CO2.RData")
saveRDS(LEW_23_CH4_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CH4.RData")

### ----- TMD 2022 ------
## ---- CH4 ----
TMD_22_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-ch4-49m-1-hour-20230425.csv'
)
TMD_22_CH4_50$DATE <- as.Date(TMD_22_CH4_50$datetime_UTC)
TMD_22_CH4_50$HH <- sprintf("%02d:00:00", TMD_22_CH4_50$HH)
TMD_22_CH4_50$datetime_combined <- paste(TMD_22_CH4_50$DATE, TMD_22_CH4_50$HH)
TMD_22_CH4_50$datetime_UTC <- as.POSIXct(TMD_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_22_CH4_50$datetime_EDT <- with_tz(TMD_22_CH4_50$datetime_UTC, tzone = "America/New_York")

## ---- CO2----
TMD_22_CO2_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-co2-49m-1-hour-20230425.csv'
)
TMD_22_CO2_50$DATE <- as.Date(TMD_22_CO2_50$datetime_UTC)
TMD_22_CO2_50$HH <- sprintf("%02d:00:00", TMD_22_CO2_50$HH)
TMD_22_CO2_50$datetime_combined <- paste(TMD_22_CO2_50$DATE, TMD_22_CO2_50$HH)
TMD_22_CO2_50$datetime_UTC <- as.POSIXct(TMD_22_CO2_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_22_CO2_50$datetime_EDT <- with_tz(TMD_22_CO2_50$datetime_UTC, tzone = "America/New_York")

## ---- SET DATE/TIME ----
start_time <- as.POSIXct("2022-10-16 00:00:00", tz = "America/New_York")
end_time   <- as.POSIXct("2022-10-20 00:00:00", tz = "America/New_York")

TMD_22_CO2_50 <- TMD_22_CO2_50[
  TMD_22_CO2_50$datetime_EDT >= start_time &
    TMD_22_CO2_50$datetime_EDT <= end_time,
]

TMD_22_CH4_50 <- TMD_22_CH4_50[
  TMD_22_CH4_50$datetime_EDT >= start_time &
    TMD_22_CH4_50$datetime_EDT <= end_time,
]

saveRDS(TMD_22_CO2_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise14/TMD_CO2.RData")
saveRDS(TMD_22_CH4_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise14/TMD_CH4.RData")

##### __________________________________________________#####
#####Load in info: cruise 4 #####

cruise_4 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_4/cruise4_info_5_min_avg_daylight.csv")
LEW_CO2_c4 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise4/LEW_CO2.RData")
LEW_CH4_c4 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise4/LEW_CH4.RData")
receptors_4 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors4.RData")

# cruise_24 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_24/cruise24_info_5_min_avg_daylight.csv")
# LEW_CO2_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CO2.RData")
# LEW_CH4_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CH4.RData")
# receptors_24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")

# MY LIST OF CRUISE 4 OVER LEW:
# it is an hour off from the receptor timing so 13 -> 14, etc this is because of:
# "The model released the particles at for example 0800 (8 am) and the first 
#footprint represents the influence between 0700 and 0800 since we go back in time. 
#That corresponding footprint time in the file is 0700, the beginning of the footprint. 
#You convolve that with the flux averaged from 7 to 8." - Anna Karion, correspondence 12/10/25
#anddddd
#" But basically the particles are released at the receptor time backwards but the footprint 
#is 1 hour before that because it represents the footprint over the following hour." - Anna Karion, correspondence 12/8/25

#using footprint to ID sections that go over LEW tower
date.time.utc <- c("2022-04-10 13:00:00", # 9:00:00 EDT
               "2022-04-10 14:00:00", 
               "2022-04-10 15:00:00",
               "2022-04-11 14:00:00",
               "2022-04-11 15:00:00",
               "2022-04-11 16:00:00",
               "2022-04-11 17:00:00",
               "2022-04-11 18:00:00",
               "2022-04-11 19:00:00",
               "2022-04-11 20:00:00" # 16:00:00 EDT (added this time/date)
               )
date.time.utc <- as.POSIXct(date.time.utc, tz = "UTC")

cruise_4$Date_UTC <- as.POSIXct(cruise_4$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

cruise_4_sub <- cruise_4[
  format(cruise_4$Date_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]


LEW_CH4_c4_sub <- LEW_CH4_c4[
  format(LEW_CH4_c4$datetime_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]

LEW_CO2_c4_sub <- LEW_CO2_c4[
  format(LEW_CO2_c4$datetime_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]

LEW_conc <- data.frame( TIME_UTC = LEW_CH4_c4_sub$datetime_UTC,
                        LEW_CH4_PPB = LEW_CH4_c4_sub$ch4_ppb,
                        LEW_CO2_PPM = LEW_CO2_c4_sub$co2_ppm)
c4 <- data.frame(TIME_UTC = cruise_4_sub$Date_UTC, 
                 LAT = cruise_4_sub$Latitude_deg, 
                 LON = cruise_4_sub$Longitude_deg,
                 OBS_CO2_PPM = cruise_4_sub$Observed_CO2,
                 OBS_CH4_PPB = (1000* cruise_4_sub$Observed_CH4))
c4 <- na.omit(c4)

c4$hour_bin <- sapply(c4$TIME_UTC, function(t) {
  i <- max(which(LEW_conc$TIME_UTC <= t))
  LEW_conc$TIME_UTC[i]
})

merged_data_closest_hour <- merge(c4, LEW_conc, by.x = "hour_bin", by.y = "TIME_UTC", all.x = TRUE)

round_to_nearest_hour <- function(time) {
  mins <- as.numeric(format(time, "%M"))
  hour <- as.numeric(format(time, "%H"))
  # If minutes >= 30, add 1 hour
  hour <- ifelse(mins >= 30, hour + 1, hour)
  as.POSIXct(paste0(format(time, "%Y-%m-%d"), " ", sprintf("%02d:00:00", hour)), tz="UTC")
}
c4$rounded_hour <- round_to_nearest_hour(c4$TIME_UTC)

merged_data_closest_half_hour <- merge(c4, LEW_conc, by.x="rounded_hour", by.y="TIME_UTC", all.x=TRUE)

merged_data_closest_half_hour$rounded_hour <- NULL
merged_data_closest_half_hour$hour_bin <- NULL
merged_data_closest_hour$hour_bin <- NULL

hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_hour$OBS_CO2_PPM - merged_data_closest_hour$LEW_CO2_PPM),
                           CH4_ENH_PPB = (merged_data_closest_hour$OBS_CH4_PPB - merged_data_closest_hour$LEW_CH4_PPB))
hrly_enhancements$DATE.TIME <-merged_data_closest_hour$TIME_UTC
hrly_enhancements$LON <- merged_data_closest_hour$LON
hrly_enhancements$LAT <- merged_data_closest_hour$LAT

half.hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_half_hour$OBS_CO2_PPM - merged_data_closest_half_hour$LEW_CO2_PPM),
                                     CH4_ENH_PPB = (merged_data_closest_half_hour$OBS_CH4_PPB - merged_data_closest_half_hour$LEW_CH4_PPB))

library(ggplot2)
ggplot(data = hrly_enhancements, aes(x = DATE.TIME, y = CO2_ENH_PPM)) + 
  geom_point(colour = "blue") + 
  geom_hline(yintercept = 0, colour = "red") + 
  labs(x = "Date UTC", y = "CO2 enhancement (ppm)", title = "Cruise 4 CO2 enhancements (ppm)")
  

ggplot(data = hrly_enhancements, aes(x = DATE.TIME, y = CH4_ENH_PPB)) + 
  geom_point(colour = "darkgreen") + 
  labs(x = "Date UTC", y = "CH4 enhancement (ppb)", title = "Cruise 4 CH4 enhancements (ppb)")


hrly_enhancements <- hrly_enhancements[
  order(hrly_enhancements$DATE.TIME),
]

library(maps)
states <- map_data("state")

ne_states <- c(
  "maine", "new hampshire", "vermont",
  "massachusetts", "rhode island", "connecticut",
  "new york", "new jersey", "pennsylvania"
)

states_ne <- states[states$region %in% ne_states, ]

xlim_use <- range(hrly_enhancements$LON, na.rm = TRUE) + c(-0.05, 0.05)
ylim_use <- range(hrly_enhancements$LAT,  na.rm = TRUE) + c(-0.05, 0.05)

sites <- data.frame(
  site = c("Cape May", "Point Pleasant"),
  lat  = c(38.9316, 40.0829),
  lon  = c(-74.9108, -74.0683)
)


scale_co2 <- scale_colour_viridis_c(
  option = "D",
  direction = 1,
  limits = c(-7.33, 7.09),  # focus range
  oob = scales::squish,      # out-of-range values are squished to the ends
  name = expression(CO[2]~"(ppm)")
)

max_point <- hrly_enhancements[which.max(hrly_enhancements$CO2_ENH_PPM), ]

library(ggrepel)

p.co2 <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_path(
    data = hrly_enhancements,
    aes(x = LON, y = LAT, colour = CO2_ENH_PPM),
    linewidth = 1
  ) + 
  geom_point( data = hrly_enhancements,
              aes(x = LON, y = LAT, colour = CO2_ENH_PPM))+
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 4 Carbon Dioxide (ppm) Enhancement",
    subtitle = "4/10/22 - 4/11/22; 10:00 - 16:00 LT"
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
  ) +
  geom_text_repel(
    data = subset(hrly_enhancements, CO2_ENH_PPM > 7),
    aes(x = LON, y = LAT, label = paste(round(CO2_ENH_PPM, 2), "ppm")),
    size = 3,
    color = "red",
    max.overlaps = Inf,
    nudge_x = 0.08# ensures all labels are considered
  ) +
  geom_point(
    data = max_point,
    aes(x = LON, y = LAT),
    color = "yellow",
    size = 2
  )


####


scale_ch4 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = c(-71.11, -23.13),  # focus range
  oob = scales::squish,      # out-of-range values are squished to the ends
  name = expression(CH[4]~"(ppb)")
)

max_point <- hrly_enhancements[which.max(hrly_enhancements$CH4_ENH_PPB), ]

p.ch4 <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_path(
    data = hrly_enhancements,
    aes(x = LON, y = LAT, colour = CH4_ENH_PPB),
    linewidth = 1
  ) + 
  geom_point( data = hrly_enhancements,
              aes(x = LON, y = LAT, colour = CH4_ENH_PPB))+
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 4 Methane (ppb) Enhancement",
    subtitle = "4/10/22 - 4/11/22; 10:00 - 16:00 LT"
    
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

plot_grid(p.co2, p.ch4, ncol = 2)


 

####Load in info: cruise 24 #####

cruise_24 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_24/cruise24_info_5_min_avg_daylight.csv")
LEW_CO2_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CO2.RData")
LEW_CH4_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CH4.RData")
receptors_24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")

# cruise_24 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_24/cruise24_info_5_min_avg_daylight.csv")
# LEW_CO2_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CO2.RData")
# LEW_CH4_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CH4.RData")
# receptors_24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")

# MY LIST OF CRUISE 4 OVER LEW:
# it is an hour off from the receptor timing so 13 -> 14, etc this is because of:
# "The model released the particles at for example 0800 (8 am) and the first 
#footprint represents the influence between 0700 and 0800 since we go back in time. 
#That corresponding footprint time in the file is 0700, the beginning of the footprint. 
#You convolve that with the flux averaged from 7 to 8." - Anna Karion, correspondence 12/10/25
#anddddd
#" But basically the particles are released at the receptor time backwards but the footprint 
#is 1 hour before that because it represents the footprint over the following hour." - Anna Karion, correspondence 12/8/25

date.time.utc <- c("2023-10-15 18:00:00",
                   "2023-10-15 19:00:00",
                   "2023-10-16 13:00:00",
                   "2023-10-16 14:00:00",
                   "2023-10-16 15:00:00",
                   "2023-10-16 16:00:00",
                   "2023-10-16 17:00:00",
                   "2023-10-16 18:00:00",
                   "2023-10-16 19:00:00"
                   
)
date.time.utc <- as.POSIXct(date.time.utc, tz = "UTC")

cruise_24$Date_UTC <- as.POSIXct(cruise_24$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

cruise_24_sub <- cruise_24[
  format(cruise_24$Date_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]


LEW_CH4_c24_sub <- LEW_CH4_c24[
  format(LEW_CH4_c24$datetime_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]

LEW_CO2_c24_sub <- LEW_CO2_c24[
  format(LEW_CO2_c24$datetime_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]

LEW_conc <- data.frame( TIME_UTC = LEW_CH4_c24_sub$datetime_UTC,
                        LEW_CH4_PPB = LEW_CH4_c24_sub$ch4_ppb,
                        LEW_CO2_PPM = LEW_CO2_c24_sub$co2_ppm)
c24 <- data.frame(TIME_UTC = cruise_24_sub$Date_UTC, 
                 LAT = cruise_24_sub$Latitude_deg, 
                 LON = cruise_24_sub$Longitude_deg,
                 OBS_CO2_PPM = cruise_24_sub$Observed_CO2,
                 OBS_CH4_PPB = (1000* cruise_24_sub$Observed_CH4))
c24 <- na.omit(c24)

c24$hour_bin <- sapply(c24$TIME_UTC, function(t) {
  i <- max(which(LEW_conc$TIME_UTC <= t))
  LEW_conc$TIME_UTC[i]
})

merged_data_closest_hour <- merge(c24, LEW_conc, by.x = "hour_bin", by.y = "TIME_UTC", all.x = TRUE)

round_to_nearest_hour <- function(time) {
  mins <- as.numeric(format(time, "%M"))
  hour <- as.numeric(format(time, "%H"))
  # If minutes >= 30, add 1 hour
  hour <- ifelse(mins >= 30, hour + 1, hour)
  as.POSIXct(paste0(format(time, "%Y-%m-%d"), " ", sprintf("%02d:00:00", hour)), tz="UTC")
}
c24$rounded_hour <- round_to_nearest_hour(c24$TIME_UTC)

merged_data_closest_half_hour <- merge(c24, LEW_conc, by.x="rounded_hour", by.y="TIME_UTC", all.x=TRUE)

merged_data_closest_half_hour$rounded_hour <- NULL
merged_data_closest_half_hour$hour_bin <- NULL
merged_data_closest_hour$hour_bin <- NULL

hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_hour$OBS_CO2_PPM - merged_data_closest_hour$LEW_CO2_PPM),
                                CH4_ENH_PPB = (merged_data_closest_hour$OBS_CH4_PPB - merged_data_closest_hour$LEW_CH4_PPB))
hrly_enhancements$DATE.TIME <-merged_data_closest_hour$TIME_UTC
hrly_enhancements$LON <- merged_data_closest_hour$LON
hrly_enhancements$LAT <- merged_data_closest_hour$LAT

half.hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_half_hour$OBS_CO2_PPM - merged_data_closest_half_hour$LEW_CO2_PPM),
                                     CH4_ENH_PPB = (merged_data_closest_half_hour$OBS_CH4_PPB - merged_data_closest_half_hour$LEW_CH4_PPB))

library(ggplot2)
ggplot(data = hrly_enhancements, aes(x = DATE.TIME, y = CO2_ENH_PPM)) + 
  geom_point(colour = "blue") + 
  geom_hline(yintercept = 0, colour = "red") + 
  labs(x = "Date UTC", y = "CO2 enhancement (ppm)", title = "Cruise 24 CO2 enhancements (ppm)")


ggplot(data = hrly_enhancements, aes(x = DATE.TIME, y = CH4_ENH_PPB)) + 
  geom_point(colour = "darkgreen") + 
  labs(x = "Date UTC", y = "CH4 enhancement (ppb)", title = "Cruise 24 CH4 enhancements (ppb)")


hrly_enhancements <- hrly_enhancements[
  order(hrly_enhancements$DATE.TIME),
]

library(maps)
states <- map_data("state")

ne_states <- c(
  "maine", "new hampshire", "vermont",
  "massachusetts", "rhode island", "connecticut",
  "new york", "new jersey", "pennsylvania"
)

states_ne <- states[states$region %in% ne_states, ]

xlim_use <- range(hrly_enhancements$LON, na.rm = TRUE) + c(-0.05, 0.05)
ylim_use <- range(hrly_enhancements$LAT,  na.rm = TRUE) + c(-0.05, 0.05)

sites <- data.frame(
  site = c("Cape May", "Point Pleasant"),
  lat  = c(38.9316, 40.0829),
  lon  = c(-74.9108, -74.0683)
)


scale_co2 <- scale_colour_viridis_c(
  option = "D",
  direction = 1,
  limits = c(-5, 5),  # focus range
  oob = scales::squish,      # out-of-range values are squished to the ends
  name = expression(CO[2]~"(ppm)")
)

max_point <- hrly_enhancements[which.max(hrly_enhancements$CO2_ENH_PPM), ]

library(ggrepel)

p.co2 <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_path(
    data = hrly_enhancements,
    aes(x = LON, y = LAT, colour = CO2_ENH_PPM),
    linewidth = 1
  ) + 
  geom_point( data = hrly_enhancements,
              aes(x = LON, y = LAT, colour = CO2_ENH_PPM))+
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 24 Carbon Dioxide (ppm) Enhancement",
    subtitle = "10/15/23 - 10/16/23; 10:00 - 16:00 LT"
    
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
  ) +
  geom_text_repel(
    data = subset(hrly_enhancements, CO2_ENH_PPM > 6),
    aes(x = LON, y = LAT, label = paste(round(CO2_ENH_PPM, 2), "ppm")),
    size = 3,
    color = "red",
    max.overlaps = Inf,
    nudge_x = 0.08# ensures all labels are considered
  ) +
  geom_point(
    data = max_point,
    aes(x = LON, y = LAT),
    color = "yellow",
    size = 2
  )


####


scale_ch4 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = c(-24, 26),  # focus range
  oob = scales::squish,      # out-of-range values are squished to the ends
  name = expression(CH[4]~"(ppb)")
)

max_point <- hrly_enhancements[which.max(hrly_enhancements$CH4_ENH_PPB), ]

p.ch4 <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_path(
    data = hrly_enhancements,
    aes(x = LON, y = LAT, colour = CH4_ENH_PPB),
    linewidth = 1
  ) + 
  geom_point( data = hrly_enhancements,
              aes(x = LON, y = LAT, colour = CH4_ENH_PPB))+
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 24 Methane (ppb) Enhancement",
    subtitle = "10/15/23 - 10/16/23; 10:00 - 16:00 LT"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text_repel(
    data = subset(hrly_enhancements, CH4_ENH_PPB > 23),
    aes(x = LON, y = LAT, label = paste(round(CH4_ENH_PPB, 2), "ppb")),
    size = 3,
    color = "red",
    max.overlaps = Inf,
    nudge_x = 0.08# ensures all labels are considered
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  ) 

library(cowplot)

plot_grid(p.co2, p.ch4, ncol = 2)




####Load in info: cruise 14 EDITING 1/29/26 #####

cruise_14 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_14/cruise14_info_5_min_avg_daylight.csv")
TMD_CO2_c14 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise14/TMD_CO2.RData")
TMD_CH4_c14 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise14/TMD_CH4.RData")
receptors_14 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors14.RData")

# cruise_24 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_24/cruise24_info_5_min_avg_daylight.csv")
# LEW_CO2_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CO2.RData")
# LEW_CH4_c24 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CH4.RData")
# receptors_24 <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/RData/receptors24.RData")

# MY LIST OF CRUISE 4 OVER LEW:
# it is an hour off from the receptor timing so 13 -> 14, etc this is because of:
# "The model released the particles at for example 0800 (8 am) and the first 
#footprint represents the influence between 0700 and 0800 since we go back in time. 
#That corresponding footprint time in the file is 0700, the beginning of the footprint. 
#You convolve that with the flux averaged from 7 to 8." - Anna Karion, correspondence 12/10/25
#anddddd
#" But basically the particles are released at the receptor time backwards but the footprint 
#is 1 hour before that because it represents the footprint over the following hour." - Anna Karion, correspondence 12/8/25

date.time.utc <- c("2022-10-18 12:00:00",
                   "2022-10-18 13:00:00",
                   "2022-10-18 14:00:00",
                   "2022-10-18 15:00:00",
                   "2022-10-18 16:00:00",
                   "2022-10-18 17:00:00",
                   "2022-10-18 18:00:00",
                   "2022-10-18 19:00:00",
                   "2022-10-19 13:00:00",
                   "2022-10-19 14:00:00",
                   "2022-10-19 15:00:00"
                   
)
date.time.utc <- as.POSIXct(date.time.utc, tz = "UTC")

cruise_14$Date_UTC <- as.POSIXct(cruise_14$Date_UTC, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

cruise_14_sub <- cruise_14[
  format(cruise_14$Date_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]


TMD_CH4_c14_sub <- TMD_CH4_c14[
  format(TMD_CH4_c14$datetime_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]

TMD_CO2_c14_sub <- TMD_CO2_c14[
  format(TMD_CO2_c14$datetime_UTC, "%Y-%m-%d %H") %in%
    format(date.time.utc, "%Y-%m-%d %H"),
]

TMD_conc <- data.frame( TIME_UTC = TMD_CH4_c14_sub$datetime_UTC,
                        TMD_CH4_PPB = TMD_CH4_c14_sub$ch4_ppb,
                        TMD_CO2_PPM = TMD_CO2_c14_sub$co2_ppm)
c14 <- data.frame(TIME_UTC = cruise_14_sub$Date_UTC, 
                  LAT = cruise_14_sub$Latitude_deg, 
                  LON = cruise_14_sub$Longitude_deg,
                  OBS_CO2_PPM = cruise_14_sub$Observed_CO2,
                  OBS_CH4_PPB = (1000* cruise_14_sub$Observed_CH4))
c14 <- na.omit(c14)

c14$hour_bin <- sapply(c14$TIME_UTC, function(t) {
  i <- max(which(TMD_conc$TIME_UTC <= t))
  TMD_conc$TIME_UTC[i]
})

merged_data_closest_hour <- merge(c14, TMD_conc, by.x = "hour_bin", by.y = "TIME_UTC", all.x = TRUE)

round_to_nearest_hour <- function(time) {
  mins <- as.numeric(format(time, "%M"))
  hour <- as.numeric(format(time, "%H"))
  # If minutes >= 30, add 1 hour
  hour <- ifelse(mins >= 30, hour + 1, hour)
  as.POSIXct(paste0(format(time, "%Y-%m-%d"), " ", sprintf("%02d:00:00", hour)), tz="UTC")
}
c14$rounded_hour <- round_to_nearest_hour(c14$TIME_UTC)

merged_data_closest_half_hour <- merge(c14, TMD_conc, by.x="rounded_hour", by.y="TIME_UTC", all.x=TRUE)

merged_data_closest_half_hour$rounded_hour <- NULL
merged_data_closest_half_hour$hour_bin <- NULL
merged_data_closest_hour$hour_bin <- NULL

hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_hour$OBS_CO2_PPM - merged_data_closest_hour$TMD_CO2_PPM),
                                CH4_ENH_PPB = (merged_data_closest_hour$OBS_CH4_PPB - merged_data_closest_hour$TMD_CH4_PPB))
hrly_enhancements$DATE.TIME <-merged_data_closest_hour$TIME_UTC
hrly_enhancements$LON <- merged_data_closest_hour$LON
hrly_enhancements$LAT <- merged_data_closest_hour$LAT

half.hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_half_hour$OBS_CO2_PPM - merged_data_closest_half_hour$TMD_CO2_PPM),
                                     CH4_ENH_PPB = (merged_data_closest_half_hour$OBS_CH4_PPB - merged_data_closest_half_hour$TMD_CH4_PPB))

library(ggplot2)
ggplot(data = hrly_enhancements, aes(x = DATE.TIME, y = CO2_ENH_PPM)) + 
  geom_point(colour = "blue") + 
  geom_hline(yintercept = 0, colour = "red") + 
  labs(x = "Date UTC", y = "CO2 enhancement (ppm)", title = "Cruise 14 CO2 enhancements (ppm)")


ggplot(data = hrly_enhancements, aes(x = DATE.TIME, y = CH4_ENH_PPB)) + 
  geom_point(colour = "darkgreen") + 
  labs(x = "Date UTC", y = "CH4 enhancement (ppb)", title = "Cruise 14 CH4 enhancements (ppb)")


hrly_enhancements <- hrly_enhancements[
  order(hrly_enhancements$DATE.TIME),
]

library(maps)
states <- map_data("state")

ne_states <- c(
  "maine", "new hampshire", "vermont",
  "massachusetts", "rhode island", "connecticut",
  "new york", "new jersey", "pennsylvania"
)

states_ne <- states[states$region %in% ne_states, ]

xlim_use <- range(hrly_enhancements$LON, na.rm = TRUE) + c(-0.05, 0.05)
ylim_use <- range(hrly_enhancements$LAT,  na.rm = TRUE) + c(-0.05, 0.05)

sites <- data.frame(
  site = c("Cape May", "Point Pleasant"),
  lat  = c(38.9316, 40.0829),
  lon  = c(-74.9108, -74.0683)
)


scale_co2 <- scale_colour_viridis_c(
  option = "D",
  direction = 1,
  limits = c(-10, 7),  # focus range
  oob = scales::squish,      # out-of-range values are squished to the ends
  name = expression(CO[2]~"(ppm)")
)

max_point <- hrly_enhancements[which.max(hrly_enhancements$CO2_ENH_PPM), ]

library(ggrepel)

p.co2 <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_path(
    data = hrly_enhancements,
    aes(x = LON, y = LAT, colour = CO2_ENH_PPM),
    linewidth = 1
  ) + 
  geom_point( data = hrly_enhancements,
              aes(x = LON, y = LAT, colour = CO2_ENH_PPM))+
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 14 Carbon Dioxide (ppm) Enhancement",
    subtitle = "10/18/22 - 10/19/22; 10:00 - 16:00 LT"
    
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
  ) +
  geom_text_repel(
    data = subset(hrly_enhancements, CO2_ENH_PPM > 4),
    aes(x = LON, y = LAT, label = paste(round(CO2_ENH_PPM, 2), "ppm")),
    size = 3,
    color = "red",
    max.overlaps = Inf,
    nudge_x = 0.08# ensures all labels are considered
  ) +
  geom_point(
    data = max_point,
    aes(x = LON, y = LAT),
    color = "yellow",
    size = 2
  )


####


scale_ch4 <- scale_colour_viridis_c(
  option = "C",
  direction = 1,
  limits = c(-60, 26),  # focus range
  oob = scales::squish,      # out-of-range values are squished to the ends
  name = expression(CH[4]~"(ppb)")
)

max_point <- hrly_enhancements[which.max(hrly_enhancements$CH4_ENH_PPB), ]

p.ch4 <- ggplot() +
  geom_polygon(
    data = states_ne,
    aes(x = long, y = lat, group = group),
    fill = "grey",
    color = "gray50",
    linewidth = 0.4
  ) +
  geom_path(
    data = hrly_enhancements,
    aes(x = LON, y = LAT, colour = CH4_ENH_PPB),
    linewidth = 1
  ) + 
  geom_point( data = hrly_enhancements,
              aes(x = LON, y = LAT, colour = CH4_ENH_PPB))+
  coord_fixed(
    ratio = 1.3,
    xlim = xlim_use,
    ylim = ylim_use
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    color = expression(CO[2]),
    title = "Cruise 14 Methane (ppb) Enhancement",
    subtitle = "10/18/22 - 10/19/22; 10:00 - 16:00 LT"
  ) +
  theme_grey() + 
  scale_ch4 +
  geom_point(
    data = sites,
    aes(x = lon, y = lat),
    color = "black",
    size = 3
  ) +
  geom_text_repel(
    data = subset(hrly_enhancements, CH4_ENH_PPB > 26),
    aes(x = LON, y = LAT, label = paste(round(CH4_ENH_PPB, 2), "ppb")),
    size = 3,
    color = "red",
    max.overlaps = Inf,
    nudge_x = 0.08# ensures all labels are considered
  ) +
  geom_text(
    data = sites,
    aes(x = lon, y = lat, label = site),
    nudge_y = 0.15,
    size = 3
  ) 

library(cowplot)

plot_grid(p.co2, p.ch4, ncol = 2)



