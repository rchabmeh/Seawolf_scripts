##Script for statistical analysis of back trajectories##
#load in trajectories and cruise tracks
#set boundaries: location boundaries and time boundaries
#     time: 10-16 EDT
#     location: btwn Point Pleasant and Cape May
#filter trajectories
#filter cruise tracks
#sort first 12 hours into angle segments:
#     1. 00-45
#     2. 46-90
#     3. 91-135
#     4. 136-180
#     5. 181-225
#     6. 226-270
#     7. 271-315
#     8. 316-360 (or maybe 359?)
#avg measurements in cruise track to minute intervals
#take the std.dev of interval measurements
#sort cruise track info into the segments based on closest hour
#     ie. 9:30-10:29 sorts with trajectory from 10
#create a histogram with frequency on x-axis and conc avg on y-axis for each angle bin

#CRUISE TRACKS___
cruise_tracks <- read.delim("/Users/reneechabot/Desktop/moving_data.txt"
                            ,
                            sep = ",",
                            dec = ".")
cruise_tracks <- cruise_tracks[!is.na(cruise_tracks$Longitude_deg), ]
cruise_tracks <- cruise_tracks[!is.na(cruise_tracks$CO2_dry_cal_moving_day), ]

#TRAJECTORIES___
directory <- "/Users/reneechabot/Desktop/test"
#directory <- "/Users/reneechabot/hysplit/working/cruise_4_hrrr_tdump_files"
setwd(directory)
tdump_files = list.files(
  pattern = glob2rx("tdump?*"),
  recursive = T,
  full.names = T
)
sorted <- order(basename(tdump_files))
tdump_files <- (tdump_files[sorted])
trajectory_list <- list()
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
  Single_Example_file_traj1$Starting.Date.Time <- format(Single_Example_file_traj1$Starting.Date.Time,
                                                         tz = "America/New_York",
                                                         usetz = TRUE)
  trajectory_list <- append(trajectory_list, list(Single_Example_file_traj1))
  i = i + 1
}
#CONSTANTS___
point_pleasant_nj <- c(40.083721, -74.066910)
cape_may_nj <- c(38.9316, -74.9108)
timespan <- sprintf("%02d:00", 10:16)
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
#TRAJECTORY LOCATION FILTER___
traj_filter <- Filter(function(df)
  df[1, "Latitude"] >= point_pleasant_nj[1] &
    df[1, "Latitude"] >= cape_may_nj[1] ,
  trajectory_list)
traj_filter <- Filter(function(df)
  df[1, "Longitude"] >= cape_may_nj[2] &
    df[1, "Longitude"] <= point_pleasant_nj[2],
  trajectory_list)
#CRUISE TIME AVG FILTER___
cruise_time_filter <- cruise_loc_filter #cruise_loc_filter[, c(2, 25, 27, 28)]
library(openair)
colnames(cruise_time_filter)[colnames(cruise_time_filter) == "Time_local"] <- "date"
cruise_time_filter <- timeAverage(
  cruise_time_filter,
  avg.time = "min",
  data.thresh = 0,
  statistic = "mean"
)
#standard deviation
colnames(cruise_loc_filter)[colnames(cruise_loc_filter) == "Time_local"] <- "date"
cruise_loc_filter$minute <- as.POSIXct(
  format(cruise_loc_filter$date, "%Y-%m-%d %H:%M:00"),
  tz = attr(cruise_time_filter$date, "tzone")
)

numeric_cols <- sapply(cruise_loc_filter, is.numeric)
numeric_cols["date"] <- FALSE
numeric_data <- cruise_loc_filter[, numeric_cols]

cruise_time_filter_std <- aggregate(numeric_data,
                                    by = list(minute = cruise_loc_filter$minute),
                                    FUN = sd)
#median
cruise_time_filter_median <- aggregate(numeric_data,
                                       by = list(minute = cruise_loc_filter$minute),
                                       FUN = median)


#TRAJECTORY TIME FILTER___
#Hours: 10-16 EDT
library(lubridate)
get_utc_offset_EST <- function(datetime) {
  datetime_ny <- with_tz(as.POSIXct(datetime, tz = "UTC"), tzone = "America/New_York")
  offset_hours <- as.numeric(format(datetime_ny, "%z")) / 100
  return(offset_hours)
}
time_traj_filter <- lapply(traj_filter, function(df)
  head(df, 12))
UTC_OFFSET <- get_utc_offset_EST(time_traj_filter[[1]][["Starting.Date.Time"]][[1]])
time_traj_filter <- Filter(function(df)
  df[1, "Current_Hour"] >= 10 - UTC_OFFSET &
    #hours of interest are 10 through 16
    df[1, "Current_Hour"] <= 16 - UTC_OFFSET,
  time_traj_filter)
