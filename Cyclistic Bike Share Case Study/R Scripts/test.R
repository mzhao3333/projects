#geocode testing

# Install and load the zipcodeR package
install.packages("zipcodeR")
library(zipcodeR)
library(ggmap)
# Specify the latitude and longitude values
lat <- 41.8781
lng <- -87.6298

# Find the ZIP code using the geo_zip() function
zip_code <- geo_zip(lat = lat, lon = lng)

# Print the result
print(zip_code)

print(geocode_zip(60609))



library(ggmap)
register_google(key = "") #deleted for privacy


str(divvy_2022_cleaned)
divvy_2022_zips = divvy_2022_cleaned


### Okay, the API key works, one caveat is that if you click on the link and open it up in your browser, you won't get access, only your Rstudio session has access
### Also be careful of output = all or address, in our case we can just use address and return the zipcode after it gives us the address in Chicago
### we can probably do some splits to grab IL 60609 and then grab the last 5 characters
location = revgeocode(c(-87.64862,41.86732), output = "address")
print(
  substr(strsplit(location, ",")[[1]][3],start = 5, stop = 9)
  )

divvy_2022_zips$start_zipcodes <- apply(divvy_2022_cleaned[, c("start_lng", "start_lat")], 1, function(x) {
  address <- revgeocode(c(x[1], x[2]), output = "address")
  return(substr(strsplit(address, ",")[[1]][3],start = 5, stop = 9))
})


# Create a new column in the data frame
divvy_2022_zips$start_zipcodes <- NA

# Split the data into batches of 10,000 rows
num_batches <- ceiling(nrow(divvy_2022_zips) / 10000)

for (i in 1:num_batches) {
  start <- (i - 1) * 10000 + 1
  end <- min(i * 10000, nrow(divvy_2022_zips))
  print("Batch:",i)
  # Apply the function to the subset of data
  divvy_2022_zips$start_zipcodes[start:end] <- apply(divvy_2022_zips[start:end, c("start_lng", "start_lat")], 1, function(x) {
    address <- revgeocode(c(x[1], x[2]), output = "address")
    return(substr(strsplit(address, ",")[[1]][3],start = 5, stop = 9))
  })
}

str(divvy_2022_zips)

str(divvy_2022_cleaned)


divvy_2022_tableaufiltered = divvy_2022_cleaned %>% filter(start_month %in% c("05","06","07")) %>% select(ride_id, start_lat, start_lng) 
write.csv(divvy_2022_tableaufiltered, "divvy_2022_tableaufiltered", row.names = FALSE)

str(divvy_2022_tableaufiltered)

# Generate a set of random row indices to delete
rows_to_delete <- sample(nrow(divvy_2022_tableaufiltered), size = 1500000, replace = FALSE)

# Delete the selected rows from the data frame
divvy_2022_tableaufiltered <- divvy_2022_tableaufiltered[-rows_to_delete,]

library(openxlsx)

# Create a new workbook
myWorkbook <- createWorkbook()

# Add a new worksheet
addWorksheet(myWorkbook, sheetName = "mySheet")

# Write some data to the worksheet
writeData(myWorkbook, "mySheet", divvy_2022_tableaufiltered)

# Save the workbook to a file
saveWorkbook(myWorkbook, "divvy_2022_tableaufiltered.xlsx", overwrite = TRUE)

