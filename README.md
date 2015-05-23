# Getting and Cleaning Data - Course Project

May 22, 2015

## Introduction

The Course Project involves reading and manipulating a large dataset.  The goal is to present this "messy" data in "tidy" data format such that:

* each variable is a column,
* each observation is a row, and
* each type of observational unit is a table.

When data is in tidy format the meaning of the data is clear, and the data is easy to manipulate with modern programming languages.  Tidy Data is described in Hadley Wickham's journal article of the same name (http://www.jstatsoft.org/v59/i10/paper).

Our messy data comes from an experiment entitled *Human Activity Recognition Using Smartphones* (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Briefly, these experiments involved 30 volunteers (aka subjects) performing 6 activities (WALKING, SITTING, STANDING, etc) while wearing a smartphone. The goal of the experiments is to see if the smartphone's built-in accelerometer and gyroscope can provide datapoints sufficient to predict the subject's activity.  This is a classic machine learning experiment where the raw data is massaged by various transformations into a series of candidate features.  561 of them!  The dataset is then randomly partitioned into 2 sets.  The first set is used to train a predictive model.  When the parameters of the predictive model are optimized, the second set is used to validate, or test, the model.  How well does the model predict the correct answer when presented with the second, and previously unseen, set of data?

## Load the Tidy Dataset

Load the tidy dataset produced for the course project into R with the following command:

    means <- read.table("means.txt", header=TRUE, sep=" ", stringsAsFactors=FALSE)

## The Tidy Dataset Script

See [run\_analysis.R](https://github.com/rjhamilton/GetCleanData/blob/master/run_analysis.R) on github.com.

## The Source Files

* The source dataset can be visualized as a cross-tab of measurements.  The rows represent 30 subjects doing 6 different activities.  Each combination of subject and activity is observed multiple times.  The columns represent 561 features derived from the raw dataset.  The cross-tab is fully popluated i.e. there are no missing measurements.

* The source dataset is presented as 2 horizontal stripes.  The largest stripe is the training stripe; the smaller is the validation or test stripe.  At some point, these 2 stripes must be combined.

* Each horizontal stripe manifests itself as a single large fact file, 2 smaller fact files, and 1 dimension file, all of which must be joined together.  For the 2 stripes we have:

    Train Stripe:  **subject\_train.txt** JOIN **y\_train.txt** JOIN **activity\_labels.txt** JOIN **X\_train.txt**

    Test Stripe:   **subject\_test.txt**  JOIN **y\_test.txt**  JOIN **activity\_labels.txt** JOIN **X\_test.txt**

* The source dataset columns include 2 types of columns: key columns and measurement columns.  The key columns identify the subject and activity for each row.  The 561 measurement columns enumerated in **features.txt** contain the experimental measurements.

* Only those columns which measure "mean" or "standard deviation" must be selected.

## Assembling the Tidy Dataset

* Read dimension files before fact files!

* Read **feature.txt** into the feature.dim dataframe.  Normalize feature names into tokens that can be safely used in modern programming languages, i.e. alphanumeric characters + underline only, with no leading digit.

* Identify those feature which measure either "mean" or "standard deviation".  featureColIx, a vector of indexes into feature.dim, identifies the features of interest.  Features were identified by regex searching for either "\_mean" or "\_std".

* Read **activity_labels.txt** into the activity.dim dataframe, i.e. "WALKING", "SITTING", "STANDING", etc.

* Read activity facts from **y\_train.txt** and **y\_test.txt** into the activity.fact dataframes.

* Read subject identifers from **subject\_train.txt** and **subject\_test.txt** into the subject.fact dataframes.

* Read **X\_train.txt** and **X\_test.txt** into the fact dataframes (and take a coffee break while waiting...)  Add a rowid identifier to these dataframes.  The rowid provides both an audit trail and a uniquifier to distinguish between multiple observations for each combination of subject and activity.

* Assemble each stripe using cbind() and inner\_join().  Only then, assemble the 2 complete stripes together using rbind().  This order of steps is easier (and safer!)

* We now have a tidy dataset in wide format!  Routine aggregation and output of data follow.

## Script Features

### Memoization
The 2 large fact tables take a significant amount of time to load from source files.  Memoization saves time by writing results to disk in .RData files for quick retrieval on subsequent calls.

    MEMOIZE <- TRUE
	txtFile <- "X_train.txt"
	rdataFile <- "X_train.RData"	

	if (file.exists(rdataFile) && MEMOIZE) {
		## read cached rdata file
		load(file=rdataFile)
	}
	else {
		## read fixed width txt file
		df <- read.fwf(file=txtFile, widths=rep(16, 561), header=FALSE, stringsAsFactors=FALSE)
		
		## save for subsequent calls
		save(file=rdataFile, df)
	}


### RowId Column
A rowid column is added to the 2 large fact tables so that individual observations can be traced back to its original row in  the source file.  If/when something goes wrong, robust rowid columns can provide an audit trail from conclusions back to the supporting raw data.  The X\_train.txt file's rowids begin at 1.  The X\_test.txt file's rowids begin at the next available power of 10 which, in this case, is 10001.

    ## add rowid to train.fact
    rowidStart <- 1
    train.fact <- cbind(
        rowid=as.integer(seq(rowidStart, length.out=nrow(train.fact)))
    	, train.fact
    )
    
    ## add rowid to test.fact
    rowidStart <- 10^ceiling(log10(max(train.fact$rowid))) + 1 # next available power of 10
    test.fact <- cbind(
    	rowid=as.integer(seq(rowidStart, length.out=nrow(test.fact)))
    	, test.fact
    )

### Feature Name Normalization
The 561 feature names enumerated in features.txt contain hyphens, parentheses, and commas.  These features will become column names that we will want to use in scripts.  Special characters, like hyphens, must be removed so that these column names conform to the rules for identifiers in modern programming languages.  This script loads the feature dimension and normalizes the names.

    NormalizeToken <- function(tok) {
        tok <- gsub("[^[:alnum:]]", "_", tok) # non-alphanum --> underline
    	tok <- gsub("_+", "_", tok)           # multiple underline --> single underline
    	gsub("_$", "", tok)                   # trim ending underline
    }
    
    feature.dim <- LoadTxtFile(lfn="features.txt", col.names=c("featureId", "descr"))
    feature.dim <- mutate(feature.dim, descr=NormalizeToken(descr))
    

