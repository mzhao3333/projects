# 1. Data Importing
#Load in Libraries
library(tidyverse)
library(rstatix)
library(ggpubr)
library(magrittr)
library(readxl)
library(dplyr)
library(vctrs)
library(openxlsx)
library(fastDummies)
library(faraway)
library(caret)
library(car)
library(olsrr)
library(rpart.plot)
library(rpart)
library(dplyr)
library(randomForest)
library(janitor)
library(caTools)
library(zoo)
library(jtools)
library(car)
library(corrplot)
library(anytime)
library(lubridate)
library(scales)
library(ggplot2)
library(reshape2)
library(stats)

##Choose Working Directory; all your csv files should be in here
# Define a function to set the working directory using choose.dir()
setwd_popup <- function() {
  dir <- choose.dir()
  if (dir != "") {
    setwd(dir)
  }
}

# Call the function to open the popup and set the working directory
setwd_popup()


##Import and combine all csv files into a single dataframe
# Get a list of CSV files in the "data" folder
csv_files <- list.files(pattern = ".csv", full.names = TRUE) ###We can ignore the first parameter because our files are all located in the wd
### We want only the csv files since we will also be storing our R scripts in the same folder
### It doesn't matter if full.names are TRUE or FALSE since we're in WD and all files are in WD


# Read in the CSV files using lapply()
data_list <- lapply(csv_files, read.csv)
### lapply acts as a loop to read all the csv files and store them in data_list
### lapply is a function that applies a given function to each element of a list and returns a new list of the results
### In this case, csv_files contains the file names of all the csv files and we apply the read.csv function to each csv file
### Each csv file will now be stored as a dataframe within data_list as a list element



# Check if all CSV files have the same columns in the same order
same_cols <- sapply(data_list, function(x) identical(names(x), names(data_list[[1]])))
### sapply if a function that applies a given function to each element of a list or vector
### The difference is that sapply simplifies the output to a vector or matrix if possible and lapply returns a list
### function(x) is used to define an anonymous function or a lambda function. It specifies that we are defining a function with one input param 'x'
### The 'x' param is a placeholder for the individual elements of data_list that will be iterated over by the sapply function
### We use the identical() function to check names(x) where x is the current element of data_list
### The reason why we don't do names(data_list[[x]])) is because x is already iterating over each element of data_list and x returns a dataframe
### We don't use data_list[1] instead of data_list[[1]] either because the 1st one returns a list containing the 1st element instead of the actual first element
### of data_list which is a dataframe. Since it iterates over data_list, we can just check if all the column names for the other 11 dfs matches the 1st one


##Type check/Testing
class(data_list[1]) #list type
class(data_list[[1]]) #data.frame type
names(data_list[1]) #returns null because the first element doesn't have a name
names(data_list[[1]]) #selects the actual first element of data_list and returns the col names of the dataframe

# Print the results
if (all(same_cols)) { #You can technically use lapply for same_cols but you will get a warning as all() takes in an input of a vector of logical values (sapply returns vectors, lapply returns a list)
  cat("All CSV files have the same columns in the same order.\n")
} else {
  cat("Not all CSV files have the same columns in the same order.\n")
}
### The all() function is used to check whether all elements in same_cols are TRUE which means all elements of data_list have the same col names
### cat() stands for concatenate and print and is used to display messages/outputs to the user, \n is needed as it doesn't auto add newline char



# Check if all CSV files have the same number of columns
same_ncols <- sapply(data_list, function(x) ncol(x) == ncol(data_list[[1]]))
###ncol() is used to get the number of columns in a matrix or dataframe. For number of columns in a vector, you can use length() instead.

# Print the results
if (all(same_ncols)) {
  cat("All CSV files have the same number of columns.\n")
} else {
  cat("Not all CSV files have the same number of columns.\n")
}

# Get the column data types for each data frame in the list
col_classes <- lapply(data_list, function(x) sapply(x, class))
### lapply returns a list that takes data_list which is a list with each element being a list that contains a dataframe
### We use sapply(x, class) for each element which applies the class() function on each column of the dataframe and returns a vector of classtypes
### In a sense, its an inner for loop since lapply is the outerloop that iterates over each element of data_list (which are lists that contain a df)
### Then sapply iterates over each element of the current element (which is a df) and applies class() on each column
### Ex) lapply(data_list[[1]]) then sapply(data_list[[1]][1]), sapply(data_list[[1]][2])...then lapply((data_list[[2]])) then sapply(data_list[[2]][1]),sapply(data_list[[2]][2])
### Our final product is a list with each sublist containing the column types of each dataframe


# Check if all columns have the same data type in all data frames
all_col_classes_same <- all(sapply(col_classes, function(x) all(x == col_classes[[1]])))

if (all_col_classes_same) {
  cat("All data frames have matching column data types.\n")
} else {
  cat("Not all data frames have matching column data types.\n")
}
### Again, we are using all() to check if everything in the vector is TRUE returned from sapply()
### sapply() takes in col_classes and iterates over each element of the col_classes list using all() to check whether or not the current element is equal
### to the first element (the first element of col_classes)


# Combine the CSV files vertically using rbind()
combined_data <- do.call(rbind, data_list) #do.call() calls rbind() with all the dfs in data_list and returns a new df containing all rows
### from all the dfs in data_list. It is useful for us if we don't know how many things are in data_list and we don't have to state each df individually from
### data_list

# Print the combined data
print(combined_data)







