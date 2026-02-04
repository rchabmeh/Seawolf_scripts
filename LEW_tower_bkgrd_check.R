##### LEW #####

files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/twr_comp/",
  pattern = "merged_.*_LEW\\.csv$",
  full.names = TRUE
)
library(dplyr)
library(stringr)

# Read all files and store with "type" field
all_data <- lapply(files, function(f) {
  df <- read.csv(f)
  
  # extract type from file name
  type <- str_extract(basename(f), "(co2|ch4_ct|ch4_cams)")
  
  df$type <- type
  return(df)
})

all_data <- bind_rows(all_data)
all_data$DATE <- ifelse(
  nchar(all_data$DATE) == 10,
  paste0(all_data$DATE, " 00:00:00"),
  all_data$DATE
)
all_data$DATE <- as.POSIXct(all_data$DATE,
                      format = "%Y-%m-%d %H:%M:%S",
                      tz = "UTC")

library(lubridate)
all_data$local_time <- with_tz(all_data$DATE, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)
all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16, ]

LEW_co2       <- all_data %>% filter(type == "co2")
LEW_ch4_ct    <- all_data %>% filter(type == "ch4_ct")
LEW_ch4_cams  <- all_data %>% filter(type == "ch4_cams")


library(ggplot2)
fit <- lm(CAMs_CH4 ~ Obs_CH4_ppb, data = LEW_ch4_cams)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p1 <- ggplot(LEW_ch4_cams, aes(x = Obs_CH4_ppb, y = CAMs_CH4)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CH4 (ppb)", y = "CAMs CH4") +
  annotate("text", x = min(LEW_ch4_cams$Obs_CH4_ppb), 
           y = max(LEW_ch4_cams$CAMs_CH4), 
           label = paste(eq, r2, sep = ", "), hjust = 0, vjust = 1.2)

fit <- lm(CT_CH4 ~ Obs_CH4_ppb, data = LEW_ch4_ct)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p2 <- ggplot(LEW_ch4_ct, aes(x = Obs_CH4_ppb, y = CT_CH4)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CH4 (ppb)", y = "CT CH4") +
  annotate("text", x = min(LEW_ch4_ct$Obs_CH4_ppb), 
           y = max(LEW_ch4_ct$CT_CH4 +25), 
           label = paste(eq, r2, sep = ", "), hjust = 0, vjust = 1.2)

fit <- lm(CAMs_CO2 ~ Obs_CO2_ppm, data = LEW_co2)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p3 <- ggplot(LEW_co2, aes(x = Obs_CO2_ppm, y = CAMs_CO2)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CO2 (ppm)", y = "CAMs CO2") +
  annotate("text", x = min(LEW_co2$Obs_CO2_ppm), 
           y = max(LEW_co2$CAMs_CO2), 
           label = paste(eq, r2, sep = ", "), hjust = 0, vjust = 1.2)

fit <- lm(CT_CO2 ~ Obs_CO2_ppm, data = LEW_co2)
summary_fit <- summary(fit)
eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p4 <- ggplot(LEW_co2, aes(x = Obs_CO2_ppm, y = CT_CO2)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CO2 (ppm)", y = "CT CO2") +
  annotate("text", x = min(LEW_co2$Obs_CO2_ppm), 
           y = max(LEW_co2$CT_CO2 + 20), 
           label = paste(eq, r2, sep = ", "), hjust = 0, vjust = 1.2)


ch4_x_lim <- range(
  c(LEW_ch4_cams$Obs_CH4_ppb, LEW_ch4_ct$Obs_CH4_ppb),
  na.rm = TRUE
)

ch4_y_lim <- range(
  c(LEW_ch4_cams$CAMs_CH4, LEW_ch4_ct$CT_CH4),
  na.rm = TRUE
)
co2_x_lim <- range(LEW_co2$Obs_CO2_ppm, na.rm = TRUE)

co2_y_lim <- range(
  c(LEW_co2$CAMs_CO2, LEW_co2$CT_CO2),
  na.rm = TRUE
)

p1 <- p1 +
  coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p2 <- p2 +
  coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)

p3 <- p3 +
  coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

p4 <- p4 +
  coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

library(cowplot)
four_panel <- plot_grid(
  p1, p2, p3, p4,
  ncol = 2
)

four_panel

##### WNJ #####
files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/twr_comp/",
  pattern = "merged_.*_WNJ\\.csv$",
  full.names = TRUE
)

library(dplyr)
library(stringr)

all_data <- lapply(files, function(f) {
  df <- read.csv(f)
  
  type <- str_extract(basename(f), "(co2|ch4_ct|ch4_cams)")
  
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

library(lubridate)
all_data$local_time <- with_tz(all_data$DATE, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)

all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16, ]

WNJ_co2       <- all_data %>% filter(type == "co2")
WNJ_ch4_ct    <- all_data %>% filter(type == "ch4_ct")
WNJ_ch4_cams  <- all_data %>% filter(type == "ch4_cams")

library(ggplot2)

fit <- lm(CAMs_CH4 ~ Obs_CH4_ppb, data = WNJ_ch4_cams)
summary_fit <- summary(fit)

eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p1 <- ggplot(WNJ_ch4_cams, aes(x = Obs_CH4_ppb, y = CAMs_CH4)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CH4 (ppb)", y = "CAMs CH4") +
  annotate(
    "text",
    x = min(WNJ_ch4_cams$Obs_CH4_ppb),
    y = max(WNJ_ch4_cams$CAMs_CH4 +25),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  )

fit <- lm(CT_CH4 ~ Obs_CH4_ppb, data = WNJ_ch4_ct)
summary_fit <- summary(fit)

eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p2 <- ggplot(WNJ_ch4_ct, aes(x = Obs_CH4_ppb, y = CT_CH4)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CH4 (ppb)", y = "CT CH4") +
  annotate(
    "text",
    x = min(WNJ_ch4_ct$Obs_CH4_ppb),
    y = max(WNJ_ch4_ct$CT_CH4),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  )

fit <- lm(CAMs_CO2 ~ Obs_CO2_ppm, data = WNJ_co2)
summary_fit <- summary(fit)

eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p3 <- ggplot(WNJ_co2, aes(x = Obs_CO2_ppm, y = CAMs_CO2)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CO2 (ppm)", y = "CAMs CO2") +
  annotate(
    "text",
    x = min(WNJ_co2$Obs_CO2_ppm),
    y = max(WNJ_co2$CAMs_CO2),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  )

fit <- lm(CT_CO2 ~ Obs_CO2_ppm, data = WNJ_co2)
summary_fit <- summary(fit)

eq <- paste0("y = ", round(coef(fit)[2], 3), "x + ", round(coef(fit)[1], 1))
r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))

p4 <- ggplot(WNJ_co2, aes(x = Obs_CO2_ppm, y = CT_CO2)) +
  geom_point(color = "grey4", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
  labs(x = "Observed CO2 (ppm)", y = "CT CO2") +
  annotate(
    "text",
    x = min(WNJ_co2$Obs_CO2_ppm),
    y = max(WNJ_co2$CT_CO2 + 20),
    label = paste(eq, r2, sep = ", "),
    hjust = 0,
    vjust = 1.2
  )

ch4_x_lim <- range(
  c(WNJ_ch4_cams$Obs_CH4_ppb, WNJ_ch4_ct$Obs_CH4_ppb),
  na.rm = TRUE
)

ch4_y_lim <- range(
  c(WNJ_ch4_cams$CAMs_CH4, WNJ_ch4_ct$CT_CH4),
  na.rm = TRUE
)

co2_x_lim <- range(WNJ_co2$Obs_CO2_ppm, na.rm = TRUE)

co2_y_lim <- range(
  c(WNJ_co2$CAMs_CO2, WNJ_co2$CT_CO2),
  na.rm = TRUE
)

p1 <- p1 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)
p2 <- p2 + coord_cartesian(xlim = ch4_x_lim, ylim = ch4_y_lim)
p3 <- p3 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)
p4 <- p4 + coord_cartesian(xlim = co2_x_lim, ylim = co2_y_lim)

library(cowplot)

four_panel <- plot_grid(
  p1, p2, p3, p4,
  ncol = 2
)
four_panel
##### SHIP #####
cruise_4 <- read.csv("/Volumes/Seagate/cruise4_eulerian/all_models_merged_cruise4.csv")
cruise_13 <- read.csv("/Volumes/Seagate/cruise13_eulerian/all_models_merged_cruise13.csv")
cruise_14 <- read.csv("/Volumes/Seagate/cruise14_eulerian/all_models_merged_cruise14.csv")
cruise_19 <- read.csv("/Volumes/Seagate/cruise19_eulerian/all_models_merged_cruise19.csv")
cruise_24 <- read.csv("/Volumes/Seagate/cruise24_eulerian/all_models_merged_cruise24.csv")
 
cruises <- list(
  c4  = cruise_4,
  c13 = cruise_13,
  c14 = cruise_14,
  c19 = cruise_19,
  c24 = cruise_24
)
for (nm in names(cruises)) {
  
  cr <- cruises[[nm]]
  
  # CO2
  co2_df <- data.frame(
    DATE_UTC = cr$date,
    OBS      = cr$ship_co2_obs,
    CT       = cr$ship_co2_ct,
    CAMS     = cr$ship_co2_cams
  )
  
  co2_df <- na.omit(co2_df)
  assign(paste0(nm, "_co2"), co2_df)
  
  # CH4
  ch4_df <- data.frame(
    DATE_UTC = cr$date,
    OBS      = cr$ship_ch4_cams.x,
    CT       = cr$ship_ch4_ct,
    CAMS     = cr$ship_ch4_cams.y
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
  df$DATE_UTC <- ifelse(
    nchar(df$DATE_UTC) == 10,
    paste0(df$DATE_UTC, " 00:00:00"),
    df$DATE_UTC
  )
  df$DATE_UTC <- as.POSIXct(
    df$DATE_UTC,
    format = "%Y-%m-%d %H:%M:%S",
    tz = "UTC"
  )
  assign(df_name, df)
}

for (df_name in dfs) {
  df <- get(df_name)
    df$DATE_NY_AMERICA <- as.POSIXct(
    format(df$DATE_UTC, tz = "America/New_York", usetz = TRUE),
    tz = "America/New_York"
  )
  
  assign(df_name, df)
}

remove_hours <- c(23,20,2,5,8)

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

ch4_all <- do.call(
  rbind,
  Map(add_source, lapply(ch4_dfs, get), ch4_dfs)
)

co2_all <- do.call(
  rbind,
  Map(add_source, lapply(co2_dfs, get), co2_dfs)
)


## plotting ##
make_lm_plot <- function(df, xvar, yvar, xlab, ylab, y_offset = 0) {
  
  fit <- lm(df[[yvar]] ~ df[[xvar]])
  summary_fit <- summary(fit)
  
  eq <- paste0(
    "y = ",
    round(coef(fit)[2], 3),
    "x + ",
    round(coef(fit)[1], 1)
  )
  
  r2 <- paste0("R² = ", round(summary_fit$r.squared, 3))
  
  ggplot(df, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_point(color = "grey4", size = 3) +
    geom_smooth(method = "lm", color = "red", se = FALSE, linewidth = 1) +
    labs(x = xlab, y = ylab) +
    annotate(
      "text",
      x = min(df[[xvar]], na.rm = TRUE),
      y = max(df[[yvar]], na.rm = TRUE) + y_offset,
      label = paste(eq, r2, sep = ", "),
      hjust = 0,
      vjust = 1.2
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

four_panel <- plot_grid(
  p1, p2, p3, p4,
  ncol = 2
)

four_panel










