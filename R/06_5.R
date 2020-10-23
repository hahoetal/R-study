# 혼자서 해보기

library(ggplot2)
library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)

# 문제1)
mpg %>%
  group_by(class) %>%
  summarise(mean = mean(cty))

#문제2)
mpg %>%
  group_by(class) %>% 
  summarise(mean = mean(cty)) %>% 
  arrange(desc(mean))

# 문제3)
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean = mean(hwy)) %>% 
  arrange(desc(mean)) %>% 
  head(3)

# 문제4)
mpg %>% 
  group_by(manufacturer) %>% 
  filter(class == "compact") %>%
  summarise(n = n()) %>%
  arrange(desc(n))