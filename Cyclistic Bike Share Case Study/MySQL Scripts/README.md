This is a summary/documentation of what I did in MySQL for this project.
<br>
<br>
<br>
<br>

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
I first tried to manually load each csv file as a table into MySQL but it wouldn't even load one table for one csv file. I looked into alternatives and found the LOAD DATA INFILE function.
<br>
I created an empty table with all the same columns as the csv files and data types I deemed to be most logical. Then I duplicated this table since each month of data is in a separate csv file.

LOAD DATA isn't allowed in Stored Procedures so we manually copy-pasted the same code, making changes to the pathfile name and the table loaded into.

I actually had a lot of trouble with this as some csv files were actually encoded different and I had to resave it with the proper encoding and there were different date formats and null values as well.
The configurations for MySQL also had to be modified because of the huge size of the data so I gave it a longer wait time so it doesn't time out and stop the query.

After that I joined all the tables together into a single one and double checked the number of rows of the merged table vs the aggregate sum of each individual table.
<br>
<br>

### Data Cleaning

<br>
<br>
Created another table to store our merged table before we started our data cleaning process so we don't have to redo the data importation step if anything goes wrong.

It is always good practice to have a preview of the data to get a brief shallow understanding of the context. We select all columns and limit it to see this.

Checked if there are any duplicates, if all IDs are unique, different unique values in certain columns.

We begin our cleaning process by checking if all the trips were in 2022. They all started in 2022 and some end in 2023 which is fine. 

We create a calculated column to see the time each trip took using the start and end dates and then we delete those that are too short or too long. It is recommended to select this data first before deleting so you know exactly what you're deleting.

Thanks to this selection, we see that there are negative trip durations as well and upon closer look, the start and end dates are supposedly swapped. We find that deleting and updating takes a super long time due to the lack of indexes. We create an index on ride_id which sped it up significantly more.

Update the dataset to swap the start dates and stations with end dates and stations.

Recheck our data cleaning efforts to make sure it went right. 

We preview the unique values of our station names and IDs to get a quick glimpse. Scrolling down, I see things ending in .0, charging, test, divvy 001, cassette. Based on this case study, all of these stations are not 'real' trips as they are charging stations, repair centers, and tests. We delete all rows that match this criteria.

Previewing the latitude and longitude fields, we see that it is not super consistent, some are more accurate than others with more decimal places.


<br>
<br>
<br>
<br>

# Analyze

<br>
<br>

### Descriptive Statistics

<br>
<br>
We check the summaries of our trip duration column and found that the longest trip was nearly 10 days. We filter to see the row with this trip duration and see that its bike type is 'docked'. Upon further research, trips with docked bike types are not actual trips and should be excluded from the analysis.

Using group_by to aggregate, we find that electric bikes are more popular and results in a shorter trip in general.

We start to find the differences between casuals and members by finding the amount of casual trips vs member trips. It is unfortunate that there is no User ID or anything to identify who is riding the bike, we only know whether or not this was a casual/member trip and not the actual number of people that belong to each group.

We explore their differences via bike types, trip durations, popular stations, months, days, and hours.
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

# Helper Queries

It is extremely helpful to have a separate query tab open to just view the dataset as well as to test things.

One useful query I created allowed me to grab all the column names separated by ',' to be used during LOAD DATA importing.
<br>
<br>
<br>

# Feedback

<br>
<br>
There is not a whole lot of analysis other than descriptive since we're only trying to find out the differences between members and casuals. The only variables we had were what bikes they rode, the time, and location.

If I had more information like USER ID, what type of pass they had, and demographics, I could have better analysis and suggestions but I understand that it was not provided for the sake of security and privacy.

I don't know how this data was collected but some data validation rules like a picklist or character formatting would make it a lot better. 