#CRUISE SORTING INTO TIME BINS___
cruise_time_filter$closest_hr <- format(round(cruise_time_filter$date, units =
                                                "hours"), format = "%H:%M")
cruise_time_filter <- cruise_time_filter[cruise_time_filter$closest_hr >= 10 &
                                           cruise_time_filter$closest_hr <= 16, , drop = FALSE]
cruise_time_filter$Day <- as.Date(cruise_time_filter$date)
#standard dev
cruise_time_filter_std$closest_hr <- format(round(cruise_time_filter_std$minute, units =
                                                    "hours"), format = "%H:%M")
cruise_time_filter_std <- cruise_time_filter_std[cruise_time_filter_std$closest_hr >= 10 &
                                                   cruise_time_filter_std$closest_hr <= 16, , drop = FALSE]
cruise_time_filter_std$Day <- as.Date(cruise_time_filter_std$minute)
#median
cruise_time_filter_median$closest_hr <- format(round(cruise_time_filter_median$minute, units =
                                                       "hours"),
                                               format = "%H:%M")
cruise_time_filter_median <- cruise_time_filter_median[cruise_time_filter_median$closest_hr >= 10 &
                                                         cruise_time_filter_median$closest_hr <= 16, , drop = FALSE]
cruise_time_filter_median$Day <- as.Date(cruise_time_filter_median$minute)

#WHAT ARE YOU WORKING WITH??___
trajectories <- length(time_traj_filter)
observations <- nrow(cruise_time_filter)
print(
  paste0(
    "You have ",
    trajectories,
    " trajectories with ",
    observations,
    " observations to sort into WD bins"
  )
)
#FIXING QUADRANTS___
most_visited_df <- data.frame(
  Trajectory = character(),
  Most_Visited_Quadrant = character(),
  Day = as.Date(character()),
  stringsAsFactors = FALSE
)

for (i in 1:length(time_traj_filter)) {
  a <- time_traj_filter[[i]][["Longitude"]][1]
  b <- time_traj_filter[[i]][["Latitude"]][1]
  xrange <- range(a + 3, a - 3)
  yrange <- range(b + 3, b - 3)
  traj_lon <- time_traj_filter[[i]][["Longitude"]]
  traj_lat <- time_traj_filter[[i]][["Latitude"]]
  traj_name <- paste("Quadrants for", time_traj_filter[[i]][["Starting.Date.Time"]][1], sep = " ")
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
  
  most_visited_df <- rbind(
    most_visited_df,
    data.frame(
      Trajectory = traj_name,
      Most_Visited_Quadrant = most_frequent_quadrant,
      Day = as.Date(time_traj_filter[[i]][["Starting.Date.Time"]][[1]]),
      stringsAsFactors = FALSE
    )
  )
}
#ADDING IT ALL TOGETHER___
AVG <- merge(cruise_time_filter, most_visited_df, by = "Day")
SD <- merge(cruise_time_filter_std, most_visited_df, by = "Day")
AVG <- AVG[!is.na(AVG$CO2_dry_cal_moving_day), ]
SD <- SD[!is.na(SD$CO2_dry_cal_moving_day), ]
MED <- merge(cruise_time_filter_median, most_visited_df, by = "Day")
MED <- MED[!is.na(MED$CO2_dry_cal_moving_day), ]
#PLOTTING HISTOGRAMS
#CO2
for (q in unique(AVG$Most_Visited_Quadrant)) {
  hist(
    AVG$CO2_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q],
    xlab = "CO2 ppm",
    main = paste("Histogram for CO2", q, sep = " ")
  )
}
#CH4
for (q in unique(AVG$Most_Visited_Quadrant)) {
  hist(
    AVG$CH4_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q],
    xlab = "CH4 ppm",
    main = paste("Histogram for CH4", q, sep = " ")
  )
}
#SUBSETTING TRAJECTORIES TO AVAILABLE DATA ONLY
final_traj_filter <- lapply(time_traj_filter, function(df)
  head(df, 12))
