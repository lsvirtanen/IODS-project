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
