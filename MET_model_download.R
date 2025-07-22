#GRABBING MET FILES 
#code adapted from /gpfs/projects/ShepsonGroup/khajny/Scripts/MET_codes/Metgrabber_KH_fx.r
metlist <-c("hrrr","nams")
#ftp://arlftp.arlhq.noaa.gov/archives/
args <- commandArgs(trailingOnly = TRUE)
# Retrieve FLIGHT_ID
if (length(args) < 1) {
  stop("FLIGHT_ID is not provided.")
}
FLIGHT_ID <- as.numeric(args[1])

local.metpath <- (paste0("/gpfs/projects/ShepsonGroup/rchabmeh/met_models/HRRR/FLIGHT_",FLIGHT_ID,sep=""))
met.bank <- list.files(local.metpath)
#FLIGHT_ID WILL BE INCORPORATED INTO THE flight_of_interest IN IN FINAL VERSION
flight_of_interest <- read.csv(paste0('/Users/reneechabot-mehlin/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/ALAR-Flights/2025_Flights/WINDS_TEST/7-2-25/2025-07-02_ALAR_1hz.csv'
                                      , sep="")
)
flight_of_interest <- flight_of_interest[!is.na(flight_of_interest$Latitude_deg),]
DATE_TIME <- as.POSIXct(flight_of_interest[[1]],tz="UTC",origin="1904-01-01")
flight_dates <- unique(as.Date(DATE_TIME))
days <- length(table(flight_dates))
hours <- 12
length <- days*hours
flight_length_days <- data.frame(1:days)
first_day <-1
last_day <-as.numeric(tail(flight_length_days,1))
start.time <- flight_dates[first_day]-2
end.time <- flight_dates[last_day]+1
time.range <- as.Date(seq(from=start.time,to=end.time, by=1))
year <- format(time.range,"%Y")
shortyear <- substr(year,3,4)
month <- format(time.range,"%m")
day <- format(time.range,"%d")
HRRR_hours <- c("00-05", "06-11", "12-17", "18-23")
hrrr_pt1 <-list()              
i=1
while (i <= length(time.range)){
  hrrr_pt1 <-rbind(hrrr_pt1, paste0(year[i],month[i],day[i],"_",sep=""))
  i=i+1
}
m = 1
date_for_loop = list()
while( m <= length(time.range)){
  date_for_loop_pt1 <- hrrr_pt1[m] 
  date_for_loop_pt1 <- paste0(rep(date_for_loop_pt1, each = length(HRRR_hours)), 
                              rep(HRRR_hours, each = length(date_for_loop_pt1)),"_hrrr",sep="")
  date_for_loop[[m]] <- date_for_loop_pt1
  m=m+1
}
hrrr.strings <- unlist(date_for_loop)
nams.strings <- paste0(year,month,day,"_hysplit.t00z.namsa")
string.options <-c(hrrr.strings,nams.strings)
#grep to find indices with MET name in them
combined_pattern <- paste(metlist, collapse = "|")
met.strings <- grep(combined_pattern, string.options, ignore.case = TRUE)
#subset them from met strings
met.strings <-string.options[met.strings]
#use unique to remove duplicates for monthly files
met.strings <- unique(met.strings)
for(MET in metlist) {
  options(timeout=1000)
  url <- paste0("ftp://arlftp.arlhq.noaa.gov/archives/",MET,"/")
  # Go get the met
  for(check in 1:length(met.strings)){
    if(length(which(met.bank==met.strings[check]))<1){
      # If you dont have the file in metbank Go get it
      cat(paste("Check Failed, downloading ",met.strings[check],"\n"))
      download.file(url=paste(url,met.strings[check],sep=""),destfile = paste(local.metpath,"/",met.strings[check],sep=""))
    }
    if(length(which(met.bank==met.strings[check]))>0){
      # If you do have the file in metbank say so
      cat(paste("Found required met file:  ",met.strings[check],"\n",sep=""))
    }
  }
}


