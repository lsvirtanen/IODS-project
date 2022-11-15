# Script to prepare data for IODS Assignment 2 analyses

library(tidyverse) # for glimpse() install.packages("tidyverse")
library(finalfit) # for fF_glimpse() install.packages("finalfit")
library(dplyr) # install.packages("dplyr")

# read in the data set (questionnaire regarding teaching and learning from 2014)
# tab as separator
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# print data information, could have used dim() and str() for just dimensions
# and structure
glimpse(lrn14)
ff_glimpse(lrn14)

# The printouts include dimensions of the data set (183 rows, 60 columns -- or
# 183 observations for 60 variables). We get the data type of columns, number
# and percentage of missing values, levels for categorical variables, and summary
# statistics for numerical variables

# form combination variables by averaging subsets of questionnaire responses
# note: sum variable for attitude question already exists, dividing by number of
# of questions (10)
lrn14$attitude <- lrn14$Attitude / 10
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
lrn14$deep <- rowMeans(lrn14[, deep_questions])
surface_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

# select a subset of variables and rename age and points with lower case
learning2014 <- lrn14[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# exclude observations where points is zero
learning2014 <- filter(learning2014, points > 0)

# set working directory to parent directory
setwd(dirname(getwd()))

# save new data set
write_csv(learning2014, "./data/learning2014.csv")

# clear variables and check that reading works
rm(list = c("lrn14", "deep_questions", "surface_questions", "strategic_questions", "learning2014"))
learning2014 <- read_csv("./data/learning2014.csv")

# check data structure
str(learning2014)
head(learning2014)
