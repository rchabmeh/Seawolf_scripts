##### ____________________________________#####
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

#____
# UNY_22_CH4_68 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-ch4-68m-1-hour-20230425.csv')
# UNY_22_CH4_68$DATE <- as.Date(UNY_22_CH4_68$datetime_UTC)
# UNY_22_CH4_68$HH <- sprintf("%02d:00:00", UNY_22_CH4_68$HH)
# UNY_22_CH4_68$datetime_combined <- paste(UNY_22_CH4_68$DATE, UNY_22_CH4_68$HH)
# UNY_22_CH4_68$datetime_UTC <- as.POSIXct(UNY_22_CH4_68$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
# library(lubridate)
# UNY_22_CH4_68$datetime_EDT <- with_tz(UNY_22_CH4_68$datetime_UTC, tzone = "America/New_York")
#
# UNY_22_CH4_60 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-ch4-60m-1-hour-20230425.csv')
# UNY_22_CH4_60$DATE <- as.Date(UNY_22_CH4_60$datetime_UTC)
# UNY_22_CH4_60$HH <- sprintf("%02d:00:00", UNY_22_CH4_60$HH)
# UNY_22_CH4_60$datetime_combined <- paste(UNY_22_CH4_60$DATE, UNY_22_CH4_60$HH)
# UNY_22_CH4_60$datetime_UTC <- as.POSIXct(UNY_22_CH4_60$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
# library(lubridate)
# UNY_22_CH4_60$datetime_EDT <- with_tz(UNY_22_CH4_60$datetime_UTC, tzone = "America/New_York")

# UNY_22_CO2_68 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-co2-68m-1-hour-20230425.csv')
# UNY_22_CO2_60 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-co2-60m-1-hour-20230425.csv')

#___
# SNJ_22_CH4_53 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-ch4-53m-1-hour-20230425.csv')
# SNJ_22_CH4_53$DATE <- as.Date(SNJ_22_CH4_53$datetime_UTC)
# SNJ_22_CH4_53$HH <- sprintf("%02d:00:00", SNJ_22_CH4_53$HH)
# SNJ_22_CH4_53$datetime_combined <- paste(SNJ_22_CH4_53$DATE, SNJ_22_CH4_53$HH)
# SNJ_22_CH4_53$datetime_UTC <- as.POSIXct(SNJ_22_CH4_53$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
# library(lubridate)
# SNJ_22_CH4_53$datetime_EDT <- with_tz(SNJ_22_CH4_53$datetime_UTC, tzone = "America/New_York")
#
# SNJ_22_CH4_42 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-ch4-42m-1-hour-20230425.csv')
# SNJ_22_CH4_42$DATE <- as.Date(SNJ_22_CH4_42$datetime_UTC)
# SNJ_22_CH4_42$HH <- sprintf("%02d:00:00", SNJ_22_CH4_42$HH)
# SNJ_22_CH4_42$datetime_combined <- paste(SNJ_22_CH4_42$DATE, SNJ_22_CH4_42$HH)
# SNJ_22_CH4_42$datetime_UTC <- as.POSIXct(SNJ_22_CH4_42$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
# library(lubridate)
# SNJ_22_CH4_42$datetime_EDT <- with_tz(SNJ_22_CH4_42$datetime_UTC, tzone = "America/New_York")
#
#  SNJ_22_CO2_53 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-co2-53m-1-hour-20230425.csv')
#  SNJ_22_CO2_53$DATE <- as.Date(SNJ_22_CO2_53$datetime_UTC)
#  SNJ_22_CO2_53$HH <- sprintf("%02d:00:00", SNJ_22_CO2_53$HH)
#  SNJ_22_CO2_53$datetime_combined <- paste(SNJ_22_CO2_53$DATE, SNJ_22_CO2_53$HH)
#  SNJ_22_CO2_53$datetime_UTC <- as.POSIXct(SNJ_22_CO2_53$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
#  library(lubridate)
#  SNJ_22_CO2_53$datetime_EDT <- with_tz(SNJ_22_CO2_53$datetime_UTC, tzone = "America/New_York")
#
#  SNJ_22_CO2_42 <- read.csv('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-co2-42m-1-hour-20230425.csv')
#  SNJ_22_CO2_42$DATE <- as.Date(SNJ_22_CO2_42$datetime_UTC)
#  SNJ_22_CO2_42$HH <- sprintf("%02d:00:00", SNJ_22_CO2_42$HH)
#  SNJ_22_CO2_42$datetime_combined <- paste(SNJ_22_CO2_42$DATE, SNJ_22_CO2_42$HH)
#  SNJ_22_CO2_42$datetime_UTC <- as.POSIXct(SNJ_22_CO2_42$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
#  library(lubridate)
#  SNJ_22_CO2_42$datetime_EDT <- with_tz(SNJ_22_CO2_42$datetime_UTC, tzone = "America/New_York")
#
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

