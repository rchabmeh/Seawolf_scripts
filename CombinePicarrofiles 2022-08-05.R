{
  #The bracket starting and ending the script are just so that all errors will
  #always be the last thing output.
  
  #assumes all .dat files in the folder should be combined into 1
  
  timefudge = F
  #if you have to manually shift the time, set this to T and change lines 123
  #and 125 below
  olderformat = F
  #older picarro files are formatted a bit differently
  
  #Note that I compared the output from this script to data analyzed by importing
  #directly into excel.  Excel noted the values did not always match, but
  #differences were always to the 10^-11th or further digit.  No value has data
  #beyond the 10^-10th digit.  I believe this is an excel rounding issue.  When
  #rounding all data to 10 decimal points, all data agreed perfectly.
  
  
  if (length(find.package("rstudioapi", quiet = TRUE)) < 1) {
    install.packages("rstudioapi")
    #install package rstudioapi quickly if it is not already installed.
    #Searches for it with find.package which is quiet so it won't
    #fail if there is no such package.  Location folder is always
    #length >1, so if it exists this will be skipped.
  }
  
  library("rstudioapi")
  #load rstudioapi into the current R session
  print("A window should have opened in the background!", quote = FALSE)
  directory <- rstudioapi::selectDirectory(caption = "select where to load Picarro files from")
  setwd(directory)
  #choose and set where you save files to.  Alternatively in Rstudio go to the
  #files tab and manually choose your working directory (navigate to
  #folder->more->set as working directory)
  
  Picarrofiles = list.files(pattern = ".dat")
  #choose the files
  Modecheck = suppressWarnings(read.table(Picarrofiles[1], header = TRUE))
  #check if in EC or MBE mode by reading in 1 file, ignoring warnings (usually
  #caused by an incomplete row at the end). Somewhat variable, but EC files had
  #18 variables. MBE had 21
  
  picarroclasses = c("character", "character", rep("numeric", dim(Modecheck)[2] -
                                                     2))
  #set what the classes of the picarro data columns are going to be.
  #Since it's somewhat variable how many columns there are, BUT date and
  #time should always be first, this will just make the first 2 characters and
  #then make as many numeric class columns as needed until there's 1 per column.
  
  #It does so by looking at the number of columns in the first file, just subtract 2
  #from that to account for date and time.  Repeat the character term "numeric" that
  #many times using rep.
  Picarro = data.frame()
  i = 1
  while (i <= length(Picarrofiles)) {
    Modecheck = read.table(Picarrofiles[i], header = TRUE, fill = TRUE)
    #check the mode of each file, just in case it is swapped mid experiment (post warmup)
    if (dim(Modecheck)[2] != length(picarroclasses)) {
      stop(
        "Picarro mode seems to have swapped at file ",
        i,
        ".\n",
        "Run those pre and post this switch separately, and rename output after each run.",
        call. = TRUE
      )
      #On the offchance the mode changes mid flight, print this error.
    }
    Singlepicarrofile = read.table(
      Picarrofiles[i],
      header = TRUE,
      colClasses = picarroclasses,
      fill = TRUE
    )
    #read the files, save as singlepicarrofile, force classes based on the above
    Picarro = rbind(Picarro, Singlepicarrofile)
    #rbind(x,y) just adds y as new rows in x under the original data in x.
    cat("\rFinished Loading Picarro File",
        i,
        "of",
        length(Picarrofiles),
        "             ")
    #add a simple user update as it progresses.  \r = return line (start at the
    #beginning of the line, overwritting previous output)
    i = i + 1
  }
  #loop through all of the picarro files, adding each files data below
  #all the previous ones
  print(
    paste0(
      "A warning about number of items read simply indicates that when",
      " the Picarro was shut off a row of data was incomplete.  This is",
      " not a problem, and the row will be automatically removed as",
      " Eg. pressure could unintentionally be saved as 1.01 instead of",
      " 1.013E3"
    ),
    quote = FALSE
  )
  Picarro = Picarro[complete.cases(Picarro), ]
  #delete all rows with partial data.  Any blanks trigger this, the whole row is removed
  #because Picarro can mistake a value like 2.194E3 to be 2.19.  That's a problem.
  #
  #works because its defining Picarro as itself, but only points where the full ROW
  #of Picarro passed complete.cases, a function which checks and fails (false) any values
  #which are blank.
  
  ################################################################################
  if (olderformat == T) {
    filedate = Picarro$DATE[1]
    filedate = gsub("/", "_", filedate)
    #pulls the first date in Picarro to be used in naming the output.  Swaps out
    #the format too
    
    Picarro$DATE = as.POSIXct(Picarro$DATE, format = "%m/%d/%y")
    #make the date an actual date format since R won't recognize Picarro's date
    #format since I initially just made it a character format
    Picarro$DATE = format(Picarro$DATE, "%m/%d/%Y")
    #Now format Picarro's date data into the date format for Igor
    
    colnames(Picarro) <- gsub("SPECTRUMID", "species", colnames(Picarro))
    colnames(Picarro) <- gsub("_", "", colnames(Picarro))
    colnames(Picarro) <- gsub("CO2CORR", "CO2_dry", colnames(Picarro))
    colnames(Picarro) <- gsub("DASTEMP.C.", "DASTEMP", colnames(Picarro))
    colnames(Picarro) <- gsub("SOLENOIDVALVES", "SOLENOID_VALVES", colnames(Picarro))
    #replace several old variable names with the newer names used in the Igor
    #code using gsub
    
    Picarro$species[Picarro$species == 10] <- 3
    Picarro$species[Picarro$species == 25] <- 2
    #species values also used to be quite different, but had the same meaning.
    #Adjust to match newer format
  } else{
    filedate = Picarro$DATE[1]
    #pulls the first date in Picarro to be used in naming the output.
    
    Picarro$DATE = as.POSIXct(Picarro$DATE, format = "%Y-%m-%d")
    #make the date an actual date format since R won't recognize Picarro's date
    #format since I initially just made it a character format
    Picarro$DATE = format(Picarro$DATE, "%m/%d/%Y")
    #Now format Picarro's date data into the date format for Igor
  }
  ################################################################################
  #only necessary for flights with the wrong timestamp (e.g., set the clock wrong)
  if (timefudge == T) {
    Picarro$TIME <- as.POSIXlt(Picarro$TIME, format = "%H:%M:%OS")
    Picarro$TIME <- Picarro$TIME - 7 * 60 * 60
    
    dayupdate <- which(Picarro$TIME > (24 - 7))
    Picarro$DATE[dayupdate] <- Picarro$DATE[1]
    
    Picarro$TIME <- format(Picarro$TIME, "%H:%M:%OS")
    #convert the time to posix from character, then subtract 7 hours from it, then
    #finally convert it back to what looks like a character representation for IGOR
    
    #the format is hour:minute:second (O = include fractional seconds)
    
    #also have dayupdate adjust the date accordingly (if midnight was crossed only
    #due to the wrong time being used)
  }
  ################################################################################
  
  Filename <<- paste0("Picarro-", filedate, ".txt")
  #makes a variable filename that is Picarro-DATE.txt with the file's date in the
  #middle
  write.table(
    Picarro,
    file = Filename,
    sep = ",",
    row.names = FALSE,
    quote = FALSE
  )
  #save the ouput data frame as filename, using commas to separate the columns,
  #ignoring all the row names, and removing the quotes around every word (since R
  #puts any words in quotes).
  closeAllConnections()
  #just in case, close the connection to the file (should auto detach after
  #writing the file, but better to be safe).
}