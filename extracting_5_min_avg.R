#Only run once large chunk at a time. After a run clear the environment.
#### Loading libraries-- always run first! ####
library(raster)
library(ncdf4)
library(sf)
library(dplyr)
library(reshape2)
library(openair)
library(hms)
library(lubridate)
library(ggplot2)
library(ggpubr)
library(tidyr)
#### ---ALL TIMES CRUISE/MODEL COMPARISON- 5 MINUTE AVG--- ####
cruise <- "Cruise 24"
#### Loading in cruise information ######
cruise_squish <- tolower(gsub(" ", "_", cruise))
cruise_info_load_in <- read.csv(
  paste0(
    "/Users/reneechabot-mehlin/Desktop/model_plotting/",
    cruise_squish,
    "/",
    cruise_squish,
    ".csv"
  ),
  sep = ",",
  dec = "."
)

cruise_info <-data.frame(Time_UTC = cruise_info_load_in$Time_UTC,
                             Time_local = cruise_info_load_in$Time_local,
                             Latitude_deg = cruise_info_load_in$Latitude_deg,
                             Longitude_deg = cruise_info_load_in$Longitude_deg,
                             CO2_dry_cal_moving_day = cruise_info_load_in$CO2,
                             CH4_dry_cal_moving_day = cruise_info_load_in$CH4)


cruise_info <- cruise_info[!is.na(cruise_info$Longitude_deg), ]


cruise_info <- cruise_info[!is.na(cruise_info$CO2_dry_cal_moving_day), ]


cruise_info$Time_local <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "America/New_York")
cruise_info$Time_UTC <- as.POSIXct(cruise_info$Time_local, origin = "1904-01-01", tz = "UTC")

colnames(cruise_info)[colnames(cruise_info) == "Time_UTC"] <- "date"
cruise_info$Day <- as.Date(cruise_info$date)
cruise_info_5min <- timeAverage(
  cruise_info,
  #avg.time = "3 hour",
 avg.time = "1 min",
  data.thresh = 0,
  statistic = "mean"
)
cruise_info_5min$time_only <- as_hms(cruise_info_5min$date)
#### Loading in basic CT files ######
CT_CO2 <- list()
files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_nrt_co2"
  ),
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "co2",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #33 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
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
files = list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_ch4_ct"
  ),
  pattern = '*.nc',
  full.names = TRUE
)
for (i in seq_along(files)) {
  nc <- brick(
    files[i],
    varname = "ch4",
    stopIfNotEqualSpaced = FALSE,
    level = 1 #34.5 m (LEW = 50 m; TMD = 49 m; WNJ = 43 m)
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


CT_CO2 <- list()
files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_nrt_co2"
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
#### Loading in CT-NRT CO2 1x1 NAMS ######
#CO2
library(hms)
cruise_info_5min$CT_CO2_tile <- NA_real_

start_time <- as_hms("00:00:00")
end_time   <- as_hms("03:00:00")

for (i in seq_along(CTCO2_1)) {
  cropped_raster <- CTCO2_1[[i]][[1]]
  name_string <- CTCO2_1[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c1_df <- cruise_info_5min[row_index, ]
      this_time <- c1_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c1_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c2_df <- cruise_info_5min[row_index, ]
      this_time <- c2_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c2_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c3_df <- cruise_info_5min[row_index, ]
      this_time <- c3_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c3_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c4_df <- cruise_info_5min[row_index, ]
      this_time <- c4_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c4_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c5_df <- cruise_info_5min[row_index, ]
      this_time <- c5_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c5_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c6_df <- cruise_info_5min[row_index, ]
      this_time <- c6_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c6_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c7_df <- cruise_info_5min[row_index, ]
      this_time <- c7_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c7_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      c8_df <- cruise_info_5min[row_index, ]
      this_time <- c8_df$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- as.numeric(c8_df[1, c("Longitude_deg", "Latitude_deg")])
        coords <- matrix(coords, ncol = 2)
        CT_CO2_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(CT_CO2_tile)) {
          cruise_info_5min$CT_CO2_tile[row_index] <- as.numeric(CT_CO2_tile)
        }
      }
    }
  }
}

#### Loading in CT CH4 3x2 GLOBAL ######
#CH4
cruise_info_5min$CT_CH4_tile <- NA_real_

start_time <- as_hms("00:00:00")
end_time   <- as_hms("03:00:00")

for (i in seq_along(CTCH4_1)) {
  cropped_raster <- CTCH4_1[[i]][[1]]
  name_string <- CTCH4_1[[i]]@data@names[[1]]
  date_string <- gsub("X(\\d{4})\\.(\\d{2})\\.(\\d{2}).*",
                      "\\1-\\2-\\3",
                      name_string)
  target_date <- as.Date(date_string)
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
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
  match_indices <- which(cruise_info_5min$Day == target_date)
  
  if (length(match_indices) > 0) {
    for (j in seq_along(match_indices)) {
      row_index <- match_indices[j]
      df_row <- cruise_info_5min[row_index, ]
      this_time <- df_row$time_only
      if (!is.na(this_time) &&
          this_time >= start_time && this_time <= end_time) {
        coords <- matrix(as.numeric(df_row[1, c("Longitude_deg", "Latitude_deg")]), ncol = 2)
        ch4_tile <- raster::extract(cropped_raster, coords)
        if (!is.null(ch4_tile)) {
          cruise_info_5min$CT_CH4_tile[row_index] <- as.numeric(ch4_tile)
        }
      }
    }
  }
}

