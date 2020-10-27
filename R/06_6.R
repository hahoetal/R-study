# 혼자서 해보기

library(ggplot2)
library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)
fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22),
                   stringsAsFactors = F)
fuel

# 문제1)
mpg <- left_join(mpg, fuel, by="fl")

# 문제2)
mpg %>%
  select(model, fl, price_fl) %>% 
  head(5)