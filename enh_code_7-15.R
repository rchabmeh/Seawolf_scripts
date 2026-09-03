##### 1.LOADING IN TOWER INFORMATION--------------------------------------- ####
##### WNJ BOTH MONTHS#####
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
all_data$datetime_utc <- ifelse(
  nchar(all_data$datetime_utc) == 10,
  paste0(all_data$datetime_utc, " 00:00:00"),
  all_data$datetime_utc
)
all_data$datetime_utc <- as.POSIXct(all_data$datetime_utc, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

library(lubridate)
all_data$local_time <- with_tz(all_data$datetime_utc, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)
all_data$date_only <- as.Date(all_data$local_time)
all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16 &
                       format(all_data$date_only, "%m") %in% c("04", "10"), ]

all_data$CT_CO2 <- dplyr::coalesce(all_data$CT.NRT_co2.x, all_data$CT.NRT_co2)
all_data$CT_CH4 <- dplyr::coalesce(all_data$CT_ch4, all_data$CT_ch4.x)



WNJ_co2       <- all_data %>% filter(type == "co2")
WNJ_ch4   <- all_data %>% filter(type == "ch4")

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
all_data$datetime_utc <- ifelse(
  nchar(all_data$datetime_utc) == 10,
  paste0(all_data$datetime_utc, " 00:00:00"),
  all_data$datetime_utc
)
all_data$datetime_utc <- as.POSIXct(all_data$datetime_utc, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

library(lubridate)
all_data$local_time <- with_tz(all_data$datetime_utc, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)
all_data$date_only <- as.Date(all_data$local_time)
all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16 &
                       format(all_data$date_only, "%m") %in% c("04", "10"), ]

all_data$CT_CO2 <- dplyr::coalesce(all_data$CT.NRT_co2.x, all_data$CT.NRT_co2)
all_data$CT_CH4 <- dplyr::coalesce(all_data$CT_ch4, all_data$CT_ch4.x)



LEW_co2       <- all_data %>% filter(type == "co2")
LEW_ch4   <- all_data %>% filter(type == "ch4")

