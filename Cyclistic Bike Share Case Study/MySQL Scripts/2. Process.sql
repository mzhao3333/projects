#Goal of what we're doing
##Description of the queries
###Conclusion of queries


#We got an error for connecting to the SQL service and was solved through this:
#Open up service.msc as admin, rightclick on MYSQL service, properties, logon, check local system account, now you can start the service

#We will check and clean the dataset
#Let's check every column and see if there are any errors
#Before we do any cleaning, let's create a backup incase anything goes wrong
Create table IF NOT EXISTS pre_clean_totalbiketrips_2022
AS
SELECT *
FROM totalbiketrips_2022;

Create table IF NOT EXISTS totalbiketrips_2022
AS
SELECT *
FROM pre_clean_totalbiketrips_2022;

#Let's explore a sample of the dataset to get a feel for it
Select * from totalbiketrips_2022
LIMIT 10;

#Let's check if there are any duplicates for all columns
##Check Helper Queries script to return a list of column names separated by commas
select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual,count(*) as cnt
from totalbiketrips_2022
group by ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
Having cnt > 1; #returns nothing, no 'complete' duplicates found for all columns

#Ride_ID seems like it should be a unique identifier because every ride is different, let's check. The count of unique ride_ids should be the same as the total number of rows
SELECT count(*) from totalbiketrips_2022; ##5667717
Select COUNT(distinct ride_id) #5667717
from totalbiketrips_2022;

#Rideable_type has 3 unique values and doesn't seem to have any mispellings
select distinct rideable_type
from totalbiketrips_2022;

#Let's check the dates to see if it is truly all from the year 2022
##How about the duration of the trips? Are there any trips that last too short or too long?
Select started_at 
from totalbiketrips_2022
where started_at < '2022-01-01' or started_at >= '2023-01-01';

Select * 
from totalbiketrips_2022
where ended_at < '2022-01-01' or ended_at >= '2023-01-01';
###It appears we do have rides that end after 2022 but all of them started before 2022 ended

#Remove bad data where trip is less than 60 seconds or more than 864000 seconds because Divvy consider these as stolen bikes
##Let's create a calculated column for trip duration
ALTER TABLE totalbiketrips_2022 
ADD COLUMN trip_duration_seconds 
INT AS (TIMESTAMPDIFF(SECOND, started_at, ended_at));

##Let's check out the duration of the routes for stolen bikes
select * from totalbiketrips_2022
where trip_duration_seconds < 60 or trip_duration_seconds > 864000
order by trip_duration_seconds;
###It seems that there is also data entry error where started and ended might have been swapped

##We will have to disable safe update mode because we are 'updating' a table without a where clause that uses a KEY column
##Let's delete everything that has less than 60 secs and more then 864000 secs considering negatives as well
delete from totalbiketrips_2022
where (trip_duration_seconds >= 0 and trip_duration_seconds < 60) or trip_duration_seconds > 864000 or (trip_duration_seconds > -60 and trip_duration_seconds <= 0) or trip_duration_seconds < -864000;

#Let's swap all the starts and ends for negative trip_durations
##Let's create a table to store the negative trip duration rides
create table tripdtest as
select * from totalbiketrips_2022
where trip_duration_seconds < 60 or trip_duration_seconds > 864000
order by trip_duration_seconds;
select * from tripdtest;

#Delete rows where ride_ids are in tripdtest
##Instead of using a subquery to grab ride_ids from dtest to delete from, let's use an inner join to delete instead
##Inner join also takes a long time, let's try WHERE EXISTS with ccorrelated subquery instead; limit 1 row for deletion takes 13.735 seconds so for 76 rows it takes nearly 18 minutes, but for 2 rows, its almost a minute.
###Let's try creating indexes to prepare for deletion instead
SELECT MAX(LENGTH(ride_id)) AS max_length
FROM totalbiketrips_2022;
CREATE INDEX index_ride_id on totalbiketrips_2022(ride_id(16)); #Max length should be 16; takes 50 seconds

#Originally, I wanted to delete the rows that have ride_ids that exist in the test table but I think it's doing some reindexing which is incredibly slow even if its 76 rows
#!!!!!!!!!!Okay, let's try not doing the calculated field as that weird stored generated thing, let's just make it a normal calculated field with timestampdiff!!!#
UPDATE totalbiketrips_2022 t1, tripdtest t2
SET 
t1.started_at = t2.ended_at,
t1.ended_at = t1.started_at,
t1.start_station_name = t2.end_station_name,
t1.start_station_id = t2.end_station_id,
t1.end_station_name = t2.start_station_name,
t1.end_station_id = t2.start_station_id,
t1.start_lat = t2.end_lat,
t1.start_lng = t2.end_lng,
t1.end_lat = t2.start_lat,
t1.end_lng = t2.start_lng
where t1.ride_id = t2.ride_id AND t1.ride_id in (select ride_id from tripdtest);

#Note that our trip_duration_seconds column automatically recalculates our start/end times so no need to make it positive again
select *
from totalbiketrips_2022 t1
where t1.ride_id in (select ride_id from tripdtest);


