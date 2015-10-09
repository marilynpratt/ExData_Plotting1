# Change working directory to your local workspace
getwd()
#install.packages("sqldf")
library("sqldf")
# Url where zip file(containing data set) for power consumption is located
if (!file.exists("household_power_consumption.txt")){
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Download copy of zip file locally (windows)
download.file(fileUrl, destfile="exdata-data-household_power_consumption.zip", method="wininet")
# Unzip the text data file locally
unzip("exdata-data-household_power_consumption.zip",overwrite = TRUE, "household_power_consumption.txt")
unlink("exdata-data-household_power_consumption.zip")
}
#assign the file connection to the power consumption text file and call it pwrfile-assigning to named variable pf
pwrfile <- "household_power_consumption.txt"
pf <- file(pwrfile)

#use sqldf() to read in the dates February 1-2, 2007 from the file connection using SQL queries and create dataframe df
df <- sqldf("select * from pf where Date == '1/2/2007' or Date == '2/2/2007' ",
            file.format = list(header = TRUE, sep = ";" ))

close(pf)


#objects in the database can be accessed by simply giving their names.

#attach(df)
# Concatante Date and Time variables
df$dateTime = paste(df$Date, df$Time)

# Convert to Date/Time class
#attach(df)
df$dateTime<- strptime(df$dateTime, "%d/%m/%Y %H:%M:%S")

#plot fourth set of four graphs


## Plots
par(mfcol = c(2, 2))

plot(df$dateTime, df$Global_active_power, xlab="",
     ylab= "Global Active Power (kilowatts)",
     main = NULL,
     type = "l")

plot(df$dateTime, df$Sub_metering_1, 
     xlab="", 
     ylab= "Energy sub metering",
     main = NULL,
     type = "l")

lines(df$dateTime, df$Sub_metering_2, col="red")

lines(df$dateTime, df$Sub_metering_3, col="blue")

legend("topright",
       lty=1,
       col = c("black","red", "blue"),
       legend =c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       bty = "n",
       cex = .75)

plot(df$dateTime, df$Voltage,
     xlab="datetime",
     ylab= "Voltage",
     main = NULL,
     type = "l")

plot(df$dateTime,df$Global_reactive_power,
     xlab="datetime",
     ylab= "Global_reactive_power",
     main = NULL,
     type = "l")

dev.copy(png, file = "plot4.png") ## Copy plot to PNG
dev.off() ## close PNG device

