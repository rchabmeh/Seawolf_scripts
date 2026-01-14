#Comparing ship to LEW!

#GOALS: OBS CRUISE - OBS LEW for cruise 4 and cruise 24
##Use another tower for cruise 14 maybe TMD or BVA
cruise_14 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_14/cruise14_info_5_min_avg_daylight.csv")
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

LEW_23_CH4_50 <- LEW_22_CH4_50[
  LEW_23_CH4_50$datetime_EDT >= start_time &
    LEW_23_CH4_50$datetime_EDT <= end_time,
]

saveRDS(LEW_23_CO2_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CO2.RData")
saveRDS(LEW_23_CH4_50, "/Users/reneechabot-mehlin/Desktop/twr_comp/cruise24/LEW_CH4.RData")

##### __________________________________________________#####
#####Load in info #####

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
half.hrly_enhancements <- data.frame(CO2_ENH_PPM = (merged_data_closest_half_hour$OBS_CO2_PPM - merged_data_closest_half_hour$LEW_CO2_PPM),
                                     CH4_ENH_PPB = (merged_data_closest_half_hour$OBS_CH4_PPB - merged_data_closest_half_hour$LEW_CH4_PPB))


