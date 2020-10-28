# 혼자서 해보기(p.198)

library(ggplot2)

mpg <- as.data.frame(ggplot2::mpg)

mpg_class <- mpg %>% 
  filter(class %in% c("compact", "subcompact", "suv")) 
  
  
ggplot(data = mpg_class, aes(x=class, y=cty)) +
  geom_boxplot()