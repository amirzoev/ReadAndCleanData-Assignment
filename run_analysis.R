#Merges the training and the test sets to create one data set.
test_set<-read.table('./UCI HAR Dataset/test/X_test.txt')
train_set<-read.table('./UCI HAR Dataset/train/X_train.txt')
set<-rbind(test_set,train_set) # resulting set
act_testset<-read.table('./UCI HAR Dataset/test/y_test.txt')
act_trainset<-read.table('./UCI HAR Dataset/train/y_train.txt')
act<-rbind(act_testset,act_trainset)
subj_test<-read.table('./UCI HAR Dataset/test/subject_test.txt')
subj_train<-read.table('./UCI HAR Dataset/train/subject_train.txt')
subj<-rbind(subj_test,subj_train)
names(subj)<-'subject'
# Extracts only the measurements on the mean and standard deviation for each measurement
feat<-read.table("./UCI HAR Dataset/features.txt")
feat_fltr<-feat[grepl("mean()",feat$V2,fixed=TRUE) | grepl("std()",feat$V2,fixed=TRUE),] # filter required features
set_fltr<-set[feat_fltr$V1] # Filtered set: Only mean() and std() 

#Appropriately labels the data set with descriptive variable or feature (column) names" 
names(set_fltr)<-feat_fltr$V2 # Rename columns in the dataset

#Uses descriptive activity names to name the activities in the data set
act_label<-read.table('./UCI HAR Dataset/activity_labels.txt')
act_named<-lapply(act, function(x) act_label[x,]$V2)
names(act_named)<-c('activity')

# Join 3 datasets together:
set_joined<-cbind(cbind(set_fltr,act_named,subj))

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## First we melt the dataset
set_melt<-melt(set_joined,id=c("subject","activity"),measure.vars=names(set_joined)[1:66])
## Cast the dataset and calculate mean at the same time. We average over each activity of each specific person.
mytidyset<-dcast(set_melt, subject + activity ~ variable, mean)
mytidyset # the resulting tidy dataset
