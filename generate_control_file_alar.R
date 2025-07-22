#####______________________________________________________________________#####
#####______________________________________________________________________#####
#####First half of generate_single_control_file ####

#GENERATE CONTROL FILES BASED ON A RECEPTOR
#Which model will you be using? Input it in quotes under the model variable below
model <- "HRRR" 
#load in the ALAR 1 Hz file
args <- commandArgs(trailingOnly = TRUE)

# Retrieve FLIGHT_ID
if (length(args) < 1) {
  stop("FLIGHT_ID is not provided.")
}
FLIGHT_ID <- as.numeric(args[1])
FLIGHT_ID <- FLIGHT_ID

#ADD CSV LOCATION HERE
#FLIGHT_ID WILL BE INCORPORATED INTO THE csv.file IN IN FINAL VERSION
library(dplyr)
csv.file <- paste0('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2025_Flights/WINDS_TEST/7-2-25/2025-07-02_ALAR_1hz.csv', sep="")
ALAR <-read.csv(csv.file)
ALAR <-ALAR %>% select(Time_UTC,Time_local,Latitude_deg,Longitude_deg,HeightAbvMSL_m,heightabvground_m)
ALAR <- ALAR[!is.na(ALAR$Latitude_deg),] 

#need to fix what IGOR PRO 9 did to the date/time in the 1 Hz file
#IGOR PRO 9: The date2secs function returns the number of seconds
#            from midnight on 1/1/1904 to the specified date.
DATE_TIME <- as.POSIXct(ALAR$Time_UTC,tz="UTC",origin="1904-01-01")

#this may need to be shifted for time instead of day
print(paste("This is the starting day/time:", (min(DATE_TIME)), "and this is the last day/time:", (max(DATE_TIME))))
library(lubridate)
max_time <- ymd_hms(max(DATE_TIME))
min_time <- ymd_hms(min(DATE_TIME))
min <- max_time - min_time
min <- round(as.numeric(min, unit = "mins"), 2)
days <-  max_time - min_time
days <- ceiling(round(as.numeric(days, unit = "days"), 2)) #this will round up to the next whole number
length <- days*min
#______________________________________________________________________________#
#Now to work on making this whole function a loop based on each hour
min <- seq(DATE_TIME[1], by = "min", length = (length))
unique_min <- as.character(min)

comparison_date <- as.character(DATE_TIME)
ALAR$COMPARE <- comparison_date

iteration <- data.frame(COMPARE = unique_min)

COMPARE<-merge(iteration,ALAR, by = c("COMPARE"),all=F)
starting_loc <- 1 


options(warn = -1)

print(paste("This is the adjusted starting day/time:", (min(COMPARE$COMPARE)),
            "and this is the adjusted last day/time:", (max(COMPARE$COMPARE))))
print("Now the ALAR cruise and the 1Hz data are aligned properly.")

date <- as.Date(COMPARE$COMPARE)
date <- format(date,"%y-%m-%d")
date <- gsub("-", " ", date)
library("lubridate")
hr <- hour(COMPARE$Time_UTC)
hr <- formatC(hr, width = 2, format = "d", flag = "0")

options(warn = 0)

