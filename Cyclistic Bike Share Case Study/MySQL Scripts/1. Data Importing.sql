#Data Importing Script
#Create tables for each csv file and load the csv file data into each table
#Combine all of the tables into one

#Check where our file path is to bypass securefilepriv option error and place all of our csv files in this path
SELECT @@global.secure_file_priv;

#All of our csv files are split into months for the year 2022, we will load each csv file as a separate table and clean it up to prepare for merging into one table
#I have checked out several files in Excel and it is way more than a million rows which is more than what Excel can handle on a single sheet
#We create a table with column names and datatypes based on what I have seen in the csv file
Create table IF NOT EXISTS biketrips_01_2022 (
ride_id TEXT NULL,
rideable_type TEXT NULL,
started_at DATETIME NULL,
ended_at DATETIME NULL,
start_station_name TEXT NULL,
start_station_id TEXT NULL,
end_station_name TEXT NULL,
end_station_id TEXT NULL,
start_lat DOUBLE NULL,
start_lng DOUBLE NULL,
end_lat DOUBLE NULL,
end_lng DOUBLE NULL,
member_casual TEXT NULL);


#Since all the tables should have the same columns and datatypes, I will create a table for each month duplicating the schema
Create table IF NOT EXISTS biketrips_02_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_03_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_04_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_05_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_06_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_07_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_08_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_09_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_10_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_11_2022 LIKE biketrips_01_2022;
Create table IF NOT EXISTS biketrips_12_2022 LIKE biketrips_01_2022;

#Our csv files are too big to manually import so we will use LOAD DATA INFILE to speed it up
#Unfortunately LOAD DATA is not allowed in Stored Procedures nor IF clauses because it requires file-level privileges which could be a security risk if used inside a stored procedure
#We will have to repeat the code 12x to get each month into their own table
#!!!Careful not to run it more than once because it will get loaded into the table again and have duplicated data!!!!
#January biketrips_01_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202201-divvy-tripdata.csv'
INTO TABLE biketrips_01_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');


#February biketrips_02_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202202-divvy-tripdata.csv'
INTO TABLE biketrips_02_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#March biketrips_03_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202203-divvy-tripdata.csv'
INTO TABLE biketrips_03_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#April biketrips_04_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202204-divvy-tripdata.csv'
INTO TABLE biketrips_04_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#May biketrips_05_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202205-divvy-tripdata.csv'
INTO TABLE biketrips_05_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#June biketrips_06_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202206-divvy-tripdata.csv'
INTO TABLE biketrips_06_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#July biketrips_07_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202207-divvy-tripdata.csv'
INTO TABLE biketrips_07_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#August biketrips_08_2022
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202208-divvy-tripdata.csv'
INTO TABLE biketrips_08_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%Y-%m-%d %H:%i:%s'),
ended_at = STR_TO_DATE(@ended_at, '%Y-%m-%d %H:%i:%s');

#September biketrips_09_2022
##When you view this file in excel, there seems to be no problems however in notepad, all values have double quotes around them, to fix this, we open up the excel file and save it as a CSV file again but
#using the tools function -> Web Options in the SAVE AS screen, we select Encoding to be Unicode (UTF-8)
###The dates for this file is also not in the format as the previous ones, we will adjust the STR_TO_DATE function as needed
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202209-divvy-tripdata.csv'
INTO TABLE biketrips_09_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%m/%d/%Y %H:%i'),
ended_at = STR_TO_DATE(@ended_at, '%m/%d/%Y %H:%i');

#October biketrips_10_2022
##This file has the same problems as above as well. Save with correct encoding and change STR_TO_DATE parameters
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202210-divvy-tripdata.csv'
INTO TABLE biketrips_10_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%m/%d/%Y %H:%i'),
ended_at = STR_TO_DATE(@ended_at, '%m/%d/%Y %H:%i');

#November biketrips_11_2022
##Same problems as above
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202211-divvy-tripdata.csv'
INTO TABLE biketrips_11_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%m/%d/%Y %H:%i'),
ended_at = STR_TO_DATE(@ended_at, '%m/%d/%Y %H:%i');

#December biketrips_12_2022
##Same problems as above
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2022 Monthly/202212-divvy-tripdata.csv'
INTO TABLE biketrips_12_2022
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id,rideable_type,@started_at,@ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,@end_lat,@end_lng,member_casual)
SET end_lat = NULLIF(@end_lat,''),
end_lng = NULLIF(@end_lng,''),
started_at = STR_TO_DATE(@started_at, '%m/%d/%Y %H:%i'),
ended_at = STR_TO_DATE(@ended_at, '%m/%d/%Y %H:%i');

#Since we have a lot of data, let's check out wait_timeout and allowed packets
SHOW VARIABLES LIKE 'wait_timeout'; #28800
SHOW VARIABLES LIKE 'max_allowed_packet'; #67108864
##30 seconds might not be enough to union all of our data, we will have to modify our configuration file to allow for more time

#With all our tables imported, lets create one table for the year 2022
CREATE TABLE IF NOT EXISTS totalbiketrips_2022 AS
(SELECT * FROM biketrips_01_2022
UNION ALL
SELECT * FROM biketrips_02_2022
UNION ALL
SELECT * FROM biketrips_03_2022
UNION ALL
SELECT * FROM biketrips_04_2022
UNION ALL
SELECT * FROM biketrips_05_2022
UNION ALL
SELECT * FROM biketrips_06_2022
UNION ALL
SELECT * FROM biketrips_07_2022
UNION ALL
SELECT * FROM biketrips_08_2022
UNION ALL
SELECT * FROM biketrips_09_2022
UNION ALL
SELECT * FROM biketrips_10_2022
UNION ALL
SELECT * FROM biketrips_11_2022
UNION ALL
SELECT * FROM biketrips_12_2022);

#To make sure that all of our data actually made it into a single table, let's count up the rows and compare
Select count(*) from totalbiketrips_2022; #5667717
SELECT SUM(cnt) AS total_count #5667717
FROM (
SELECT COUNT(*) AS cnt FROM biketrips_01_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_02_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_03_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_04_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_05_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_06_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_07_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_08_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_09_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_10_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_11_2022
UNION ALL
SELECT COUNT(*) AS cnt FROM biketrips_12_2022
) AS counts;
##Great, it seems the sum of the rows from each table matches the number of rows in our final table





