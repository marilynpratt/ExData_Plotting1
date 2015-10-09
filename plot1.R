# Change working directory to your local workspace
getwd()
#install.packages("sqldf")
library("sqldf")
# Url where zip file(containing data set) for power consumption is located
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download copy of zip file locally (windows)
download.file(fileUrl, destfile="exdata-data-household_power_consumption.zip", method="wininet")

# Unzip the text data file locally
unzip("exdata-data-household_power_consumption.zip",overwrite = TRUE, "household_power_consumption.txt")

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
attach(df)
dateTime<- strptime(dateTime, "%d/%m/%Y %H:%M:%S")
hist(Global_active_power,
     col="red",
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)",
     mar=(c(8,4,4,8)))
dev.copy(png,file="plot1.png", 
         width=480,height=480, 
         units= "px",
         bg = "transparent")
dev.off()
