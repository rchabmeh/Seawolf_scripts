##### Load in NEC tower .csv files #####
#____
LEW_22_CH4_95 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-95m-1-hour-20230425.csv")
LEW_22_CH4_95$DATE <- as.Date(LEW_22_CH4_95$datetime_UTC)
LEW_22_CH4_95$HH <- sprintf("%02d:00:00", LEW_22_CH4_95$HH)
LEW_22_CH4_95$datetime_combined <- paste(LEW_22_CH4_95$DATE, LEW_22_CH4_95$HH)
LEW_22_CH4_95$datetime_UTC <- as.POSIXct(LEW_22_CH4_95$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CH4_95$datetime_EDT <- with_tz(LEW_22_CH4_95$datetime_UTC, tzone = "America/New_York")


LEW_22_CH4_50 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-ch4-50m-1-hour-20230425.csv')
LEW_22_CH4_50$DATE <- as.Date(LEW_22_CH4_50$datetime_UTC)
LEW_22_CH4_50$HH <- sprintf("%02d:00:00", LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_combined <- paste(LEW_22_CH4_50$DATE, LEW_22_CH4_50$HH)
LEW_22_CH4_50$datetime_UTC <- as.POSIXct(LEW_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CH4_50$datetime_EDT <- with_tz(LEW_22_CH4_50$datetime_UTC, tzone = "America/New_York")

LEW_22_CO2_95 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-co2-95m-1-hour-20230425.csv')
LEW_22_CO2_95$DATE <- as.Date(LEW_22_CO2_95$datetime_UTC)
LEW_22_CO2_95$HH <- sprintf("%02d:00:00", LEW_22_CO2_95$HH)
LEW_22_CO2_95$datetime_combined <- paste(LEW_22_CO2_95$DATE, LEW_22_CO2_95$HH)
LEW_22_CO2_95$datetime_UTC <- as.POSIXct(LEW_22_CO2_95$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CO2_95$datetime_EDT <- with_tz(LEW_22_CO2_95$datetime_UTC, tzone = "America/New_York")


LEW_22_CO2_50 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/LEW-2022-co2-50m-1-hour-20230425.csv')
LEW_22_CO2_50$DATE <- as.Date(LEW_22_CO2_50$datetime_UTC)
LEW_22_CO2_50$HH <- sprintf("%02d:00:00", LEW_22_CO2_50$HH)
LEW_22_CO2_50$datetime_combined <- paste(LEW_22_CO2_50$DATE, LEW_22_CO2_50$HH)
LEW_22_CO2_50$datetime_UTC <- as.POSIXct(LEW_22_CO2_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
LEW_22_CO2_50$datetime_EDT <- with_tz(LEW_22_CO2_50$datetime_UTC, tzone = "America/New_York")

#_________
TMD_22_CH4_113 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-ch4-113m-1-hour-20230425.csv')
TMD_22_CH4_113$DATE <- as.Date(TMD_22_CH4_113$datetime_UTC)
TMD_22_CH4_113$HH <- sprintf("%02d:00:00", TMD_22_CH4_113$HH)
TMD_22_CH4_113$datetime_combined <- paste(TMD_22_CH4_113$DATE, TMD_22_CH4_113$HH)
TMD_22_CH4_113$datetime_UTC <- as.POSIXct(TMD_22_CH4_113$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
TMD_22_CH4_113$datetime_EDT <- with_tz(TMD_22_CH4_113$datetime_UTC, tzone = "America/New_York")

TMD_22_CH4_49 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-ch4-49m-1-hour-20230425.csv')
TMD_22_CH4_49$DATE <- as.Date(TMD_22_CH4_49$datetime_UTC)
TMD_22_CH4_49$HH <- sprintf("%02d:00:00", TMD_22_CH4_49$HH)
TMD_22_CH4_49$datetime_combined <- paste(TMD_22_CH4_49$DATE, TMD_22_CH4_49$HH)
TMD_22_CH4_49$datetime_UTC <- as.POSIXct(TMD_22_CH4_49$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_22_CH4_49$datetime_EDT <- with_tz(TMD_22_CH4_49$datetime_UTC, tzone = "America/New_York")

TMD_22_CO2_113 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-co2-113m-1-hour-20230425.csv')
TMD_22_CO2_113$DATE <- as.Date(TMD_22_CO2_113$datetime_UTC)
TMD_22_CO2_113$HH <- sprintf("%02d:00:00", TMD_22_CO2_113$HH)
TMD_22_CO2_113$datetime_combined <- paste(TMD_22_CO2_113$DATE, TMD_22_CO2_113$HH)
TMD_22_CO2_113$datetime_UTC <- as.POSIXct(TMD_22_CO2_113$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
TMD_22_CO2_113$datetime_EDT <- with_tz(TMD_22_CO2_113$datetime_UTC, tzone = "America/New_York")

TMD_22_CO2_49 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/TMD-2022-co2-49m-1-hour-20230425.csv')
TMD_22_CO2_49$DATE <- as.Date(TMD_22_CO2_49$datetime_UTC)
TMD_22_CO2_49$HH <- sprintf("%02d:00:00", TMD_22_CO2_49$HH)
TMD_22_CO2_49$datetime_combined <- paste(TMD_22_CO2_49$DATE, TMD_22_CO2_49$HH)
TMD_22_CO2_49$datetime_UTC <- as.POSIXct(TMD_22_CO2_49$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
TMD_22_CO2_49$datetime_EDT <- with_tz(TMD_22_CO2_49$datetime_UTC, tzone = "America/New_York")

#_________
BVA_22_CH4_111 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-ch4-111m-1-hour-v20250319.csv')
BVA_22_CH4_111$DATE <- as.Date(BVA_22_CH4_111$datetime_UTC)
BVA_22_CH4_111$HH <- sprintf("%02d:00:00", BVA_22_CH4_111$HH)
BVA_22_CH4_111$datetime_combined <- paste(BVA_22_CH4_111$DATE, BVA_22_CH4_111$HH)
BVA_22_CH4_111$datetime_UTC <- as.POSIXct(BVA_22_CH4_111$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
BVA_22_CH4_111$datetime_EDT <- with_tz(BVA_22_CH4_111$datetime_UTC, tzone = "America/New_York")

BVA_22_CH4_50 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-ch4-50m-1-hour-v20250319.csv')
BVA_22_CH4_50$DATE <- as.Date(BVA_22_CH4_50$datetime_UTC)
BVA_22_CH4_50$HH <- sprintf("%02d:00:00", BVA_22_CH4_50$HH)
BVA_22_CH4_50$datetime_combined <- paste(BVA_22_CH4_50$DATE, BVA_22_CH4_50$HH)
BVA_22_CH4_50$datetime_UTC <- as.POSIXct(BVA_22_CH4_50$datetime_combined,
                                         format = "%Y-%m-%d %H:%M:%S",
                                         tz = "UTC")
library(lubridate)
BVA_22_CH4_50$datetime_EDT <- with_tz(BVA_22_CH4_50$datetime_UTC, tzone = "America/New_York")

BVA_22_CO2_111 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-co2-111m-1-hour-v20250319.csv')
BVA_22_CO2_111$DATE <- as.Date(BVA_22_CO2_111$datetime_UTC)
BVA_22_CO2_111$HH <- sprintf("%02d:00:00", BVA_22_CO2_111$HH)
BVA_22_CO2_111$datetime_combined <- paste(BVA_22_CO2_111$DATE, BVA_22_CO2_111$HH)
BVA_22_CO2_111$datetime_UTC <- as.POSIXct(BVA_22_CO2_111$datetime_combined,
                                          format = "%Y-%m-%d %H:%M:%S",
                                          tz = "UTC")
library(lubridate)
BVA_22_CO2_111$datetime_EDT <- with_tz(BVA_22_CO2_111$datetime_UTC, tzone = "America/New_York")

BVA_22_CO2_50 <- read.csv('/Users/reneechabot-mehlin/Desktop/towers/BVA-2022-co2-50m-1-hour-v20250319.csv')
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

##### Basic Plotting #####
xlim_vals <- c(as.POSIXct("2022-04-09 00:00:00"),
               as.POSIXct("2022-04-2012 23:00:00"))
#ch4
plot(
  x = LEW_22_CH4_95$datetime_EDT,
  y = LEW_22_CH4_95$ch4_ppb,
  xlim = xlim_vals,
  ylim = c(1800, 2500),
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
lines(
  x = LEW_22_CH4_50$datetime_EDT,
  y = LEW_22_CH4_50$ch4_ppb,
  type = "b",
  col = "darkred",
  pch = 20
)
arrows(
  x0 = LEW_22_CH4_50$datetime_EDT,
  y0 = LEW_22_CH4_50$ch4_ppb - LEW_22_CH4_50$ch4_uncertainty,
  x1 = LEW_22_CH4_50$datetime_EDT,
  y1 = LEW_22_CH4_50$ch4_ppb + LEW_22_CH4_50$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkred"
)
lines(
  x = TMD_22_CH4_113$datetime_EDT,
  y = TMD_22_CH4_113$ch4_ppb,
  type = "b",
  col = "green",
  pch = 20
)
arrows(
  x0 = TMD_22_CH4_113$datetime_EDT,
  y0 = TMD_22_CH4_113$ch4_ppb - TMD_22_CH4_113$ch4_uncertainty,
  x1 = TMD_22_CH4_113$datetime_EDT,
  y1 = TMD_22_CH4_113$ch4_ppb + TMD_22_CH4_113$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "green"
)
lines(
  x = TMD_22_CH4_49$datetime_EDT,
  y = TMD_22_CH4_49$ch4_ppb,
  type = "b",
  col = "darkgreen",
  pch = 20
)
arrows(
  x0 = TMD_22_CH4_49$datetime_EDT,
  y0 = TMD_22_CH4_49$ch4_ppb - TMD_22_CH4_49$ch4_uncertainty,
  x1 = TMD_22_CH4_49$datetime_EDT,
  y1 = TMD_22_CH4_49$ch4_ppb + TMD_22_CH4_49$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkgreen"
)
lines(
  x = BVA_22_CH4_111$datetime_EDT,
  y = BVA_22_CH4_111$ch4_ppb,
  type = "b",
  col = "lightblue",
  pch = 20
)
arrows(
  x0 = BVA_22_CH4_111$datetime_EDT,
  y0 = BVA_22_CH4_111$ch4_ppb - BVA_22_CH4_111$ch4_uncertainty,
  x1 = BVA_22_CH4_111$datetime_EDT,
  y1 = BVA_22_CH4_111$ch4_ppb + BVA_22_CH4_111$ch4_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "lightblue"
)
lines(
  x = BVA_22_CH4_50$datetime_EDT,
  y = BVA_22_CH4_50$ch4_ppb,
  type = "b",
  col = "blue",
  pch = 20
)
arrows(
  x0 = BVA_22_CH4_50$datetime_EDT,
  y0 = BVA_22_CH4_50$ch4_ppb - BVA_22_CH4_50$ch4_uncertainty,
  x1 = BVA_22_CH4_50$datetime_EDT,
  y1 = BVA_22_CH4_50$ch4_ppb + BVA_22_CH4_50$ch4_uncertainty,
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

plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(
    "TMD_22_CH4_113",
    "TMD_22_CH4_49",
    "BVA_22_CH4_111",
    "BVA_22_CH4_50"
  ),
  title = "Legend",
  title.col = "black",
  col = c("green", "darkgreen", "lightblue", "blue"),
  pch = c(20, 20, 20, 20),
  lty = c(1, 1, 1, 1),
  text.col = c("green", "darkgreen", "lightblue", "blue"),
  bty = "o"
)


#co2
plot(
  x = LEW_22_CO2_95$datetime_EDT,
  y = LEW_22_CO2_95$co2_ppm,
  xlim = xlim_vals,
  ylim = c(400, 550),
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
lines(
  x = LEW_22_CO2_50$datetime_EDT,
  y = LEW_22_CO2_50$co2_ppm,
  type = "b",
  col = "darkred",
  pch = 20
)
arrows(
  x0 = LEW_22_CO2_50$datetime_EDT,
  y0 = LEW_22_CO2_50$co2_ppm - LEW_22_CO2_50$co2_uncertainty,
  x1 = LEW_22_CO2_50$datetime_EDT,
  y1 = LEW_22_CO2_50$co2_ppm + LEW_22_CO2_50$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkred"
)
lines(
  x = TMD_22_CO2_113$datetime_EDT,
  y = TMD_22_CO2_113$co2_ppm,
  type = "b",
  col = "green",
  pch = 20
)
arrows(
  x0 = TMD_22_CO2_113$datetime_EDT,
  y0 = TMD_22_CO2_113$co2_ppm - TMD_22_CO2_113$co2_uncertainty,
  x1 = TMD_22_CO2_113$datetime_EDT,
  y1 = TMD_22_CO2_113$co2_ppm + TMD_22_CO2_113$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "green"
)
lines(
  x = TMD_22_CO2_49$datetime_EDT,
  y = TMD_22_CO2_49$co2_ppm,
  type = "b",
  col = "darkgreen",
  pch = 20
)
arrows(
  x0 = TMD_22_CO2_49$datetime_EDT,
  y0 = TMD_22_CO2_49$co2_ppm - TMD_22_CO2_49$co2_uncertainty,
  x1 = TMD_22_CO2_49$datetime_EDT,
  y1 = TMD_22_CO2_49$co2_ppm + TMD_22_CO2_49$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "darkgreen"
)
lines(
  x = BVA_22_CO2_111$datetime_EDT,
  y = BVA_22_CO2_111$co2_ppm,
  type = "b",
  col = "lightblue",
  pch = 20
)
arrows(
  x0 = BVA_22_CO2_111$datetime_EDT,
  y0 = BVA_22_CO2_111$co2_ppm - BVA_22_CO2_111$co2_uncertainty,
  x1 = BVA_22_CO2_111$datetime_EDT,
  y1 = BVA_22_CO2_111$co2_ppm + BVA_22_CO2_111$co2_uncertainty,
  angle = 90,
  code = 3,
  length = 0.02,
  col = "lightblue"
)
lines(
  x = BVA_22_CO2_50$datetime_EDT,
  y = BVA_22_CO2_50$co2_ppm,
  type = "b",
  col = "blue",
  pch = 20
)
arrows(
  x0 = BVA_22_CO2_50$datetime_EDT,
  y0 = BVA_22_CO2_50$co2_ppm - BVA_22_CO2_50$co2_uncertainty,
  x1 = BVA_22_CO2_50$datetime_EDT,
  y1 = BVA_22_CO2_50$co2_ppm + BVA_22_CO2_50$co2_uncertainty,
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

plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(
    "TMD_22_CO2_113",
    "TMD_22_CO2_49",
    "BVA_22_CO2_111",
    "BVA_22_CO2_50"
  ),
  title = "Legend",
  title.col = "black",
  col = c("green", "darkgreen", "lightblue", "blue"),
  pch = c(20, 20, 20, 20),
  lty = c(1, 1, 1, 1),
  text.col = c("green", "darkgreen", "lightblue", "blue"),
  bty = "o"
)

##### Averaging data for 3 hour intervals #####
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
  tower_row <- matched_rows[matched_rows$SiteCode == sitecode, c("Lat","Lon") , drop = FALSE]
  if (nrow(tower_row) == 1) {
    meta_df <- cbind(averaged_data[[i]], tower_row[rep(1, nrow(averaged_data[[i]])), ])
    averaged_data[[i]] <- meta_df
  }
}

 start_date <- as.Date("2022-10-20")
 end_date <- as.Date("2022-10-20")

datetime_filtered_data <- lapply(averaged_data, function(df) { #3hr average for time period of interest
  df$date <- as.Date(df$date)

 df[df$date >= start_date & df$date <= end_date, ]
})

##### Adding Carbon Tracker Information #####
# adding carbon tracker
library(raster)
CT_CO2 <- list()
files <- list.files(
  '/Users/reneechabot-mehlin/Desktop/towers/ct/oct/co2',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
  CT_CO2[[i]] <- nc
}

CTCO2_1 <- list()
CTCO2_2 <- list()
CTCO2_3 <- list()
CTCO2_4 <- list()
CTCO2_5 <- list()
CTCO2_6 <- list()
CTCO2_7 <- list()
CTCO2_8 <- list()
for (i in seq_along(CT_CO2)) {
  CTCO2_1[[i]] <- CT_CO2[[i]][[1]]
  CTCO2_2[[i]] <- CT_CO2[[i]][[2]]
  CTCO2_3[[i]] <- CT_CO2[[i]][[3]]
  CTCO2_4[[i]] <- CT_CO2[[i]][[4]]
  CTCO2_5[[i]] <- CT_CO2[[i]][[5]]
  CTCO2_6[[i]] <- CT_CO2[[i]][[6]]
  CTCO2_7[[i]] <- CT_CO2[[i]][[7]]
  CTCO2_8[[i]] <- CT_CO2[[i]][[8]]
}
CT_CH4 <- list()
library(raster)
files = list.files(
  '/Users/reneechabot-mehlin/Desktop/towers/ct/oct/ch4',
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1
  )
  CT_CH4[[i]] <- nc
}

CTCH4_1 <- list()
CTCH4_2 <- list()
CTCH4_3 <- list()
CTCH4_4 <- list()
CTCH4_5 <- list()
CTCH4_6 <- list()
CTCH4_7 <- list()
CTCH4_8 <- list()
for (i in seq_along(CT_CH4)) {
  CTCH4_1[[i]] <- CT_CH4[[i]][[1]]
  CTCH4_2[[i]] <- CT_CH4[[i]][[2]]
  CTCH4_3[[i]] <- CT_CH4[[i]][[3]]
  CTCH4_4[[i]] <- CT_CH4[[i]][[4]]
  CTCH4_5[[i]] <- CT_CH4[[i]][[5]]
  CTCH4_6[[i]] <- CT_CH4[[i]][[6]]
  CTCH4_7[[i]] <- CT_CH4[[i]][[7]]
  CTCH4_8[[i]] <- CT_CH4[[i]][[8]]
}


interval_labels <- c(
  "00:00–03:00 UTC", "03:00–06:00 UTC", "06:00–09:00 UTC", "09:00–12:00 UTC",
  "12:00–15:00 UTC", "15:00–18:00 UTC", "18:00–21:00 UTC", "21:00–00:00 UTC"
)
CTCO2_lists <- list(CTCO2_1, CTCO2_2, CTCO2_3, CTCO2_4, CTCO2_5, CTCO2_6, CTCO2_7, CTCO2_8)
CTCH4_lists <- list(CTCH4_1, CTCH4_2, CTCH4_3, CTCH4_4, CTCH4_5, CTCH4_6, CTCH4_7, CTCH4_8)
datetime_with_ct <- lapply(datetime_filtered_data, function(df) {
  co2_vals <- numeric(nrow(df))
  ch4_vals <- numeric(nrow(df))
  
  for (j in seq_len(nrow(df))) {
    date_j <- as.Date(df$date[j])
    interval_j <- df$interval[j]
    lat <- df$Lat[j]
    lon <- df$Lon[j]
    # Get interval index (1–8)
    interval_index <- match(interval_j, interval_labels)
    if (is.na(interval_index)) next
    # Format date for matching raster names
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
  df
})

##### Plotting bias against CT #####
#edits below
library(dplyr)
library(tidyr)
library(ggplot2)

interval_levels <- c("00:00–03:00 UTC", "03:00–06:00 UTC", "06:00–09:00 UTC", "09:00–12:00 UTC",
                     "12:00–15:00 UTC", "15:00–18:00 UTC", "18:00–21:00 UTC", "21:00–00:00 UTC")

df_names <- names(datetime_with_ct)
if (is.null(df_names)) {
  df_names <- paste0("Dataframe_", seq_along(datetime_with_ct))
}

# --- Step 1: Calculate global bias limits before loop ---
all_ch4_bias <- c()
all_co2_bias <- c()

for (df in datetime_with_ct) {
  if (!is.data.frame(df)) next
  
  if (all(c("ch4_ppb", "ch4_ct") %in% names(df))) {
    ch4_bias <- df$ch4_ct - df$ch4_ppb
    all_ch4_bias <- c(all_ch4_bias, ch4_bias[!is.na(ch4_bias)])
  }
  
  if (all(c("co2_ppm", "co2_ct") %in% names(df))) {
    co2_bias <- df$co2_ct - df$co2_ppm
    all_co2_bias <- c(all_co2_bias, co2_bias[!is.na(co2_bias)])
  }
}

# Fallback if no bias found
ch4_limits <- if(length(all_ch4_bias) > 0) range(all_ch4_bias) else c(-1, 1)
co2_limits <- if(length(all_co2_bias) > 0) range(all_co2_bias) else c(-1, 1)

# Optionally round limits nicely
ch4_limits <- round(ch4_limits)
co2_limits <- round(co2_limits)

# --- Step 2: Main loop with plots ---
for (i in seq_along(datetime_with_ct)) {
  df <- datetime_with_ct[[i]]
  df_name <- df_names[i]
  
  if (!is.data.frame(df) || nrow(df) == 0) next
  
  df$interval <- factor(df$interval, levels = interval_levels, ordered = TRUE)
  df$date <- as.Date(as.character(df$date))
  
  label_date <- if (length(unique(df$date)) == 1) {
    as.character(unique(df$date))
  } else {
    paste0(min(df$date), " to ", max(df$date))
  }
  
  # --- CH4 Plot ---
  if (all(c("ch4_ppb", "ch4_ct") %in% names(df)) &&
      any(!is.na(df$ch4_ppb)) && any(!is.na(df$ch4_ct))) {
    
    plot_df <- pivot_longer(df,
                            cols = c("ch4_ppb", "ch4_ct"),
                            names_to = "Source",
                            values_to = "CH4")
    
    plot_df$Source <- factor(plot_df$Source,
                             levels = c("ch4_ppb", "ch4_ct"),
                             labels = c("Observed CH4", "CarbonTracker CH4"))
    
    p_ch4 <- ggplot(plot_df, aes(x = interval, y = CH4, color = Source, group = Source)) +
      geom_point(size = 3) +
      geom_line() +
      labs(title = paste("CH4 Concentration ", df_name, "on", label_date),
           x = "Time of Day (UTC Interval)",
           y = "CH4 (ppb)",
           color = "Data Source") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    print(p_ch4)
  }
  
  # --- CO2 Plot ---
  if (all(c("co2_ppm", "co2_ct") %in% names(df)) &&
      any(!is.na(df$co2_ppm)) && any(!is.na(df$co2_ct))) {
    
    plot_df <- pivot_longer(df,
                            cols = c("co2_ppm", "co2_ct"),
                            names_to = "Source",
                            values_to = "CO2")
    
    plot_df$Source <- factor(plot_df$Source,
                             levels = c("co2_ppm", "co2_ct"),
                             labels = c("Observed CO2", "CarbonTracker CO2"))
    
    p_co2 <- ggplot(plot_df, aes(x = interval, y = CO2, color = Source, group = Source)) +
      geom_point(size = 3) +
      geom_line() +
      labs(title = paste("CO2 Concentration ", df_name, "on", label_date),
           x = "Time of Day (UTC Interval)",
           y = "CO2 (ppm)",
           color = "Data Source") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    print(p_co2)
  }
  
  # --- Bias Plot (CH4 and CO2) with global y-axis limits ---
  if (any(c("ch4_ppb", "ch4_ct", "co2_ppm", "co2_ct") %in% names(df))) {
    
    has_ch4 <- all(c("ch4_ct", "ch4_ppb") %in% names(df)) &&
      any(!is.na(df$ch4_ct) & !is.na(df$ch4_ppb))
    
    has_co2 <- all(c("co2_ct", "co2_ppm") %in% names(df)) &&
      any(!is.na(df$co2_ct) & !is.na(df$co2_ppm))
    
    if (has_ch4 || has_co2) {
      if (has_ch4) df$CH4_bias <- df$ch4_ct - df$ch4_ppb
      if (has_co2) df$CO2_bias <- df$co2_ct - df$co2_ppm
      
      bias_cols <- c()
      if ("CH4_bias" %in% names(df)) bias_cols <- c(bias_cols, "CH4_bias")
      if ("CO2_bias" %in% names(df)) bias_cols <- c(bias_cols, "CO2_bias")
      
      bias_df <- pivot_longer(df,
                              cols = all_of(bias_cols),
                              names_to = "Gas",
                              values_to = "Bias",
                              values_drop_na = TRUE)
      
      bias_df$Gas <- factor(bias_df$Gas,
                            levels = c("CH4_bias", "CO2_bias"),
                            labels = c("CH4 (Model - Obs)", "CO2 (Model - Obs)"))
      
      bias_df$interval <- factor(bias_df$interval, levels = interval_levels, ordered = TRUE)
      
      if (nrow(bias_df) > 0) {
        p_bias <- ggplot(bias_df, aes(x = interval, y = Bias, fill = Gas)) +
          geom_bar(stat = "identity", position = "dodge") +
          geom_text(aes(label = round(Bias, 2)),
                    position = position_dodge(width = 0.9),
                    vjust = -0.5, size = 3) +
          labs(title = paste("Model Bias (Model - Observed) for", df_name, "on", label_date),
               x = "Time of Day (UTC Interval)",
               y = "Bias (Model - Obs)",
               fill = "Gas") +
          theme_minimal() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
        # Apply global y-axis limits
        if (length(unique(bias_df$Gas)) == 1) {
          if ("CH4 (Model - Obs)" %in% bias_df$Gas) {
            p_bias <- p_bias + coord_cartesian(ylim = ch4_limits)
          } else {
            p_bias <- p_bias + coord_cartesian(ylim = co2_limits)
          }
        } else {
          combined_limits <- range(ch4_limits, co2_limits)
          p_bias <- p_bias + coord_cartesian(ylim = combined_limits)
        }
        
        print(p_bias)
      }
    }
  }
}


#Plotting points on a map
library(sf)
library(sp)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k/cb_2023_us_state_500k.shp")
plot(st_geometry((states)), xlim = c(-78, -70),
     ylim = c(38, 42),
     xlab = "",
     ylab = "",
     main = "Towers of Interest",
     border = "grey",
     axes = T,
     las = 1
)
for (i in 1:3){
  points(matched_rows$Lon[i],matched_rows$Lat[i], col = "black",pch=21, bg="red")
  text((matched_rows$Lon[i]),(matched_rows$Lat[i]+0.08),label= matched_rows$SiteCode[i])
}



