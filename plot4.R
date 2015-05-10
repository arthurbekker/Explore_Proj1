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
par(mfrow=c(2,2)) 
with(dt, {plot(dt$Time, dt$Global_active_power, type="l", xlab="",ylab="Global Active Power")})
with(dt, {plot(dt$Time, dt$Voltage, type="l", xlab="datetime", ylab="Voltage")})
with(dt, {plot(dt$Time, dt$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
          lines(dt$Time, dt$Sub_metering_2, type="l", col="red")
          lines(dt$Time, dt$Sub_metering_3, type="l", col="blue", xlab="", ylab="Energy Sub metering")
          legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red", "blue"), lty=1, lwd=2, cex=0.5, bty="n") })
with(dt, {plot(dt$Time, dt$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")})
dev.print(png, file='plot4.png', width=480, height=480)
dev.off()

