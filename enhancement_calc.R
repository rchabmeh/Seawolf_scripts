#Run towers.R first to generate tower .csv files if not already
#Updated last on August 25, 2025
#####_____________________________________________________________________ #####
##### 1. Loading in completed tower .csv files ####

#TOWERS CO2- MAKE THIS AUTOMATIC PROB BASED ON CRUISE #
LEW_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_LEW.csv")
BVA_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_BVA.csv")
TMD_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_TMD.csv")
WNJ_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_WNJ.csv")

#TOWERS CH4- MAKE THIS AUTOMATIC PROB BASED ON CRUISE #
LEW_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_LEW.csv")
BVA_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_BVA.csv")
TMD_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_TMD.csv")
WNJ_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_WNJ.csv")

##### 2. LOOK @ TRAJECTORY MAP TO SEE WHICH TOWERS ARE YOUR BACKGROUND #####
background_towers <- c("BVA", "TMD", "WNJ") #"LEW"

rm(list = ls()[!grepl(paste0("^(", paste(background_towers, collapse = "|"), ")"), ls())])

tower_data <- mget(ls())

for (nm in names(tower_data)) {
  tower_data[[nm]]$DATE <- as.POSIXct(ifelse(
    nchar(tower_data[[nm]]$DATE) == 10,
    paste0(tower_data[[nm]]$DATE, " 00:00:00"),
    tower_data[[nm]]$DATE
  ),
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC")
}




##### 3. Set time limit #####
start_date <- as.Date("2023-10-12")
end_date <- as.Date("2023-10-17")

#####_______________ 4. Setting cruise to 3 hour average _________________ #####
#### Loading in cruise and averaging to 3 hours ####
cruise = "Cruise 24"
cruise_squish <- tolower(gsub(" ", "", cruise))
cruise_info <- read.delim(
  paste0(
    "/Volumes/Seagate/",
    cruise_squish,
    "_eulerian/all_data_",
    cruise_squish,
    ".txt"
  ),
  sep = ",",
  dec = "."
)

names(cruise_info)[names(cruise_info) == "co2_subrange"] <- "CO2_dry_cal_moving_day"
names(cruise_info)[names(cruise_info) == "ch4_subrange"] <- "CH4_dry_cal_moving_day"
names(cruise_info)[names(cruise_info) == "time_local_subrange"] <- "Time_local"
names(cruise_info)[names(cruise_info) == "time_utc_subrange"] <- "Time_UTC"
names(cruise_info)[names(cruise_info) == "latitude_deg_subrange"] <- "Latitude_deg"
names(cruise_info)[names(cruise_info) == "longitude_deg_subrange"] <- "Longitude_deg"

cruise_info <- cruise_info[!is.na(cruise_info$Longitude_deg), ]
cruise_info <- cruise_info[!is.na(cruise_info$CO2_dry_cal_moving_day), ]
cruise_info$Time_local <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "America/New_York")
cruise_info$Time_UTC <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "UTC")

library(openair)
colnames(cruise_info)[colnames(cruise_info) == "Time_UTC"] <- "date"
cruise_info$Day <- as.Date(cruise_info$date)
cruise_info_3hr <- timeAverage(
  cruise_info,
  avg.time = "3 hour",
  data.thresh = 0,
  statistic = "mean"
)

library(hms)
cruise_info_3hr$time_only <- as_hms(cruise_info_3hr$date)

cruise_info_3hr <- cruise_info_3hr[cruise_info_3hr$date >= as.POSIXct(start_date) &
                                     cruise_info_3hr$date <= as.POSIXct(end_date) + 86400 - 1, ]

cruise_info_3hr$CH4_dry_cal_moving_day = cruise_info_3hr$CH4_dry_cal_moving_day *
  1000

