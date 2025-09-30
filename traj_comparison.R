#Comparison of trajectories
##LOADING IN INFO + PROCESSING FOR PLOTTING #####
#Load in state outline and ship tracks___
library(ggplot2)
library(sf)
library(sp)
library(terra)
library(tmap)
states <- st_read("/Users/reneechabot-mehlin/Downloads/cb_2023_us_state_500k")
cruise_tracks <- read.delim(
"/Users/reneechabot-mehlin/Downloads/moving_data.txt"
  ,
  sep = ",",
  dec = "."
)
cruise_tracks <- cruise_tracks[!is.na(cruise_tracks$Longitude_deg), ]
cruise_tracks <- cruise_tracks[!is.na(cruise_tracks$CO2_dry_cal_moving_day), ]
#Load in NAMS trajectories___  
NAMS_directory <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/nams" ##change per cruise
setwd(NAMS_directory)
tdump_files = list.files(
  pattern = glob2rx("tdump?*"),
  recursive = T,
  full.names = T
)
sorted <- order(basename(tdump_files))
tdump_files <- (tdump_files[sorted])
NAMS_trajectory_list <- list()
i = 1
while (i <= length(tdump_files)) {
  Single_Example_file = suppressWarnings(read.table(tdump_files[i], header =
                                                      F, skip = 8))
  colnames(Single_Example_file) <- c(
    "Trajectory Number",
    "Pressure Number",
    "Year",
    "Month",
    "Day",
    "Current_Hour",
    "Not sure yet!",
    "Trajectory Time (Forward)",
    "Elapsed Time (Backwards)",
    "Latitude",
    "Longitude",
    "Height (m)",
    "Pressure (mbar)"
  )
  Single_Example_file_traj1 <- Single_Example_file[Single_Example_file$`Trajectory Number` ==
                                                     1, ]
  Single_Example_file_traj1$Starting.Date.Time <- as.POSIXct(with(
    Single_Example_file_traj1,
    paste(Year, Month, Day, (Current_Hour), sep = "-")
  ), tz = "UTC", "%y-%m-%d-%H")
  print("Timezone is UTC.")
  Single_Example_file_traj1$Starting.Date.Time <- format(Single_Example_file_traj1$Starting.Date.Time,
                                                         tz = "America/New_York",
                                                         usetz = TRUE)
  print("Timezone is America/New_York.")
  NAMS_trajectory_list <- append(NAMS_trajectory_list, list(Single_Example_file_traj1))
  i = i + 1
}
#Load in HRRR trajectories___
HRRR_directory <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/hrrr" ##change per cruise
setwd(HRRR_directory)
tdump_files = list.files(
  pattern = glob2rx("tdump?*"),
  recursive = T,
  full.names = T
)
sorted <- order(basename(tdump_files))
tdump_files <- (tdump_files[sorted])
HRRR_trajectory_list <- list()
i = 1
while (i <= length(tdump_files)) {
  Single_Example_file = suppressWarnings(read.table(tdump_files[i], header =
                                                      F, skip = 16))
  colnames(Single_Example_file) <- c(
    "Trajectory Number",
    "Pressure Number",
    "Year",
    "Month",
    "Day",
    "Current_Hour",
    "Not sure yet!",
    "Trajectory Time (Forward)",
    "Elapsed Time (Backwards)",
    "Latitude",
    "Longitude",
    "Height (m)",
    "Pressure (mbar)"
  )
  Single_Example_file_traj1 <- Single_Example_file[Single_Example_file$`Trajectory Number` ==
                                                     1, ]
  Single_Example_file_traj1$Starting.Date.Time <- as.POSIXct(with(
    Single_Example_file_traj1,
    paste(Year, Month, Day, (Current_Hour), sep = "-")
  ), tz = "UTC", "%y-%m-%d-%H")
  print("Timezone is UTC.")
  Single_Example_file_traj1$Starting.Date.Time <- format(Single_Example_file_traj1$Starting.Date.Time,
                                                         tz = "America/New_York",
                                                         usetz = TRUE)
  print("Timezone is America/New_York.")
  
  HRRR_trajectory_list <- append(HRRR_trajectory_list, list(Single_Example_file_traj1))
  i = i + 1
}
#CONSTANTS___
point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)
timespan <- sprintf("%02d:00", 10:16)
#TRAJECTORY LOCATION FILTER___
#NAMS__
NAMS_traj_filter <- Filter(function(df)
  df[1, "Latitude"] >= point_pleasant_nj[1] &
    df[1, "Latitude"] >= cape_may_nj[1] ,
  NAMS_trajectory_list)
NAMS_traj_filter <- Filter(function(df)
  df[1, "Longitude"] >= cape_may_nj[2] &
    df[1, "Longitude"] <= point_pleasant_nj[2],
  NAMS_trajectory_list)
#HRRR__
HRRR_traj_filter <- Filter(function(df)
  df[1, "Latitude"] >= point_pleasant_nj[1] &
    df[1, "Latitude"] >= cape_may_nj[1] ,
  HRRR_trajectory_list)
HRRR_traj_filter <- Filter(function(df)
  df[1, "Longitude"] >= cape_may_nj[2] &
    df[1, "Longitude"] <= point_pleasant_nj[2],
  HRRR_trajectory_list)
