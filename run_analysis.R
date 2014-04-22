##### Coursera: Getting and Cleaning Data
##### Week 3 Homework
##### Cedric Yau
##### Apr 21, 2014w

#Read All Files

xtest <- read.table('test/X_test.txt')
xtrain <- read.table('train/X_train.txt')

ytest <- read.table('test/y_test.txt')
ytrain <- read.table('train/y_train.txt')

subjectstest <- read.table('test/subject_test.txt')
subjectstrain <- read.table('train/subject_train.txt')

acts <- read.table('activity_labels.txt')

features <- read.table('features.txt')

#Requirement 1: Combine test and training data (note that the three all are merged below)
xall <- rbind(xtest, xtrain)
yall <- rbind(ytest, ytrain)
subjectsall <- rbind(subjectstest, subjectstrain)

yall.labeled <- merge(acts, yall)

#Requirement 3: Rename Columns to use descriptive activity names
colnames(xall) <- features$V2
colnames(yall.labeled) <- c('ActivityID','ActivityLabel')

#Requirement 4: Final Consolidation (label the data set with descriptive activity names)
data <- cbind(xall,Activity = yall.labeled$ActivityLabel, Subject = subjectsall$V1)

#Requirement 2: Filter for Columns with Mean or Std
colsWithMeanOrStd = regexpr('mean\\(\\)|std\\(\\)|activity|subject',colnames(data),ignore.case=TRUE)>-1
data.ColsWithMeanOrStd <- data[,colsWithMeanOrStd]

#Requirement 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(plyr)
library(reshape2)
data.melt <- melt(data, id.vars=c('Activity','Subject'))
data.summary <- dcast(data.melt, Activity + Subject ~ variable, mean)

#Write Output to Disk
write.table(data.summary,'output_clean.txt')
