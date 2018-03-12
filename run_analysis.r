getwd()
setwd("C:/Users/agray/Documents/Coursera Data Science Course/Programming Assignment Getting and Cleaning Data")

library(dplyr)

# read in train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# read in test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# read in data descriptions
features <- read.table("UCI HAR Dataset/features.txt")

# read in activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# 1 - Merges the training and the test sets to create one data set.
X_tot <- rbind(X_train, X_test)
Y_tot <- rbind(Y_train, Y_test)
Subject_tot <- rbind(Subject_train, Subject_test)

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
featureMeanSd <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_tot <- X_tot[,featureMeanSd[,1]]

# 3 - Uses descriptive activity names to name the activities in the data set
colnames(Y_tot) <- "activity"
Y_tot$activitylabel <- factor(Y_tot$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_tot[,-1]

# 4 - Appropriately labels the data set with descriptive variable names.
colnames(X_tot) <- features[featureMeanSd[,1],2]

# 5 - From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Subject_tot) <- "subject"
tot <- cbind(X_tot, activitylabel, Subject_tot)
tot_mean <- tot %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(tot_mean, file = "UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
