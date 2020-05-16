# Getting and Cleaning Data Project John Hopkins Coursera
# Author: Eric Johnson

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Download data ontop computer and upload into R

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "data.zip")
unzip(zipfile = "data.zip")
setwd("/Users/eric/Desktop/UCI HAR Dataset")

train_files <- list.files( "train", full.names = TRUE )[-1]
test_files  <- list.files( "test" , full.names = TRUE )[-1]
files <- c( train_files, test_files )

# train data

train_sub <- read.table(files[1])
train_x <- read.table(files[2])
train_y <- read.table(files[3])

# test data

test_sub <- read.table(files[4])
test_x <- read.table(files[5])
test_y <- read.table(files[6])

# merge data - train, test

data_sub <- rbind(train_sub, test_sub)
data_x <- rbind(train_x, test_x)
data_y <- rbind(train_y, test_y)

# name variables with descriptive activity names

names(data_sub) <- c('subject')
names(data_y) <- c('activity')
data_x_names <- read.table(file.path("features.txt"),head=FALSE)
names(data_x) <- data_x_names$V2

# mean and standard deviation

data_x_mean_std <- data_x[, grep('-(mean|std)\\(\\)', read.table("features.txt")[,2])]
names(data_x_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 

# combine into single dataset

Data <- cbind(data_x_mean_std,data_y,data_sub)

# finish naming all variables

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# create a second tidy dataset

Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
