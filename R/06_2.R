# 혼자서 해보기

library(ggplot2)

mpg <- as.data.frame(ggplot2::mpg)

# 문제1)
new_mpg <- mpg %>% 
  select(class, cty)

head(new_mpg)

# 문제2)
suv_cty <- new_mpg %>%
  filter(class == "suv")

mean(suv_cty$cty)

compact_cty <- new_mpg %>% 
  filter(class == "compact")

mean(compact_cty$cty)