{
  #The bracket starting and ending the script are just so that all errors will 
  #always be the last thing output.
  
  #assumes all .dat files in the folder and all subfolders should be combined into 1
  
  #Note that I compared the output from this script to data analyzed by importing 
  #directly into excel.  Excel noted the values did not always match, but 
  #differences were always to the 10^-11th or further digit.  No value has data 
  #beyond the 10^-10th digit.  I believe this is an excel rounding issue.  When 
  #rounding all data to 10 decimal points, all data agreed perfectly.
  
  ################################################################################
  #load packages
  i <- 1
  packagecheck <- c("rstudioapi","data.table")
  
  while(i<=length(packagecheck)){
    if(length(find.package(packagecheck[i],quiet = TRUE))<1){
      install.packages(packagecheck[i],repos="https://repo.miserver.it.umich.edu/cran/")
      #install package rstudioapi quickly if it is not already installed.
      #Searches for it with find.package which is quiet so it won't 
      #fail if there is no such package.  Location folder is always 
      #length >1, so if it exists this will be skipped.
    }
    i <- i+1
  }
  #go through each item in packagecheck 1 by 1
  
  lapply(packagecheck, library, character.only=TRUE)
  remove(packagecheck,i)
  #load each into the current R session at once with apply functions
  
  #rstudioapi = user friendly, OS independent menus
  #data.table = fast functions for loading in many files
  ################################################################################
  print("A window should have opened in the background!",quote=FALSE)
  directory <- rstudioapi::selectDirectory(caption = "select where to load Picarro files from")
  setwd(directory)
  #choose and set where you save files to.  Alternatively in Rstudio go to the
  #files tab and manually choose your working directory (navigate to
  #folder->more->set as working directory)
  
  Picarrofiles= list.files(pattern=glob2rx("*.dat"), recursive = T, full.names = T)
  #choose the files. Includes both those in the folder selected, and any # folders deeper
  
  #lets organize files by date and time
  sorted <- order(basename(Picarrofiles))
  Picarrofiles <-(Picarrofiles[sorted])
  
  if(length(Picarrofiles)>700){
    cat("\nOver 700 Picarrofiles selected!?  Likely unusably large once combined.  Do you really want to combine all of these?  type (yes/no)")
    user_answer <- readline()
    if(length(grep("y",user_answer))==1){
      cat() #just to avoid a NULL in the console
    }else{
      stop("User said to stop execution.")
    }
  }
  #if you try to load a TON of files, ask the user before proceeding
  
  Example_file=suppressWarnings(read.table(Picarrofiles[1],header=TRUE))
  #check if in EC or MBE mode by reading in 1 file, ignoring warnings (usually
  #caused by an incomplete row at the end). Somewhat variable, but EC files had
  #18 variables. MBE had 21
  
  picarroclasses=c("character","character",rep("numeric",dim(Example_file)[2]-2))
  #set what the classes of the picarro data columns are going to be.  
  #Since it's somewhat variable how many columns there are, BUT date and 
  #time should always be first, this will just make the first 2 characters and
  #then make as many numeric class columns as needed until there's 1 per column.
  
  #It does so by looking at the number of columns in the first file, just subtract 2
  #from that to account for date and time.  Repeat the character term "numeric" that 
  #many times using rep.
  
  #read each file in with columns set from picarroclasses and put them together
  #in a big list, then use rbind to combine each list entry by row
  Picarro <- rbindlist(sapply(Picarrofiles, fread, simplify = FALSE,colClasses=picarroclasses),
                  use.names = TRUE)  
  
  
  
  # Picarro <- do.call(rbind,
  #                    lapply(Picarrofiles,
  #                           FUN = function(x){read.table(x,header=T,colClasses=picarroclasses,fill=T)}))
  
  print(paste0("A warning about number of items read simply indicates that when",
               " the Picarro was shut off a row of data was incomplete.  This is",
               " not a problem, and the row will be automatically removed as",
               " Eg. pressure could unintentionally be saved as 1.01 instead of",
               " 1.013E3"),quote=FALSE)
  Picarro=Picarro[complete.cases(Picarro),]
  #delete all rows with partial data.  Any blanks trigger this, the whole row is removed
  #because Picarro can mistake a value like 2.194E3 to be 2.19.  That's a problem.
  #
  #works because its defining Picarro as itself, but only points where the full ROW
  #of Picarro passed complete.cases, a function which checks and fails (false) any values
  #which are blank.
  
  ################################################################################
  filedate=Picarro$DATE[1]
  #pulls the first date in Picarro to be used in naming the output.
  
  Picarro$DATE=as.POSIXct(Picarro$DATE,format="%Y-%m-%d")
  #make the date an actual date format since R won't recognize Picarro's date
  #format since I initially just made it a character format
  Picarro$DATE=format(Picarro$DATE,"%m/%d/%Y")
  #Now format Picarro's date data into the date format for Igor
  
  ################################################################################
  
  Filename<<-paste0("Picarro-",filedate,".txt")
  #makes a variable filename that is Picarro-DATE.txt with the file's date in the 
  #middle
  write.table(Picarro,file=Filename,sep=",",row.names=FALSE,quote = FALSE)
  #save the ouput data frame as filename, using commas to separate the columns, 
  #ignoring all the row names, and removing the quotes around every word (since R
  #puts any words in quotes).
  closeAllConnections()
  #just in case, close the connection to the file (should auto detach after
  #writing the file, but better to be safe).
}
