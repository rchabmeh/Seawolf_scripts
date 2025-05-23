#NEC TOWERS INFO
#____
LEW_22_CH4_95 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-1/mds2-3012/csv/LEW-2022-ch4-95m-1-hour-20230425.csv')
LEW_22_CH4_95$DATE <- as.Date(LEW_22_CH4_95$datetime_UTC)
LEW_22_CH4_95$HH <- sprintf("%02d:00:00", LEW_22_CH4_95$HH)
LEW_22_CH4_95$datetime_combined <- paste(LEW_22_CH4_95$DATE, LEW_22_CH4_95$HH)
LEW_22_CH4_95$datetime_UTC <- as.POSIXct(LEW_22_CH4_95$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
LEW_22_CH4_95$datetime_EDT <- with_tz(LEW_22_CH4_95$datetime_UTC, tzone = "America/New_York")


LEW_22_CH4_50 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-1/mds2-3012/csv/LEW-2022-ch4-50m-1-hour-20230425.csv')
LEW_22_CH4_50$DATE <- as.Date(LEW_22_CH4_50$datetime_UTC)
LEW_22_CH4_50$HH <- sprintf("%02d:00:00", LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_combined <- paste(LEW_22_CH4_50$DATE, LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_UTC <- as.POSIXct(LEW_22_CH4_50$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
LEW_22_CH4_50$datetime_EDT <- with_tz(LEW_22_CH4_50$datetime_UTC, tzone = "America/New_York")

LEW_22_CO2_95 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-1/mds2-3012/csv/LEW-2022-co2-95m-1-hour-20230425.csv')
LEW_22_CO2_95$DATE <- as.Date(LEW_22_CO2_95$datetime_UTC)
LEW_22_CO2_95$HH <- sprintf("%02d:00:00", LEW_22_CO2_95$HH)
LEW_22_CO2_95$datetime_combined <- paste(LEW_22_CO2_95$DATE, LEW_22_CO2_95$HH)
LEW_22_CO2_95$datetime_UTC <- as.POSIXct(LEW_22_CO2_95$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
LEW_22_CO2_95$datetime_EDT <- with_tz(LEW_22_CO2_95$datetime_UTC, tzone = "America/New_York")


LEW_22_CO2_50 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-1/mds2-3012/csv/LEW-2022-co2-50m-1-hour-20230425.csv')
LEW_22_CO2_50$DATE <- as.Date(LEW_22_CO2_50$datetime_UTC)
LEW_22_CO2_50$HH <- sprintf("%02d:00:00", LEW_22_CO2_50$HH)
LEW_22_CO2_50$datetime_combined <- paste(LEW_22_CO2_50$DATE, LEW_22_CO2_50$HH)
LEW_22_CO2_50$datetime_UTC <- as.POSIXct(LEW_22_CO2_50$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
LEW_22_CO2_50$datetime_EDT <- with_tz(LEW_22_CO2_50$datetime_UTC, tzone = "America/New_York")

  #_________
 TMD_22_CH4_113 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv/TMD-2022-ch4-113m-1-hour-20230425.csv')
 TMD_22_CH4_113$DATE <- as.Date(TMD_22_CH4_113$datetime_UTC)
 TMD_22_CH4_113$HH <- sprintf("%02d:00:00", TMD_22_CH4_113$HH)
 TMD_22_CH4_113$datetime_combined <- paste(TMD_22_CH4_113$DATE, TMD_22_CH4_113$HH)
 TMD_22_CH4_113$datetime_UTC <- as.POSIXct(TMD_22_CH4_113$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
 library(lubridate)
 TMD_22_CH4_113$datetime_EDT <- with_tz(TMD_22_CH4_113$datetime_UTC, tzone = "America/New_York")
 
 TMD_22_CH4_49 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv/TMD-2022-ch4-49m-1-hour-20230425.csv')
 TMD_22_CH4_49$DATE <- as.Date(TMD_22_CH4_49$datetime_UTC)
 TMD_22_CH4_49$HH <- sprintf("%02d:00:00", TMD_22_CH4_49$HH)
 TMD_22_CH4_49$datetime_combined <- paste(TMD_22_CH4_49$DATE, TMD_22_CH4_49$HH)
 TMD_22_CH4_49$datetime_UTC <- as.POSIXct(TMD_22_CH4_49$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
 library(lubridate)
 TMD_22_CH4_49$datetime_EDT <- with_tz(TMD_22_CH4_49$datetime_UTC, tzone = "America/New_York")
 
TMD_22_CO2_113 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv/TMD-2022-co2-113m-1-hour-20230425.csv')
TMD_22_CO2_113$DATE <- as.Date(TMD_22_CO2_113$datetime_UTC)
TMD_22_CO2_113$HH <- sprintf("%02d:00:00", TMD_22_CO2_113$HH)
TMD_22_CO2_113$datetime_combined <- paste(TMD_22_CO2_113$DATE, TMD_22_CO2_113$HH)
TMD_22_CO2_113$datetime_UTC <- as.POSIXct(TMD_22_CO2_113$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
TMD_22_CO2_113$datetime_EDT <- with_tz(TMD_22_CO2_113$datetime_UTC, tzone = "America/New_York")

TMD_22_CO2_49 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv/TMD-2022-co2-49m-1-hour-20230425.csv')
TMD_22_CO2_49$DATE <- as.Date(TMD_22_CO2_49$datetime_UTC)
TMD_22_CO2_49$HH <- sprintf("%02d:00:00", TMD_22_CO2_49$HH)
TMD_22_CO2_49$datetime_combined <- paste(TMD_22_CO2_49$DATE, TMD_22_CO2_49$HH)
TMD_22_CO2_49$datetime_UTC <- as.POSIXct(TMD_22_CO2_49$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
TMD_22_CO2_49$datetime_EDT <- with_tz(TMD_22_CO2_49$datetime_UTC, tzone = "America/New_York")

#____
# UNY_22_CH4_68 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-ch4-68m-1-hour-20230425.csv')
# UNY_22_CH4_68$DATE <- as.Date(UNY_22_CH4_68$datetime_UTC)
# UNY_22_CH4_68$HH <- sprintf("%02d:00:00", UNY_22_CH4_68$HH)
# UNY_22_CH4_68$datetime_combined <- paste(UNY_22_CH4_68$DATE, UNY_22_CH4_68$HH)
# UNY_22_CH4_68$datetime_UTC <- as.POSIXct(UNY_22_CH4_68$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
# library(lubridate)
# UNY_22_CH4_68$datetime_EDT <- with_tz(UNY_22_CH4_68$datetime_UTC, tzone = "America/New_York")
# 
# UNY_22_CH4_60 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-ch4-60m-1-hour-20230425.csv')
# UNY_22_CH4_60$DATE <- as.Date(UNY_22_CH4_60$datetime_UTC)
# UNY_22_CH4_60$HH <- sprintf("%02d:00:00", UNY_22_CH4_60$HH)
# UNY_22_CH4_60$datetime_combined <- paste(UNY_22_CH4_60$DATE, UNY_22_CH4_60$HH)
# UNY_22_CH4_60$datetime_UTC <- as.POSIXct(UNY_22_CH4_60$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
# library(lubridate)
# UNY_22_CH4_60$datetime_EDT <- with_tz(UNY_22_CH4_60$datetime_UTC, tzone = "America/New_York")

# UNY_22_CO2_68 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-co2-68m-1-hour-20230425.csv')
# UNY_22_CO2_60 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 2/UNY-2022-co2-60m-1-hour-20230425.csv')

#___
SNJ_22_CH4_53 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-ch4-53m-1-hour-20230425.csv')
SNJ_22_CH4_53$DATE <- as.Date(SNJ_22_CH4_53$datetime_UTC)
SNJ_22_CH4_53$HH <- sprintf("%02d:00:00", SNJ_22_CH4_53$HH)
SNJ_22_CH4_53$datetime_combined <- paste(SNJ_22_CH4_53$DATE, SNJ_22_CH4_53$HH)
SNJ_22_CH4_53$datetime_UTC <- as.POSIXct(SNJ_22_CH4_53$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
SNJ_22_CH4_53$datetime_EDT <- with_tz(SNJ_22_CH4_53$datetime_UTC, tzone = "America/New_York")

SNJ_22_CH4_42 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-ch4-42m-1-hour-20230425.csv')
SNJ_22_CH4_42$DATE <- as.Date(SNJ_22_CH4_42$datetime_UTC)
SNJ_22_CH4_42$HH <- sprintf("%02d:00:00", SNJ_22_CH4_42$HH)
SNJ_22_CH4_42$datetime_combined <- paste(SNJ_22_CH4_42$DATE, SNJ_22_CH4_42$HH)
SNJ_22_CH4_42$datetime_UTC <- as.POSIXct(SNJ_22_CH4_42$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
library(lubridate)
SNJ_22_CH4_42$datetime_EDT <- with_tz(SNJ_22_CH4_42$datetime_UTC, tzone = "America/New_York")

 SNJ_22_CO2_53 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-co2-53m-1-hour-20230425.csv')
 SNJ_22_CO2_53$DATE <- as.Date(SNJ_22_CO2_53$datetime_UTC)
 SNJ_22_CO2_53$HH <- sprintf("%02d:00:00", SNJ_22_CO2_53$HH)
 SNJ_22_CO2_53$datetime_combined <- paste(SNJ_22_CO2_53$DATE, SNJ_22_CO2_53$HH)
 SNJ_22_CO2_53$datetime_UTC <- as.POSIXct(SNJ_22_CO2_53$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
 library(lubridate)
 SNJ_22_CO2_53$datetime_EDT <- with_tz(SNJ_22_CO2_53$datetime_UTC, tzone = "America/New_York")
 
 SNJ_22_CO2_42 <- read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/documents/NEC towers/NIST-Data-2025-02-12T14-24-2/mds2-3012/csv 3/SNJ-2022-co2-42m-1-hour-20230425.csv')
 SNJ_22_CO2_42$DATE <- as.Date(SNJ_22_CO2_42$datetime_UTC)
 SNJ_22_CO2_42$HH <- sprintf("%02d:00:00", SNJ_22_CO2_42$HH)
 SNJ_22_CO2_42$datetime_combined <- paste(SNJ_22_CO2_42$DATE, SNJ_22_CO2_42$HH)
 SNJ_22_CO2_42$datetime_UTC <- as.POSIXct(SNJ_22_CO2_42$datetime_combined, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
 library(lubridate)
 SNJ_22_CO2_42$datetime_EDT <- with_tz(SNJ_22_CO2_42$datetime_UTC, tzone = "America/New_York")
 

xlim_vals <- c(as.POSIXct("2022-04-10 00:00:00"), as.POSIXct("2022-04-10 23:00:00"))

plot(x=LEW_22_CH4_95$datetime_EDT, y = LEW_22_CH4_95$ch4_ppb, xlim= xlim_vals, ylim = c(2000,2060),
     xlab= "Date (ETD)", ylab="CH4 (ppb)", main= "NEC TOWER DATA", type = "b", col="red", pch =20)
 lines(x = LEW_22_CH4_50$datetime_EDT, y = LEW_22_CH4_50$ch4_ppb, type = "b", col= "blue", pch=20)
# lines(x = UNY_22_CH4_68$datetime_EDT, y = UNY_22_CH4_68$co2_ppm, type = "b", col= "green", pch=20)
# lines(x = UNY_22_CH4_60$datetime_EDT, y = UNY_22_CH4_60$co2_ppm, type = "b", col= "black", pch=20)
# lines(x = SNJ_22_CH4_53$datetime_EDT, y = SNJ_22_CH4_53$co2_ppm, type = "b", col= "purple", pch=20)
# lines(x = SNJ_22_CH4_53$datetime_EDT, y = SNJ_22_CH4_53$co2_ppm, type = "b", col= "orange", pch=20)
# lines(x = SNJ_22_CH4_42$datetime_EDT, y = SNJ_22_CH4_42$co2_ppm, type = "b", col= "hotpink", pch=20)
 plot(x=TMD_22_CH4_49$datetime_EDT, y = TMD_22_CH4_49$ch4_ppb, xlim= xlim_vals, ylim = c(2000,2080),
      xlab= "Date (ETD)", ylab="CO2 (ppm)", main= "NEC TOWER DATA", type = "b", col="orange2", pch =20)
 #lines(x = TMD_22_CO2_49$datetime_EDT, y = TMD_22_CO2_49$co2_ppm, type = "b", col= "orange2", pch=20)
 lines(x = TMD_22_CH4_113$datetime_EDT, y = TMD_22_CH4_113$ch4_ppb, type = "b", col= "purple", pch=20)
 
legend("topright", title= "Height in meters", legend = c("LEW-95 meters", "LEW-50 meters","TMD-49 meters","TMD-113 meters"),
       col = c("red","blue","orange2","purple"), pch = 20, cex = 0.4)
