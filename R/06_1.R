# 혼자서 해보기(p.133)

# 문제1)
library(ggplot2)

mpg <- as.data.frame(ggplot2::mpg)

mpg_displ_under_4 <- mpg %>% filter(displ <= 4)
mpg_displ_up_5 <- mpg %>% filter(displ > 5)

mpg_displ_under_4_m <- mean(mpg_displ_under_4$hwy) 
mpg_displ_up_5_m <- mean(mpg_displ_up_5$hwy)

# mpg_displ_under_4_m : 25.96319
# mpg_displ_up_5_m : 18.13889
# displ이 4 이하인 자동자의 hwy(고속도로)연비가 displ이 5 이상인 자동차보다 더 크다.

# 문제2)
audi <- mpg %>% filter(manufacturer == "audi")
toyota <- mpg %>% filter(manufacturer == "toyota")

audi_cty_m <- mean(audi$cty)
toyota_cty_m <- mean(toyota$cty)

# audi_cty_m : 17.61111
# toyota_cty_m : 18.52941
# toyota에서 만든 자동차의 cty(도시연비)가 audi에서 만든 자동차 cty보다 크다.

# 문제3)
CFH <- mpg %>% filter(manufacturer %in% c("chevrolet", "ford", "honda"))

CFH_m <- mean(CFH$hwy)
