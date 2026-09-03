#Analyzing tower data: observations and models comparison
#Updated last on August 4, 2026

#You will have to manually change items in:
# 2.3 (start_date, end_date)
# 2.4 (cruise)
##### ________________________ 1. Just Towers _____________________________#####
##### Load in the 2022 NEC tower .csv files #####
#____
# LEW_22_CH4_95 <- read.csv(
#   "/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-95m-1-hour-20230425.csv"
# )
# LEW_22_CH4_95$DATE <- as.Date(LEW_22_CH4_95$datetime_UTC)
# LEW_22_CH4_95$HH <- sprintf("%02d:00:00", LEW_22_CH4_95$HH)
# LEW_22_CH4_95$datetime_combined <- paste(LEW_22_CH4_95$DATE, LEW_22_CH4_95$HH)
# LEW_22_CH4_95$datetime_UTC <- as.POSIXct(LEW_22_CH4_95$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# LEW_22_CH4_95$datetime_EDT <- with_tz(LEW_22_CH4_95$datetime_UTC, tzone = "America/New_York")
# 

LEW_22_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-50m-1-hour-20230425.csv'
)
LEW_22_CH4_50$DATE <- as.Date(LEW_22_CH4_50$datetime_UTC)
LEW_22_CH4_50$HH <- sprintf("%02d:00:00", LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_combined <- paste(LEW_22_CH4_50$DATE, LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_UTC <- as.POSIXct(LEW_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
# library(lubridate)
# LEW_22_CH4_50$datetime_EDT <- with_tz(LEW_22_CH4_50$datetime_UTC, tzone = "America/New_York")
# 
# LEW_22_CO2_95 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-co2-95m-1-hour-20230425.csv'
# )
# LEW_22_CO2_95$DATE <- as.Date(LEW_22_CO2_95$datetime_UTC)
# LEW_22_CO2_95$HH <- sprintf("%02d:00:00", LEW_22_CO2_95$HH)
# LEW_22_CO2_95$datetime_combined <- paste(LEW_22_CO2_95$DATE, LEW_22_CO2_95$HH)
# LEW_22_CO2_95$datetime_UTC <- as.POSIXct(LEW_22_CO2_95$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# LEW_22_CO2_95$datetime_EDT <- with_tz(LEW_22_CO2_95$datetime_UTC, tzone = "America/New_York")


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

#_________
# TMD_22_CH4_113 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-ch4-113m-1-hour-20230425.csv'
# )
# TMD_22_CH4_113$DATE <- as.Date(TMD_22_CH4_113$datetime_UTC)
# TMD_22_CH4_113$HH <- sprintf("%02d:00:00", TMD_22_CH4_113$HH)
# TMD_22_CH4_113$datetime_combined <- paste(TMD_22_CH4_113$DATE, TMD_22_CH4_113$HH)
# TMD_22_CH4_113$datetime_UTC <- as.POSIXct(TMD_22_CH4_113$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# TMD_22_CH4_113$datetime_EDT <- with_tz(TMD_22_CH4_113$datetime_UTC, tzone = "America/New_York")

TMD_22_CH4_49 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-ch4-49m-1-hour-20230425.csv'
)
TMD_22_CH4_49$DATE <- as.Date(TMD_22_CH4_49$datetime_UTC)
TMD_22_CH4_49$HH <- sprintf("%02d:00:00", TMD_22_CH4_49$HH)
TMD_22_CH4_49$datetime_combined <- paste(TMD_22_CH4_49$DATE, TMD_22_CH4_49$HH)
TMD_22_CH4_49$datetime_UTC <- as.POSIXct(TMD_22_CH4_49$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_22_CH4_49$datetime_EDT <- with_tz(TMD_22_CH4_49$datetime_UTC, tzone = "America/New_York")

# TMD_22_CO2_113 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-co2-113m-1-hour-20230425.csv'
# )
# TMD_22_CO2_113$DATE <- as.Date(TMD_22_CO2_113$datetime_UTC)
# TMD_22_CO2_113$HH <- sprintf("%02d:00:00", TMD_22_CO2_113$HH)
# TMD_22_CO2_113$datetime_combined <- paste(TMD_22_CO2_113$DATE, TMD_22_CO2_113$HH)
# TMD_22_CO2_113$datetime_UTC <- as.POSIXct(TMD_22_CO2_113$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# TMD_22_CO2_113$datetime_EDT <- with_tz(TMD_22_CO2_113$datetime_UTC, tzone = "America/New_York")

TMD_22_CO2_49 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-co2-49m-1-hour-20230425.csv'
)
TMD_22_CO2_49$DATE <- as.Date(TMD_22_CO2_49$datetime_UTC)
TMD_22_CO2_49$HH <- sprintf("%02d:00:00", TMD_22_CO2_49$HH)
TMD_22_CO2_49$datetime_combined <- paste(TMD_22_CO2_49$DATE, TMD_22_CO2_49$HH)
TMD_22_CO2_49$datetime_UTC <- as.POSIXct(TMD_22_CO2_49$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_22_CO2_49$datetime_EDT <- with_tz(TMD_22_CO2_49$datetime_UTC, tzone = "America/New_York")

#_________
# BVA_22_CH4_111 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-ch4-111m-1-hour-v20250319.csv'
# )
# BVA_22_CH4_111$DATE <- as.Date(BVA_22_CH4_111$datetime_UTC)
# BVA_22_CH4_111$HH <- sprintf("%02d:00:00", BVA_22_CH4_111$HH)
# BVA_22_CH4_111$datetime_combined <- paste(BVA_22_CH4_111$DATE, BVA_22_CH4_111$HH)
# BVA_22_CH4_111$datetime_UTC <- as.POSIXct(BVA_22_CH4_111$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# BVA_22_CH4_111$datetime_EDT <- with_tz(BVA_22_CH4_111$datetime_UTC, tzone = "America/New_York")

BVA_22_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-ch4-50m-1-hour-v20250319.csv'
)
BVA_22_CH4_50$DATE <- as.Date(BVA_22_CH4_50$datetime_UTC)
BVA_22_CH4_50$HH <- sprintf("%02d:00:00", BVA_22_CH4_50$HH)
BVA_22_CH4_50$datetime_combined <- paste(BVA_22_CH4_50$DATE, BVA_22_CH4_50$HH)
BVA_22_CH4_50$datetime_UTC <- as.POSIXct(BVA_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
BVA_22_CH4_50$datetime_EDT <- with_tz(BVA_22_CH4_50$datetime_UTC, tzone = "America/New_York")

# BVA_22_CO2_111 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-co2-111m-1-hour-v20250319.csv'
# )
# BVA_22_CO2_111$DATE <- as.Date(BVA_22_CO2_111$datetime_UTC)
# BVA_22_CO2_111$HH <- sprintf("%02d:00:00", BVA_22_CO2_111$HH)
# BVA_22_CO2_111$datetime_combined <- paste(BVA_22_CO2_111$DATE, BVA_22_CO2_111$HH)
# BVA_22_CO2_111$datetime_UTC <- as.POSIXct(BVA_22_CO2_111$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# BVA_22_CO2_111$datetime_EDT <- with_tz(BVA_22_CO2_111$datetime_UTC, tzone = "America/New_York")

BVA_22_CO2_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-co2-50m-1-hour-v20250319.csv'
)
BVA_22_CO2_50$DATE <- as.Date(BVA_22_CO2_50$datetime_UTC)
BVA_22_CO2_50$HH <- sprintf("%02d:00:00", BVA_22_CO2_50$HH)
BVA_22_CO2_50$datetime_combined <- paste(BVA_22_CO2_50$DATE, BVA_22_CO2_50$HH)
BVA_22_CO2_50$datetime_UTC <- as.POSIXct(BVA_22_CO2_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
BVA_22_CO2_50$datetime_EDT <- with_tz(BVA_22_CO2_50$datetime_UTC, tzone = "America/New_York")


WNJ_22_CH4_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-ch4-43m-1-hour-v20250319.csv"
)
WNJ_22_CH4_43$DATE <- as.Date(WNJ_22_CH4_43$datetime_UTC)
WNJ_22_CH4_43$HH <- sprintf("%02d:00:00", WNJ_22_CH4_43$HH)
WNJ_22_CH4_43$datetime_combined <- paste(WNJ_22_CH4_43$DATE, WNJ_22_CH4_43$HH)
WNJ_22_CH4_43$datetime_UTC <- as.POSIXct(WNJ_22_CH4_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_22_CH4_43$datetime_EDT <- with_tz(WNJ_22_CH4_43$datetime_UTC, tzone = "America/New_York")

# WNJ_22_CH4_98 <- read.csv(
#   "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-ch4-98m-1-hour-v20250319.csv"
# )
# WNJ_22_CH4_98$DATE <- as.Date(WNJ_22_CH4_98$datetime_UTC)
# WNJ_22_CH4_98$HH <- sprintf("%02d:00:00", WNJ_22_CH4_98$HH)
# WNJ_22_CH4_98$datetime_combined <- paste(WNJ_22_CH4_98$DATE, WNJ_22_CH4_98$HH)
# WNJ_22_CH4_98$datetime_UTC <- as.POSIXct(WNJ_22_CH4_98$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# WNJ_22_CH4_98$datetime_EDT <- with_tz(WNJ_22_CH4_98$datetime_UTC, tzone = "America/New_York")

WNJ_22_CO2_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-co2-43m-1-hour-v20250319.csv"
)
WNJ_22_CO2_43$DATE <- as.Date(WNJ_22_CO2_43$datetime_UTC)
WNJ_22_CO2_43$HH <- sprintf("%02d:00:00", WNJ_22_CO2_43$HH)
WNJ_22_CO2_43$datetime_combined <- paste(WNJ_22_CO2_43$DATE, WNJ_22_CO2_43$HH)
WNJ_22_CO2_43$datetime_UTC <- as.POSIXct(WNJ_22_CO2_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_22_CO2_43$datetime_EDT <- with_tz(WNJ_22_CO2_43$datetime_UTC, tzone = "America/New_York")

# WNJ_22_CO2_98 <- read.csv(
#   "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-co2-98m-1-hour-v20250319.csv"
# )
# WNJ_22_CO2_98$DATE <- as.Date(WNJ_22_CO2_98$datetime_UTC)
# WNJ_22_CO2_98$HH <- sprintf("%02d:00:00", WNJ_22_CO2_98$HH)
# WNJ_22_CO2_98$datetime_combined <- paste(WNJ_22_CO2_98$DATE, WNJ_22_CO2_98$HH)
# WNJ_22_CO2_98$datetime_UTC <- as.POSIXct(WNJ_22_CO2_98$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# WNJ_22_CO2_98$datetime_EDT <- with_tz(WNJ_22_CO2_98$datetime_UTC, tzone = "America/New_York")

##### Load in the 2023 NEC tower .csv files #####
# LEW_23_CH4_95 <- read.csv(
#   "/Users/reneechabot-mehlin/Desktop/towers/LEW-2023-ch4-95m-1-hour-v20250319.csv"
# )
# LEW_23_CH4_95$DATE <- as.Date(LEW_23_CH4_95$datetime_UTC)
# LEW_23_CH4_95$HH <- sprintf("%02d:00:00", LEW_23_CH4_95$HH)
# LEW_23_CH4_95$datetime_combined <- paste(LEW_23_CH4_95$DATE, LEW_23_CH4_95$HH)
# LEW_23_CH4_95$datetime_UTC <- as.POSIXct(LEW_23_CH4_95$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# LEW_23_CH4_95$datetime_EDT <- with_tz(LEW_23_CH4_95$datetime_UTC, tzone = "America/New_York")

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

# LEW_23_CO2_95 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/LEW-2023-co2-95m-1-hour-v20250319.csv'
# )
# LEW_23_CO2_95$DATE <- as.Date(LEW_23_CO2_95$datetime_UTC)
# LEW_23_CO2_95$HH <- sprintf("%02d:00:00", LEW_23_CO2_95$HH)
# LEW_23_CO2_95$datetime_combined <- paste(LEW_23_CO2_95$DATE, LEW_23_CO2_95$HH)
# LEW_23_CO2_95$datetime_UTC <- as.POSIXct(LEW_23_CO2_95$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# LEW_23_CO2_95$datetime_EDT <- with_tz(LEW_23_CO2_95$datetime_UTC, tzone = "America/New_York")

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

#_________
# TMD_23_CH4_113 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/TMD-2023-ch4-113m-1-hour-v20250319.csv'
# )
# TMD_23_CH4_113$DATE <- as.Date(TMD_23_CH4_113$datetime_UTC)
# TMD_23_CH4_113$HH <- sprintf("%02d:00:00", TMD_23_CH4_113$HH)
# TMD_23_CH4_113$datetime_combined <- paste(TMD_23_CH4_113$DATE, TMD_23_CH4_113$HH)
# TMD_23_CH4_113$datetime_UTC <- as.POSIXct(TMD_23_CH4_113$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# TMD_23_CH4_113$datetime_EDT <- with_tz(TMD_23_CH4_113$datetime_UTC, tzone = "America/New_York")

TMD_23_CH4_49 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2023-ch4-49m-1-hour-v20250319.csv'
)
TMD_23_CH4_49$DATE <- as.Date(TMD_23_CH4_49$datetime_UTC)
TMD_23_CH4_49$HH <- sprintf("%02d:00:00", TMD_23_CH4_49$HH)
TMD_23_CH4_49$datetime_combined <- paste(TMD_23_CH4_49$DATE, TMD_23_CH4_49$HH)
TMD_23_CH4_49$datetime_UTC <- as.POSIXct(TMD_23_CH4_49$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_23_CH4_49$datetime_EDT <- with_tz(TMD_23_CH4_49$datetime_UTC, tzone = "America/New_York")

# TMD_23_CO2_113 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/TMD-2023-co2-113m-1-hour-v20250319.csv'
# )
# TMD_23_CO2_113$DATE <- as.Date(TMD_23_CO2_113$datetime_UTC)
# TMD_23_CO2_113$HH <- sprintf("%02d:00:00", TMD_23_CO2_113$HH)
# TMD_23_CO2_113$datetime_combined <- paste(TMD_23_CO2_113$DATE, TMD_23_CO2_113$HH)
# TMD_23_CO2_113$datetime_UTC <- as.POSIXct(TMD_23_CO2_113$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# TMD_23_CO2_113$datetime_EDT <- with_tz(TMD_23_CO2_113$datetime_UTC, tzone = "America/New_York")

TMD_23_CO2_49 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2023-co2-49m-1-hour-v20250319.csv'
)
TMD_23_CO2_49$DATE <- as.Date(TMD_23_CO2_49$datetime_UTC)
TMD_23_CO2_49$HH <- sprintf("%02d:00:00", TMD_23_CO2_49$HH)
TMD_23_CO2_49$datetime_combined <- paste(TMD_23_CO2_49$DATE, TMD_23_CO2_49$HH)
TMD_23_CO2_49$datetime_UTC <- as.POSIXct(TMD_23_CO2_49$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_23_CO2_49$datetime_EDT <- with_tz(TMD_23_CO2_49$datetime_UTC, tzone = "America/New_York")

#_________
# BVA_23_CH4_111 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/BVA-2023-ch4-111m-1-hour-v20250319.csv'
# )
# BVA_23_CH4_111$DATE <- as.Date(BVA_23_CH4_111$datetime_UTC)
# BVA_23_CH4_111$HH <- sprintf("%02d:00:00", BVA_23_CH4_111$HH)
# BVA_23_CH4_111$datetime_combined <- paste(BVA_23_CH4_111$DATE, BVA_23_CH4_111$HH)
# BVA_23_CH4_111$datetime_UTC <- as.POSIXct(BVA_23_CH4_111$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# BVA_23_CH4_111$datetime_EDT <- with_tz(BVA_23_CH4_111$datetime_UTC, tzone = "America/New_York")

BVA_23_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2023-ch4-50m-1-hour-v20250319.csv'
)
BVA_23_CH4_50$DATE <- as.Date(BVA_23_CH4_50$datetime_UTC)
BVA_23_CH4_50$HH <- sprintf("%02d:00:00", BVA_23_CH4_50$HH)
BVA_23_CH4_50$datetime_combined <- paste(BVA_23_CH4_50$DATE, BVA_23_CH4_50$HH)
BVA_23_CH4_50$datetime_UTC <- as.POSIXct(BVA_23_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
BVA_23_CH4_50$datetime_EDT <- with_tz(BVA_23_CH4_50$datetime_UTC, tzone = "America/New_York")

# BVA_23_CO2_111 <- read.csv(
#   '/Users/reneechabot-mehlin/Desktop/towers/BVA-2023-co2-111m-1-hour-v20250319.csv'
# )
# BVA_23_CO2_111$DATE <- as.Date(BVA_23_CO2_111$datetime_UTC)
# BVA_23_CO2_111$HH <- sprintf("%02d:00:00", BVA_23_CO2_111$HH)
# BVA_23_CO2_111$datetime_combined <- paste(BVA_23_CO2_111$DATE, BVA_23_CO2_111$HH)
# BVA_23_CO2_111$datetime_UTC <- as.POSIXct(BVA_23_CO2_111$datetime_combined,
#                                           format = "%Y-%m-%d %H:%M:%S",
#                                           tz = "UTC")
# library(lubridate)
# BVA_23_CO2_111$datetime_EDT <- with_tz(BVA_23_CO2_111$datetime_UTC, tzone = "America/New_York")

BVA_23_CO2_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2023-co2-50m-1-hour-v20250319.csv'
)
BVA_23_CO2_50$DATE <- as.Date(BVA_23_CO2_50$datetime_UTC)
BVA_23_CO2_50$HH <- sprintf("%02d:00:00", BVA_23_CO2_50$HH)
BVA_23_CO2_50$datetime_combined <- paste(BVA_23_CO2_50$DATE, BVA_23_CO2_50$HH)
BVA_23_CO2_50$datetime_UTC <- as.POSIXct(BVA_23_CO2_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
BVA_23_CO2_50$datetime_EDT <- with_tz(BVA_23_CO2_50$datetime_UTC, tzone = "America/New_York")

#
WNJ_23_CH4_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-ch4-43m-1-hour-v20250319.csv"
)
WNJ_23_CH4_43$DATE <- as.Date(WNJ_23_CH4_43$datetime_UTC)
WNJ_23_CH4_43$HH <- sprintf("%02d:00:00", WNJ_23_CH4_43$HH)
WNJ_23_CH4_43$datetime_combined <- paste(WNJ_23_CH4_43$DATE, WNJ_23_CH4_43$HH)
WNJ_23_CH4_43$datetime_UTC <- as.POSIXct(WNJ_23_CH4_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_23_CH4_43$datetime_EDT <- with_tz(WNJ_23_CH4_43$datetime_UTC, tzone = "America/New_York")

#
# WNJ_23_CH4_98 <- read.csv(
#   "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-ch4-98m-1-hour-v20250319.csv"
# )
# WNJ_23_CH4_98$DATE <- as.Date(WNJ_23_CH4_98$datetime_UTC)
# WNJ_23_CH4_98$HH <- sprintf("%02d:00:00", WNJ_23_CH4_98$HH)
# WNJ_23_CH4_98$datetime_combined <- paste(WNJ_23_CH4_98$DATE, WNJ_23_CH4_98$HH)
# WNJ_23_CH4_98$datetime_UTC <- as.POSIXct(WNJ_23_CH4_98$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# WNJ_23_CH4_98$datetime_EDT <- with_tz(WNJ_23_CH4_98$datetime_UTC, tzone = "America/New_York")

#
WNJ_23_CO2_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-co2-43m-1-hour-v20250319.csv"
)
WNJ_23_CO2_43$DATE <- as.Date(WNJ_23_CO2_43$datetime_UTC)
WNJ_23_CO2_43$HH <- sprintf("%02d:00:00", WNJ_23_CO2_43$HH)
WNJ_23_CO2_43$datetime_combined <- paste(WNJ_23_CO2_43$DATE, WNJ_23_CO2_43$HH)
WNJ_23_CO2_43$datetime_UTC <- as.POSIXct(WNJ_23_CO2_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_23_CO2_43$datetime_EDT <- with_tz(WNJ_23_CO2_43$datetime_UTC, tzone = "America/New_York")

#
# WNJ_23_CO2_98 <- read.csv(
#   "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-co2-98m-1-hour-v20250319.csv"
# )
# WNJ_23_CO2_98$DATE <- as.Date(WNJ_23_CO2_98$datetime_UTC)
# WNJ_23_CO2_98$HH <- sprintf("%02d:00:00", WNJ_23_CO2_98$HH)
# WNJ_23_CO2_98$datetime_combined <- paste(WNJ_23_CO2_98$DATE, WNJ_23_CO2_98$HH)
# WNJ_23_CO2_98$datetime_UTC <- as.POSIXct(WNJ_23_CO2_98$datetime_combined,
#                                          format = "%Y-%m-%d %H:%M:%S",
#                                          tz = "UTC")
# library(lubridate)
# WNJ_23_CO2_98$datetime_EDT <- with_tz(WNJ_23_CO2_98$datetime_UTC, tzone = "America/New_York")
# 

##### ___________________ 2. Averaging Times + Time Limits ________________#####
##### Averaging data for 3 hour intervals 2022 #####
#3 hr avg__
all_data <- list(
  LEW_22_CH4_50 = LEW_22_CH4_50,
  #LEW_22_CH4_95 = LEW_22_CH4_95,
  LEW_22_CO2_50 = LEW_22_CO2_50,
  #LEW_22_CO2_95 = LEW_22_CO2_95,
 # TMD_22_CH4_113 = TMD_22_CH4_113,
  TMD_22_CH4_49 = TMD_22_CH4_49,
  #TMD_22_CO2_113 = TMD_22_CO2_113,
  TMD_22_CO2_49 = TMD_22_CO2_49,
 # BVA_22_CH4_111 = BVA_22_CH4_111,
  BVA_22_CH4_50 = BVA_22_CH4_50,
  #BVA_22_CO2_111 = BVA_22_CO2_111,
  BVA_22_CO2_50 = BVA_22_CO2_50,
 # WNJ_22_CO2_98 = WNJ_22_CO2_98,
  WNJ_22_CO2_43 = WNJ_22_CO2_43,
 # WNJ_22_CH4_98 = WNJ_22_CH4_98,
  WNJ_22_CH4_43 = WNJ_22_CH4_43
)
interval_labels <- c(
  "00:00–03:00 UTC",
  "03:00–06:00 UTC",
  "06:00–09:00 UTC",
  "09:00–12:00 UTC",
  "12:00–15:00 UTC",
  "15:00–18:00 UTC",
  "18:00–21:00 UTC",
  "21:00–00:00 UTC"
)
averaged_data <- list()

for (name in names(all_data)) {
  df <- all_data[[name]]
  df$hour <- as.numeric(format(df$datetime_UTC, "%H"))
  df$date <- as.Date(df$datetime_UTC)
  df$group <- findInterval(df$hour,
                           vec = c(0, 3, 6, 9, 12, 15, 18, 21, 24),
                           rightmost.closed = TRUE)
  if ("ch4_ppb" %in% names(df)) {
    target_col <- "ch4_ppb"
  } else if ("co2_ppm" %in% names(df)) {
    target_col <- "co2_ppm"
  } else {
    warning(paste("No target column found in", name))
    next
  }
  agg_formula <- as.formula(paste(target_col, "~ date + group"))
  avg_df <- aggregate(agg_formula, data = df, FUN = mean)
  avg_df$interval <- interval_labels[avg_df$group]
  
  averaged_data[[name]] <- avg_df
}

TOWER_LOCATIONS <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")

prefixes <- c("TMD", "LEW", "BVA", "WNJ")
site_prefixes <- substr(as.character(TOWER_LOCATIONS$SiteCode), 1, 3)
matched_rows <- TOWER_LOCATIONS[site_prefixes %in% prefixes, ]

for (i in names(averaged_data)) {
  sitecode <- substr(i, 1, 3)
  tower_row <- matched_rows[matched_rows$SiteCode == sitecode, c("Lat", "Lon") , drop = FALSE]
  if (nrow(tower_row) == 1) {
    meta_df <- cbind(averaged_data[[i]], tower_row[rep(1, nrow(averaged_data[[i]])), ])
    averaged_data[[i]] <- meta_df
  }
}
##### Averaging data for 3 hour intervals 2023 #####
all_data <- list(
  LEW_23_CH4_50 = LEW_23_CH4_50,
  #LEW_23_CH4_95 = LEW_23_CH4_95,
  LEW_23_CO2_50 = LEW_23_CO2_50,
  #LEW_23_CO2_95 = LEW_23_CO2_95,
  #TMD_23_CH4_113 = TMD_23_CH4_113,
  TMD_23_CH4_49 = TMD_23_CH4_49,
  #TMD_23_CO2_113 = TMD_23_CO2_113,
  TMD_23_CO2_49 = TMD_23_CO2_49,
 #BVA_23_CH4_111 = BVA_23_CH4_111,
  BVA_23_CH4_50 = BVA_23_CH4_50,
  #BVA_23_CO2_111 = BVA_23_CO2_111,
  BVA_23_CO2_50 = BVA_23_CO2_50,
 # WNJ_23_CO2_98 = WNJ_23_CO2_98,
  WNJ_23_CO2_43 = WNJ_23_CO2_43,
  #WNJ_23_CH4_98 = WNJ_23_CH4_98,
  WNJ_23_CH4_43 = WNJ_23_CH4_43
)

interval_labels <- c(
  "00:00–03:00 UTC",
  "03:00–06:00 UTC",
  "06:00–09:00 UTC",
  "09:00–12:00 UTC",
  "12:00–15:00 UTC",
  "15:00–18:00 UTC",
  "18:00–21:00 UTC",
  "21:00–00:00 UTC"
)

averaged_data <- list()

for (name in names(all_data)) {
  df <- all_data[[name]]
  df$hour <- as.numeric(format(df$datetime_UTC, "%H"))
  df$date <- as.Date(df$datetime_UTC)
  df$group <- findInterval(df$hour,
                           vec = c(0, 3, 6, 9, 12, 15, 18, 21, 24),
                           rightmost.closed = TRUE)
  if ("ch4_ppb" %in% names(df)) {
    target_col <- "ch4_ppb"
  } else if ("co2_ppm" %in% names(df)) {
    target_col <- "co2_ppm"
  } else {
    warning(paste("No target column found in", name))
    next
  }
  agg_formula <- as.formula(paste(target_col, "~ date + group"))
  avg_df <- aggregate(agg_formula, data = df, FUN = mean)
  avg_df$interval <- interval_labels[avg_df$group]
  
  averaged_data[[name]] <- avg_df
}

TOWER_LOCATIONS <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")

prefixes <- c("TMD", "LEW", "BVA", "WNJ")
site_prefixes <- substr(as.character(TOWER_LOCATIONS$SiteCode), 1, 3)
matched_rows <- TOWER_LOCATIONS[site_prefixes %in% prefixes, ]

for (i in names(averaged_data)) {
  sitecode <- substr(i, 1, 3)
  tower_row <- matched_rows[matched_rows$SiteCode == sitecode, c("Lat", "Lon") , drop = FALSE]
  if (nrow(tower_row) == 1) {
    meta_df <- cbind(averaged_data[[i]], tower_row[rep(1, nrow(averaged_data[[i]])), ])
    averaged_data[[i]] <- meta_df
  }
}

##### ALWAYS RUN: Set time limit for model comparison #####
cruise <- "Cruise 14"
cruise_squish <- tolower(gsub(" ", "_", cruise))

start_date <- as.Date("2022-10-06")
end_date <- as.Date("2022-11-8")

# Filter averaged_data to time period of interest
datetime_filtered_data <- lapply(averaged_data, function(df) {
  df$date <- as.Date(df$date)
  df[df$date >= start_date & df$date <= end_date, ]
})

library(dplyr)
big_df <- bind_rows(datetime_filtered_data, .id = "source")
names(big_df)[names(big_df) == "source"] <- "SiteCode"

big_df$SiteCode <- substr(big_df$SiteCode, 1, 3)

obs_co2 <- big_df[!is.na(big_df$co2_ppm), ]
obs_co2$ch4_ppb <- NULL

obs_ch4 <- big_df[!is.na(big_df$ch4_ppb), ]
obs_ch4$co2_ppm <- NULL

interval_start <- sub("–.*", "", obs_co2$interval)

obs_co2$datetime_utc <- as.POSIXct(
  paste(obs_co2$date, interval_start),
  tz = "UTC"
)

interval_start <- sub("–.*", "", obs_ch4$interval)

obs_ch4$datetime_utc <- as.POSIXct(
  paste(obs_ch4$date, interval_start),
  tz = "UTC"
  
) 

##### ___________________ 3. Adding Models ________________________________#####
##### Carbon Tracker #####

# obs_co2
# obs_ch4

library(raster)
#edit for laptop usage
# co2_files <- list.files(
#   paste0(
#     "/Users/reneechabot-mehlin/Desktop/towers/models/",
#     cruise_squish,
#     "/carbon_tracker_co2_total"
#   ),
#   pattern = '\\.nc$',
#   full.names =  TRUE
# )

co2_files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_nrt_co2"
  ),
  pattern = '*.nc',
  full.names = TRUE
)

CT_CO2 <- lapply(co2_files, function(f) {
  brick(
    f,
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #lowest height
  )
})


#edit for laptop usage
# ch4_files <- list.files(
#   paste0(
#     "/Users/reneechabot-mehlin/Desktop/towers/models/",
#     cruise_squish,
#     "/carbon_tracker_ch4_total"
#   ),
#   pattern = '\\.nc$',
#   full.names =  TRUE
# )

ch4_files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_ch4_ct"
  ),
  pattern = '*.nc',
  full.names = TRUE
)

