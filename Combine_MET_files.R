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
  directory <- rstudioapi::selectDirectory(caption = "select where to load MET files from")
  setwd(directory)
  #choose and set where you save files to.  Alternatively in Rstudio go to the
  #files tab and manually choose your working directory (navigate to
  #folder->more->set as working directory)
  
  #glob2rx converts Linex code to R code! 
  #(Kris knows how to do this in Linex)
  METfiles= list.files(pattern=glob2rx('met1*.txt'), recursive = T, full.names = T)
  #  glob2rx('met1*.txt')     ==        "^met1.*\\.txt$"
  
  MET= data.frame()
  i=1
  while(i<=length(METfiles)){
    SingleMETfile=read.table(METfiles[i])
    #read the files, save as singleMETfile, force classes based on the above
    
    #let's make sure the dates are correct! (There is an issue with some SeaWolf dates!)
    MET_date <-substring(text = basename(METfiles),6,15)
    MET_date <-as.Date(MET_date)
    MET_date <-format(MET_date,'%m/%d/%Y')
    SingleMETfile[ ,'V2'] <- MET_date[i]
    
    MET=rbind(MET,SingleMETfile)
    #rbind(x,y) just adds y as new rows in x under the original data in x.
    cat("\rFinished Loading MET File",i,"of",length(METfiles),"             ")
    #add a simple user update as it progresses.  \r = return line (start at the
    #beginning of the line, overwriting previous output)
    i=i+1
  }
  #loop through all of the MET files, adding each files data below
  filedate <- gsub("/","-",MET_date[1])
  Filename<<-paste0("MET-",filedate,".txt")
  #makes a variable filename that is MET-DATE.txt with the file's date in the 
  #middle
  write.table(MET,file=Filename,sep="\t",row.names=FALSE,quote = FALSE, col.names = F)
  #save the ouput data frame as filename, using commas to separate the columns, 
  #ignoring all the row names, and removing the quotes around every word (since R
  #puts any words in quotes).
  closeAllConnections()
  #just in case, close the connection to the file (should auto detach after
  #writing the file, but better to be safe).
}
