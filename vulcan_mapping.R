#Vulcan Map
library(raster)
library(terra)
library(viridis)
library(geodata)
v4.tot.co2.1km.llc.mn <- "/Users/reneechabot-mehlin/Downloads/v4.tot.co2.usa.1km.lcc.mn.allyrs/v4.tot.co2.usa.1km.lcc.mn.2022.tif"
vulcan.raster <- terra::rast(v4.tot.co2.1km.llc.mn)

vulcan.lat.lon <- project(vulcan.raster, "EPSG:4326")
vulcan.log <- log10(vulcan.lat.lon + 0.1) # + # changes color scaling 

twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]

us_ll <- geodata::gadm("USA", level = 1, path = tempdir())
cols <- viridis(200)
zlim <- range(values(vulcan.log), na.rm = TRUE)

plot(
  vulcan.log,
  col = cols,
  xlab = "Longitude",
  xlim = c(-80, -70),
  ylab = "Latitude",
  ylim = c(38, 42),
  main = "VULCAN V4.0 ffCO2 Inventory"
)
lines(us_ll, col = "white", lwd = 1.5)
points(twr$Lon, twr$Lat, col = "red", bg = "red", pch = 21)
text(x = twr$Lon + 0.01, y = twr$Lat - 0.1, labels = twr$SiteCode, col = "red")

plot.new()
fields::image.plot(
  legend.only = TRUE,
  zlim = zlim,
  col = cols,
  legend.lab = "log10(tC/year)",
  legend.width = 0.5,
  legend.shrink = 0.7,
  horizontal = F
)
