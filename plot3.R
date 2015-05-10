#Will be using sqldf library to extract only the rows wanted for analysis
library(sqldf)
#------------- Extract Data
#provide file name and attributes for the file
fl <- file("household_power_consumption.txt")
attr(fl, "file.format") <- list(sep = ";", header = TRUE) 
#extract rows for 2/1/2007 and 2/2/2007, as the dates are in dd/mm/yyyy format, use appropriate
dt <- sqldf("select * from fl where Date = '1/2/2007' or Date = '2/2/2007'")

#--------- Set column types
dt$Date <- as.Date(dt$Date, "%d/%m/%Y")
dt$DateTime <- paste(dt$Date,dt$Time)
dt$Time <- strptime(dt$DateTime, "%d/%m/%Y %H:%M:%S")

#--------- Create graph
with(dt, {plot(dt$Time, dt$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
          lines(dt$Time, dt$Sub_metering_2, type="l", col="red")
          lines(dt$Time, dt$Sub_metering_3, type="l", col="blue")
          legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red", "blue"), lty=1, lwd=2, cex=0.75)})
dev.print(png, file='plot3.png', width=480, height=480)
dev.off()