CT_CH4 <- lapply(ch4_files, function(f) {
  brick(
    f,
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #lowest height
  )
})


CT_CO2_cropped <- list()
for (i in seq_along(CT_CO2)) {
  ras_date <- as.Date(floor(as.numeric((getZ(
    CT_CO2[[i]]
  )[1]))))
  if (ras_date >= start_date && ras_date <= end_date) {
    CT_CO2_cropped[[i]] <- CT_CO2[[i]]
  }
  
}

CT_CO2_cropped <- CT_CO2_cropped[!sapply(CT_CO2_cropped, is.null)]

CT_CH4_cropped <- list()
for (i in seq_along(CT_CH4)) {
  ras_date <- as.Date(getZ(CT_CH4[[i]])[1]) #starts at 03:00 and ends the next day at 00:00
  if (ras_date >= start_date &&
      ras_date <= end_date) {
    #this is why it is mismatched later on and can't be fixed
    CT_CH4_cropped[[i]] <- CT_CH4[[i]] #but why CT_CO2 can and has been fixed
  }
  
}

CT_CH4_cropped <- CT_CH4_cropped[!sapply(CT_CH4_cropped, is.null)]

CTCO2_lists <- lapply(1:8, function(k)
  lapply(CT_CO2_cropped, function(x)
    x[[k]]))