traj_dates_char <- character(length(final_traj_filter))
for (i in 1:length(final_traj_filter)) {
  traj_dates_char[i] <- final_traj_filter[[i]][["Starting.Date.Time"]][[1]]
}
traj_dates <- as.Date(traj_dates_char)
matching_indices <- which(traj_dates %in% as.Date(AVG$date))
final_traj_filter <- final_traj_filter[matching_indices]
#FINAL INFO:
trajectories2 <- length(final_traj_filter)
observations2 <- nrow(AVG)
print(paste0(
  "You have ",
  trajectories2,
  " trajectories and ",
  observations2,
  " observations"
))
saveRDS(final_traj_filter, file = "/Users/reneechabot/Desktop/8final_traj.RData")
#PLOT ALONG TRACKS___
library(ggplot2)
library(sf)
library(sp)
library(terra)
library(tmap)
library(paletteer)
states <- st_read(
  "/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp"
)
cruise_tracks <- read.delim(
  '/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 14 (10 11 22-11 3 22)/moving_data.txt'
  ,
  sep = ",",
  dec = "."
)
cruise_tracks <- cruise_tracks[!is.na(cruise_tracks$Longitude_deg), ]
plot(
  st_geometry((states)),
  xlim = c(-78, -70),
  ylim = c(38, 42),
  xlab = "",
  ylab = "",
  main = "Back Trajectories in HRRR: Cruise 8",
  border = "grey",
  axes = T,
  las = 1
)
lines(
  cruise_tracks$Longitude_deg,
  cruise_tracks$Latitude_deg,
  col = 'grey4',
  lwd = "2"
)
points(
  point_pleasant_nj[2],
  point_pleasant_nj[1],
  col = "black",
  bg = "blue",
  pch = 25
)
text(point_pleasant_nj[2] - .6,
     point_pleasant_nj[1],
     "Point Pleasant",
     cex = 0.7)