#______________________________________________________________________________#
#CREATING A DATAFRAME FOR LAT/LONG/HEIGHT/DATE+TIME
options(warn = -1)
j = 1
lat_lon_ht <-data.frame()
while (j <= length(COMPARE[[1]])){
  lat_1 <-COMPARE$Latitude_deg[[j]]
  # lat_1 <-COMPARE$latitude_deg[[j]]
  lat_1 <- formatC(lat_1, format="f", digits=6) 
  
  long_1 <- COMPARE$Longitude_deg[[j]]
  # long_1 <- COMPARE$longitude_deg[[j]]
  long_1 <-formatC(long_1, format="f", digits=6)
  
  ht_1 <- COMPARE$HeightAbvMSL_m[[j]] #set height correctly
  
  date_and_time <- COMPARE$COMPARE[[j]]
  lat_lon_ht <- rbind(lat_lon_ht, c(date_and_time,lat_1, long_1, ht_1), deparse.level = 0)
  
  j=j+1
}
options(warn = 0)
colnames(lat_lon_ht) <-c("date & time", "latitude", "longitude", "height above MSL [m]")
#______________________________________________________________________________#
latitude <-as.numeric(lat_lon_ht$latitude)
latitude <- round(latitude, digits = 3)
longitude <-as.numeric(lat_lon_ht$longitude) 
longitude<- round(longitude, digits = 3)
height <- round(as.numeric(lat_lon_ht$`height above MSL [m]`),2)
#______________________________________________________________________________#
vert_method <- 0 #vertical motion calculation method 
top <- 15300 #top of model domain in m AGL
#pub <- "/pub/archives/" #where is the met files are stored
#ADD IN LOCATION OF MODEL
pub <- paste0("",sep="")
#______________________________________________________________________________#
total_run <- -12 #time background
grab_in_case <- total_run*2 
days_back <- grab_in_case/24
#______________________________________________________________________________#
m = 1
date_for_loop = list()
while( m <= length(COMPARE[[1]])){
  starting_hour <- hr[m] 
  
  NAM_S = 1:24 #gives you all the data from the 24 hours, hourly information
  pull_NAM_S <- 1 #pull for one day of information
  
  NAM12 = seq(0, 24, 3)  #but after 21 UTC you need the next day as it contains info from every 3 hours
  NAM12 <- NAM12[2:8]
  pull_NAM12 <- if(starting_hour <= 20){1}else{2}
  
  HRRR = 1:6 #hourly information
  pull_HRRR <- 4 #pull for one day of information
  hrrr_hours<-c("_00-05", "_06-11","_12-17","_18-23")
  
  input_dat_grid <- if (model == "NAM12"){pull_NAM12}else{pull_NAM_S}
  date_for_loop_pt1 <- as.Date(lat_lon_ht$`date & time`[m]) 
  
  if(model == "HRRR"){
    date_for_loop_pt2 <- (date_for_loop_pt1 + (days_back+1):input_dat_grid) 
    date_for_loop_pt2 <- gsub("-", "", date_for_loop_pt2)
    date_for_loop_pt2 <- paste0(rep(date_for_loop_pt2, each = length(hrrr_hours)), 
                                rep(hrrr_hours, times = length(date_for_loop_pt2)))
  }else{
    date_for_loop_pt2 <- (date_for_loop_pt1 + days_back:input_dat_grid) 
    date_for_loop_pt2 <- gsub("-", "", date_for_loop_pt2)
  }
  date_for_loop[[m]] <- date_for_loop_pt2
  m=m+1
}
date_file_name <- gsub(" ", "-", date)
#create loop later for hrrr/nams/nam 
nams_file<-"_hysplit.t00z.namsa"

hrrr_file<-"_hrrr"
#______________________________________________________________________________#
i <- 1
j=1
output<-list()
output_1 <-data.frame()

while(i <= length(date_for_loop)){
  #this will always happen at the beginning of each iteration
  while(j <= length(date_for_loop[[i]])){
    part_one <-pub
    part_one <-noquote(part_one)
    output_1<-rbind(output_1,part_one)
    part_two <- paste(date_for_loop[[i]][[j]],hrrr_file, sep = "")
    part_two <- list(noquote(part_two))
    output_1<-rbind(output_1,part_two, deparse.level = 0) 
    j=j+1
  } 
  j=1
  output[i]<- output_1
  output_1 <- data.frame()
  i=i+1
}
colnames(output) <-NULL

#______________________________________________________________________________#
directory <- paste0("/gpfs/projects/ShepsonGroup/rchabmeh/control_and_tdump/FLIGHT_",FLIGHT_ID,"/",model,"/", sep="")

writeLines(directory, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/dir",
                             FLIGHT_ID,".txt",sep=""))

n_value <-as.character(length(output))

writeLines(n_value, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/n-value",
                           FLIGHT_ID,".txt",sep=""))

saveRDS(COMPARE, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/compare",
                        FLIGHT_ID,".rds",sep=""))

saveRDS(output, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/output",
                       FLIGHT_ID,".rds",sep=""))

saveRDS(date_file_name, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/date_file",
                               FLIGHT_ID,".rds",sep=""))

saveRDS(date_for_loop, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/date_loop",
                              FLIGHT_ID,".rds",sep=""))

saveRDS(latitude, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/lat",
                         FLIGHT_ID,".rds",sep=""))

