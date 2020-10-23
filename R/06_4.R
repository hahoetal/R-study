# 혼자서 해보기(p.144)

library(ggplot2)
library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)

# 문제1)
mpg <- mpg %>%
  mutate(total = cty + hwy)

# 문제2)
mpg <- mpg %>%
  mutate(mean = total/2)

# 문제3)
mpg %>% 
  arrange(desc(mean)) %>% 
  head(3)

# 문제4)
mpg %>% 
  mutate(total = cty + hwy,
         mean = total/2) %>% 
  arrange(desc(mean)) %>% 
  head(3)