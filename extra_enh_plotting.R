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

Pz = 1015.1 *100 #layer pressure hPa -> Pa
Po = 1013.25 *100 #sea level pressure hPa -> Pa
R =  287 # J/kg/K
Temp = 55.5 #average temp in the US in F
Temp = (Temp - 32)* (5/9) + 273.15 #converted to K
g = 9.81 #gravitational accel constant m/s^2

delta_z <- ((R*Temp)/g)*log(Pz/Po)
 
#LEW tower is in Lewisburg, PA (Union County). GHG sources in the area include:
# 1. Bucknell University (32,878 mt CO2e [2022]) which is S of LEW (Lewisburg, PA)
# 2. Gold Bond - MLT Plant (45,494 mt CO2e [2022]) which is N of LEW (New Columbia, PA)

##### Loading in .csv file #####
enh_info <- read.csv("/Volumes/Seagate/cruise14_eulerian/all_models_merged_cruise14.csv")

##### Create enhancement columns (Tower v WNJ) #####

towers <- c("BVA", "TMD")
species <- c("co2", "ch4")
models <- c("obs", "ct", "cams")

for (tower in towers) {
  for (mod in models) {
    for (sp in species) {
      
      # Define input column names
      wnj_col <- paste0(mod, "_mean_", sp, "_WNJ")
      tower_col <- paste0(mod, "_mean_", sp, "_", tower)
      
      # Define output column name
      new_col <- paste0(mod, "_", sp, "_enh_via_", tower, "_4_WNJ")
      
      # Only create if both input columns exist
      if (wnj_col %in% names(enh_info) && tower_col %in% names(enh_info)) {
        enh_info[[new_col]] <- enh_info[[wnj_col]] - enh_info[[tower_col]]
      } else {
        warning(paste("Missing columns for", new_col))
      }
    }
  }
}

enh_info$date <- ifelse(
  grepl("^\\d{4}-\\d{2}-\\d{2}$", enh_info$date),
  paste0(enh_info$date, " 00:00:00"),
  enh_info$date
)

