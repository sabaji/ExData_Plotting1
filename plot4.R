## This scripts uses the 'Electric Power Consumption' dataset from UCI web site and
## generates 4 line plots for 2 days 2007/02/01 and 2007/02/02 in a single png.

## The scripts carries out following tasks:
## 1. Download and unzip data
## 2. Read the data for the 2 days, 2007/02/01 and 2007/02/02, into a dataframe
## 3. Combine Date & Time columns into a single POSIXct column
## 4. Generate 4 line plots in one png as follows
##    a. Global Active Power vs DateTime
##    b. Voltage vs DateTime
##    c. Sub Metring 1, 2, 3 vs DateTime vs DateTime
##    d. Global Reactive Power vs DateTime

## 1. Download and unzip data

## Download zip file
if (!file.exists('PoweConsumption.zip'))
{
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip','PoweConsumption.zip')
}
## unzip txt data file
if (!file.exists('household_power_consumption.txt'))
{
    unzip('PoweConsumption.zip')
}

## 2. Read the data for the 2 days, 2007/02/01 and 2007/02/02, into a dataframe

## Get the row numbers for the 2 required dates, 2007/02/01 and 2007/02/02
lines <- readLines('household_power_consumption.txt')
rowind <- which(grepl("^1/2/2007|^2/2/2007",lines))-1

## If these row numbers are consecutive, then you can use skip/nrows options in read.table
## to reduce processing time and memory requirement
minrowind <- min(rowind)
maxrowind <- max(rowind)
lenrowind <- length(rowind)

## Missing values are codes as ? in the dataset
if(lenrowind == maxrowind - minrowind + 1)
{
    mydata <- read.table('household_power_consumption.txt',na.strings = "?", sep = ";", header = F, skip = minrowind, nrows = lenrowind, colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
    names(mydata) <- unlist(strsplit(readLines('household_power_consumption.txt', n=1), split = ";"))
} else
{
    mydata <- read.table('household_power_consumption.txt',na.strings = "?", sep = ";", header = T, colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))[rowind,]
}

## 3. Combine Date & Time columns into a single POSIXct column

mydata <- cbind(strptime(paste(mydata$Date,mydata$Time),format = '%d/%m/%Y %H:%M:%S'),mydata[,3:9])
colnames(mydata)[1] <- 'DateTime'

## 4. Generate 4 line plots in one png

png('plot4.png')
par(mfrow = c(2,2))

##    a. Global Active Power vs DateTime
plot(mydata$DateTime,mydata$Global_active_power,type="l", xlab='', ylab = 'Global Active Power (kilowatts)')

##    b. Voltage vs DateTime
plot(mydata$DateTime,mydata$Voltage,type="l", xlab='datetime', ylab = 'Voltage')

##    c. Sub Metring 1, 2, 3 vs DateTime vs DateTime
plot(mydata$DateTime,mydata$Sub_metering_1,type="n", xlab='', ylab = 'Energy sub metering')
lines(mydata$DateTime,mydata$Sub_metering_1,type="l")
lines(mydata$DateTime,mydata$Sub_metering_2,type="l",col="red")
lines(mydata$DateTime,mydata$Sub_metering_3,type="l",col="blue")
legend('topright',legend=c('Sub_metering_1','Sub_metering_3','Sub_metering_3'),col=c('black','red','blue'), lwd = 1, bty = 'n')

##    d. Global Reactive Power vs DateTime
plot(mydata$DateTime,mydata$Global_reactive_power,type="l", xlab='datetime', ylab = 'Global_reactive_power')

dev.off()
