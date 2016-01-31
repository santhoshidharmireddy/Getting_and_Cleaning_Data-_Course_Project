
###################################################################################################################
# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#   for each activity and each subject.
###################################################################################################################

#Downloading and reading files
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){download.file(fileUrl1,destfile="getdata-projectfiles-UCI HAR Dataset.zip")}
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
list.files("./UCI HAR Dataset")


# The files that will be used in this course project are listed below:
#1. features.txt
#2. activity_labels.txt
#3. test/subject_test.txt
#4. train/subject_train.txt
#5. test/X_test.txt
#6. train/X_train.txt
#7. test/y_test.txt
#8. train/y_train.txt

# Loading/reading activity labels and features
ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
ActivityLabels[,2] <- as.character(ActivityLabels[,2])
Features <- read.table("UCI HAR Dataset/features.txt")
Features[,2] <- as.character(Features[,2])

# Reading Features files
FeaturesTest<- read.table("UCI HAR Dataset/test/X_test.txt")
FeaturesTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
str(FeaturesTest)
str(FeaturesTrain)

#Reading Activity files
ActivityTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
ActivityTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
str(ActivityTest)
str(ActivityTrain)

#Reading Subject files
SubjectTest<- read.table("UCI HAR Dataset/test/subject_test.txt")
SubjectTrain<- read.table("UCI HAR Dataset/train/subject_train.txt")
str(SubjectTest)
str(SubjectTrain)

#cbind all the train and test data separately
Traindata<- cbind(SubjectTrain,ActivityTrain,FeaturesTrain)
Testdata<- cbind(SubjectTest,ActivityTest,FeaturesTest)

#Merging training and the test sets to create one data set.
FinalData<- rbind(Traindata,Testdata)
colnames(FinalData)<- c("Subject","Activity",Features[,2])

#Extracting only the measurements on the mean and standard deviation for each measurement.
FeaturesNames<-Features$V2[grep("mean\\(\\)|std\\(\\)", Features[,2])]
colnames<- c("Subject","Activity",FeaturesNames)
Data<- subset(FinalData,select=colnames)

#Uses descriptive activity names to name the activities in the data set
Data$Activity <- factor(Data$Activity, levels = ActivityLabels[,1], labels = ActivityLabels[,2])
Data$Subject <- as.factor(Data$Subject)

#Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.
TidyData<-aggregate(. ~Subject + Activity, Data, mean)
tidydata<- TidyData[order(TidyData$Subject,TidyData$Activity),]
write.table(TidyData,file="tidydata.txt", row.names = FALSE, quote = FALSE)


##Produce Codebook
library(knitr)
knit2html("codebook.Rmd");





