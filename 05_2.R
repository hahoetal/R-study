# 분석 도전
# 문제 1)
library(ggplot2)

df_midwest <- as.data.frame(ggplot2::midwest)

head(df_midwest)
tail(df_midwest)
View(df_midwest)
dim(df_midwest)
str(df_midwest)
summary(df_midwest)

# 문제 2)
library(dplyr)

midwest_copy <- rename(df_midwest, total = poptotal, asian = popasian)

# 문제 3)
midwest_copy$ratio <- (midwest_copy$asian/midwest_copy$total)*100
hist(midwest_copy$ratio)

# 문제 4)
ratio_mean <- mean(midwest_copy$ratio)
midwest_copy$group <- ifelse(midwest_copy$ratio > ratio_mean, "large", "small")

# 문제 5)
table(midwest_copy$group)
qplot(midwest_copy$group)