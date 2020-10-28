# 혼자서 해보기

library(ggplot2)
library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)

# 문제 1
mpg_suv <- mpg %>%
  filter(class=="suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>%
  arrange(desc(mean_cty))
  head(5)

ggplot(data=mpg_suv, aes(x=reorder(manufacturer, -mean_cty), y=mean_cty)) +
  geom_col()

# 문제2
ggplot(data=mpg, aes(x=class)) +
  geom_bar()