
setwd("~/Google Drive/My Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/EDGAR_yearly_inventory")
library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
#I chose to use the same year as the EPA inventory
nc_data <- nc_open("~/Google Drive/My Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/EDGAR_yearly_inventory/EDGAR_v7.0_TOTAL_1970-2021_nc/v7.0_FT2021_CH4_2021_TOTALS.0.1x0.1.nc")
print(nc_data)

attributes(nc_data$dim)
attributes(nc_data$var)
#EDGAR just has emissions of the CH4 - no subsections like GEPA

lat <- ncvar_get(nc_data, "lat")
nlat <- dim(lat) #check if dimensions are correct from metadata
lon <- ncvar_get(nc_data, "lon")
nlon <- dim(lon) #same reason as above

#both match metadata
print(c(nlon, nlat)) #this is to make sure they have the right info inside

  r <- raster("~/Google Drive/My Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/EDGAR_yearly_inventory/EDGAR_v7.0_TOTAL_1970-2021_nc/v7.0_FT2021_CH4_2021_TOTALS.0.1x0.1.nc")
  #this works for pulling things from an .nc file, but doesn't need to be this complicated!
  #change longitude from 0-360 to -180-180 (https://gis.stackexchange.com/questions/284224/convert-over-360-degree-range-of-coordinates-to-180-longitude-range-in-r/284228#284228)
  Eastern <- extent(c(xmin=0,xmax=180,ymin=-90,ymax=90))
  Western <- extent(c(xmin=180, xmax=360, ymin=-90, ymax=90))
  
  r1 <- crop(r,Eastern)
  r2 <- crop(r,Western)
  
  xmin(r2) <- xmin(r2)-360
  xmax(r2) <- xmax(r2)-360
  
  R <- merge(r1,r2)
  
  # convert the units to nmol/m2/s as units are in kg ch4/m2/s
  K <-  1000*(1/16.04)*(1*10^9)
  
  Final <- R*K 
  #save as png
  png(paste0('EDGAR_CH4_total_2012.png'))
  
  plot(log10(Final), main= 'EDGAR CH4 total emissions 2021', xlab= "longitude",ylab="latitude",
       col=fields::tim.colors(),xlim=c(-78,-74), ylim=c(39,41),
       legend.width=.75, legend.shrink=0.75, horizontal = T,
       legend.args=list(text='CH4 (nmol/m2/s) log scale', side=1, font=2, line=2, cex=0.8))
  
  library(rgdal)
  states <- readOGR('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
  states.p <- spTransform(states,CRSobj=CRS(projection(r)))
  #      spTransform provides transformations btwn datum(s) and conversion btwn projections  
  #      from one unambiguously specified coordinate reference system (CRS) to another 
  lines(states.p,xlim=c(-78,-74), ylim=c(39,41))
  projection(states.p) 
  lines(extent(c(-77,-75.8,39.7,40.5)),lwd=3)
  #close png
  graphics.off()
  
 #________________________________________total______________________________________
  Box_area <-extent(Final)
  Box_area <- extent(c(-77,-75.8,39.7,40.5))
  Box_area <- crop(Final, Box_area)
  Box_sum <- cellStats(Box_area,stat="sum", na.rm=T)
  Box_sum <- signif(Box_sum, 3)
  Box_sum_moles <- Box_sum/(1*10^9) #now mol/m2/s
  Box_sum_moles <-signif(Box_sum_moles, 3)
  
  library(pracma)
  #The location can be input in two different formats, as latitude and longitude in a character string, 
  #e.g. for Frankfurt airport as '50 02 00N, 08 34 14E', 
  #or as a numerical two-vector in degrees (not radians).
  
  #haversine is in km 
  
  latlongvector_1 <- '40 30 00N, 77 00 00W'
  latlongvector_2 <- '40 30 00N, 75 48 00W'
  latlongvector_3 <- '39 42 00N, 75 48 00W'
  latlongvector_4 <- '39 42 00N, 77 00 00W'
  
  box_north_boundary<- haversine(latlongvector_1,latlongvector_2) #top left to top right
  box_east_boundary<- haversine(latlongvector_2,latlongvector_3) #top right to bottom right
  box_south_boundary<- haversine(latlongvector_3,latlongvector_4) #bottom right to bottom left
  box_west_boundary<- haversine(latlongvector_4,latlongvector_1) #bottom left to top left 
  
  box_north_boundary <- signif(box_north_boundary,3)
  box_east_boundary <-  signif(box_east_boundary,3)
  box_south_boundary <- signif(box_south_boundary,3)
  box_west_boundary <-  signif(box_west_boundary,3)
  
  #area is = width * length 
  box_width <- (box_north_boundary+box_south_boundary)/2
  box_length <-(box_east_boundary+box_west_boundary)/2
  box_area <- box_width*box_length #km2
  box_area <- box_area *(1000)^2 #now in m2
  
  box_sum_mol_per_second <- Box_sum_moles * box_area
  box_sum_mol_per_second <-signif(box_sum_mol_per_second, 3)
  print(box_sum_mol_per_second) # = 22900 mol/s 
  #what went wrong? - ask Israel