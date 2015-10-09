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

#check to see if there are any "NA's" in df by converting all "?" to NA
df[ df == "?"] = NA
#sum the number of NA's found and if there are any omit those records 

if (!sum(is.na(df)) == 0 )
{ df<- na.omit(df) }
#creating a table to see that all columns are clean of "NA's" (not necessary but double check)
na_count <-sapply(df, function(y) sum(length(which(is.na(y)))))


#objects in the database can be accessed by simply giving their names.

#attach(df)
# Concatante Date and Time variables
df$dateTime = paste(df$Date, df$Time)

# Convert to Date/Time class
#attach(df)
df$dateTime<- strptime(df$dateTime, "%d/%m/%Y %H:%M:%S")
#plot second graph
png(filename = "plot2.png" , width = 480, height = 480, units = "px", bg = "white")
with(df, plot(dateTime, Global_active_power, type = 'l', xlab = "", 
              ylab = "Global Active Power (kilowatts)" ))
dev.copy(png,file="plot2.png", 
         width=480,height=480, 
         units= "px",
         bg = "transparent")
# Close Graphical device
dev.off()
