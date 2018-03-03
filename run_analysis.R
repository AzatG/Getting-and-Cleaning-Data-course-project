#run_analysis.r

#upload tada that should be cleaned
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "courseprojectdata.zip")

# Final project of Getting and Cleaning data course
setwd("~/edu/Getting and Cleaning data/course_project/data")

#install necessary packages
library(data.table)
library(plyr)
library(dplyr)




#I extracted zip file in set directory so all documents can read by R

#read all necessary tables
 activity_labels <- setDT(read.table("activity_labels.txt", header = FALSE))
 setnames(activity_labels, c("V1","V2"), c("activity_id","activity") )  
 
 features <- read.table("features.txt", header =  FALSE)
 subject_test <- read.table("test/subject_test.txt", header = FALSE)
 x_test <- read.table("test/X_test.txt", header = FALSE)
 y_test <- read.table("test/Y_test.txt", header = FALSE)  
 subject_train <- read.table("train/subject_train.txt", header = FALSE)
 x_train <- read.table("train/X_train.txt", header = FALSE)
 y_train <- read.table("train/y_train.txt", header = FALSE)
 
# 1 Merge of all data
# merge training and test sets
 datax <- rbind(x_test,x_train)
 datay <- rbind(y_test, y_train)
 subject <- rbind(subject_test,subject_train)
 
 # set column names
 setnames(subject, "V1" , "activity_id" ) 
 colnames(datax) <- features[,2]
 colnames(datay) <- "y"
 
 
# merge all data in one file
 
 data <- cbind(datax,datay, subject)
 
 
 
 
# 2 Extract measurements of on the mean and stand
  meanandstd <- grep("activity|mean|std", colnames(data))
  meanandstddata <- data[,meanandstd]  
  
# 3 Use descriptive activity names to name activity in the data set  
  meanandstddata <- merge(x = meanandstddata, y = activity_labels, by = "activity_id")
  setDT(meanandstddata)
  meanandstddata <- select(meanandstddata, - activity_id)
  
# 4 Appropriately labels the data set with descriptive variable names
  colnames <- colnames(meanandstddata)
  colnames <- gsub("_"," ", colnames)
  colnames <- gsub("-", " ", colnames)
  colnames <- gsub("fBody", "body", colnames)
  colnames <- gsub("tBody", "body", colnames)
  colnames <- gsub("bodyBody", "body", colnames)
  colnames <- gsub("tGravity", "gravity", colnames)
  colnames <- gsub("\\()"," ", colnames)
  
  colnames(meanandstddata) <- colnames
  
  
#5 From the data set in step 4, creates a second, independent tidy data set with 
#  the average of each variable for each activity and each subject.
  

  seconddata<-aggregate(. ~ activity, meanandstddata, mean)
  write.table(seconddata, file = "tidydata.txt",row.name=FALSE)
   
  


  
  
  
  