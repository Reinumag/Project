# Getting and Cleaning Data Course Project

#You should create one R script called run_analysis.R that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation 
#for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

# this function returns the required clean data set and also writes it
# to a .txt file in workind directory.
# The funcion assumes that input data can be found from working dir.

run_analysis <- function(){
  
  ##
  # Initial reading of activity labels, column names for main datasets
  # as well as activities for datasets 
  ##
  
  # load packages
  library(plyr)
  
  # Reading variable names (features) of the dataset 
  featuresFile <- "./UCI HAR Dataset/features.txt"
  features<- read.table(featuresFile)
  
  # Reading labels of activities
  activitiesFile <- "./UCI HAR Dataset/activity_labels.txt"
  activities <- read.table(activitiesFile)
  names(activities) <- c("activityID","activity")
  
  # Reading activity codes for test and train datasets,
  # naming data sets accoringly. Fulfills task #4
  testActivitiesFile <- "./UCI HAR Dataset/test/y_test.txt"
  testActivities <- read.table(testActivitiesFile)
  names(testActivities) <- "activityID"
  trainActivitiesFile <- "./UCI HAR Dataset/train/y_train.txt"
  trainActivities <- read.table(trainActivitiesFile)
  names(trainActivities) <- "activityID"
  
  # Matching test and train set activity IDs with corresponding labels
  # This fulfills task #3
  testActivities <- join(testActivities, activities, by = "activityID")
  trainActivities <- join(trainActivities, activities, by = "activityID")
  
  ##
  # Merging test and training sets. Fulfils task #1
  ##
  
  # Reading test data, naming columns, inserting activity labels to the left 
  testFile <- "./UCI HAR Dataset/test/X_test.txt"
  testData <- read.table(testFile)
  names(testData) <- features[,2]
  testData <- cbind(testActivities,testData)
 
  # Also reading subject IDs, inserting subject IDs column to the left 
  # in testData data.frame
  testSubjectsList <- "./UCI HAR Dataset/test/subject_test.txt"
  testSubjects <- read.table(testSubjectsList)
  names(testSubjects) <- "subjectID"
  testData <- cbind(testSubjects,testData)
  
  # Repeating similar modifications for training data
  # Reading train data, inserting activity labels to the left 
  trainFile <- "./UCI HAR Dataset/train/X_train.txt"
  trainData <- read.table(trainFile)
  names(trainData) <- features[,2]
  trainData <- cbind(trainActivities,trainData)
  # also reading subject IDs, inserting subject IDs column to the left
  trainSubjectsList <- "./UCI HAR Dataset/train/subject_train.txt"
  trainSubjects <- read.table(trainSubjectsList)
  names(trainSubjects) <- "subjectID"
  trainData <- cbind(trainSubjects,trainData)
  
  #actual merging of test and train data
  uciharData <- rbind(testData,trainData)
  # drop unneeded partial datasets from memory
  rm(testData, trainData,features)
  rm(testActivities,testSubjects,trainActivities, trainSubjects)
  
  ##
  # Subsetting only variables containing mean() and std() in their names
  # Fulfills task #2
  ##
  
  # Figuring out which columns contain mean() or std()
  selectColsA <- grep("mean()",names(uciharData))
  selectColsB <- grep("std()",names(uciharData))
  selectCols <- c(1:3,selectColsA,selectColsB) # first 3 columns are needed
  selectCols <- sort(selectCols)
  
  # Actual subsetting of required columns
  uciharData <- uciharData[,selectCols]
  # Apparently there are columnnames containing meanFreq() 
  # which should be excluded from dataset
  selectCols <- grep("meanFreq()",names(uciharData))
  uciharData <- uciharData[,-selectCols]
  
  ##
  # Creating clean dataset which averages observation values 
  # for each subject and activity, filfilling task #5
  ##
  
  # first, the activity labels must be removed
  uciharData <- uciharData[,-3]
  # then colwise means can be calculated
  uciharClean <- ddply(uciharData,c("subjectID","activityID"),colwise(mean))
  #then, activity labels sbould be introdced again
  uciharClean <- join(uciharClean, activities, by = "activityID")
  uciharClean <- uciharClean[c(1:2,69,3:68)]
  write.table(uciharClean,"uciharClean.txt",row.names = FALSE)
  uciharClean
}

