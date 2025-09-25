#CT Heights:
#1	34.5 meters ** using this layer
#2	111.9	meters
#3	256.9	meters
#4	490.4	meters
#5	826.4	meters
#6	1274.1 meters
#7	1839.0 meters
#8	2524.0 meters
#9	3329.9 meters

#CAMS Height:
#I'm seeing multiple different info, max surface level p for both is 1015.8 hPa, having trouble isolating region
#For CAMS CH4 level 1 height is said to be 2834.6 m (altitude variable)
#Based on Figure 7 in ECMWF website, base layer is @ 1000 hPa

#LEW tower is in Lewisburg, PA (Union County). GHG sources in the area include:
# 1. Bucknell University (32,878 mt CO2e [2022]) which is S of LEW (Lewisburg, PA)
# 2. Gold Bond - MLT Plant (45,494 mt CO2e [2022]) which is N of LEW (New Columbia, PA)

##### Loading in .csv file #####
enh_info <- read.csv("/Volumes/Seagate/cruise4_eulerian/all_models_merged_cruise4.csv")
enh_info$obs_co2_enh_via_LEW_4_WNJ <- enh_info$obs_mean_co2_WNJ - enh_info$obs_mean_co2_LEW
enh_info$obs_ch4_enh_via_LEW_4_WNJ <- enh_info$obs_mean_ch4_WNJ - enh_info$obs_mean_ch4_LEW
enh_info$ct_co2_enh_via_LEW_4_WNJ <- enh_info$ct_mean_co2_WNJ - enh_info$ct_mean_co2_LEW
enh_info$ct_ch4_enh_via_LEW_4_WNJ <- enh_info$ct_mean_ch4_WNJ - enh_info$ct_mean_ch4_LEW
enh_info$cams_co2_enh_via_LEW_4_WNJ <- enh_info$cams_mean_co2_WNJ - enh_info$cams_mean_co2_LEW
enh_info$cams_ch4_enh_via_LEW_4_WNJ <- enh_info$cams_mean_ch4_WNJ - enh_info$cams_mean_ch4_LEW

enh_info$date <- ifelse(
  grepl("^\\d{4}-\\d{2}-\\d{2}$", enh_info$date),
  paste0(enh_info$date, " 00:00:00"),
  enh_info$date
)