#TRAJECTORY TIME FILTER___
library(lubridate)
get_utc_offset_EST <- function(datetime) {
  datetime_ny <- with_tz(as.POSIXct(datetime, tz = "UTC"), tzone = "America/New_York")
  offset_hours <- as.numeric(format(datetime_ny, "%z")) / 100
  return(offset_hours)
}
#NAMS__
NAMS_time_traj_filter <- lapply(NAMS_traj_filter, function(df)
  head(df, 12))
UTC_OFFSET <- get_utc_offset_EST(NAMS_time_traj_filter[[1]][["Starting.Date.Time"]][[1]])
NAMS_time_traj_filter <- Filter(function(df)
  df[1, "Current_Hour"] >= 10 - UTC_OFFSET &
    #hours of interest are 10 through 16
    df[1, "Current_Hour"] <= 16 - UTC_OFFSET,
  NAMS_time_traj_filter)
#HRRR__
HRRR_time_traj_filter <- lapply(HRRR_traj_filter, function(df)
  head(df, 12))
UTC_OFFSET <- get_utc_offset_EST(HRRR_time_traj_filter[[1]][["Starting.Date.Time"]][[1]])
HRRR_time_traj_filter <- Filter(function(df)
  df[1, "Current_Hour"] >= 10 - UTC_OFFSET &
    #hours of interest are 10 through 16
    df[1, "Current_Hour"] <= 16 - UTC_OFFSET,
  HRRR_time_traj_filter)
#CRUISE LOCATION FILTER___
library(dplyr)
cruise_loc_filter <- cruise_tracks %>%
  dplyr::filter(Latitude_deg <= point_pleasant_nj[1] &
                  Latitude_deg >= cape_may_nj[1])
cruise_loc_filter <- cruise_loc_filter %>%
  dplyr::filter(Longitude_deg >= cape_may_nj[2] &
                  Longitude_deg <= point_pleasant_nj[2])
cruise_loc_filter$Time_local <- as.POSIXct(cruise_loc_filter$Time_local,
                                           origin = "1904-01-01",
                                           tz = "America/New_York")
#CRUISE TIME AVG FILTER___
cruise_time_filter <- cruise_loc_filter
library(openair)
colnames(cruise_time_filter)[colnames(cruise_time_filter) == "Time_local"] <- "date"
cruise_time_filter <- timeAverage(
  cruise_time_filter,
  avg.time = "min",
  data.thresh = 0,
  statistic = "mean"
)
cruise_time_filter_std <- timeAverage(
  cruise_time_filter,
  avg.time = "min",
  data.thresh = 0,
  statistic = "sd"
)
cruise_time_filter$closest_hr <- format(round(cruise_time_filter$date, units =
                                                "hours"), format = "%H:%M")
cruise_time_filter <- cruise_time_filter[cruise_time_filter$closest_hr >= 10 &
                                           cruise_time_filter$closest_hr <= 18, , drop = FALSE]
cruise_time_filter$Day <- as.Date(cruise_time_filter$date)

cruise_time_filter_std <- data.frame(cruise_time_filter)
cruise_time_filter_std$closest_hr <- format(round(cruise_time_filter_std$date, units =
                                                    "hours"), format = "%H:%M")
cruise_time_filter_std <- cruise_time_filter_std[cruise_time_filter_std$closest_hr >= 10 &
                                                   cruise_time_filter_std$closest_hr <= 18, , drop = FALSE]
cruise_time_filter_std$Day <- as.Date(cruise_time_filter_std$date)