##### TMD BOTH MONTHS#####
files <- list.files(
  "/Users/reneechabot-mehlin/Desktop/model_plotting/twr",
  pattern = "merged_.*_TMD\\.csv$",
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
all_data$datetime_utc <- ifelse(
  nchar(all_data$datetime_utc) == 10,
  paste0(all_data$datetime_utc, " 00:00:00"),
  all_data$datetime_utc
)
all_data$datetime_utc <- as.POSIXct(all_data$datetime_utc, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

library(lubridate)
all_data$local_time <- with_tz(all_data$datetime_utc, tzone = "America/New_York")
all_data$hour <- hour(all_data$local_time)
all_data$date_only <- as.Date(all_data$local_time)
all_data <- all_data[all_data$hour >= 10 & all_data$hour <= 16 &
                       format(all_data$date_only, "%m") %in% c("04", "10"), ]

all_data$CT_CO2 <- dplyr::coalesce(all_data$CT.NRT_co2.x, all_data$CT.NRT_co2)
all_data$CT_CH4 <- dplyr::coalesce(all_data$CT_ch4, all_data$CT_ch4.x)



TMD_co2       <- all_data %>% filter(type == "co2")
TMD_ch4   <- all_data %>% filter(type == "ch4")

##### ENHANCEMENTS #####
WNJ_enh_obs <- data.frame(
  LEW_CO2_ppm = (WNJ_co2$co2_ppm - LEW_co2$co2_ppm),
  LEW_CH4_ppb = (WNJ_ch4$ch4_ppb - LEW_ch4$ch4_ppb),
 TMD_CO2_ppm = (WNJ_co2$co2_ppm - TMD_co2$co2_ppm),
 TMD_CH4_ppb = (WNJ_ch4$ch4_ppb - TMD_ch4$ch4_ppb)
)

WNJ_enh_CT <- data.frame(
  LEW_CO2_ppm = (WNJ_co2$CT_CO2 - LEW_co2$CT_CO2),
  LEW_CH4_ppb = (WNJ_ch4$CT_CH4 - LEW_ch4$CT_CH4),
 TMD_CO2_ppm = (WNJ_co2$CT_CO2- TMD_co2$CT_CO2),
 TMD_CH4_ppb = (WNJ_ch4$CT_CH4 - TMD_ch4$CT_CH4)
)

WNJ_enh_CAMS <- data.frame(
  LEW_CO2_ppm = (WNJ_co2$CAMS_CO2 - LEW_co2$CAMS_CO2),
  LEW_CH4_ppb = (WNJ_ch4$CAMS_CH4 - LEW_ch4$CAMS_CH4),
  TMD_CO2_ppm = (WNJ_co2$CAMS_CO2 - TMD_co2$CAMS_CO2),
  TMD_CH4_ppb = (WNJ_ch4$CAMS_CH4 - TMD_ch4$CAMS_CH4)
  )

## sort by date ??
lew_co2_enh <- data.frame(
  Date = WNJ_co2$datetime_utc,
  OBS = WNJ_enh_obs$LEW_CO2_ppm,
  CT = WNJ_enh_CT$LEW_CO2_ppm,
  CAMS = WNJ_enh_CAMS$LEW_CO2_ppm
)

lew_co2_enh <- lew_co2_enh[grepl("^2023-10|^2022-04", lew_co2_enh$Date), ]

lew_ch4_enh <- data.frame(
  Date = WNJ_ch4$datetime_utc,
  OBS = WNJ_enh_obs$LEW_CH4_ppb,
  CT = WNJ_enh_CT$LEW_CH4_ppb,
  CAMS = WNJ_enh_CAMS$LEW_CH4_ppb
)

lew_ch4_enh <- lew_ch4_enh[grepl("^2023-10|^2022-04", lew_ch4_enh$Date), ]

tmd_co2_enh <- data.frame(
  Date = WNJ_co2$datetime_utc,
  OBS = WNJ_enh_obs$TMD_CO2_ppm,
  CT = WNJ_enh_CT$TMD_CO2_ppm,
  CAMS = WNJ_enh_CAMS$TMD_CO2_ppm
)

tmd_co2_enh <- tmd_co2_enh[grepl("^2022-10", tmd_co2_enh$Date), ]

tmd_ch4_enh <- data.frame(
  Date = WNJ_ch4$datetime_utc,
  OBS = WNJ_enh_obs$TMD_CH4_ppb,
  CT = WNJ_enh_CT$TMD_CH4_ppb,
  CAMS = WNJ_enh_CAMS$TMD_CH4_ppb
)

tmd_ch4_enh <- tmd_ch4_enh[grepl("^2022-10", tmd_ch4_enh$Date), ]

##### -------------2.PLOTTING: WNJ - LEW Enhancements--------------------- #####
#### CT-NRT CO2 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(lew_co2_enh$CT ~ lew_co2_enh$OBS, data = lew_co2_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(lew_co2_enh$CT, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(lew_co2_enh$CT, na.rm = TRUE) / sqrt(sum(!is.na(lew_co2_enh$CT))), 2)
mean_val_obs <- round(mean(lew_co2_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(lew_co2_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(lew_co2_enh$OBS))), 2)

ggplot(lew_co2_enh, aes(OBS, CT)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - LEW CO2 Enhancements: Observations vs CT-NRT",
    x = "Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
  
#### CAMS CO2 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(lew_co2_enh$CAMS ~ lew_co2_enh$OBS, data = lew_co2_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(lew_co2_enh$CAMS, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(lew_co2_enh$CAMS, na.rm = TRUE) / sqrt(sum(!is.na(lew_co2_enh$CAMS))), 2)
mean_val_obs <- round(mean(lew_co2_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(lew_co2_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(lew_co2_enh$OBS))), 2)

ggplot(lew_co2_enh, aes(OBS, CAMS)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - LEW CO2 Enhancements: Observations vs CAMS",
    x = "Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_ct,
      "    CAMS SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )

  
  
  
#### CT CH4 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(lew_ch4_enh$CT ~ lew_ch4_enh$OBS, data = lew_ch4_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(lew_ch4_enh$CT, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(lew_ch4_enh$CT, na.rm = TRUE) / sqrt(sum(!is.na(lew_ch4_enh$CT))), 2)
mean_val_obs <- round(mean(lew_ch4_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(lew_ch4_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(lew_ch4_enh$OBS))), 2)

ggplot(lew_ch4_enh, aes(OBS, CT)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - LEW CH4 Enhancements: Observations vs CT",
    x = "Observed CH4 Enhancement (ppb)",
    y = "CT CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )

#### CAMS CH4 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(lew_ch4_enh$CAMS ~ lew_ch4_enh$OBS, data = lew_ch4_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(lew_ch4_enh$CAMS, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(lew_ch4_enh$CAMS, na.rm = TRUE) / sqrt(sum(!is.na(lew_ch4_enh$CAMS))), 2)
mean_val_obs <- round(mean(lew_ch4_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(lew_ch4_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(lew_ch4_enh$OBS))), 2)

ggplot(lew_ch4_enh, aes(OBS, CAMS)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - LEW CH4 Enhancements: Observations vs CAMS",
    x = "Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_ct,
      "    CAMS SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )




##### ------------3.PLOTTING: WNJ - TMD Enhancements---------------------- #####
#### CT-NRT CO2 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(tmd_co2_enh$CT ~ tmd_co2_enh$OBS, data = tmd_co2_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(tmd_co2_enh$CT, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(tmd_co2_enh$CT, na.rm = TRUE) / sqrt(sum(!is.na(tmd_co2_enh$CT))), 2)
mean_val_obs <- round(mean(tmd_co2_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(tmd_co2_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(tmd_co2_enh$OBS))), 2)

ggplot(tmd_co2_enh, aes(OBS, CT)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - TMD CO2 Enhancements: Observations vs CT-NRT",
    x = "Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )

#### CAMS CO2 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(tmd_co2_enh$CAMS ~ tmd_co2_enh$OBS, data = tmd_co2_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(tmd_co2_enh$CAMS, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(tmd_co2_enh$CAMS, na.rm = TRUE) / sqrt(sum(!is.na(tmd_co2_enh$CAMS))), 2)
mean_val_obs <- round(mean(tmd_co2_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(tmd_co2_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(tmd_co2_enh$OBS))), 2)

ggplot(tmd_co2_enh, aes(OBS, CAMS)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - TMD CO2 Enhancements: Observations vs CAMS",
    x = "Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_ct,
      "    CAMS SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )




#### CT CH4 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(tmd_ch4_enh$CT ~ tmd_ch4_enh$OBS, data = tmd_ch4_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(tmd_ch4_enh$CT, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(tmd_ch4_enh$CT, na.rm = TRUE) / sqrt(sum(!is.na(tmd_ch4_enh$CT))), 2)
mean_val_obs <- round(mean(tmd_ch4_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(tmd_ch4_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(tmd_ch4_enh$OBS))), 2)

ggplot(tmd_ch4_enh, aes(OBS, CT)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - TMD CH4 Enhancements: Observations vs CT",
    x = "Observed CH4 Enhancement (ppb)",
    y = "CT CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )

#### CAMS CH4 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(tmd_ch4_enh$CAMS ~ tmd_ch4_enh$OBS, data = tmd_ch4_enh)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(tmd_ch4_enh$CAMS, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(tmd_ch4_enh$CAMS, na.rm = TRUE) / sqrt(sum(!is.na(tmd_ch4_enh$CAMS))), 2)
mean_val_obs <- round(mean(tmd_ch4_enh$OBS, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(tmd_ch4_enh$OBS, na.rm = TRUE) / sqrt(sum(!is.na(tmd_ch4_enh$OBS))), 2)

ggplot(tmd_ch4_enh, aes(OBS, CAMS)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "WNJ - TMD CH4 Enhancements: Observations vs CAMS",
    x = "Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_ct,
      "    CAMS SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )

#### -----------------4.PLOTTING: SHIP - TOWER Enhancements--------------- #####
#### 5.LOADING IN CRUISES- EXACT BACK TRAJECTORY TIMES--------------------- ####
c4 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/enh_btj.times_c4.csv")
c14 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/enh_btj.times_c14.csv")
c24 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/enh_btj.times_c24.csv")
combo <- rbind(c4,c24)
#### CT-NRT CO2 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$ct_co2 ~ combo$obs_co2, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(combo$ct_co2, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(combo$ct_co2, na.rm = TRUE) / sqrt(sum(!is.na(combo$ct_co2))), 2)
mean_val_obs <- round(mean(combo$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_co2))), 2)

ggplot(combo, aes(obs_co2, ct_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CO2 Enhancements: Cruises 4 & 24 Observations vs CT-NRT",
    x = "Cruises 4 & 24 Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT CH4 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$ct_ch4 ~ combo$obs_ch4, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(combo$ct_ch4, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(combo$ct_ch4, na.rm = TRUE) / sqrt(sum(!is.na(combo$ct_ch4))), 2)
mean_val_obs <- round(mean(combo$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_ch4))), 2)

ggplot(combo, aes(obs_ch4, ct_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CH4 Enhancements: Cruises 4 & 24 Observations vs CT",
    x = "Cruises 4 & 24 Observed CH4 Enhancement (ppb)",
    y = "CT CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CO2 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$cams_co2 ~ combo$obs_co2, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(combo$cams_co2, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(combo$cams_co2, na.rm = TRUE) / sqrt(sum(!is.na(combo$cams_co2))), 2)
mean_val_obs <- round(mean(combo$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_co2))), 2)

ggplot(combo, aes(obs_co2, cams_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CO2 Enhancements: Cruises 4 & 24 Observations vs CAMS",
    x = "Cruises 4 & 24 Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CH4 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$cams_ch4 ~ combo$obs_ch4, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(combo$cams_ch4, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(combo$cams_ch4, na.rm = TRUE) / sqrt(sum(!is.na(combo$cams_ch4))), 2)
mean_val_obs <- round(mean(combo$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_ch4))), 2)

ggplot(combo, aes(obs_ch4, cams_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CH4 Enhancements: Cruises 4 & 24 Observations vs CAMS",
    x = "Cruises 4 & 24 Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT-NRT CO2 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$ct_co2 ~ c14$obs_co2, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(c14$ct_co2, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(c14$ct_co2, na.rm = TRUE) / sqrt(sum(!is.na(c14$ct_co2))), 2)
mean_val_obs <- round(mean(c14$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_co2))), 2)

ggplot(c14, aes(obs_co2, ct_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CO2 Enhancements: Cruises 14 Observations vs CT-NRT",
    x = "Cruises 14 Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT CH4 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$ct_ch4 ~ c14$obs_ch4, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(c14$ct_ch4, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(c14$ct_ch4, na.rm = TRUE) / sqrt(sum(!is.na(c14$ct_ch4))), 2)
mean_val_obs <- round(mean(c14$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_ch4))), 2)

ggplot(c14, aes(obs_ch4, ct_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CH4 Enhancements: Cruises 14 Observations vs CT",
    x = "Cruises 14 Observed CH4 Enhancement (ppb)",
    y = "CT CO2 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CO2 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$cams_co2 ~ c14$obs_co2, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(c14$cams_co2, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(c14$cams_co2, na.rm = TRUE) / sqrt(sum(!is.na(c14$cams_co2))), 2)
mean_val_obs <- round(mean(c14$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_co2))), 2)

ggplot(c14, aes(obs_co2, cams_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CO2 Enhancements: Cruises 14 Observations vs CAMS",
    x = "Cruises 14 Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CH4 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$cams_ch4 ~ c14$obs_ch4, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(c14$cams_ch4, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(c14$cams_ch4, na.rm = TRUE) / sqrt(sum(!is.na(c14$cams_ch4))), 2)
mean_val_obs <- round(mean(c14$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_ch4))), 2)

ggplot(c14, aes(obs_ch4, cams_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CH4 Enhancements: Cruises 14 Observations vs CAMS",
    x = "Cruises 14 Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### --------------6.PLOTTING: SHIP - ALT GRIDCELL Enhancements----------- #####
#### CT-NRT CO2 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$ct_co2.A ~ combo$obs_co2, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(combo$ct_co2.A, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(combo$ct_co2.A, na.rm = TRUE) / sqrt(sum(!is.na(combo$ct_co2.A))), 2)
mean_val_obs <- round(mean(combo$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_co2))), 2)

ggplot(combo, aes(obs_co2, ct_co2.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CO2 Enhancements: Cruises 4 & 24 Observations vs CT-NRT",
    x = "Cruises 4 & 24 Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT CH4 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$ct_ch4.A ~ combo$obs_ch4, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(combo$ct_ch4.A, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(combo$ct_ch4.A, na.rm = TRUE) / sqrt(sum(!is.na(combo$ct_ch4.A))), 2)
mean_val_obs <- round(mean(combo$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_ch4))), 2)

ggplot(combo, aes(obs_ch4, ct_ch4.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alterative Gridcell CH4 Enhancements: Cruises 4 & 24 Observations vs CT",
    x = "Cruises 4 & 24 Observed CH4 Enhancement (ppb)",
    y = "CT CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CO2 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$cams_co2.A ~ combo$obs_co2, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(combo$cams_co2.A, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(combo$cams_co2.A, na.rm = TRUE) / sqrt(sum(!is.na(combo$cams_co2.A))), 2)
mean_val_obs <- round(mean(combo$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_co2))), 2)

ggplot(combo, aes(obs_co2, cams_co2.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CO2 Enhancements: Cruises 4 & 24 Observations vs CAMS",
    x = "Cruises 4 & 24 Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CH4 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(combo$cams_ch4.A ~ combo$obs_ch4, data = combo)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(combo$cams_ch4.A, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(combo$cams_ch4.A, na.rm = TRUE) / sqrt(sum(!is.na(combo$cams_ch4.A))), 2)
mean_val_obs <- round(mean(combo$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(combo$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(combo$obs_ch4))), 2)

ggplot(combo, aes(obs_ch4, cams_ch4.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CH4 Enhancements: Cruises 4 & 24 Observations vs CAMS",
    x = "Cruises 4 & 24 Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT-NRT CO2 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$ct_co2.A ~ c14$obs_co2, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(c14$ct_co2.A, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(c14$ct_co2.A, na.rm = TRUE) / sqrt(sum(!is.na(c14$ct_co2.A))), 2)
mean_val_obs <- round(mean(c14$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_co2))), 2)

ggplot(c14, aes(obs_co2, ct_co2.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CO2 Enhancements: Cruises 14 Observations vs CT-NRT",
    x = "Cruises 14 Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT CH4 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$ct_ch4.A ~ c14$obs_ch4, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(c14$ct_ch4.A, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(c14$ct_ch4.A, na.rm = TRUE) / sqrt(sum(!is.na(c14$ct_ch4.A))), 2)
mean_val_obs <- round(mean(c14$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_ch4))), 2)

ggplot(c14, aes(obs_ch4, ct_ch4.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CH4 Enhancements: Cruises 14 Observations vs CT",
    x = "Cruises 14 Observed CH4 Enhancement (ppb)",
    y = "CT CO2 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CO2 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$cams_co2.A ~ c14$obs_co2, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(c14$cams_co2.A, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(c14$cams_co2.A, na.rm = TRUE) / sqrt(sum(!is.na(c14$cams_co2.A))), 2)
mean_val_obs <- round(mean(c14$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_co2))), 2)

ggplot(c14, aes(obs_co2, cams_co2.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CO2 Enhancements: Cruises 14 Observations vs CAMS",
    x = "Cruises 14 Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CH4 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(c14$cams_ch4.A ~ c14$obs_ch4, data = c14)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(c14$cams_ch4.A, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(c14$cams_ch4.A, na.rm = TRUE) / sqrt(sum(!is.na(c14$cams_ch4.A))), 2)
mean_val_obs <- round(mean(c14$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(c14$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(c14$obs_ch4))), 2)

ggplot(c14, aes(obs_ch4, cams_ch4.A)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - Alternative Gridcell CH4 Enhancements: Cruises 14 Observations vs CAMS",
    x = "Cruises 14 Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )







#### -------------------7.LOADING IN CRUISES- FULL TIMES------------------- ####
#### ------------------LOAD IN CRUISES, LEW, AND TMD TOWERS-------_-------- ####
#cruise 4
df4 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/c4_alt_models_5min_daylight.csv")
df4$date <- ifelse(
  nchar(df4$date) == 10,
  paste0(df4$date, " 00:00:00"),
  df4$date)
df4$date <- as.POSIXct(df4$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
df4$cruise <- "C4"
df4_alt <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_4/alt_gridcell_bkgrd_c4.csv")
#cruise 14
df14 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/c14_alt_models_5min_daylight.csv")
df14$date <- ifelse(
  nchar(df14$date) == 10,
  paste0(df14$date, " 00:00:00"),
  df14$date)
df14$date <- as.POSIXct(df14$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
df14$date <- df14$date - 120
df14_alt <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_14/alt_gridcell_bkgrd_c14.csv")
df14_alt$date <- ifelse(
  nchar(df14_alt$date) == 10,
  paste0(df14_alt$date, " 00:00:00"),
  df14_alt$date)
df14_alt$date <- as.POSIXct(df14_alt$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
df14$cruise <- "C14"
#cruise 24
df24 <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/c24_alt_models_5min_daylight.csv")
df24$date <- ifelse(
  nchar(df24$date) == 10,
  paste0(df24$date, " 00:00:00"),
  df24$date)
df24$date <- as.POSIXct(df24$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
df24$date <- df24$date - 60
df24$cruise <- "C24"
df24_alt <- read.csv("/Users/reneechabot-mehlin/Desktop/model_plotting/cruise_24/alt_gridcell_bkgrd_c24.csv")
#combine cruises 4 and 24 since they both use LEW as a bkgrd tower
combo <- rbind(df4,df24)
combo_alt <- rbind(df4_alt, df24_alt)
combo_alt$date <- ifelse(
  nchar(combo_alt$date) == 10,
  paste0(combo_alt$date, " 00:00:00"),
  combo_alt$date)
combo_alt$date <- as.POSIXct(combo_alt$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
#merge based on date now :-) 
library(dplyr)
#LEW CO2 merge w/ c4 & c24
LEW_sub_co2 <- LEW_co2 %>%
  select(date = datetime_utc, co2_ppm,CAMS_CO2, CT_CO2)
combo_sub_co2 <- combo %>%
  select(date, CO2_dry_cal_moving_day, 
         CT_CO2_tile, CAMS_CO2)
merged_co2_LEW <- left_join(
  LEW_sub_co2, combo_sub_co2,
  by = "date",
  suffix = c("_LEW", "_combo")
) %>% 
  na.omit()
#LEW CH4 merge w/ c4 & c24
LEW_sub_ch4 <- LEW_ch4 %>%
  select(date = datetime_utc, ch4_ppb, CAMS_CH4, CT_CH4)
combo_sub_ch4 <- combo %>%
  select(date, CH4_dry_cal_moving_day,
         CT_CH4_tile, CAMS_CH4)
merged_ch4_LEW <- left_join(
  LEW_sub_ch4, combo_sub_ch4,
  by = "date",
  suffix = c("_LEW", "_combo")
) %>% 
  na.omit()
#TMD CO2 merge w/ c14
TMD_sub_co2 <- TMD_co2 %>%
  select(date = datetime_utc, co2_ppm,CAMS_CO2, CT_CO2)
df14_sub_co2 <- df14 %>%
  select(date, CO2_dry_cal_moving_day, 
         CT_CO2_tile, CAMS_CO2)
merged_co2_c14 <- left_join(
  TMD_sub_co2, df14_sub_co2,
  by = "date",
  suffix = c("_TMD", "_cruise")
) %>% 
  na.omit()
#TMD CH4 merge w/ c14
TMD_sub_ch4 <- TMD_ch4 %>%
  select(date = datetime_utc, ch4_ppb, CAMS_CH4, CT_CH4)
df14_sub_ch4 <- df14 %>%
  select(date, CH4_dry_cal_moving_day,
         CT_CH4_tile, CAMS_CH4)
merged_ch4_c14 <- left_join(
  TMD_sub_ch4, df14_sub_ch4,
  by = "date",
  suffix = c("_TMD", "_combo")
) %>% 
  na.omit()
#observational enhancement
LEW_CO2_ppm <- merged_co2_LEW$CO2_dry_cal_moving_day - merged_co2_LEW$co2_ppm
LEW_CH4_ppb <- (merged_ch4_LEW$CH4_dry_cal_moving_day*1000) - merged_ch4_LEW$ch4_ppb
TMD_CO2_ppm <- merged_co2_c14$CO2_dry_cal_moving_day - merged_co2_c14$co2_ppm
TMD_CH4_ppb <- (merged_ch4_c14$CH4_dry_cal_moving_day*1000) - merged_ch4_c14$ch4_ppb

n <- max(length(LEW_CO2_ppm), length(LEW_CH4_ppb), length(TMD_CO2_ppm), length(TMD_CH4_ppb))
pad <- function(x, n) { length(x) <- n; x }

SHIP_enh_obs <- data.frame(
  LEW_CO2_ppm = pad(LEW_CO2_ppm, n),
  LEW_CH4_ppb = pad(LEW_CH4_ppb, n),
  TMD_CO2_ppm = pad(TMD_CO2_ppm, n), #different dates than LEW dates
  TMD_CH4_ppb = pad(TMD_CH4_ppb, n) #different dates than LEW dates
)
#ct enhancement
LEW_CO2_ppm <- merged_co2_LEW$CT_CO2_tile - merged_co2_LEW$CT_CO2
LEW_CH4_ppb <- (merged_ch4_LEW$CT_CH4_tile*1000) - merged_ch4_LEW$CT_CH4
TMD_CO2_ppm <- merged_co2_c14$CT_CO2_tile - merged_co2_c14$CT_CO2
TMD_CH4_ppb <- (merged_ch4_c14$CT_CH4_tile*1000) - merged_ch4_c14$CT_CH4

n <- max(length(LEW_CO2_ppm), length(LEW_CH4_ppb), length(TMD_CO2_ppm), length(TMD_CH4_ppb))
pad <- function(x, n) { length(x) <- n; x }

SHIP_enh_ct <- data.frame(
  LEW_CO2_ppm = pad(LEW_CO2_ppm, n),
  LEW_CH4_ppb = pad(LEW_CH4_ppb, n),
  TMD_CO2_ppm = pad(TMD_CO2_ppm, n), #different dates than LEW dates
  TMD_CH4_ppb = pad(TMD_CH4_ppb, n) #different dates than LEW dates
)
#cams enhancement
LEW_CO2_ppm <- merged_co2_LEW$CAMS_CO2_combo - merged_co2_LEW$CAMS_CO2_LEW
LEW_CH4_ppb <- (merged_ch4_LEW$CAMS_CH4_combo*1000) - merged_ch4_LEW$CAMS_CH4_LEW
TMD_CO2_ppm <- merged_co2_c14$CAMS_CO2_cruise - merged_co2_c14$CAMS_CO2_TMD
TMD_CH4_ppb <- (merged_ch4_c14$CAMS_CH4_combo*1000) - merged_ch4_c14$CAMS_CH4_TMD

n <- max(length(LEW_CO2_ppm), length(LEW_CH4_ppb), length(TMD_CO2_ppm), length(TMD_CH4_ppb))
pad <- function(x, n) { length(x) <- n; x }

SHIP_enh_cams <- data.frame(
  LEW_CO2_ppm = pad(LEW_CO2_ppm, n),
  LEW_CH4_ppb = pad(LEW_CH4_ppb, n),
  TMD_CO2_ppm = pad(TMD_CO2_ppm, n), #different dates than LEW dates
  TMD_CH4_ppb = pad(TMD_CH4_ppb, n) #different dates than LEW dates
)

ship_enh_lew <- data.frame(obs_co2 = SHIP_enh_obs$LEW_CO2_ppm,
                           obs_ch4 = SHIP_enh_obs$LEW_CH4_ppb,
                           ct_co2 = SHIP_enh_ct$LEW_CO2_ppm,
                           ct_ch4 = SHIP_enh_ct$LEW_CH4_ppb,
                           cams_co2 = SHIP_enh_cams$LEW_CO2_ppm,
                           cams_ch4 = SHIP_enh_cams$LEW_CH4_ppb,
                           Date = merged_co2_LEW$date)

ship_enh_tmd <- data.frame(obs_co2 = SHIP_enh_obs$TMD_CO2_ppm,
                           obs_ch4 = SHIP_enh_obs$TMD_CH4_ppb,
                           ct_co2 = SHIP_enh_ct$TMD_CO2_ppm,
                           ct_ch4 = SHIP_enh_ct$TMD_CH4_ppb,
                           cams_co2 = SHIP_enh_cams$TMD_CO2_ppm,
                           cams_ch4 = SHIP_enh_cams$TMD_CH4_ppb)

ship_enh_tmd <- ship_enh_tmd[rowSums(!is.na(ship_enh_tmd)) > 0, ]
ship_enh_tmd$Date = merged_co2_c14$date

#### CT-NRT CO2 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_lew$ct_co2 ~ ship_enh_lew$obs_co2, data = ship_enh_lew)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(ship_enh_lew$ct_co2, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(ship_enh_lew$ct_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$ct_co2))), 2)
mean_val_obs <- round(mean(ship_enh_lew$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_lew$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$obs_co2))), 2)

ggplot(ship_enh_lew, aes(obs_co2, ct_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CO2 Enhancements: Cruises 4 & 24 Observations vs CT-NRT",
    x = "Cruises 4 & 24 Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT CH4 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_lew$ct_ch4 ~ ship_enh_lew$obs_ch4, data = ship_enh_lew)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(ship_enh_lew$ct_ch4, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(ship_enh_lew$ct_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$ct_ch4))), 2)
mean_val_obs <- round(mean(ship_enh_lew$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_lew$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$obs_ch4))), 2)

ggplot(ship_enh_lew, aes(obs_ch4, ct_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CH4 Enhancements: Cruises 4 & 24 Observations vs CT",
    x = "Cruises 4 & 24 Observed CH4 Enhancement (ppb)",
    y = "CT CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CO2 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_lew$cams_co2 ~ ship_enh_lew$obs_co2, data = ship_enh_lew)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(ship_enh_lew$cams_co2, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(ship_enh_lew$cams_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$cams_co2))), 2)
mean_val_obs <- round(mean(ship_enh_lew$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_lew$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$obs_co2))), 2)

ggplot(ship_enh_lew, aes(obs_co2, cams_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CO2 Enhancements: Cruises 4 & 24 Observations vs CAMS",
    x = "Cruises 4 & 24 Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CH4 C4 & C24 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_lew$cams_ch4 ~ ship_enh_lew$obs_ch4, data = ship_enh_lew)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(ship_enh_lew$cams_ch4, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(ship_enh_lew$cams_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$cams_ch4))), 2)
mean_val_obs <- round(mean(ship_enh_lew$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_lew$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_lew$obs_ch4))), 2)

ggplot(ship_enh_lew, aes(obs_ch4, cams_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - LEW CH4 Enhancements: Cruises 4 & 24 Observations vs CAMS",
    x = "Cruises 4 & 24 Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT-NRT CO2 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_tmd$ct_co2 ~ ship_enh_tmd$obs_co2, data = ship_enh_tmd)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(ship_enh_tmd$ct_co2, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(ship_enh_tmd$ct_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$ct_co2))), 2)
mean_val_obs <- round(mean(ship_enh_tmd$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_tmd$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$obs_co2))), 2)

ggplot(ship_enh_tmd, aes(obs_co2, ct_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CO2 Enhancements: Cruises 14 Observations vs CT-NRT",
    x = "Cruises 14 Observed CO2 Enhancement (ppm)",
    y = "CT-NRT CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT-NRT Mean = ", mean_val_ct,
      "    CT-NRT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CT CH4 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_tmd$ct_ch4 ~ ship_enh_tmd$obs_ch4, data = ship_enh_tmd)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_ct <- round(mean(ship_enh_tmd$ct_ch4, na.rm = TRUE), 2)
sem_val_ct  <- round(sd(ship_enh_tmd$ct_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$ct_ch4))), 2)
mean_val_obs <- round(mean(ship_enh_tmd$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_tmd$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$obs_ch4))), 2)

ggplot(ship_enh_tmd, aes(obs_ch4, ct_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CH4 Enhancements: Cruises 14 Observations vs CT",
    x = "Cruises 14 Observed CH4 Enhancement (ppb)",
    y = "CT CO2 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CT Mean = ", mean_val_ct,
      "    CT SEM = ", sem_val_ct,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CO2 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_tmd$cams_co2 ~ ship_enh_tmd$obs_co2, data = ship_enh_tmd)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(ship_enh_tmd$cams_co2, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(ship_enh_tmd$cams_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$cams_co2))), 2)
mean_val_obs <- round(mean(ship_enh_tmd$obs_co2, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_tmd$obs_co2, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$obs_co2))), 2)

ggplot(ship_enh_tmd, aes(obs_co2, cams_co2)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CO2 Enhancements: Cruises 14 Observations vs CAMS",
    x = "Cruises 14 Observed CO2 Enhancement (ppm)",
    y = "CAMS CO2 Enhancement (ppm)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
#### CAMS CH4 C14 ####
library(ggplot2)
library(ggpmisc)
library(ggpubr)
library(tidyr)
fit <- lm(ship_enh_tmd$cams_ch4 ~ ship_enh_tmd$obs_ch4, data = ship_enh_tmd)
rse_value <- round(summary(fit)$sigma, 2) 

mean_val_cams <- round(mean(ship_enh_tmd$cams_ch4, na.rm = TRUE), 2)
sem_val_cams  <- round(sd(ship_enh_tmd$cams_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$cams_ch4))), 2)
mean_val_obs <- round(mean(ship_enh_tmd$obs_ch4, na.rm = TRUE), 2)
sem_val_obs  <- round(sd(ship_enh_tmd$obs_ch4, na.rm = TRUE) / sqrt(sum(!is.na(ship_enh_tmd$obs_ch4))), 2)

ggplot(ship_enh_tmd, aes(obs_ch4, cams_ch4)) + 
  geom_line(linewidth = 1, color = "firebrick") + 
  geom_point(size = 2, color = "firebrick") + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Ship - TMD CH4 Enhancements: Cruises 14 Observations vs CAMS",
    x = "Cruises 14 Observed CH4 Enhancement (ppb)",
    y = "CAMS CH4 Enhancement (ppb)"
  ) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  stat_poly_eq(
    aes(label = after_stat(
      paste(eq.label,
            rr.label,
            paste0("RSE == ", rse_value),
            sep = "~~~~")
    )),
    formula = y ~ x,
    parse = TRUE,
    size = 7,
    npcx = 0.02,
    npcy = 0.98,
    hjust = 0
  ) +
  ggpp::geom_text_npc(
    data = ~ head(.x, 1),
    npcx = 0.02,
    npcy = 0.92,
    hjust = 0,
    size = 7,
    label = paste0(
      "CAMS Mean = ", mean_val_cams,
      "    CAMS SEM = ", sem_val_cams,
      "\nObserved Mean = ", mean_val_obs,
      "    Observed SEM = ", sem_val_obs
    )
  )
##### Alternative Gridcells and Lowest 5th percentile for cruise####
library(dplyr)
#ALT CO2 merge w/ c4 & c24
Acombo_sub_co2 <- combo_alt %>%
  select(date = date ,CAMS_CO2, CT.NRT_co2) #alternative gridcells 
combo_sub_co2 <- combo %>%
  select(date, CT_CO2_tile, CAMS_CO2) #ship gridcells
merged_co2_alt<- left_join(
  Acombo_sub_co2, combo_sub_co2,
  by = "date",
  suffix = c("_Alt", "_combo")
) %>% 
  na.omit()
#ALT CH4 merge w/ c4 & c24
Acombo_sub_ch4 <- combo_alt %>%
  select(date = date ,CAMS_CH4, CT_ch4) #alternative gridcells
combo_sub_ch4 <- combo %>%
  select(date, CT_CH4_tile, CAMS_CH4) #ship gridcells
merged_ch4_alt<- left_join(
  Acombo_sub_ch4, combo_sub_ch4,
  by = "date",
  suffix = c("_Alt", "_combo")
) %>% 
  na.omit()
#ALT CO2 merge w/ c14
Alt_14_sub_co2 <- df14_alt %>%
  select(date = date, CAMS_CO2, CT.NRT_co2) #alternative gridcells
df14_sub_co2 <- df14 %>%
  select(date, 
         CT_CO2_tile, CAMS_CO2) #ship gridcells
merged_co2_c14_alt <- left_join(
  Alt_14_sub_co2, df14_sub_co2,
  by = "date",
  suffix = c("_Alt", "_cruise")
) %>% 
  na.omit()
#ALT CH4 merge w/ c14
Alt_14_sub_ch4 <- df14_alt %>%
  select(date = date, CAMS_CH4, CT_ch4) #alternative gricells
df14_sub_ch4 <- df14 %>%
  select(date, 
         CT_CH4_tile, CAMS_CH4) #ship gridcells 
merged_ch4_c14_alt <- left_join(
  Alt_14_sub_ch4, df14_sub_ch4,
  by = "date",
  suffix = c("_Alt", "_cruise")
) %>% 
  na.omit()

enh_combo_co2_alt.gc <- data.frame(
  CT.ppm = (merged_co2_alt$CT_CO2_tile - merged_co2_alt$CT.NRT_co2),
  CAMS.ppm = (merged_co2_alt$CAMS_CO2_combo - merged_co2_alt$CAMS_CO2_Alt),
  Date = merged_co2_alt$date
  )

enh_combo_ch4_alt.gc <- data.frame(
  CT.ppb = ((merged_ch4_alt$CT_CH4_tile * 1000) - merged_ch4_alt$CT_ch4),
  CAMS.ppb = ((merged_ch4_alt$CAMS_CH4_combo *
                 1000) - merged_ch4_alt$CAMS_CH4_Alt
  ),
  Date = merged_ch4_alt$date
)

enh_c14_co2_alt.gc <- data.frame(
  CT.ppm = (
    merged_co2_c14_alt$CT_CO2_tile - merged_co2_c14_alt$CT.NRT_co2
  ),
  CAMS.ppm = (
    merged_co2_c14_alt$CAMS_CO2_cruise - merged_co2_c14_alt$CAMS_CO2_Alt
  ),
  Date = merged_co2_c14_alt$date
)

enh_c14_ch4_alt.gc <- data.frame(
  CT.ppb = ((merged_ch4_c14_alt$CT_CH4_tile * 1000) - merged_ch4_c14_alt$CT_ch4
  ),
  CAMS.ppb = ((merged_ch4_c14_alt$CAMS_CH4_cruise *
                 1000) - merged_ch4_c14_alt$CAMS_CH4_Alt
  ),
  Date = merged_ch4_c14_alt$date
)

alternative_enh_c4.c24 <-merge(enh_combo_co2_alt.gc, enh_combo_ch4_alt.gc, by = "Date", all.x = T)
alternative_enh_c14 <-merge(enh_c14_co2_alt.gc, enh_c14_ch4_alt.gc, by = "Date", all.x = T)

lowest <- readRDS("/Users/reneechabot-mehlin/Desktop/model_plotting/5th_per_bkgrds.RDS")
i <- match(combo$cruise, lowest$cruise)
combo$CO2_enh_L5th <- combo$CO2_dry_cal_moving_day - lowest$co2[i]
combo$CH4_enh_L5th <- combo$CH4_dry_cal_moving_day - lowest$ch4[i]
i <- match(df14$cruise, lowest$cruise)
df14$CO2_enh_L5th <- df14$CO2_dry_cal_moving_day - lowest$co2[i]
df14$CH4_enh_L5th <- df14$CH4_dry_cal_moving_day - lowest$ch4[i]

enh_fifth_c4.c24 = data.frame(
  CO2_ppm = combo$CO2_enh_L5th,
  CH4_ppb = (combo$CH4_enh_L5th * 1000),
  Date = combo$date
)

enh_fifth_c14 = data.frame(
  CO2_ppm = df14$CO2_enh_L5th,
  CH4_ppb = (df14$CH4_enh_L5th * 1000),
  Date = df14$date
)

library(ggplot2)
plot_stats <- function(df, column, title = NULL, ylab = NULL){
  
  x <- df[[column]]
  x <- x[!is.na(x)]
  
  stats <- data.frame(
    Index = seq_along(x),
    Value = x
  )
  
  mean_x <- mean(x)
  sd_x   <- sd(x)
  sem_x  <- sd_x / sqrt(length(x))
  
  label <- sprintf(
    "Mean = %.3f\nSD = %.3f\nSEM = %.3f",
    mean_x, sd_x, sem_x
  )
  
  ggplot(stats, aes(Index, Value)) +
    geom_line(color = "black") +
    geom_point(size = 1.5) +
    annotate(
      "label",
      x = Inf, y = Inf,
      hjust = 1.05, vjust = 1.1,
      label = label,
      size = 5
    ) +
    labs(
      title = title,
      x = "count (n)",
      y = ylab
    ) +
    theme_bw(base_size = 18)
}

plot_stats(
  enh_fifth_c4.c24,
  "CO2_ppm",
  "Lowest Fifth Percentile Averaged CO2 Enhancement (C4/C24)",
  "Ship CO2 Observations - Lowest Fifth Percentile Average CO2 (ppm)"
)

plot_stats(
  enh_fifth_c4.c24,
  "CH4_ppb",
  "Lowest Fifth Percentile Averaged CH4 Enhancement (C4/C24)",
  "Ship CH4 Observations - Lowest Fifth Percentile Average CH4 (ppb)"
)

plot_stats(
  enh_fifth_c14,
  "CO2_ppm",
  "Lowest Fifth Percentile Averaged CO2 Enhancement (C14)",
  "Ship CO2 Observations - Lowest Fifth Percentile Average CO2 (ppm)"
)

plot_stats(
  enh_fifth_c14,
  "CH4_ppb",
  "Lowest Fifth Percentile Averaged CH4 Enhancement (C14)",
  "Ship CH4 Observations - Lowest Fifth Percentile Average CH4 (ppb)"
)

plot_stats(
  alternative_enh_c4.c24,
  "CT.ppm",
  "Alternative Grid Cell CT-NRT Model CO2 Enhancement (C4/C24)",
  "Ship CO2 CT-NRT - Alternative Grid Cell CT-NRT Model CO2 (ppm)"
)

plot_stats(
  alternative_enh_c4.c24,
  "CAMS.ppm",
  "Alternative Grid Cell CAMS Model CO2 Enhancement (C4/C24)",
  "Ship CO2 CAMS - Alternative Grid Cell CAMS Model CO2 (ppm)"
)

plot_stats(
  alternative_enh_c4.c24,
  "CT.ppb",
  "Alternative Grid Cell CT Model CH4 Enhancement (C4/C24)",
  "Ship CH4 CT - Alternative Grid Cell CT Model CH4 (ppb)"
)

plot_stats(
  alternative_enh_c4.c24,
  "CAMS.ppb",
  "Alternative Grid Cell CAMS Model CH4 Enhancement (C4/C24)",
  "Ship CH4 CAMS - Alternative Grid Cell CAMS Model CH4 (ppb)"
)

plot_stats(
  alternative_enh_c14,
  "CT.ppm",
  "Alternative Grid Cell CT-NRT Model CO2 Enhancement (C14)",
  "Ship CO2 CT-NRT - Alternative Grid Cell CT-NRT Model CO2 (ppm)"
)

plot_stats(
  alternative_enh_c14,
  "CAMS.ppm",
  "Alternative Grid Cell CAMS Model CO2 Enhancement (C14)",
  "Ship CO2 CAMS - Alternative Grid Cell CAMS Model CO2 (ppm)"
)

plot_stats(
  alternative_enh_c14,
  "CT.ppb",
  "Alternative Grid Cell CT Model CH4 Enhancement (C14)",
  "Ship CH4 CT - Alternative Grid Cell CT Model CH4 (ppb)"
)

plot_stats(
  alternative_enh_c14,
  "CAMS.ppb",
  "Alternative Grid Cell CAMS Model CH4 Enhancement (C14)",
  "Ship CH4 CAMS - Alternative Grid Cell CAMS Model CH4 (ppb)"
)
