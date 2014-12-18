Getting and cleaning data course prject
=======

Run_analysis function reads unzipped data from text files in <./UCI HAR Dataset> folder.
The function attaches column names to data and adds subjectID and activity data to 
both test and training sets. Unneeded variables are dropped.
Test and training sets are merged into a single complete dataframe. 

For output, a condensed version of the complete dataset is compiled - for each activity 
performed by each person, the average of each variable is calculated. 
(Initial dataset contained many measurements per person per activity).
The output is written to a text file and is also a return value of the Run_analysis function.

Please refer to the codebook for description of variables in the dataset.

