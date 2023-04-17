# 3. Data Analyze
# Our goal is to find a marketing strategy to convert casual riders into annual members backed by data insights

str(combined_data)

# Let' see how many casuals and members there are
gb_mc = combined_data %>% group_by(member_casual) %>% summarise(count = n())
gb_mc
### There is almost a million more trips with members than casuals with members at around 3.26 million

# Let's explore what sort of bikes casuals and members like to ride
gb_mc_rt = combined_data %>% group_by(member_casual, rideable_type) %>% summarise(count = n())
gb_mc_rt

mc_rtplot = combined_data %>% group_by(member_casual, rideable_type) %>% summarise(n_rides = n()) %>%
  ggplot(aes(x = member_casual, y = n_rides, fill = rideable_type)) +
  geom_col(position = "dodge")
mc_rtplot
### Casuals and Members both prefer electric bikes than classic bikes.
### A little devious but we can reduce the number of electric bikes available for Casuals to incentivize Casuals to become annual members
unique(combined_data$rideable_type)
# Let's explore the date/time differences between Casuals and Members
## We can see that casuals tend to take longer trips than members
avgtrip_plot = combined_data %>% group_by(member_casual) %>% summarise(avg_trip = mean(time_diff_sec)) %>% 
  ggplot(aes(x = member_casual,y = avg_trip, fill = member_casual)) +
  geom_bar(stat = "identity", width = 0.25) +
  geom_text(aes(label = round(avg_trip,2), vjust = -0.5))
avgtrip_plot
### We only want two bars to graph casuals and members. By grouping it, we essentially create a 2x2
### use ggplot to create our plot and map our variables
### use geom_bar for bar graphs and stat = "identity" to plot the actual values provided in the y aesthetic (avg_trip)
### use geom_text to add values on top of our bars

## Recall that there is a 3rd rideable_type called docked_bike, without it, the avg trip duration for Casuals drop by nearly 300 seconds
avgtrip_plot2 = combined_data %>% filter(rideable_type != "docked_bike") %>% group_by(member_casual) %>% summarise(avg_trip = mean(time_diff_sec)) %>% 
  ggplot(aes(x = member_casual,y = avg_trip, fill = member_casual)) +
  geom_bar(stat = "identity", width = 0.25) +
  geom_text(aes(label = round(avg_trip,2), vjust = -0.5))
avgtrip_plot2

# Let's see the difference of trips in months, days, and hours between casuals and members
## We can see for each month, members always have more trips than casuals which makes sense since there are a million more members
## The overall trend shows that the rides pick up around May and ends by the end of October
monthtrip_plot = combined_data %>% group_by(member_casual, start_month) %>% summarise(n_rides = n()) %>%
  ggplot(aes(x = start_month, y = n_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = sprintf("%sK", comma(round(n_rides/1000))), vjust = -0.5))
monthtrip_plot
### use a series of complex formatting to show labels in 100 thousands

## Members tend to go out more on the weekends. Surprisingly, weekends for Casuals are on the lower end. Maybe there is a correlation between 
## having a member class and going out on weekends.
weekday_names <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
daytrip_plot = combined_data %>% group_by(member_casual, start_day) %>% summarise(n_rides = n()) %>% 
  ggplot(aes(x = start_day, y = n_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = sprintf("%sK", comma(round(n_rides/1000))), vjust = -0.5)) +
  scale_x_discrete(labels = weekday_names)
daytrip_plot
### Create a list of ordered weekday strings so that we can order the bars in the plot through scale_x_discrete

## Members and Casuals seem to follow the overall trend and start their trips at roughly the same time.
## Members have a lot more activity between hours 6-9 and 16-18 probably because they are using these rides for going and returning from work
hourtrip_plot = combined_data %>% group_by(member_casual, start_hour) %>% summarise(n_rides = n()) %>% 
  ggplot(aes(x = start_hour, y = n_rides, fill = member_casual)) +
  geom_col(position = "dodge")
hourtrip_plot

# Let's take a look at the most start popular stations
gb_mc_startstation = combined_data %>% group_by(member_casual, start_station_name) %>% summarise(n_rides = n()) %>% arrange(desc(n_rides))
gb_mc_startstation

## Plot the most popular start stations for casuals and members
startstation_plot <- combined_data %>% 
  filter(!is.na(start_station_name) & !is.na(member_casual) & start_station_name != "" & member_casual != "") %>% 
  group_by(member_casual, start_station_name) %>% 
  summarise(n_rides = n()) %>% 
  arrange(desc(n_rides)) %>%
  mutate(rank = dense_rank(desc(n_rides))) %>% # add a rank column
  filter(rank <= 10) %>% # filter for the top 10 stations
  ggplot(aes(x = reorder(start_station_name, n_rides), y = n_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(x = "Start Station", y = "Number of Rides", fill = "User Type") +
  scale_fill_manual(values = c("#FDB813", "#0072B2")) + # set custom colors
  theme_minimal() + # apply a minimal theme
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +# rotate x-axis labels
  coord_flip()

## Plot the most popular end stations for casuals and members
endstation_plot <- combined_data %>% 
  filter(!is.na(end_station_name) & !is.na(member_casual) & end_station_name != "" & member_casual != "") %>% 
  group_by(member_casual, end_station_name) %>% 
  summarise(n_rides = n()) %>% 
  arrange(desc(n_rides)) %>%
  mutate(rank = dense_rank(desc(n_rides))) %>% # add a rank column
  filter(rank <= 10) %>% # filter for the top 10 stations
  ggplot(aes(x = reorder(end_station_name, n_rides), y = n_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(x = "End Station", y = "Number of Rides", fill = "User Type") +
  scale_fill_manual(values = c("#FDB813", "#0072B2")) + # set custom colors
  theme_minimal() + # apply a minimal theme
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +# rotate x-axis labels
  coord_flip()
endstation_plot
### For casuals, the top start/end stations are mostly the same. If you look up all these streets, you would find that all of these are near
### Lake Shore Drive which is on the coast line of Lake Michigan. Many tourist locations reside there as well such as Navy Pier, Millennium Park, and Shedd Aquarium.

# Key takeaways and recommendations for the marketing campaign
## Key Takeaways
print("Both Casuals and Members ride Electric Bikes moreso than Classic bikes")
print("On average, Casuals take longer trips than Members")
print("Casuals have more rides in warmer months from May till the end of October")
print("Casuals tend to ride their bikes on Wednesdays and Thursdays")
print("Casuals have increased bike activity during 4 PM - 6 PM")
print("Casuals take the most trips along the coast line of Lake Michigan")

## Recommendations
print("Make more Electric Bikes available for Members (possibly decrease electric bikes for casuals) to drive more Casuals to become members")
print("Increase the amount that Casuals have to pay the longer their rides are to incentivize getting a membership")
print("Create a summer marketing campaign that gives a sale/discount for new members such as the first month free")
print("Send out weekly reminders on Wednesdays during the work day to non-members to inform them of new marketing campaign perks")
print("Physical marketing such as fliers/mascots/demonstrations/etc should take place near the coast line of Lake Michigan")






