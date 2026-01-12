receptors <- readRDS("/Users/reneechabot-mehlin/Desktop/Seawulf_files/receptors.RData")
actual_files <- list.files("/Users/reneechabot-mehlin/Desktop/Seawulf_files/nc_files", pattern = "\\.nc$", full.names = FALSE)
time_str <- format(as.POSIXct(receptors$time, tz = "UTC"),
                   "%Y%m%d%H%M")
expected_files <- paste0(
  time_str, "_",
  receptors$lon, "_",
  receptors$lat, "_",
  receptors$ht, "_foot.nc"
)
output_dir <- "/Users/reneechabot-mehlin/Desktop/Seawulf_files/nc_files"

receptors$file_exists <- file.exists(
  file.path(output_dir, expected_files)
)

# View any missing
receptors[!receptors$file_exists, ]

extra_files <- setdiff(actual_files, expected_files)
extra_files
files_to_delete <- file.path(output_dir, extra_files)

file.remove(files_to_delete)
