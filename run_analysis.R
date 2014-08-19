
#The script does the following:
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


path<-"UCI HAR Dataset" #path to the data directory
#test_path<-paste(path,"\\test") ### test subdir
#train_path<-paste(path,"\\train") ### train subdir

### read test data   
y_test<-read.table(paste(path,"\\test\\y_test.txt",sep=""))
x_test<-read.table(paste(path,"\\test\\X_test.txt",sep=""))
subject_test<-read.table(paste(path,"\\test\\subject_test.txt",sep=""))

### read train data
y_train<-read.table(paste(path,"\\train\\y_train.txt",sep=""))
x_train<-read.table(paste(path,"\\train\\X_train.txt",sep=""))
subject_train<-read.table(paste(path,"\\train\\subject_train.txt",sep=""))

### read activity labels
activity_labels<-read.table(paste(path,"\\activity_labels.txt",sep=""))

### read features
features<-read.table(paste(path,"\\features.txt",sep=""))

### make a copy of test and train data frame to work on
tidy_test<-x_test
tidy_train<-x_train

### label the test data frame
names(tidy_test)<-t(as.vector(features[,2]))

### label the train data frame
names(tidy_train)<-t(as.vector(features[,2]))


###name the activity_labels data frame, we will use this for merge operation
names(activity_labels)<-c("activityId","activity")

### add subject_id and activity columns to the tidy_test data frame
tidy_test<-cbind(subject_test,tidy_test)
names(tidy_test)[1]<-c("subjectId")
tidy_test<-cbind(y_test,tidy_test)
names(tidy_test)[1]<-c("activityId")
tidy_test<-(merge(activity_labels,tidy_test))
tidy_test$activityId<-NULL ## remove the activityId as it is not needed

### the same for tidy_train data frame

tidy_train<-cbind(subject_train,tidy_train)
names(tidy_train)[1]<-c("subjectId")
tidy_train<-cbind(y_train,tidy_train)
names(tidy_train)[1]<-c("activityId")
tidy_train<-(merge(activity_labels,tidy_train))
tidy_train$activityId<-NULL ## remove the activityId as it is not needed


### merge the test and train data frames
tidy_all<-rbind(tidy_train,tidy_test)


### extracts the mean and stdev columns - keep the activity and subjectId

tidy_all<-tidy_all[grep("subjectId|activity|mean|std",names(tidy_all))]

### Project tasks 1,2,3,4 completed

### For project task 5 create new data frame and write to file

tidy_new<-aggregate(tidy_all[grep("activity|subjectId",names(tidy_all),invert=TRUE)],by=list(subject=tidy_all$subjectId,activity=tidy_all$activity),FUN=mean)
write.table(tidy_new,file=paste(path,"\\tidy_ds.txt",sep=""),row.name=FALSE)







