This is a summary/documentation of what I did in the Rscripts for this project.
<br>
<br>
<br>
<br>

<h1 style="color:red;">ASK</h1>

# ASK

<br>
<br>

### What problem am I solving?

<br>
<br>
The director wants to maximize the number of annual memberships. Therefore we need to find the difference between casual riders and annual members and design a strategy to convert casuals into annuals. Our recommendations must be backed with compelling data insights and data visualizations.
<br>
<br>
<br>
<br>

# PREPARE

<br>
<br>

### Where is our data located? How is it organized? Are we allowed to use this data?

<br>
<br>
Our data is made available through monthly csv files and we have a license to use it.
<br>
<br>
<br>
<br>

# PROCESS

<br>
<br>

### Data Importing

<br>
<br>
I load all of the common libraries and ones that I need. Note: if two libraries have a function with the same name, the latest one is applied.

Created a function to set the working directory instead of hardcoding in the path line.

I have 12 csv files to load in as there is one for each month, I didn't want to repeat the same code 12 times so I grabbed all the csv files in the working directory, applied the read.csv function onto each csv file to turn them into a dataframe.

Checked if all the column names, column order, number of columns, and column types are the same.

Combined all of our dataframes into a single one.
<br>
<br>

### Data Cleaning

<br>
<br>
Created a backup of our combined dataframe before making any changes so I don't have to repeat the data importing process all over if I make a permanant mistake.

Checked for duplicated data, if certain data is unique, and what data types the columns are.

Our date columns is of chr data type. Previewed a sample of our date values to see how they look like. Initially, I tried to use POSIXct to convert the characters into date format but it did not work as there were 2 different formats.

I subsetted the date data using is.na and grepl with regular expression to see what the other format looked like. Subsetted it again with the other format included and returned no results meaning there are only null values and 2 different date formats.

I know that lubridate library has a lot of functions dealing with time so I looked into that and found the parse_date_time function which allowed me to convert the two date formats into POSIXct values then I formatted it using the format function so I have a singular format.

With proper dates, I created a column to show the difference in seconds between start and end dates. Deleted trips that were longer than 864000 or shorter than 60 as these are invalid trips or stolen bikes.

I also see negative time duration and notice that their end dates are behind their start dates. We swapped the dates and recalculated the time difference and cleaned them again.

Checked the mins and maxs of our dates to see if they are all in 2022. Some trips end in 2023 but everything starts in 2022, all good. We disaggregate our dates into months, days, and hour for granularity. 

I grabbed a list of distinct station names and ids and scrolled through them. I don't know of a good way to check/clean data like this. I scroll over and find things like testing, divvy 001, charging, ending in .0, etc and removed them.
<br>
<br>
<br>
<br>

# Analyze and Share

<br>
<br>

### Descriptive Statistics and Visualizations

<br>
<br>
Using group_by and summarise, I checked the number of rides made by casuals and members; members have a lot more trips. 

Checked how many trips were made on each bike type for the two groups; they both prefer electric bikes.

Created a quick graph to visualize the average trip duration in seconds for each group; casuals take longer trips

Made a line chart to see the number of trips each group makes per month. Did the same for weekdays and hours; Both groups have more trips in warmer months. Casuals like going out more on weekends than members. Members and Casuals both mainly take rides during daytime but Members spike in early morning and late afternoon.

Looked at the most popular stations via bar graph.

I tried to assign a zipcode to each trip using google maps API but since I was doing it on a row to row basis, Rstudio would crash even if I was doing it in batches. 
<br>
<br>

### Main Takeaways and Suggestions

<br>
<br>
As both groups enjoy riding electric bikes, we can make more available for members to incentivize more casual riders to become members.

Casuals tend to take longer trips than members, we can increase the amount of hourly/day passes so its cheaper for them to get an annual membership.

Since the rides are most popular for casuals during the summer season, on the weekends, and near the coastline of Lake Michigan, this time period and location is when our marketing campaign should begin. 
<br>
<br>
<br>
<br>

# Feedback

<br>
<br>
A majority of my work was on data cleaning and processing. I don't think this dataset was very suitable for any linear regressions or modeling so I mainly looked at the mins/maxs/avgs, etc. 

I don't know how this data was collected but some data validation rules like a picklist or character formatting would make it a lot better. 













