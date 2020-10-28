# 혼자서 해보기(p.188)

library(ggplot2)

# 문제1
mpg <- as.data.frame(ggplot2::mpg)

ggplot(data=mpg, aes(x=cty, y=hwy)) +
  geom_point()

# 문제2
midwest <- as.data.frame(ggplot2::midwest)

ggplot(data=midwest, aes(x=poptotal, y=popasian)) +
  geom_point() +
  xlim(0, 500000) +
  ylim(0, 10000)