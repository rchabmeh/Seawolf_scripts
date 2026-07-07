##### LEW BOTH MONTHS#####

files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/twr",
  pattern = "merged_.*_LEW\\.csv$",
  full.names = TRUE
)
library(dplyr)
library(stringr)

# Read all files and store with "type" field
all_data <- lapply(files, function(f) {
  df <- read.csv(f)
  
  # extract type from file name
  type <- str_extract(basename(f), "(co2|ch4)")
  
  df$type <- type
  return(df)
})

all_data <- bind_rows(all_data)
all_data$datetime_utc <- ifelse(nchar(all_data$datetime_utc) == 10,
                        paste0(all_data$datetime_utc, " 00:00:00"),
                        all_data$datetime_utc)
all_data$datetime_utc <- as.POSIXct(all_data$datetime_utc, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

library(lubridate)
all_data$local_time <- with_tz(all_data$datetime_utc, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)
all_data$date_only <- as.Date(all_data$local_time)
all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16 &
                       format(all_data$date_only, "%m") %in% c("04", "10"), ]

all_data$CT_CO2 <- dplyr::coalesce(all_data$CT.NRT_co2.x,all_data$CT.NRT_co2)
all_data$CT_CH4 <- dplyr::coalesce(all_data$CT_ch4,all_data$CT_ch4.x)



LEW_co2       <- all_data %>% filter(type == "co2")
LEW_ch4   <- all_data %>% filter(type == "ch4")


