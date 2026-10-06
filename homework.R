#PSYC 259 Homework 1 - Data Import
#For full credit, provide answers for at least 6/8 questions

#List names of students collaborating with (no more than 2): 

#GENERAL INFO 
#data_A contains 12 files of data. 
#Each file (6192_3.txt) notes the participant (6192) and block number (3)
#The header contains metadata about the session
#The remaining rows contain 4 columns, one for each of 20 trials:
#trial_number, speed_actual, speed_response, correct
#Speed actual was whether the figure on the screen was actually moving faster/slower
#Speed response was what the participant report
#Correct is whether their response matched the actual speed

### QUESTION 1 ------ 

# Load the readr package

# ANSWER

library(readr)

### QUESTION 2 ----- 

# Read in the data for 6191_1.txt using here()
# Hint 1: use getwd first to check working directory
# Hint 2: make sure you let R know about the data_A subfolder
# Hint 3: nest the readr and here() functions 
# Store it to an object called ds1
# Ignore the header information, and just import the 20 trials
# Be sure to look at the format of the file to determine what read_* function to use
# And what arguments might be needed

# A list of column names are provided to use:

col_names  <-  c("trial_num","speed_actual","speed_response","correct")

# ANSWER
library(here)
getwd()
ds1 <- read_tsv(here("data_A/6191_1.txt"), skip = 7, col_names = col_names)
### QUESTION 3a. ----- 

# For some reason, the trial numbers for this experiment should start at 100
# Create a new column in ds1 that takes trial_num and adds 100


# ANSWER
library(dplyr)
ds1 <- ds1 %>%
  mutate(trial_num_new = trial_num + 100)

### QUESTION 3b. ----- 
# Write the new data from question 3a to a CSV file in the "data_A_cleaned" folder
# Make sure to include code to create a "data_A_cleaned" folder if it doesn't already exist
# Choose a naming convention for this new dataset (ex. snake_case, no spaces, a date or version prefix/suffix)
# Add one commend explaining your naming choice

# ANSWER
dir.create("data_A_cleaned")
write_csv(ds1, "data_A_cleaned/6191_1_260510.txt" )
# I chose snake case because this is what I normally use and I think it is generally the most compatible across programming languages.
# I also used the data format of 260510 since 2026-05-10 uses "-" which could be subtraction in R

### QUESTION 4 ----- 

# Use list.files() to get a list of the full file names of everything in "data_A"
# Store it to a variable

# ANSWER
dataA_list <- list.files(here("data_A"), full.names = TRUE)

### QUESTION 5 ----- 

# Read all of the files in data_A into a single tibble called ds

# ANSWER
library(purrr)
ds <- map_dfr(dataA_list, read_tsv, skip = 7, col_names = col_names, col_types = cols(
                trial_num = col_integer(),
                speed_actual = col_character(),
                speed_response = col_character(),
                correct = col_logical()))

### QUESTION 6 -----

# Try creating the "add 100" to the trial number variable again
# There's an error! Take a look at 6191_5.txt to see why.
# Use the col_types argument to force trial number to be an integer "i"
# You might need to check ?read_tsv to see what options to use for the columns
# trial_num should be integer, speed_actual and speed_response should be character, and correct should be logical
# After fixing it, create the column to add 100 to the trial numbers 
# (It should work now, but you'll see a warning because of the erroneous data point)

# ANSWER
ds <- ds %>%
  mutate(trial_num_new = trial_num + 100)
# I had to fix the columns to use map_dfr to create the full df for this question, so that step is shown above in Question 5

### QUESTION 7 -----

# Now that the column type problem is fixed, take a look at ds()
# We're missing some important information (which participant/block each set of trials comes from)
# Read the help file for read_tsv to use the "id" argument to capture that information in the file
# Re-import the data so that filename becomes a column

# ANSWER
ds <- map_dfr(dataA_list, read_tsv, skip = 7, col_names = col_names, col_types = cols(
                trial_num = col_integer(),
                speed_actual = col_character(),
                speed_response = col_character(),
                correct = col_logical()),
              id = "file_name")

### QUESTION 8 -----

# Your PI emailed you an Excel file with the list of participant info 
# Install the readxl package, load it, and use it to read in the .xlsx data in data_B
# There are two sheets of data -- import each one into a new tibble

# ANSWER
library(readxl)
participant_info <- read_xlsx("data_B/participant_info.xlsx")

# I could only find one sheet of data!
