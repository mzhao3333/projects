#Our goal is to try and find a difference/trends between casual riders and annual riders as well as designing a strategy to convert casuals into annuals
#This includes finding out the difference in bike types, trip durations, and start/end stations
#Let's check out summary statistics
select avg(trip_duration_seconds)
from totalbiketrips_2022; #1143.5736 seconds or 19.05656 minutes

select min(trip_duration_seconds)
from totalbiketrips_2022; #60 seconds which makes sense since anything under 60 is considered stolen or a bad trip

select max(trip_duration_seconds)
from totalbiketrips_2022; #863867 seconds or 14397.783 minutes or 239.963 hours or 9.9984 days
##Is it possible to have such a long trip?

select *
from totalbiketrips_2022
where trip_duration_seconds = (select max(trip_duration_seconds)
from totalbiketrips_2022); #We can see that it is a docked bike however, what exactly is a docked bike?

select *
from totalbiketrips_2022
order by trip_duration_seconds desc
limit 2000; #We can see that docked bikes have the longest trip durations, does it mean that when a person returns a bike (started_at) it stays docked until someone uses it (ended_at)?

select *
from totalbiketrips_2022
where rideable_type != 'docked_bike'
order by trip_duration_seconds desc
limit 1000; #We can see that without docked bikes, the highest trip duration belongs to an electric bike that lasts for around 7 days and is returned to nearly the same place based on the start and end lats/lngs
#It is around 6.6 times more than the next trip duration which is only 93596 seconds and is definitely an outlier
#621180s or 10353m or 172.55h or 7.2d

select rideable_type, avg(trip_duration_seconds), count(trip_duration_seconds)
from totalbiketrips_2022
group by 1; #We can see that electric bikes on avg have a shorter trip (probably because they are faster) than classic bikes and more popular as well. 

select *
from totalbiketrips_2022
where rideable_type = 'docked_bike' and (end_station_name != '' or end_station_id != '')
order by trip_duration_seconds desc
limit 1000; #Checking out rows for docked bikes where there is actually an end present; I'm confused as to how a bike is assigned a rideable_type.
#The website stats that a dock holds each individual bicycle where they are locked and must be unlocked before you can ride it. 
#It says that you should always wait to make sure your bike is locked and your ride has ended so I can infer that some docked_bike rides did not end at the correct time/place due to user error.
#Since I'm not 100% sure what a docked_bike represents, I'm going to just count it as a regular trip


#Let's check out the difference for casuals and annuals
#Counts and percentage
select member_casual, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022) * 100 as perc
from  totalbiketrips_2022
group by 1; #We can see that casuals make up ~41% and members make up ~59% this means that there is a lot of potential for profit as there are many casual riders that can be converted to members

#Bike Types
select member_casual, rideable_type, count(rideable_type) as bike_cnt, count(rideable_type)/(select count(rideable_type) from totalbiketrips_2022)*100 as bike_all_perc,
COUNT(rideable_type) / SUM(COUNT(rideable_type)) OVER (PARTITION BY member_casual) * 100 AS bike_perc_pergrp
from totalbiketrips_2022
group by 1,2
order by 1,2,3; #We can see that the electric bike is the most popular for casuals but classic is best for members by a small margin.

#Trip Durations
select member_casual, avg(trip_duration_seconds)
from totalbiketrips_2022
group by 1; #Casuals' avg trip duration is ~1670 secs or ~28 min vs members' at ~777 secs or ~13 min which is almost doubled for Casuals
#it's possible that this is skewed due to docked bikes as they only exist for casuals, let's remove them and see

select member_casual, avg(trip_duration_seconds)
from totalbiketrips_2022
where rideable_type != 'docked_bike'
group by 1; #Without docked bikes, Casuals' avg trip duration only dropped by 300 seconds or 5 minutes which isn't a huge amount but noticeable
#Let's check out the average duration for each bike type for each group

