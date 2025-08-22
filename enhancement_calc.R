##Finding enhancements in ship concentration: observed and modeled
##### Load in .csv files ####
#SHIP ALL 5 MIN AVG
ship_data <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/cruise24_info_5_min_avg_ALL.csv")

#TOWERS CO2- MAKE THIS AUTOMATIC PROB BASED ON CRUISE #
LEW_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_LEW.csv")
BVA_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_BVA.csv")
TMD_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_TMD.csv")
WNJ_co2 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_co2_WNJ.csv")

#TOWERS CH4- MAKE THIS AUTOMATIC PROB BASED ON CRUISE #
LEW_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_LEW.csv")
BVA_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_BVA.csv")
TMD_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_TMD.csv")
WNJ_ch4 <- read.csv("/Users/reneechabot-mehlin/Desktop/towers/final_csv_files/merged_ch4_WNJ.csv")

##### LOOK @ TRAJECTORY MAP TO SEE WHICH TOWERS ARE YOUR BACKGROUND #####
background_towers <- c("BVA", "TMD", "WNJ") #"LEW"

##### Set time limit for model comparison #####
start_date <- as.Date("2023-10-12")
end_date <- as.Date("2023-10-17")

ship_data$date <- as.Date(ship_data$Date_UTC)
ship_time_filtered_data <- ship_data[ship_data$date >= start_date & ship_data$date <= end_date, ]

#### Set to 3 hour average or maybe load in the 3 hour avg dataset beforehand in part 1 ####






