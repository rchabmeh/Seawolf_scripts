#GENERATE CONTROL FILES BASED ON A RECEPTOR
#load in the Seawolf 1 Hz file
Seawolf <-read.csv('/Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Cruises/Cruise 24 (10 11 23-11 7 23)/1904-01-01__1904-01-01_Seawolf_1hz.csv')
#Seawolf <- Seawolf[!is.na(Seawolf$Latitude_deg),] 
#Seawolf <- na.omit(Seawolf)
Seawolf <- Seawolf[!is.na(Seawolf$Latitude_deg),] 

#need to fix what IGOR PRO 9 did to the date/time in the 1 Hz file
#IGOR PRO 9: The date2secs function returns the number of seconds
#            from midnight on 1/1/1904 to the specified date.
#DATE_TIME <- as.POSIXct(Seawolf$Time_UTC,tz="UTC",origin="1904-01-01")
DATE_TIME <- as.POSIXct(Seawolf$Time_UTC,tz="UTC",origin="1904-01-01")
days <- as.numeric(round((max(DATE_TIME)-min(DATE_TIME)),0))
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
COMPARE$Date <- as.Date(COMPARE$COMPARE)

df1 <-COMPARE[COMPARE$Date >= "2023-10-11" & COMPARE$Date <= "2023-10-14", ]
df2 <-COMPARE[COMPARE$Date >= "2023-10-15" & COMPARE$Date <= "2023-10-17", ]
df3 <-COMPARE[COMPARE$Date >= "2023-11-04" & COMPARE$Date <= "2023-11-05", ]
library("lubridate")
df1$hour <- hour(df1$Time_UTC)
df2$hour <- hour(df2$Time_UTC)
df3$hour <- hour(df3$Time_UTC)

df1 <- df1[-c(71:79), ]
df2 <- df2[-c(52), ]
df3 <- df3[-c(22:45), ]

combined_df <- rbind(df1, df2, df3)


combined_df$Time_All <- as.POSIXct(combined_df$Time_UTC,tz="UTC",origin="1904-01-01")



plot(combined_df$Time_All, combined_df$CO2_dry, pch=20)
plot(combined_df$Time_All, combined_df$CH4_dry, pch=20)











