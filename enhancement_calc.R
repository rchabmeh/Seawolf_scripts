#Run towers.R first to generate tower .csv files if not already
#Updated last on September 2, 2025

#You will have to manually change items in:
# 2.0 (background_towers)
# 3.0 (start_date, end_date)
# 5.1 (final_obs_co2 <- wide_data_co2_obs[, c(NUMBERS HERE)]) <- would like to automate

#NOTE: BVA and TMD are in the same grid cell which is why on CT and CAMS plots it doesn't show BVA
#NOTE: File path is /Volumes/Seagate/... you will have to change them manually as well

##losing background_towers by section 8 ?? looking into now 8/28/25

#New goals via 1:1 meeting w/ Shep:
# 1. Choose carefully which towers represent background
# 2. Use WNJ not as a background but as a comparison to ship data
# 3. Add scatter plots to compare modeled v enhancement

cruise = "Cruise 14"
cruise_squish <- tolower(gsub(" ", "", cruise))
#####_____________________________________________________________________ #####
#####_____________________________________________________________________ #####
##### 1. Loading in completed tower .csv files ####

setwd(paste0("/Volumes/Seagate/", cruise_squish, "_eulerian/towers"))

temp = list.files(pattern = "\\.csv$")

myfiles = lapply(temp, read.csv)

base_names <- tools::file_path_sans_ext(basename(temp))

clean_names <- sub(paste0("merged_(co2|ch4)_", cruise_squish, "_(.*)"),
                   "\\2_\\1",
                   base_names)

myfiles <- setNames(lapply(temp, read.csv), clean_names)
list2env(myfiles, envir = .GlobalEnv)

##### 2. LOOK @ TRAJECTORY MAP TO SEE WHICH TOWERS ARE YOUR BACKGROUND #####
background_towers <- c("TMD", "WNJ","BVA") #"LEW", "BVA", "TMD", "WNJ"

rm(list = ls()[!grepl(paste0("^(", paste(
  c(
    background_towers,
    "background_towers",
    "cruise",
    "cruise_squish"
  ),
  collapse = "|"
), ")"), ls())])

tower_data <- mget(setdiff(ls(), c(
  "background_towers", "cruise", "cruise_squish"
)))

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
start_date <- as.Date("2022-10-18")
end_date <- as.Date("2022-10-19")

#####_______________ 4. Setting cruise to 3 hour average _________________ #####
#### Loading in cruise and averaging to 3 hours ####
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

cruise_info_3hr$CH4_dry_cal_moving_day = cruise_info_3hr$CH4_dry_cal_moving_day *
  1000

library(hms)
cruise_info_3hr$time_only <- as_hms(cruise_info_3hr$date)

cruise_info_3hr <- cruise_info_3hr[cruise_info_3hr$date >= as.POSIXct(start_date) &
                                     cruise_info_3hr$date <= as.POSIXct(end_date) + 86400 - 1, ]



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

library(dplyr)
joined <- joined %>% dplyr::select(-window_start_co2, -window_start_ch4, -time_only, -Day)

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

#####___________________5. Observation comparisons _______________________ #####
##### Creating combined ship and tower observation data frames #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_co2_obs <- joined %>%
  dplyr::select(date, Observed_CO2) %>%
  mutate(Source = "Ship", CO2 = Observed_CO2) %>%
  dplyr::select(date, CO2, Source)


tower_df_co2_obs <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"Obs_CO2_ppm" %in% names(df))
    return(NULL)
  tower_code <- gsub("_co2$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CO2 = Obs_CO2_ppm) %>%
    dplyr::select(DATE, CO2, Source) %>%
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

combined <- bind_rows(ship_unique,
                      tower_numbered %>% dplyr::select(date, CO2, Source_id))

wide_data_co2_obs <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CO2) %>%
  arrange(date)

for (twr in background_towers) {
  col1 <- paste0(twr, "_1")
  col2 <- paste0(twr, "_2")
  newcol <- paste0(twr, "_mean")
  
  wide_data_co2_obs[[newcol]] <- rowMeans(wide_data_co2_obs[, c(col1, col2)], na.rm = TRUE)
}

