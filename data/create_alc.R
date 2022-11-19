# Lari Virtanen, 2022-11-19, Student Performance Data Set preparation script

# The Student Performance Data Set involves measures of secondary school student
# performance in mathematics and Portuguese language, with a variety of
# background variables collected by using school reports and questionnaires.

# The data set is available at:
# https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Reference to source article: P. Cortez and A. Silva. Using Data Mining to
# Predict Secondary School Student Performance. In A. Brito and J. Teixeira
# Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008)
# pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.

# access packages for later use
library(dplyr) # install.packages("dplyr")
library(readr) # install.packages("readr")

# read the tables
perf_math = read.table("student-mat.csv", sep=";", header=TRUE)
perf_por = read.table("student-por.csv", sep=";", header=TRUE)

# check dimensions and structure of data
dim(perf_math)
str(perf_math)
dim(perf_por)
str(perf_por)

# give the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(perf_por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(perf_math, perf_por, by = join_cols, suffix = c(".math", ".por"))

# check dimensions and structure of the joined data set
dim(math_por)
str(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# getting rid of duplicate records with the logic introduced in Exercise3:
# for numeric variables, take the rounded mean of the two versions
# for categorical variables (paid), use the one in the math version
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# checking combined and modified data
glimpse(alc)

# save data as csv to current folder (which should be data/)
write_csv(alc, "alc.csv")