enh_info$date <- as.POSIXct(enh_info$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
enh_info$local_time <- as.POSIXct(format(enh_info$date, tz = "America/New_York", usetz = TRUE),
                                  tz = "America/New_York")
enh_info$local_date <- as.Date(enh_info$local_time, tz = "America/New_York")

enh_info <- subset(enh_info, local_date == as.Date("2022-04-10"))

 enh_info <- subset(enh_info, format(local_time, "%H") >= "10" &
                      format(local_time, "%H") <= "16")




#ship avg enh
avg_cams_ch4_ship_enh <- mean(enh_info$cams_ch4_enh_via_LEW, na.rm = T)
cams_ch4_ship_enh_sd <- sd(enh_info$cams_ch4_enh_via_LEW, na.rm = T)
avg_cams_co2_ship_enh <- mean(enh_info$cams_co2_enh_via_LEW, na.rm = T)
cams_co2_ship_enh_sd <- sd(enh_info$cams_co2_enh_via_LEW, na.rm = T)
cams_print <- paste(
  "CAMS (LEW) CO2 enhancement is",
  round(avg_cams_co2_ship_enh, 2),
  "±",
  round(cams_co2_ship_enh_sd, 2),
  "(ppm) and CAMS (LEW) CH4 enhancement is",
  round(avg_cams_ch4_ship_enh, 2),
  "±",
  round(cams_ch4_ship_enh_sd, 2),
  "(ppb)"
)

avg_ct_ch4_ship_enh <- mean(enh_info$ct_ch4_enh_via_LEW, na.rm = T)
ct_ch4_ship_enh_sd <- sd(enh_info$ct_ch4_enh_via_LEW, na.rm = T)
avg_ct_co2_ship_enh <- mean(enh_info$ct_co2_enh_via_LEW, na.rm = T)
ct_co2_ship_enh_sd <- sd(enh_info$ct_co2_enh_via_LEW, na.rm = T)
ct_print <- paste(
  "CT CO2 (LEW) enhancement is",
  round(avg_ct_co2_ship_enh, 2),
  "±",
  round(ct_co2_ship_enh_sd, 2),
  "(ppm) and CT CH4 (LEW) enhancement is",
  round(avg_ct_ch4_ship_enh, 2),
  "±",
  round(ct_ch4_ship_enh_sd, 2),
  "(ppb)"
)

avg_obs_ch4_ship_enh_LEW <- mean(enh_info$obs_ch4_enh_via_LEW, na.rm = T)
obs_ch4_ship_enh_sd_LEW <- sd(enh_info$obs_ch4_enh_via_LEW, na.rm = T)
avg_obs_co2_ship_enh_LEW <- mean(enh_info$obs_co2_enh_via_LEW, na.rm =
                                   T)
obs_co2_ship_enh_sd_LEW <- sd(enh_info$obs_co2_enh_via_LEW, na.rm = T)
obs_LEW_print <- paste(
  "Obs (LEW) CO2 enhancement is",
  round(avg_obs_co2_ship_enh_LEW, 2),
  "±",
  round(obs_co2_ship_enh_sd_LEW, 2),
  "(ppm)and Obs (LEW) CH4 enhancement is",
  round(avg_obs_ch4_ship_enh_LEW, 2),
  "±",
  round(obs_ch4_ship_enh_sd_LEW, 2),
  "(ppb)"
)

# avg_obs_ch4_ship_enh_TMD <- mean(enh_info$obs_ch4_enh_via_TMD, na.rm = T)
# obs_ch4_ship_enh_sd_TMD <- sd(enh_info$obs_ch4_enh_via_TMD, na.rm = T)
# avg_obs_co2_ship_enh_TMD <- mean(enh_info$obs_co2_enh_via_TMD, na.rm = T)
# obs_co2_ship_enh_sd_TMD <- sd(enh_info$obs_co2_enh_via_TMD, na.rm = T)
# obs_TMD_print <- paste(
#   "Obs (TMD) CO2 enhancement is",
#   round(avg_obs_co2_ship_enh_TMD, 2),
#   "±",
#   round(obs_co2_ship_enh_sd_TMD, 2),
#   "(ppm) and Obs (TMD) CH4 enhancement is",
#   round(avg_obs_ch4_ship_enh_TMD, 2),
#   "±",
#   round(obs_ch4_ship_enh_sd_TMD, 2),
#   "(ppb)"
# )

print(ct_print)
#print(obs_TMD_print)
print(cams_print)
print(obs_LEW_print)

time_range <- c(head(enh_info$date, 1),tail(enh_info$date, 1)) #for cruise 24 I want 10-16-23 from 10-16 EDT
date_text <- paste("Timeframe:",time_range[1],"through",time_range[2],"(Filtered for daylight hours only [10-16 EDT].)")

##### Scatter Plots LEW Tower #####
#co2 ct LEW v Ship
library(ggplot2)
library(ggpubr)
library(tidyr)

xrange <- range(enh_info$obs_co2_enh_via_LEW, na.rm = TRUE)
yrange <- range(enh_info$ct_co2_enh_via_LEW, na.rm = TRUE)

   # overall_min <- min(xrange[1], yrange[1])
   # overall_max <- max(xrange[2], yrange[2])

   overall_min <- min(-5,5)
   overall_max <- max(-5,5)

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_co2_enh_via_LEW, y = ct_co2_enh_via_LEW)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v Ship: Comparing CT CO2 Enh v Obs CO2 Enh Cruise 4"
    ,
    x = "Observed Ship Conc - Observed LEW Conc (CO2 Enhancement ppm)",
    y = "CT Ship Conc - CT LEW Conc (CO2 Enhancement ppm)",
   subtitle = date_text
    
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

#ch4 ct LEW v Ship

xrange <- range(enh_info$obs_ch4_enh_via_LEW, na.rm = TRUE)
yrange <- range(enh_info$ct_ch4_enh_via_LEW, na.rm = TRUE)

   # overall_min <- min(xrange[1], yrange[1])
   # overall_max <- max(xrange[2], yrange[2])

   overall_min <- min(-50,30)
   overall_max <- max(-50,30)

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW, y = ct_ch4_enh_via_LEW)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v Ship: Comparing CT CH4 Enh v Obs CH4 Enh Cruise 4"
    ,
    x = "Observed Ship Conc - Observed LEW Conc (CH4 Enhancement ppb)",
    y = "CT Ship Conc - CT LEW Conc (CH4 Enhancement ppb)",
    subtitle = date_text
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

#co2 cams LEW v Ship
library(ggplot2)
library(ggpubr)
library(tidyr)

xrange <- range(enh_info$obs_co2_enh_via_LEW, na.rm = TRUE)
yrange <- range(enh_info$cams_co2_enh_via_LEW, na.rm = TRUE)

  # overall_min <- min(xrange[1], yrange[1])
  # overall_max <- max(xrange[2], yrange[2])

   overall_min <- min(-5,5)
   overall_max <- max(-5,5)

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_co2_enh_via_LEW, y = cams_co2_enh_via_LEW)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v Ship: Comparing CAMS CO2 Enh v Obs CO2 Enh Cruise 4"
    ,
    x = "Observed Ship Conc - Observed LEW Conc (CO2 Enhancement ppm)",
    y = "CAMS Ship Conc - CAMS LEW Conc (CO2 Enhancement ppm)",
    subtitle = date_text
    
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