#this needs to be dynamic - 8/28/25
final_obs_co2 <- wide_data_co2_obs[, c(1, 2, 9, 10,11)]

for (twr in background_towers) {
  mean_col <- paste0(twr, "_mean")
  newcol   <- paste0("enh_via_", twr)
  
  final_obs_co2[[newcol]] <- final_obs_co2$Ship - final_obs_co2[[mean_col]]
}

enh_cols <- grep("^enh_via_", names(final_obs_co2), value = TRUE)

final_obs_long_co2 <- melt(
  final_obs_co2,
  id.vars = "date",
  measure.vars = enh_cols,
  variable.name = "Tower",
  value.name = "CO2"
)
final_obs_long_co2$Tower <- sub("^enh_via_", "", final_obs_long_co2$Tower)

#CH4
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_ch4_obs <- joined %>%
  dplyr::select(date, Observed_CH4) %>%
  mutate(Source = "Ship", CH4 = Observed_CH4) %>%
  dplyr::select(date, CH4, Source)


tower_df_ch4_obs <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"Obs_CH4_ppb" %in% names(df))
    return(NULL)
  tower_code <- gsub("_ch4$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CH4 = Obs_CH4_ppb) %>%
    dplyr::select(DATE, CH4, Source) %>%
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

combined <- bind_rows(ship_unique,
                      tower_numbered %>% dplyr::select(date, CH4, Source_id))

wide_data_ch4_obs <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CH4) %>%
  arrange(date)

for (twr in background_towers) {
  col1 <- paste0(twr, "_1")
  col2 <- paste0(twr, "_2")
  newcol <- paste0(twr, "_mean")
  
  wide_data_ch4_obs[[newcol]] <- rowMeans(wide_data_ch4_obs[, c(col1, col2)], na.rm = TRUE)
}

final_obs_ch4 <- wide_data_ch4_obs[, c(1, 2, 9,10,11)]

for (twr in background_towers) {
  mean_col <- paste0(twr, "_mean")
  newcol   <- paste0("enh_via_", twr)
  
  final_obs_ch4[[newcol]] <- final_obs_ch4$Ship - final_obs_ch4[[mean_col]]
}

enh_cols <- grep("^enh_via_", names(final_obs_ch4), value = TRUE)

final_obs_long_ch4 <- melt(
  final_obs_ch4,
  id.vars = "date",
  measure.vars = enh_cols,
  variable.name = "Tower",
  value.name = "CH4"
)
final_obs_long_ch4$Tower <- sub("^enh_via_", "", final_obs_long_ch4$Tower)


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
  "interval_labels",
  "background_towers"
)
rm(list = setdiff(ls(), keep))

View(final_obs_co2)
View(final_obs_ch4)

##### Plotting tower observation against ship observation #####
#CO2 obs plot comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

ship_daylight_co2 <- subset(ship_df_co2_obs,
                            format(date, "%H") >= "14" &
                              format(date, "%H") <= "22")

tower_daylight_co2 <- subset(tower_df_co2_obs,
                             format(date, "%H") >= "14" &
                               format(date, "%H") <= "22")
tower_daylight_avg_co2 <- aggregate(CO2 ~ date + Source, data = tower_daylight_co2, FUN = mean)


library(ggplot2)
library(scales)

