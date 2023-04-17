# ASK



### What problem am I solving?


The director wants to maximize the number of annual memberships. Therefore we need to find the difference between casual riders and annual members and design a strategy to convert casuals into annuals. Our recommendations must be backed with compelling data insights and data visualizations.



# PREPARE



### Where is our data located? How is it organized? Are we allowed to use this data?


Our data is made available through monthly csv files and we have a license to use it.



# PROCESS



### Data Importing


I load all of the common libraries and ones that I need. Note: if two libraries have a function with the same name, the latest one is applied.

Created a function to set the working directory instead of hardcoding in the path line.

I have 12 csv files to load in as there is one for each month, I didn't want to repeat the same code 12 times so I grabbed all the csv files in the working directory, applied the read.csv function onto each csv file to turn them into a dataframe.

Checked if all the column names, column order, number of columns, and column types are the same.

Combined all of our dataframes into a single one.


### Data Cleaning


Created a backup of our combined dataframe before making any changes so I don't have to repeat the data importing process all over if I make a permanant mistake.

Checked for duplicated data, if certain data is unique, and what data types the columns are.

Our date columns is of chr data type. Previewed a sample of our date values to see how they look like. Initially, I tried to use POSIXct to convert the characters into date format but it did not work as there were 2 different formats.

I subsetted the date data using is.na and grepl with regular expression to see what the other format looked like. Subsetted it again with the other format included and returned no results meaning there are only null values and 2 different date formats.

I know that lubridate library has a lot of functions dealing with time so I looked into that and found the parse_date_time function which allowed me to convert the two date formats into POSIXct values then I formatted it using the format function so I have a singular format.

With proper dates, I created a column to show the difference in seconds between start and end dates. Deleted trips that were longer than 864000 or shorter than 60 as these are invalid trips or stolen bikes.

I also see negative time duration and notice that their end dates are behind their start dates. We swapped the dates and recalculated the time difference and cleaned them again.

Checked the mins and maxs of our dates to see if they are all in 2022. Some trips end in 2023 but everything starts in 2022, all good. We disaggregate our dates into months, days, and hour for granularity. 

I grabbed a list of distinct station names and ids and scrolled through them. I don't know of a good way to check/clean data like this. I scroll over and find things like testing, divvy 001, charging, ending in .0, etc and removed them.



# Analyze


### Descriptive Statistics


Using group_by and summarise, I checked the number of rides made by casuals and members; members have a lot more trips. 







