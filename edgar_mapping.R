#edgar mapping
library(ncdf4)
library(raster)
library(terra)
library(viridis)
edgar.nc.file <- ("/Users/reneechabot-mehlin/Downloads/Express_Extension_Gridded_GHGI_Methane_v2_2020.nc")

nc <- nc_open(edgar.nc.file)
vars <- setdiff(names(nc$var), "grid_cell_area")
nc_close(nc)

all.layers <- rast(edgar.nc.file)
edgar.raster <- all.layers[[vars]]
edgar.sum <- sum(edgar.raster)
edgar.log <- log10(edgar.sum + 0.1)


twr <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/NEC_sites.csv")
twr <- twr[twr$SiteCode %in% c("LEW", "WNJ", "BVA", "TMD"), ]

us_ll <- geodata::gadm("USA", level = 1, path = tempdir())
cols <- viridis(200)
vals <- values(edgar.log)
zlims <- range(vals[vals!=0], na.rm = TRUE)

plot(edgar.log,
     col = cols,
     main = "EDGAR Express Extension 2020 CH4 Emissions (summed across all sectors)",
     xlab = "Longitude",
     xlim = c(-80, -70),
     ylab = "Latitude",
     ylim = c(38, 42),
     zlim = zlims
     )

lines(us_ll, col = "white", lwd = 1.5)
points(twr$Lon, twr$Lat, col = "red", bg = "red", pch = 21)
text(x = twr$Lon + 0.01, y = twr$Lat - 0.1, labels = twr$SiteCode, col = "red")

plot.new()
fields::image.plot(
  legend.only = TRUE,
  zlim = zlims,
  col = cols,
  legend.lab = "log10(moleccm-2s-1 )",
  legend.width = 0.5,
  legend.shrink = 0.7,
  horizontal = F
)