ggplot() +
  geom_segment(
    data = tower_daylight_avg_co2,
    aes(
      x = date,
      xend = date,
      y = 415,
      yend = CO2,
      color = Source
    ),
    linewidth = 1,
    alpha = 0.6
  ) +
  geom_point(data = ship_daylight_co2,
             aes(x = date, y = CO2, color = Source),
             size = 3) +
  geom_point(
    data = tower_daylight_avg_co2,
    aes(x = date, y = CO2, color = Source),
    size = 3,
    shape = 17
  ) +
  scale_color_manual(values = all_colors) +
  scale_x_datetime(
    date_labels = "%b %d",
    # show only month and day
    date_breaks = "1 day",
    # one tick per day
    expand = expansion(add = c(1.5 * 60 * 60, 1.5 * 60 * 60))
  ) +
  labs(
    title = paste("Ship vs Tower CO2 Observations (Daylight, 10AM–6PM EDT)"),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text = element_text(size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CH4 obs plot comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

ship_daylight_ch4 <- subset(ship_df_ch4_obs,
                            format(date, "%H") >= "14" &
                              format(date, "%H") <= "22")

tower_daylight_ch4 <- subset(tower_df_ch4_obs,
                             format(date, "%H") >= "14" &
                               format(date, "%H") <= "22")
tower_daylight_avg_ch4 <- aggregate(CH4 ~ date + Source, data = tower_daylight_ch4, FUN = mean)


library(ggplot2)
library(scales)

ggplot() +
  geom_segment(
    data = tower_daylight_avg_ch4,
    aes(
      x = date,
      xend = date,
      y = 1950,
      yend = CH4,
      color = Source
    ),
    linewidth = 1,
    alpha = 0.6
  ) +
  geom_point(data = ship_daylight_ch4,
             aes(x = date, y = CH4, color = Source),
             size = 3) +
  geom_point(
    data = tower_daylight_avg_ch4,
    aes(x = date, y = CH4, color = Source),
    size = 3,
    shape = 17
  ) +
  scale_color_manual(values = all_colors) +
  scale_x_datetime(
    date_labels = "%b %d",
    # show only month and day
    date_breaks = "1 day",
    # one tick per day
    expand = expansion(add = c(1.5 * 60 * 60, 1.5 * 60 * 60))
  ) +
  labs(
    title = paste("Ship vs Tower CH4 Observations (Daylight, 10AM–6PM EDT)"),
    x = "Date UTC",
    y = "CH4 (ppb)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text = element_text(size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#CO2 enhancement comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

ship_daylight_co2 <- subset(
  final_obs_long_co2,
  Tower == "Ship" &
    format(date, "%H") >= "14" & format(date, "%H") <= "22"
)
tower_daylight_co2 <- subset(
  final_obs_long_co2,
  Tower != "Ship" &
    format(date, "%H") >= "14" & format(date, "%H") <= "22"
)
tower_daylight_avg_co2 <- aggregate(CO2 ~ date + Tower, data = tower_daylight_co2, FUN = mean)

library(ggplot2)

ggplot() +
  geom_segment(
    data = tower_daylight_avg_co2,
    aes(
      x = date,
      xend = date,
      y = 0,
      yend = CO2,
      color = Tower
    ),
    linewidth = 1,
    alpha = 0.6
  ) +
  geom_point(data = ship_daylight_co2,
             aes(x = date, y = CO2, color = Tower),
             size = 3) +
  geom_point(
    data = tower_daylight_avg_co2,
    aes(x = date, y = CO2, color = Tower),
    size = 3,
    shape = 17
  ) +
  scale_color_manual(values = all_colors) +
  scale_x_datetime(
    date_labels = "%b %d",
    date_breaks = "1 day",
    expand = expansion(add = c(1.5 * 60 * 60, 1.5 * 60 * 60))
  ) +
  labs(
    title = paste("Ship vs Tower CO2 Observational Enhancements (Daylight, 10AM–6PM EDT)"),
    x = "Date UTC",
    y = "CO2 (ppm)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text = element_text(size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )


#CH4 enhancement comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)
ship_daylight_ch4 <- subset(
  final_obs_long_ch4,
  Tower == "Ship" &
    format(date, "%H") >= "14" & format(date, "%H") <= "22"
)
tower_daylight_ch4 <- subset(
  final_obs_long_ch4,
  Tower != "Ship" &
    format(date, "%H") >= "14" & format(date, "%H") <= "22"
)
tower_daylight_avg_ch4 <- aggregate(CH4 ~ date + Tower, data = tower_daylight_ch4, FUN = mean)

library(ggplot2)

ggplot() +
  geom_segment(
    data = tower_daylight_avg_ch4,
    aes(
      x = date,
      xend = date,
      y = 0,
      yend = CH4,
      color = Tower
    ),
    linewidth = 1,
    alpha = 0.6
  ) +
  geom_point(
    data = ship_daylight_ch4,
    aes(x = date, y = CH4, color = Tower),
    size = 3
  ) +
  geom_point(
    data = tower_daylight_avg_ch4,
    aes(x = date, y = CH4, color = Tower),
    size = 3,
    shape = 17
  ) +
  scale_color_manual(values = all_colors) +
  scale_x_datetime(
    date_labels = "%b %d",
    date_breaks = "1 day",
    expand = expansion(add = c(1.5 * 60 * 60, 1.5 * 60 * 60))
  ) +
  labs(
    title = paste("Ship vs Tower CH4 Observational Enhancements (Daylight, 10AM–6PM EDT)"),
    x = "Date UTC",
    y = "CH4 (ppb)"
  ) +
  geom_hline(yintercept = 0) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text = element_text(size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, hjust = 0.5)
  )

#####___________________6. CT comparisons _________________________________#####
##### Creating combined ship and tower carbon tracker data frames #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_co2_ct <- joined %>%
  dplyr::select(date, CT_CO2) %>%
  mutate(Source = "Ship", CO2 = CT_CO2) %>%
  dplyr::select(date, CO2, Source)


tower_df_co2_ct <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CT_CO2" %in% names(df))
    return(NULL)
  tower_code <- gsub("_co2$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CO2 = CT_CO2) %>%
    dplyr::select(DATE, CO2, Source) %>%
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

combined <- bind_rows(ship_unique,
                      tower_numbered %>% dplyr::select(date, CO2, Source_id))

wide_data_co2_ct <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CO2) %>%
  arrange(date)

for (twr in background_towers) {
  col1 <- paste0(twr, "_1")
  col2 <- paste0(twr, "_2")
  newcol <- paste0(twr, "_mean")
  
  wide_data_co2_ct[[newcol]] <- rowMeans(wide_data_co2_ct[, c(col1, col2)], na.rm = TRUE)
}

final_ct_co2 <- wide_data_co2_ct[, c(1, 2, 9,10,11)]

for (twr in background_towers) {
  mean_col <- paste0(twr, "_mean")
  newcol   <- paste0("enh_via_", twr)
  
  final_ct_co2[[newcol]] <- final_ct_co2$Ship - final_ct_co2[[mean_col]]
}

enh_cols <- grep("^enh_via_", names(final_ct_co2), value = TRUE)

final_ct_long_co2 <- melt(
  final_ct_co2,
  id.vars = "date",
  measure.vars = enh_cols,
  variable.name = "Tower",
  value.name = "CO2"
)
final_ct_long_co2$Tower <- sub("^enh_via_", "", final_ct_long_co2$Tower)


#CH4
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_ch4_ct <- joined %>%
  dplyr::select(date, CT_CH4) %>%
  mutate(Source = "Ship", CH4 = CT_CH4) %>%
  dplyr::select(date, CH4, Source)


tower_df_ch4_ct <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CT_CH4" %in% names(df))
    return(NULL)
  tower_code <- gsub("_ch4$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CH4 = CT_CH4) %>%
    dplyr::select(DATE, CH4, Source) %>%
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

combined <- bind_rows(ship_unique,
                      tower_numbered %>% dplyr::select(date, CH4, Source_id))

wide_data_ch4_ct <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CH4) %>%
  arrange(date)

for (twr in background_towers) {
  col1 <- paste0(twr, "_1")
  col2 <- paste0(twr, "_2")
  newcol <- paste0(twr, "_mean")
  
  wide_data_ch4_ct[[newcol]] <- rowMeans(wide_data_ch4_ct[, c(col1, col2)], na.rm = TRUE)
}

final_ct_ch4 <- wide_data_ch4_ct[, c(1, 2, 9, 10,11)]

for (twr in background_towers) {
  mean_col <- paste0(twr, "_mean")
  newcol   <- paste0("enh_via_", twr)
  
  final_ct_ch4[[newcol]] <- final_ct_ch4$Ship - final_ct_ch4[[mean_col]]
}

enh_cols <- grep("^enh_via_", names(final_ct_ch4), value = TRUE)

final_ct_long_ch4 <- melt(
  final_ct_ch4,
  id.vars = "date",
  measure.vars = enh_cols,
  variable.name = "Tower",
  value.name = "CH4"
)
final_ct_long_ch4$Tower <- sub("^enh_via_", "", final_ct_long_ch4$Tower)

View(final_ct_co2)
View(final_ct_ch4)

##### Plotting tower carbon tracker against ship carbon tracker #####

#CO2 ct plot comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

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
  scale_color_manual(values = all_colors) +
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

#CH4 ct plot comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

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
  scale_color_manual(values = all_colors) +
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
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

library(ggplot2)
ggplot(final_ct_long_co2, aes(x = date, y = CO2, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = all_colors) +
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
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

library(ggplot2)
ggplot(final_ct_long_ch4, aes(x = date, y = CH4, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = all_colors) +
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

#####___________________7. CAMS comparisons ______________________________ #####
##### Creating combined ship and tower CAMS data frames #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC

ship_df_co2_cams <- joined %>%
  dplyr::select(date, CAMS_CO2) %>%
  mutate(Source = "Ship", CO2 = CAMS_CO2) %>%
  dplyr::select(date, CO2, Source)


tower_df_co2_cams <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CAMs_CO2" %in% names(df))
    return(NULL)
  tower_code <- gsub("_co2$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CO2 = CAMs_CO2) %>%
    dplyr::select(DATE, CO2, Source) %>%
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

combined <- bind_rows(ship_unique,
                      tower_numbered %>% dplyr::select(date, CO2, Source_id))

wide_data_co2_cams <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CO2) %>%
  arrange(date)

for (twr in background_towers) {
  col1 <- paste0(twr, "_1")
  col2 <- paste0(twr, "_2")
  newcol <- paste0(twr, "_mean")
  
  wide_data_co2_cams[[newcol]] <- rowMeans(wide_data_co2_cams[, c(col1, col2)], na.rm = TRUE)
}

final_cams_co2 <- wide_data_co2_cams[, c(1, 2, 9, 10,11)]

for (twr in background_towers) {
  mean_col <- paste0(twr, "_mean")
  newcol   <- paste0("enh_via_", twr)
  
  final_cams_co2[[newcol]] <- final_cams_co2$Ship - final_cams_co2[[mean_col]]
}

enh_cols <- grep("^enh_via_", names(final_cams_co2), value = TRUE)

final_cams_long_co2 <- melt(
  final_cams_co2,
  id.vars = "date",
  measure.vars = enh_cols,
  variable.name = "Tower",
  value.name = "CO2"
)
final_cams_long_co2$Tower <- sub("^enh_via_", "", final_cams_long_co2$Tower)


#CH4
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

joined$date <- joined$Date_UTC
joined$CAMS_CH4 <- joined$CAMS_CH4 * 1000
ship_df_ch4_cams <- joined %>%
  dplyr::select(date, CAMS_CH4) %>%
  mutate(Source = "Ship", CH4 = CAMS_CH4) %>%
  dplyr::select(date, CH4, Source)


tower_df_ch4_cams <- map_df(names(tower_data), function(tower_name) {
  df <- tower_data[[tower_name]]
  if (!is.data.frame(df))
    return(NULL)
  if (!"CAMs_CH4" %in% names(df))
    return(NULL)
  tower_code <- gsub("_ch4$", "", tower_name)
  
  df %>%
    mutate(Source = tower_code, CH4 = CAMs_CH4) %>%
    dplyr::select(DATE, CH4, Source) %>%
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

combined <- bind_rows(ship_unique,
                      tower_numbered %>% dplyr::select(date, CH4, Source_id))

wide_data_ch4_cams <- combined %>%
  pivot_wider(names_from = Source_id, values_from = CH4) %>%
  arrange(date)

for (twr in background_towers) {
  col1 <- paste0(twr, "_1")
  col2 <- paste0(twr, "_2")
  newcol <- paste0(twr, "_mean")
  
  wide_data_ch4_cams[[newcol]] <- rowMeans(wide_data_ch4_cams[, c(col1, col2)], na.rm = TRUE)
}

final_cams_ch4 <- wide_data_ch4_cams[, c(1, 2, 9, 10,11)]

for (twr in background_towers) {
  mean_col <- paste0(twr, "_mean")
  newcol   <- paste0("enh_via_", twr)
  
  final_cams_ch4[[newcol]] <- final_cams_ch4$Ship - final_cams_ch4[[mean_col]]
}

enh_cols <- grep("^enh_via_", names(final_cams_ch4), value = TRUE)

final_cams_long_ch4 <- melt(
  final_cams_ch4,
  id.vars = "date",
  measure.vars = enh_cols,
  variable.name = "Tower",
  value.name = "CH4"
)
final_cams_long_ch4$Tower <- sub("^enh_via_", "", final_cams_long_ch4$Tower)

#this is just for CAMS as its 6 hour resolution
final_cams_ch4 <- na.omit(final_cams_ch4)
final_cams_long_ch4 <- na.omit(final_cams_long_ch4)
tower_df_ch4_cams <- na.omit(tower_df_ch4_cams)

View(final_cams_co2)
View(final_cams_ch4)

##### Plotting tower CAMS against ship CAMS #####

#CO2 cams plot comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

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
  scale_color_manual(values = all_colors) +
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

#CH4 cams plot comparison
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

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
  scale_color_manual(values = all_colors) +
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
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

library(ggplot2)
ggplot(final_cams_long_co2, aes(x = date, y = CO2, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = all_colors) +
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
tower_colors <- rainbow(length(background_towers))
tower_colors <- setNames(tower_colors, background_towers)
all_colors <- c("Ship" = "black", tower_colors)

library(ggplot2)
ggplot(final_cams_long_ch4, aes(x = date, y = CH4, color = Tower)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = all_colors) +
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
  "interval_labels",
  "background_towers", 
  "cruise_squish"
)
rm(list = setdiff(ls(), keep))

#cams
final_cams_ch4_names <- c(
  "date",
  "ship_ch4_cams",
  paste0("cams_mean_ch4_", background_towers),
  paste0("cams_ch4_enh_via_", background_towers)
)
names(final_cams_ch4) <- final_cams_ch4_names


final_cams_co2_names <- c(
  "date",
  "ship_co2_cams",
  paste0("cams_mean_co2_", background_towers),
  paste0("cams_co2_enh_via_", background_towers)
)
names(final_cams_co2) <- final_cams_co2_names

#ct
final_ct_ch4_names <- c(
  "date",
  "ship_ch4_ct",
  paste0("ct_mean_ch4_", background_towers),
  paste0("ct_ch4_enh_via_", background_towers)
)
names(final_ct_ch4) <- final_ct_ch4_names


final_ct_co2_names <- c(
  "date",
  "ship_co2_ct",
  paste0("ct_mean_co2_", background_towers),
  paste0("ct_co2_enh_via_", background_towers)
)
names(final_ct_co2) <- final_ct_co2_names

#obs
final_obs_ch4_names <- c(
  "date",
  "ship_ch4_cams",
  paste0("obs_mean_ch4_", background_towers),
  paste0("obs_ch4_enh_via_", background_towers)
)
names(final_obs_ch4) <- final_obs_ch4_names


final_obs_co2_names <- c(
  "date",
  "ship_co2_obs",
  paste0("obs_mean_co2_", background_towers),
  paste0("obs_co2_enh_via_", background_towers)
)
names(final_obs_co2) <- final_obs_co2_names

#combining all
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

sources <- c("cams", "ct", "obs")
enh_cols_ch4 <- as.vector(sapply(sources, function(src) {
  paste0(src, "_ch4_enh_via_", background_towers)
}))



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
    "CAMS" = "red",
    "CT"   = "blue",
    "Obs"  = "black"
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



sources <- c("cams", "ct", "obs")
enh_cols_co2 <- as.vector(sapply(sources, function(src) {
  paste0(src, "_co2_enh_via_", background_towers)
}))


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
    y = "CO2 Enhancement (ppm)",
    color = "Source",
    title = paste("Enhancement Comparison CO2 for", cruise)
  ) +
  scale_color_manual(values = c(
    "CAMS" = "red",
    "CT"   = "blue",
    "Obs"  = "black"
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

#####_________________________9. Saving .csv files _______________________ #####
##### Saving all .csv files #####
cruise_squish <- tolower(gsub(" ", "", cruise))

write.csv(
  merged_all,
  paste0(
    "/Volumes/Seagate/",
    cruise_squish,
    "_eulerian/all_models_merged_",
    cruise_squish,
    ".csv"
  )
)

#####_____________________________________________________________________ #####
#####_____________________________________________________________________ #####