##### PLOTTING ######
#FIXING QUADRANTS___
#NAMS__
NAMS_most_visited_df <- data.frame(
  Trajectory = character(),
  Most_Visited_Quadrant = character(),
  Day = as.Date(character()),
  stringsAsFactors = FALSE
)
for (i in 1:length(NAMS_time_traj_filter)) {
  a <- NAMS_time_traj_filter[[i]][["Longitude"]][1]
  b <- NAMS_time_traj_filter[[i]][["Latitude"]][1]
  xrange <- range(a + 3, a - 3)
  yrange <- range(b + 3, b - 3)
  traj_lon <- NAMS_time_traj_filter[[i]][["Longitude"]]
  traj_lat <- NAMS_time_traj_filter[[i]][["Latitude"]]
  traj_name <- paste("NAMS Quadrants for", NAMS_time_traj_filter[[i]][["Starting.Date.Time"]][1], sep = " ")
  plot(
    traj_lon,
    traj_lat,
    xlim = xrange,
    ylim = yrange,
    xlab = "Longitude",
    ylab = "Latitude",
    main = traj_name
  )
  abline(h = b)
  abline(v = a)
  abline(a = b - a, b = 1)
  abline(a = b + a, b = -1)
  text(a + 1, b + 2.5, "Q1")
  text(a + 2, b + 1, "Q2")
  text(a + 2, b - 1, "Q3")
  text(a + 1, b - 2.5, "Q4")
  text(a - 1, b - 2.5, "Q5")
  text(a - 2, b - 1, "Q6")
  text(a - 2, b + 1, "Q7")
  text(a - 1, b + 2.5, "Q8")
  quadrant_counts <- c(
    Q1 = 0,
    Q2 = 0,
    Q3 = 0,
    Q4 = 0,
    Q5 = 0,
    Q6 = 0,
    Q7 = 0,
    Q8 = 0
  )
  for (j in 1:length(traj_lon)) {
    x <- traj_lon[j]
    y <- traj_lat[j]
    if (x > a & y > b & y - b > x - a) {
      quadrant_counts["Q1"] <- quadrant_counts["Q1"] + 1
    } else if (x > a & y > b & y - b < x - a) {
      quadrant_counts["Q2"] <- quadrant_counts["Q2"] + 1
    } else if (x > a & y < b & b - y < x - a) {
      quadrant_counts["Q3"] <- quadrant_counts["Q3"] + 1
    } else if (x > a & y < b & b - y > x - a) {
      quadrant_counts["Q4"] <- quadrant_counts["Q4"] + 1
    } else if (x < a & y < b & b - y > a - x) {
      quadrant_counts["Q5"] <- quadrant_counts["Q5"] + 1
    } else if (x < a & y < b & b - y < a - x) {
      quadrant_counts["Q6"] <- quadrant_counts["Q6"] + 1
    } else if (x < a & y > b & y - b < a - x) {
      quadrant_counts["Q7"] <- quadrant_counts["Q7"] + 1
    } else if (x < a & y > b & y - b > a - x) {
      quadrant_counts["Q8"] <- quadrant_counts["Q8"] + 1
    }
  }
  most_frequent_quadrant <- names(which.max(quadrant_counts))
  NAMS_most_visited_df <- rbind(
    NAMS_most_visited_df,
    data.frame(
      Trajectory = traj_name,
      Most_Visited_Quadrant = most_frequent_quadrant,
      Day = as.Date(NAMS_time_traj_filter[[i]][["Starting.Date.Time"]][[1]]),
      stringsAsFactors = FALSE
    )
  )
}
#HRRR__
HRRR_most_visited_df <- data.frame(
  Trajectory = character(),
  Most_Visited_Quadrant = character(),
  Day = as.Date(character()),
  stringsAsFactors = FALSE
)
for (i in 1:length(HRRR_time_traj_filter)) {
  a <- HRRR_time_traj_filter[[i]][["Longitude"]][1]
  b <- HRRR_time_traj_filter[[i]][["Latitude"]][1]
  xrange <- range(a + 3, a - 3)
  yrange <- range(b + 3, b - 3)
  traj_lon <- HRRR_time_traj_filter[[i]][["Longitude"]]
  traj_lat <- HRRR_time_traj_filter[[i]][["Latitude"]]
  traj_name <- paste("HRRR Quadrants for", HRRR_time_traj_filter[[i]][["Starting.Date.Time"]][1], sep = " ")
  plot(
    traj_lon,
    traj_lat,
    xlim = xrange,
    ylim = yrange,
    xlab = "Longitude",
    ylab = "Latitude",
    main = traj_name
  )
  abline(h = b)
  abline(v = a)
  abline(a = b - a, b = 1)
  abline(a = b + a, b = -1)
  text(a + 1, b + 2.5, "Q1")
  text(a + 2, b + 1, "Q2")
  text(a + 2, b - 1, "Q3")
  text(a + 1, b - 2.5, "Q4")
  text(a - 1, b - 2.5, "Q5")
  text(a - 2, b - 1, "Q6")
  text(a - 2, b + 1, "Q7")
  text(a - 1, b + 2.5, "Q8")
  quadrant_counts <- c(
    Q1 = 0,
    Q2 = 0,
    Q3 = 0,
    Q4 = 0,
    Q5 = 0,
    Q6 = 0,
    Q7 = 0,
    Q8 = 0
  )
  for (j in 1:length(traj_lon)) {
    x <- traj_lon[j]
    y <- traj_lat[j]
    if (x > a & y > b & y - b > x - a) {
      quadrant_counts["Q1"] <- quadrant_counts["Q1"] + 1
    } else if (x > a & y > b & y - b < x - a) {
      quadrant_counts["Q2"] <- quadrant_counts["Q2"] + 1
    } else if (x > a & y < b & b - y < x - a) {
      quadrant_counts["Q3"] <- quadrant_counts["Q3"] + 1
    } else if (x > a & y < b & b - y > x - a) {
      quadrant_counts["Q4"] <- quadrant_counts["Q4"] + 1
    } else if (x < a & y < b & b - y > a - x) {
      quadrant_counts["Q5"] <- quadrant_counts["Q5"] + 1
    } else if (x < a & y < b & b - y < a - x) {
      quadrant_counts["Q6"] <- quadrant_counts["Q6"] + 1
    } else if (x < a & y > b & y - b < a - x) {
      quadrant_counts["Q7"] <- quadrant_counts["Q7"] + 1
    } else if (x < a & y > b & y - b > a - x) {
      quadrant_counts["Q8"] <- quadrant_counts["Q8"] + 1
    }
  }
  most_frequent_quadrant <- names(which.max(quadrant_counts))
  HRRR_most_visited_df <- rbind(
    HRRR_most_visited_df,
    data.frame(
      Trajectory = traj_name,
      Most_Visited_Quadrant = most_frequent_quadrant,
      Day = as.Date(HRRR_time_traj_filter[[i]][["Starting.Date.Time"]][[1]]),
      stringsAsFactors = FALSE
    )
  )
}
#ADDING IT ALL TOGETHER___
#NAMS__
NAMS_AVG <- merge(cruise_time_filter, NAMS_most_visited_df, by = "Day")
NAMS_SD <- merge(cruise_time_filter_std, NAMS_most_visited_df, by = "Day")
NAMS_AVG <- NAMS_AVG[!is.na(NAMS_AVG$CO2_dry_cal_moving_day), ]
NAMS_SD <- NAMS_SD[!is.na(NAMS_SD$CO2_dry_cal_moving_day), ]
#HRRR__
HRRR_AVG <- merge(cruise_time_filter, HRRR_most_visited_df, by = "Day")
HRRR_SD <- merge(cruise_time_filter_std, HRRR_most_visited_df, by = "Day")
HRRR_AVG <- HRRR_AVG[!is.na(HRRR_AVG$CO2_dry_cal_moving_day), ]
HRRR_SD <- HRRR_SD[!is.na(HRRR_SD$CO2_dry_cal_moving_day), ]
#PLOTTING HISTOGRAMS___
#NAMS__
#CO2
for (q in unique(NAMS_AVG$Most_Visited_Quadrant)) {
  hist(
    NAMS_AVG$CO2_dry_cal_moving_day[NAMS_AVG$Most_Visited_Quadrant == q],
    xlab = "CO2 ppm",
    main = paste("NAMS Histogram for CO2", q, sep = " ")
  )
}
#CH4
for (q in unique(NAMS_AVG$Most_Visited_Quadrant)) {
  hist(
    NAMS_AVG$CH4_dry_cal_moving_day[NAMS_AVG$Most_Visited_Quadrant == q],
    xlab = "CH4 ppm",
    main = paste("NAMS Histogram for CH4", q, sep = " ")
  )
}
#HRRR__
#CO2
for (q in unique(HRRR_AVG$Most_Visited_Quadrant)) {
  hist(
    HRRR_AVG$CO2_dry_cal_moving_day[HRRR_AVG$Most_Visited_Quadrant == q],
    xlab = "CO2 ppm",
    main = paste("HRRR Histogram for CO2", q, sep = " ")
  )
}
#CH4
for (q in unique(HRRR_AVG$Most_Visited_Quadrant)) {
  hist(
    HRRR_AVG$CH4_dry_cal_moving_day[HRRR_AVG$Most_Visited_Quadrant == q],
    xlab = "CH4 ppm",
    main = paste("HRRR Histogram for CH4", q, sep = " ")
  )
}
#SUBSETTING TRAJECTORIES TO AVAILABLE DATA ONLY___
#NAMS__
NAMS_final_traj_filter <- lapply(NAMS_time_traj_filter, function(df)
  head(df, 12))