##### Loading in basic CT files ######
library(raster)
CT_CO2 <- list()
files <- list.files(
  paste0(
    '/Volumes/Seagate/',
    cruise_squish,
    '_eulerian/carbon_tracker_co2_total/'
  ),
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
  paste0(
    '/Volumes/Seagate/',
    cruise_squish,
    '_eulerian/carbon_tracker_ch4_total'
  ),
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

library(ncdf4)
library(raster)
library(lubridate)

CT_CO2 <- list()
files <- list.files(
  paste0(
    '/Volumes/Seagate/',
    cruise_squish,
    '_eulerian/carbon_tracker_co2_total/'
  ),
  pattern = '*.nc',
  full.names = TRUE
)
nc <- nc_open(files[[1]])
time_vals <- nc$dim$time$vals
origin <- as.POSIXct("2000-01-01 00:00:00", tz = "UTC")
actual_time <- origin + time_vals * 86400

# Define time window (±1.5 hours)
start_times <- actual_time - 1.5 * 3600
end_times   <- actual_time + 1.5 * 3600
interval_labels <- data.frame(
  Times_UTC = paste0(
    format(start_times, "%H:%M"),
    "–",
    format(end_times, "%H:%M UTC")
  ),
  Grouping = 1:length(start_times)
)
start_ny <- lubridate::with_tz(start_times, tzone = "America/New_York")
end_ny   <- lubridate::with_tz(end_times, tzone = "America/New_York")
interval_labels$Times_NY <- paste0(format(start_ny, "%H:%M"), "–", format(end_ny, "%H:%M %Z"))
print(interval_labels)

##### Loading in CT-NRT CO2 ######
#CO2
library(hms)
cruise_info_3hr$CT_CO2_tile <- NA_real_

start_time <- as_hms("00:00:00")
end_time   <- as_hms("03:00:00")

for (i in seq_along(CTCO2_1)) {
  cropped_raster <- CTCO2_1[[i]][[1]]
  name_string <- CTCO2_1[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c1_df <- cruise_info_3hr[row_index, ]
      this_time <- c1_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c1_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("03:00:00")
end_time   <- as_hms("06:00:00")

for (i in seq_along(CTCO2_2)) {
  cropped_raster <- CTCO2_2[[i]][[1]]
  name_string <- CTCO2_2[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c2_df <- cruise_info_3hr[row_index, ]
      this_time <- c2_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c2_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("06:00:00")
end_time   <- as_hms("09:00:00")

for (i in seq_along(CTCO2_3)) {
  cropped_raster <- CTCO2_3[[i]][[1]]
  name_string <- CTCO2_3[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c3_df <- cruise_info_3hr[row_index, ]
      this_time <- c3_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c3_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("09:00:00")
end_time   <- as_hms("12:00:00")

for (i in seq_along(CTCO2_4)) {
  cropped_raster <- CTCO2_4[[i]][[1]]
  name_string <- CTCO2_4[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c4_df <- cruise_info_3hr[row_index, ]
      this_time <- c4_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c4_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("12:00:00")
end_time   <- as_hms("15:00:00")

for (i in seq_along(CTCO2_5)) {
  cropped_raster <- CTCO2_5[[i]][[1]]
  name_string <- CTCO2_5[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c5_df <- cruise_info_3hr[row_index, ]
      this_time <- c5_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c5_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

library(hms)
start_time <- as_hms("15:00:00")
end_time   <- as_hms("18:00:00")

for (i in seq_along(CTCO2_6)) {
  cropped_raster <- CTCO2_6[[i]][[1]]
  name_string <- CTCO2_6[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c6_df <- cruise_info_3hr[row_index, ]
      this_time <- c6_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c6_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

library(hms)
start_time <- as_hms("18:00:00")
end_time   <- as_hms("21:00:00")

for (i in seq_along(CTCO2_7)) {
  cropped_raster <- CTCO2_7[[i]][[1]]
  name_string <- CTCO2_7[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c7_df <- cruise_info_3hr[row_index, ]
      this_time <- c7_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c7_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

start_time <- as_hms("21:00:00")
end_time   <- as_hms("23:59:59")

for (i in seq_along(CTCO2_8)) {
  cropped_raster <- CTCO2_8[[i]][[1]]
  name_string <- CTCO2_8[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c8_df <- cruise_info_3hr[row_index, ]
      this_time <- c8_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c8_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_3hr$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

##### Loading in CT CH4 ######
#CH4
library(hms)
cruise_info_3hr$CT_CH4_tile <- NA_real_

start_time <- as_hms("00:00:00")
end_time   <- as_hms("03:00:00")

for (i in seq_along(CTCH4_1)) {
  cropped_raster <- CTCH4_1[[i]][[1]]
  name_string <- CTCH4_1[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("03:00:00")
end_time   <- as_hms("06:00:00")

for (i in seq_along(CTCH4_2)) {
  cropped_raster <- CTCH4_2[[i]][[1]]
  name_string <- CTCH4_2[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("06:00:00")
end_time   <- as_hms("09:00:00")

for (i in seq_along(CTCH4_3)) {
  cropped_raster <- CTCH4_3[[i]][[1]]
  name_string <- CTCH4_3[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("09:00:00")
end_time   <- as_hms("12:00:00")

for (i in seq_along(CTCH4_4)) {
  cropped_raster <- CTCH4_4[[i]][[1]]
  name_string <- CTCH4_4[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("12:00:00")
end_time   <- as_hms("15:00:00")

for (i in seq_along(CTCH4_5)) {
  cropped_raster <- CTCH4_5[[i]][[1]]
  name_string <- CTCH4_5[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("15:00:00")
end_time   <- as_hms("18:00:00")

for (i in seq_along(CTCH4_6)) {
  cropped_raster <- CTCH4_6[[i]][[1]]
  name_string <- CTCH4_6[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("18:00:00")
end_time   <- as_hms("21:00:00")

for (i in seq_along(CTCH4_7)) {
  cropped_raster <- CTCH4_7[[i]][[1]]
  name_string <- CTCH4_7[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

start_time <- as_hms("21:00:00")
end_time   <- as_hms("23:59:59")

for (i in seq_along(CTCH4_8)) {
  cropped_raster <- CTCH4_8[[i]][[1]]
  name_string <- CTCH4_8[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_3hr$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_3hr[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_3hr$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

cruise_info_3hr$CT_CH4_tile <- cruise_info_3hr$CT_CH4_tile

##### Loading in CAMS information ######
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
  df_long$date <- as.POSIXct(df_long$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  df_long$gas <- ifelse(grepl("CO2", file_key, ignore.case = TRUE), "CO2", "CH4")
  df_long$source <- file_key
  
  df_long
})

CAMS_combined <- do.call(rbind, CAMS_df_list)
CAMS_split <- split(CAMS_combined, CAMS_combined$gas)

CAMS_CO2_df <- CAMS_split[["CO2"]]
CAMS_CH4_df <- CAMS_split[["CH4"]]

grid_data_ch4 <- CAMS_CH4_df %>%
  group_by(date) %>%
  summarise(ch4_conc = mean(concentration, na.rm = TRUE) / 1000) %>%
  rename(window_start_ch4 = date)

cruise_info_3hr <- cruise_info_3hr %>% mutate(window_start_ch4 = floor_date(date, unit = "6 hours"))
joined <- cruise_info_3hr %>%
  mutate(window_start_ch4 = floor_date(date, unit = "6 hours")) %>%
  left_join(grid_data_ch4, by = "window_start_ch4")

grid_data_co2 <- CAMS_CO2_df %>%
  group_by(date) %>%
  summarise(co2_conc = mean(concentration, na.rm = TRUE)) %>%
  rename(window_start_co2 = date)

joined <- joined %>% mutate(window_start_co2 = floor_date(date, unit = "3 hours"))
joined <- joined %>% left_join(grid_data_co2, by = "window_start_co2")

joined <- joined %>% select(-window_start_co2, -window_start_ch4, -time_only, -Day)

names(joined)[names(joined) == "date"] <- "Date_UTC"
names(joined)[names(joined) == "CO2_dry_cal_moving_day"] <- "Observed_CO2"
names(joined)[names(joined) == "CH4_dry_cal_moving_day"] <- "Observed_CH4"
names(joined)[names(joined) == "CT_CO2_tile"] <- "CT_CO2"
names(joined)[names(joined) == "CT_CH4_tile"] <- "CT_CH4"
names(joined)[names(joined) == "co2_conc"] <- "CAMS_CO2"
names(joined)[names(joined) == "ch4_conc"] <- "CAMS_CH4"
joined <- joined[, c(1, 4, 5, 6, 2, 3, 7, 8, 10, 9)]

joined$Bias_CT_CO2 <- joined$CT_CO2 - joined$Observed_CO2
joined$Bias_CT_CH4 <- joined$CT_CH4 - joined$Observed_CH4
joined$Bias_CAMS_CO2 <- joined$CAMS_CO2 - joined$Observed_CO2
joined$Bias_CAMS_CH4 <- joined$CAMS_CH4 - joined$Observed_CH4
joined$Bias_CT_CO2_SD <- sd(joined$Bias_CT_CO2, na.rm = T)
joined$Bias_CT_CH4_SD <- sd(joined$Bias_CT_CH4, na.rm = T)
joined$Bias_CAMS_CO2_SD <- sd(joined$Bias_CAMS_CO2, na.rm = T)
joined$Bias_CAMS_CH4_SD <- sd(joined$Bias_CAMS_CH4, na.rm = T)

#####___________________5. Observation comparisons_________________________ #####
##### Creating combined ship and tower observation data frames #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_co2_obs <- joined %>%
  select(date, Observed_CO2) %>%
  mutate(Source = "Ship", CO2 = Observed_CO2) %>%
  select(date, CO2, Source)


tower_df_co2_obs <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"Obs_CO2_ppm" %in% names(df))
    return(NULL)
  tower_code <- gsub("_co2$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CO2 = Obs_CO2_ppm) %>%
    select(DATE, CO2, Source) %>%
    rename(date = DATE)
})

all_data_co2_obs <- bind_rows(ship_df_co2_obs, tower_df_co2_obs)

ship_unique <- ship_df_co2_obs %>%
  group_by(date) %>%
  summarise(CO2 = mean(CO2, na.rm = TRUE)) %>%
  mutate(Source_id = "Ship")

tower_numbered <- tower_df_co2_obs %>%
  group_by(Source, date) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  unite("Source_id", Source, id, sep = "_")

combined <- bind_rows(ship_unique, tower_numbered %>% select(date, CO2, Source_id))

wide_data_co2_obs <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CO2) %>%
  arrange(date)
#need to make automated- comment 8/24/25
wide_data_co2_obs$mean_BVA <- (wide_data_co2_obs$BVA_1 + wide_data_co2_obs$BVA_2) /
  2
wide_data_co2_obs$mean_TMD <- (wide_data_co2_obs$TMD_1 + wide_data_co2_obs$TMD_2) /
  2
wide_data_co2_obs$mean_WNJ <- (wide_data_co2_obs$WNJ_1 + wide_data_co2_obs$WNJ_2) /
  2

final_obs_co2 <- wide_data_co2_obs[, c(1, 2, 9, 10, 11)]

#need to automate - comment 8/24/25
final_obs_co2$enh_via_BVA <- final_obs_co2$Ship - final_obs_co2$mean_BVA
final_obs_co2$enh_via_TMD <- final_obs_co2$Ship - final_obs_co2$mean_TMD
final_obs_co2$enh_via_WNJ <- final_obs_co2$Ship - final_obs_co2$mean_WNJ

library(reshape2)
final_obs_long_co2 <- melt(
  final_obs_co2,
  id.vars = "date",
  measure.vars = c("enh_via_BVA", "enh_via_TMD", "enh_via_WNJ"),
  variable.name = "Tower",
  value.name = "CO2"
)

final_obs_long_co2$Tower <- gsub("enh_via_", "", final_obs_long_co2$Tower)


#CH4
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_ch4_obs <- joined %>%
  select(date, Observed_CH4) %>%
  mutate(Source = "Ship", CH4 = Observed_CH4) %>%
  select(date, CH4, Source)


tower_df_ch4_obs <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"Obs_CH4_ppb" %in% names(df))
    return(NULL)
  tower_code <- gsub("_ch4$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CH4 = Obs_CH4_ppb) %>%
    select(DATE, CH4, Source) %>%
    rename(date = DATE)
})

all_data_ch4_obs <- bind_rows(ship_df_ch4_obs, tower_df_ch4_obs)

ship_unique <- ship_df_ch4_obs %>%
  group_by(date) %>%
  summarise(CH4 = mean(CH4, na.rm = TRUE)) %>%
  mutate(Source_id = "Ship")

tower_numbered <- tower_df_ch4_obs %>%
  group_by(Source, date) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  unite("Source_id", Source, id, sep = "_")

combined <- bind_rows(ship_unique, tower_numbered %>% select(date, CH4, Source_id))

wide_data_ch4_obs <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CH4) %>%
  arrange(date)

#need to make automated- comment 8/24/25
wide_data_ch4_obs$mean_BVA <- (wide_data_ch4_obs$BVA_1 + wide_data_ch4_obs$BVA_2) /
  2
wide_data_ch4_obs$mean_TMD <- (wide_data_ch4_obs$TMD_1 + wide_data_ch4_obs$TMD_2) /
  2
wide_data_ch4_obs$mean_WNJ <- (wide_data_ch4_obs$WNJ_1 + wide_data_ch4_obs$WNJ_2) /
  2

final_obs_ch4 <- wide_data_ch4_obs[, c(1, 2, 9, 10, 11)]

#make automated - comment 8/24/25
final_obs_ch4$enh_via_BVA <- final_obs_ch4$Ship - final_obs_ch4$mean_BVA
final_obs_ch4$enh_via_TMD <- final_obs_ch4$Ship - final_obs_ch4$mean_TMD
final_obs_ch4$enh_via_WNJ <- final_obs_ch4$Ship - final_obs_ch4$mean_WNJ

library(reshape2)
final_obs_long_ch4 <- melt(
  final_obs_ch4,
  id.vars = "date",
  measure.vars = c("enh_via_BVA", "enh_via_TMD", "enh_via_WNJ"),
  variable.name = "Tower",
  value.name = "CH4"
)

final_obs_long_ch4$Tower <- gsub("enh_via_", "", final_obs_long_ch4$Tower)


keep <- c(
  "joined",
  "final_obs_co2",
  "final_obs_ch4",
  "ship_df_ch4_obs",
  "ship_df_co2_obs",
  "tower_data",
  "tower_df_co2_obs",
  "tower_df_ch4_obs",
  "cruise",
  "final_obs_long_co2",
  "final_obs_long_ch4",
  "interval_labels"
)
rm(list = setdiff(ls(), keep))

View(final_obs_co2)
View(final_obs_ch4)

##### Plotting tower observation against ship observation #####
#CO2 obs plot comparison
ggplot() +
  geom_ribbon(
    data = ship_df_co2_obs,
    aes(x = date, ymin = 415, ymax = CO2),
    fill = "darkgrey",
    alpha = 0.5
  ) +
  geom_line(data = ship_df_co2_obs,
            aes(x = date, y = CO2, color = Source),
            linewidth = 1) +
  geom_point(data = ship_df_co2_obs,
             aes(x = date, y = CO2, color = Source),
             size = 2) +
  geom_line(data = tower_df_co2_obs,
            aes(x = date, y = CO2, color = Source),
            linewidth = 1) +
  geom_point(data = tower_df_co2_obs,
             aes(x = date, y = CO2, color = Source),
             size = 2) +
  scale_color_manual(values = c(
    "Ship" = "black",
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Observation comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 obs plot comparison
ggplot() +
  geom_ribbon(
    data = ship_df_ch4_obs,
    aes(x = date, ymin = 1975, ymax = CH4),
    fill = "darkgrey",
    alpha = 0.5
  ) +
  geom_line(data = ship_df_ch4_obs,
            aes(x = date, y = CH4, color = Source),
            linewidth = 1) +
  geom_point(data = ship_df_ch4_obs,
             aes(x = date, y = CH4, color = Source),
             size = 2) +
  geom_line(data = tower_df_ch4_obs,
            aes(x = date, y = CH4, color = Source),
            linewidth = 1) +
  geom_point(data = tower_df_ch4_obs,
             aes(x = date, y = CH4, color = Source),
             size = 2) +
  scale_color_manual(values = c(
    "Ship" = "black",
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Observation comparison for", cruise),
    x = "Date UTC",
    y = "CH4 (ppb)"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CO2 enhancement comparison
library(ggplot2)
ggplot(final_obs_long_co2, aes(x = date, y = CO2, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Observed enhancement comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 enhancement comparison
library(ggplot2)
ggplot(final_obs_long_ch4, aes(x = date, y = CH4, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Observed enhancement comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#####___________________6. CT comparisons_________________________ #####
##### Creating combined ship and tower carbon tracker data frames #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_co2_ct <- joined %>%
  select(date, CT_CO2) %>%
  mutate(Source = "Ship", CO2 = CT_CO2) %>%
  select(date, CO2, Source)


tower_df_co2_ct <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CT_CO2" %in% names(df))
    return(NULL)
  tower_code <- gsub("_co2$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CO2 = CT_CO2) %>%
    select(DATE, CO2, Source) %>%
    rename(date = DATE)
})

all_data_co2_ct <- bind_rows(ship_df_co2_ct, tower_df_co2_ct)

ship_unique <- ship_df_co2_ct %>%
  group_by(date) %>%
  summarise(CO2 = mean(CO2, na.rm = TRUE)) %>%
  mutate(Source_id = "Ship")

tower_numbered <- tower_df_co2_ct %>%
  group_by(Source, date) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  unite("Source_id", Source, id, sep = "_")

combined <- bind_rows(ship_unique, tower_numbered %>% select(date, CO2, Source_id))

wide_data_co2_ct <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CO2) %>%
  arrange(date)
#need to make automated- comment 8/24/25
wide_data_co2_ct$mean_BVA <- (wide_data_co2_ct$BVA_1 + wide_data_co2_ct$BVA_2) /
  2
wide_data_co2_ct$mean_TMD <- (wide_data_co2_ct$TMD_1 + wide_data_co2_ct$TMD_2) /
  2
wide_data_co2_ct$mean_WNJ <- (wide_data_co2_ct$WNJ_1 + wide_data_co2_ct$WNJ_2) /
  2

final_ct_co2 <- wide_data_co2_ct[, c(1, 2, 9, 10, 11)]

#need to automate - comment 8/24/25
final_ct_co2$enh_via_BVA <- final_ct_co2$Ship - final_ct_co2$mean_BVA
final_ct_co2$enh_via_TMD <- final_ct_co2$Ship - final_ct_co2$mean_TMD
final_ct_co2$enh_via_WNJ <- final_ct_co2$Ship - final_ct_co2$mean_WNJ

library(reshape2)
final_ct_long_co2 <- melt(
  final_ct_co2,
  id.vars = "date",
  measure.vars = c("enh_via_BVA", "enh_via_TMD", "enh_via_WNJ"),
  variable.name = "Tower",
  value.name = "CO2"
)

final_ct_long_co2$Tower <- gsub("enh_via_", "", final_ct_long_co2$Tower)


#CH4
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_ch4_ct <- joined %>%
  select(date, CT_CH4) %>%
  mutate(Source = "Ship", CH4 = CT_CH4) %>%
  select(date, CH4, Source)


tower_df_ch4_ct <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CT_CH4" %in% names(df))
    return(NULL)
  tower_code <- gsub("_ch4$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CH4 = CT_CH4) %>%
    select(DATE, CH4, Source) %>%
    rename(date = DATE)
})

all_data_ch4_ct <- bind_rows(ship_df_ch4_ct, tower_df_ch4_ct)

ship_unique <- ship_df_ch4_ct %>%
  group_by(date) %>%
  summarise(CH4 = mean(CH4, na.rm = TRUE)) %>%
  mutate(Source_id = "Ship")

tower_numbered <- tower_df_ch4_ct %>%
  group_by(Source, date) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  unite("Source_id", Source, id, sep = "_")

combined <- bind_rows(ship_unique, tower_numbered %>% select(date, CH4, Source_id))

wide_data_ch4_ct <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CH4) %>%
  arrange(date)

#need to make automated- comment 8/24/25
wide_data_ch4_ct$mean_BVA <- (wide_data_ch4_ct$BVA_1 + wide_data_ch4_ct$BVA_2) /
  2
wide_data_ch4_ct$mean_TMD <- (wide_data_ch4_ct$TMD_1 + wide_data_ch4_ct$TMD_2) /
  2
wide_data_ch4_ct$mean_WNJ <- (wide_data_ch4_ct$WNJ_1 + wide_data_ch4_ct$WNJ_2) /
  2

final_ct_ch4 <- wide_data_ch4_ct[, c(1, 2, 9, 10, 11)]

#make automated - comment 8/24/25
final_ct_ch4$enh_via_BVA <- final_ct_ch4$Ship - final_ct_ch4$mean_BVA
final_ct_ch4$enh_via_TMD <- final_ct_ch4$Ship - final_ct_ch4$mean_TMD
final_ct_ch4$enh_via_WNJ <- final_ct_ch4$Ship - final_ct_ch4$mean_WNJ

library(reshape2)
final_ct_long_ch4 <- melt(
  final_ct_ch4,
  id.vars = "date",
  measure.vars = c("enh_via_BVA", "enh_via_TMD", "enh_via_WNJ"),
  variable.name = "Tower",
  value.name = "CH4"
)

final_ct_long_ch4$Tower <- gsub("enh_via_", "", final_ct_long_ch4$Tower)

View(final_ct_co2)
View(final_ct_ch4)

##### Plotting tower carbon tracker against ship carbon tracker #####
#CO2 obs plot comparison
ggplot() +
  geom_ribbon(
    data = ship_df_co2_ct,
    aes(x = date, ymin = 415, ymax = CO2),
    fill = "darkgrey",
    alpha = 0.5
  ) +
  geom_line(data = ship_df_co2_ct,
            aes(x = date, y = CO2, color = Source),
            linewidth = 1) +
  geom_point(data = ship_df_co2_ct,
             aes(x = date, y = CO2, color = Source),
             size = 2) +
  geom_line(data = tower_df_co2_ct,
            aes(x = date, y = CO2, color = Source),
            linewidth = 1) +
  geom_point(data = tower_df_co2_ct,
             aes(x = date, y = CO2, color = Source),
             size = 2) +
  scale_color_manual(values = c(
    "Ship" = "black",
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Carbon Tracker comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 obs plot comparison
ggplot() +
  geom_ribbon(
    data = ship_df_ch4_ct,
    aes(x = date, ymin = 1975, ymax = CH4),
    fill = "darkgrey",
    alpha = 0.5
  ) +
  geom_line(data = ship_df_ch4_ct,
            aes(x = date, y = CH4, color = Source),
            linewidth = 1) +
  geom_point(data = ship_df_ch4_ct,
             aes(x = date, y = CH4, color = Source),
             size = 2) +
  geom_line(data = tower_df_ch4_ct,
            aes(x = date, y = CH4, color = Source),
            linewidth = 1) +
  geom_point(data = tower_df_ch4_ct,
             aes(x = date, y = CH4, color = Source),
             size = 2) +
  scale_color_manual(values = c(
    "Ship" = "black",
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Carbon Tracker comparison for", cruise),
    x = "Date UTC",
    y = "CH4 (ppb)"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CO2 enhancement comparison
library(ggplot2)
ggplot(final_ct_long_co2, aes(x = date, y = CO2, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Carbon Tracker enhancement comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 enhancement comparison
library(ggplot2)
ggplot(final_ct_long_ch4, aes(x = date, y = CH4, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: Carbon Tracker enhancement comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#####___________________7. CAMS comparisons_________________________ #####
##### Creating combined ship and tower CAMS data frames #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_co2_cams <- joined %>%
  select(date, CAMS_CO2) %>%
  mutate(Source = "Ship", CO2 = CAMS_CO2) %>%
  select(date, CO2, Source)


tower_df_co2_cams <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CAMs_CO2" %in% names(df))
    return(NULL)
  tower_code <- gsub("_co2$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CO2 = CAMs_CO2) %>%
    select(DATE, CO2, Source) %>%
    rename(date = DATE)
})

all_data_co2_cams <- bind_rows(ship_df_co2_cams, tower_df_co2_cams)

ship_unique <- ship_df_co2_cams %>%
  group_by(date) %>%
  summarise(CO2 = mean(CO2, na.rm = TRUE)) %>%
  mutate(Source_id = "Ship")

tower_numbered <- tower_df_co2_cams %>%
  group_by(Source, date) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  unite("Source_id", Source, id, sep = "_")

combined <- bind_rows(ship_unique, tower_numbered %>% select(date, CO2, Source_id))

wide_data_co2_cams <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CO2) %>%
  arrange(date)
#need to make automated- comment 8/24/25
wide_data_co2_cams$mean_BVA <- (wide_data_co2_cams$BVA_1 + wide_data_co2_cams$BVA_2) /
  2
wide_data_co2_cams$mean_TMD <- (wide_data_co2_cams$TMD_1 + wide_data_co2_cams$TMD_2) /
  2
wide_data_co2_cams$mean_WNJ <- (wide_data_co2_cams$WNJ_1 + wide_data_co2_cams$WNJ_2) /
  2

final_cams_co2 <- wide_data_co2_cams[, c(1, 2, 9, 10, 11)]

#need to automate - comment 8/24/25
final_cams_co2$enh_via_BVA <- final_cams_co2$Ship - final_cams_co2$mean_BVA
final_cams_co2$enh_via_TMD <- final_cams_co2$Ship - final_cams_co2$mean_TMD
final_cams_co2$enh_via_WNJ <- final_cams_co2$Ship - final_cams_co2$mean_WNJ

library(reshape2)
final_cams_long_co2 <- melt(
  final_cams_co2,
  id.vars = "date",
  measure.vars = c("enh_via_BVA", "enh_via_TMD", "enh_via_WNJ"),
  variable.name = "Tower",
  value.name = "CO2"
)

final_cams_long_co2$Tower <- gsub("enh_via_", "", final_cams_long_co2$Tower)


#CH4
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC
joined$CAMS_CH4 <- joined$CAMS_CH4 * 1000
ship_df_ch4_cams <- joined %>%
  select(date, CAMS_CH4) %>%
  mutate(Source = "Ship", CH4 = CAMS_CH4) %>%
  select(date, CH4, Source)


tower_df_ch4_cams <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CAMs_CH4" %in% names(df))
    return(NULL)
  tower_code <- gsub("_ch4$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CH4 = CAMs_CH4) %>%
    select(DATE, CH4, Source) %>%
    rename(date = DATE)
})

all_data_ch4_ct <- bind_rows(ship_df_ch4_cams, tower_df_ch4_cams)

ship_unique <- ship_df_ch4_cams %>%
  group_by(date) %>%
  summarise(CH4 = mean(CH4, na.rm = TRUE)) %>%
  mutate(Source_id = "Ship")

tower_numbered <- tower_df_ch4_cams %>%
  group_by(Source, date) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  unite("Source_id", Source, id, sep = "_")

combined <- bind_rows(ship_unique, tower_numbered %>% select(date, CH4, Source_id))

wide_data_ch4_cams <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CH4) %>%
  arrange(date)

#need to make automated- comment 8/24/25
wide_data_ch4_cams$mean_BVA <- (wide_data_ch4_cams$BVA_1 + wide_data_ch4_cams$BVA_2) /
  2
wide_data_ch4_cams$mean_TMD <- (wide_data_ch4_cams$TMD_1 + wide_data_ch4_cams$TMD_2) /
  2
wide_data_ch4_cams$mean_WNJ <- (wide_data_ch4_cams$WNJ_1 + wide_data_ch4_cams$WNJ_2) /
  2

final_cams_ch4 <- wide_data_ch4_cams[, c(1, 2, 9, 10, 11)]

#make automated - comment 8/24/25
final_cams_ch4$enh_via_BVA <- final_cams_ch4$Ship - final_cams_ch4$mean_BVA
final_cams_ch4$enh_via_TMD <- final_cams_ch4$Ship - final_cams_ch4$mean_TMD
final_cams_ch4$enh_via_WNJ <- final_cams_ch4$Ship - final_cams_ch4$mean_WNJ

library(reshape2)
final_cams_long_ch4 <- melt(
  final_cams_ch4,
  id.vars = "date",
  measure.vars = c("enh_via_BVA", "enh_via_TMD", "enh_via_WNJ"),
  variable.name = "Tower",
  value.name = "CH4"
)

final_cams_long_ch4$Tower <- gsub("enh_via_", "", final_cams_long_ch4$Tower)

#this is just for CAMS as its 6 hour resolution
final_cams_ch4 <- na.omit(final_cams_ch4)
final_cams_long_ch4 <- na.omit(final_cams_long_ch4)
tower_df_ch4_cams <- na.omit(tower_df_ch4_cams)

View(final_cams_co2)
View(final_cams_ch4)

##### Plotting tower CAMS against ship CAMS #####
#CO2 obs plot comparison
ggplot() +
  geom_ribbon(
    data = ship_df_co2_cams,
    aes(x = date, ymin = 415, ymax = CO2),
    fill = "darkgrey",
    alpha = 0.5
  ) +
  geom_line(data = ship_df_co2_cams,
            aes(x = date, y = CO2, color = Source),
            linewidth = 1) +
  geom_point(data = ship_df_co2_cams,
             aes(x = date, y = CO2, color = Source),
             size = 2) +
  geom_line(data = tower_df_co2_cams,
            aes(x = date, y = CO2, color = Source),
            linewidth = 1) +
  geom_point(data = tower_df_co2_cams,
             aes(x = date, y = CO2, color = Source),
             size = 2) +
  scale_color_manual(values = c(
    "Ship" = "black",
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: CAMS comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 obs plot comparison
ggplot() +
  geom_ribbon(
    data = ship_df_ch4_cams,
    aes(x = date, ymin = 1975, ymax = CH4),
    fill = "darkgrey",
    alpha = 0.5
  ) +
  geom_line(data = ship_df_ch4_cams,
            aes(x = date, y = CH4, color = Source),
            linewidth = 1) +
  geom_point(data = ship_df_ch4_cams,
             aes(x = date, y = CH4, color = Source),
             size = 2) +
  geom_line(data = tower_df_ch4_cams,
            aes(x = date, y = CH4, color = Source),
            linewidth = 1) +
  geom_point(data = tower_df_ch4_cams,
             aes(x = date, y = CH4, color = Source),
             size = 2) +
  scale_color_manual(values = c(
    "Ship" = "black",
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: CAMS comparison for", cruise),
    x = "Date UTC",
    y = "CH4 (ppb)"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CO2 enhancement comparison
library(ggplot2)
ggplot(final_cams_long_co2, aes(x = date, y = CO2, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: CAMS enhancement comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 enhancement comparison
library(ggplot2)
ggplot(final_cams_long_ch4, aes(x = date, y = CH4, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "BVA" = "purple",
    "TMD" = "blue",
    "WNJ" = "red"
  )) +
  labs(
    title = paste("Ship v Tower: CAMS enhancement comparison for", cruise),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )


#####___________________8. Cross-model comparisons________________________ #####
##### Combining enhancement data sets for comparison #####
keep <- c(
  "final_cams_ch4",
  "final_cams_co2",
  "final_ct_ch4",
  "final_ct_co2",
  "final_obs_ch4",
  "final_obs_co2",
  "cruise",
  "joined",
  "towers",
  "interval_labels"
)
rm(list = setdiff(ls(), keep))

#want to make this part automated - 8/25/25
names(final_cams_ch4) <- c(
  "date",
  "ship_ch4_cams",
  "cams_mean_ch4_BVA",
  "cams_mean_ch4_TMD",
  "cams_mean_ch4_WNJ",
  "cams_ch4_enh_via_BVA",
  "cams_ch4_enh_via_TMD",
  "cams_ch4_enh_via_WNJ"
)


names(final_cams_co2) <- c(
  "date",
  "ship_co2_cams",
  "cams_mean_co2_BVA",
  "cams_mean_co2_TMD",
  "cams_mean_co2_WNJ",
  "cams_co2_enh_via_BVA",
  "cams_co2_enh_via_TMD",
  "cams_co2_enh_via_WNJ"
)

names(final_ct_ch4) <- c(
  "date",
  "ship_ch4_ct",
  "ct_mean_ch4_BVA",
  "ct_mean_ch4_TMD",
  "ct_mean_ch4_WNJ",
  "ct_ch4_enh_via_BVA",
  "ct_ch4_enh_via_TMD",
  "ct_ch4_enh_via_WNJ"
)

names(final_ct_co2) <- c(
  "date",
  "ship_co2_ct",
  "ct_mean_co2_BVA",
  "ct_mean_co2_TMD",
  "ct_mean_co2_WNJ",
  "ct_co2_enh_via_BVA",
  "ct_co2_enh_via_TMD",
  "ct_co2_enh_via_WNJ"
)

names(final_obs_ch4) <- c(
  "date",
  "ship_ch4_obs",
  "obs_mean_ch4_BVA",
  "obs_mean_ch4_TMD",
  "obs_mean_ch4_WNJ",
  "obs_ch4_enh_via_BVA",
  "obs_ch4_enh_via_TMD",
  "obs_ch4_enh_via_WNJ"
)

names(final_obs_co2) <- c(
  "date",
  "ship_co2_obs",
  "obs_mean_co2_BVA",
  "obs_mean_co2_TMD",
  "obs_mean_co2_WNJ",
  "obs_co2_enh_via_BVA",
  "obs_co2_enh_via_TMD",
  "obs_co2_enh_via_WNJ"
)



merge_obs <- merge(final_obs_co2, final_obs_ch4, by = "date", all = T)
merge_ct <- merge(final_ct_co2, final_ct_ch4, by = "date", all = T)
merge_cams <- merge(final_cams_co2, final_cams_ch4, by = "date", all = T)

merged_obs_ct <- merge(merge_obs, merge_ct, by = "date", all = T)
merged_all <- merge(merged_obs_ct, merge_cams, by = "date", all = T)

View(merged_all)

##Grouping by time, then plotting
library(lubridate)
merged_all$hour_only <- hour(merged_all$date)

View(interval_labels)
breaks <- c(0, 3, 6, 9, 12, 15, 18, 21, 24)
labels <- interval_labels$Times_UTC

merged_all$Times_UTC <- cut(
  merged_all$hour_only,
  breaks = breaks,
  labels = labels,
  include.lowest = TRUE,
  right = FALSE
)

merged_all$Grouping <- as.integer(merged_all$Times_UTC)

##maybe split into towers as well:

enh_cols_ch4 <- c(
  "cams_ch4_enh_via_BVA",
  "cams_ch4_enh_via_TMD",
  "cams_ch4_enh_via_WNJ",
  "ct_ch4_enh_via_BVA",
  "ct_ch4_enh_via_TMD",
  "ct_ch4_enh_via_WNJ",
  "obs_ch4_enh_via_BVA",
  "obs_ch4_enh_via_TMD",
  "obs_ch4_enh_via_WNJ"
)


long_data_ch4 <- melt(
  merged_all,
  id.vars = c("date", "Grouping", "Times_UTC"),
  measure.vars = enh_cols_ch4,
  variable.name = "Enhancement_Type",
  value.name   = "Enhancement"
)

library(tidyr)
long_data_ch4 <- separate(
  long_data_ch4,
  col = Enhancement_Type,
  into = c("Source", "Gas", "tmp1", "tmp2", "Tower"),
  sep = "_",
  remove = FALSE
)

long_data_ch4 <- long_data_ch4[, c("date",
                                   "Grouping",
                                   "Times_UTC",
                                   "Source",
                                   "Gas",
                                   "Tower",
                                   "Enhancement")]

ggplot(long_data_ch4, aes(x = Grouping, y = Enhancement, color = Source)) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.7) +
  geom_boxplot(aes(group = interaction(Grouping, Source)),
               outlier.shape = NA,
               alpha = 0.3) +
  scale_x_continuous(breaks = 1:8, labels = interval_labels$Times_UTC) +
  facet_wrap( ~ Tower, nrow = 1) +
  labs(
    x = "UTC Interval",
    y = "CH4 Enhancement (ppb)",
    color = "Source",
    title = paste("Enhancement Comparison CH4 for", cruise)
  ) +
  scale_color_manual(values = c(
    "cams" = "red",
    "ct"   = "blue",
    "obs"  = "black"
  )) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1,
      size = 14
    ),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )



enh_cols_co2 <- c(
  "cams_co2_enh_via_BVA",
  "cams_co2_enh_via_TMD",
  "cams_co2_enh_via_WNJ",
  "ct_co2_enh_via_BVA",
  "ct_co2_enh_via_TMD",
  "ct_co2_enh_via_WNJ",
  "obs_co2_enh_via_BVA",
  "obs_co2_enh_via_TMD",
  "obs_co2_enh_via_WNJ"
)



long_data_co2 <- melt(
  merged_all,
  id.vars = c("date", "Grouping", "Times_UTC"),
  measure.vars = enh_cols_co2,
  variable.name = "Enhancement_Type",
  value.name   = "Enhancement"
)

library(tidyr)
long_data_co2 <- separate(
  long_data_co2,
  col = Enhancement_Type,
  into = c("Source", "Gas", "tmp1", "tmp2", "Tower"),
  sep = "_",
  remove = FALSE
)

long_data_co2 <- long_data_co2[, c("date",
                                   "Grouping",
                                   "Times_UTC",
                                   "Source",
                                   "Gas",
                                   "Tower",
                                   "Enhancement")]

ggplot(long_data_co2, aes(x = Grouping, y = Enhancement, color = Source)) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.7) +
  geom_boxplot(aes(group = interaction(Grouping, Source)),
               outlier.shape = NA,
               alpha = 0.3) +
  scale_x_continuous(breaks = 1:8, labels = interval_labels$Times_UTC) +
  facet_wrap( ~ Tower, nrow = 1) +
  labs(
    x = "UTC Interval",
    y = "CH4 Enhancement (ppb)",
    color = "Source",
    title = paste("Enhancement Comparison CO2 for", cruise)
  ) +
  scale_color_manual(values = c(
    "cams" = "red",
    "ct"   = "blue",
    "obs"  = "black"
  )) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1,
      size = 14
    ),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )
