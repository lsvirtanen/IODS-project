# load in packages
library(dplyr) # install.packages("dplyr")
library(tidyr) # install.packages("tidyr")

# read in data sets
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)

# checking data set properties of BPRS
names(BPRS)
glimpse(BPRS)
str(BPRS)
summary(BPRS)

# checking data set properties of RATS
names(RATS)
glimpse(RATS)
str(RATS)
summary(RATS)

# making categorical variables factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# convert to long for and add a week variable for BPRS
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks)
BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks, 5, 5)))

# convert to long for and add a Time variable for RATS
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>%
  arrange(Time)

# checking data set properties of the long form BPRS
names(BPRSL)
glimpse(BPRSL)
str(BPRSL)
summary(BPRSL)

# checking data set properties of the long form RATS
names(RATSL)
glimpse(RATSL)
str(RATSL)
summary(RATSL)

# The essential difference between wide form and long form is that wide form has each subject as one observation with separate
# variables for different measurements; in contrast, long form presents each measurement as one observation, and subjects are
# individuated by a subject variable.

# save modified data sets
write.table(BPRSL, "BPRS.csv", col.names = TRUE, row.names = TRUE, sep = ",")
write.table(RATSL, "RATS.csv", col.names = TRUE, row.names = TRUE, sep = ",")