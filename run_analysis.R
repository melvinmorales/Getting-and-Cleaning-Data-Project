# You should create one R script called run_analysis.R that does 
# the following. 
# 1.Merges the training and the test sets to create one data set.
## Creating subject dataset
subject_test <- read.table('./test/subject_test.txt')
subject_train <- read.table('./train/subject_train.txt')
subject_dataset <- rbind(subject_train, subject_test)
names(subject_dataset) <- "subject"

## Creating X dataset
x_test <- read.table('./test/X_test.txt')
x_train <- read.table('./train/X_train.txt')
x_dataset <- rbind(x_train, x_test)

## Creating y dataset
y_test <- read.table('./test/y_test.txt')
y_train <- read.table('./train/y_train.txt')
y_dataset <- rbind(y_train, y_test)


# 2.Extracts only the measurements on the mean and standard 
#   deviation for each measurement. 
features <- read.table('./features.txt', header=FALSE, col.names=c('id', 'name'))
feature_selected_columns <- grep('mean\\(\\)|std\\(\\)', features$name)
filtered_dataset <- x_dataset[, feature_selected_columns]

# 3.Uses descriptive activity names to name the activities 
#   in the data set
activity_labels <- read.table('./activity_labels.txt', header=FALSE, col.names=c('id', 'name'))

# 4.Appropriately labels the data set with descriptive variable
#   names. 
y_dataset[, 1] = activity_labels[y_dataset[, 1], 2]
names(y_dataset) <- "activity"

# 5.From the data set in step 4, creates a second, independent 
#   tidy data set with the average of each variable for each 
#   activity and each subject.

#Creates an intermediate dataset with all required measurements.
whole_dataset <- cbind(subject_dataset, y_dataset, filtered_dataset)
write.csv(whole_dataset, "./dataset_with_descriptive_activity_names.csv")

#Creates the final, independent tidy data set with the average 
#of each variable for each activity and each subject.
measurements <- whole_dataset[, 3:dim(whole_dataset)[2]]
tidy_dataset <- aggregate(measurements, list(whole_dataset$subject, whole_dataset$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
write.csv(tidy_dataset, "./output/final_tidy_dataset.csv")
write.table(tidy_dataset, "./output/final_tidy_dataset.txt",row.name=FALSE )
