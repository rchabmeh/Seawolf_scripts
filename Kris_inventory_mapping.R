#Kris's Inventory (mean across ensemble mapping)
library(raster)
library(terra)
library(viridis)
library(geodata)
kris.inventory.path <- "/Users/reneechabot-mehlin/Downloads/mean_across_ensemble.nc"
kris.raster <- terra::rast(kris.inventory.path)
kris.lat.lon <- project(kris.raster, "EPSG:4326")
summed.raster <- sum(kris.lat.lon, na.rm = T)
kris.log <- log10(summed.raster + 0.1) # + # changes color scaling 

twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]

us_ll <- geodata::gadm("USA", level = 1, path = tempdir())
cols <- inferno(200)
zlim <- range(values(kris.log), na.rm = TRUE)

plot(
  kris.log,
  col = cols,
  xlab = "Longitude",
  xlim = c(-80, -70),
  ylab = "Latitude",
  ylim = c(38, 42),
  main = "Hajny Methane Inventory"
)
lines(us_ll, col = "white", lwd = 1.5)
points(twr$Lon, twr$Lat, col = "white", bg = "white", pch = 21)
text(x = twr$Lon + 0.01, y = twr$Lat - 0.1, labels = twr$SiteCode, col = "white")

plot.new()
fields::image.plot(
  legend.only = TRUE,
  zlim = zlim,
  col = cols,
  legend.lab = "log10(nmol/m2/s)",
  legend.width = 0.5,
  legend.shrink = 0.7,
  horizontal = F
)