#Let's check the station names now
#It is possible using the soundex() function to compare phonetically but I'm not sure if it is too helpful in this case
select distinct start_station_name
from totalbiketrips_2022;

#More useful check is if the ids for the start and end stations actually match
#We can use some cross-field validation to check station ids bc theoretically each station should be the same id regardless of start or end
#Lets create a list of station names and their ids and then check each start station and their id as well as end station and their id to see if it matches
#This can be applied to start/end lat/lng as well

#A quick glance at this data shows us that some of the start stations are named slightly different but have the same id as well as having the same start station name but the one of the ids have a .0 at the end
#Looking at it, there is actually a bunch of mistakes which ranges to have the station name as the id, naming the id as a chargingstx, having wrong station names, have the ids be a name, not fully filling things out
#We will have to check each thing and correct each thing one by one and focus on fixing start/end IDs
select distinct end_station_name, end_station_id
from totalbiketrips_2022
order by 2;

#Station_IDs ending in .0
UPDATE totalbiketrips_2022
SET end_station_id = REPLACE(end_station_id, '.0', '')
WHERE end_station_id LIKE '%.0';
UPDATE totalbiketrips_2022
SET start_station_id = REPLACE(start_station_id, '.0', '')
WHERE start_station_id LIKE '%.0';

#I don't have enough information/context to determine if rows with 'Charging' are deemed as actual rides or are they just charged for the duration
##So my assumption will be that they are not counted as actual rides and will be deleted along with tests
select *
from totalbiketrips_2022
where lower(start_station_name) LIKE '%test%' or lower(start_station_name) like '%charging%' or
lower(end_station_name) LIKE '%test%' or lower(end_station_name) like '%charging%' or
lower(end_station_id) LIKE '%test%' or lower(end_station_id) like '%charging%' or
lower(start_station_id) LIKE '%test%' or lower(start_station_id) like '%charging%' or
lower(start_station_name) LIKE '%test%' or lower(start_station_name) like '%charging%';

#Deleting all rows that pertain to testing or charging
Delete from totalbiketrips_2022
where lower(start_station_name) LIKE '%test%' or lower(start_station_name) like '%charging%' or
lower(end_station_name) LIKE '%test%' or lower(end_station_name) like '%charging%' or
lower(end_station_id) LIKE '%test%' or lower(end_station_id) like '%charging%' or
lower(start_station_id) LIKE '%test%' or lower(start_station_id) like '%charging%' or
lower(start_station_name) LIKE '%test%' or lower(start_station_name) like '%charging%';

#Divvy Valet is a Valet Service during peak usage times where a staff member will acept more bikes than a station would typically allow
#DIVVY 001s and DIVVY CASSETTEs are both repair centers and are not actual trips, let's delete these
select *
from totalbiketrips_2022
where lower(start_station_name) like '%divvy 001%' or lower(end_station_name) like '%divvy 001%' or
lower(end_station_name) like '%divvy 001%' or lower(end_station_name) like '%divvy 001%' or
lower(start_station_id) like '%divvy 001%' or lower(start_station_id) like '%divvy 001%' or
lower(end_station_id) like '%divvy 001%' or lower(end_station_id) like '%divvy 001%' or
lower(start_station_name) like '%divvy cassette%' or lower(end_station_name) like '%divvy cassette%' or
lower(end_station_name) like '%divvy cassette%' or lower(end_station_name) like '%divvy cassette%' or
lower(start_station_id) like '%divvy cassette%' or lower(start_station_id) like '%divvy cassette%' or
lower(end_station_id) like '%divvy cassette%' or lower(end_station_id) like '%divvy cassette%';

delete from totalbiketrips_2022
where lower(start_station_name) like '%divvy 001%' or lower(end_station_name) like '%divvy 001%' or
lower(end_station_name) like '%divvy 001%' or lower(end_station_name) like '%divvy 001%' or
lower(start_station_id) like '%divvy 001%' or lower(start_station_id) like '%divvy 001%' or
lower(end_station_id) like '%divvy 001%' or lower(end_station_id) like '%divvy 001%' or
lower(start_station_name) like '%divvy cassette%' or lower(end_station_name) like '%divvy cassette%' or
lower(end_station_name) like '%divvy cassette%' or lower(end_station_name) like '%divvy cassette%' or
lower(start_station_id) like '%divvy cassette%' or lower(start_station_id) like '%divvy cassette%' or
lower(end_station_id) like '%divvy cassette%' or lower(end_station_id) like '%divvy cassette%';

#Let's look at the geographical data
##It seems that even though it was at the same start_station, the lat/long values differ slightly in decimal points, this isn't super relevant to our business task so we can ignore this
select * from totalbiketrips_2022
where start_station_name != '' and length(start_lat) > 8
order by start_station_name
limit 10;


#What is the purpose of our analysis? How much of the data cleaning do we actually need to do? How accurate do our results have to be/how many rows do we need to clean to derive 
#a recommendation with >85% or so of positivty?

