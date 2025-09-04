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
#surface level 

#LEW tower is in Lewisburg, PA (Union County). GHG sources in the area include:
# 1. Bucknell University (32,878 mt CO2e [2022]) which is S of LEW (Lewisburg, PA)
# 2. Gold Bond - MLT Plant (45,494 mt CO2e [2022]) which is N of LEW (New Columbia, PA)

enh_info <- read.csv("/Volumes/Seagate/cruise24_eulerian/all_models_merged_cruise24.csv")
enh_info$obs_co2_enh_via_LEW_4_WNJ <- enh_info$obs_mean_co2_WNJ - enh_info$obs_mean_co2_LEW
enh_info$obs_ch4_enh_via_LEW_4_WNJ <- enh_info$obs_mean_ch4_WNJ - enh_info$obs_mean_ch4_LEW
enh_info$ct_co2_enh_via_LEW_4_WNJ <- enh_info$ct_mean_co2_WNJ - enh_info$ct_mean_co2_LEW
enh_info$ct_ch4_enh_via_LEW_4_WNJ <- enh_info$ct_mean_ch4_WNJ - enh_info$ct_mean_ch4_LEW
enh_info$cams_co2_enh_via_LEW_4_WNJ <- enh_info$cams_mean_co2_WNJ - enh_info$cams_mean_co2_LEW
enh_info$cams_ch4_enh_via_LEW_4_WNJ <- enh_info$cams_mean_ch4_WNJ - enh_info$cams_mean_ch4_LEW

enh_info$date <- as.POSIXct(enh_info$date, format= "%Y-%m-%d %H:%M:%OS", tz = "UTC")
enh_info <- subset(enh_info,
                            format(date, "%H") >= "14" &
                              format(date, "%H") <= "20")

#co2 ct LEW v Ship
library(ggplot2)
library(ggpubr)
library(tidyr)

xrange <- range(enh_info$obs_co2_enh_via_LEW, na.rm = TRUE)
yrange <- range(enh_info$ct_co2_enh_via_LEW, na.rm = TRUE)

overall_min <- min(xrange[1], yrange[1])
overall_max <- max(xrange[2], yrange[2])

label.x <- overall_min + 0.02 * (overall_max - overall_min)
label.y <- overall_max - 0.02 * (overall_max - overall_min)

 ggplot(enh_info, aes(x = obs_co2_enh_via_LEW, y = ct_co2_enh_via_LEW)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_regline_equation(aes(label = paste(
    ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
  )), label.x = label.x, label.y = label.y) +
  labs(
    title = "LEW v Ship: Comparing CT CO2 enh v Obs CO2 enh Cruise 24"
    ,
    x = "Observed Ship Conc - Observed LEW Conc (CO2 Enhancement ppm)",
    y = "CT Ship Conc - CT LEW Conc (CO2 Enhancement ppm)",
    subtitle = "Daylight hours only (10AM-4PM EDT)"
    
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
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW, y = ct_ch4_enh_via_LEW)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v Ship: Comparing CT CH4 enh v Obs CH4 enh Cruise 24"
     ,
     x = "Observed Ship Conc - Observed LEW Conc (CH4 Enhancement ppb)",
     y = "CT Ship Conc - CT LEW Conc (CH4 Enhancement ppb)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
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
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_co2_enh_via_LEW, y = cams_co2_enh_via_LEW)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v Ship: Comparing CAMS CO2 enh v Obs CO2 enh Cruise 24"
     ,
     x = "Observed Ship Conc - Observed LEW Conc (CO2 Enhancement ppm)",
     y = "CAMS Ship Conc - CAMS LEW Conc (CO2 Enhancement ppm)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
     
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
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW, y = cams_ch4_enh_via_LEW)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v Ship: Comparing CAMS CH4 enh v Obs CH4 enh Cruise 24"
     ,
     x = "Observed Ship Conc - Observed LEW Conc (CH4 Enhancement ppb)",
     y = "CAMS Ship Conc - CAMS LEW Conc (CH4 Enhancement ppb)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
     
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
 #_______________________#
 #co2 ct LEW v WNJ
 library(ggplot2)
 library(ggpubr)
 library(tidyr)
 
 xrange <- range(enh_info$obs_co2_enh_via_LEW_4_WNJ, na.rm = TRUE)
 yrange <- range(enh_info$ct_co2_enh_via_LEW_4_WNJ, na.rm = TRUE)
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_co2_enh_via_LEW_4_WNJ, y = ct_co2_enh_via_LEW_4_WNJ)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v WNJ: Comparing CT CO2 enh v Obs CO2 enh Cruise 24"
     ,
     x = "Observed WNJ Conc - Observed LEW Conc (CO2 Enhancement ppm)",
     y = "CT WNJ Conc - CT LEW Conc (CO2 Enhancement ppm)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
     
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
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW_4_WNJ, y = ct_ch4_enh_via_LEW_4_WNJ)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v WNJ: Comparing CT CH4 enh v Obs CH4 enh Cruise 24"
     ,
     x = "Observed WNJ Conc - Observed LEW Conc (CH4 Enhancement ppb)",
     y = "CT WNJ Conc - CT LEW Conc (CH4 Enhancement ppb)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
     
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
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_co2_enh_via_LEW_4_WNJ, y = cams_co2_enh_via_LEW_4_WNJ)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v WNJ: Comparing CAMS CO2 enh v Obs CO2 enh Cruise 24"
     ,
     x = "Observed WNJ Conc - Observed LEW Conc (CO2 Enhancement ppm)",
     y = "CAMS WNJ Conc - CAMS LEW Conc (CO2 Enhancement ppm)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
     
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
 
 overall_min <- min(xrange[1], yrange[1])
 overall_max <- max(xrange[2], yrange[2])
 
 label.x <- overall_min + 0.02 * (overall_max - overall_min)
 label.y <- overall_max - 0.02 * (overall_max - overall_min)
 
 ggplot(enh_info, aes(x = obs_ch4_enh_via_LEW_4_WNJ, y = cams_ch4_enh_via_LEW_4_WNJ)) +
   geom_point() +
   geom_smooth(method = lm) +
   stat_regline_equation(aes(label = paste(
     ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
   )), label.x = label.x, label.y = label.y) +
   labs(
     title = "LEW v WNJ: Comparing CAMS CH4 enh v Obs CH4 enh Cruise 24"
     ,
     x = "Observed WNJ Conc - Observed LEW Conc (CH4 Enhancement ppb)",
     y = "CAMS WNJ Conc - CAMS LEW Conc (CH4 Enhancement ppb)",
     subtitle = "Daylight hours only (10AM-4PM EDT)"
     
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
 