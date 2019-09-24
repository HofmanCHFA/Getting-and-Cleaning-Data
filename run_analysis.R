#Loading packages
library(tidyverse)
#dplyr is part of the tidyverse package.

#Downloading needed files
filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#Loading all tables into R
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Creating one single dataset
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

#Extracting mean and standard deviation for each measurement
tidydataset <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#Labeling data with appropriate descriptions
names(tidydataset)[2] = "activity"
names(tidydataset)<-gsub("Acc", "accelerometer", names(tidydataset))
names(tidydataset)<-gsub("Gyro", "gyroscope", names(tidydataset))
names(tidydataset)<-gsub("BodyBody", "body", names(tidydataset))
names(tidydataset)<-gsub("Mag", "magnitude", names(tidydataset))
names(tidydataset)<-gsub("^t", "time", names(tidydataset))
names(tidydataset)<-gsub("^f", "frequency", names(tidydataset))
names(tidydataset)<-gsub("tBody", "bodytime", names(tidydataset))
names(tidydataset)<-gsub("-mean()", "mean", names(tidydataset), ignore.case = TRUE)
names(tidydataset)<-gsub("-std()", "std", names(tidydataset), ignore.case = TRUE)
names(tidydataset)<-gsub("-freq()", "frequency", names(tidydataset), ignore.case = TRUE)
names(tidydataset)<-gsub("angle", "angle", names(tidydataset))
names(tidydataset)<-gsub("gravity", "gravity", names(tidydataset))

#creating a independent data set with averages for each subject
finaldata <- tidydataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(finaldata, "finaldata.txt", row.name=FALSE)

#Checking the names
head(finaldata)
str(finaldata)
