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
           y = max(LEW_ch4_ct$CT_CH4), 
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
           y = max(LEW_co2$CT_CO2), 
           label = paste(eq, r2, sep = ", "), hjust = 0, vjust = 1.2)


library(cowplot)
four_panel <- plot_grid(
  p1, p2, p3, p4,
  ncol = 2
)

four_panel