enh_info$date <- as.POSIXct(enh_info$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
enh_info$local_time <- as.POSIXct(format(enh_info$date, tz = "America/New_York", usetz = TRUE),
                                  tz = "America/New_York")
enh_info$local_date <- as.Date(enh_info$local_time, tz = "America/New_York")

# enh_info <- subset(enh_info, local_date == as.Date("2023-03-30"))

 enh_info <- subset(enh_info, format(local_time, "%H") >= "10" &
                      format(local_time, "%H") <= "16")

#ship avg enh
 make_all_enh_prints <- function(data, site) {
   # CAMS
   avg_cams_ch4 <- mean(data[[paste0("cams_ch4_enh_via_", site)]], na.rm = TRUE)
   sd_cams_ch4  <- sd(data[[paste0("cams_ch4_enh_via_", site)]], na.rm = TRUE)
   avg_cams_co2 <- mean(data[[paste0("cams_co2_enh_via_", site)]], na.rm = TRUE)
   sd_cams_co2  <- sd(data[[paste0("cams_co2_enh_via_", site)]], na.rm = TRUE)
   cams_print <- paste(
     "CAMS (", site, ") CO2 enhancement is",
     round(avg_cams_co2, 2), "±", round(sd_cams_co2, 2), "(ppm) and CAMS (", site,
     ") CH4 enhancement is",
     round(avg_cams_ch4, 2), "±", round(sd_cams_ch4, 2), "(ppb)"
   )
   
   # CarbonTracker (CT)
   avg_ct_ch4 <- mean(data[[paste0("ct_ch4_enh_via_", site)]], na.rm = TRUE)
   sd_ct_ch4  <- sd(data[[paste0("ct_ch4_enh_via_", site)]], na.rm = TRUE)
   avg_ct_co2 <- mean(data[[paste0("ct_co2_enh_via_", site)]], na.rm = TRUE)
   sd_ct_co2  <- sd(data[[paste0("ct_co2_enh_via_", site)]], na.rm = TRUE)
   ct_print <- paste(
     "CT (", site, ") CO2 enhancement is",
     round(avg_ct_co2, 2), "±", round(sd_ct_co2, 2), "(ppm) and CT (", site,
     ") CH4 enhancement is",
     round(avg_ct_ch4, 2), "±", round(sd_ct_ch4, 2), "(ppb)"
   )
   
   # Observations
   avg_obs_ch4 <- mean(data[[paste0("obs_ch4_enh_via_", site)]], na.rm = TRUE)
   sd_obs_ch4  <- sd(data[[paste0("obs_ch4_enh_via_", site)]], na.rm = TRUE)
   avg_obs_co2 <- mean(data[[paste0("obs_co2_enh_via_", site)]], na.rm = TRUE)
   sd_obs_co2  <- sd(data[[paste0("obs_co2_enh_via_", site)]], na.rm = TRUE)
   obs_print <- paste(
     "Obs (", site, ") CO2 enhancement is",
     round(avg_obs_co2, 2), "±", round(sd_obs_co2, 2), "(ppm) and Obs (", site,
     ") CH4 enhancement is",
     round(avg_obs_ch4, 2), "±", round(sd_obs_ch4, 2), "(ppb)"
   )
   
   list(cams = cams_print, ct = ct_print, obs = obs_print)
 }
 
# lew_results <- make_all_enh_prints(enh_info, "LEW")
 bva_results <- make_all_enh_prints(enh_info, "BVA")
 tmd_results <- make_all_enh_prints(enh_info, "TMD")
 
# print(lew_results)
 print(bva_results)
 print(tmd_results)
 
time_range <- c(head(enh_info$date, 1),tail(enh_info$date, 1)) 
date_text <- paste("Timeframe:",time_range[1],"through",time_range[2],"(Filtered for daylight hours only [10-16 EDT].)")

##### Scatter Plots Towers v Ship #####
library(ggplot2)
library(ggpubr)
library(tidyr)

# Define towers and species
towers <- c("BVA", "TMD")
species <- c("co2", "ch4")
models <- c("ct", "cams")

# Define plotting limits for each species
limits <- list(
  co2 = c(-10, 10),
  ch4 = c(-50, 50)
)

# Loop through combinations
for (tower in towers) {
  for (mod in models) {
    for (sp in species) {
      
      obs_col <- paste0("obs_", sp, "_enh_via_", tower)
      mod_col <- paste0(mod, "_", sp, "_enh_via_", tower)
      
      # Skip if columns don't exist
      if (!(obs_col %in% names(enh_info)) | !(mod_col %in% names(enh_info))) next
      
      overall_min <- limits[[sp]][1]
      overall_max <- limits[[sp]][2]
      
      label.x <- overall_min + 0.02 * (overall_max - overall_min)
      label.y <- overall_max - 0.02 * (overall_max - overall_min)
      
      title_text <- paste0(tower, " v Ship: Comparing ",
                           toupper(mod), " ", toupper(sp),
                           " Enh v Obs ", toupper(sp),
                           " Enh Cruise 14")
      
      y_label <- paste0(toupper(mod), " Ship Conc - ", toupper(mod),
                        " ", tower, " Conc (", toupper(sp),
                        ifelse(sp == "co2", " ppm)", " ppb)"))
      x_label <- paste0("Observed Ship Conc - Observed ", tower,
                        " Conc (", toupper(sp),
                        ifelse(sp == "co2", " ppm)", " ppb)"))
      
      p <- ggplot(enh_info, aes_string(x = obs_col, y = mod_col)) +
        geom_point() +
        geom_smooth(method = lm) +
        stat_regline_equation(aes(label = paste(..eq.label..,
                                                "*\", \"*",
                                                ..rr.label..,
                                                sep = "")),
                              label.x = label.x,
                              label.y = label.y) +
        geom_abline(intercept = 0, slope = 1, color = "red",
                    linetype = "dashed") +
        labs(
          title = title_text,
          x = x_label,
          y = y_label,
          subtitle = date_text
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
      
      print(p)  # Display each plot in sequence
    }
  }
}

##### Scatter Plots Towers v WNJ #####
library(ggplot2)
library(ggpubr)
library(tidyr)

# Towers to compare against WNJ
towers <- c( "BVA", "TMD")
species <- c("co2", "ch4")
models <- c("ct", "cams")

# Define plotting limits
limits <- list(
  co2 = c(-5, 10),
  ch4 = c(-50, 50)
)

# Loop through combinations
for (tower in towers) {
  for (mod in models) {
    for (sp in species) {
      
      obs_col <- paste0("obs_", sp, "_enh_via_", tower, "_4_WNJ")
      mod_col <- paste0(mod, "_", sp, "_enh_via_", tower, "_4_WNJ")
      
      # Skip if columns don't exist
      if (!(obs_col %in% names(enh_info)) | !(mod_col %in% names(enh_info))) next
      
      overall_min <- limits[[sp]][1]
      overall_max <- limits[[sp]][2]
      
      label.x <- overall_min + 0.02 * (overall_max - overall_min)
      label.y <- overall_max - 0.02 * (overall_max - overall_min)
      
      title_text <- paste0(tower, " v WNJ: Comparing ",
                           toupper(mod), " ", toupper(sp),
                           " Enh v Obs ", toupper(sp),
                           " Enh Cruise 14")
      
      x_label <- paste0("Observed WNJ Conc - Observed ", tower,
                        " Conc (", toupper(sp),
                        ifelse(sp == "co2", " Enhancement ppm)", " Enhancement ppb)"))
      
      y_label <- paste0(toupper(mod), " WNJ Conc - ", toupper(mod),
                        " ", tower, " Conc (", toupper(sp),
                        ifelse(sp == "co2", " Enhancement ppm)", " Enhancement ppb)"))
      
      p <- ggplot(enh_info, aes_string(x = obs_col, y = mod_col)) +
        geom_point() +
        geom_smooth(method = lm) +
        stat_regline_equation(aes(label = paste(
          ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
        )), label.x = label.x, label.y = label.y) +
        labs(
          title = title_text,
          x = x_label,
          y = y_label,
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
      
      print(p)  # display each plot in sequence
      
    }
  }
}



