# Lari Virtanen, 2022-11-29, “Human development” and “Gender inequality” data sets preparation script

# include packages for later use
library(tidyverse) # install.packages("tidyverse")

# reading in the data files
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# exploration of variables, hd
dim(hd)
str(hd)
summary(hd)

# exploration of variables, gii
dim(gii)
str(gii)
summary(gii)

# renaming variables, hd
names(hd) <- c("HDIRank", "Country", "HDI", "LifeExp", "EduExp", "MeanEdu", "GNI", "GNI-HDIRank")

# renaming variables, gii
names(gii) <- c("GIIRank", "Country", "GII", "MatMor", "AdoBirth", "ParliF", "Edu2F", "Edu2M", "LaboF", "LaboM")

# create variables for secondary education and labor force participation ratios by gender
gii <- mutate(gii, Edu2FM = Edu2F / Edu2M)
gii <- mutate(gii, LaboFM = LaboF / LaboM)

# join the two data sets by Country
human <- inner_join(hd, gii, by = "Country")

# save new data set
write_csv(human, "human.csv")

# ------------------------------------------------------------------------------
# NOTE: continuing with Assignment 5 from this point on
# loading data
human <- read_csv("human.csv")

# checking dimensions and structure
dim(human)
str(human)

# This data is combined from Human Development Index and Gender Inequality Index data sets,
# see https://hdr.undp.org/data-center/human-development-index#/indicies/HDI and
# https://hdr.undp.org/system/files/documents//technical-notes-calculating-human-development-indices.pdf for details.
# Data from 195 countries are included, with original variables for Human Development Index (HDI), rank by HDI,
# life expectancy at birth, expected years of education, mean years of education, Gross National Income per capita (GNI),
# GNI rank minus HDI rank, Gender Inequality Index (GII), rank by GII, maternal mortality ratio, adolescent birth rate,
# percent of female representation in parliament, population with secondary education separately for females and males,
# and labour force participation rate separately for females and males.
# In addition to the original variables, gender ratios for secondary eduation and labour force participation
# were calculated by dividing the female variable with the male counterpart.

# Next the assignment instructs to mutate the GNI variable to numeric.
# However, unlike the data used in Exercise set 5, the data used here already
# has GNI without commas and as a numeric variable.
# For completeness, this is how it would be implemented:
# human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()

# keep only a subset of variables
keep <- c("Country", "Edu2FM", "LaboFM", "EduExp", "LifeExp", "GNI", "MatMor", "AdoBirth", "ParliF")
human <- select(human, one_of(keep))

# filter out all rows with NA values
human <- filter(human, complete.cases(human))

# some of the last observations are combined areas instead of countries as seen here
tail(human, 10)

# we will exclude observations which are not countries
human <- human[1:(nrow(human)-7), ]

# add countries as rownames, need to set as a data frame for tibbles do not seem to support rownames
human <- as.data.frame(human)
rownames(human) <- human$Country

# remove the Country variable
human <- select(human, -Country)

# save modified data set
write_csv(human, "human.csv")
