# ASK



### What problem am I solving?


The director wants to maximize the number of annual memberships. Therefore we need to find the difference between casual riders and annual members and design a strategy to convert casuals into annuals. Our recommendations must be backed with compelling data insights and data visualizations.



# PREPARE



### Where is our data located? How is it organized? Are we allowed to use this data?


Our data is made available through monthly csv files and we have a license to use it.



# PROCESS



### Data Importing


We load all of the common libraries and ones that we need. Note: if two libraries have a function with the same name, the latest one is applied.
Created a function to set the working directory instead of hardcoding in the path line.
We have 12 csv files to load in as there is one for each month, I didn't want to repeat the same code 12 times so I grabbed all the csv files in the working directory, applied the read.csv function onto each csv file to turn them into a dataframe.
Checked if all the column names, column order, number of columns, and column types are the same.
Combined all of our dataframes into a single one.
