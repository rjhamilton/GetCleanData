#
# Getting and Cleaning Data - Course Project
# ==================================================================
# Human Activity Recognition Using Smartphones Dataset
# Version 1.0
# ==================================================================
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#

#setwd("D:\\WORK\\MOOC-GetCleanData")
#rmall <- function() rm(list=ls(envir=globalenv()), envir=globalenv()); rmall()

library(reshape)
library(dplyr)

## constants
MEMOIZE <- TRUE
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DATA_DIR <- "."
#DATA_DIR <- ".\\data"


####
Log <- function(text, ...)
{
	msg <- sprintf(paste0(as.character(Sys.time()), ": ", text, "\n"), ...)
	cat(msg)
	flush.console()
}


####
NormalizeToken <- function(tok)
{
	tok <- gsub("[^[:alnum:]]", "_", tok) # non-alphanum --> underline
	tok <- gsub("_+", "_", tok)           # multiple underline --> single underline
	gsub("_$", "", tok)                   # trim ending underline
}


####
GetZipFile <- function(url, lfn)
{
	zipFile <- paste0(DATA_DIR , "\\", lfn)
	if (!(file.exists(zipFile) && MEMOIZE))
	{
		Log("downloading '%s'...\n", zipFile)
		if (!file.exists(DATA_DIR)) {
			dir.create(DATA_DIR)
		}
		
		setInternet2(use=TRUE)
		download.file(url=URL, destfile=zipFile, mode="wb")

		Log("unzipping '%s'...\n", zipFile)
		unzip(zipFile, exdir=DATA_DIR , junkpaths=TRUE)
	}

	NULL
}


####
LoadTxtFile <- function(lfn, col.names)
{
	txtFile <- paste0(DATA_DIR, "\\", lfn)
	Log("reading '%s'...\n", txtFile)
	read.table(
		file=txtFile
		, sep=" "
		, header=FALSE
		, stringsAsFactors=FALSE
		, col.names=col.names
	)
}


####
LoadFacts <- function(lfn)
{
	p <- regexpr("\\.", lfn)[1]
	baseName <- substring(lfn, 1, p-1) # strip file extension
	txtFile <- paste0(DATA_DIR, "\\", baseName, ".txt")
	rdataFile <- paste0(baseName, ".RData")
	
	if (file.exists(rdataFile) && MEMOIZE)
	{
		## read cached rdata file
		Log("loading '%s'...\n", rdataFile)
		load(file=rdataFile)
	}
	else
	{
		## read fixed width txt file
		Log("reading '%s'...\n", txtFile)
		df <- read.fwf(
			file=txtFile
			, widths=rep(16, 561)
			, header=FALSE
			, stringsAsFactors=FALSE
#			, n=10 # for DEBUG
		)
		#str(df, list.len=ncol(df))

		## assign names to columns of interest
		colnames(df)[featureColIx] <- feature.dim$descr[featureColIx]
		#str(df, list.len=ncol(df))

		## remove columns we don't need
		df <- select(df, featureColIx)

		Log("saving '%s'...\n", rdataFile)
		save(file=rdataFile, df)
	}

	df
}
#lfn <- "X_train.txt"; df.X_train <- LoadFacts(lfn); str(df.X_train)
#lfn <- "X_test.txt"; df.X_test <- LoadFacts(lfn); str(df.X_test)


########
# MAIN
########


## download file and unzip as necessary
GetZipFile(URL, "dataset.zip")


## load feature dimension, normalize column names, get columns of interest
feature.dim <- LoadTxtFile("features.txt", c("featureId", "descr"))
feature.dim <- mutate(feature.dim, descr=NormalizeToken(descr))
featureColIx <- grep("_mean|_std", feature.dim$descr) # tokens now normalized
#feature.dim[featureColIx, "descr"]


## load activity dimension
activity.dim <- LoadTxtFile("activity_labels.txt", c("activityId", "activity"))


## load activity labels
trainActivity.fact <- LoadTxtFile("y_train.txt", "activityId")
testActivity.fact <- LoadTxtFile("y_test.txt", "activityId")


## load subject labels
trainSubject.fact <- LoadTxtFile("subject_train.txt", "subjectId")
testSubject.fact <- LoadTxtFile("subject_test.txt", "subjectId")


## load fact tables (s l o w . . .)
train.fact <- LoadFacts("X_train.txt")
test.fact <- LoadFacts("X_test.txt")


## add rowid to preserve audit trail
Log("add rowid to fact tables...")
rowidStart <- 1
train.fact <- cbind(
	rowid=as.integer(seq(rowidStart, length.out=nrow(train.fact)))
	, train.fact
)
rowidStart <- 10^ceiling(log10(max(train.fact$rowid))) + 1 # next available power of 10
test.fact <- cbind(
	rowid=as.integer(seq(rowidStart, length.out=nrow(test.fact)))
	, test.fact
)
#str(train.fact)
#str(test.fact)


## assemble the pieces
Log("prep wide format dataset...")
DF.WIDE <- rbind(
	cbind(
		trainSubject.fact
		, inner_join(trainActivity.fact, activity.dim)
		, train.fact
	)
	, cbind(
		testSubject.fact
		, inner_join(testActivity.fact, activity.dim)
		, test.fact
	)
)
DF.WIDE <- mutate(DF.WIDE, activityId=NULL) %>% # remove activityId column
	arrange(subjectId, activity, rowid)       # sort on key columns
#DF.WIDE[1:200, 1:5]
#str(DF.WIDE)


## unpivot to long format
Log("prep long format dataset...")
keyColIx <- 1:3
measureColIx <- (1:ncol(DF.WIDE))[-keyColIx]
DF.LONG <- melt.data.frame(
	DF.WIDE
	, id.vars = keyColIx
	, measure.vars = measureColIx
	, variable_name = "feature"
)
DF.LONG <- arrange(DF.LONG, subjectId, activity, rowid, feature)
#head(DF.LONG, 300)
#str(DF.LONG)


## group by subject
Log("calc means by subject...")
bySubject <- aggregate(
	DF.WIDE[,measureColIx]
	, by=list(subjectId=DF.WIDE$subjectId)
	, mean
)
nc <- ncol(bySubject)
nr <- nrow(bySubject)
bySubject <- mutate(bySubject, activity=rep("NA", nr)) %>%
	select(subjectId, activity, 3:nc)
#str(bySubject, list.len=10)


## group by activity
Log("calc means by activity...")
byActivity <- aggregate(
	DF.WIDE[,measureColIx]
	, by=list(activity=DF.WIDE$activity)
	, mean
)
nc <- ncol(byActivity)
nr <- nrow(byActivity)
byActivity <- mutate(byActivity, subjectId=as.integer(rep(NA,nr))) %>%
	select(subjectId, activity, 3:nc)
#str(byActivity, list.len=10)


## assemble means dataset
DF.MEANS <- rbind(
	bySubject
	, byActivity
)


## write means file
lfn <- paste0(DATA_DIR, "\\", "means.txt")
Log("writing '%s'...", lfn)
write.table(DF.MEANS, file=lfn, row.names=FALSE)


## finally!
Log("Done.")