saveRDS(longitude, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/long",
                          FLIGHT_ID,".rds",sep=""))
saveRDS(height, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/height",
                          FLIGHT_ID,".rds",sep=""))

saveRDS(lat_lon_ht, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/lat_lon_ht",
                           FLIGHT_ID,".rds",sep=""))

saveRDS(hr, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/hr",
                   FLIGHT_ID,".rds",sep=""))

saveRDS(date, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/date",
                     FLIGHT_ID,".rds",sep=""))


#####______________________________________________________________________#####
#### Second half of generate_single_control_file ####
model <- "HRRR"
args <- commandArgs(trailingOnly = TRUE)
FLIGHT_ID <- as.numeric(args[1])
receptor_number <- as.numeric(args[2])
temp_dir <- args[3]
vert_method <- 0 #vertical motion calculation method 
top <- 15300 #top of model domain in m AGL
starting_loc <- 1

output <- readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/output",
                         FLIGHT_ID,".rds",sep=""))

date <- readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/date",
                       FLIGHT_ID,".rds",sep=""))

hr <- readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/hr",
                     FLIGHT_ID,".rds",sep=""))

lat_lon_ht <-readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/lat_lon_ht",
                            FLIGHT_ID,".rds",sep=""))

date_for_loop <- readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/date_loop",
                                FLIGHT_ID,".rds",sep=""))

date_file_name <- readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/date_file",
                                 FLIGHT_ID,".rds",sep=""))

latitude <- readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/lat",
                           FLIGHT_ID,".rds",sep=""))

longitude <-readRDS(paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/long",
                           FLIGHT_ID,".rds",sep=""))
height <-readRDS(height, paste0("/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/height",
                                FLIGHT_ID,".rds",sep=""))

print(paste("current flight ID is", FLIGHT_ID))
current_cruise <-writeLines(as.character(FLIGHT_ID),"/gpfs/projects/ShepsonGroup/rchabmeh/1Hz_Cruise_files/R_variables/CURRENT_FLIGHT.txt")
total_run <- -12 #time background
#setwd()
directory <- paste0("/gpfs/projects/ShepsonGroup/rchabmeh/control_and_tdump/FLIGHT_",FLIGHT_ID,"/",model,"/", sep="")
if (!dir.exists(directory)) {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
}
setwd(directory)
#______________________________________________________________________________#
#CHANGE K TO BE A VALUE BETWEEN 1 AND LENGTH(COMPARE[[1]])
k=receptor_number
if (k <= length(output)){
  
  your_text_here <- paste(date_file_name[k], hr[k],latitude[k],longitude[k],height[k], sep = "_")
  full_file_name <- capture.output(cat("CONTROL.",your_text_here,".txt", sep=""))
  file_name <- capture.output(cat("tdump.",your_text_here, sep=""))
  #______________________________________________________________________________# 
  #_____ now let's create the text file________
  
  full_file_path <- file.path(temp_dir, full_file_name)
  
  if (!file.exists(full_file_path)) {  
    line_1 <- paste(date[k],hr[k])
    line_2 <- paste(starting_loc)
    line_3 <-paste(lat_lon_ht$latitude[k],lat_lon_ht$longitude[k],lat_lon_ht$`height above MSL [m]`[k])
    #line_4 <-paste(lat_2,long_2,ht_2)
    #line_5 <-paste(lat_3,long_3,ht_3)
    line_6 <- total_run
    line_7 <- vert_method
    line_8 <- top
    line_9 <- length(date_for_loop[[k]])
    line_10 <- directory
    
    #__file time:
    sink(file = full_file_path)
    #file of interest
    cat(line_1,"\n")
    cat(line_2,"\n")
    cat(line_3,"\n")
    #cat(line_4,"\n")
    #cat(line_5,"\n")
    cat(line_6,"\n")
    cat(line_7,"\n")
    cat(line_8,"\n")
    cat(line_9)
    print(as.data.frame(output[[k]],optional =T), row.names = F)
    cat(line_10,"\n")
    cat(file_name) 
    sink(NULL)
    
    cat("File generated:", full_file_name, "\n")
  } else {
    cat("File already exists. Skipping:", full_file_name, "\n")
  }
}
#####______________________________________________________________________#####
#####______________________________________________________________________#####
