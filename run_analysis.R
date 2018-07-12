install.packages("RCurl")
library(RCurl)
library(plyr)
library(data.table)

setwd('C:\\Users\\DELL\\Desktop\\UCI HAR Dataset')

# This part is used to merge training and test datasets
training_x_data <- read.table('./train/x_train.txt',header=FALSE)
test_x_data <- read.table('./test/x_test.txt',header=FALSE)
merged_x_data <- rbind(training_x_data, test_x_data)

training_subject <- read.table('./train/subject_train.txt',header=FALSE)
test_subject <- read.table('./test/subject_test.txt',header=FALSE)
merged_subject <- rbind(training_subject, test_subject)

training_y_data <- read.table('./train/y_train.txt',header=FALSE)
test_y_data <- read.table('./test/y_test.txt',header=FALSE)
merged_y_data <- rbind(training_y_data, test_y_data)

# This part is used to extract the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
mean_sd <- grep("-(mean|std)\\(\\)", features[, 2])
x_mean_sd <- merged_x_data[, mean_sd]

# This part is used to name the activities in the data set using descriptive activitiy names
names(x_mean_sd) <- features[mean_sd, 2]
activity_labels <- read.table("activity_labels.txt")
merged_y_data[, 1] <- activity_labels[merged_y_data[, 1], 2]
names(merged_y_data) <- "Activity"

# Appropriately label the data set with descriptive activity names.
names(merged_subject) <- "Subject"
summary(merged_subject)

singleDataSet <- cbind(x_mean_sd, merged_y_data, merged_subject)
names(singleDataSet) <- make.names(names(singleDataSet))
names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))
write.table(singleDataSet, 'merged.txt', row.names = FALSE)


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Mean_data<-aggregate(. ~Subject + Activity, singleDataSet, mean)
Mean_data<-Mean_data[order(Mean_data$Subject,Mean_data$Activity),]
write.table(Mean_data, file = "tidydata.txt",row.name=FALSE)















