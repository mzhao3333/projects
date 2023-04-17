show columns from totalbiketrips_2022;

SHOW INDEXES FROM totalbiketrips_2022;

SELECT GROUP_CONCAT(column_name SEPARATOR ',') as all_columns
FROM information_schema.columns
WHERE table_name = 'totalbiketrips_2022';

#Store a view to double check if value swap is working as intended
Create view trip_duration_test as
select * from totalbiketrips_2022
where trip_duration_seconds < 60 or trip_duration_seconds > 864000
order by trip_duration_seconds;
select * from trip_duration_test;

##Let's create a table to test out the swap query first
create table tripdtest as
select * from totalbiketrips_2022
where trip_duration_seconds < 60 or trip_duration_seconds > 864000
order by trip_duration_seconds;

##swapping values
##Maybe use an inner join to basically duplicate the table and have the same 76 rows and then you can directly swap values
update tripdtest t1, tripdtest t2
SET t1.started_at = t2.ended_at, 
t1.ended_at = t2.started_at,
t1.start_station_name = t2.end_station_name,
t1.start_station_id = t2.end_station_id,
t1.end_station_name = t2.start_station_name,
t1.end_station_id = t2.start_station_id,
t1.start_lat = t2.end_lat,
t1.start_lng = t2.end_lng,
t1.end_lat = t2.start_lat,
t1.end_lng = t2.start_lng,
t1.trip_duration_seconds = t2.trip_duration_seconds*-1
where t1.ride_id = t2.ride_id;


select * from tripdtest;

select distinct end_station_name, end_station_id
from totalbiketrips_2022
order by 2;