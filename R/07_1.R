# 혼자서 해보기(p.170)

library(ggplot2)

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA


# 문제1
table(is.na(mpg$drv))

## FALSE 
## 234

table(is.na(mpg$hwy))

## FALSE  TRUE 
## 229     5 

# 문제2
library(dplyr)

mpg %>% 
  filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))