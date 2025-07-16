#GENERATE CONTROL FILES BASED ON A RECEPTOR
#load in the Seawolf 1 Hz file
Seawolf <-read.csv("/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 4 (4-5-22 to 4-16-22)/2022-04-07__2022-04-16_Seawolf_1hz.csv")
Seawolf <- na.omit(Seawolf)

#need to fix what IGOR PRO 9 did to the date/time in the 1 Hz file
#IGOR PRO 9: The date2secs function returns the number of seconds
#            from midnight on 1/1/1904 to the specified date.
DATE_TIME <- as.POSIXct(Seawolf$Time_UTC,tz="UTC",origin="1904-01-01")
days <- 7
hours <- 24
length <- days*hours
#______________________________________________________________________________#
#Now to work on making this whole function a loop based on each hour
hours <- seq(DATE_TIME[1], by = "hours", length = (length))
unique_hour <- as.character(hours)

comparison_date <- as.character(DATE_TIME)
Seawolf$COMPARE <- comparison_date

iteration <- data.frame(COMPARE = unique_hour)

COMPARE<-merge(iteration,Seawolf, by = c("COMPARE"),all=F)

starting_loc <- 1 

date <- as.Date(COMPARE$COMPARE)
date <- format(date,"%y-%m-%d")
date <- gsub("-", " ", date)

library("lubridate")
hr <- hour(COMPARE$COMPARE)
hr <- formatC(hr, width = 2, format = "d", flag = "0")
#______________________________________________________________________________#
#CREATING A DATAFRAME FOR LAT/LONG/HEIGHT/DATE+TIME
j = 1
lat_lon_ht <-data.frame()
while (j <= length(COMPARE[[1]])){
  lat_1 <-COMPARE$Latitude_deg[[j]]
  lat_1 <- formatC(lat_1, format="f", digits=6) 
  
  long_1 <- COMPARE$Longitude_deg[[j]]
  long_1 <-formatC(long_1, format="f", digits=6)
  
  ht_1 <- rep.int(c(11),j) #m AGL; set as a constant (varies originally bc of waves)
  
  date_and_time <- COMPARE$COMPARE[[j]]
  lat_lon_ht <- rbind(lat_lon_ht, c(date_and_time,lat_1, long_1, ht_1), deparse.level = 0)
  
  j=j+1
}
colnames(lat_lon_ht) <-c("date & time", "latitude", "longitude", "height of inlet [m]")
#______________________________________________________________________________#
latitude <-as.numeric(lat_lon_ht$latitude)
latitude <- round(latitude, digits = 3)
longitude <-as.numeric(lat_lon_ht$longitude) 
longitude<- round(longitude, digits = 3)
#______________________________________________________________________________#
vert_method <- 0 #vertical motion calculation method 
top <- 15300 #top of model domain in m AGL
#pub <- "/pub/archives/" #where is the met files are stored 
pub <- "/Users/reneechabot/Desktop/met_models/NAMS/CRUISE_4/"
#______________________________________________________________________________#
total_run <- -24 #time background
grab_in_case <- total_run*2 
days_back <- grab_in_case/24

print("Which model will you be using? Input it in quotes under the model variable below.",quote=F)
#model <- "nam12" #model name that's used 
model <- "NAMS"
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
  
  #NUMBER nextfile mfile OF INPUT DATA GRIDS
  input_dat_grid <- if (model == "nam12"){pull_NAM12}else if(model == "hrrr"){pull_HRR}else{pull_NAM_S}
  
  date_for_loop_pt1 <- as.Date(lat_lon_ht$`date & time`[m]) 
  #from 00-03 hours in a date it is the same value as the day before (04-20)
  #date_for_loop[[18]] == lat_lon_ht$'date & time'[18] NOT WHAT I'M LOOKING FOR
  #date_for_loop[[14]]=/= lat_lon_ht$'date & time'[18] WHAT I'M LOOKING FOR 
  
  #iteration 14 is the problem
  date_for_loop_pt2 <- (date_for_loop_pt1 + days_back:input_dat_grid) 
  date_for_loop_pt2 <- gsub("-", "", date_for_loop_pt2)
  
  date_for_loop[[m]] <- date_for_loop_pt2
  
  m=m+1
}
date_file_name <- gsub(" ", "-", date)


#create loop later for hrrr/nams/nam 
nams_file<-"_hysplit.t00z.namsa"
#______________________________________________________________________________#
i <- 1
j=1
output<-list()
output_1 <-data.frame()
#need to change this section__________________________________9/26____________
while(i <= length(date_for_loop)){
  #this will always happen at the beginning of each iteration
  while(j <= length(date_for_loop[[i]])){
    part_one <-pub
    part_one <-noquote(part_one)
    output_1<-rbind(output_1,part_one)
    part_two <- paste(date_for_loop[[i]][[j]],nams_file, sep = "")
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
#setwd()
directory <- "/Users/reneechabot/hysplit/working/cruise_4_nams_control_files"
setwd(directory)
#______________________________________________________________________________#
#CHANGE K TO BE A VALUE BETWEEN 1 AND LENGTH(COMPARE[[1]])
args <- commandArgs(trailingOnly = TRUE)
receptor_number <- as.numeric(args[1])

k=receptor_number
if (k <= length(COMPARE[[1]])){
  
  your_text_here <- paste(date_file_name[k], hr[k],latitude[k],longitude[k],"11", sep = "_")
  full_file_name <- capture.output(cat("CONTROL.",your_text_here,".txt", sep=""))
  file_name <- capture.output(cat("tdump.",your_text_here, sep=""))
#______________________________________________________________________________# 
  #_____ now let's create the text file________
  
  line_1 <- paste(date[k],hr[k])
  line_2 <- paste(starting_loc)
  line_3 <-paste(lat_lon_ht$latitude[k],lat_lon_ht$longitude[k],"11.1")
  #line_4 <-paste(lat_2,long_2,ht_2)
  #line_5 <-paste(lat_3,long_3,ht_3)
  line_6 <- total_run
  line_7 <- vert_method
  line_8 <- top
  line_9 <- input_dat_grid
  line_10 <- "/Users/reneechabot/hysplit/working/cruise_4_nams_tdump_files" #this will change too
  
  #__file time:
  sink(file = full_file_name)
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
}

#download latest version of HYSPLIT
#download name files for path and in general 
#AFTER MODIFICATIONS:
#run control R file in my terminal without inputs to generate same # of files
#next to have an input as a number(integer) that is the row number of the receptor file
