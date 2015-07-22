# README
   
22 Jul 2015  
#Getting & Cleaning Data: Project 1

The following is a description of the code produced to obtain a tidy data 
set using the data collected from the accelerometers from the Samsung Galaxy S smartphone.

The entire code is in one script: run_analysis.R

###Step 0:
We first load the necessary libraries, and check if data exists in working directory, otherwise download the data from the url:


```r
library(plyr) 
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(reshape2)

temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(file="UCI HAR Dataset/test/X_test.txt")) {
      download.file(fileUrl, temp, method="curl")
      unzip(temp)
}
unlink(temp)
```

Load the data into data frames:


```r
TestSet <- read.table(file="UCI HAR Dataset/test/X_test.txt")
TrainSet <- read.table(file="UCI HAR Dataset/train/X_train.txt")
TestSubject <- read.table(file="UCI HAR Dataset/test/subject_test.txt")

TestLab <- read.table(file="UCI HAR Dataset/test/y_test.txt")
TrainLab <- read.table(file="UCI HAR Dataset/train/y_train.txt")
TrainSubject <- read.table(file="UCI HAR Dataset/train/subject_train.txt")

Features <- read.table(file="UCI HAR Dataset/features.txt")
ActivityLab <- read.table(file="UCI HAR Dataset/activity_labels.txt")
```

