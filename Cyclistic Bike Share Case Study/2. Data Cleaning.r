# 2. Data Cleaning
#Before we do any data cleaning, let's create a backup
combined_data_preclean = combined_data
#combined_data = combined_data_preclean

#Check the datatypes of each column
str(combined_data)
#Let's take a look at each column 1 by 1

#Check if there are any duplicates
anyDuplicated(combined_data)
### duplicated() returns T/F for each row and its not useful for us to see which row right now
### we just want to know if there are any duplicates right now, 0 indicates there are no duplicates

#Let's check if ride_id is unique because the context seems to tell us so
anyDuplicated(combined_data$ride_id)
### it's unique

#Let's check out rideable_type
unique(combined_data$rideable_type)

#Turn date columns with datatype format as date
### as.POSIXct will return NA if the value doesn't meet the specified format, let's check for any values that aren't empty and don't follow our format
head(combined_data$started_at[!is.na(combined_data$started_at)]) ### Sneak peak at first couple values in our column
combined_data$started_at[!is.na(combined_data$started_at) & !grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$", combined_data$started_at)]
### we want to return all values that are not null and does not follow the regular expression format which is equivalent to "2022-01-01 01:01:01"
### grepl() is used to search for a pattern within a character string or a vector of character strings and returns a logical vector indicating whether a match was found or not
### everything in [...] will be evaluated against each row of started_at and if it is TRUE, that row will be returned and therefore returns a subset of started_at that meets these conditions
### We can see that these dates follow a m/d/y h:m format instead of y-m-d h:m:s format

#Let's check if there is another format other than these 2
combined_data$started_at[!is.na(combined_data$started_at) & !grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$", combined_data$started_at)
                         & !grepl("^\\d{1,2}/\\d{1,2}/\\d{4} \\d{1,2}:\\d{2}$", combined_data$started_at)]
### character(0) means that there are no values that meet the conditions which confirms that these are the only 2 formats that exist, let's do the same
### thing to ended_at just to double check

#Double check with ended_at
combined_data$ended_at[!is.na(combined_data$ended_at) & !grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$", combined_data$ended_at)
                         & !grepl("^\\d{1,2}/\\d{1,2}/\\d{4} \\d{1,2}:\\d{2}$", combined_data$ended_at)]
### also returns no values, we are good with these two formats

#Lets turn all the dates into mo/d/yr h:m format since we don't really need the seconds anyways
### use the parse_date_time function from the lubridate library to convert values in one of the two formats into type POSIXct date-time
### since all the values are POSIXct, format() knows and can convert them all into the one format we wanted
combined_data$started_at = parse_date_time(combined_data$started_at, c("%m/%d/%Y %H:%M", "%Y-%m-%d %H:%M:%S"))
combined_data$started_at = format(combined_data$started_at, "%m/%d/%Y %H:%M")
combined_data$ended_at = parse_date_time(combined_data$ended_at, c("%m/%d/%Y %H:%M", "%Y-%m-%d %H:%M:%S"))
combined_data$ended_at = format(combined_data$ended_at, "%m/%d/%Y %H:%M")

#Turn the date columns into datetypes with timestamps
### since format() turns the values into type chr, we will need to use as.POSIXct() again to convert them back to date-time
combined_data$started_at = as.POSIXct(combined_data$started_at, format = "%m/%d/%Y %H:%M")
combined_data$ended_at = as.POSIXct(combined_data$ended_at, format = "%m/%d/%Y %H:%M")

# Create time difference between trips column
combined_data$time_diff_sec = as.numeric(difftime(combined_data$ended_at, combined_data$started_at, units = "secs"))
### difftime takes the difference between the first and second parameter; 1st date-time - 2nd datetime

## Create a df to scroll through data to double check
df_timecheck = combined_data %>% select(started_at, ended_at, time_diff_sec) %>% arrange(time_diff_sec)

#Divvy considers trips that are less than 60 seconds or more than 864000 seconds to be stolen bikes and are not real trips
df_timecheck_badtrips = df_timecheck %>% filter(time_diff_sec < 60 | time_diff_sec > 864000) %>% arrange(time_diff_sec) 
### It looks like we have some negative values as well as trips that last super long

## Let's swap the start and end times for the negative trips and remove the super long trips to clean it up
combined_data <- combined_data %>%
  mutate(
    temp = started_at, #Need to create a temp for ended_at to reference otherwise it will reference the same value since started_at will be changed to ended_at
    started_at = if_else(time_diff_sec < 0, ended_at, started_at),
    ended_at = if_else(time_diff_sec < 0, temp, ended_at)
  ) %>% select(-temp)
combined_data$time_diff_sec = as.numeric(difftime(combined_data$ended_at, combined_data$started_at, units = "secs"))
### We are only swapping start and end time since its clear they are illogical and inconsistent but we can't say the same for stations and lats/lngs
### Recalculate the difference in time since we swapped dates for those with negative time
combined_data = combined_data %>% filter(time_diff_sec >= 60 & time_diff_sec <= 864000)
min(combined_data$time_diff_sec)
max(combined_data$time_diff_sec)
### Filter out trips less than 1 minute and over 14400 minutes (10 days) then double checking mins and max

#Let's create some extra columns for our times: month, weekday, hour
### Using format() on our POSIXct values, we can easily specify which date-time part we want to extract
combined_data$start_month = format(combined_data$started_at, "%m")
combined_data$start_day = format(combined_data$started_at, "%A")
combined_data$start_hour = format(combined_data$started_at, "%H")

# Check start/end dates to see if they are all in 2022
min(combined_data$started_at)
max(combined_data$started_at)
min(combined_data$ended_at)
max(combined_data$ended_at)
### All of our trips start in 2022 but some end in 2023, still valid trips since they did start in 2022

# Check station names/ids for cleaning
df_startstations = combined_data %>% select(start_station_name, start_station_id) %>% distinct(start_station_name, start_station_id) %>% arrange(start_station_id)
df_endstations = combined_data %>% select(end_station_name, end_station_id) %>% distinct (end_station_name, end_station_id) %>% arrange(end_station_id)
### Many trips have blank stations/ids, 2 diff ids for normal station and public rack station name, ids end in .0, names have 'test' and 'charging' and 'divvy 001'
### and 'divvy cassette'

# We could turn all station ids and names to match where one contains the other for Public Racks but can't assume there isn't a difference between Public Racks
### and normal stations. We can clean the .0 ids and remove all tests, chargings, 001s and cassettes.
combined_data = combined_data %>% filter(!grepl('test|charging|divvy cassette|divvy 001', tolower(start_station_name)) &
                           !grepl('test|charging|divvy cassette|divvy 001', tolower(start_station_id))) %>%
  filter(!grepl('test|charging|divvy cassette|divvy 001', tolower(end_station_name)) &
           !grepl('test|charging|divvy cassette|divvy 001', tolower(end_station_id)))
### Filter out stations/ids that contain either of our 4 strings

# Create new df for start stations/ids ending in .0 and removing .0 at the end
dt_startstations0 = combined_data %>% select(start_station_id, start_station_name) %>% arrange(start_station_id)
dt_startstations01 = dt_startstations0 %>% mutate(
  start_station_name = gsub("\\.0$", "", start_station_name),
  start_station_id = gsub("\\.0$", "", start_station_id)
) %>% arrange(start_station_id)
### Create a subset of just start station names and ids and remove .0 at the end from them

dt_startstations0 = dt_startstations0 %>% distinct(start_station_id, start_station_name)
dt_startstations01 = dt_startstations01 %>% distinct(start_station_id, start_station_name)
### Double check via distinct values, start on row 368 and we skim other values ending in 0, we can see that it only affected those ending in .0

combined_data = combined_data %>% mutate(
  start_station_name = gsub("\\.0$", "", start_station_name),
  start_station_id = gsub("\\.0$", "", start_station_id),
  end_station_name = gsub("\\.0$", "", end_station_name),
  end_station_id = gsub("\\.0$", "", end_station_id)
)
### Replace station names/ids ending in .0 with empty through gsub




str(combined_data)