traj_dates_char <- character(length(NAMS_final_traj_filter))
for (i in 1:length(NAMS_final_traj_filter)) {
  traj_dates_char[i] <- NAMS_final_traj_filter[[i]][["Starting.Date.Time"]][[1]]
}
traj_dates <- as.Date(traj_dates_char)
matching_indices <- which(traj_dates %in% as.Date(NAMS_AVG$date))
NAMS_final_traj_filter <- NAMS_final_traj_filter[matching_indices]
#HRRR__
HRRR_final_traj_filter <- lapply(HRRR_time_traj_filter, function(df)
  head(df, 12))
traj_dates_char <- character(length(HRRR_final_traj_filter))
for (i in 1:length(HRRR_final_traj_filter)) {
  traj_dates_char[i] <- HRRR_final_traj_filter[[i]][["Starting.Date.Time"]][[1]]
}
traj_dates <- as.Date(traj_dates_char)
matching_indices <- which(traj_dates %in% as.Date(HRRR_AVG$date))
HRRR_final_traj_filter <- HRRR_final_traj_filter[matching_indices]
#AVERAGES___
#NAMS__
NAMS_quadrant_avg <- list()
for (q in unique(NAMS_AVG$Most_Visited_Quadrant)) {
  co2_mean <- mean(NAMS_AVG$CO2_dry_cal_moving_day[NAMS_AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  ch4_mean <- mean(NAMS_AVG$CH4_dry_cal_moving_day[NAMS_AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  NAMS_quadrant_avg[[q]] <- data.frame(
    Most_Visited_Quadrant = q,
    Mean_CO2 = co2_mean,
    Mean_CH4 = ch4_mean
  )
}
NAMS_sum_quad_avg <- do.call(rbind, NAMS_quadrant_avg)
quadrant_order <- paste0("Q", 1:8)
NAMS_sum_quad_avg <- NAMS_sum_quad_avg[match(quadrant_order, NAMS_sum_quad_avg$Most_Visited_Quadrant), ]
NAMS_sum_quad_avg2 <- NAMS_sum_quad_avg
NAMS_sum_quad_avg <- na.omit(NAMS_sum_quad_avg)
#CO2
bp <- barplot(
  height = NAMS_sum_quad_avg$Mean_CO2,
  names.arg = NAMS_sum_quad_avg$Most_Visited_Quadrant,
  ylab = "Mean CO2",
  xlab = "Most Visited Quadrant",
  main = "NAMS Average CO2 by Quadrant",
  col = "skyblue",
  ylim = c(0, max(NAMS_sum_quad_avg$Mean_CO2) * 1.1)
)
text(
  x = bp,
  y = NAMS_sum_quad_avg$Mean_CO2,
  labels = round(NAMS_sum_quad_avg$Mean_CO2, 3),
  pos = 3,
  cex = 0.8
)
#CH4
bp <- barplot(
  height = NAMS_sum_quad_avg$Mean_CH4,
  names.arg = NAMS_sum_quad_avg$Most_Visited_Quadrant,
  ylab = "Mean CH4",
  xlab = "Most Visited Quadrant",
  main = "NAMS Average CH4 by Quadrant",
  col = "skyblue",
  ylim = c(0, max(NAMS_sum_quad_avg$Mean_CH4) * 1.1)
)
text(
  x = bp,
  y = NAMS_sum_quad_avg$Mean_CH4,
  labels = round(NAMS_sum_quad_avg$Mean_CH4, 3),
  pos = 3,
  cex = 0.8
)
#HRRR__
HRRR_quadrant_avg <- list()
for (q in unique(HRRR_AVG$Most_Visited_Quadrant)) {
  co2_mean <- mean(HRRR_AVG$CO2_dry_cal_moving_day[HRRR_AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  ch4_mean <- mean(HRRR_AVG$CH4_dry_cal_moving_day[HRRR_AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  co2_SD <- mean(HRRR_SD$CO2_dry_cal_moving_day[HRRR_SD$Most_Visited_Quadrant == q], na.rm = TRUE)
  ch4_SD <- mean(HRRR_SD$CH4_dry_cal_moving_day[HRRR_SD$Most_Visited_Quadrant == q], na.rm = TRUE)
  
  HRRR_quadrant_avg[[q]] <- data.frame(
    Most_Visited_Quadrant = q,
    Mean_CO2 = co2_mean,
    Mean_CH4 = ch4_mean,
    SD_CO2 = co2_SD,
    SD_CH4 = ch4_SD#I have the SD dataframe so should I add it in here?
  )
}
HRRR_sum_quad_avg <- do.call(rbind, HRRR_quadrant_avg)
quadrant_order <- paste0("Q", 1:8)
HRRR_sum_quad_avg <- HRRR_sum_quad_avg[match(quadrant_order, HRRR_sum_quad_avg$Most_Visited_Quadrant), ]
HRRR_sum_quad_avg2 <- HRRR_sum_quad_avg
HRRR_sum_quad_avg <- na.omit(HRRR_sum_quad_avg)
#ADD STANDARD DEVIATION 


#CO2
bp <- barplot(
  height = HRRR_sum_quad_avg$Mean_CO2,
  names.arg = HRRR_sum_quad_avg$Most_Visited_Quadrant,
  ylab = "Mean CO2",
  xlab = "Most Visited Quadrant",
  main = "HRRR Average CO2 by Quadrant",
  col = "skyblue",
  ylim = c(0, max(HRRR_sum_quad_avg$Mean_CO2) * 1.1)
)
text(
  x = bp,
  y = HRRR_sum_quad_avg$Mean_CO2,
  labels = round(HRRR_sum_quad_avg$Mean_CO2, 3),
  pos = 3,
  cex = 0.8
)
arrows(bp, HRRR_sum_quad_avg$Mean_CO2 - HRRR_sum_quad_avg$SD_CO2, #add standard deviation 
       bp, HRRR_sum_quad_avg$Mean_CO2 + HRRR_sum_quad_avg$SD_CO2 ,angle=90,code=3) #add real SD

#SHOULDN'T BE THE SAME NUMBERS 

#CH4
bp <- barplot(
  height = HRRR_sum_quad_avg$Mean_CH4,
  names.arg = HRRR_sum_quad_avg$Most_Visited_Quadrant,
  ylab = "Mean CH4",
  xlab = "Most Visited Quadrant",
  main = "HRRR Average CH4 by Quadrant",
  col = "skyblue",
  ylim = c(0, max(HRRR_sum_quad_avg$Mean_CH4) * 1.1)
)
text(
  x = bp,
  y = HRRR_sum_quad_avg$Mean_CH4,
  labels = round(HRRR_sum_quad_avg$Mean_CH4, 3),
  pos = 3,
  cex = 0.8
)
#AVG CIRCLE___
#NAMS__
#CO2
values <- NAMS_sum_quad_avg2$Mean_CO2
valid_idx <- !is.na(values)
r_min <- 0.2
r_max <- 1
scaled_values <- values
scaled_values[valid_idx] <- r_min + (values[valid_idx] - min(values[valid_idx])) /
  (max(values[valid_idx]) - min(values[valid_idx])) * (r_max - r_min)
angles <- (pi / 4 - (0:7) * pi / 4) + pi / 8
x <- scaled_values * cos(angles)
y <- scaled_values * sin(angles)
plot(
  0,
  0,
  type = "n",
  asp = 1,
  xlim = c(-1.2, 1.2),
  ylim = c(-1.2, 1.2),
  xlab = "",
  ylab = "",
  axes = FALSE,
  main = "NAMS AVG CO2"
)
symbols(
  0,
  0,
  circles = 1,
  inches = FALSE,
  add = TRUE,
  lty = 2
)
for (a in seq(0, 2 * pi, length.out = 9)[-9]) {
  segments(0, 0, cos(a), sin(a), col = "lightgray")
}
points(x[valid_idx],
       y[valid_idx],
       pch = 21,
       bg = "tomato",
       cex = 1.5)
valid_x <- x[valid_idx]
valid_y <- y[valid_idx]
lines(c(valid_x, valid_x[1]),
      c(valid_y, valid_y[1]),
      col = "tomato4",
      lwd = 2)
text(x[valid_idx], y[valid_idx], labels = round(values[valid_idx], 3), pos = 3)
quad_labels <- paste0("Q", 1:8)
label_radius <- 1.2
label_x <- label_radius * cos(angles)
label_y <- label_radius * sin(angles)
text(label_x,
     label_y,
     labels = quad_labels,
     font = 2,
     cex = 0.9)
#CH4
values <- NAMS_sum_quad_avg2$Mean_CH4
valid_idx <- !is.na(values)
r_min <- 0.2
r_max <- 1
scaled_values <- values
scaled_values[valid_idx] <- r_min + (values[valid_idx] - min(values[valid_idx])) /
  (max(values[valid_idx]) - min(values[valid_idx])) * (r_max - r_min)
angles <- (pi / 4 - (0:7) * pi / 4) + pi / 8
x <- scaled_values * cos(angles)
y <- scaled_values * sin(angles)
plot(
  0,
  0,
  type = "n",
  asp = 1,
  xlim = c(-1.2, 1.2),
  ylim = c(-1.2, 1.2),
  xlab = "",
  ylab = "",
  axes = FALSE,
  main = "NAMS AVG CH4"
)
symbols(
  0,
  0,
  circles = 1,
  inches = FALSE,
  add = TRUE,
  lty = 2
)
for (a in seq(0, 2 * pi, length.out = 9)[-9]) {
  segments(0, 0, cos(a), sin(a), col = "lightgray")
}
points(x[valid_idx],
       y[valid_idx],
       pch = 21,
       bg = "tomato",
       cex = 1.5)
valid_x <- x[valid_idx]
valid_y <- y[valid_idx]
lines(c(valid_x, valid_x[1]),
      c(valid_y, valid_y[1]),
      col = "tomato4",
      lwd = 2)
text(x[valid_idx], y[valid_idx], labels = round(values[valid_idx], 3), pos = 3)
quad_labels <- paste0("Q", 1:8)
label_radius <- 1.2
label_x <- label_radius * cos(angles)
label_y <- label_radius * sin(angles)
text(label_x,
     label_y,
     labels = quad_labels,
     font = 2,
     cex = 0.9)
#HRRR__
#CO2
values <- HRRR_sum_quad_avg2$Mean_CO2
valid_idx <- !is.na(values)
r_min <- 0.2
r_max <- 1
scaled_values <- values
scaled_values[valid_idx] <- r_min + (values[valid_idx] - min(values[valid_idx])) /
  (max(values[valid_idx]) - min(values[valid_idx])) * (r_max - r_min)
angles <- (pi / 4 - (0:7) * pi / 4) + pi / 8
x <- scaled_values * cos(angles)
y <- scaled_values * sin(angles)
plot(
  0,
  0,
  type = "n",
  asp = 1,
  xlim = c(-1.2, 1.2),
  ylim = c(-1.2, 1.2),
  xlab = "",
  ylab = "",
  axes = FALSE,
  main = "HRRR AVG CO2"
)
symbols(
  0,
  0,
  circles = 1,
  inches = FALSE,
  add = TRUE,
  lty = 2
)
for (a in seq(0, 2 * pi, length.out = 9)[-9]) {
  segments(0, 0, cos(a), sin(a), col = "lightgray")
}
points(x[valid_idx],
       y[valid_idx],
       pch = 21,
       bg = "tomato",
       cex = 1.5)
valid_x <- x[valid_idx]
valid_y <- y[valid_idx]
lines(c(valid_x, valid_x[1]),
      c(valid_y, valid_y[1]),
      col = "tomato4",
      lwd = 2)
text(x[valid_idx], y[valid_idx], labels = round(values[valid_idx], 3), pos = 3)
quad_labels <- paste0("Q", 1:8)
label_radius <- 1.2
label_x <- label_radius * cos(angles)
label_y <- label_radius * sin(angles)
text(label_x,
     label_y,
     labels = quad_labels,
     font = 2,
     cex = 0.9)
#CH4
values <- HRRR_sum_quad_avg2$Mean_CH4
valid_idx <- !is.na(values)
r_min <- 0.2
r_max <- 1
scaled_values <- values
scaled_values[valid_idx] <- r_min + (values[valid_idx] - min(values[valid_idx])) /
  (max(values[valid_idx]) - min(values[valid_idx])) * (r_max - r_min)
angles <- (pi / 4 - (0:7) * pi / 4) + pi / 8
x <- scaled_values * cos(angles)
y <- scaled_values * sin(angles)
plot(
  0,
  0,
  type = "n",
  asp = 1,
  xlim = c(-1.2, 1.2),
  ylim = c(-1.2, 1.2),
  xlab = "",
  ylab = "",
  axes = FALSE,
  main = "HRRR AVG CH4"
)
symbols(
  0,
  0,
  circles = 1,
  inches = FALSE,
  add = TRUE,
  lty = 2
)
for (a in seq(0, 2 * pi, length.out = 9)[-9]) {
  segments(0, 0, cos(a), sin(a), col = "lightgray")
}
points(x[valid_idx],
       y[valid_idx],
       pch = 21,
       bg = "tomato",
       cex = 1.5)
valid_x <- x[valid_idx]
valid_y <- y[valid_idx]
lines(c(valid_x, valid_x[1]),
      c(valid_y, valid_y[1]),
      col = "tomato4",
      lwd = 2)
text(x[valid_idx], y[valid_idx], labels = round(values[valid_idx], 3), pos = 3)
quad_labels <- paste0("Q", 1:8)
label_radius <- 1.2
label_x <- label_radius * cos(angles)
label_y <- label_radius * sin(angles)
text(label_x,
     label_y,
     labels = quad_labels,
     font = 2,
     cex = 0.9)
#PLOT HEIGHT V TIME___
#NAMS__
#Plot height v time- one traj for each plot
for (i in 1:length(NAMS_final_traj_filter)) {
  plot(NAMS_final_traj_filter[[i]][["Elapsed Time (Backwards)"]],
       NAMS_final_traj_filter[[i]][["Height (m)"]],
       xlab= "Time Elapsed", ylab= "Height (m)", 
       main = paste("NAMS",NAMS_final_traj_filter[[i]][["Starting.Date.Time"]][1], sep = " "),
       type= "b",
       col = "tomato",
       pch = 20
  )
}
#All trajectories on one plot
plot(NAMS_final_traj_filter[[1]][["Elapsed Time (Backwards)"]],
     NAMS_final_traj_filter[[1]][["Height (m)"]],
     xlab= "Time Elapsed", ylab= "Height (m)", 
     main = "ALL NAMS TRAJECTORIES",
     type= "b",
     col = "black",
     pch = 20,
     ylim = c(0,600)
)
library(paletteer)
cols = paletteer_c("grDevices::rainbow", n = length(NAMS_final_traj_filter)-1)
for (i in 2:length(NAMS_final_traj_filter)) { 
  lines(NAMS_final_traj_filter[[i]][["Elapsed Time (Backwards)"]],
        NAMS_final_traj_filter[[i]][["Height (m)"]],
        type = "b",
        pch=20,
        col = cols[i])
}
k = 2
legend_text2 <- c(NAMS_final_traj_filter[[1]][["Starting.Date.Time"]][1])
while (k <= length(NAMS_final_traj_filter)) {
  date <- NAMS_final_traj_filter[[k]][["Starting.Date.Time"]][1]
  legend_text2 <- append(legend_text2, c(date))
  k = k + 1
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "NAMS trajectories",
  text.font = 3,
  col = c("black", cols[1:25]),
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#HRRR__
#Plot height v time- one traj for each plot
for (i in 1:length(HRRR_final_traj_filter)) {
plot(HRRR_final_traj_filter[[i]][["Elapsed Time (Backwards)"]],
     HRRR_final_traj_filter[[i]][["Height (m)"]],
     xlab= "Time Elapsed", ylab= "Height (m)", 
     main = paste("HRRR", HRRR_final_traj_filter[[i]][["Starting.Date.Time"]][1], sep=" "),
     type= "b",
     col = "tomato",
     pch = 20
     )
  }
#All trajectories on one plot
  plot(HRRR_final_traj_filter[[1]][["Elapsed Time (Backwards)"]],
       HRRR_final_traj_filter[[1]][["Height (m)"]],
       xlab= "Time Elapsed", ylab= "Height (m)", 
       main = "ALL HRRR TRAJECTORIES",
       type= "b",
       col = "black",
       pch = 20,
       ylim = c(0,600)
  )
library(paletteer)
cols = paletteer_c("grDevices::rainbow", n = length(HRRR_final_traj_filter)-1)
  for (i in 2:length(HRRR_final_traj_filter)) { 
    lines(HRRR_final_traj_filter[[i]][["Elapsed Time (Backwards)"]],
         HRRR_final_traj_filter[[i]][["Height (m)"]],
         type = "b",
         pch=20,
         col = cols[i])
  }
k = 2
legend_text2 <- c(HRRR_final_traj_filter[[1]][["Starting.Date.Time"]][1])
while (k <= length(HRRR_final_traj_filter)) {
  date <- HRRR_final_traj_filter[[k]][["Starting.Date.Time"]][1]
  legend_text2 <- append(legend_text2, c(date))
  k = k + 1
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "HRRR trajectories",
  text.font = 3,
  col = c("black", cols[1:25]),
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#BOTH__
plot(NAMS_final_traj_filter[[1]][["Elapsed Time (Backwards)"]],
     NAMS_final_traj_filter[[1]][["Height (m)"]],
     xlab= "Time Elapsed", ylab= "Height (m)", 
     main = "ALL TRAJECTORIES",
     type= "b",
     col = "blue",
     pch = 20,
     ylim = c(0,600)
)
library(paletteer)
cols = paletteer_c("grDevices::rainbow", n = length(NAMS_final_traj_filter)-1)
for (i in 2:length(NAMS_final_traj_filter)) { 
  lines(NAMS_final_traj_filter[[i]][["Elapsed Time (Backwards)"]],
        NAMS_final_traj_filter[[i]][["Height (m)"]],
        type = "b",
        pch=20,
        col = "blue")
}
for (i in 1:length(HRRR_final_traj_filter)) { 
  lines(HRRR_final_traj_filter[[i]][["Elapsed Time (Backwards)"]],
        HRRR_final_traj_filter[[i]][["Height (m)"]],
        type = "b",
        pch=20,
        col = "red")
  
}

##### NEW PLOTS ####
states <- st_transform(states, crs = 4326)
plot(
  st_geometry((states)),
  xlim = c(-78, -70),
  ylim = c(38, 42),
  xlab = "Longitude",
  ylab = "Latitude",
  main = "Cruise 4: 4-10-2022, 10:00 - 16:00 EDT HRRR Trajectories",
  border = "grey",
  axes = T,
  las = 1,
  asp = 1
)
 # for (i in 1:length(HRRR_final_traj_filter)) { 
 #  lines(HRRR_final_traj_filter[[i]][["Longitude"]],HRRR_final_traj_filter[[i]][["Latitude"]])
 # }

 lines(HRRR_final_traj_filter[[2]][["Longitude"]],HRRR_final_traj_filter[[2]][["Latitude"]], col = "red")
 lines(HRRR_final_traj_filter[[3]][["Longitude"]],HRRR_final_traj_filter[[3]][["Latitude"]], col = "blue")
 lines(HRRR_final_traj_filter[[4]][["Longitude"]],HRRR_final_traj_filter[[4]][["Latitude"]], col = "green")
 lines(HRRR_final_traj_filter[[5]][["Longitude"]],HRRR_final_traj_filter[[5]][["Latitude"]], col = "yellow") 
 lines(HRRR_final_traj_filter[[6]][["Longitude"]],HRRR_final_traj_filter[[6]][["Latitude"]], col = "orange") 
 lines(HRRR_final_traj_filter[[7]][["Longitude"]],HRRR_final_traj_filter[[7]][["Latitude"]], col = "purple") 
 lines(HRRR_final_traj_filter[[8]][["Longitude"]],HRRR_final_traj_filter[[8]][["Latitude"]], col = "brown")

#add towers
twr <-read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
#twr <- twr[twr$SiteCode == "LEW", ]
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ"), ]

points(twr$Lon,twr$Lat, pch = 23, col = "black", bg = "black")
text(twr$Lon, twr$Lat, labels = twr$SiteCode, pos = 4, cex = 0.8)

labels <- sapply(2:8, function(i) { #change this when necessary
  dt <- HRRR_final_traj_filter[[i]][["Starting.Date.Time"]][1]
  dt <- as.POSIXct(dt, tz = "America/New_York")   # ensure proper datetime object
  format(dt, "%H:%M %Z")                          # gives "10:00 EDT"
})

# add legend
legend("bottomright",
       inset = -0.135,
       legend = labels,
       col = c("red", "blue", "green", "yellow", "orange", "purple", "brown"),
       lty = 1,
       cex = 0.9,
       bty = "n",
       y.intersp = 0.3
     )



tracks4 <- read.csv("/Users/reneechabot-mehlin/Downloads/2022-04-07__2022-04-16_Seawolf_1hz.csv")
tracks4 <- tracks4[!is.na(tracks4$Latitude_deg), ]
tracks4$Time_local <- as.POSIXct(tracks4$Time_local, origin = "1904-01-01", tz = "America/New_York")
tracks4$DATE <- as.Date(tracks4$Time_local)

library(sf)
library(ggplot2)
states <- st_transform(states, crs = 4326)

dates <- sort(unique(tracks4$DATE))
colors <- rainbow(length(dates))
names(colors) <- as.character(dates)

start_points <- tracks4[!duplicated(tracks4$DATE), ]

ggplot() +
  geom_sf(data = states,
          fill = NA,
          color = "grey2") +
  geom_path(
    data = tracks4,
    aes(x = Longitude_deg, y = Latitude_deg, color = as.factor(DATE)),
    size = 1
  ) +
  scale_color_manual(values = colors) +
  coord_sf(xlim = c(-78, -70), ylim = c(38, 42)) +
  labs(
    title = "Cruise 4 Tracks: 04/05/22 - 04/16/22",
    x = "Longitude",
    y = "Latitude",
    color = "Date"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    legend.title = element_text(size = 14),
    plot.title = element_text(size = 20,face = "bold"),
    legend.text = element_text(size =13)
  )



cruise = "Cruise 4"
cruise_squish <- tolower(gsub(" ", "", cruise))
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