select member_casual, rideable_type, avg(trip_duration_seconds)
from totalbiketrips_2022
group by 1,2
order by 1,2,3; #It seems like casuals take long trips compared to members. On the site, it says that it is $1 to unlock the bike and $0.17 a minute for non-members
#There is also a day pass for $16.5 with unlimited 3-hour rides for 24 hours and $0.17 a minute after 3 hours
#Then there is the $10/month annual membership with unlimited 45-min rides
#It's difficult to find how many rides/riders would've benefitted and how much they would've benefitted from being an annual member because we don't know if they had single ride or day pass
#and we don't have a user ID that these rides belong 

#Let's check out which stations have a high usage rage as well as the percentage compared to the rest of the trips
select start_station_name, start_station_id, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022) * 100 AS percentage, 
count(*) - lag(count(*)) over (order by count(*) desc) as cnt_difference
from totalbiketrips_2022
group by 1,2
order by count(*) desc;
#We can see that a majority of our trips have a blank start station so our most popular one is Streeter Dr & Grand Ave which is 1.3434% of all trips. There is not a huge jump in counts other than the first couple of rows

#Let's do the same thing for end stations
select end_station_name, end_station_id, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022) * 100 AS percentage, 
count(*) - lag(count(*)) over (order by count(*) desc) as cnt_difference
from totalbiketrips_2022
group by 1,2
order by count(*) desc;
#It is similar to the start stations with Streeter being the most popular which makes sense because that area is actually Navy Pier, one of the top tourist attractions in Chicago
#Therefore people travel to and from Navy Pier a lot

#Let's remind ourselves of the task: Design a strategy to convert casuals into annuals, have recommendations backed by insights and viz
#I am thinking of a marketing campaign targeted towards casual riders therefore we will need to find the locations where casual riders most frequent
select start_station_name, start_station_id, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022) * 100 AS percentage, 
count(*) - lag(count(*)) over (order by count(*) desc) as cnt_difference
from totalbiketrips_2022
where member_casual LIKE '%casual%'
group by 1,2
order by count(*) desc;

select end_station_name, end_station_id, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022) * 100 AS percentage, 
count(*) - lag(count(*)) over (order by count(*) desc) as cnt_difference
from totalbiketrips_2022
where member_casual LIKE '%casual%'
group by 1,2
order by count(*) desc; #No surprise here, both start/end stations for casual riders are at Navy Pier

#Since a marketing campaign doesn't last forever, we can try to minimize campaign efforts by targeting certain days or months
##Let's find out on average which days are the most popular
###Create helper columns for months and days
ALTER TABLE totalbiketrips_2022 
ADD COLUMN month
INT NOT NULL DEFAULT 0;
UPDATE totalbiketrips_2022 SET month = MONTH(started_at); #I choose to use started_at because I know that all of the rides start in 2022 and some end in 2023

ALTER TABLE totalbiketrips_2022 
ADD COLUMN weekday
INT NOT NULL DEFAULT 0;
UPDATE totalbiketrips_2022 SET weekday = DAYOFWEEK(started_at); #Saturday is 7 and Sunday is 1 and Monday is 2 and so on

#What are the most popular months for casuals?
select month, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022 where member_casual LIKE '%casual%') as perc
from totalbiketrips_2022
where member_casual LIKE '%casual%'
group by 1
order by 2 desc; #The most popular months are 7,6,8 which makes sense as they are summer months and people are going out more
#Our marketing campaign can start in May and end in October

#What are the most popular days?
select weekday, count(*) as cnt, count(*)/(select count(*) from totalbiketrips_2022 where member_casual LIKE '%casual%') as perc
from totalbiketrips_2022
where member_casual LIKE '%casual%'
group by 1
order by 2 desc; #Saturday and Sunday are the most popular followed by Friday, makes sense as these are the weekend days
#Given a budget or some sort of timeframe, I would definitely refer to these two queries to decide


#I would start the marketing campaign during the summer and focus weekends especially
#I would focus on locations near Navy Pier and the most popular stations
#Add more electric bikes for casuals
#For the campaign, give casuals a trial session/period of free rides when they sign up for annual, maybe the first month free


#collect better data for point of entry for clean data	
#include whether or not single ride or day pass as well as user id data
#Give free rides at popular stations

#To export returns of the queries. run the query and you can export it as different file types