cruise_info_5min$CT_CH4_tile <- cruise_info_5min$CT_CH4_tile / 1000

#### Loading in Lat/Lon grid #####
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
#### Loading in CAMS 1x1 GLOBAL information ######
CAMS <- list(CH4 = list(), CO2 = list())
files <- list.files(
  paste0(
    '/Users/reneechabot-mehlin/Desktop/model_plotting/',
    cruise_squish,
    '/',
    cruise_squish,
    "_cams"
  ),
  pattern = '\\.nc$',
  full.names = TRUE
)

level_co2 <- 1   # 43.3 m
level_ch4 <- 1   # 378.3 m (lowest)

for (f in files) {
  
  cat("Processing:", basename(f), "\n")
  
  nc <- nc_open(f)
  var_names <- names(nc$var)
  
  if ("CH4" %in% var_names) {
    var_to_use <- "CH4"
    lvl <- level_ch4
    
  } else if ("CO2" %in% var_names) {
    var_to_use <- "CO2"
    lvl <- level_co2
    
  } else {
    nc_close(nc)
    next
  }
  
  nc_close(nc)
  
  CAMS[[var_to_use]][[length(CAMS[[var_to_use]]) + 1]] <- brick(
    f,
    varname = var_to_use,
    level = lvl
  )
}

get_timestamps <- function(nc_file) {
  
  nc <- nc_open(nc_file)
  on.exit(nc_close(nc), add = TRUE)
  
  if (!("time" %in% names(nc$dim))) {
    warning(paste("No time dimension in:", nc_file))
    return(NULL)
  }
  
  time_vals  <- ncvar_get(nc, "time")
  time_units <- ncatt_get(nc, "time", "units")$value
  
  origin <- sub("hours since ", "", time_units)
  
  as.POSIXct(
    time_vals * 3600,
    origin = origin,
    tz = "UTC"
  )
}

all_timestamps <- lapply(files, get_timestamps)
names(all_timestamps) <- basename(files)

cruise_info_5min$CAMS_CH4 <- NA_real_
cruise_info_5min$CAMS_CO2 <- NA_real_

# optional: save matched layer info
closest_times <- data.frame()
time_tolerance_secs <- 0

for (j in seq_len(nrow(cruise_info_5min))) {
  
  target_time <- cruise_info_5min$date[j]
  
  lon <- cruise_info_5min$Longitude_deg[j]
  lat <- cruise_info_5min$Latitude_deg[j]
  
  coords <- matrix(
    c(lon, lat),
    ncol = 2
  )
  
  cat("Row:", j, "of", nrow(cruise_info_5min), "\n")
  
  for (i in seq_along(files)) {
    
    timestamps <- all_timestamps[[i]]
    
    if (is.null(timestamps)) next
   
     file_start <- min(timestamps)
    file_end   <- max(timestamps)
    if (target_time < (file_start - time_tolerance_secs) |
        target_time > (file_end   + time_tolerance_secs)) next
    
    layer_number <- which.min(
      abs(difftime(
        timestamps,
        target_time,
        units = "secs"
      ))
    )
    
    matched_time <- timestamps[layer_number]
    
    file_type <- if (grepl("CO2", basename(files[i]), ignore.case = TRUE)) {
      "CO2"
    } else if (grepl("CH4", basename(files[i]), ignore.case = TRUE)) {
      "CH4"
    } else {
      next
    }
    
    brick_index <- sum(
      sapply(files[1:i], function(x)
        grepl(file_type, basename(x), ignore.case=TRUE))
    )
    
    r_layer <- CAMS[[file_type]][[brick_index]][[layer_number]]    
    model_value <- raster::extract(
      r_layer,
      coords
    )
    
    if (file_type == "CO2") {
      cruise_info_5min$CAMS_CO2[j] <- model_value * 1e6
    }
    
    if (file_type == "CH4") {
      cruise_info_5min$CAMS_CH4[j] <- model_value
    }
    
    closest_times <- rbind(
      closest_times,
      data.frame(
        cruise_row = j,
        file = basename(files[i]),
        variable = file_type,
        cruise_time = target_time,
        matched_time = matched_time,
        layer_num = layer_number
      )
    )
  }
}

cruise_info_5min$CAMS_CH4 <- cruise_info_5min$CAMS_CH4/1000

#### Setting for daylight hours #####
cruise_info_5min <- cruise_info_5min %>% filter(hour(Time_local) >= 10, hour(Time_local) <= 18)

#### Check against models #####
# plot(cruise_info_5min$Time_local, cruise_info_5min$CO2_dry_cal_moving_day, type = "b", pch = 20)
# lines(cruise_info_5min$Time_local, cruise_info_5min$CT_CO2_tile, type = "b", pch = 20, col = "red")
# lines(cruise_info_5min$Time_local, cruise_info_5min$CAMS_CO2, type = "b", pch = 20, col = "blue")
# 
# plot(cruise_info_5min$Time_local, cruise_info_5min$CH4_dry_cal_moving_day, type = "b", pch = 20)
# lines(cruise_info_5min$Time_local, cruise_info_5min$CT_CH4_tile, type = "b", pch = 20, col = "red")
# lines(cruise_info_5min$Time_local, cruise_info_5min$CAMS_CH4, type = "b", pch = 20, col = "blue")


write.csv(cruise_info_5min, "/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_1min_daylight.csv")








