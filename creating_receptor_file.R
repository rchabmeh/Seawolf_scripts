final_traj_file <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/24final_traj.RData")
first_rows_df <- do.call(rbind, lapply(final_traj_file, function(x) x[1, , drop = FALSE]))
df <- first_rows_df[ , -c(1:9,13)]
names(df)[1] <- "lat"
names(df)[2] <- "lon"
names(df)[3] <- "ht"
names(df)[4] <- "time"

df$time <- as.POSIXct(df$time, tz = "America/New_York")
attr(df$time, "tzone") <- "UTC"

df <- df[ , c(ncol(df), 1:(ncol(df) - 1))]

saveRDS(df, "/Users/reneechabot-mehlin/Desktop/Seawulf_files/receptors24.RData")