##### Set time limit for basic plots #####
xlim_vals <- c(as.POSIXct("2023-10-12 10:00:00"),
               as.POSIXct("2023-10-17 13:00:00"))
##### Basic Plotting 2022 #####
#ch4____
plot(
  x = LEW_22_CH4_95$datetime_EDT,
  y = LEW_22_CH4_95$ch4_ppb,
  xlim = xlim_vals,
  ylim = c(2020, 2100),
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
  ylim = c(420, 430),
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


##### ____________________________________#####
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
  BVA_22_CO2_50 = BVA_22_CO2_50
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

prefixes <- c("TMD", "LEW", "BVA")
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
  BVA_23_CO2_50 = BVA_23_CO2_50
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

prefixes <- c("TMD", "LEW", "BVA")
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
start_date <- as.Date("2023-10-12")
end_date <- as.Date("2023-10-17")

# Filter averaged_data to time period of interest
datetime_filtered_data <- lapply(averaged_data, function(df) {
  df$date <- as.Date(df$date)
  df[df$date >= start_date & df$date <= end_date, ]
})

##### Loading in CarbonTracker #####
library(raster)

cruise <- "Cruise 24"
cruise_squish <- tolower(gsub(" ", "", cruise))

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

CTCO2_lists <- lapply(1:8, function(k)
  lapply(CT_CO2, function(x)
    x[[k]]))
CTCH4_lists <- lapply(1:8, function(k)
  lapply(CT_CH4, function(x)
    x[[k]]))

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

datetime_with_ct <- lapply(datetime_filtered_data, function(df) {
  if (!nrow(df))
    return(NULL)  # skip empty
  
  co2_vals <- numeric(nrow(df))
  ch4_vals <- numeric(nrow(df))
  
  for (j in seq_len(nrow(df))) {
    date_j <- as.Date(df$date[j])
    interval_j <- df$interval[j]
    lat <- df$Lat[j]
    lon <- df$Lon[j]
    
    interval_index <- match(interval_j, interval_labels)
    if (is.na(interval_index))
      next
    
    formatted_name <- format(date_j, "X%Y.%m.%d")
    date_index <- which(sapply(CTCO2_lists[[interval_index]], function(r) {
      grepl(formatted_name, names(r))
    }))
    
    if (length(date_index) == 1) {
      r_co2 <- CTCO2_lists[[interval_index]][[date_index]]
      r_ch4 <- CTCH4_lists[[interval_index]][[date_index]]
      co2_vals[j] <- raster::extract(r_co2, matrix(c(lon, lat), ncol = 2))
      ch4_vals[j] <- raster::extract(r_ch4, matrix(c(lon, lat), ncol = 2))
    } else {
      co2_vals[j] <- NA
      ch4_vals[j] <- NA
    }
  }
  
  df$co2_ct <- co2_vals
  df$ch4_ct <- ch4_vals
  
  na.omit(df)
})

datetime_with_ct <- Filter(function(x)
  ! is.null(x) && nrow(x) > 0, datetime_with_ct)

common_names <- Reduce(intersect, lapply(datetime_with_ct, names))
datetime_with_ct <- lapply(datetime_with_ct, function(df)
  df[, common_names, drop = FALSE])

final_df <- do.call(rbind, datetime_with_ct)

###### Loading in CAMS information ######

## alt approach 8/11/25 ##
library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)
cruise <- "Cruise 24" #add cruise number
cruise_squish <- tolower(gsub(" ", "", cruise))
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
states <- st_read(
  "/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
east_coast_states <- c(
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states)
east_extent <- extent(-85, -65, 25, 47)

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
  
  # Ensure CRS matches shapefile
  if (is.na(crs(r))) {
    crs(r) <- st_crs(east_states_sf)$proj4string
  }
  
  # Crop and mask
  r <- crop(r, east_extent)
  r <- mask(r, east_states_sf)
  
  # Unit fix for CO2
  if (var_to_use == "CO2") {
    r <- calc(r, function(x)
      x * 1e6)
  }
  
  file_key <- basename(f)  # Use file name as key
  CAMS[[file_key]] <- r
  all_timestamps[[file_key]] <- timestamps
}