points(
  cape_may_nj[2],
  cape_may_nj[1],
  col = "black",
  bg = "orange",
  pch = 25
)
text(cape_may_nj[2] - .5, cape_may_nj[1], "Cape May", cex = 0.7)
colors = paletteer_c("grDevices::rainbow", n = length(final_traj_filter))
for (i in 1:length(final_traj_filter)) {
  lines(
    final_traj_filter[[i]][["Longitude"]],
    final_traj_filter[[i]][["Latitude"]],
    #add color based on trajectory date
    col = colors[i],
    type = "o",
    pch = 20,
    cex = 0.6
  )
}
k = 1
legend_text2 <- c("SeaWolf Tracks")
while (k <= length(final_traj_filter)) {
  date <- lapply(final_traj_filter[[k]][[14]][[1]], as.character)
  legend_text2 <- append(legend_text2, c(date))
  k = k + 1
}
plot.new()
par(xpd = T)
legend(
  "center",
  legend = c(legend_text2),
  title = "Dates-Cruise 8",
  text.font = 3,
  col = c("grey4", colors[1:21]),
  lty = 1,
  ncol = 3,
  cex = .3,
  pt.cex = 3,
  pt.lwd = 3,
  lwd = 3,
  bg = "aliceblue"
)
#AVERAGES___
quadrant_avg <- list()
for (q in unique(AVG$Most_Visited_Quadrant)) {
  co2_mean <- mean(AVG$CO2_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  ch4_mean <- mean(AVG$CH4_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  co2_sd <- sd(AVG$CO2_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  ch4_sd <- sd(AVG$CH4_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  co2_med <-median(AVG$CO2_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  ch4_med <-median(AVG$CH4_dry_cal_moving_day[AVG$Most_Visited_Quadrant == q], na.rm = TRUE)
  
  
  
  quadrant_avg[[q]] <- data.frame(
    Most_Visited_Quadrant = q,
    Mean_CO2 = co2_mean,
    Mean_CH4 = ch4_mean,
    SD_CO2 = co2_sd,
    SD_CH4 = ch4_sd ,
    Median_CO2 = co2_med,
    Median_CH4 = ch4_med
  )
}
sum_quad_avg <- do.call(rbind, quadrant_avg)
quadrant_order <- paste0("Q", 1:8)
sum_quad_avg <- sum_quad_avg[match(quadrant_order, sum_quad_avg$Most_Visited_Quadrant), ]
sum_quad_avg2 <- sum_quad_avg
sum_quad_avg <- na.omit(sum_quad_avg)
#CO2
bp <- barplot(
  height = sum_quad_avg$Mean_CO2,
  names.arg = sum_quad_avg$Most_Visited_Quadrant,
  ylab = "Mean CO2",
  xlab = "Most Visited Quadrant",
  main = "Average CO2 by Quadrant",
  col = "skyblue",
  ylim = c(0, max(sum_quad_avg$Mean_CO2) + max(sum_quad_avg$SD_CO2) * 1.1)
)
arrows(
  x0 = bp,
  y0 = sum_quad_avg$Mean_CO2 - sum_quad_avg$SD_CO2,
  x1 = bp,
  y1 = sum_quad_avg$Mean_CO2 + sum_quad_avg$SD_CO2,
  angle = 90,
  code = 3,
  length = 0.1,
  col = "red"
)

text(
  x = bp,
  y = sum_quad_avg$Mean_CO2,
  labels = round(sum_quad_avg$Mean_CO2, 3),
  pos = 3,
  cex = 0.8
)
#CH4
bp <- barplot(
  height = sum_quad_avg$Mean_CH4,
  names.arg = sum_quad_avg$Most_Visited_Quadrant,
  ylab = "Mean CH4",
  xlab = "Most Visited Quadrant",
  main = "Average CH4 by Quadrant",
  col = "skyblue",
  ylim = c(0, max(sum_quad_avg$Mean_CH4) + max(sum_quad_avg$SD_CH4) * 1.1)
)
arrows(
  x0 = bp,
  y0 = sum_quad_avg$Mean_CH4 - sum_quad_avg$SD_CH4,
  x1 = bp,
  y1 = sum_quad_avg$Mean_CH4 + sum_quad_avg$SD_CH4,
  angle = 90,
  code = 3,
  length = 0.1,
  col = "red"
)
text(
  x = bp,
  y = sum_quad_avg$Mean_CH4,
  labels = round(sum_quad_avg$Mean_CH4, 3),
  pos = 3,
  cex = 0.8
)

#AVG CIRCLE___
#CO2
library(ggplot2)
library(dplyr)

df <- data.frame(
  direction = seq(0, 315, by = 45),
  magnitude = sum_quad_avg2$Mean_CO2,
  sd = sum_quad_avg2$SD_CO2,
  median = sum_quad_avg2$Median_CO2
)

error_scale_factor <- 10
my_colors <- c(
  "deepskyblue",
  "deepskyblue3",
  "deepskyblue4",
  "darkblue",
  "darkseagreen",
  "darkseagreen4",
  "darkolivegreen",
  "darkgreen"
)
ggplot(df, aes(
  x = direction,
  y = magnitude,
  fill = factor(direction)
)) +
  geom_col(width = 45) +
  geom_col(aes(y = median), width=15, col="black")+
  geom_errorbar(
    aes(
      ymin = magnitude - sd * error_scale_factor,
      ymax = magnitude + sd * error_scale_factor
    ),
    width = 5,
    color = "red"
  ) +
   geom_text(aes(label = paste0(round(magnitude, 3), " ± ", round(sd, 3))),
            position = position_stack(vjust = 0.5),
            size = 3, col="white") +
  geom_text(aes(label = paste("(",round(median, 3), ")")),
            position = position_stack(vjust = 0.8),
            size = 2.5, col="white") +
  coord_polar(start = 0, direction = 1) +
  scale_x_continuous(
    breaks = seq(0, 315, by = 45),
    labels = paste0(seq(0, 315, by = 45), "°"),
    limits = c(0, 360)
  ) +
  scale_fill_manual(values = my_colors, name = "Direction") +
  labs(title = "CO2 mean concentrations for Cruise #4",
       subtitle = "*(Standard deviation scaled by 10 for visibility)",
       caption = "* SD bars scaled visually") +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(size = 10),
    legend.position = "right"
  )

#CH4
library(ggplot2)
library(dplyr)

df <- data.frame(
  direction = seq(0, 315, by = 45),
  magnitude = sum_quad_avg2$Mean_CH4,
  sd = sum_quad_avg2$SD_CH4,
  median = sum_quad_avg2$Median_CH4
)

error_scale_factor <- 10
my_colors <- c(
  "deepskyblue",
  "deepskyblue3",
  "deepskyblue4",
  "darkblue",
  "darkseagreen",
  "darkseagreen4",
  "darkolivegreen",
  "darkgreen"
)
ggplot(df, aes(
  x = direction,
  y = magnitude,
  fill = factor(direction)
)) +
  geom_col(width = 45) +
  geom_col(aes(y = median), width=15, col="black")+
  geom_errorbar(
    aes(
      ymin = magnitude - sd * error_scale_factor,
      ymax = magnitude + sd * error_scale_factor
    ),
    width = 5,
    color = "red"
  ) +
  geom_text(aes(label = paste0(round(magnitude, 3), " ± ", round(sd, 3))),
            position = position_stack(vjust = 0.5),
            size = 3, col="white") +
  geom_text(aes(label = paste("(",round(median, 3), ")")),
            position = position_stack(vjust = 0.8),
            size = 2.5, col="white") +
  coord_polar(start = 0, direction = 1) +
  scale_x_continuous(
    breaks = seq(0, 315, by = 45),
    labels = paste0(seq(0, 315, by = 45), "°"),
    limits = c(0, 360)
  ) +
  scale_fill_manual(values = my_colors, name = "Direction") +
  labs(title = "CH4 mean concentrations for Cruise #4",
       subtitle = "*(Standard deviation scaled by 10 for visibility)",
       caption = "* SD bars scaled visually") +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(size = 10),
    legend.position = "right"
  )
