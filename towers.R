#Analyzing tower data: observations and models comparison
#Updated last on August 28, 2025

#You will have to manually change items in:
# 1.3 (xlim_vals)
# 2.3 (start_date, end_date)
# 2.4 (cruise)

##### ________________________ 1. Just Towers _____________________________#####
##### Load in the 2022 NEC tower .csv files #####
#____
LEW_22_CH4_95 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-95m-1-hour-20230425.csv"
)
LEW_22_CH4_95$DATE <- as.Date(LEW_22_CH4_95$datetime_UTC)
LEW_22_CH4_95$HH <- sprintf("%02d:00:00", LEW_22_CH4_95$HH)
LEW_22_CH4_95$datetime_combined <- paste(LEW_22_CH4_95$DATE, LEW_22_CH4_95$HH)
LEW_22_CH4_95$datetime_UTC <- as.POSIXct(LEW_22_CH4_95$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CH4_95$datetime_EDT <- with_tz(LEW_22_CH4_95$datetime_UTC, tzone = "America/New_York")


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

LEW_22_CO2_95 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-co2-95m-1-hour-20230425.csv'
)
LEW_22_CO2_95$DATE <- as.Date(LEW_22_CO2_95$datetime_UTC)
LEW_22_CO2_95$HH <- sprintf("%02d:00:00", LEW_22_CO2_95$HH)
LEW_22_CO2_95$datetime_combined <- paste(LEW_22_CO2_95$DATE, LEW_22_CO2_95$HH)
LEW_22_CO2_95$datetime_UTC <- as.POSIXct(LEW_22_CO2_95$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CO2_95$datetime_EDT <- with_tz(LEW_22_CO2_95$datetime_UTC, tzone = "America/New_York")


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
TMD_22_CH4_113 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-ch4-113m-1-hour-20230425.csv'
)
TMD_22_CH4_113$DATE <- as.Date(TMD_22_CH4_113$datetime_UTC)
TMD_22_CH4_113$HH <- sprintf("%02d:00:00", TMD_22_CH4_113$HH)
TMD_22_CH4_113$datetime_combined <- paste(TMD_22_CH4_113$DATE, TMD_22_CH4_113$HH)
TMD_22_CH4_113$datetime_UTC <- as.POSIXct(TMD_22_CH4_113$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
TMD_22_CH4_113$datetime_EDT <- with_tz(TMD_22_CH4_113$datetime_UTC, tzone = "America/New_York")

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

TMD_22_CO2_113 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-co2-113m-1-hour-20230425.csv'
)
TMD_22_CO2_113$DATE <- as.Date(TMD_22_CO2_113$datetime_UTC)
TMD_22_CO2_113$HH <- sprintf("%02d:00:00", TMD_22_CO2_113$HH)
TMD_22_CO2_113$datetime_combined <- paste(TMD_22_CO2_113$DATE, TMD_22_CO2_113$HH)
TMD_22_CO2_113$datetime_UTC <- as.POSIXct(TMD_22_CO2_113$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
TMD_22_CO2_113$datetime_EDT <- with_tz(TMD_22_CO2_113$datetime_UTC, tzone = "America/New_York")

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
BVA_22_CH4_111 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-ch4-111m-1-hour-v20250319.csv'
)
BVA_22_CH4_111$DATE <- as.Date(BVA_22_CH4_111$datetime_UTC)
BVA_22_CH4_111$HH <- sprintf("%02d:00:00", BVA_22_CH4_111$HH)
BVA_22_CH4_111$datetime_combined <- paste(BVA_22_CH4_111$DATE, BVA_22_CH4_111$HH)
BVA_22_CH4_111$datetime_UTC <- as.POSIXct(BVA_22_CH4_111$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
BVA_22_CH4_111$datetime_EDT <- with_tz(BVA_22_CH4_111$datetime_UTC, tzone = "America/New_York")

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

BVA_22_CO2_111 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-co2-111m-1-hour-v20250319.csv'
)
BVA_22_CO2_111$DATE <- as.Date(BVA_22_CO2_111$datetime_UTC)
BVA_22_CO2_111$HH <- sprintf("%02d:00:00", BVA_22_CO2_111$HH)
BVA_22_CO2_111$datetime_combined <- paste(BVA_22_CO2_111$DATE, BVA_22_CO2_111$HH)
BVA_22_CO2_111$datetime_UTC <- as.POSIXct(BVA_22_CO2_111$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
BVA_22_CO2_111$datetime_EDT <- with_tz(BVA_22_CO2_111$datetime_UTC, tzone = "America/New_York")

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

WNJ_22_CH4_98 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-ch4-98m-1-hour-v20250319.csv"
)
WNJ_22_CH4_98$DATE <- as.Date(WNJ_22_CH4_98$datetime_UTC)
WNJ_22_CH4_98$HH <- sprintf("%02d:00:00", WNJ_22_CH4_98$HH)
WNJ_22_CH4_98$datetime_combined <- paste(WNJ_22_CH4_98$DATE, WNJ_22_CH4_98$HH)
WNJ_22_CH4_98$datetime_UTC <- as.POSIXct(WNJ_22_CH4_98$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_22_CH4_98$datetime_EDT <- with_tz(WNJ_22_CH4_98$datetime_UTC, tzone = "America/New_York")

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

WNJ_22_CO2_98 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2022-co2-98m-1-hour-v20250319.csv"
)
WNJ_22_CO2_98$DATE <- as.Date(WNJ_22_CO2_98$datetime_UTC)
WNJ_22_CO2_98$HH <- sprintf("%02d:00:00", WNJ_22_CO2_98$HH)
WNJ_22_CO2_98$datetime_combined <- paste(WNJ_22_CO2_98$DATE, WNJ_22_CO2_98$HH)
WNJ_22_CO2_98$datetime_UTC <- as.POSIXct(WNJ_22_CO2_98$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_22_CO2_98$datetime_EDT <- with_tz(WNJ_22_CO2_98$datetime_UTC, tzone = "America/New_York")

##### Load in the 2023 NEC tower .csv files #####
LEW_23_CH4_95 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/LEW-2023-ch4-95m-1-hour-v20250319.csv"
)
LEW_23_CH4_95$DATE <- as.Date(LEW_23_CH4_95$datetime_UTC)
LEW_23_CH4_95$HH <- sprintf("%02d:00:00", LEW_23_CH4_95$HH)
LEW_23_CH4_95$datetime_combined <- paste(LEW_23_CH4_95$DATE, LEW_23_CH4_95$HH)
LEW_23_CH4_95$datetime_UTC <- as.POSIXct(LEW_23_CH4_95$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_23_CH4_95$datetime_EDT <- with_tz(LEW_23_CH4_95$datetime_UTC, tzone = "America/New_York")

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

LEW_23_CO2_95 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/LEW-2023-co2-95m-1-hour-v20250319.csv'
)
LEW_23_CO2_95$DATE <- as.Date(LEW_23_CO2_95$datetime_UTC)
LEW_23_CO2_95$HH <- sprintf("%02d:00:00", LEW_23_CO2_95$HH)
LEW_23_CO2_95$datetime_combined <- paste(LEW_23_CO2_95$DATE, LEW_23_CO2_95$HH)
LEW_23_CO2_95$datetime_UTC <- as.POSIXct(LEW_23_CO2_95$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_23_CO2_95$datetime_EDT <- with_tz(LEW_23_CO2_95$datetime_UTC, tzone = "America/New_York")

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
TMD_23_CH4_113 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2023-ch4-113m-1-hour-v20250319.csv'
)
TMD_23_CH4_113$DATE <- as.Date(TMD_23_CH4_113$datetime_UTC)
TMD_23_CH4_113$HH <- sprintf("%02d:00:00", TMD_23_CH4_113$HH)
TMD_23_CH4_113$datetime_combined <- paste(TMD_23_CH4_113$DATE, TMD_23_CH4_113$HH)
TMD_23_CH4_113$datetime_UTC <- as.POSIXct(TMD_23_CH4_113$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
TMD_23_CH4_113$datetime_EDT <- with_tz(TMD_23_CH4_113$datetime_UTC, tzone = "America/New_York")

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

TMD_23_CO2_113 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/TMD-2023-co2-113m-1-hour-v20250319.csv'
)
TMD_23_CO2_113$DATE <- as.Date(TMD_23_CO2_113$datetime_UTC)
TMD_23_CO2_113$HH <- sprintf("%02d:00:00", TMD_23_CO2_113$HH)
TMD_23_CO2_113$datetime_combined <- paste(TMD_23_CO2_113$DATE, TMD_23_CO2_113$HH)
TMD_23_CO2_113$datetime_UTC <- as.POSIXct(TMD_23_CO2_113$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
TMD_23_CO2_113$datetime_EDT <- with_tz(TMD_23_CO2_113$datetime_UTC, tzone = "America/New_York")

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
BVA_23_CH4_111 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2023-ch4-111m-1-hour-v20250319.csv'
)
BVA_23_CH4_111$DATE <- as.Date(BVA_23_CH4_111$datetime_UTC)
BVA_23_CH4_111$HH <- sprintf("%02d:00:00", BVA_23_CH4_111$HH)
BVA_23_CH4_111$datetime_combined <- paste(BVA_23_CH4_111$DATE, BVA_23_CH4_111$HH)
BVA_23_CH4_111$datetime_UTC <- as.POSIXct(BVA_23_CH4_111$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
BVA_23_CH4_111$datetime_EDT <- with_tz(BVA_23_CH4_111$datetime_UTC, tzone = "America/New_York")

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

BVA_23_CO2_111 <- read.csv(
  '/Users/reneechabot-mehlin/Desktop/towers/BVA-2023-co2-111m-1-hour-v20250319.csv'
)
BVA_23_CO2_111$DATE <- as.Date(BVA_23_CO2_111$datetime_UTC)
BVA_23_CO2_111$HH <- sprintf("%02d:00:00", BVA_23_CO2_111$HH)
BVA_23_CO2_111$datetime_combined <- paste(BVA_23_CO2_111$DATE, BVA_23_CO2_111$HH)
BVA_23_CO2_111$datetime_UTC <- as.POSIXct(BVA_23_CO2_111$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
BVA_23_CO2_111$datetime_EDT <- with_tz(BVA_23_CO2_111$datetime_UTC, tzone = "America/New_York")

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
WNJ_23_CH4_98 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-ch4-98m-1-hour-v20250319.csv"
)
WNJ_23_CH4_98$DATE <- as.Date(WNJ_23_CH4_98$datetime_UTC)
WNJ_23_CH4_98$HH <- sprintf("%02d:00:00", WNJ_23_CH4_98$HH)
WNJ_23_CH4_98$datetime_combined <- paste(WNJ_23_CH4_98$DATE, WNJ_23_CH4_98$HH)
WNJ_23_CH4_98$datetime_UTC <- as.POSIXct(WNJ_23_CH4_98$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_23_CH4_98$datetime_EDT <- with_tz(WNJ_23_CH4_98$datetime_UTC, tzone = "America/New_York")

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
WNJ_23_CO2_98 <- read.csv(
  "/Users/reneechabot-mehlin/Desktop/towers/WNJ-2023-co2-98m-1-hour-v20250319.csv"
)
WNJ_23_CO2_98$DATE <- as.Date(WNJ_23_CO2_98$datetime_UTC)
WNJ_23_CO2_98$HH <- sprintf("%02d:00:00", WNJ_23_CO2_98$HH)
WNJ_23_CO2_98$datetime_combined <- paste(WNJ_23_CO2_98$DATE, WNJ_23_CO2_98$HH)
WNJ_23_CO2_98$datetime_UTC <- as.POSIXct(WNJ_23_CO2_98$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
WNJ_23_CO2_98$datetime_EDT <- with_tz(WNJ_23_CO2_98$datetime_UTC, tzone = "America/New_York")


##### Set time limit for basic plots #####
xlim_vals <- c(as.POSIXct("2023-10-12 08:00:00"),
               as.POSIXct("2023-10-17 18:00:00"))
##### Basic Plotting 2022 #####
#ch4____
plot(
  x = LEW_22_CH4_95$datetime_EDT,
  y = LEW_22_CH4_95$ch4_ppb,
  xlim = xlim_vals,
  ylim = c(1950, 2250),
  xlab = "Date (ETD)",
  ylab = "CH4 (ppb)",
  main = "NEC TOWER DATA",
  type = "b",
  col = "red",
  pch = 20
)
arrows(
  x0 = LEW_22_CH4_95$datetime_EDT,
  y0 = LEW_22_CH4_95$ch4_ppb - LEW_22_CH4_95$ch4_uncertainty,
  x1 = LEW_22_CH4_95$datetime_EDT,
  y1 = LEW_22_CH4_95$ch4_ppb + LEW_22_CH4_95$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "red"
)

# Add remaining lines and error bars
lines(
  LEW_22_CH4_50$datetime_EDT,
  LEW_22_CH4_50$ch4_ppb,
  type = "b",
  col = "darkred",
  pch = 20
)
arrows(
  LEW_22_CH4_50$datetime_EDT,
  LEW_22_CH4_50$ch4_ppb - LEW_22_CH4_50$ch4_uncertainty,
  LEW_22_CH4_50$datetime_EDT,
  LEW_22_CH4_50$ch4_ppb + LEW_22_CH4_50$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkred"
)

lines(
  TMD_22_CH4_113$datetime_EDT,
  TMD_22_CH4_113$ch4_ppb,
  type = "b",
  col = "green",
  pch = 20
)
arrows(
  TMD_22_CH4_113$datetime_EDT,
  TMD_22_CH4_113$ch4_ppb - TMD_22_CH4_113$ch4_uncertainty,
  TMD_22_CH4_113$datetime_EDT,
  TMD_22_CH4_113$ch4_ppb + TMD_22_CH4_113$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "green"
)

lines(
  TMD_22_CH4_49$datetime_EDT,
  TMD_22_CH4_49$ch4_ppb,
  type = "b",
  col = "darkgreen",
  pch = 20
)
arrows(
  TMD_22_CH4_49$datetime_EDT,
  TMD_22_CH4_49$ch4_ppb - TMD_22_CH4_49$ch4_uncertainty,
  TMD_22_CH4_49$datetime_EDT,
  TMD_22_CH4_49$ch4_ppb + TMD_22_CH4_49$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkgreen"
)

lines(
  BVA_22_CH4_111$datetime_EDT,
  BVA_22_CH4_111$ch4_ppb,
  type = "b",
  col = "lightblue",
  pch = 20
)
arrows(
  BVA_22_CH4_111$datetime_EDT,
  BVA_22_CH4_111$ch4_ppb - BVA_22_CH4_111$ch4_uncertainty,
  BVA_22_CH4_111$datetime_EDT,
  BVA_22_CH4_111$ch4_ppb + BVA_22_CH4_111$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "lightblue"
)

lines(
  BVA_22_CH4_50$datetime_EDT,
  BVA_22_CH4_50$ch4_ppb,
  type = "b",
  col = "blue",
  pch = 20
)
arrows(
  BVA_22_CH4_50$datetime_EDT,
  BVA_22_CH4_50$ch4_ppb - BVA_22_CH4_50$ch4_uncertainty,
  BVA_22_CH4_50$datetime_EDT,
  BVA_22_CH4_50$ch4_ppb + BVA_22_CH4_50$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "blue"
)

# Add description of error bars
mtext(
  "Vertical bars represent ±1 SD (standard deviation)",
  side = 1,
  line = 4,
  cex = 0.9
)

subset_ch4 <- function(df) {
  df$ch4_ppb[df$datetime_EDT >= xlim_vals[1] &
               df$datetime_EDT <= xlim_vals[2]]
}
ch4_dfs <- list(
  LEW_22_CH4_95,
  LEW_22_CH4_50,
  TMD_22_CH4_113,
  TMD_22_CH4_49,
  BVA_22_CH4_111,
  BVA_22_CH4_50
)

plotted_ch4 <- unlist(lapply(ch4_dfs, subset_ch4))

avg_ch4 <- mean(plotted_ch4, na.rm = TRUE)

abline(
  h = avg_ch4,
  col = "black",
  lty = 2,
  lwd = 3
)

# Add text in top-right corner
usr <- par("usr") # Get plot bounds
text(
  x = usr[2],
  y = usr[4],
  # near top right
  labels = paste0("Mean CH4: ", round(avg_ch4, 1), " ppb"),
  adj = c(1, 1),
  col = "black",
  cex = 0.9
)
plot.new()
# Add legend below plot
par(xpd = TRUE) # Allow drawing outside plot area
legend(
  "center",
  legend = c("LEW 95m", "LEW 50m", "TMD 113m", "TMD 49m", "BVA 111m", "BVA 50m"),
  title = "Legend",
  title.col = "black",
  col = c("red", "darkred", "green", "darkgreen", "lightblue", "blue"),
  pch = 20,
  lty = 1,
  bty = "n",
  cex = 0.9
)
par (xpd = FALSE)

#co2___
# Plot main dataset
plot(
  x = LEW_22_CO2_95$datetime_EDT,
  y = LEW_22_CO2_95$co2_ppm,
  xlim = xlim_vals,
  ylim = c(420, 460),
  xlab = "Date (ETD)",
  ylab = "CO2 (ppm)",
  main = "NEC TOWER DATA",
  type = "b",
  col = "red",
  pch = 20
)
arrows(
  x0 = LEW_22_CO2_95$datetime_EDT,
  y0 = LEW_22_CO2_95$co2_ppm - LEW_22_CO2_95$co2_uncertainty,
  x1 = LEW_22_CO2_95$datetime_EDT,
  y1 = LEW_22_CO2_95$co2_ppm + LEW_22_CO2_95$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "red"
)

# Add remaining lines and error bars
lines(
  LEW_22_CO2_50$datetime_EDT,
  LEW_22_CO2_50$co2_ppm,
  type = "b",
  col = "darkred",
  pch = 20
)
arrows(
  LEW_22_CO2_50$datetime_EDT,
  LEW_22_CO2_50$co2_ppm - LEW_22_CO2_50$co2_uncertainty,
  LEW_22_CO2_50$datetime_EDT,
  LEW_22_CO2_50$co2_ppm + LEW_22_CO2_50$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkred"
)

lines(
  TMD_22_CO2_113$datetime_EDT,
  TMD_22_CO2_113$co2_ppm,
  type = "b",
  col = "green",
  pch = 20
)
arrows(
  TMD_22_CO2_113$datetime_EDT,
  TMD_22_CO2_113$co2_ppm - TMD_22_CO2_113$co2_uncertainty,
  TMD_22_CO2_113$datetime_EDT,
  TMD_22_CO2_113$co2_ppm + TMD_22_CO2_113$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "green"
)

lines(
  TMD_22_CO2_49$datetime_EDT,
  TMD_22_CO2_49$co2_ppm,
  type = "b",
  col = "darkgreen",
  pch = 20
)
arrows(
  TMD_22_CO2_49$datetime_EDT,
  TMD_22_CO2_49$co2_ppm - TMD_22_CO2_49$co2_uncertainty,
  TMD_22_CO2_49$datetime_EDT,
  TMD_22_CO2_49$co2_ppm + TMD_22_CO2_49$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkgreen"
)

lines(
  BVA_22_CO2_111$datetime_EDT,
  BVA_22_CO2_111$co2_ppm,
  type = "b",
  col = "lightblue",
  pch = 20
)
arrows(
  BVA_22_CO2_111$datetime_EDT,
  BVA_22_CO2_111$co2_ppm - BVA_22_CO2_111$co2_uncertainty,
  BVA_22_CO2_111$datetime_EDT,
  BVA_22_CO2_111$co2_ppm + BVA_22_CO2_111$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "lightblue"
)

lines(
  BVA_22_CO2_50$datetime_EDT,
  BVA_22_CO2_50$co2_ppm,
  type = "b",
  col = "blue",
  pch = 20
)
arrows(
  BVA_22_CO2_50$datetime_EDT,
  BVA_22_CO2_50$co2_ppm - BVA_22_CO2_50$co2_uncertainty,
  BVA_22_CO2_50$datetime_EDT,
  BVA_22_CO2_50$co2_ppm + BVA_22_CO2_50$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "blue"
)

# Add description of error bars
mtext(
  "Vertical bars represent ±1 SD (standard deviation)",
  side = 1,
  line = 4,
  cex = 0.9
)

# Compute and draw mean CO2 line
subset_co2 <- function(df) {
  df$co2_ppm[df$datetime_EDT >= xlim_vals[1] &
               df$datetime_EDT <= xlim_vals[2]]
}
co2_dfs <- list(
  LEW_22_CO2_95,
  LEW_22_CO2_50,
  TMD_22_CO2_113,
  TMD_22_CO2_49,
  BVA_22_CO2_111,
  BVA_22_CO2_50
)

plotted_co2 <- unlist(lapply(co2_dfs, subset_co2))

avg_co2 <- mean(plotted_co2, na.rm = TRUE)

abline(
  h = avg_co2,
  col = "black",
  lty = 2,
  lwd = 3
)

# Add text in top-right corner
usr <- par("usr") # Get plot bounds
text(
  x = usr[2],
  y = usr[4],
  # near top right
  labels = paste0("Mean CO2: ", round(avg_co2, 1), " ppm"),
  adj = c(1, 1),
  col = "black",
  cex = 0.9
)
plot.new()
# Add legend below plot
par(xpd = TRUE) # Allow drawing outside plot area
legend(
  "center",
  legend = c("LEW 95m", "LEW 50m", "TMD 113m", "TMD 49m", "BVA 111m", "BVA 50m"),
  title = "Legend",
  title.col = "black",
  col = c("red", "darkred", "green", "darkgreen", "lightblue", "blue"),
  pch = 20,
  lty = 1,
  bty = "n",
  cex = 0.9
)

##### Basic Plotting 2023 #####
# Plot CH4 data
plot(
  x = LEW_23_CH4_95$datetime_EDT,
  y = LEW_23_CH4_95$ch4_ppb,
  xlim = xlim_vals,
  ylim = c(2000, 2070),
  xlab = "Date (ETD)",
  ylab = "CH4 (ppb)",
  main = "NEC TOWER DATA",
  type = "b",
  col = "red",
  pch = 20
)
arrows(
  x0 = LEW_23_CH4_95$datetime_EDT,
  y0 = LEW_23_CH4_95$ch4_ppb - LEW_23_CH4_95$ch4_uncertainty,
  x1 = LEW_23_CH4_95$datetime_EDT,
  y1 = LEW_23_CH4_95$ch4_ppb + LEW_23_CH4_95$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "red"
)

# Add remaining lines and error bars
lines(
  LEW_23_CH4_50$datetime_EDT,
  LEW_23_CH4_50$ch4_ppb,
  type = "b",
  col = "darkred",
  pch = 20
)
arrows(
  LEW_23_CH4_50$datetime_EDT,
  LEW_23_CH4_50$ch4_ppb - LEW_23_CH4_50$ch4_uncertainty,
  LEW_23_CH4_50$datetime_EDT,
  LEW_23_CH4_50$ch4_ppb + LEW_23_CH4_50$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkred"
)

lines(
  TMD_23_CH4_113$datetime_EDT,
  TMD_23_CH4_113$ch4_ppb,
  type = "b",
  col = "green",
  pch = 20
)
arrows(
  TMD_23_CH4_113$datetime_EDT,
  TMD_23_CH4_113$ch4_ppb - TMD_23_CH4_113$ch4_uncertainty,
  TMD_23_CH4_113$datetime_EDT,
  TMD_23_CH4_113$ch4_ppb + TMD_23_CH4_113$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "green"
)

lines(
  TMD_23_CH4_49$datetime_EDT,
  TMD_23_CH4_49$ch4_ppb,
  type = "b",
  col = "darkgreen",
  pch = 20
)
arrows(
  TMD_23_CH4_49$datetime_EDT,
  TMD_23_CH4_49$ch4_ppb - TMD_23_CH4_49$ch4_uncertainty,
  TMD_23_CH4_49$datetime_EDT,
  TMD_23_CH4_49$ch4_ppb + TMD_23_CH4_49$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkgreen"
)

lines(
  BVA_23_CH4_111$datetime_EDT,
  BVA_23_CH4_111$ch4_ppb,
  type = "b",
  col = "lightblue",
  pch = 20
)
arrows(
  BVA_23_CH4_111$datetime_EDT,
  BVA_23_CH4_111$ch4_ppb - BVA_23_CH4_111$ch4_uncertainty,
  BVA_23_CH4_111$datetime_EDT,
  BVA_23_CH4_111$ch4_ppb + BVA_23_CH4_111$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "lightblue"
)

lines(
  BVA_23_CH4_50$datetime_EDT,
  BVA_23_CH4_50$ch4_ppb,
  type = "b",
  col = "blue",
  pch = 20
)
arrows(
  BVA_23_CH4_50$datetime_EDT,
  BVA_23_CH4_50$ch4_ppb - BVA_23_CH4_50$ch4_uncertainty,
  BVA_23_CH4_50$datetime_EDT,
  BVA_23_CH4_50$ch4_ppb + BVA_23_CH4_50$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "blue"
)

mtext(
  "Vertical bars represent ±1 SD (standard deviation)",
  side = 1,
  line = 4,
  cex = 0.9
)

subset_ch4 <- function(df) {
  df$ch4_ppb[df$datetime_EDT >= xlim_vals[1] &
               df$datetime_EDT <= xlim_vals[2]]
}
ch4_dfs <- list(
  LEW_23_CH4_95,
  LEW_23_CH4_50,
  TMD_23_CH4_113,
  TMD_23_CH4_49,
  BVA_23_CH4_111,
  BVA_23_CH4_50
)

plotted_ch4 <- unlist(lapply(ch4_dfs, subset_ch4))
avg_ch4 <- mean(plotted_ch4, na.rm = TRUE)

abline(
  h = avg_ch4,
  col = "black",
  lty = 2,
  lwd = 3
)

usr <- par("usr")
text(
  x = usr[2],
  y = usr[4],
  labels = paste0("Mean CH4: ", round(avg_ch4, 1), " ppb"),
  adj = c(1, 1),
  col = "black",
  cex = 0.9
)
plot.new()

par(xpd = TRUE)
legend(
  "center",
  legend = c("LEW 95m", "LEW 50m", "TMD 113m", "TMD 49m", "BVA 111m", "BVA 50m"),
  title = "Legend",
  title.col = "black",
  col = c("red", "darkred", "green", "darkgreen", "lightblue", "blue"),
  pch = 20,
  lty = 1,
  bty = "n",
  cex = 0.9
)
par(xpd = FALSE)

# Plot CO2 data
plot(
  x = LEW_23_CO2_95$datetime_EDT,
  y = LEW_23_CO2_95$co2_ppm,
  xlim = xlim_vals,
  ylim = c(420, 430),
  xlab = "Date (ETD)",
  ylab = "CO2 (ppm)",
  main = "NEC TOWER DATA",
  type = "b",
  col = "red",
  pch = 20
)
arrows(
  x0 = LEW_23_CO2_95$datetime_EDT,
  y0 = LEW_23_CO2_95$co2_ppm - LEW_23_CO2_95$co2_uncertainty,
  x1 = LEW_23_CO2_95$datetime_EDT,
  y1 = LEW_23_CO2_95$co2_ppm + LEW_23_CO2_95$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "red"
)

lines(
  LEW_23_CO2_50$datetime_EDT,
  LEW_23_CO2_50$co2_ppm,
  type = "b",
  col = "darkred",
  pch = 20
)
arrows(
  LEW_23_CO2_50$datetime_EDT,
  LEW_23_CO2_50$co2_ppm - LEW_23_CO2_50$co2_uncertainty,
  LEW_23_CO2_50$datetime_EDT,
  LEW_23_CO2_50$co2_ppm + LEW_23_CO2_50$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkred"
)

lines(
  TMD_23_CO2_113$datetime_EDT,
  TMD_23_CO2_113$co2_ppm,
  type = "b",
  col = "green",
  pch = 20
)
arrows(
  TMD_23_CO2_113$datetime_EDT,
  TMD_23_CO2_113$co2_ppm - TMD_23_CO2_113$co2_uncertainty,
  TMD_23_CO2_113$datetime_EDT,
  TMD_23_CO2_113$co2_ppm + TMD_23_CO2_113$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "green"
)

lines(
  TMD_23_CO2_49$datetime_EDT,
  TMD_23_CO2_49$co2_ppm,
  type = "b",
  col = "darkgreen",
  pch = 20
)
arrows(
  TMD_23_CO2_49$datetime_EDT,
  TMD_23_CO2_49$co2_ppm - TMD_23_CO2_49$co2_uncertainty,
  TMD_23_CO2_49$datetime_EDT,
  TMD_23_CO2_49$co2_ppm + TMD_23_CO2_49$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkgreen"
)

lines(
  BVA_23_CO2_111$datetime_EDT,
  BVA_23_CO2_111$co2_ppm,
  type = "b",
  col = "lightblue",
  pch = 20
)
arrows(
  BVA_23_CO2_111$datetime_EDT,
  BVA_23_CO2_111$co2_ppm - BVA_23_CO2_111$co2_uncertainty,
  BVA_23_CO2_111$datetime_EDT,
  BVA_23_CO2_111$co2_ppm + BVA_23_CO2_111$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "lightblue"
)

lines(
  BVA_23_CO2_50$datetime_EDT,
  BVA_23_CO2_50$co2_ppm,
  type = "b",
  col = "blue",
  pch = 20
)
arrows(
  BVA_23_CO2_50$datetime_EDT,
  BVA_23_CO2_50$co2_ppm - BVA_23_CO2_50$co2_uncertainty,
  BVA_23_CO2_50$datetime_EDT,
  BVA_23_CO2_50$co2_ppm + BVA_23_CO2_50$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "blue"
)

mtext(
  "Vertical bars represent ±1 SD (standard deviation)",
  side = 1,
  line = 4,
  cex = 0.9
)

subset_co2 <- function(df) {
  df$co2_ppm[df$datetime_EDT >= xlim_vals[1] &
               df$datetime_EDT <= xlim_vals[2]]
}
co2_dfs <- list(
  LEW_23_CO2_95,
  LEW_23_CO2_50,
  TMD_23_CO2_113,
  TMD_23_CO2_49,
  BVA_23_CO2_111,
  BVA_23_CO2_50
)

plotted_co2 <- unlist(lapply(co2_dfs, subset_co2))
avg_co2 <- mean(plotted_co2, na.rm = TRUE)

abline(
  h = avg_co2,
  col = "black",
  lty = 2,
  lwd = 3
)

usr <- par("usr")
text(
  x = usr[2],
  y = usr[4],
  labels = paste0("Mean CO2: ", round(avg_co2, 1), " ppm"),
  adj = c(1, 1),
  col = "black",
  cex = 0.9
)
plot.new()

par(xpd = TRUE)
legend(
  "center",
  legend = c("LEW 95m", "LEW 50m", "TMD 113m", "TMD 49m", "BVA 111m", "BVA 50m"),
  title = "Legend",
  title.col = "black",
  col = c("red", "darkred", "green", "darkgreen", "lightblue", "blue"),
  pch = 20,
  lty = 1,
  bty = "n",
  cex = 0.9
)
par(xpd = FALSE)


##### _____________________2. Adding Models _______________________________#####
##### Averaging data for 3 hour intervals 2022 #####
#3 hr avg__
all_data <- list(
  LEW_22_CH4_50 = LEW_22_CH4_50,
  LEW_22_CH4_95 = LEW_22_CH4_95,
  LEW_22_CO2_50 = LEW_22_CO2_50,
  LEW_22_CO2_95 = LEW_22_CO2_95,
  TMD_22_CH4_113 = TMD_22_CH4_113,
  TMD_22_CH4_49 = TMD_22_CH4_49,
  TMD_22_CO2_113 = TMD_22_CO2_113,
  TMD_22_CO2_49 = TMD_22_CO2_49,
  BVA_22_CH4_111 = BVA_22_CH4_111,
  BVA_22_CH4_50 = BVA_22_CH4_50,
  BVA_22_CO2_111 = BVA_22_CO2_111,
  BVA_22_CO2_50 = BVA_22_CO2_50,
  WNJ_22_CO2_98 = WNJ_22_CO2_98,
  WNJ_22_CO2_43 = WNJ_22_CO2_43,
  WNJ_22_CH4_98 = WNJ_22_CH4_98,
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
  LEW_23_CH4_95 = LEW_23_CH4_95,
  LEW_23_CO2_50 = LEW_23_CO2_50,
  LEW_23_CO2_95 = LEW_23_CO2_95,
  TMD_23_CH4_113 = TMD_23_CH4_113,
  TMD_23_CH4_49 = TMD_23_CH4_49,
  TMD_23_CO2_113 = TMD_23_CO2_113,
  TMD_23_CO2_49 = TMD_23_CO2_49,
  BVA_23_CH4_111 = BVA_23_CH4_111,
  BVA_23_CH4_50 = BVA_23_CH4_50,
  BVA_23_CO2_111 = BVA_23_CO2_111,
  BVA_23_CO2_50 = BVA_23_CO2_50,
  WNJ_23_CO2_98 = WNJ_23_CO2_98,
  WNJ_23_CO2_43 = WNJ_23_CO2_43,
  WNJ_23_CH4_98 = WNJ_23_CH4_98,
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
start_date <- as.Date("2022-10-18")
end_date <- as.Date("2022-10-19")

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

cruise <- "Cruise 14"
cruise_squish <- tolower(gsub(" ", "", cruise))


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
    '/Volumes/Seagate/',
    cruise_squish,
    '_eulerian/carbon_tracker_co2_total'
  ),
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
    '/Volumes/Seagate/',
    cruise_squish,
    '_eulerian/carbon_tracker_ch4_total'
  ),
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
  rounded_hours <- floor(hours / 3) * 3 #chosing floor instead of ceiling so 01:30 -> 00:00
  dates_posix_aligned <- as.POSIXct(paste0(
    format(dates_posix, "%Y-%m-%d "),
    sprintf("%02d:00:00", rounded_hours)
  ), tz = "UTC")
  
  library(terra)
  vals <- extract(r_brick, coords)
  
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
  vals <- extract(r_brick, coords)
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
  paste0(
    '/Volumes/Seagate/',
    cruise_squish,
    '_eulerian/cams_global_inversion_optimized_ghg_fluxes'
  ),
  pattern = '\\.nc$',
  full.names = TRUE
)

#for computer usage
# files <- list.files(
#   "/Users/reneechabot-mehlin/Desktop/towers/models/cruise24/cams_global_inversion_optimized_ghg_fluxes",
#   pattern = "\\.nc$",
#   full.names = T
# )


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
  
  vals <- extract(r_stack, coords)
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


##### Plotting against CT and CAMS #####
#CO2
merged_co2_list <- list()
for (abriv in unique(matched_rows$SiteCode)) {
  site = abriv
  filtered_cams_co2 <- cams_CO2 %>% filter(SiteCode == site)
  filtered_obs_co2 <- obs_co2 %>% filter(substr(source, 1, 3) == site)
  filtered_ct_co2 <- CT_CO2_df %>% filter(SiteCode == site)
  
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
  
  filtered_obs_co2$datetime <- as.POSIXct(paste(filtered_obs_co2$date, interval_starts[filtered_obs_co2$interval]), tz = "UTC")
  filtered_obs_co2$height <- sub(".*_(\\d+)$", "\\1", filtered_obs_co2$source)
  heights <- unique(filtered_obs_co2$height)
  colors <- c("cyan", "green")
  
  filtered_cams_co2 <- filtered_cams_co2[order(filtered_cams_co2$Timestamp), ]
  filtered_obs_co2  <- filtered_obs_co2[order(filtered_obs_co2$datetime), ]
  filtered_ct_co2 <- filtered_ct_co2[order(filtered_ct_co2$date), ]
  
  all_y <- c(filtered_cams_co2$Value,
             filtered_ct_co2$co2,
             filtered_obs_co2$co2_ppm)
  y_pad <- diff(range(all_y, na.rm = T)) * 0.05
  
  par(mfrow = c(2, 1), mar = c(2, 2, 2, 2))
  plot(
    filtered_cams_co2$Timestamp,
    filtered_cams_co2$Value,
    col = "darkblue",
    type = "b",
    pch = 20,
    xlab = "Date",
    ylab = "CO2 (ppm)",
    main = paste(cruise, "-", "A comparison of models v obs. CO2 at", site),
    ylim = range(all_y, na.rm = T)
  )
  for (i in seq_along(heights)) {
    subset_obs <- filtered_obs_co2[filtered_obs_co2$height == heights[i], ]
    lines(
      subset_obs$datetime,
      subset_obs$co2_ppm,
      col = colors[i],
      type = "b",
      pch = 20
    )
  }
  lines(
    filtered_ct_co2$date,
    filtered_ct_co2$co2,
    col = "red",
    type = "b",
    pch = 20
  )
  
  plot.new()
  legend(
    "center",
    legend = c("CAMs", paste("Obs", heights, "m"), "CT"),
    col    = c("darkblue", colors[seq_along(heights)], "red"),
    pch    = 20,
    lty    = 1,
    cex    = 0.55,
    title  = "Legend",
    horiz = T
  )
  
  
  filtered_cams_co2$DATE <- filtered_cams_co2$Timestamp
  filtered_obs_co2$DATE  <- filtered_obs_co2$datetime
  filtered_ct_co2$DATE <- filtered_ct_co2$date
  
  names(filtered_cams_co2)[names(filtered_cams_co2) == "Value"] <- "CAMs_CO2"
  names(filtered_obs_co2)[names(filtered_obs_co2) == "co2_ppm"] <- "Obs_CO2_ppm"
  names(filtered_ct_co2)[names(filtered_ct_co2) == "co2"] <- "CT_CO2"
  
  filtered_cams_co2$SiteCode <- site
  filtered_ct_co2$SiteCode   <- site
  filtered_obs_co2$SiteCode  <- site
  
  merged_temp <- merge(filtered_cams_co2,
                       filtered_ct_co2,
                       by = "DATE",
                       all = TRUE)
  merged_co2 <- merge(merged_temp,
                      filtered_obs_co2,
                      by = "DATE",
                      all = TRUE)
  
  merged_co2 <- merged_co2[, c("DATE", "SiteCode", "CAMs_CO2", "Obs_CO2_ppm", "CT_CO2")]
  
  merged_co2_list[[site]] <- merged_co2
  
}

#CH4
merged_ch4_list <- list()
for (abriv in unique(matched_rows$SiteCode)) {
  site = abriv
  filtered_cams_ch4 <- cams_CH4 %>% filter(SiteCode == site)
  filtered_obs_ch4 <- obs_ch4 %>% filter(substr(source, 1, 3) == site)
  filtered_ct_ch4 <- CT_CH4_df %>% filter(SiteCode == site)
  
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
  
  filtered_obs_ch4$datetime <- as.POSIXct(paste(filtered_obs_ch4$date, interval_starts[filtered_obs_ch4$interval]), tz = "UTC")
  filtered_obs_ch4$height <- sub(".*_(\\d+)$", "\\1", filtered_obs_ch4$source)
  heights <- unique(filtered_obs_ch4$height)
  colors <- c("cyan", "green")
  
  filtered_cams_ch4 <- filtered_cams_ch4[order(filtered_cams_ch4$Timestamp), ]
  filtered_obs_ch4  <- filtered_obs_ch4[order(filtered_obs_ch4$datetime), ]
  filtered_ct_ch4 <- filtered_ct_ch4[order(filtered_ct_ch4$date), ]
  
  all_y <- c(filtered_cams_ch4$Value,
             filtered_ct_ch4$ch4,
             filtered_obs_ch4$ch4_ppb)
  y_pad <- diff(range(all_y, na.rm = T)) * 0.05
  
  par(mfrow = c(2, 1), mar = c(2, 2, 2, 2))
  plot(
    filtered_cams_ch4$Timestamp,
    filtered_cams_ch4$Value,
    col = "darkblue",
    type = "b",
    pch = 20,
    xlab = "Date",
    ylab = "CH4 (ppb)",
    main = paste(cruise, "-", "A comparison of models v obs. CH4 at", site),
    ylim = range(all_y, na.rm = T)
  )
  for (i in seq_along(heights)) {
    subset_obs <- filtered_obs_ch4[filtered_obs_ch4$height == heights[i], ]
    lines(
      subset_obs$datetime,
      subset_obs$ch4_ppb,
      col = colors[i],
      type = "b",
      pch = 20
    )
  }
  lines(
    filtered_ct_ch4$date,
    filtered_ct_ch4$ch4,
    col = "red",
    type = "b",
    pch = 20
  )
  
  plot.new()
  legend(
    "center",
    legend = c("CAMs", paste("Obs", heights, "m"), "CT"),
    col    = c("darkblue", colors[seq_along(heights)], "red"),
    pch    = 20,
    lty    = 1,
    cex    = 0.55,
    title  = "Legend",
    horiz = T
  )
  
  
  filtered_cams_ch4$DATE <- filtered_cams_ch4$Timestamp
  filtered_obs_ch4$DATE  <- filtered_obs_ch4$datetime
  filtered_ct_ch4$DATE <- filtered_ct_ch4$date
  
  names(filtered_cams_ch4)[names(filtered_cams_ch4) == "Value"] <- "CAMs_CH4"
  names(filtered_obs_ch4)[names(filtered_obs_ch4) == "ch4_ppb"] <- "Obs_CH4_ppb"
  names(filtered_ct_ch4)[names(filtered_ct_ch4) == "ch4"] <- "CT_CH4"
  
  filtered_cams_ch4$SiteCode <- site
  filtered_ct_ch4$SiteCode   <- site
  filtered_obs_ch4$SiteCode  <- site
  
  merged_temp <- merge(filtered_cams_ch4,
                       filtered_ct_ch4,
                       by = "DATE",
                       all = TRUE)
  merged_ch4 <- merge(merged_temp,
                      filtered_obs_ch4,
                      by = "DATE",
                      all = TRUE)
  
  merged_ch4 <- merged_ch4[, c("DATE", "SiteCode", "CAMs_CH4", "Obs_CH4_ppb", "CT_CH4")]
  
  merged_ch4_list[[site]] <- merged_ch4
  
}

##### Saving .csv files #####

output_dir <- paste0("/Volumes/Seagate/", cruise_squish, "_eulerian/towers")

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

for (abriv in unique(matched_rows$SiteCode)) {
  write.csv(
    merged_co2_list[[abriv]],
    paste0(
      output_dir, "/merged_co2_",
      cruise_squish, "_", abriv, ".csv"
    ),
    row.names = FALSE
  )
}

for (abriv in unique(matched_rows$SiteCode)) {
  write.csv(
    merged_ch4_list[[abriv]],
    paste0(
      output_dir, "/merged_ch4_",
      cruise_squish, "_", abriv, ".csv"
    ),
    row.names = FALSE
  )
}

##### _____________________________________________________________________#####