library(raster)
library(lubridate)

extract_cams_value <- function(lat, lon, datetime, raster_stack, layer_times) {
  # Find closest layer index
  time_diffs <- abs(difftime(layer_times, datetime, units = "secs"))
  closest_layer <- which.min(time_diffs)
  
  # Extract the raster layer
  rast_layer <- raster_stack[[closest_layer]]
  
  # Extract value at (lon, lat) — order is (x=lon, y=lat)
  value <- raster::extract(rast_layer, matrix(c(lon, lat), ncol = 2))
  
  return(value)
}

final_df$co2_cams <- mapply(
  extract_cams_value,
  lat = final_df$Lat,
  lon = final_df$Lon,
  datetime = final_df$date,
  MoreArgs = list(
    raster_stack = r,
    layer_times = all_timestamps
  )
)


## end alt approach 8/11/25 ##
  
library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)
cruise <- "Cruise 24" #add cruise number
cruise_squish <- tolower(gsub(" ", "", cruise))
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
states <- st_read(
  "/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
east_coast_states <- c(
  "Maine",
  "New Hampshire",
  "Massachusetts",
  "Rhode Island",
  "Connecticut",
  "New York",
  "New Jersey",
  "Delaware",
  "Maryland",
  "Virginia",
  "North Carolina",
  "South Carolina",
  "Georgia",
  "Florida",
  "Pennsylvania",
  "Vermont"
)
east_states_sf <- states %>%
  filter(NAME %in% east_coast_states)
east_extent <- extent(-85, -65, 25, 47)

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
  
  # Ensure CRS matches shapefile
  if (is.na(crs(r))) {
    crs(r) <- st_crs(east_states_sf)$proj4string
  }
  
  # Crop and mask
  r <- crop(r, east_extent)
  r <- mask(r, east_states_sf)
  
  # Unit fix for CO2
  if (var_to_use == "CO2") {
    r <- calc(r, function(x)
      x * 1e6)
  }
  
  file_key <- basename(f)  # Use file name as key
  CAMS[[file_key]] <- r
  all_timestamps[[file_key]] <- timestamps
}
east_states_sf <- st_transform(east_states_sf, crs = st_crs(CAMS[[1]]))
CAMS_df_list <- lapply(names(CAMS), function(file_key) {
  ras <- CAMS[[file_key]]
  
  if (is.null(ras)) {
    message("[", file_key, "] Raster is NULL — skipping.")
    return(NULL)
  }
  df <- as.data.frame(ras, xy = TRUE)
  df <- na.omit(df)
  # Example dataframe df with first two columns lon, lat and the rest timestamp columns
  # Rename only from column 3 onward
  if (ncol(df) < 3)
    return(NULL)
  
  names(df)[3:ncol(df)] <- {
    cn <- names(df)[3:ncol(df)]         # subset column names
    cn <- sub("^X", "", cn)             # remove leading X
    
    # Use regmatches + regexec to extract date/time parts
    parts <- regmatches(cn,
                        regexec("^([0-9]{4})\\.([0-9]{2})\\.([0-9]{2})(.*)$", cn))
    
    sapply(parts, function(p) {
      if (length(p) == 0)
        return(NA_character_)
      date_part <- paste0(p[2], "-", p[3], "-", p[4])
      time_part <- p[5]
      if (time_part == "") {
        time_part <- " 00:00:00"
      } else {
        time_part <- gsub("\\.", ":", sub("^\\.", " ", time_part))
      }
      paste0(date_part, time_part)
    })
  }
  bad_cols <- which(is.na(names(df)))
  if (length(bad_cols) > 0) {
    df <- df[, -bad_cols, drop = FALSE]
  }
  
  if (ncol(df) < 3)
    return(NULL)  # no data columns left
  
  library(tidyr)
  df_long <- pivot_longer(
    df,
    cols = -(1:2),
    # all columns except lat and long
    names_to = "date",
    # new column name for former column headers
    values_to = "concentration"  # new column name for values
  )
 # df_long$date <- as.POSIXct(df_long$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  df_long$gas <- ifelse(grepl("CO2", file_key, ignore.case = TRUE), "CO2", "CH4")
  df_long$source <- file_key
  
  df_long
})

