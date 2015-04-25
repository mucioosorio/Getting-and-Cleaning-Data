

# the path in my pc is C:/Users/Mucio/Documents/samsung

##############
# 1. Merges the x train and x test to create one data set.
# The "x" data frame has a size 10299 * 561 .
##############

x_train <- read.table("samsung/train/X_train.txt")
x_test <- read.table("samsung/test/X_test.txt")
x <- rbind(x_train,x_test)

#############
# 2. From "features" we extracts only the measurements names related with mean and standard deviation for each measurement.
#############

# In "features" are all the variable names for x data set.In column V1 are the id numbers for variable name and
# the column 2 contains the variable names text. The size is 561 * 2

features <- read.table("samsung/features.txt")        

# Only for remember: grep, grepl, regexpr and gregexpr search for matches to argument pattern within each element of a character vector: they differ in the format of and amount of detail in the results.
# sub and gsub perform replacement of the first and all matches respectively. 
# by default: grep(pattern, x, ignore.case = FALSE, perl = FALSE, value = FALSE,
#     fixed = FALSE, useBytes = FALSE, invert = FALSE)

# "features_with_mean_sd" contains the id number for variables interested us. There are 66 variables for mean an sd 

features_with_mean_sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

# The "xn" data set contains only the data set with the variables related with mean and sd for each measurement fron ths data set x. 
# the "xn" size is 10299 * 66. Also the name of the variable is added.

xn <- x[,features_with_mean_sd]
names(xn) <- features[features_with_mean_sd, 2]

############
# 3. Uses descriptive activity names to name the activities in the data set.
############

# The data frame "activities" have the descriptive names of activities

activities <- read.table("samsung/activity_labels.txt")

# "y" is the id for activities in the "x" data set. the size is 10299 * 1

y_train <- read.table("samsung/train/y_train.txt")
y_test <- read.table("samsung/test/y_test.txt")
y <- rbind(y_train,y_test)

# replace the numeric id for the name of the activity and put the column name

y[,1] = activities[y[,1], 2]
names(y) <- "Activity"

#############
# 4. Appropriately labels the data set with descriptive activity names.
#############

# The ID subject are in data set "s" and varies from 1 to 30. The size is 10299 * 1

s_train <- read.table("samsung/train/subject_train.txt")
s_test <- read.table("samsung/test/subject_test.txt")
s <- rbind(s_train, s_test)                                    
names(s) <- "Subject"

# The data set cleaned

x_cleaned <- cbind(s, y, xn)

# Finally the data set cleaned file (space separed)

write.table(x_cleaned, "x_cleaned.txt",row.names=F)

##############
#Step 5: "Creates a second, independent tidy data set with the average of each variable for each activity and each subject."
##############

# First Defining subject as a factor to aggregate by subject and by activity

x_cleaned$Subject<-as.factor(x_cleaned$Subject)

# x_cleaned_average contains the average for each activity and each subject
x_cleaned_average <-aggregate(x_cleaned, by=list("Subject"=x_cleaned$Subject,"Activity"=x_cleaned$Activity), FUN="mean", na.rm=T)
x_cleaned_average<-x_cleaned_average[,-(3:4)]

#Finally the second data set cleaned file (space separed)

write.table(x_cleaned_average, "2x_cleaned.txt",row.names=F)
