library("data.table", lib.loc="C:/Users/Hendrik/Documents/R/win-library/3.1")

myFile <- "~/Computational Scientist/Studiemateriaal/Johns Hopkins University Data Science Course Track/4 Exploratory Data Analysis/CourseProject1/household_power_consumption.txt"

#I liked 'fread' best. The file needs to go fully into RAM but it was possible here. 
#When using GB's of data other methods must be used.
  power_raw <- fread(myFile, sep=";", sep2="auto", nrows=-1L, header=TRUE, na.strings="?", 
                       stringsAsFactors=FALSE, verbose=FALSE, autostart=30L, skip=-1L, select=NULL, drop=NULL, 
                       colClasses=NULL,integer64=getOption("datatable.integer64"), # default: "integer64"
                       showProgress=getOption("datatable.showProgress")    # default: TRUE
                       )


#subset the 2880 observations during 1st and 2nd Feb 2007 we'll use for the project. 
#Cast as data.frame because else we'll have trouble with the datetime.
  power <- as.data.frame(power_raw[power_raw$Date == "1/2/2007" | power_raw$Date == "2/2/2007",])
  print("1st and 2nd Feb 2007 data read into a data.frame")

#fix up the dates and times
  datetimes <- paste(power$Date,power$Time)
  datetimes2 <- strptime(datetimes, "%d/%m/%Y%H:%M:%S",tz="") #gives us a List
  power2 <- cbind(datetimes2,power) #add this list as a column in the power2 data.frame


#close and reset any open gfx devices 
#dev.off() <= this was causing trouble: the PNG file turned out white and blank.

#tell R we're plotting to a .PNG file with specified height and width.
  dev.new(png(filename = "plot2.png",width = 480, height = 480, units = "px",bg = "transparent"))
  
  with(power2,plot(Global_active_power ~ datetimes2,col="black",xlab = "",
                  ylab = "Global Active Power (kilowatts)", yaxp = c(0,6,3), type='l', lty=1,lwd=1))
  dev.off()
  print("png made")

#to go back to RStudio graphics device ('plots' tab)
#dev.new(noRStudioGD = FALSE)
