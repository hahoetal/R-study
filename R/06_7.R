# 분석 도전

library(ggplot2)
library(dplyr)

midwest <- as.data.frame(ggplot2::midwest)
head(midwest)

# 문제1)
midwest <- midwest %>%
  mutate(ratio_child = (poptotal - popadults)/poptotal*100)

# 문제2)
midwest %>%
  arrange(desc(ratio_child)) %>% 
  select(county, ratio_child) %>% 
  head(5)

# 문제3)
midwest <- midwest %>% 
  mutate(grade = ifelse(ratio_child >= 40, "large", 
                        ifelse(ratio_child >= 30, "middle", "small")))

table(midwest$grade) # 빈도표...

# 문제4)
midwest %>% 
  mutate(ratio_A = (popasian/poptotal)*100) %>% 
  arrange(ratio_A) %>%
  select(state, county, ratio_A) %>%
  tail(10)