# 혼자서 해보기(p.178)

library(ggplot2)

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10, 14, 58, 93), "drv"] <- "k"
mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42)

# 문제1
table(mpg$drv)

##   4   f   k   r 
## 100 106   4  24

mpg$drv <- ifelse(mpg$drv %in% c('4', 'f', 'r'), mpg$drv, NA)
table(mpg$drv)

##   4   f   k 
## 100 106   4

# 문제2
boxplot(mpg$cty)$stats

## [,1]
## [1,]    9
## [2,]   14
## [3,]   17
## [4,]   19
## [5,]   26

mpg$cty <- ifelse((mpg$cty < 9 | mpg$cty > 26), NA, mpg$cty)

boxplot(mpg$cty)

# 문제3
mpg %>% 
  filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_cty = mean(cty))

## # A tibble: 3 x 2
## drv   mean_cty
## <chr>      <dbl>
## 1 4         14.2
## 2 f         19.5
## 3 r         14.0