CTCH4_lists <- lapply(1:8, function(k)
  lapply(CT_CH4_cropped, function(x)
    x[[k]]))

library(raster)
CTCO2_lists <- unlist(CTCO2_lists, recursive = FALSE)
coords <- unique(obs_co2[, c("Lon", "Lat")])
all_results <- list()


for (i in seq_along(CTCO2_lists)) {
  r_brick <- CTCO2_lists[[i]]
  
  dates <- getZ(r_brick)
  
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  

  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  hours <- as.numeric(format(dates_posix, "%H"))
  rounded_hours <- floor(hours / 3) * 3 #choosing floor instead of ceiling so 01:30 -> 00:00
  dates_posix_aligned <- as.POSIXct(paste0(
    format(dates_posix, "%Y-%m-%d "),
    sprintf("%02d:00:00", rounded_hours)
  ), tz = "UTC")
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  
  df <- data.frame(
    datetime_utc = rep(as.POSIXct(dates_posix_aligned), each = nrow(coords)),
    Lon  = rep(coords$Lon, times = nlayers(r_brick)),
    Lat  = rep(coords$Lat, times = nlayers(r_brick)),
    CT.NRT_co2  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CO2_df <- do.call(rbind, all_results)
CT_CO2_df <- merge(CT_CO2_df,
                   unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
                   by = c("Lon", "Lat"),
                   all.x = TRUE)

library(raster)

CTCH4_lists <- unlist(CTCH4_lists, recursive = FALSE)
coords <- unique(obs_ch4[, c("Lon", "Lat")])
all_results <- list()

for (i in seq_along(CTCH4_lists)) {
  r_brick <- CTCH4_lists[[i]]
  
  dates <- getZ(r_brick)
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  
  df <- data.frame(
    datetime_utc = rep(as.POSIXct(dates_posix), each = nrow(coords)),
    Lon  = rep(coords$Lon, times = nlayers(r_brick)),
    Lat  = rep(coords$Lat, times = nlayers(r_brick)),
    CT_ch4  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CH4_df <- do.call(rbind, all_results)
CT_CH4_df <- merge(CT_CH4_df,
                   unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
                   by = c("Lon", "Lat"),
                   all.x = TRUE)

obs_co2 <- merge(obs_co2, CT_CO2_df, by = c("datetime_utc","Lon", "Lat","SiteCode"))
obs_ch4 <- merge(obs_ch4, CT_CH4_df, by = c("datetime_utc","Lon", "Lat","SiteCode"))

#### CAMS information #####

library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)

CAMS <- list(CH4 = list(), CO2 = list())
files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_cams"
  ),
  pattern = '\\.nc$',
  full.names = TRUE
)

level_co2 <- 1   
level_ch4 <- 1   # 378.3 m (lowest)

for (f in files) {
  
  cat("Processing:", basename(f), "\n")
  
  nc <- nc_open(f)
  var_names <- names(nc$var)
  
  if ("CH4" %in% var_names) {
    var_to_use <- "CH4"
    lvl <- level_ch4
    
  } else if ("CO2" %in% var_names) {
    var_to_use <- "CO2"
    lvl <- level_co2
    
  } else {
    nc_close(nc)
    next
  }
  
  nc_close(nc)
  
  CAMS[[var_to_use]][[length(CAMS[[var_to_use]]) + 1]] <- brick(
    f,
    varname = var_to_use,
    level = lvl
  )
}

get_timestamps <- function(nc_file) {
  
  nc <- nc_open(nc_file)
  on.exit(nc_close(nc), add = TRUE)
  
  if (!("time" %in% names(nc$dim))) {
    warning(paste("No time dimension in:", nc_file))
    return(NULL)
  }
  
  time_vals  <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  
  origin <- sub("hours since ", "", time_units)
  
  as.POSIXct(
    time_vals * 3600,
    origin = origin,
    tz = "UTC"
  )
}

all_timestamps <- lapply(files, get_timestamps)
names(all_timestamps) <- basename(files)

# optional: save matched layer info
closest_times <- data.frame()

time_tolerance_secs <- 0

# CO2 loop — only process CO2 files
for (j in seq_len(nrow(obs_co2))) {
  target_time <- obs_co2$datetime_utc[j]
  lon <- obs_co2$Lon[j]
  lat <- obs_co2$Lat[j]
  coords <- matrix(c(lon, lat), ncol = 2)
  
  for (i in seq_along(files)) {
    # Skip non-CO2 files entirely
    if (!grepl("CO2", basename(files[i]), ignore.case = TRUE)) next
    
    timestamps <- all_timestamps[[i]]
    if (is.null(timestamps)) next
    
    file_start <- min(timestamps)
    file_end   <- max(timestamps)
    if (target_time < (file_start - time_tolerance_secs) |
        target_time > (file_end   + time_tolerance_secs)) next
    
    layer_number <- which.min(abs(difftime(timestamps, target_time, units = "secs")))
    matched_time <- timestamps[layer_number]
    
    brick_index <- sum(sapply(files[1:i], function(x)
      grepl("CO2", basename(x), ignore.case = TRUE)))
    
    r_layer <- CAMS[["CO2"]][[brick_index]][[layer_number]]
    model_value <- raster::extract(r_layer, coords)
    
    obs_co2$CAMS_CO2[j] <- model_value * 1e6
    
    closest_times <- rbind(closest_times, data.frame(
      cruise_row  = j,
      file        = basename(files[i]),
      variable    = "CO2",
      cruise_time = target_time,
      matched_time = matched_time,
      layer_num   = layer_number
    ))
  }
}

# CH4 loop — only process CH4 files
for (j in seq_len(nrow(obs_ch4))) {
  target_time <- obs_ch4$datetime_utc[j]
  lon <- obs_ch4$Lon[j]
  lat <- obs_ch4$Lat[j]
  coords <- matrix(c(lon, lat), ncol = 2)
  
  for (i in seq_along(files)) {
    # Skip non-CH4 files entirely
    if (!grepl("CH4", basename(files[i]), ignore.case = TRUE)) next
    
    timestamps <- all_timestamps[[i]]
    if (is.null(timestamps)) next
   
     file_start <- min(timestamps)
    file_end   <- max(timestamps)
    if (target_time < (file_start - time_tolerance_secs) |
        target_time > (file_end   + time_tolerance_secs)) next
    
    layer_number <- which.min(abs(difftime(timestamps, target_time, units = "secs")))
    matched_time <- timestamps[layer_number]
    
    brick_index <- sum(sapply(files[1:i], function(x)
      grepl("CH4", basename(x), ignore.case = TRUE)))
    
    r_layer <- CAMS[["CH4"]][[brick_index]][[layer_number]]
    model_value <- raster::extract(r_layer, coords)
    
    obs_ch4$CAMS_CH4[j] <- model_value  # CH4 already in correct units
    
    closest_times <- rbind(closest_times, data.frame(
      cruise_row  = j,
      file        = basename(files[i]),
      variable    = "CH4",
      cruise_time = target_time,
      matched_time = matched_time,
      layer_num   = layer_number
    ))
  }
}

obs_co2$date = NULL
obs_ch4$date = NULL

obs_co2$group = NULL
obs_ch4$group = NULL

obs_co2$interval = NULL
obs_ch4$interval = NULL


#### ___________________ 4. Saving .csv files ______________________________####
output_dir <- paste0("/Users/reneechabot-mehlin/Desktop/model_plotting/", cruise_squish, "/towers")

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

for (abriv in unique(obs_co2$SiteCode)) {
  write.csv(
    obs_co2[obs_co2$SiteCode == abriv, ],
      paste0(
      output_dir, "/merged_co2_",
      cruise_squish, "_", abriv, ".csv"
    ),
    row.names = FALSE
  )
}

for (abriv in unique(obs_ch4$SiteCode)) {
  write.csv(
    obs_ch4[obs_ch4$SiteCode == abriv, ],
    paste0(
      output_dir, "/merged_ch4_",
      cruise_squish, "_", abriv, ".csv"
    ),
    row.names = FALSE
  )
}

####_____________________Extras: NOT SURE IF I SHOULD REMOVE ______________#####
#####_______________________ 3. WNJ v LEW Comparison 2022 _________________#####
##### Load in the 2022 NEC tower .csv files #####


LEW_22_CH4_50 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-50m-1-hour-20230425.csv'
)
LEW_22_CH4_50$DATE <- as.Date(LEW_22_CH4_50$datetime_UTC)
LEW_22_CH4_50$HH <- sprintf("%02d:00:00", LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_combined <- paste(LEW_22_CH4_50$DATE, LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_UTC <- as.POSIXct(LEW_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")

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


WNJ_22_CH4_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-ch4-43m-1-hour-v20250319.csv"
)
WNJ_22_CH4_43$DATE <- as.Date(WNJ_22_CH4_43$datetime_UTC)
WNJ_22_CH4_43$HH <- sprintf("%02d:00:00", WNJ_22_CH4_43$HH)
WNJ_22_CH4_43$datetime_combined <- paste(WNJ_22_CH4_43$DATE, WNJ_22_CH4_43$HH)
WNJ_22_CH4_43$datetime_UTC <- as.POSIXct(WNJ_22_CH4_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_22_CH4_43$datetime_EDT <- with_tz(WNJ_22_CH4_43$datetime_UTC, tzone = "America/New_York")

WNJ_22_CO2_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-co2-43m-1-hour-v20250319.csv"
)
WNJ_22_CO2_43$DATE <- as.Date(WNJ_22_CO2_43$datetime_UTC)
WNJ_22_CO2_43$HH <- sprintf("%02d:00:00", WNJ_22_CO2_43$HH)
WNJ_22_CO2_43$datetime_combined <- paste(WNJ_22_CO2_43$DATE, WNJ_22_CO2_43$HH)
WNJ_22_CO2_43$datetime_UTC <- as.POSIXct(WNJ_22_CO2_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_22_CO2_43$datetime_EDT <- with_tz(WNJ_22_CO2_43$datetime_UTC, tzone = "America/New_York")


##### Averaging data for 3 hour intervals 2022 #####
#3 hr avg__
all_data <- list(
  LEW_22_CH4_50 = LEW_22_CH4_50,
  LEW_22_CO2_50 = LEW_22_CO2_50,
  WNJ_22_CO2_43 = WNJ_22_CO2_43,
  WNJ_22_CH4_43 = WNJ_22_CH4_43
)
interval_labels <- c(
  "00:00–03:00 UTC",
  "03:00–06:00 UTC",
  "06:00–09:00 UTC",
  "09:00–12:00 UTC",
  "12:00–15:00 UTC",
  "15:00–18:00 UTC",
  "18:00–21:00 UTC",
  "21:00–00:00 UTC"
)
averaged_data <- list()

for (name in names(all_data)) {
  df <- all_data[[name]]
  df$hour <- as.numeric(format(df$datetime_UTC, "%H"))
  df$date <- as.Date(df$datetime_UTC)
  df$group <- findInterval(df$hour,
                           vec = c(0, 3, 6, 9, 12, 15, 18, 21, 24),
                           rightmost.closed = TRUE)
  if ("ch4_ppb" %in% names(df)) {
    target_col <- "ch4_ppb"
  } else if ("co2_ppm" %in% names(df)) {
    target_col <- "co2_ppm"
  } else {
    warning(paste("No target column found in", name))
    next
  }
  agg_formula <- as.formula(paste(target_col, "~ date + group"))
  avg_df <- aggregate(agg_formula, data = df, FUN = mean)
  avg_df$interval <- interval_labels[avg_df$group]
  
  averaged_data[[name]] <- avg_df
}

TOWER_LOCATIONS <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")

prefixes <- c("TMD", "LEW", "BVA", "WNJ")
site_prefixes <- substr(as.character(TOWER_LOCATIONS$SiteCode), 1, 3)
matched_rows <- TOWER_LOCATIONS[site_prefixes %in% prefixes, ]

for (i in names(averaged_data)) {
  sitecode <- substr(i, 1, 3)
  tower_row <- matched_rows[matched_rows$SiteCode == sitecode, c("Lat", "Lon") , drop = FALSE]
  if (nrow(tower_row) == 1) {
    meta_df <- cbind(averaged_data[[i]], tower_row[rep(1, nrow(averaged_data[[i]])), ])
    averaged_data[[i]] <- meta_df
  }
}


##### Set time limit for model comparison #####
start_date <- as.Date("2022-01-01")
end_date <- as.Date("2022-12-31")

# Filter averaged_data to time period of interest
datetime_filtered_data <- lapply(averaged_data, function(df) {
  df$date <- as.Date(df$date)
  df[df$date >= start_date & df$date <= end_date, ]
})

library(dplyr)
big_df <- bind_rows(datetime_filtered_data, .id = "source")
obs_co2 <- big_df[!is.na(big_df$co2_ppm), ]
obs_co2$ch4_ppb <- NULL

obs_ch4 <- big_df[!is.na(big_df$ch4_ppb), ]
obs_ch4$co2_ppm <- NULL
##### Loading in CarbonTracker #####

library(raster)

co2_files <- list.files(
  '/Volumes/Seagate/towers_model_info/CT_2022/co2',
  pattern = '\\.nc$',
  full.names = TRUE
)

CT_CO2 <- lapply(co2_files, function(f) {
  brick(
    f,
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
})


ch4_files <- list.files(
  '/Volumes/Seagate/towers_model_info/CT_2022/ch4',
  pattern = '\\.nc$',
  full.names = TRUE
)

CT_CH4 <- lapply(ch4_files, function(f) {
  brick(
    f,
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
})


CT_CO2_cropped <- list()
for (i in seq(CT_CO2)) {
  ras_date <- as.Date(floor(as.numeric((getZ(
    CT_CO2[[i]]
  )[1]))))
  if (ras_date >= start_date && ras_date <= end_date) {
    CT_CO2_cropped[[i]] <- CT_CO2[[i]]
  }
  
}

CT_CO2_cropped <- CT_CO2_cropped[!sapply(CT_CO2_cropped, is.null)]

CT_CH4_cropped <- list()
for (i in seq(CT_CO2)) {
  ras_date <- as.Date(getZ(CT_CH4[[i]])[1]) 
  if (ras_date >= start_date &&
      ras_date <= end_date) {
    CT_CH4_cropped[[i]] <- CT_CH4[[i]] 
  }
  
}

CT_CH4_cropped <- CT_CH4_cropped[!sapply(CT_CH4_cropped, is.null)]

CTCO2_lists <- lapply(1:8, function(k)
  lapply(CT_CO2_cropped, function(x)
    x[[k]]))
CTCH4_lists <- lapply(1:8, function(k)
  lapply(CT_CH4_cropped, function(x)
    x[[k]]))

library(raster)
CTCO2_lists <- unlist(CTCO2_lists, recursive = FALSE)
coords <- unique(obs_co2[, c("Lon", "Lat")])
all_results <- list()

for (i in seq_along(CTCO2_lists)) {
  r_brick <- CTCO2_lists[[i]]
  
  dates <- getZ(r_brick)
  
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  hours <- as.numeric(format(dates_posix, "%H"))
  rounded_hours <- floor(hours / 3) * 3 #choosing floor instead of ceiling so 01:30 -> 00:00
  dates_posix_aligned <- as.POSIXct(paste0(
    format(dates_posix, "%Y-%m-%d "),
    sprintf("%02d:00:00", rounded_hours)
  ), tz = "UTC")
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  
  df <- data.frame(
    date = rep(as.POSIXct(dates_posix_aligned), each = nrow(coords)),
    Lon  = rep(coords$Lon, times = nlayers(r_brick)),
    Lat  = rep(coords$Lat, times = nlayers(r_brick)),
    co2  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CO2_df <- do.call(rbind, all_results)
CT_CO2_df <- merge(CT_CO2_df,
                   unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
                   by = c("Lon", "Lat"),
                   all.x = TRUE)

library(raster)

CTCH4_lists <- unlist(CTCH4_lists, recursive = FALSE)
coords <- unique(obs_co2[, c("Lon", "Lat")])
all_results <- list()

for (i in seq_along(CTCH4_lists)) {
  r_brick <- CTCH4_lists[[i]]
  
  dates <- getZ(r_brick)
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  
  df <- data.frame(
    date = rep(as.POSIXct(dates_posix), each = nrow(coords)),
    Lon  = rep(coords$Lon, times = nlayers(r_brick)),
    Lat  = rep(coords$Lat, times = nlayers(r_brick)),
    ch4  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CH4_df <- do.call(rbind, all_results)
CT_CH4_df <- merge(CT_CH4_df,
                   unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
                   by = c("Lon", "Lat"),
                   all.x = TRUE)

 
###### Loading in CAMS information ######

library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)
CAMS <- list()
all_timestamps <- list()
files <- list.files(
  '/Volumes/Seagate/towers_model_info/CAMS_2022',
  pattern = '\\.nc$',
  full.names = TRUE
)

for (f in files) {
  cat("Processing:", f, "\n")
  nc <- nc_open(f)
  var_names <- names(nc$var)
  
  if ("CH4" %in% var_names) {
    var_to_use <- "CH4"
  } else if ("CO2" %in% var_names) {
    var_to_use <- "CO2"
  } else {
    warning("No CH4 or CO2 found in:", f)
    nc_close(nc)
    next
  }
  
  if ("time" %in% names(nc$dim)) {
    time_vals <- ncvar_get(nc, "time")
    time_units <- ncatt_get(nc, "time", "units")$value
    origin <- sub("hours since ", "", time_units)
    timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  } else {
    warning("No time dimension in:", f)
    nc_close(nc)
    next
  }
  nc_close(nc)
  
  r <- stack(f, varname = var_to_use)
    if (var_to_use == "CO2") {
    r <- calc(r, function(x)
      x * 1e6)
  }
  
  file_key <- basename(f)  
  CAMS[[file_key]] <- r
  all_timestamps[[file_key]] <- timestamps
}

coords <- unique(obs_co2[, c("Lon", "Lat")])
library(raster)

extracted_list <- list()

for (file_key in names(CAMS)) {
  r_stack <- CAMS[[file_key]]
  timestamps <- all_timestamps[[file_key]]
  
  vals <- raster::extract(r_stack, coords)
  df <- data.frame(
    Lon = rep(coords$Lon, each = nlayers(r_stack)),
    Lat = rep(coords$Lat, each = nlayers(r_stack)),
    Timestamp = rep(timestamps, times = nrow(coords)),
    Value = as.vector(t(vals)),
    File = file_key
  )
  
  extracted_list[[file_key]] <- df
}

all_data_cams <- do.call(rbind, extracted_list)

all_data_cams <- merge(
  all_data_cams,
  unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
  by = c("Lon", "Lat"),
  all.x = TRUE
)

start_datetime <- as.POSIXct(start_date, tz = "UTC")
end_datetime   <- as.POSIXct(end_date + 1, tz = "UTC") - 1


cams_CO2 <- all_data_cams[grepl("CO2", all_data_cams$File, ignore.case = TRUE) &
                            all_data_cams$Timestamp >= start_datetime &
                            all_data_cams$Timestamp <= end_datetime, ]

cams_CH4 <- all_data_cams[grepl("CH4", all_data_cams$File, ignore.case = TRUE) &
                            all_data_cams$Timestamp >= start_datetime &
                            all_data_cams$Timestamp <= end_datetime, ]
cams_CO2$File <- NULL
cams_CH4$File <- NULL

##### Saving .rds files #####
saveRDS(CT_CH4_df,"/Users/reneechabot-mehlin/Desktop/twr_comp/ct_ch4_2022.RData" )
saveRDS(CT_CO2_df,"/Users/reneechabot-mehlin/Desktop/twr_comp/ct_co2_2022.RData" )
saveRDS(cams_CO2,"/Users/reneechabot-mehlin/Desktop/twr_comp/cams_co2_2022.RData" )
saveRDS(cams_CH4,"/Users/reneechabot-mehlin/Desktop/twr_comp/cams_ch4_2022.RData" )
saveRDS(obs_co2, "/Users/reneechabot-mehlin/Desktop/twr_comp/obs_co2_2022.RData")
saveRDS(obs_ch4, "/Users/reneechabot-mehlin/Desktop/twr_comp/obs_ch4_2022.RData")

#####______________________________________________________________________#####
#####___________ Load in RDS files, no need to rerun! ____________________ #####
CT_CH4_df <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/ct_ch4_2022.RData")
CT_CO2_df <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/ct_co2_2022.RData")
cams_CO2 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cams_co2_2022.RData")
cams_CH4 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cams_ch4_2022.RData")
obs_co2 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/obs_co2_2022.RData")
obs_ch4 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/obs_ch4_2022.RData")
#####______________________________________________________________________#####
##### Merging Datasets together based on tower #####
#CO2

merged_co2_list <- list()

for (abriv in c("WNJ","LEW")) {
  site <- abriv
  
  filtered_cams_co2 <- cams_CO2[cams_CO2$SiteCode == site, ] #grab site code data only 
  filtered_obs_co2  <- obs_co2[substr(obs_co2$source, 1, 3) == site, ] #grab site code data only
  filtered_ct_co2   <- CT_CO2_df[CT_CO2_df$SiteCode == site, ] #grab site code data only
  
  interval_starts <- c(
    "00:00–03:00 UTC" = "00:00:00",   #defining time interval
    "03:00–06:00 UTC" = "03:00:00",
    "06:00–09:00 UTC" = "06:00:00",
    "09:00–12:00 UTC" = "09:00:00",
    "12:00–15:00 UTC" = "12:00:00",
    "15:00–18:00 UTC" = "15:00:00",
    "18:00–21:00 UTC" = "18:00:00",
    "21:00–00:00 UTC" = "21:00:00"
  )
  
  filtered_obs_co2$datetime <- as.POSIXct(
    paste(filtered_obs_co2$date, interval_starts[filtered_obs_co2$interval]), #add a datetime section to obs
    tz = "UTC"
  )
  
  filtered_cams_co2$DATE <- filtered_cams_co2$Timestamp #creating a date column for merge later
  filtered_obs_co2$DATE  <- filtered_obs_co2$datetime #creating a date column for merge later
  filtered_ct_co2$DATE   <- filtered_ct_co2$date #creating a date column for merge later
  
  names(filtered_cams_co2)[names(filtered_cams_co2) == "Value"] <- "CAMs_CO2" #renaming columns for merge later
  names(filtered_obs_co2)[names(filtered_obs_co2) == "co2_ppm"] <- "Obs_CO2_ppm" #renaming columns for merge later
  names(filtered_ct_co2)[names(filtered_ct_co2) == "co2"] <- "CT_CO2" #renaming columns for merge later
  
  #filtered_cams_co2$SiteCode <- site #I don't need to do this
  #filtered_ct_co2$SiteCode   <- site #I don't need to do this
  filtered_obs_co2$SiteCode  <- site
  
  merged_temp <- merge(filtered_obs_co2,
                       filtered_ct_co2,
                       by = "DATE",
                       all = TRUE)
  merged_co2 <- merge(merged_temp,
                      filtered_cams_co2,
                      by = "DATE",
                      all = TRUE)
  
  merged_co2 <- merged_co2[, c("DATE", "SiteCode", "CAMs_CO2", "Obs_CO2_ppm", "CT_CO2")]
  merged_co2 <- na.omit(merged_co2)
  merged_co2_list[[site]] <- merged_co2
}


#CH4
merged_ch4_cams_list <- list()
merged_ch4_ct_list   <- list()

for (abriv in c("WNJ", "LEW")) {
  site <- abriv
  
  filtered_cams_ch4 <- cams_CH4[cams_CH4$SiteCode == site, ]
  filtered_obs_ch4  <- obs_ch4[substr(obs_ch4$source, 1, 3) == site, ]
  filtered_ct_ch4   <- CT_CH4_df[CT_CH4_df$SiteCode == site, ]
  
  interval_starts <- c(
    "00:00–03:00 UTC" = "00:00:00",
    "03:00–06:00 UTC" = "03:00:00",
    "06:00–09:00 UTC" = "06:00:00",
    "09:00–12:00 UTC" = "09:00:00",
    "12:00–15:00 UTC" = "12:00:00",
    "15:00–18:00 UTC" = "15:00:00",
    "18:00–21:00 UTC" = "18:00:00",
    "21:00–00:00 UTC" = "21:00:00"
  )
  
  filtered_obs_ch4$datetime <- as.POSIXct(
    paste(filtered_obs_ch4$date, interval_starts[filtered_obs_ch4$interval]),
    tz = "UTC"
  )
  
  filtered_cams_ch4$DATE <- filtered_cams_ch4$Timestamp
  filtered_obs_ch4$DATE  <- filtered_obs_ch4$datetime
  filtered_ct_ch4$DATE   <- filtered_ct_ch4$date
  
  names(filtered_cams_ch4)[names(filtered_cams_ch4) == "Value"] <- "CAMs_CH4"
  names(filtered_obs_ch4)[names(filtered_obs_ch4) == "ch4_ppb"] <- "Obs_CH4_ppb"
  names(filtered_ct_ch4)[names(filtered_ct_ch4) == "ch4"] <- "CT_CH4"
  
  filtered_obs_ch4$SiteCode  <- site
  
  merged_obs_cams <- merge(filtered_obs_ch4[, c("DATE", "SiteCode", "Obs_CH4_ppb")],
                           filtered_cams_ch4[, c("DATE", "CAMs_CH4")],
                           by = "DATE",
                           all = TRUE)
  
  merged_obs_cams <- na.omit(merged_obs_cams)
  merged_obs_ct <- merge(filtered_obs_ch4[, c("DATE", "SiteCode", "Obs_CH4_ppb")],
                         filtered_ct_ch4[, c("DATE", "CT_CH4")],
                         by = "DATE",
                         all = TRUE)
  merged_obs_ct <- na.omit(merged_obs_ct)
  merged_ch4_cams_list[[site]] <- merged_obs_cams
  merged_ch4_ct_list[[site]]   <- merged_obs_ct
}


##### Saving .csv files #####

#output_dir <- '/Volumes/Seagate/towers_model_info'
output_dir<- "/Users/reneechabot-mehlin/Desktop/twr_comp/"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

#co2
for (abriv in c("WNJ", "LEW")) {
  write.csv(
    merged_co2_list[[abriv]],
    paste0(
      output_dir, "/merged_co2_2022_",
      abriv, ".csv"
    ),
    row.names = FALSE
  )
}
#cams ch4
for (abriv in c("WNJ", "LEW")) {
  write.csv(
    merged_ch4_cams_list[[abriv]],
    paste0(
      output_dir, "/merged_ch4_cams_2022_",
       abriv, ".csv"
    ),
    row.names = FALSE
  )
}
#ct ch4
for (abriv in c("WNJ", "LEW")) {
  write.csv(
    merged_ch4_ct_list[[abriv]],
    paste0(
      output_dir, "/merged_ch4_ct_2022_",
      abriv, ".csv"
    ),
    row.names = FALSE
  )
}
##### Removing everything except merged files ####
rm(list = ls())

#WNJ_co2 <- read.csv("/Volumes/Seagate/towers_model_info/merged_co2_2022_WNJ.csv")
#WNJ_ch4 <- read.csv("/Volumes/Seagate/towers_model_info/merged_ch4_2022_WNJ.csv")

WNJ_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_co2_2022_WNJ.csv")
WNJ_ch4_ct <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_ct_2022_WNJ.csv")
WNJ_ch4_cams <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_cams_2022_WNJ.csv")


#LEW_co2 <- read.csv("/Volumes/Seagate/towers_model_info/merged_co2_2022_LEW.csv")
#LEW_ch4 <- read.csv("/Volumes/Seagate/towers_model_info/merged_ch4_2022_LEW.csv")

LEW_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_co2_2022_LEW.csv")
LEW_ch4_ct <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_ct_2022_LEW.csv")
LEW_ch4_cams <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_cams_2022_LEW.csv")

 

##### Adding trajectory dates in #####
dates_2022 <- c(
  "2022-01-06",
  "2022-01-07",
  "2022-01-08",
  "2022-01-11",
  "2022-01-30",
  "2022-04-27",
  "2022-06-18",
  "2022-08-31",
  "2022-09-24",
  "2022-10-18",
  "2022-11-26",
  "2022-12-20",
  "2022-03-03",
  "2022-03-21",
  "2022-03-25",
  "2022-03-28",
  "2022-04-08",
  "2022-04-19",
  "2022-04-28",
  "2022-07-19",
  "2022-08-24",
  "2022-09-01",
  "2022-09-28",
  "2022-10-27",
  "2022-11-28",
  "2022-01-10",
  "2022-02-05",
  "2022-02-14",
  "2022-02-15",
  "2022-02-18",
  "2022-03-08",
  "2022-03-29",
  "2022-04-02",
  "2022-04-04",
  "2022-04-10",
  "2022-04-15",
  "2022-06-10",
  "2022-09-14",
  "2022-09-20",
  "2022-11-13",
  "2022-12-04"
)
dates_2022 <- as.POSIXct(dates_2022, format = "%Y-%m-%d", tz = "UTC")

#date formatting and conversion to POSIXct() UTC for sure
for (site in c("WNJ", "LEW")) {
  df_names <- ls(pattern = paste0("^", site, "_"))
  for (df_name in df_names) {
    df <- get(df_name)
    
    if ("DATE" %in% names(df)) {
      df$DATE <- ifelse(
        nchar(df$DATE) == 10,
        paste0(df$DATE, " 00:00:00"),
        df$DATE
      )
      df$DATE <- as.POSIXct(df$DATE, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
    }
    
    assign(df_name, df)
  }
}

for (site in c("WNJ", "LEW")) {
  df_names <- ls(pattern = paste0("^", site, "_"))
  
  for (df_name in df_names) {
    df <- get(df_name)
    
    if ("DATE" %in% names(df)) {
      df <- df[as.Date(df$DATE) %in% as.Date(dates_2022), ]
      assign(df_name, df)
    }
  }
}

all_sites <- ls(pattern = "^(WNJ|LEW)_") 
gases <- unique(sub("^(WNJ|LEW)_", "", all_sites))
enh_info_list <- list()
for (gas in gases) {
  wnj_name <- paste0("WNJ_", gas)
  lew_name <- paste0("LEW_", gas)
  
  if (!all(c(wnj_name, lew_name) %in% ls())) next
  
  WNJ <- get(wnj_name)
  LEW <- get(lew_name)
  merged <- merge(WNJ, LEW, by = "DATE", suffixes = c("_WNJ", "_LEW"))
  common_cols <- intersect(names(WNJ), names(LEW))
  numeric_cols <- common_cols[sapply(WNJ[common_cols], is.numeric)]
  
  enh_df <- data.frame(date = merged$DATE)
  
  for (col in numeric_cols) {
    wnj_col <- paste0(col, "_WNJ")
    lew_col <- paste0(col, "_LEW")
    
    if (all(c(wnj_col, lew_col) %in% names(merged))) {
      enh_df[[paste0(col, "_enh")]] <- merged[[wnj_col]] - merged[[lew_col]]
    }
  }
  
  enh_info_list[[gas]] <- enh_df
}

for (gas in names(enh_info_list)) {
  csv_filename <- paste0("/Users/reneechabot-mehlin/Desktop/twr_comp/",
                         "enhancement_2022_",
                         gas,
                         ".csv")
  write.csv(enh_info_list[[gas]], file = csv_filename, row.names = FALSE)
  message("✅ Saved ", csv_filename)
}
rm(list = ls())

#####______________________________________________________________________#####
#####_____________ can just run the section below for quick access ________#####
##### Plotting WNJ against LEW #####
csv_dir <- "/Users/reneechabot-mehlin/Desktop/twr_comp/"
csv_files <- list.files(path = csv_dir, pattern = "enhancement_2022.*\\.csv$", full.names = TRUE)
enh_loaded_list <- lapply(csv_files, read.csv)
names(enh_loaded_list) <- sub("\\.csv$", "", basename(csv_files))
list2env(enh_loaded_list, envir = .GlobalEnv)

enh_df_names <- ls(pattern = "^enhancement_2022_")
#date correct class
for (df_name in enh_df_names) {
  df <- get(df_name)
  
  date_col <- "date" %in% names(df)
  if (!is.na(date_col)) {
    df[[date_col]] <- ifelse(
      nchar(df[[date_col]]) == 10,
      paste0(df[[date_col]], " 00:00:00"),
      df[[date_col]]
    )
        df[[date_col]] <- as.POSIXct(df[[date_col]], format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  }
  assign(df_name, df)
}
#daylight hours only
for (df_name in enh_df_names) {
  df <- get(df_name)
  
  # Identify datetime column
  datetime_col <- "date" %in% names(df)
  
  df[[datetime_col]] <- as.POSIXct(df[[datetime_col]], tz = "UTC")
  
  local_time <- with_tz(df[[datetime_col]], tzone = "America/New_York")
  
  hour_local <- hour(local_time)
  
  df <- df[hour_local >= 10 & hour_local <= 16, ]
  
  assign(df_name, df)
}

library(ggplot2)
library(ggpubr)
library(grid)  
enh_info_list <- list(
  co2 = enhancement_2022_co2,
  ch4_ct = enhancement_2022_ch4_ct,
  ch4_cams = enhancement_2022_ch4_cams
)

limits <- list(
  co2 = c(-30, 30),
  ch4_ct = c(-100, 100),
  ch4_cams = c(-100, 100)
)

for (sp in names(enh_info_list)) {
  df <- enh_info_list[[sp]]
  
  if ("date" %in% names(df)) df$date <- as.Date(df$date)
    obs_col  <- grep("^Obs", names(df), value = TRUE)
  ct_col   <- grep("^CT", names(df), value = TRUE)
  cams_col <- grep("^CAM", names(df), value = TRUE)
  if (length(obs_col) == 0 || (length(ct_col) == 0 && length(cams_col) == 0)) next
  
  overall_min <- limits[[sp]][1]
  overall_max <- limits[[sp]][2]
  label.x <- overall_min + 0.02 * (overall_max - overall_min)
  label.y <- overall_max - 0.02 * (overall_max - overall_min)

    for (mod_col in c(ct_col, cams_col)) {
    mod_name <- ifelse(grepl("CT", mod_col), "CT", "CAMs")
    
    x_label <- paste0("Observed ", toupper(sub("_.*", "", sp)),
                      ifelse(grepl("co2", sp), " Enhancement (ppm)", " Enhancement (ppb)"))
    y_label <- paste0(mod_name, " ", toupper(sub("_.*", "", sp)),
                      ifelse(grepl("co2", sp), " Enhancement (ppm)", " Enhancement (ppb)"))
    
    title_text <- "Daytime Enhancements at WNJ tower Relative to LEW tower"
    
    p <- ggplot(df, aes(x = .data[[obs_col]], y = .data[[mod_col]], color = date)) +
      geom_point(size = 2, alpha = 0.8) +
      geom_smooth(method = lm, se = FALSE, color = "black") +
      stat_regline_equation(
        aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
        label.x = label.x,
        label.y = label.y,
        color = "black"
      ) +
      geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
      geom_hline(yintercept = 0, color = "grey55") +
      geom_vline(xintercept = 0, color = "grey55") +
      coord_fixed(
        ratio = 1,
        xlim = c(overall_min, overall_max),
        ylim = c(overall_min, overall_max)
      ) +
      scale_color_date(
        name = "Date",
        date_labels = "%Y-%m-%d",
        date_breaks = "1 month",
        guide = guide_colorbar(reverse = TRUE),
        low = "blue",
        high = "red"
      ) +
      labs(
        title = title_text,
        x = x_label,
        y = y_label,
        subtitle = paste0(mod_name, " vs Observations")
      ) +
      theme(
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16),
        plot.title = element_text(size = 20),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        legend.key.height = unit(1.5, "cm")
      )
    
    print(p)
  }
}


#####___________________ 4. WNJ v LEW Comparison 2023 _____________________#####
##### Load in the 2023 NEC tower .csv files #####
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


WNJ_23_CH4_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-ch4-43m-1-hour-v20250319.csv"
)
WNJ_23_CH4_43$DATE <- as.Date(WNJ_23_CH4_43$datetime_UTC)
WNJ_23_CH4_43$HH <- sprintf("%02d:00:00", WNJ_23_CH4_43$HH)
WNJ_23_CH4_43$datetime_combined <- paste(WNJ_23_CH4_43$DATE, WNJ_23_CH4_43$HH)
WNJ_23_CH4_43$datetime_UTC <- as.POSIXct(WNJ_23_CH4_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_23_CH4_43$datetime_EDT <- with_tz(WNJ_23_CH4_43$datetime_UTC, tzone = "America/New_York")


WNJ_23_CO2_43 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-co2-43m-1-hour-v20250319.csv"
)
WNJ_23_CO2_43$DATE <- as.Date(WNJ_23_CO2_43$datetime_UTC)
WNJ_23_CO2_43$HH <- sprintf("%02d:00:00", WNJ_23_CO2_43$HH)
WNJ_23_CO2_43$datetime_combined <- paste(WNJ_23_CO2_43$DATE, WNJ_23_CO2_43$HH)
WNJ_23_CO2_43$datetime_UTC <- as.POSIXct(WNJ_23_CO2_43$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_23_CO2_43$datetime_EDT <- with_tz(WNJ_23_CO2_43$datetime_UTC, tzone = "America/New_York")

##### Averaging data for 3 hour intervals 2023 #####
#3 hr avg__
all_data <- list(
  LEW_23_CH4_50 = LEW_23_CH4_50,
  LEW_23_CO2_50 = LEW_23_CO2_50,
  WNJ_23_CO2_43 = WNJ_23_CO2_43,
  WNJ_23_CH4_43 = WNJ_23_CH4_43
)
interval_labels <- c(
  "00:00–03:00 UTC",
  "03:00–06:00 UTC",
  "06:00–09:00 UTC",
  "09:00–12:00 UTC",
  "12:00–15:00 UTC",
  "15:00–18:00 UTC",
  "18:00–21:00 UTC",
  "21:00–00:00 UTC"
)
averaged_data <- list()

for (name in names(all_data)) {
  df <- all_data[[name]]
  df$hour <- as.numeric(format(df$datetime_UTC, "%H"))
  df$date <- as.Date(df$datetime_UTC)
  df$group <- findInterval(df$hour,
                           vec = c(0, 3, 6, 9, 12, 15, 18, 21, 24),
                           rightmost.closed = TRUE)
  if ("ch4_ppb" %in% names(df)) {
    target_col <- "ch4_ppb"
  } else if ("co2_ppm" %in% names(df)) {
    target_col <- "co2_ppm"
  } else {
    warning(paste("No target column found in", name))
    next
  }
  agg_formula <- as.formula(paste(target_col, "~ date + group"))
  avg_df <- aggregate(agg_formula, data = df, FUN = mean)
  avg_df$interval <- interval_labels[avg_df$group]
  
  averaged_data[[name]] <- avg_df
}

TOWER_LOCATIONS <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")

prefixes <- c("TMD", "LEW", "BVA", "WNJ")
site_prefixes <- substr(as.character(TOWER_LOCATIONS$SiteCode), 1, 3)
matched_rows <- TOWER_LOCATIONS[site_prefixes %in% prefixes, ]

for (i in names(averaged_data)) {
  sitecode <- substr(i, 1, 3)
  tower_row <- matched_rows[matched_rows$SiteCode == sitecode, c("Lat", "Lon") , drop = FALSE]
  if (nrow(tower_row) == 1) {
    meta_df <- cbind(averaged_data[[i]], tower_row[rep(1, nrow(averaged_data[[i]])), ])
    averaged_data[[i]] <- meta_df
  }
}


##### Set time limit for model comparison #####
start_date <- as.Date("2023-01-01")
end_date <- as.Date("2023-12-31")

# Filter averaged_data to time period of interest
datetime_filtered_data <- lapply(averaged_data, function(df) {
  df$date <- as.Date(df$date)
  df[df$date >= start_date & df$date <= end_date, ]
})

library(dplyr)
big_df <- bind_rows(datetime_filtered_data, .id = "source")
obs_co2 <- big_df[!is.na(big_df$co2_ppm), ]
obs_co2$ch4_ppb <- NULL

obs_ch4 <- big_df[!is.na(big_df$ch4_ppb), ]
obs_ch4$co2_ppm <- NULL
##### Loading in CarbonTracker #####

# obs_co2
# obs_ch4

library(raster)

co2_files <- list.files(
  '/Volumes/Seagate/towers_model_info/CT_2023/co2',
  pattern = '\\.nc$',
  full.names = TRUE
)

CT_CO2 <- lapply(co2_files, function(f) {
  brick(
    f,
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
})


ch4_files <- list.files(
  '/Volumes/Seagate/towers_model_info/CT_2023/ch4',
  pattern = '\\.nc$',
  full.names = TRUE
)

CT_CH4 <- lapply(ch4_files, function(f) {
  brick(
    f,
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
})


CT_CO2_cropped <- list()
for (i in seq(CT_CO2)) {
  ras_date <- as.Date(floor(as.numeric((getZ(
    CT_CO2[[i]]
  )[1]))))
  if (ras_date >= start_date && ras_date <= end_date) {
    CT_CO2_cropped[[i]] <- CT_CO2[[i]]
  }
  
}

CT_CO2_cropped <- CT_CO2_cropped[!sapply(CT_CO2_cropped, is.null)]

CT_CH4_cropped <- list()
for (i in seq(CT_CO2)) {
  ras_date <- as.Date(getZ(CT_CH4[[i]])[1]) #starts at 03:00 and ends the next day at 00:00
  if (ras_date >= start_date &&
      ras_date <= end_date) {
    #this is why it is mismatched later on and can't be fixed
    CT_CH4_cropped[[i]] <- CT_CH4[[i]] #but why CT_CO2 can and has been fixed
  }
  
}

CT_CH4_cropped <- CT_CH4_cropped[!sapply(CT_CH4_cropped, is.null)]

CTCO2_lists <- lapply(1:8, function(k)
  lapply(CT_CO2_cropped, function(x)
    x[[k]]))
CTCH4_lists <- lapply(1:8, function(k)
  lapply(CT_CH4_cropped, function(x)
    x[[k]]))

library(raster)
CTCO2_lists <- unlist(CTCO2_lists, recursive = FALSE)
coords <- unique(obs_co2[, c("Lon", "Lat")])
all_results <- list()

for (i in seq_along(CTCO2_lists)) {
  r_brick <- CTCO2_lists[[i]]
  
  dates <- getZ(r_brick)
  
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  hours <- as.numeric(format(dates_posix, "%H"))
  rounded_hours <- floor(hours / 3) * 3 #choosing floor instead of ceiling so 01:30 -> 00:00
  dates_posix_aligned <- as.POSIXct(paste0(
    format(dates_posix, "%Y-%m-%d "),
    sprintf("%02d:00:00", rounded_hours)
  ), tz = "UTC")
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  
  df <- data.frame(
    date = rep(as.POSIXct(dates_posix_aligned), each = nrow(coords)),
    Lon  = rep(coords$Lon, times = nlayers(r_brick)),
    Lat  = rep(coords$Lat, times = nlayers(r_brick)),
    co2  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CO2_df <- do.call(rbind, all_results)
CT_CO2_df <- merge(CT_CO2_df,
                   unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
                   by = c("Lon", "Lat"),
                   all.x = TRUE)

library(raster)

CTCH4_lists <- unlist(CTCH4_lists, recursive = FALSE)
coords <- unique(obs_co2[, c("Lon", "Lat")])
all_results <- list()

for (i in seq_along(CTCH4_lists)) {
  r_brick <- CTCH4_lists[[i]]
  
  dates <- getZ(r_brick)
  if (is.null(dates)) {
    dates <- 1:nlayers(r_brick)
  }
  
  library(terra)
  vals <- raster::extract(r_brick, coords)
  dates_posix <- as.POSIXct(dates, origin = "1970-01-01", tz = "UTC")
  
  df <- data.frame(
    date = rep(as.POSIXct(dates_posix), each = nrow(coords)),
    Lon  = rep(coords$Lon, times = nlayers(r_brick)),
    Lat  = rep(coords$Lat, times = nlayers(r_brick)),
    ch4  = as.vector(t(vals))
  )
  
  all_results[[i]] <- df
}

CT_CH4_df <- do.call(rbind, all_results)
CT_CH4_df <- merge(CT_CH4_df,
                   unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
                   by = c("Lon", "Lat"),
                   all.x = TRUE)


###### Loading in CAMS information ######

library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)
CAMS <- list()
all_timestamps <- list()
files <- list.files(
  '/Volumes/Seagate/towers_model_info/CAMS_2023',
  pattern = '\\.nc$',
  full.names = TRUE
)

for (f in files) {
  cat("Processing:", f, "\n")
  nc <- nc_open(f)
  var_names <- names(nc$var)
  
  if ("CH4" %in% var_names) {
    var_to_use <- "CH4"
  } else if ("CO2" %in% var_names) {
    var_to_use <- "CO2"
  } else {
    warning("No CH4 or CO2 found in:", f)
    nc_close(nc)
    next
  }
  
  # Read timestamps
  if ("time" %in% names(nc$dim)) {
    time_vals <- ncvar_get(nc, "time")
    time_units <- ncatt_get(nc, "time", "units")$value
    origin <- sub("hours since ", "", time_units)
    timestamps <- as.POSIXct(time_vals * 3600, origin = origin, tz = "UTC")
  } else {
    warning("No time dimension in:", f)
    nc_close(nc)
    next
  }
  nc_close(nc)
  
  # Load all time layers
  r <- stack(f, varname = var_to_use)
  
  # Unit fix for CO2
  if (var_to_use == "CO2") {
    r <- calc(r, function(x)
      x * 1e6)
  }
  
  file_key <- basename(f)  # Use file name as key
  CAMS[[file_key]] <- r
  all_timestamps[[file_key]] <- timestamps
}

coords <- unique(obs_co2[, c("Lon", "Lat")])
library(raster)

extracted_list <- list()

for (file_key in names(CAMS)) {
  r_stack <- CAMS[[file_key]]
  timestamps <- all_timestamps[[file_key]]
  
  vals <- raster::extract(r_stack, coords)
  df <- data.frame(
    Lon = rep(coords$Lon, each = nlayers(r_stack)),
    Lat = rep(coords$Lat, each = nlayers(r_stack)),
    Timestamp = rep(timestamps, times = nrow(coords)),
    Value = as.vector(t(vals)),
    File = file_key
  )
  
  extracted_list[[file_key]] <- df
}

all_data_cams <- do.call(rbind, extracted_list)

all_data_cams <- merge(
  all_data_cams,
  unique(matched_rows[, c("Lon", "Lat", "SiteCode")]),
  by = c("Lon", "Lat"),
  all.x = TRUE
)

start_datetime <- as.POSIXct(start_date, tz = "UTC")
end_datetime   <- as.POSIXct(end_date + 1, tz = "UTC") - 1


cams_CO2 <- all_data_cams[grepl("CO2", all_data_cams$File, ignore.case = TRUE) &
                            all_data_cams$Timestamp >= start_datetime &
                            all_data_cams$Timestamp <= end_datetime, ]

cams_CH4 <- all_data_cams[grepl("CH4", all_data_cams$File, ignore.case = TRUE) &
                            all_data_cams$Timestamp >= start_datetime &
                            all_data_cams$Timestamp <= end_datetime, ]
cams_CO2$File <- NULL
cams_CH4$File <- NULL


##### Saving .rds files #####
saveRDS(CT_CH4_df,"/Users/reneechabot-mehlin/Desktop/twr_comp/ct_ch4_2023.RData" )
saveRDS(CT_CO2_df,"/Users/reneechabot-mehlin/Desktop/twr_comp/ct_co2_2023.RData" )
saveRDS(cams_CO2,"/Users/reneechabot-mehlin/Desktop/twr_comp/cams_co2_2023.RData" )
saveRDS(cams_CH4,"/Users/reneechabot-mehlin/Desktop/twr_comp/cams_ch4_2023.RData" )
saveRDS(obs_co2, "/Users/reneechabot-mehlin/Desktop/twr_comp/obs_co2_2023.RData")
saveRDS(obs_ch4, "/Users/reneechabot-mehlin/Desktop/twr_comp/obs_ch4_2023.RData")

#####______________________________________________________________________#####
#####___________ Load in RDS files, no need to rerun! ____________________ #####
CT_CH4_df <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/ct_ch4_2023.RData")
CT_CO2_df <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/ct_co2_2023.RData")
cams_CO2 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cams_co2_2023.RData")
cams_CH4 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/cams_ch4_2023.RData")
obs_co2 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/obs_co2_2023.RData")
obs_ch4 <- readRDS("/Users/reneechabot-mehlin/Desktop/twr_comp/obs_ch4_2023.RData")
#####______________________________________________________________________#####
##### Merging Datasets together based on tower #####
#CO2

merged_co2_list <- list()

for (abriv in c("WNJ","LEW")) {
  site <- abriv
  
  filtered_cams_co2 <- cams_CO2[cams_CO2$SiteCode == site, ] #grab site code data only 
  filtered_obs_co2  <- obs_co2[substr(obs_co2$source, 1, 3) == site, ] #grab site code data only
  filtered_ct_co2   <- CT_CO2_df[CT_CO2_df$SiteCode == site, ] #grab site code data only
  
  interval_starts <- c(
    "00:00–03:00 UTC" = "00:00:00",   #defining time interval
    "03:00–06:00 UTC" = "03:00:00",
    "06:00–09:00 UTC" = "06:00:00",
    "09:00–12:00 UTC" = "09:00:00",
    "12:00–15:00 UTC" = "12:00:00",
    "15:00–18:00 UTC" = "15:00:00",
    "18:00–21:00 UTC" = "18:00:00",
    "21:00–00:00 UTC" = "21:00:00"
  )
  
  filtered_obs_co2$datetime <- as.POSIXct(
    paste(filtered_obs_co2$date, interval_starts[filtered_obs_co2$interval]), #add a datetime section to obs
    tz = "UTC"
  )
  
  filtered_cams_co2$DATE <- filtered_cams_co2$Timestamp #creating a date column for merge later
  filtered_obs_co2$DATE  <- filtered_obs_co2$datetime #creating a date column for merge later
  filtered_ct_co2$DATE   <- filtered_ct_co2$date #creating a date column for merge later
  
  names(filtered_cams_co2)[names(filtered_cams_co2) == "Value"] <- "CAMs_CO2" #renaming columns for merge later
  names(filtered_obs_co2)[names(filtered_obs_co2) == "co2_ppm"] <- "Obs_CO2_ppm" #renaming columns for merge later
  names(filtered_ct_co2)[names(filtered_ct_co2) == "co2"] <- "CT_CO2" #renaming columns for merge later
  
  #filtered_cams_co2$SiteCode <- site #I don't need to do this
  #filtered_ct_co2$SiteCode   <- site #I don't need to do this
  filtered_obs_co2$SiteCode  <- site
  
  merged_temp <- merge(filtered_obs_co2,
                       filtered_ct_co2,
                       by = "DATE",
                       all = TRUE)
  merged_co2 <- merge(merged_temp,
                      filtered_cams_co2,
                      by = "DATE",
                      all = TRUE)
  
  merged_co2 <- merged_co2[, c("DATE", "SiteCode", "CAMs_CO2", "Obs_CO2_ppm", "CT_CO2")]
  merged_co2 <- na.omit(merged_co2)
  merged_co2_list[[site]] <- merged_co2
}


#CH4
merged_ch4_cams_list <- list()
merged_ch4_ct_list   <- list()

for (abriv in c("WNJ", "LEW")) {
  site <- abriv
  
  filtered_cams_ch4 <- cams_CH4[cams_CH4$SiteCode == site, ]
  filtered_obs_ch4  <- obs_ch4[substr(obs_ch4$source, 1, 3) == site, ]
  filtered_ct_ch4   <- CT_CH4_df[CT_CH4_df$SiteCode == site, ]
  
  interval_starts <- c(
    "00:00–03:00 UTC" = "00:00:00",
    "03:00–06:00 UTC" = "03:00:00",
    "06:00–09:00 UTC" = "06:00:00",
    "09:00–12:00 UTC" = "09:00:00",
    "12:00–15:00 UTC" = "12:00:00",
    "15:00–18:00 UTC" = "15:00:00",
    "18:00–21:00 UTC" = "18:00:00",
    "21:00–00:00 UTC" = "21:00:00"
  )
  
  filtered_obs_ch4$datetime <- as.POSIXct(
    paste(filtered_obs_ch4$date, interval_starts[filtered_obs_ch4$interval]),
    tz = "UTC"
  )
  
  filtered_cams_ch4$DATE <- filtered_cams_ch4$Timestamp
  filtered_obs_ch4$DATE  <- filtered_obs_ch4$datetime
  filtered_ct_ch4$DATE   <- filtered_ct_ch4$date
  
  names(filtered_cams_ch4)[names(filtered_cams_ch4) == "Value"] <- "CAMs_CH4"
  names(filtered_obs_ch4)[names(filtered_obs_ch4) == "ch4_ppb"] <- "Obs_CH4_ppb"
  names(filtered_ct_ch4)[names(filtered_ct_ch4) == "ch4"] <- "CT_CH4"
  
  filtered_obs_ch4$SiteCode  <- site
  
  merged_obs_cams <- merge(filtered_obs_ch4[, c("DATE", "SiteCode", "Obs_CH4_ppb")],
                           filtered_cams_ch4[, c("DATE", "CAMs_CH4")],
                           by = "DATE",
                           all = TRUE)
  
  merged_obs_cams <- na.omit(merged_obs_cams)
  merged_obs_ct <- merge(filtered_obs_ch4[, c("DATE", "SiteCode", "Obs_CH4_ppb")],
                         filtered_ct_ch4[, c("DATE", "CT_CH4")],
                         by = "DATE",
                         all = TRUE)
  merged_obs_ct <- na.omit(merged_obs_ct)
  merged_ch4_cams_list[[site]] <- merged_obs_cams
  merged_ch4_ct_list[[site]]   <- merged_obs_ct
}


##### Saving .csv files #####

#output_dir <- '/Volumes/Seagate/towers_model_info'
output_dir<- "/Users/reneechabot-mehlin/Desktop/twr_comp/"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

#co2
for (abriv in c("WNJ", "LEW")) {
  write.csv(
    merged_co2_list[[abriv]],
    paste0(
      output_dir, "/merged_co2_2023_",
      abriv, ".csv"
    ),
    row.names = FALSE
  )
}
#cams ch4
for (abriv in c("WNJ", "LEW")) {
  write.csv(
    merged_ch4_cams_list[[abriv]],
    paste0(
      output_dir, "/merged_ch4_cams_2023_",
      abriv, ".csv"
    ),
    row.names = FALSE
  )
}
#ct ch4
for (abriv in c("WNJ", "LEW")) {
  write.csv(
    merged_ch4_ct_list[[abriv]],
    paste0(
      output_dir, "/merged_ch4_ct_2023_",
      abriv, ".csv"
    ),
    row.names = FALSE
  )
}
##### Removing everything except merged files ####
rm(list = ls())

#WNJ_co2 <- read.csv("/Volumes/Seagate/towers_model_info/merged_co2_2022_WNJ.csv")
#WNJ_ch4 <- read.csv("/Volumes/Seagate/towers_model_info/merged_ch4_2022_WNJ.csv")

WNJ_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_co2_2023_WNJ.csv")
WNJ_ch4_ct <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_ct_2023_WNJ.csv")
WNJ_ch4_cams <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_cams_2023_WNJ.csv")


#LEW_co2 <- read.csv("/Volumes/Seagate/towers_model_info/merged_co2_2022_LEW.csv")
#LEW_ch4 <- read.csv("/Volumes/Seagate/towers_model_info/merged_ch4_2022_LEW.csv")

LEW_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_co2_2023_LEW.csv")
LEW_ch4_ct <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_ct_2023_LEW.csv")
LEW_ch4_cams <- read.csv("/Users/reneechabot-mehlin/Desktop/twr_comp/merged_ch4_cams_2023_LEW.csv")

##### Adding trajectory dates in #####
dates_2023 <- c(
  "2023-01-01",
  "2023-01-18",
  "2023-01-23",
  "2023-02-03",
  "2023-02-04",
  "2023-02-08",
  "2023-02-14", 
  "2023-02-18",
  "2023-02-24",
  "2023-03-14",
  "2023-03-15",
  "2023-03-18",
  "2023-05-21",
  "2023-06-15",
  "2023-06-18",
  "2023-07-10",
  "2023-08-09",
  "2023-08-18",
  "2023-08-19",
  "2023-09-04",
  "2023-09-19",
  "2023-10-16",
  "2023-10-21",
  "2023-10-22",
  "2023-11-01",
  "2023-11-10",
  "2023-11-11",
  "2023-11-14",
  "2023-11-19",
  "2023-11-23",
  "2023-11-24",
  "2023-12-05",
  "2023-12-11",
  "2023-12-18",
  "2023-12-19",
  "2023-12-20",
  "2023-12-29",
  "2023-12-31"
)
dates_2023 <- as.POSIXct(dates_2023, format = "%Y-%m-%d", tz = "UTC")

#date formatting and conversion to POSIXct() UTC for sure
for (site in c("WNJ", "LEW")) {
  df_names <- ls(pattern = paste0("^", site, "_"))
  for (df_name in df_names) {
    df <- get(df_name)
    
    if ("DATE" %in% names(df)) {
      df$DATE <- ifelse(
        nchar(df$DATE) == 10,
        paste0(df$DATE, " 00:00:00"),
        df$DATE
      )
      df$DATE <- as.POSIXct(df$DATE, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
    }
    
    assign(df_name, df)
  }
}

for (site in c("WNJ", "LEW")) {
  df_names <- ls(pattern = paste0("^", site, "_"))
  
  for (df_name in df_names) {
    df <- get(df_name)
    
    if ("DATE" %in% names(df)) {
      df <- df[as.Date(df$DATE) %in% as.Date(dates_2023), ]
      assign(df_name, df)
    }
  }
}

all_sites <- ls(pattern = "^(WNJ|LEW)_") 
gases <- unique(sub("^(WNJ|LEW)_", "", all_sites))
enh_info_list <- list()
for (gas in gases) {
  wnj_name <- paste0("WNJ_", gas)
  lew_name <- paste0("LEW_", gas)
  
  if (!all(c(wnj_name, lew_name) %in% ls())) next
  
  WNJ <- get(wnj_name)
  LEW <- get(lew_name)
  merged <- merge(WNJ, LEW, by = "DATE", suffixes = c("_WNJ", "_LEW"))
  common_cols <- intersect(names(WNJ), names(LEW))
  numeric_cols <- common_cols[sapply(WNJ[common_cols], is.numeric)]
  
  enh_df <- data.frame(date = merged$DATE)
  
  for (col in numeric_cols) {
    wnj_col <- paste0(col, "_WNJ")
    lew_col <- paste0(col, "_LEW")
    
    if (all(c(wnj_col, lew_col) %in% names(merged))) {
      enh_df[[paste0(col, "_enh")]] <- merged[[wnj_col]] - merged[[lew_col]]
    }
  }
  
  enh_info_list[[gas]] <- enh_df
}


for (gas in names(enh_info_list)) {
  csv_filename <- paste0("/Users/reneechabot-mehlin/Desktop/twr_comp/",
                         "enhancement_2023_",
                         gas,
                         ".csv")
  write.csv(enh_info_list[[gas]], file = csv_filename, row.names = FALSE)
  message("✅ Saved ", csv_filename)
}
rm(list = ls())


#####_____________ can just run the section below for quick access ________#####
##### Plotting WNJ against LEW #####
csv_dir <- "/Users/reneechabot-mehlin/Desktop/twr_comp/"
csv_files <- list.files(path = csv_dir, pattern = "enhancement_2023.*\\.csv$", full.names = TRUE)
enh_loaded_list <- lapply(csv_files, read.csv)
names(enh_loaded_list) <- sub("\\.csv$", "", basename(csv_files))
list2env(enh_loaded_list, envir = .GlobalEnv)

enh_df_names <- ls(pattern = "^enhancement_2023_")
#date correct class
for (df_name in enh_df_names) {
  df <- get(df_name)
  
  date_col <- "date" %in% names(df)
  if (!is.na(date_col)) {
    df[[date_col]] <- ifelse(
      nchar(df[[date_col]]) == 10,
      paste0(df[[date_col]], " 00:00:00"),
      df[[date_col]]
    )
    df[[date_col]] <- as.POSIXct(df[[date_col]], format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  }
  assign(df_name, df)
}
#daylight hours only
for (df_name in enh_df_names) {
  df <- get(df_name)
  
  # Identify datetime column
  datetime_col <- "date" %in% names(df)
  
  df[[datetime_col]] <- as.POSIXct(df[[datetime_col]], tz = "UTC")
  
  local_time <- with_tz(df[[datetime_col]], tzone = "America/New_York")
  
  hour_local <- hour(local_time)
  
  df <- df[hour_local >= 10 & hour_local <= 16, ]
  
  assign(df_name, df)
}

library(ggplot2)
library(ggpubr)
library(grid)  
enh_info_list <- list(
  co2 = enhancement_2023_co2,
  ch4_ct = enhancement_2023_ch4_ct,
  ch4_cams = enhancement_2023_ch4_cams
)

limits <- list(
  co2 = c(-30, 30),
  ch4_ct = c(-100, 100),
  ch4_cams = c(-100, 100)
)

for (sp in names(enh_info_list)) {
  df <- enh_info_list[[sp]]
  
  if ("date" %in% names(df)) df$date <- as.Date(df$date)
  obs_col  <- grep("^Obs", names(df), value = TRUE)
  ct_col   <- grep("^CT", names(df), value = TRUE)
  cams_col <- grep("^CAM", names(df), value = TRUE)
  if (length(obs_col) == 0 || (length(ct_col) == 0 && length(cams_col) == 0)) next
  
  overall_min <- limits[[sp]][1]
  overall_max <- limits[[sp]][2]
  label.x <- overall_min + 0.02 * (overall_max - overall_min)
  label.y <- overall_max - 0.02 * (overall_max - overall_min)
  
  for (mod_col in c(ct_col, cams_col)) {
    mod_name <- ifelse(grepl("CT", mod_col), "CT", "CAMs")
    
    x_label <- paste0("Observed ", toupper(sub("_.*", "", sp)),
                      ifelse(grepl("co2", sp), " Enhancement (ppm)", " Enhancement (ppb)"))
    y_label <- paste0(mod_name, " ", toupper(sub("_.*", "", sp)),
                      ifelse(grepl("co2", sp), " Enhancement (ppm)", " Enhancement (ppb)"))
    
    title_text <- "Daytime Enhancements at WNJ tower Relative to LEW tower"
    
    p <- ggplot(df, aes(x = .data[[obs_col]], y = .data[[mod_col]], color = date)) +
      geom_point(size = 2, alpha = 0.8) +
      geom_smooth(method = lm, se = FALSE, color = "black") +
      stat_regline_equation(
        aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
        label.x = label.x,
        label.y = label.y,
        color = "black"
      ) +
      geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
      geom_hline(yintercept = 0, color = "grey55") +
      geom_vline(xintercept = 0, color = "grey55") +
      coord_fixed(
        ratio = 1,
        xlim = c(overall_min, overall_max),
        ylim = c(overall_min, overall_max)
      ) +
      scale_color_date(
        name = "Date",
        date_labels = "%Y-%m-%d",
        date_breaks = "1 month",
        guide = guide_colorbar(reverse = TRUE),
        low = "blue",
        high = "red"
      ) +
      labs(
        title = title_text,
        x = x_label,
        y = y_label,
        subtitle = paste0(mod_name, " vs Observations")
      ) +
      theme(
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16),
        plot.title = element_text(size = 20),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        legend.key.height = unit(1.5, "cm")
      )
    
    print(p)
  }
}
#####_______________________________________________________________________####
#####_____________________ 5. Combining Comparison 22-23 ___________________####
library(lubridate)
library(ggplot2)
library(ggpubr)
library(grid)
library(dplyr)
library(tidyverse)

csv_dir <- "/Users/reneechabot-mehlin/Desktop/twr_comp/"
csv_files <- list.files(path = csv_dir, pattern = "enhancement_(2022|2023).*\\.csv$", full.names = TRUE)

enh_loaded_list <- lapply(csv_files, read.csv)
names(enh_loaded_list) <- sub("\\.csv$", "", basename(csv_files))
list2env(enh_loaded_list, envir = .GlobalEnv)

enh_df_names <- ls(pattern = "^enhancement_(2022|2023)_")

for (df_name in enh_df_names) {
  df <- get(df_name)
  
  if ("date" %in% names(df)) {
    df$date <- ifelse(
      nchar(df$date) == 10,
      paste0(df$date, " 00:00:00"),
      df$date
    )
    df$date <- as.POSIXct(df$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
    local_time <- with_tz(df$date, tzone = "America/New_York")
    hour_local <- hour(local_time)
    df <- df[hour_local >= 10 & hour_local <= 16, ]
    
    assign(df_name, df)
  }
}

combine_years <- function(prefix) {
  df_2022 <- get(paste0("enhancement_2022_", prefix), inherits = TRUE)
  df_2023 <- get(paste0("enhancement_2023_", prefix), inherits = TRUE)
  bind_rows(df_2022, df_2023)
}

enh_info_list <- list(
  co2      = combine_years("co2"),
  ch4_ct   = combine_years("ch4_ct"),
  ch4_cams = combine_years("ch4_cams")
)

limits <- list(
  co2 = c(-30, 30),
  ch4_ct = c(-100, 100),
  ch4_cams = c(-100, 100)
)

for (sp in names(enh_info_list)) {
  df <- enh_info_list[[sp]]
  
  if ("date" %in% names(df)) df$date <- as.Date(df$date)
  
  obs_col  <- grep("^Obs", names(df), value = TRUE)
  ct_col   <- grep("^CT", names(df), value = TRUE)
  cams_col <- grep("^CAM", names(df), value = TRUE)
  if (length(obs_col) == 0 || (length(ct_col) == 0 && length(cams_col) == 0)) next
  
  overall_min <- limits[[sp]][1]
  overall_max <- limits[[sp]][2]
  label.x <- overall_min + 0.02 * (overall_max - overall_min)
  label.y <- overall_max - 0.02 * (overall_max - overall_min)
  
  for (mod_col in c(ct_col, cams_col)) {
    mod_name <- ifelse(grepl("CT", mod_col), "CT", "CAMs")
    
    x_label <- paste0("Observed ", toupper(sub("_.*", "", sp)),
                      ifelse(grepl("co2", sp), " Enhancement (ppm)", " Enhancement (ppb)"))
    y_label <- paste0(mod_name, " ", toupper(sub("_.*", "", sp)),
                      ifelse(grepl("co2", sp), " Enhancement (ppm)", " Enhancement (ppb)"))
    
    title_text <- "Daytime Enhancements at WNJ tower Relative to LEW tower"
    
    p <- ggplot(df, aes(x = .data[[obs_col]], y = .data[[mod_col]], color = date)) +
      geom_point(size = 2, alpha = 0.8) +
      geom_smooth(method = lm, se = FALSE, color = "black") +
      stat_regline_equation(
        aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
        label.x = label.x,
        label.y = label.y,
        color = "black"
      ) +
      geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
      geom_hline(yintercept = 0, color = "grey55") +
      geom_vline(xintercept = 0, color = "grey55") +
      coord_fixed(
        ratio = 1,
        xlim = c(overall_min, overall_max),
        ylim = c(overall_min, overall_max)
      ) +
      scale_color_date(
        name = "Date",
        date_labels = "%Y-%m-%d",
        date_breaks = "1 month",
        guide = guide_colorbar(reverse = TRUE),
        low = "blue",
        high = "red"
      ) +
      labs(
        title = title_text,
        x = x_label,
        y = y_label,
        subtitle = paste0(mod_name, " vs Observations")
      ) +
      theme(
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16),
        plot.title = element_text(size = 20),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        legend.key.height = unit(1.5, "cm")
      )
    
    print(p)
  }
}

#####_______________________________________________________________________####
#####_______________________________________________________________________####
