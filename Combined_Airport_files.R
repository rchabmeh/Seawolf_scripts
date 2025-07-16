
{
  #The bracket starting and ending the script are just so that all errors will 
  #always be the last thing output.
  
  if(length(find.package("rstudioapi",quiet = TRUE))<1){
    install.packages("rstudioapi")
    #install package rstudioapi quickly if it is not already installed.
    #Searches for it with find.package which is quiet so it won't 
    #fail if there is no such package.  Location folder is always 
    #length >1, so if it exists this will be skipped.
  }
  
  library("rstudioapi")
  #load rstudioapi into the current R session
  print("A window should have opened in the background!",quote=FALSE)
  directory <- rstudioapi::selectDirectory(caption = "select where to load Airport_winds files from")
  setwd(directory)
  #choose and set where you save files to.  Alternatively in Rstudio go to the
  #files tab and manually choose your working directory (navigate to
  #folder->more->set as working directory)
  
  #glob2rx converts Linex code to R code! 
  #(Kris knows how to do this in Linex)
  Airport_windsfiles= list.files(pattern=glob2rx('*.csv'))
  
  #how to subset [] or $ or subset()
  
  Airport_winds= read.csv(Airport_windsfiles[1], header= T, skip= 1)
  i=2
  while(i<=length(Airport_windsfiles)){
    SingleAirport_windsfile=read.csv(Airport_windsfiles[i], header= T, skip= 1)
    #read the files, save as singleAirport_windsfile, force classes based on the above
    
    Airport_winds=rbind(Airport_winds[ ,c("DATE","LATITUDE","LONGITUDE","NAME","WND")],
                        SingleAirport_windsfile[ ,c("DATE","LATITUDE","LONGITUDE","NAME","WND")])
    #rbind(x,y) just adds y as new rows in x under the original data in x.
    cat("\rFinished Loading Airport_winds File",i,"of",length(Airport_windsfiles),"             ")
    #add a simple user update as it progresses.  \r = return line (start at the
    #beginning of the line, overwriting previous output)
    i=i+1
  }
  #loop through all of the Airport_winds files, adding each files data below
  
  #let's add Excel equations- can use cbind (combine by columns) or by #
  #Excel code: 
  #   =IF(OR(LEFT($K3,3)="999",RIGHT(LEFT($K3,4),1)=3,RIGHT(LEFT($K3,4),1)=7),"",LEFT($K3,3))	 
  #== 	JFK_winddirection
  #   =IF(OR(LEFT(RIGHT(K3,6),4)="9999",RIGHT(K3,1)=3,RIGHT(K3,1)=7),"",LEFT(RIGHT(K3,6),4)/10)	
  #== 	JFK_windspeed	
  #
  #Date fix
  Date_part <-substring(Airport_winds[ ,1],1,10) 
  Date_part <-as.Date(Date_part)
  Date_part <-format(Date_part,'%m/%d/%Y')
  Airport_winds <-cbind(Airport_winds, Date_part)
  
  #Time fix
  Time_part <-substring(Airport_winds[ ,1],12,999)
  Airport_winds <-cbind(Airport_winds, Time_part)
  
  #Winds fix
  #Typecode we want to keep: N = normal 

  
  Wind_direction <-substring(Airport_winds[ ,5],1,3) 
  Wind_direction[Wind_direction==999] = NaN
  
  Wind_error <-substring(Airport_winds[ ,5], 5,5)
  #2 = SUSPECT
  #3 = ERROR
  #6 = SUSPECT NCEI (NCEI=where it was downloaded from )
  #7 = ERROR NCEI

  Wind_direction[Wind_error%in%c(3,7,2,6)] = NaN
  # %in% is anything in A = B (will be set to NaN if true)

  Wind_speed <-substring(Airport_winds[ ,5],9,12) 
  Wind_speed[Wind_speed==9999] = NaN
  Speed_error <-substring(Airport_winds[ ,5], 14,14)
  #2 = SUSPECT
  #3 = ERROR
  #6 = SUSPECT NCEI (NCEI=where it was downloaded from )
  #7 = ERROR NCEI
  Wind_speed[Speed_error%in%c(3,7,2,6)] = NaN
  Wind_speed <-as.numeric(Wind_speed)
  #now to get winds in m/s
  Wind_speed <- Wind_speed/10
  
  #now we only have data that's good wind data
  Typecode <-substring(Airport_winds[ ,5],7,7) 
  Wind_direction[Typecode!="N"] = NaN
  Wind_speed[Typecode!="N"] = NaN
  
  #append to table now!
  Airport_winds <-cbind(Airport_winds, Wind_direction,Wind_speed)
  #make the table just the columns we want
  Airport_winds <- (Airport_winds[ ,c(2:4,6:9)])
  #making sure we just have NaN, not NA and NaN
  Airport_winds[is.na(Wind_speed),7]=NaN
  
  filedate <- substring(Airport_winds[1,4],7,10) 
  Filename<<-paste0("Airport_winds-",filedate,".txt")
  #makes a variable filename that is Airport_winds-DATE.csv with the file's date in the 
  #middle
  write.table(Airport_winds,file=Filename,sep="\t",row.names=FALSE,quote = FALSE, col.names = T)
  #save the ouput data frame as filename, using commas to separate the columns, 
  #ignoring all the row names, and removing the quotes around every word (since R
  #puts any words in quotes).
  closeAllConnections()
  #just in case, close the connection to the file (should auto detach after
  #writing the file, but better to be safe).
}
