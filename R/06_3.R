# 혼자서 해보기(p.141)

library(ggplot2)
library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)

mpg %>% 
  filter(manufacturer == "audi") %>% 
  arrange(desc(hwy))