CAMS_combined <- do.call(rbind, CAMS_df_list)
CAMS_combined$date <- as.POSIXct(CAMS_combined$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
CAMS_combined <- CAMS_combined[CAMS_combined$date >= start_date & CAMS_combined$date <= end_date, ]

CAMS_combined <- CAMS_combined %>%
  mutate(window_start = floor_date(date, unit = "6 hours"))

CAMS_split <- split(CAMS_combined, CAMS_combined$gas)
CAMS_CO2_df <- CAMS_split[["CO2"]]
CAMS_CH4_df <- CAMS_split[["CH4"]]


## edits below 8/11/25 ##

names(CAMS_CO2_df)[names(CAMS_CO2_df) == "x"] <- "Lon"
names(CAMS_CO2_df)[names(CAMS_CO2_df) == "y"] <- "Lat"

names(CAMS_CH4_df)[names(CAMS_CH4_df) == "x"] <- "Lon"
names(CAMS_CH4_df)[names(CAMS_CH4_df) == "y"] <- "Lat"

library(dplyr)
library(lubridate)
library(stringr)

# Prepare the CAMS_CH4 data: create window_start and keep lat/lon
final_df$date <-as.POSIXct(final_df$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
final_df <- final_df %>%
  mutate(window_start = floor_date(date, unit = "6 hours"))
joined <- final_df %>%
  left_join(CAMS_CH4_df, by = c("window_start", "Lat", "Lon"))


###alt approach


grid_data_ch4 <- CAMS_CH4_df %>%
  mutate(
    window_start_ch4 = floor_date(date, unit = "6 hours"),
    Lon_round = round(Lon, 4),
    Lat_round = round(Lat, 4)
  ) %>%
  group_by(window_start_ch4, Lon_round, Lat_round) %>%
  summarise(ch4_conc_cams = mean(concentration, na.rm = TRUE) / 1000, .groups = "drop")
grid_data_ch4$window_start_ch4 <- as.Date(grid_data_ch4$window_start_ch4)

final_df <- final_df %>%
  mutate(
    window_start_ch4 = floor_date(date, unit = "6 hours")
  )
final_df$Lon_round <- round(final_df$Lon, 1)
final_df$Lat_round <- round(final_df$Lat, 1)

joined <- final_df %>%
  left_join(grid_data_ch4, by = c("window_start_ch4", "Lon_round", "Lat_round"))


## edits above 8/11/25 ##

grid_data_co2 <- CAMS_CO2_df %>%
  group_by(date) %>%
  summarise(co2_conc_cams = mean(concentration, na.rm = TRUE)) %>%
  rename(window_start_co2 = date)

joined <- joined %>% mutate(window_start_co2 = floor_date(date, unit = "3 hours"))
joined <- joined %>% left_join(grid_data_co2, by = "window_start_co2")

joined <- joined[-c(2, 4, 5, 8, 10)]

##### Plotting against CT and CAMS #####
library(data.table)
joined_dt <- as.data.table(joined)
filtered_dt_list <- mapply(function(df, nm) {
  dt <- as.data.table(df)
  setnames(dt,
           old = setdiff(names(dt), "date"),
           new = paste0(setdiff(names(dt), "date"), "_", nm))
  dt
}, filtered_list, names(filtered_list), SIMPLIFY = FALSE)

big_dt <- rbindlist(filtered_dt_list, use.names = TRUE, fill = TRUE)

joined_dt[, date := as.Date(date)]
big_dt[, date := as.Date(date)]

big_dt_agg <- big_dt[, lapply(.SD, mean, na.rm = TRUE), by = date]

merged_dt <- merge(joined_dt, big_dt_agg, by = "date", all.x = TRUE)

merged_df <- as.data.frame(merged_dt)

##### ____________________________________#####
