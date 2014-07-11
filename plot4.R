library("data.table", lib.loc="C:/Users/Hendrik/Documents/R/win-library/3.1")

myFile <- "~/Computational Scientist/Studiemateriaal/Johns Hopkins University Data Science Course Track/4 Exploratory Data Analysis/CourseProject1/household_power_consumption.txt"

#I liked 'fread' best. The file needs to go fully into RAM but it was possible here. 
#When using GB's of data other methods must be used.
  power_raw <- fread(myFile, sep=";", sep2="auto", nrows=-1L, header=TRUE, na.strings="?", 
                       stringsAsFactors=FALSE, verbose=FALSE, autostart=30L, skip=-1L, select=NULL, drop=NULL, 
                       colClasses=NULL,integer64=getOption("datatable.integer64"), # default: "integer64"
                       showProgress=getOption("datatable.showProgress")    # default: TRUE
                       )


#subset the 2880 observations during 1st and 2nd Feb 2007 we'll use for the project
power <- as.data.frame(power_raw[power_raw$Date == "1/2/2007" | power_raw$Date == "2/2/2007",])
print("1st and 2nd Feb 2007 data read into a data.frame")

#fix up the dates and times
datetimes <- paste(power$Date,power$Time)
datetimes2 <- strptime(datetimes, "%d/%m/%Y%H:%M:%S",tz="") #gives us a List
power2 <- cbind(datetimes2,power) #add this list as a column in the power2 data.frame

#tell R we're plotting to a .PNG file with specified height and width.
dev.new(png(filename = "plot4.png",width = 480, height = 480, units = "px",bg = "transparent"))
#setting up a 2x2 plot
par(mfrow = c(2,2))

#TOP LEFT: same as PLOT2

with(power2,plot(Global_active_power ~ datetimes2,col="black",xlab = "",
                 ylab = "Global Active Power (kilowatts)", yaxp = c(0,6,3), type='l', lty=1,lwd=1))
print("TOP LEFT MADE.")



#TOP RIGHT

with(power2,plot(Voltage ~ datetimes2,col="black",xlab = "datetime",
                 ylab = "Voltage", yaxp = c(234,246,6), type='l', lty=1,lwd=1))

print("TOP RIGHT MADE.")
#BOTTOM LEFT: same as PLOT3 with a minor change in legend
with(power2,plot(Sub_metering_1 ~ datetimes2,col="black",xlab = "",
                 ylab = "Energy sub metering", yaxp = c(0,30,3), type='l', lty=1,lwd=1))

with(power2,points(Sub_metering_2 ~ datetimes2,col="red",xlab = "",
                   ylab = "", yaxp = c(0,30,3), type='l', lty=1,lwd=1))

with(power2,points(Sub_metering_3 ~ datetimes2,col="blue",xlab = "",
                   ylab = "", yaxp = c(0,30,3), type='l', lty=1,lwd=1))
#Mimicking the legend.    
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1,col=c("black","red","blue"),bty="n")

print("BOTTOM LEFT MADE.")

#BOTTOM RIGHT : global reactive power  ~ time.
#Plotted it as best as I could see
with(power2,plot(Global_reactive_power~ datetimes2,col="black",xlab = "datetime",
                 ylab = "Global_reactive_power", yaxp = c(0,0.5,5), type='l', lty=1,lwd=1))
print("BOTTOM RIGHT MADE.")

dev.off()