###Step 1:
Working on the test sets and training sets separately, first compile all
features into complete data frames, then concatenate to obtain the full set (TotalSet). At this point, we appropriately label the data set with descriptive variable names (#4 in the assignment).


```r
#Test Set:

names(TestSet) <- Features$V2
TestSet["Activity"] <- TestLab
TestSet["Subject"] <- TestSubject

#Train Set:

names(TrainSet) <- Features$V2
TrainSet["Activity"] <- TrainLab
TrainSet["Subject"] <- TrainSubject

#concatenate the two:

TotalSet <- rbind(TestSet,TrainSet) 
```


###Step 2:
Extract only the measurements on the mean and standard deviation for 
each measurement: 


```r
TotalSet$Subject <- as.factor(TotalSet$Subject)
sub_TSet <- select(TotalSet,contains("mean"),contains("std"),Activity,Subject)
```

Examine the list obtained, and remove unwanted features. Since we are 
only interested in the raw features, we may remove the ones that are derived from these.


```r
names(sub_TSet)
```

```
##  [1] "tBodyAcc-mean()-X"                   
##  [2] "tBodyAcc-mean()-Y"                   
##  [3] "tBodyAcc-mean()-Z"                   
##  [4] "tGravityAcc-mean()-X"                
##  [5] "tGravityAcc-mean()-Y"                
##  [6] "tGravityAcc-mean()-Z"                
##  [7] "tBodyAccJerk-mean()-X"               
##  [8] "tBodyAccJerk-mean()-Y"               
##  [9] "tBodyAccJerk-mean()-Z"               
## [10] "tBodyGyro-mean()-X"                  
## [11] "tBodyGyro-mean()-Y"                  
## [12] "tBodyGyro-mean()-Z"                  
## [13] "tBodyGyroJerk-mean()-X"              
## [14] "tBodyGyroJerk-mean()-Y"              
## [15] "tBodyGyroJerk-mean()-Z"              
## [16] "tBodyAccMag-mean()"                  
## [17] "tGravityAccMag-mean()"               
## [18] "tBodyAccJerkMag-mean()"              
## [19] "tBodyGyroMag-mean()"                 
## [20] "tBodyGyroJerkMag-mean()"             
## [21] "fBodyAcc-mean()-X"                   
## [22] "fBodyAcc-mean()-Y"                   
## [23] "fBodyAcc-mean()-Z"                   
## [24] "fBodyAcc-meanFreq()-X"               
## [25] "fBodyAcc-meanFreq()-Y"               
## [26] "fBodyAcc-meanFreq()-Z"               
## [27] "fBodyAccJerk-mean()-X"               
## [28] "fBodyAccJerk-mean()-Y"               
## [29] "fBodyAccJerk-mean()-Z"               
## [30] "fBodyAccJerk-meanFreq()-X"           
## [31] "fBodyAccJerk-meanFreq()-Y"           
## [32] "fBodyAccJerk-meanFreq()-Z"           
## [33] "fBodyGyro-mean()-X"                  
## [34] "fBodyGyro-mean()-Y"                  
## [35] "fBodyGyro-mean()-Z"                  
## [36] "fBodyGyro-meanFreq()-X"              
## [37] "fBodyGyro-meanFreq()-Y"              
## [38] "fBodyGyro-meanFreq()-Z"              
## [39] "fBodyAccMag-mean()"                  
## [40] "fBodyAccMag-meanFreq()"              
## [41] "fBodyBodyAccJerkMag-mean()"          
## [42] "fBodyBodyAccJerkMag-meanFreq()"      
## [43] "fBodyBodyGyroMag-mean()"             
## [44] "fBodyBodyGyroMag-meanFreq()"         
## [45] "fBodyBodyGyroJerkMag-mean()"         
## [46] "fBodyBodyGyroJerkMag-meanFreq()"     
## [47] "angle(tBodyAccMean,gravity)"         
## [48] "angle(tBodyAccJerkMean),gravityMean)"
## [49] "angle(tBodyGyroMean,gravityMean)"    
## [50] "angle(tBodyGyroJerkMean,gravityMean)"
## [51] "angle(X,gravityMean)"                
## [52] "angle(Y,gravityMean)"                
## [53] "angle(Z,gravityMean)"                
## [54] "tBodyAcc-std()-X"                    
## [55] "tBodyAcc-std()-Y"                    
## [56] "tBodyAcc-std()-Z"                    
## [57] "tGravityAcc-std()-X"                 
## [58] "tGravityAcc-std()-Y"                 
## [59] "tGravityAcc-std()-Z"                 
## [60] "tBodyAccJerk-std()-X"                
## [61] "tBodyAccJerk-std()-Y"                
## [62] "tBodyAccJerk-std()-Z"                
## [63] "tBodyGyro-std()-X"                   
## [64] "tBodyGyro-std()-Y"                   
## [65] "tBodyGyro-std()-Z"                   
## [66] "tBodyGyroJerk-std()-X"               
## [67] "tBodyGyroJerk-std()-Y"               
## [68] "tBodyGyroJerk-std()-Z"               
## [69] "tBodyAccMag-std()"                   
## [70] "tGravityAccMag-std()"                
## [71] "tBodyAccJerkMag-std()"               
## [72] "tBodyGyroMag-std()"                  
## [73] "tBodyGyroJerkMag-std()"              
## [74] "fBodyAcc-std()-X"                    
## [75] "fBodyAcc-std()-Y"                    
## [76] "fBodyAcc-std()-Z"                    
## [77] "fBodyAccJerk-std()-X"                
## [78] "fBodyAccJerk-std()-Y"                
## [79] "fBodyAccJerk-std()-Z"                
## [80] "fBodyGyro-std()-X"                   
## [81] "fBodyGyro-std()-Y"                   
## [82] "fBodyGyro-std()-Z"                   
## [83] "fBodyAccMag-std()"                   
## [84] "fBodyBodyAccJerkMag-std()"           
## [85] "fBodyBodyGyroMag-std()"              
## [86] "fBodyBodyGyroJerkMag-std()"          
## [87] "Activity"                            
## [88] "Subject"
```

```r
sub_TSet <- select(sub_TSet,-contains("angle"))
```

###Step 3:
Use descriptive activity names to name the activities in the data set:


```r
sub_TSet$Activity <- as.factor(sub_TSet$Activity)
levels(sub_TSet$Activity)
```

```
## [1] "1" "2" "3" "4" "5" "6"
```

```r
levels(sub_TSet$Activity) <- ActivityLab$V2
levels(sub_TSet$Activity)
```

```
## [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS"
## [4] "SITTING"            "STANDING"           "LAYING"
```


###Step 4:
Appropriately label the data set with descriptive variable names:
This was performed already in Step 1.

###Step 5:
From the data set in Step 4, creates a second, independent tidy data 
set with the average of each variable for each activity and each subject.

First reorder data set by Subject:


```r
sub_TSet <- arrange(sub_TSet, Subject)
```

For each subject, melt by Activity, then calculate the mean for each variable.


```r
TSet_melt <- melt(sub_TSet, id=c("Subject","Activity"))

#Initialize final DF:
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
```


Output Tidy Data set:


```r
write.table(Tidy_data, file="TidyData.txt", row.name=FALSE)
```

Reading in Tidy Data set:


```r
read_tidy <- read.table(file="TidyData.txt",header=TRUE, stringsAsFactors=TRUE)
```