#ch4 cams LEW v Ship

xrange <- range(enh_info$obs_ch4_enh_via_LEW, na.rm = TRUE)
yrange <- range(enh_info$cams_ch4_enh_via_LEW, na.rm = TRUE)

   # overall_min <- min(xrange[1], yrange[1])
   # overall_max <- max(xrange[2], yrange[2])

  overall_min <- min(-30,30)
  overall_max <- max(-30,30)

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW, y = cams_ch4_enh_via_LEW)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v Ship: Comparing CAMS CH4 Enh v Obs CH4 Enh Cruise 4"
    ,
    x = "Observed Ship Conc - Observed LEW Conc (CH4 Enhancement ppb)",
    y = "CAMS Ship Conc - CAMS LEW Conc (CH4 Enhancement ppb)",
    subtitle = date_text
    
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

##### Scatter Plots LEW V WNJ Tower #####
#co2 ct LEW v WNJ
library(ggplot2)
library(ggpubr)
library(tidyr)

xrange <- range(enh_info$obs_co2_enh_via_LEW_4_WNJ, na.rm = TRUE)
yrange <- range(enh_info$ct_co2_enh_via_LEW_4_WNJ, na.rm = TRUE)

  # overall_min <- min(xrange[1], yrange[1])
  # overall_max <- max(xrange[2], yrange[2])

   overall_min <- min(-5, 5)
   overall_max <- max(-5, 5)


label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_co2_enh_via_LEW_4_WNJ, y = ct_co2_enh_via_LEW_4_WNJ)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v WNJ: Comparing CT CO2 Enh v Obs CO2 Enh Cruise 4"
    ,
    x = "Observed WNJ Conc - Observed LEW Conc (CO2 Enhancement ppm)",
    y = "CT WNJ Conc - CT LEW Conc (CO2 Enhancement ppm)",
    subtitle = date_text
    
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

#ch4 ct LEW v WNJ

xrange <- range(enh_info$obs_ch4_enh_via_LEW_4_WNJ, na.rm = TRUE)
yrange <- range(enh_info$ct_ch4_enh_via_LEW_4_WNJ, na.rm = TRUE)

   # overall_min <- min(xrange[1], yrange[1])
   # overall_max <- max(xrange[2], yrange[2])

   overall_min <- min(-50,30)
   overall_max <- max(-50, 30)

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW_4_WNJ, y = ct_ch4_enh_via_LEW_4_WNJ)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v WNJ: Comparing CT CH4 Enh v Obs CH4 Enh Cruise 4"
    ,
    x = "Observed WNJ Conc - Observed LEW Conc (CH4 Enhancement ppb)",
    y = "CT WNJ Conc - CT LEW Conc (CH4 Enhancement ppb)",
    subtitle = date_text
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

#co2 cams LEW v WNJ
library(ggplot2)
library(ggpubr)
library(tidyr)

xrange <- range(enh_info$obs_co2_enh_via_LEW_4_WNJ, na.rm = TRUE)
yrange <- range(enh_info$cams_co2_enh_via_LEW_4_WNJ, na.rm = TRUE)

   # overall_min <- min(xrange[1], yrange[1])
   # overall_max <- max(xrange[2], yrange[2])

   overall_min <- min(-5,5)
   overall_max <- max(-5,5)


label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_co2_enh_via_LEW_4_WNJ, y = cams_co2_enh_via_LEW_4_WNJ)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v WNJ: Comparing CAMS CO2 Enh v Obs CO2 Enh Cruise 4"
    ,
    x = "Observed WNJ Conc - Observed LEW Conc (CO2 Enhancement ppm)",
    y = "CAMS WNJ Conc - CAMS LEW Conc (CO2 Enhancement ppm)",
    subtitle = date_text
    
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )

#ch4 cams LEW v WNJ

xrange <- range(enh_info$obs_ch4_enh_via_LEW_4_WNJ, na.rm = TRUE)
yrange <- range(enh_info$cams_ch4_enh_via_LEW_4_WNJ, na.rm = TRUE)

   # overall_min <- min(xrange[1], yrange[1])
   # overall_max <- max(xrange[2], yrange[2])

  overall_min <- min(-30,30)
  overall_max <- max(-30,30)

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW_4_WNJ, y = cams_ch4_enh_via_LEW_4_WNJ)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v WNJ: Comparing CAMS CH4 Enh v Obs CH4 Enh Cruise 4"
    ,
    x = "Observed WNJ Conc - Observed LEW Conc (CH4 Enhancement ppb)",
    y = "CAMS WNJ Conc - CAMS LEW Conc (CH4 Enhancement ppb)",
    subtitle = date_text
    
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    color = "red",
    linetype = "dashed"
  ) +
  coord_fixed(
    ratio = 1,
    xlim = c(overall_min, overall_max),
    ylim = c(overall_min, overall_max)
  ) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20)
  )


