library(plyr) 
library(dplyr)
library(reshape2)

#0 Read in data:

temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(file="UCI HAR Dataset/test/X_test.txt")) {
      download.file(fileUrl, temp, method="curl")
      unzip(temp)
}
unlink(temp)

TestSet <- read.table(file="UCI HAR Dataset/test/X_test.txt")
TrainSet <- read.table(file="UCI HAR Dataset/train/X_train.txt")
TestSubject <- read.table(file="UCI HAR Dataset/test/subject_test.txt")

TestLab <- read.table(file="UCI HAR Dataset/test/y_test.txt")
TrainLab <- read.table(file="UCI HAR Dataset/train/y_train.txt")
TrainSubject <- read.table(file="UCI HAR Dataset/train/subject_train.txt")

Features <- read.table(file="UCI HAR Dataset/features.txt")
ActivityLab <- read.table(file="UCI HAR Dataset/activity_labels.txt")

#1-Merge the training and the test sets to create one data set.

#First compile the complete test set, and the training set:

#Test Set:

names(TestSet) <- Features$V2
TestSet["Activity"] <- TestLab
TestSet["Subject"] <- TestSubject

#Train Set:

names(TrainSet) <- Features$V2
TrainSet["Activity"] <- TrainLab
TrainSet["Subject"] <- TrainSubject

#Second merge the two:

TotalSet <- rbind(TestSet,TrainSet) 
#For later analysis:

TotalSet$Subject <- as.factor(TotalSet$Subject)

#2-Extract only the measurements on the mean and standard deviation for 
#each measurement. 

sub_TSet <- select(TotalSet,contains("mean"),contains("std"),Activity,Subject)

#Examine list and remove unwanted features
#We are only interested in the raw features, since the others are derived from these.

names(sub_TSet)
sub_TSet <- select(sub_TSet,-contains("angle"))

#3-Use descriptive activity names to name the activities in the data set

sub_TSet$Activity <- as.factor(sub_TSet$Activity)
levels(sub_TSet$Activity)
ActivityLab$V2
levels(sub_TSet$Activity) <- ActivityLab$V2

#4-Appropriately label the data set with descriptive variable names. 

#Done already in the above steps..

#5-From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

#First reorder data set by Subject:

sub_TSet <- arrange(sub_TSet, Subject)

#subset by subject
#for each subject, melt by Activity
#then calc mean for each variable

TSet_melt <- melt(sub_TSet, id=c("Subject","Activity"))

#Final DF:
Tidy_data <- dcast(TSet_melt, Activity ~ variable, mean, subset = .(Subject == 1))
#add subject:
Subject <- Subject <- rep(1,6)
Tidy_data <- cbind(Subject,Tidy_data)

#loop over subjects:
for(i in 2:30){
  tmp <- dcast(TSet_melt, Activity ~ variable, mean, subset = .(Subject == i))
  tmp["Subject"] <- i
  #rbind to previous subject and continue
  Tidy_data <- rbind(Tidy_data,tmp) 
}

#Output Tidy Data set:

write.table(Tidy_data, file="TidyData.txt", row.name=FALSE)

#Reading in Tidy Data set:
  
read_tidy <- read.table(file="TidyData.txt",header=TRUE, stringsAsFactors=TRUE)
read_tidy$Subject <- as.factor(read_tidy$Subject)

