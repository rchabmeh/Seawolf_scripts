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

Pz = 1015.1 * 100 #layer pressure hPa -> Pa
Po = 1013.25 * 100 #sea level pressure hPa -> Pa
R =  287 # J/kg/K
Temp = 55.5 #average temp in the US in F
Temp = (Temp - 32) * (5 / 9) + 273.15 #converted to K
g = 9.81 #gravitational accel constant m/s^2

delta_z <- ((R * Temp) / g) * log(Pz / Po)

#LEW tower is in Lewisburg, PA (Union County). GHG sources in the area include:
# 1. Bucknell University (32,878 mt CO2e [2022]) which is S of LEW (Lewisburg, PA)
# 2. Gold Bond - MLT Plant (45,494 mt CO2e [2022]) which is N of LEW (New Columbia, PA)

##### Loading in .csv file #####
enh_info <- read.csv(
  "/Volumes/Seagate/cruise19_eulerian/all_models_merged_cruise19tower_comparisons.csv"
)

##### Create enhancement columns (Tower v WNJ) #####

towers <- c("LEW")
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
      if (wnj_col %in% names(enh_info) &&
          tower_col %in% names(enh_info)) {
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
enh_info$local_time <- as.POSIXct(format(enh_info$date, tz = "America/New_York", usetz = TRUE), tz = "America/New_York")
enh_info$local_date <- as.Date(enh_info$local_time, tz = "America/New_York")

enh_info <- subset(enh_info, local_date == as.Date("2023-03-30"))

enh_info <- subset(enh_info,
                   format(local_time, "%H") >= "10" &
                     format(local_time, "%H") <= "16")

#ship avg enh
make_all_enh_prints <- function(data, site) {
  # CAMS
  avg_cams_ch4 <- mean(data[[paste0("cams_ch4_enh_via_", site)]], na.rm = TRUE)
  sd_cams_ch4  <- sd(data[[paste0("cams_ch4_enh_via_", site)]], na.rm = TRUE)
  avg_cams_co2 <- mean(data[[paste0("cams_co2_enh_via_", site)]], na.rm = TRUE)
  sd_cams_co2  <- sd(data[[paste0("cams_co2_enh_via_", site)]], na.rm = TRUE)
  cams_print <- paste(
    "CAMS (",
    site,
    ") CO2 enhancement is",
    round(avg_cams_co2, 2),
    "±",
    round(sd_cams_co2, 2),
    "(ppm) and CAMS (",
    site,
    ") CH4 enhancement is",
    round(avg_cams_ch4, 2),
    "±",
    round(sd_cams_ch4, 2),
    "(ppb)"
  )
  
  # CarbonTracker (CT)
  avg_ct_ch4 <- mean(data[[paste0("ct_ch4_enh_via_", site)]], na.rm = TRUE)
  sd_ct_ch4  <- sd(data[[paste0("ct_ch4_enh_via_", site)]], na.rm = TRUE)
  avg_ct_co2 <- mean(data[[paste0("ct_co2_enh_via_", site)]], na.rm = TRUE)
  sd_ct_co2  <- sd(data[[paste0("ct_co2_enh_via_", site)]], na.rm = TRUE)
  ct_print <- paste(
    "CT (",
    site,
    ") CO2 enhancement is",
    round(avg_ct_co2, 2),
    "±",
    round(sd_ct_co2, 2),
    "(ppm) and CT (",
    site,
    ") CH4 enhancement is",
    round(avg_ct_ch4, 2),
    "±",
    round(sd_ct_ch4, 2),
    "(ppb)"
  )
  
  # Observations
  avg_obs_ch4 <- mean(data[[paste0("obs_ch4_enh_via_", site)]], na.rm = TRUE)
  sd_obs_ch4  <- sd(data[[paste0("obs_ch4_enh_via_", site)]], na.rm = TRUE)
  avg_obs_co2 <- mean(data[[paste0("obs_co2_enh_via_", site)]], na.rm = TRUE)
  sd_obs_co2  <- sd(data[[paste0("obs_co2_enh_via_", site)]], na.rm = TRUE)
  obs_print <- paste(
    "Obs (",
    site,
    ") CO2 enhancement is",
    round(avg_obs_co2, 2),
    "±",
    round(sd_obs_co2, 2),
    "(ppm) and Obs (",
    site,
    ") CH4 enhancement is",
    round(avg_obs_ch4, 2),
    "±",
    round(sd_obs_ch4, 2),
    "(ppb)"
  )
  
  list(cams = cams_print, ct = ct_print, obs = obs_print)
}

# lew_results <- make_all_enh_prints(enh_info, "LEW")
bva_results <- make_all_enh_prints(enh_info, "BVA")
tmd_results <- make_all_enh_prints(enh_info, "TMD")

# print(lew_results)
print(bva_results)
print(tmd_results)

time_range <- c(head(enh_info$date, 1), tail(enh_info$date, 1))
date_text <- paste(
  "Timeframe:",
  time_range[1],
  "through",
  time_range[2],
  "(Filtered for daylight hours only [10-16 EDT].)"
)

##### Scatter Plots Towers v Ship #####
library(ggplot2)
library(ggpubr)
library(tidyr)

# Define towers and species
towers <- c("LEW")
species <- c("co2", "ch4")
models <- c("ct", "cams")

# Define plotting limits for each species
limits <- list(co2 = c(-10, 10), ch4 = c(-50, 50))

# Loop through combinations
for (tower in towers) {
  for (mod in models) {
    for (sp in species) {
      obs_col <- paste0("obs_", sp, "_enh_via_", tower)
      mod_col <- paste0(mod, "_", sp, "_enh_via_", tower)
      
      # Skip if columns don't exist
      if (!(obs_col %in% names(enh_info)) |
          !(mod_col %in% names(enh_info)))
        next
      
      overall_min <- limits[[sp]][1]
      overall_max <- limits[[sp]][2]
      
      label.x <- overall_min + 0.02 * (overall_max - overall_min)
      label.y <- overall_max - 0.02 * (overall_max - overall_min)
      
      title_text <- paste0(
        tower,
        " v Ship: Comparing ",
        toupper(mod),
        " ",
        toupper(sp),
        " Enh v Obs ",
        toupper(sp),
        " Enh Cruise 14"
      )
      
      y_label <- paste0(
        toupper(mod),
        " Ship Conc - ",
        toupper(mod),
        " ",
        tower,
        " Conc (",
        toupper(sp),
        ifelse(sp == "co2", " ppm)", " ppb)")
      )
      x_label <- paste0(
        "Observed Ship Conc - Observed ",
        tower,
        " Conc (",
        toupper(sp),
        ifelse(sp == "co2", " ppm)", " ppb)")
      )
      
      p <- ggplot(enh_info, aes_string(x = obs_col, y = mod_col)) +
        geom_point() +
        geom_smooth(method = lm) +
        stat_regline_equation(aes(label = paste(
          ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
        )),
        label.x = label.x,
        label.y = label.y) +
        geom_abline(
          intercept = 0,
          slope = 1,
          color = "red",
          linetype = "dashed"
        ) +
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
towers <- c("LEW")
species <- c("co2", "ch4")
models <- c("ct", "cams")

# Define plotting limits
limits <- list(co2 = c(-10, 10), ch4 = c(-60, 60))

# Loop through combinations
for (tower in towers) {
  for (mod in models) {
    for (sp in species) {
      obs_col <- paste0("obs_", sp, "_enh_via_", tower, "_4_WNJ")
      mod_col <- paste0(mod, "_", sp, "_enh_via_", tower, "_4_WNJ")
      
      # Skip if columns don't exist
      if (!(obs_col %in% names(enh_info)) |
          !(mod_col %in% names(enh_info)))
        next
      
      overall_min <- limits[[sp]][1]
      overall_max <- limits[[sp]][2]
      
      label.x <- overall_min + 0.02 * (overall_max - overall_min)
      label.y <- overall_max - 0.02 * (overall_max - overall_min)
      
      title_text <- paste0(
        tower,
        " v WNJ: Comparing ",
        toupper(mod),
        " ",
        toupper(sp),
        " Enh v Obs ",
        toupper(sp),
        " Enh WNJ tower"
      )
      
      x_label <- paste0(
        "Observed WNJ Conc - Observed ",
        tower,
        " Conc (",
        toupper(sp),
        ifelse(sp == "co2", " Enhancement ppm)", " Enhancement ppb)")
      )
      
      y_label <- paste0(
        toupper(mod),
        " WNJ Conc - ",
        toupper(mod),
        " ",
        tower,
        " Conc (",
        toupper(sp),
        ifelse(sp == "co2", " Enhancement ppm)", " Enhancement ppb)")
      )
      
      p <- ggplot(enh_info, aes_string(x = obs_col, y = mod_col)) +
        geom_point() +
        geom_smooth(method = lm) +
        stat_regline_equation(aes(label = paste(
          ..eq.label.., "*\", \"*", ..rr.label.., sep = ""
        )),
        label.x = label.x,
        label.y = label.y) +
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

#### Combining Enhancements #####
library(dplyr)

# Define cruises and dates of interest
cruise_info <- list(
  "cruise1" = list(path = "/Volumes/Seagate/cruise1_eulerian/all_models_merged_cruise1tower_comparisons.csv", date_filter = as.Date("2022-02-05")),
  "cruise4" = list(path = "/Volumes/Seagate/cruise4_eulerian/all_models_merged_cruise4.csv", date_filter = as.Date("2022-04-10")),
  "cruise13" = list(path = "/Volumes/Seagate/cruise13_eulerian/all_models_merged_cruise13tower_comparisons.csv", date_filter = as.Date("2022-09-28")),
  "cruise19" = list(path = "/Volumes/Seagate/cruise19_eulerian/all_models_merged_cruise19tower_comparisons.csv", date_filter = as.Date("2023-03-30"))
)

# Towers and model info
towers <- c("LEW")
species <- c("co2", "ch4")
models <- c("obs", "ct", "cams")

# Prepare empty list to store results
all_enh <- list()

# Loop through each cruise
for (cruise_name in names(cruise_info)) {
  info <- cruise_info[[cruise_name]]
  enh_info <- read.csv(info$path)
  
  ##### Create enhancement columns (Tower v WNJ) #####
  for (tower in towers) {
    for (mod in models) {
      for (sp in species) {
        wnj_col <- paste0(mod, "_mean_", sp, "_WNJ")
        tower_col <- paste0(mod, "_mean_", sp, "_", tower)
        new_col <- paste0(mod, "_", sp, "_enh_via_", tower, "_4_WNJ")
        
        if (wnj_col %in% names(enh_info) &&
            tower_col %in% names(enh_info)) {
          enh_info[[new_col]] <- enh_info[[wnj_col]] - enh_info[[tower_col]]
        } else {
          warning(paste("Missing columns for", new_col, "in", cruise_name))
        }
      }
    }
  }
  
  ##### Fix date formatting #####
  enh_info$date <- ifelse(
    grepl("^\\d{4}-\\d{2}-\\d{2}$", enh_info$date),
    paste0(enh_info$date, " 00:00:00"),
    enh_info$date
  )
  
  enh_info$date <- as.POSIXct(enh_info$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  enh_info$local_time <- as.POSIXct(format(enh_info$date, tz = "America/New_York", usetz = TRUE),
                                    tz = "America/New_York")
  enh_info$local_date <- as.Date(enh_info$local_time, tz = "America/New_York")
  
  ##### Apply date and hour filters #####
  enh_info <- subset(enh_info, local_date == info$date_filter)
  enh_info <- subset(enh_info,
                     format(local_time, "%H") >= "10" &
                       format(local_time, "%H") <= "16")
  
  ##### Tag with cruise ID #####
  enh_info$cruise <- cruise_name
  
  ##### Save processed data #####
  all_enh[[cruise_name]] <- enh_info
}

# Combine all cruises into one dataframe
enh_combined <- do.call(rbind, all_enh)

# Check combined data
print(dim(enh_combined))
print(unique(enh_combined$cruise))
##### Plot ####
library(ggplot2)
library(ggpubr)
library(tidyr)

# Towers to compare against WNJ
towers <- c("LEW")
species <- c("co2", "ch4")
models <- c("ct", "cams")

# Define plotting limits
limits <- list(co2 = c(-10, 10), ch4 = c(-60, 60))

# Loop through combinations
for (tower in towers) {
  for (mod in models) {
    for (sp in species) {
      obs_col <- paste0("obs_", sp, "_enh_via_", tower, "_4_WNJ")
      mod_col <- paste0(mod, "_", sp, "_enh_via_", tower, "_4_WNJ")
      
      # Skip if columns don't exist
      if (!(obs_col %in% names(enh_combined)) |
          !(mod_col %in% names(enh_combined)))
        next
      
      overall_min <- limits[[sp]][1]
      overall_max <- limits[[sp]][2]
      
      label.x <- overall_min + 0.02 * (overall_max - overall_min)
      label.y <- overall_max - 0.02 * (overall_max - overall_min)
      
      title_text <- paste0(
        tower,
        " v WNJ: Comparing ",
        toupper(mod),
        " ",
        toupper(sp),
        " Enh v Obs ",
        toupper(sp),
        " NJ Tower (WNJ) Enhancement Test Cases"
      )
      
      x_label <- paste0(
        "Observed WNJ Conc - Observed ",
        tower,
        " Conc (",
        toupper(sp),
        ifelse(sp == "co2", " Enhancement ppm)", " Enhancement ppb)")
      )
      
      y_label <- paste0(
        toupper(mod),
        " WNJ Conc - ",
        toupper(mod),
        " ",
        tower,
        " Conc (",
        toupper(sp),
        ifelse(sp == "co2", " Enhancement ppm)", " Enhancement ppb)")
      )
      
      p <- ggplot(enh_combined,
                  aes_string(x = obs_col, y = mod_col, color = "local_date")) +
        geom_point(size = 2, alpha = 0.8) +
        geom_smooth(method = lm,
                    se = FALSE,
                    color = "black") +
        stat_regline_equation(
          aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
          label.x = label.x,
          label.y = label.y,
          color = "black"
        ) +
        labs(
          title = title_text,
          x = x_label,
          y = y_label,
          color = "Test Case Dates"
        ) +
        geom_abline(
          intercept = 0,
          slope = 1,
          color = "red",
          linetype = "dashed"
        ) +
        geom_hline(yintercept = 0, color = "grey55") +
        geom_vline(xintercept = 0, color = "grey55") +
        coord_fixed(
          ratio = 1,
          xlim = c(overall_min, overall_max),
          ylim = c(overall_min, overall_max)
        ) +
        scale_color_gradientn(
          colours = rainbow(7),
          # convert numeric day values back to Date for labeling
          labels = function(x)
            format(as.Date(x, origin = "1970-01-01"), "%Y-%m-%d"),
          breaks = pretty(as.numeric(enh_combined$local_date), n = 6)
        ) +
        theme(
          axis.text = element_text(size = 14),
          axis.title = element_text(size = 16),
          plot.title = element_text(size = 20),
          legend.title = element_text(size = 14),
          legend.text = element_text(size = 10)
        )
      
      
      print(p)  # show each plot
      
    }
  }
}


##### Resolution Planning #####
library(raster)
extent_region <- extent(-80, -70, 37, 43)
for (res in c(0.01 ,0.1, 0.2, 0.25, 0.5, 1)) {
  r <- raster(ext = extent_region, res = res)
  cat("Resolution:", res, "degrees ->", ncell(r), "cells\n")
}





##### Plotting 2022 Tower comparison #####
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


