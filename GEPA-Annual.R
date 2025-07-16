
setwd("~/Google Drive/My Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/GEPA_yearly_inventory")
library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
nc_data <- nc_open("~/Google Drive/My Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/inventories/GEPA_yearly_inventory/Gridded_EPA_2012/GEPA_Annual.nc")
print(nc_data)

attributes(nc_data$dim)
attributes(nc_data$var)

lat <- ncvar_get(nc_data, "lat")
nlat <- dim(lat) #check if dimensions are correct from metadata
lon <- ncvar_get(nc_data, "lon")
nlon <- dim(lon) #same reason as above

#both match metadata

print(c(nlon, nlat)) #this is to make sure they have the right info inside
#___________________________________plots____________________________________________________
                  #1:22
for (sector_name in 1:22) {
  sector_name <- attributes(nc_data$var) $names [sector_name]
  
  r <- raster('~/Downloads/Gridded Methane Data/GEPA_Annual.nc', varname=sector_name)
  
  # convert the units to nmol/m2/s as units are in molecule/cm2*s
  c <- ((1/(6.02*10^23)) * (1*10^9))/((100)^2) 
  
  Final <- r*c
  #save as png
  png(paste0(sector_name, '.png'))
  
  plot(log10(Final), main= sector_name, xlab= "longitude",ylab="latitude", col=fields::tim.colors(), xlim=c(-78,-74), ylim=c(39,41),
       legend.width=.75, legend.shrink=0.75, horizontal = T,
       legend.args=list(text='CH4 (nmol/m2/s) log scale', side=1, font=2, line=2, cex=0.8))
  #changed zlim as I fixed the conversion
  library(rgdal)
  states <- readOGR('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/My Drive/Shepson Group Drive/General Inventories and Shapefiles/Shapefiles/cb_2021_us_state_500k/cb_2021_us_state_500k.shp')
  states.p <- spTransform(states,CRSobj=CRS(projection(r)))
  #      spTransform provides transformations btwn datum(s) and conversion btwn projections  
  #      from one unambiguously specified coordinate reference system (CRS) to another 
  lines(states.p,xlim=c(-85,-65), ylim=c(34,46))
  projection(states.p) 
  lines(extent(c(-77,-75.8,39.7,40.5)),lwd=3)
  #close png
  graphics.off()
}

#________________________________csv of area sum_____________________________________________
Sector_Box_Concentration <- data.frame(1:3)
rownames(Sector_Box_Concentration) <-(c("type", "nmol/m2/s", "mol/m2/s"))
for (sector_name in 1:22) {
  sector_name <- attributes(nc_data$var) $names [sector_name]
  
  r <- raster('~/Downloads/Gridded Methane Data/GEPA_Annual.nc', varname=sector_name)
  
  #this works for pulling things from an .nc file, but doesn't need to be this complicated!
  #     r <- raster(nc.array.manure, xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
  #look at it before flipping
  #     r <-flip(r,direction='y')
  #     r <- flip(r, direction='x')
  #units start as molecule/cm2*s
  # convert the units to nmol/m2/s as units are in molecule/cm2*s
  c <- ((1/(6.02*10^23)) * (1*10^9))/((100)^2) 
  
  Final <- r*c
  
  sector_name_e <-extent(Final)
  sector_name_e <- extent(c(-77,-75.8,39.7,40.5))
  sector_name_e <- crop(Final, sector_name_e)
  Box_sum <- cellStats(sector_name_e,stat="sum", na.rm=T)
 # print(Box_sum) #units are in nmol/m2/s
  Box_sum <- signif(Box_sum, 3)
  Box_sum_moles <- Box_sum/(1*10^9) #now mol/m2/s
  Box_sum_moles <-signif(Box_sum_moles, 3)
  Sector_Box_Concentration <-cbind(Sector_Box_Concentration ,c(sector_name,Box_sum,Box_sum_moles))
}
  Sector_Box_Concentration <-subset(Sector_Box_Concentration[1:3,2:23])
  write.csv(Sector_Box_Concentration,file = "Sector_Box_Concentration.csv")
#_____________________________removing area_________________________________________________
  mole_per_second_ch4 <-data.frame(1:2)
  rownames(mole_per_second_ch4) <- (c("type", "moles/second"))
  
 for (sector_name in 1:22) {
   sector_name <- attributes(nc_data$var) $names [sector_name]
   
   r <- raster('~/Downloads/Gridded Methane Data/GEPA_Annual.nc', varname=sector_name)
  
   c <- ((1/(6.02*10^23)) * (1*10^9))/((100)^2) 
   
    Final <- r*c
   
   sector_name_e <-extent(Final)
   sector_name_e <- extent(c(-77,-75.8,39.7,40.5))
   sector_name_e <- crop(Final, sector_name_e)
   Box_sum <- cellStats(sector_name_e,stat="sum", na.rm=T)
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
   
   mole_per_second_ch4 <-cbind(mole_per_second_ch4 , c(sector_name,box_sum_mol_per_second))
 }
 mole_per_second_ch4 <-subset(mole_per_second_ch4[1:2,2:23])
 write.csv(mole_per_second_ch4,file = "Sector_Box_Concentration_mol_per_sec.csv")
 # total box sum of all sectors: 0.0001936183 mol/s
 # 19.4 mmol/s CH4
 #_______________________________________________________________________________________
 
  