library(dplyr)

trainx <- read.table("./UCI HAR Dataset/train/trainx.txt")
trainy <- read.table("./UCI HAR Dataset/train/trainy.txt")
trainsb <- read.table("./UCI HAR Dataset/train/subject_train.txt")

testx <- read.table("./UCI HAR Dataset/test/testx.txt")
testy <- read.table("./UCI HAR Dataset/test/testy.txt")
testsb <- read.table("./UCI HAR Dataset/test/subject_test.txt")

namevar <- read.table("./UCI HAR Dataset/features.txt")

activitylab <- read.table("./UCI HAR Dataset/activitylab.txt")

totalx <- rbind(trainx, testx)
totaly <- rbind(trainy, testy)
totalsb <- rbind(trainsb, testsb)

selected_var <- namevar[grep("mean\\(\\)|std\\(\\)",namevar[,2]),]
totalx <- totalx[,selected_var[,1]]

colnames(totaly) <- "activity"
totaly$activitylabel <- factor(totaly$activity, labels = as.character(activitylab[,2]))
activitylabel <- totaly[,-1]

colnames(totalx) <- namevar[selected_var[,1],2]

colnames(totalsb) <- "subject"
total <- cbind(totalx, activitylabel, totalsb)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)