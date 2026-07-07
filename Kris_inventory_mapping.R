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
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ","TMD"), ]
nw.gridcell <- c(41.5, -77.5)
w.gridcell <- c(39.6, -78.5)
alt.gridcells <- data.frame(
  Lat = c(nw.gridcell[1], w.gridcell[1]),
  Lon = c(nw.gridcell[2], w.gridcell[2]),
  relative_to = c("LEW", "TMD"),
  name = c("NW.GC", "W.GC")
)

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
  main = "Hajny Methane Inventory",
  cex.lab = 1.6,
  cex.main = 2,
  cex.axis = 1.3
)
lines(us_ll, col = "white", lwd = 1.5)
points(twr$Lon, twr$Lat, col = "white", bg = "white", pch = 21, cex = 2.5)
points(twr$Lon, twr$Lat, col = "red", bg = "red", pch = 21, cex = 2)
points(alt.gridcells$Lon, alt.gridcells$Lat, col = "white", bg = "white", pch = 21, cex = 2.5)
points(alt.gridcells$Lon, alt.gridcells$Lat, col = "red", bg = "red", pch = 21, cex = 2)

offset <- 0.02
label_offset <- 0.12

for(dx in c(-offset, offset, 0, 0)){
  for(dy in c(0, 0, -offset, offset)){
    text(
      twr$Lon + dx,
      twr$Lat + dy - label_offset,
      twr$SiteCode,
      col = "white",
      cex = 0.9,
      font = 2
    )
  }
}

text(
  twr$Lon,
  twr$Lat - label_offset,
  twr$SiteCode,
  col = "red",
  cex = 0.9,
  font = 2
)

for(dx in c(-offset, offset, 0, 0)){
  for(dy in c(0, 0, -offset, offset)){
    text(
      alt.gridcells$Lon + dx,
      alt.gridcells$Lat + dy - label_offset,
      alt.gridcells$name,
      col = "white",
      cex = 0.9,
      font = 2
    )
  }
}

text(
  alt.gridcells$Lon,
  alt.gridcells$Lat - label_offset,
  alt.gridcells$name,
  col = "red",
  cex = 0.9,
  font = 2
)

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