library(ggplot2)
fit <- lm(CAMS_CH4 ~ ch4_ppb, data = LEW_ch4)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p1 <- ggplot(LEW_ch4, aes(
  x = ch4_ppb,
  y = CAMS_CH4,
  color = factor(format(as.Date(date_only), "%m"))
)) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CH4 (ppb)", y = "CAMs CH4") +
  annotate(
    "text",
    x = min(LEW_ch4$ch4_ppb),
    y = max(LEW_ch4$CAMS_CH4 - 50),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 


fit <- lm(CT_CH4 ~ ch4_ppb, data = LEW_ch4)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p2 <- ggplot(LEW_ch4, aes(
  x = ch4_ppb,
  y = CT_CH4,
  color = factor(format(as.Date(date_only), "%m"))
)) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CH4 (ppb)", y = "CT CH4") +
  annotate(
    "text",
    x = min(LEW_ch4$ch4_ppb),
    y = max(LEW_ch4$CT_CH4),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) + 
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 

fit <- lm(CAMS_CO2 ~ co2_ppm, data = LEW_co2)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p3 <- ggplot(LEW_co2, aes(
  x = co2_ppm,
  y = CAMS_CO2,
  color = factor(format(as.Date(date_only), "%m"))
)) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CO2 (ppm)", y = "CAMs CO2") +
  annotate(
    "text",
    x = min(LEW_co2$co2_ppm),
    y = max(LEW_co2$CAMS_CO2),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 

fit <- lm(CT_CO2 ~ co2_ppm, data = LEW_co2)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p4 <- ggplot(LEW_co2, aes(x = co2_ppm, y = CT_CO2, color = factor(format(as.Date(date_only), "%m")))) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CO2 (ppm)", y = "CT CO2") +
  annotate(
    "text",
    x = min(LEW_co2$co2_ppm),
    y = max(LEW_co2$CT_CO2 + 10),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 


ch4_x_lim <- range(c(LEW_ch4$ch4_ppb, LEW_ch4$CT_ch4.x, LEW_ch4$CAMS_CH4), na.rm = TRUE)

ch4_y_lim <- range(c(LEW_ch4$ch4_ppb, LEW_ch4$CT_ch4.x, LEW_ch4$CAMS_CH4), na.rm = TRUE)

co2_x_lim <- range(c(LEW_co2$co2_ppm, LEW_co2$CT.NRT_co2.x, LEW_co2$CAMS_CO2), na.rm = TRUE)

co2_y_lim <- range(c(LEW_co2$co2_ppm, LEW_co2$CT.NRT_co2.x, LEW_co2$CAMS_CO2), na.rm = TRUE)


p1 <- p1 +
  coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p2 <- p2 +
  coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p3 <- p3 +
  coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

p4 <- p4 +
  coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

library(cowplot)
four_panel <- plot_grid(p1, p2, p3, p4, ncol = 2)

four_panel_spaced <- four_panel +
  theme(plot.margin = margin(
    t = 25,
    r = 5,
    b = 5,
    l = 5
  ))

four_panel_titled <- ggdraw(four_panel_spaced) +
  draw_label(
    "Observed vs Modeled CO2 and CH4 at LEW",
    x = 0.5,
    y = 0.99,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 16
  ) +
  draw_label(
    "10:00-16:00 Local Time (2022-2023)",
    x = 0.5,
    y = 0.97,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 12
  ) +
  draw_label(
    "April and October Only",
    x = 0.48,
    y = 0.95,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 11
  )

four_panel_titled

##### LEW INDIVIDUAL MONTHS#####

library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(cowplot)

files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/twr_comp/",
  pattern = "merged_.*_LEW\\.csv$",
  full.names = TRUE
)

# Read all files and store with "type" field
all_data <- lapply(files, function(f) {
  
  df <- read.csv(f)
  
  type <- str_extract(
    basename(f),
    "(co2|ch4_ct|ch4_cams)"
  )
  
  df$type <- type
  
  return(df)
})

all_data <- bind_rows(all_data)

all_data$DATE <- ifelse(
  nchar(all_data$DATE) == 10,
  paste0(all_data$DATE, " 00:00:00"),
  all_data$DATE
)

all_data$DATE <- as.POSIXct(
  all_data$DATE,
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC"
)

all_data$local_time <- with_tz(
  all_data$DATE,
  tzone = "America/New_York"
)

all_data$hour <- hour(all_data$local_time)

all_data$date_only <- as.Date(all_data$local_time)

# Keep only 10:00–16:00 local time
all_data <- all_data[
  all_data$hour >= 10 &
    all_data$hour <= 16,
]


run_month <- function(month_num, month_name) {
  
  ##### SUBSET MONTH #####
  
  month_data <- all_data[
    format(all_data$date_only, "%m") == month_num,
  ]
  
  month_color <- ifelse(
    month_num == "04",
    "dodgerblue",
    "darkorange"
  )
  
  LEW_co2 <- month_data %>%
    filter(type == "co2")
  
  LEW_ch4_ct <- month_data %>%
    filter(type == "ch4_ct")
  
  LEW_ch4_cams <- month_data %>%
    filter(type == "ch4_cams")
  
  
  ##### MATCH CH4 TIMES #####
  
  common_times <- intersect(
    LEW_ch4_ct$DATE,
    LEW_ch4_cams$DATE
  )
  
  LEW_ch4_cams <- LEW_ch4_cams[
    LEW_ch4_cams$DATE %in% common_times,
  ]
  
  
  ##### P1 CAMS CH4 #####
  
  fit <- lm(
    CAMs_CH4 ~ Obs_CH4_ppb,
    data = LEW_ch4_cams
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p1 <- ggplot(
    LEW_ch4_cams,
    aes(
      x = Obs_CH4_ppb,
      y = CAMs_CH4
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CH4 (ppb)",
      y = "CAMs CH4"
    ) +
    annotate(
      "text",
      x = min(LEW_ch4_cams$Obs_CH4_ppb, na.rm = TRUE),
      y = max(LEW_ch4_cams$CAMs_CH4, na.rm = TRUE) + 10,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### P2 CT CH4 #####
  
  fit <- lm(
    CT_CH4 ~ Obs_CH4_ppb,
    data = LEW_ch4_ct
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p2 <- ggplot(
    LEW_ch4_ct,
    aes(
      x = Obs_CH4_ppb,
      y = CT_CH4
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CH4 (ppb)",
      y = "CT CH4"
    ) +
    annotate(
      "text",
      x = min(LEW_ch4_ct$Obs_CH4_ppb, na.rm = TRUE),
      y = max(LEW_ch4_ct$CT_CH4, na.rm = TRUE),
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### P3 CAMS CO2 #####
  
  fit <- lm(
    CAMs_CO2 ~ Obs_CO2_ppm,
    data = LEW_co2
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p3 <- ggplot(
    LEW_co2,
    aes(
      x = Obs_CO2_ppm,
      y = CAMs_CO2
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CO2 (ppm)",
      y = "CAMs CO2"
    ) +
    annotate(
      "text",
      x = min(LEW_co2$Obs_CO2_ppm, na.rm = TRUE),
      y = max(LEW_co2$CAMs_CO2, na.rm = TRUE),
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### P4 CT CO2 #####
  
  fit <- lm(
    CT_CO2 ~ Obs_CO2_ppm,
    data = LEW_co2
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p4 <- ggplot(
    LEW_co2,
    aes(
      x = Obs_CO2_ppm,
      y = CT_CO2
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CO2 (ppm)",
      y = "CT CO2"
    ) +
    annotate(
      "text",
      x = min(LEW_co2$Obs_CO2_ppm, na.rm = TRUE),
      y = max(LEW_co2$CT_CO2, na.rm = TRUE) + 5,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### MATCH AXES #####
  
  ch4_x_lim <- range(
    c(
      LEW_ch4_cams$Obs_CH4_ppb,
      LEW_ch4_ct$Obs_CH4_ppb
    ),
    na.rm = TRUE
  )
  
  ch4_y_lim <- range(
    c(
      LEW_ch4_cams$CAMs_CH4,
      LEW_ch4_ct$CT_CH4
    ),
    na.rm = TRUE
  )
  
  co2_x_lim <- range(
    LEW_co2$Obs_CO2_ppm,
    na.rm = TRUE
  )
  
  co2_y_lim <- range(
    c(
      LEW_co2$CAMs_CO2,
      LEW_co2$CT_CO2
    ),
    na.rm = TRUE
  )
  
  p1 <- p1 +
    coord_cartesian(
      xlim = ch4_x_lim,
      ylim = ch4_y_lim
    )
  
  p2 <- p2 +
    coord_cartesian(
      xlim = ch4_x_lim,
      ylim = ch4_y_lim
    )
  
  p3 <- p3 +
    coord_cartesian(
      xlim = co2_x_lim,
      ylim = co2_y_lim
    )
  
  p4 <- p4 +
    coord_cartesian(
      xlim = co2_x_lim,
      ylim = co2_y_lim
    )
  
  
  ##### COMBINE #####
  
  four_panel <- plot_grid(
    p1,
    p2,
    p3,
    p4,
    ncol = 2
  )
  
  four_panel_spaced <- four_panel +
    theme(
      plot.margin = margin(
        t = 25,
        r = 5,
        b = 5,
        l = 5
      )
    )
  
  four_panel_titled <- ggdraw(four_panel_spaced) +
    draw_label(
      paste0(
        "Observed vs Modeled CO2 and CH4 at LEW - ",
        month_name
      ),
      x = 0.5,
      y = 0.99,
      hjust = 0.5,
      vjust = 1,
      fontface = "bold",
      size = 16
    ) +
    draw_label(
      "10:00-16:00 Local Time (2022-2023)",
      x = 0.5,
      y = 0.97,
      hjust = 0.5,
      vjust = 1,
      fontface = "bold",
      size = 12
    )
  
  return(four_panel_titled)
}


##### RUN LEW INDIVIDUAL MONTHS#####

april_plot <- run_month(
  month_num = "04",
  month_name = "April"
)

october_plot <- run_month(
  month_num = "10",
  month_name = "October"
)

april_plot
october_plot
##### WNJ BOTH MONTHS #####
files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/twr",
  pattern = "merged_.*_WNJ\\.csv$",
  full.names = TRUE
)
library(dplyr)
library(stringr)

# Read all files and store with "type" field
all_data <- lapply(files, function(f) {
  df <- read.csv(f)
  
  # extract type from file name
  type <- str_extract(basename(f), "(co2|ch4)")
  
  df$type <- type
  return(df)
})

all_data <- bind_rows(all_data)
all_data$datetime_utc <- ifelse(nchar(all_data$datetime_utc) == 10,
                                paste0(all_data$datetime_utc, " 00:00:00"),
                                all_data$datetime_utc)
all_data$datetime_utc <- as.POSIXct(all_data$datetime_utc, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

library(lubridate)
all_data$local_time <- with_tz(all_data$datetime_utc, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)
all_data$date_only <- as.Date(all_data$local_time)
all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16 &
                       format(all_data$date_only, "%m") %in% c("04", "10"), ]

all_data$CT_CO2 <- dplyr::coalesce(all_data$CT.NRT_co2.x,all_data$CT.NRT_co2)
all_data$CT_CH4 <- dplyr::coalesce(all_data$CT_ch4,all_data$CT_ch4.x)



LEW_co2       <- all_data %>% filter(type == "co2")
LEW_ch4   <- all_data %>% filter(type == "ch4")


library(ggplot2)
fit <- lm(CAMS_CH4 ~ ch4_ppb, data = LEW_ch4)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p1 <- ggplot(LEW_ch4, aes(
  x = ch4_ppb,
  y = CAMS_CH4,
  color = factor(format(as.Date(date_only), "%m"))
)) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CH4 (ppb)", y = "CAMs CH4") +
  annotate(
    "text",
    x = min(LEW_ch4$ch4_ppb),
    y = max(LEW_ch4$CAMS_CH4- 100),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 

fit <- lm(CT_CH4 ~ ch4_ppb, data = LEW_ch4)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p2 <- ggplot(LEW_ch4, aes(
  x = ch4_ppb,
  y = CT_CH4,
  color = factor(format(as.Date(date_only), "%m"))
)) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CH4 (ppb)", y = "CT CH4") +
  annotate(
    "text",
    x = min(LEW_ch4$ch4_ppb),
    y = max(LEW_ch4$CT_CH4 + 25),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 

fit <- lm(CAMS_CO2 ~ co2_ppm, data = LEW_co2)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p3 <- ggplot(LEW_co2, aes(
  x = co2_ppm,
  y = CAMS_CO2,
  color = factor(format(as.Date(date_only), "%m"))
)) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CO2 (ppm)", y = "CAMs CO2") +
  annotate(
    "text",
    x = min(LEW_co2$co2_ppm),
    y = max(LEW_co2$CAMS_CO2 + 5),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 

fit <- lm(CT_CO2 ~ co2_ppm, data = LEW_co2)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p4 <- ggplot(LEW_co2, aes(x = co2_ppm, y = CT_CO2, color = factor(format(as.Date(date_only), "%m")))) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = FALSE,
    linewidth = 1
  ) +
  scale_color_manual(
    values = c("04" = "dodgerblue", "10" = "darkorange"),
    labels = c("04" = "April", "10" = "October"),
    name = "Month"
  ) +
  labs(x = "Observed CO2 (ppm)", y = "CT CO2") +
  annotate(
    "text",
    x = min(LEW_co2$co2_ppm),
    y = max(LEW_co2$CT_CO2 + 10),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  ) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x  = element_text(size = 16),
    axis.text.y  = element_text(size = 16)
  ) 


ch4_x_lim <- range(c(LEW_ch4$ch4_ppb, LEW_ch4$CT_ch4.x, LEW_ch4$CAMS_CH4), na.rm = TRUE)

ch4_y_lim <- range(c(LEW_ch4$ch4_ppb, LEW_ch4$CT_ch4.x, LEW_ch4$CAMS_CH4), na.rm = TRUE)

co2_x_lim <- range(c(LEW_co2$co2_ppm, LEW_co2$CT.NRT_co2.x, LEW_co2$CAMS_CO2), na.rm = TRUE)

co2_y_lim <- range(c(LEW_co2$co2_ppm, LEW_co2$CT.NRT_co2.x, LEW_co2$CAMS_CO2), na.rm = TRUE)

p1 <- p1 +
  coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p2 <- p2 +
  coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p3 <- p3 +
  coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

p4 <- p4 +
  coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

library(cowplot)
four_panel <- plot_grid(p1, p2, p3, p4, ncol = 2)

four_panel_spaced <- four_panel +
  theme(plot.margin = margin(
    t = 25,
    r = 5,
    b = 5,
    l = 5
  ))

four_panel_titled <- ggdraw(four_panel_spaced) +
  draw_label(
    "Observed vs Modeled CO2 and CH4 at WNJ",
    x = 0.5,
    y = 0.99,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 16
  ) +
  draw_label(
    "10:00-16:00 Local Time (2022-2023)",
    x = 0.5,
    y = 0.97,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 12
  ) +
  draw_label(
    "April and October Only",
    x = 0.48,
    y = 0.95,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 11
  )

four_panel_titled

##### WNJ INDIVIDUAL MONTHS #####

library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(cowplot)

files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/twr_comp/",
  pattern = "merged_.*_WNJ\\.csv$",
  full.names = TRUE
)

# Read all files and store with "type" field
all_data <- lapply(files, function(f) {
  
  df <- read.csv(f)
  
  type <- str_extract(
    basename(f),
    "(co2|ch4_ct|ch4_cams)"
  )
  
  df$type <- type
  
  return(df)
})

all_data <- bind_rows(all_data)

all_data$DATE <- ifelse(
  nchar(all_data$DATE) == 10,
  paste0(all_data$DATE, " 00:00:00"),
  all_data$DATE
)

all_data$DATE <- as.POSIXct(
  all_data$DATE,
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC"
)

all_data$local_time <- with_tz(
  all_data$DATE,
  tzone = "America/New_York"
)

all_data$hour <- hour(all_data$local_time)

all_data$date_only <- as.Date(all_data$local_time)

# Keep only 10:00–16:00 local time
all_data <- all_data[
  all_data$hour >= 10 &
    all_data$hour <= 16,
]


run_month <- function(month_num, month_name) {
  
  ##### SUBSET MONTH #####
  
  month_data <- all_data[
    format(all_data$date_only, "%m") == month_num,
  ]
  
  month_color <- ifelse(
    month_num == "04",
    "dodgerblue",
    "darkorange"
  )
  
  WNJ_co2 <- month_data %>%
    filter(type == "co2")
  
  WNJ_ch4_ct <- month_data %>%
    filter(type == "ch4_ct")
  
  WNJ_ch4_cams <- month_data %>%
    filter(type == "ch4_cams")
  
  
  ##### MATCH CH4 TIMES #####
  
  common_times <- intersect(
    WNJ_ch4_ct$DATE,
    WNJ_ch4_cams$DATE
  )
  
  WNJ_ch4_cams <- WNJ_ch4_cams[
    WNJ_ch4_cams$DATE %in% common_times,
  ]
  
  
  ##### P1 CAMS CH4 #####
  
  fit <- lm(
    CAMs_CH4 ~ Obs_CH4_ppb,
    data = WNJ_ch4_cams
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p1 <- ggplot(
    WNJ_ch4_cams,
    aes(
      x = Obs_CH4_ppb,
      y = CAMs_CH4
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CH4 (ppb)",
      y = "CAMs CH4"
    ) +
    annotate(
      "text",
      x = min(WNJ_ch4_cams$Obs_CH4_ppb, na.rm = TRUE),
      y = max(WNJ_ch4_cams$CAMs_CH4, na.rm = TRUE) ,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### P2 CT CH4 #####
  
  fit <- lm(
    CT_CH4 ~ Obs_CH4_ppb,
    data = WNJ_ch4_ct
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p2 <- ggplot(
    WNJ_ch4_ct,
    aes(
      x = Obs_CH4_ppb,
      y = CT_CH4
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CH4 (ppb)",
      y = "CT CH4"
    ) +
    annotate(
      "text",
      x = min(WNJ_ch4_ct$Obs_CH4_ppb, na.rm = TRUE),
      y = max(WNJ_ch4_ct$CT_CH4, na.rm = TRUE),
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### P3 CAMS CO2 #####
  
  fit <- lm(
    CAMs_CO2 ~ Obs_CO2_ppm,
    data = WNJ_co2
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p3 <- ggplot(
    WNJ_co2,
    aes(
      x = Obs_CO2_ppm,
      y = CAMs_CO2
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CO2 (ppm)",
      y = "CAMs CO2"
    ) +
    annotate(
      "text",
      x = min(WNJ_co2$Obs_CO2_ppm, na.rm = TRUE),
      y = max(WNJ_co2$CAMs_CO2, na.rm = TRUE),
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### P4 CT CO2 #####
  
  fit <- lm(
    CT_CO2 ~ Obs_CO2_ppm,
    data = WNJ_co2
  )
  
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0(
    "R² = ",
    round(summary_fit$r.squared, 3)
  )
  
  p4 <- ggplot(
    WNJ_co2,
    aes(
      x = Obs_CO2_ppm,
      y = CT_CO2
    )
  ) +
    geom_point(
      color = month_color,
      size = 3
    ) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(
      x = "Observed CO2 (ppm)",
      y = "CT CO2"
    ) +
    annotate(
      "text",
      x = min(WNJ_co2$Obs_CO2_ppm, na.rm = TRUE),
      y = max(WNJ_co2$CT_CO2, na.rm = TRUE) + 5,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
    )
  
  
  ##### MATCH AXES #####
  
  ch4_x_lim <- range(
    c(
      WNJ_ch4_cams$Obs_CH4_ppb,
      WNJ_ch4_ct$Obs_CH4_ppb
    ),
    na.rm = TRUE
  )
  
  ch4_y_lim <- range(
    c(
      WNJ_ch4_cams$CAMs_CH4,
      WNJ_ch4_ct$CT_CH4
    ),
    na.rm = TRUE
  )
  
  co2_x_lim <- range(
    WNJ_co2$Obs_CO2_ppm,
    na.rm = TRUE
  )
  
  co2_y_lim <- range(
    c(
      WNJ_co2$CAMs_CO2,
      WNJ_co2$CT_CO2
    ),
    na.rm = TRUE
  )
  
  p1 <- p1 +
    coord_cartesian(
      xlim = ch4_x_lim,
      ylim = ch4_y_lim
    )
  
  p2 <- p2 +
    coord_cartesian(
      xlim = ch4_x_lim,
      ylim = ch4_y_lim
    )
  
  p3 <- p3 +
    coord_cartesian(
      xlim = co2_x_lim,
      ylim = co2_y_lim
    )
  
  p4 <- p4 +
    coord_cartesian(
      xlim = co2_x_lim,
      ylim = co2_y_lim
    )
  
  
  ##### COMBINE #####
  
  four_panel <- plot_grid(
    p1,
    p2,
    p3,
    p4,
    ncol = 2
  )
  
  four_panel_spaced <- four_panel +
    theme(
      plot.margin = margin(
        t = 25,
        r = 5,
        b = 5,
        l = 5
      )
    )
  
  four_panel_titled <- ggdraw(four_panel_spaced) +
    draw_label(
      paste0(
        "Observed vs Modeled CO2 and CH4 at WNJ - ",
        month_name
      ),
      x = 0.5,
      y = 0.99,
      hjust = 0.5,
      vjust = 1,
      fontface = "bold",
      size = 16
    ) +
    draw_label(
      "10:00-16:00 Local Time (2022-2023)",
      x = 0.5,
      y = 0.97,
      hjust = 0.5,
      vjust = 1,
      fontface = "bold",
      size = 12
    )
  
  return(four_panel_titled)
}


##### RUN WNJ INDIVIDUAL MONTHS #####

april_plot <- run_month(
  month_num = "04",
  month_name = "April"
)

october_plot <- run_month(
  month_num = "10",
  month_name = "October"
)

april_plot
october_plot
##### SHIP #####
cruise_4 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/c4_alt_models_5min_daylight.csv")
cruise_4$date <- as.POSIXct(cruise_4$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

#cruise_13 <- read.csv("/Volumes/Seagate/cruise13_eulerian/all_models_merged_cruise13.csv")
cruise_14 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/c14_alt_models_5min_daylight.csv")
cruise_14$date <- as.POSIXct(cruise_14$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
cruise_14$date <- cruise_14$date -120
#cruise_19 <- read.csv("/Volumes/Seagate/cruise19_eulerian/all_models_merged_cruise19.csv")
cruise_24 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_5min_daylight.csv")
cruise_24$date <- as.POSIXct(cruise_24$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
cruise_24$date <- cruise_24$date -60


cruises <- list(
  c4  = cruise_4,
  #c13 = cruise_13,
  c14 = cruise_14,
  #c19 = cruise_19,
  c24 = cruise_24
)
for (nm in names(cruises)) {
  cr <- cruises[[nm]]
  
  # CO2
  co2_df <- data.frame(
    DATE_UTC = cr$date,
    OBS      = cr$CO2_dry_cal_moving_day,
    CT       = cr$CT_CO2_tile,
    CAMS     = cr$CAMS_CO2
  )
  
  co2_df <- na.omit(co2_df)
  assign(paste0(nm, "_co2"), co2_df)
  
  # CH4
  ch4_df <- data.frame(
    DATE_UTC = cr$date,
    OBS      = cr$CH4_dry_cal_moving_day ,
    CT       = cr$CT_CH4_tile,
    CAMS     = cr$CAMS_CH4
  )
  
  ch4_df <- na.omit(ch4_df)
  assign(paste0(nm, "_ch4"), ch4_df)
}

dfs <- c()
for (nm in names(cruises)) {
  dfs <- c(dfs, paste0(nm, "_ch4"), paste0(nm, "_co2"))
}

for (df_name in dfs) {
  df <- get(df_name)
  df$DATE_UTC <- ifelse(nchar(df$DATE_UTC) == 10,
                        paste0(df$DATE_UTC, " 00:00:00"),
                        df$DATE_UTC)
  df$DATE_UTC <- as.POSIXct(df$DATE_UTC, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  assign(df_name, df)
}

for (df_name in dfs) {
  df <- get(df_name)
  df$DATE_NY_AMERICA <- as.POSIXct(format(df$DATE_UTC, tz = "America/New_York", usetz = TRUE), tz = "America/New_York")
  
  assign(df_name, df)
}

remove_hours <- c(23, 20, 2, 5, 8)

for (df_name in dfs) {
  df <- get(df_name)
  
  keep <- !as.integer(format(df$DATE_NY_AMERICA, "%H")) %in% remove_hours
  df <- df[keep, ]
  
  assign(df_name, df)
}

ch4_dfs <- c("c4_ch4", "c14_ch4", "c24_ch4")
co2_dfs <- c("c4_co2", "c14_co2", "c24_co2")

add_source <- function(df, name) {
  df$source <- name
  df
}

ch4_all <- do.call(rbind, Map(add_source, lapply(ch4_dfs, get), ch4_dfs))

co2_all <- do.call(rbind, Map(add_source, lapply(co2_dfs, get), co2_dfs))


## plotting ##
make_lm_plot <- function(df, xvar, yvar, xlab, ylab, y_offset = 1) {
  fit <- lm(df[[yvar]] ~ df[[xvar]])
  summary_fit <- summary(fit)
  
  eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
  
  r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))
  x_rng <- range(df[[xvar]], na.rm = TRUE)
  y_rng <- range(df[[yvar]], na.rm = TRUE)
  
  ggplot(df, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_point(color = "grey4", size = 3) +
    geom_smooth(
      method = "lm",
      color = "red",
      se = FALSE,
      linewidth = 1
    ) +
    labs(x = xlab, y = ylab) +
  annotate(
    "text",
    x = x_rng[2] - 0.03 * diff(x_rng),
    y = y_rng[2] - 0.03 * diff(y_rng),
    label = paste(eq, r2, sep = "\n"),
    hjust = 1,
    vjust = 1,
    size = 4
  )
}

p1 <- make_lm_plot(
  ch4_all,
  xvar = "OBS",
  yvar = "CAMS",
  xlab = "Observed CH4 (ppb)",
  ylab = "CAMS CH4"
)

p2 <- make_lm_plot(
  ch4_all,
  xvar = "OBS",
  yvar = "CT",
  xlab = "Observed CH4 (ppb)",
  ylab = "CT CH4"
)



p3 <- make_lm_plot(
  co2_all,
  xvar = "OBS",
  yvar = "CAMS",
  xlab = "Observed CO2 (ppm)",
  ylab = "CAMS CO2"
)

p4 <- make_lm_plot(
  co2_all,
  xvar = "OBS",
  yvar = "CT",
  xlab = "Observed CO2 (ppm)",
  ylab = "CT CO2"
)

# CH4 limits
ch4_x_lim <- range(ch4_all$OBS, na.rm = TRUE)
ch4_y_lim <- range(c(ch4_all$CAMS, ch4_all$CT), na.rm = TRUE)

# CO2 limits
co2_x_lim <- range(co2_all$OBS, na.rm = TRUE)
co2_y_lim <- range(c(co2_all$CAMS, co2_all$CT), na.rm = TRUE)

p1 <- p1 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)
p2 <- p2 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)
p3 <- p3 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)
p4 <- p4 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)


library(cowplot)

four_panel <- plot_grid(p1, p2, p3, p4, ncol = 2)


four_panel_titled <- ggdraw(four_panel) +
  draw_label(
    "Observed vs Modeled CO2 and CH4 at Ship",
    x = 0.7,
    y = 0.99,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 16
  ) +
  draw_label(
    "10:00-16:00 Local Time (C4, C14, C24)",
    x = 0.7,
    y = 0.97,
    hjust = 0.5,
    vjust = 1,
    fontface = "bold",
    size = 12
  ) 
four_panel_titled