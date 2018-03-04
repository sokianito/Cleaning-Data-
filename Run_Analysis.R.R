## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



library(reshape2)
library(data.table)



setwd("C:/Users/fried/Desktop")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "C:/Users/fried/Desktop/data.zip"  )
unzip("C:/Users/fried/Desktop/data.zip")



## read activity labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
activity_labels <- as.character(activity_labels)

### read feutures 
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
feutures <- as.character(features)


## extract_features for mean and standard deviation  

extract_features <- grepl("mean|std", features)

## load dataset  for test 

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(X_test) <- features

X_test <- X_test[,extract_features]

Y_test[,2] <- activity_labels[Y_test[,1]]
names(Y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "subject"

test <- cbind(as.data.table(subject_test), Y_test, X_test)



## load dataset for train 

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) <- feutures

X_train <-  X_train[,extract_features]

Y_train[,2] <- activity_labels[Y_train[,1]]

names(Y_train) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "subject"


train <- cbind(as.data.table(subject_test), Y_train, X_train)


## merge test and train 

data <- rbind(test,train)

id_labels <- c("subject","Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)

## apply the mean function 

tidy_data <- dcast(melt_data, subject + Activity_Label ~ variable, mean)


write.table( tidy_data, file = "./tidy_data.txt")

write.table(tidy_data, file = "./tidy.csv", sep = ",")
