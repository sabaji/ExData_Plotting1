## This scripts uses the 'Electric Power Consumption' dataset from UCI web site and
## generates frequency plot of Global Active Power for 2 days 2007/02/01 and 2007/02/02.

## The scripts carries out following tasks:
## 1. Download and unzip data
## 2. Read the data for the 2 days, 2007/02/01 and 2007/02/02, into a dataframe
## 3. Combine Date & Time columns into a single POSIXct column
## 4. Generate histogram of frequencies for Global Active Power and output it as png

## remove this before upload
setwd("C:/My Files/MyDocs/Courses/DataScience/Exploratory Data Analysis/Assignment1")

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

## Not used now
setClass('dmyDate')
setAs("character","dmyDate", function(from) as.Date(from, format="%d/%m/%Y"))
setClass('onlyTime')
setAs("character","onlyTime", function(from) strptime(from,"%H:%M:%S"))

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
#     mydata <- read.table('household_power_consumption.txt',na.strings = "?", sep = ";", header = F, skip = minrowind, nrows = lenrowind, colClasses = c("dmyDate","onlyTime","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
    mydata <- read.table('household_power_consumption.txt',na.strings = "?", sep = ";", header = F, skip = minrowind, nrows = lenrowind, colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
    names(mydata) <- unlist(strsplit(readLines('household_power_consumption.txt', n=1), split = ";"))
} else
{
#     mydata <- read.table('household_power_consumption.txt',na.strings = "?", sep = ";", header = T, colClasses = c("dmyDate","onlyTime","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))[rowind,]
    mydata <- read.table('household_power_consumption.txt',na.strings = "?", sep = ";", header = T, colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))[rowind,]
}

## 3. Combine Date & Time columns into a single POSIXct column

mydata <- cbind(strptime(paste(mydata$Date,mydata$Time),format = '%d/%m/%Y %H:%M:%S'),mydata[,3:9])
colnames(mydata)[1] <- 'DateTime'

## 4. Generate histogram of frequencies for Global Active Power and output it as png

png('plot1.png')
hist(mydata$Global_active_power,freq = T, xlab = 'Global Active Power (kilowatts)', main = 'Global Active Power', col='red')
dev.off()
