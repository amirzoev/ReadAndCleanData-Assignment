CodeBook for run_analysis.R
========================================================
## Stage 1 - Reading data from files, combining the training and the test sets to create one data set.
`test_set, train_set`  - values of variables read from test and train sets, respectively

`test_set<-read.table('./UCI HAR Dataset/test/X_test.txt')`
`train_set<-read.table('./UCI HAR Dataset/train/X_train.txt')`

`set` - combined set of the above two

`set<-rbind(test_set,train_set)`

`act_testset, act_trainset` - names of the activities, test and train sets, respectively

`act_testset<-read.table('./UCI HAR Dataset/test/y_test.txt')`
`act_trainset<-read.table('./UCI HAR Dataset/train/y_train.txt')`

act - combined set of the above two 

`act<-rbind(act_testset,act_trainset)`

subj_test, subj_train - list of subjects involved in each observation in test and train sets, respectively
`subj_test<-read.table('./UCI HAR Dataset/test/subject_test.txt')`
`subj_train<-read.table('./UCI HAR Dataset/train/subject_train.txt')`
subj - combined set of the above two
subj<-rbind(subj_test,subj_train)
Give reasonable name to subject-variable
`names(subj)<-'subject'`

## Stage 2. Extracts only the measurements on the mean and standard deviation for each measurement
Read list of all recorded features: `feat`

`feat<-read.table("./UCI HAR Dataset/features.txt")`

Filter only thouse which has keywords mean() and std() in the header.

`feat_fltr<-feat[grepl("mean()",feat$V2,fixed=TRUE) | grepl("std()",feat$V2,fixed=TRUE),]`

Apply the filter to the dataset `set` obtained at the stage 1, thus obtain the filtered dataset `set_fltr`

`set_fltr<-set[feat_fltr$V1]`

## Stage 3. Appropriately label the data set with descriptive variable or feature (column) names" 
Set names of the variables in `set_fltr` in accordance with the list of recorded reatures. The feature names are stated there in the 2nd column V2

`names(set_fltr)<-feat_fltr$V2`

## Stage 4. Use descriptive activity names to name the activities in the data set
Read labels of the recorded activities:

`act_label<-read.table('./UCI HAR Dataset/activity_labels.txt')`

set actual names of the activities instead of the ID-numbers

`act_named<-lapply(act, function(x) act_label[x,]$V2)`

Set the meaningfull name for the variable.

`names(act_named)<-c('activity')`

Join 3 datasets (filtered data, activity names and subject IDs) together, resulting in a single united dataset `set_joined`
`set_joined<-cbind(cbind(set_fltr,act_named,subj))`

## Stage 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
First we melt the dataset

set_melt<-melt(set_joined,id=c("subject","activity"),measure.vars=names(set_joined)[1:66])

Cast the dataset and calculate mean at the same time. We average over each activity of each specific person.

mytidyset<-dcast(set_melt, subject + activity ~ variable, mean)

Return the resulting tidy dataset

mytidyset 

