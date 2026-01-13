#Comparing ship to LEW!

#GOALS: OBS CRUISE - OBS LEW for cruise 4 and cruise 24
##Use another tower for cruise 14

cruise_4 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_4/cruise4_info_5_min_avg_daylight.csv")
cruise_14 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_14/cruise14_info_5_min_avg_daylight.csv")
cruise_24 <- read.csv("/Users/reneechabot-mehlin/Desktop/Seawulf_files/cruises_modeled_info/cruise_24/cruise24_info_5_min_avg_daylight.csv")
##### Only have to run once (already ran) #####
#"2022-04-08 14:00:00"
#"2022-04-15 20:45:00"
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

#####Load in towers #####

LEW_CO2 <- readRDS()
LEW_CH4 <- readRDS()