c4 <- read.csv("/Volumes/Seagate/cruise4_eulerian/all_models_merged_cruise4.csv")
c14 <- read.csv("/Volumes/Seagate/cruise14_eulerian/all_models_merged_cruise14.csv")
c24 <- read.csv("/Volumes/Seagate/cruise24_eulerian/all_models_merged_cruise24.csv")


cruises <- list(c4 = c4, c14 = c14, c24 = c24)
c4$CRUISE = "c4"
c14$CRUISE = "c14"
c24$CRUISE = "c24"

for (nm in names(cruises)) {
  
  cr <- cruises[[nm]]
  
  co2_obs_col  <- if ("obs_co2_enh_via_LEW"  %in% names(cr)) "obs_co2_enh_via_LEW"  else "obs_co2_enh_via_TMD"
  co2_ct_col   <- if ("ct_co2_enh_via_LEW"   %in% names(cr)) "ct_co2_enh_via_LEW"   else "ct_co2_enh_via_TMD"
  co2_cams_col <- if ("cams_co2_enh_via_LEW" %in% names(cr)) "cams_co2_enh_via_LEW" else "cams_co2_enh_via_TMD"
  
  ch4_obs_col  <- if ("obs_ch4_enh_via_LEW"  %in% names(cr)) "obs_ch4_enh_via_LEW"  else "obs_ch4_enh_via_TMD"
  ch4_ct_col   <- if ("ct_ch4_enh_via_LEW"   %in% names(cr)) "ct_ch4_enh_via_LEW"   else "ct_ch4_enh_via_TMD"
  ch4_cams_col <- if ("cams_ch4_enh_via_LEW" %in% names(cr)) "cams_ch4_enh_via_LEW" else "cams_ch4_enh_via_TMD"
  
  co2_source <- if (co2_obs_col == "obs_co2_enh_via_LEW") "LEW" else "TMD"
  ch4_source <- if (ch4_obs_col == "obs_ch4_enh_via_LEW") "LEW" else "TMD"
  
  # CO2
  co2_df <- data.frame(
    DATE_UTC = cr$date,
    OBS_ENH  = cr[[co2_obs_col]],
    CT_ENH   = cr[[co2_ct_col]],
    CAMS_ENH = cr[[co2_cams_col]],
    SOURCE = co2_source,
    CRUISE = nm
  )
  
  co2_df <- na.omit(co2_df)
  assign(paste0(nm, "_co2"), co2_df)
  
  # CH4
  ch4_df <- data.frame(
    DATE_UTC = cr$date,
    OBS_ENH  = cr[[ch4_obs_col]],
    CT_ENH   = cr[[ch4_ct_col]],
    CAMS_ENH = cr[[ch4_cams_col]],
    SOURCE = ch4_source,
    CRUISE = nm
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

co2_list <- mget(ls(pattern = "_co2$"))
co2_all  <- do.call(rbind, co2_list)


ch4_list <- mget(ls(pattern = "_ch4$"))
ch4_all  <- do.call(rbind, ch4_list)

co2_all$GAS <- "CO2"
ch4_all$GAS <- "CH4"

all_gases <- rbind(co2_all, ch4_all)


all_gases <- all_gases[as.numeric(format(all_gases$DATE_NY_AMERICA, "%H")) >= 10 &
           as.numeric(format(all_gases$DATE_NY_AMERICA, "%H")) < 16, ]

library(ggplot2)
library(cowplot)

make_plot <- function(df, xvar, yvar, xlab, ylab) {
  
  fit <- lm(df[[yvar]] ~ df[[xvar]])
  m <- coef(fit)[2]
  b <- coef(fit)[1]
  r2 <- summary(fit)$r.squared
  
  label_text <- paste0(
    "y = ", round(m,3), "x + ", round(b,3),
    "\nR² = ", round(r2,3)
  )
  
  x <- df[[xvar]]
  y <- df[[yvar]]
  lim <- range(c(x, y), na.rm = TRUE)
  
  ggplot(df, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_point() +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    annotate("text",
             x = lim[1] + 0.05*diff(lim),
             y = lim[2] - 0.05*diff(lim),
             label = label_text,
             hjust = 0,
             size = 4) +
    coord_equal(xlim = lim, ylim = lim) +
    labs(x = xlab, y = ylab) +
    theme_bw()
}

co2_data <- all_gases[all_gases$GAS == "CO2", ]
ch4_data <- all_gases[all_gases$GAS == "CH4", ]

#####plotting first attempt #####
# CO2
p1 <- make_plot(
  co2_data,
  "OBS_ENH",
  "CT_ENH",
  "Observed CO2 Enhancement",
  "CarbonTracker CO2 Enhancement"
)

p2 <- make_plot(
  co2_data,
  "OBS_ENH",
  "CAMS_ENH",
  "Observed CO2 Enhancement",
  "CAMS CO2 Enhancement"
)

# CH4
p3 <- make_plot(
  ch4_data,
  "OBS_ENH",
  "CT_ENH",
  "Observed CH4 Enhancement",
  "CarbonTracker CH4 Enhancement"
)

p4 <- make_plot(
  ch4_data,
  "OBS_ENH",
  "CAMS_ENH",
  "Observed CH4 Enhancement",
  "CAMS CH4 Enhancement"
)

plot_grid(
  p1, p2, p3, p4,
  ncol = 2,
  align = "hv",
  labels = NULL
) |> 
  ggdraw() +
  draw_label(
    "Background tower used:\nC4 = LEW   |   C14 = TMD   |   C24 = LEW\nPlotted hours: 10–18 EDT",
    x = 0.5, y = 0.88,
    hjust = 0.5,
    size = 10
  )


####plotting second attempt ####
library(reshape2)

long_df <- melt(
  all_gases,
  id.vars = c("DATE_UTC", "DATE_NY_AMERICA", "OBS_ENH", "SOURCE", "GAS", "CRUISE"),
  measure.vars = c("CT_ENH", "CAMS_ENH"),
  variable.name = "MODEL",
  value.name = "MODEL_ENH"
)

long_df <- long_df[
  as.numeric(format(long_df$DATE_NY_AMERICA, "%H")) >= 10 &
    as.numeric(format(long_df$DATE_NY_AMERICA, "%H")) <= 16,
]


library(dplyr)

gas_limits <- long_df %>%
  group_by(GAS) %>%
  summarise(
    lim_min = min(c(OBS_ENH, MODEL_ENH), na.rm = TRUE),
    lim_max = max(c(OBS_ENH, MODEL_ENH), na.rm = TRUE)
  )

long_df <- long_df %>%
  left_join(gas_limits, by = "GAS")

library(dplyr)

r2_df <- long_df %>%
  group_by(GAS, MODEL) %>%
  summarise(
    r2 = summary(lm(MODEL_ENH ~ OBS_ENH))$r.squared,
    .groups = "drop"
  )


library(cowplot)

# CO2
co2_plot <- ggplot(long_df[long_df$GAS == "CO2", ], 
                   aes(x = OBS_ENH, y = MODEL_ENH, color = SOURCE, shape = CRUISE)) +
  geom_point(size = 4) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "black") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_grid(. ~ MODEL) +
  coord_equal(
    xlim = range(long_df$OBS_ENH[long_df$GAS == "CO2"], na.rm = TRUE),
    ylim = range(long_df$OBS_ENH[long_df$GAS == "CO2"], na.rm = TRUE)
  ) +
  geom_text(
    data = r2_df[r2_df$GAS == "CO2", ],
    aes(x = min(long_df$OBS_ENH[long_df$GAS == "CO2"], na.rm = TRUE),
        y = max(long_df$OBS_ENH[long_df$GAS == "CO2"], na.rm = TRUE),
        label = paste0("R² = ", round(r2, 3))),
    inherit.aes = FALSE,
    hjust = 0, vjust = 1.2,
    size = 6
  ) +
  labs(
    x = "Observed CO2 Enhancement (ppm)",
    y = "Modeled CO2 Enhancement (ppm)",
    color = "Tower",
    shape = "Cruise"
  ) +
  theme_bw() +
  theme(
    axis.title = element_text(size = 14),      # axis labels
    axis.text  = element_text(size = 12),      # axis tick labels
    legend.title = element_text(size = 12),    # legend title
    legend.text  = element_text(size = 10),    # legend items
    strip.text = element_text(size = 12)       # facet labels
  )


# CH4
ch4_plot <- ggplot(long_df[long_df$GAS == "CH4", ], 
                   aes(x = OBS_ENH, y = MODEL_ENH, color = SOURCE, shape = CRUISE)) +
  geom_point(size = 4) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "black") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  facet_grid(. ~ MODEL) +
  coord_equal(
    xlim = range(long_df$OBS_ENH[long_df$GAS == "CH4"], na.rm = TRUE),
    ylim = range(long_df$OBS_ENH[long_df$GAS == "CH4"], na.rm = TRUE)
  ) +
  geom_text(
    data = r2_df[r2_df$GAS == "CH4", ],
    aes(x = min(long_df$OBS_ENH[long_df$GAS == "CH4"], na.rm = TRUE),
        y = max(long_df$OBS_ENH[long_df$GAS == "CH4"], na.rm = TRUE),
        label = paste0("R² = ", round(r2, 3))),
    inherit.aes = FALSE,
    hjust = 0, vjust = 1.2,
    size = 6
  ) +
  labs(
    x = "Observed CH4 Enhancement (ppb)",
    y = "Modeled CH4 Enhancement (ppb)",
    color = "Tower",
    shape = "Cruise"
  ) +
  theme_bw()+
  theme(
    axis.title = element_text(size = 14),      # axis labels
    axis.text  = element_text(size = 12),      # axis tick labels
    legend.title = element_text(size = 12),    # legend title
    legend.text  = element_text(size = 10),    # legend items
    strip.text = element_text(size = 12)       # facet labels
  )

# Combine
plot_grid(co2_plot, ch4_plot, ncol = 1)
