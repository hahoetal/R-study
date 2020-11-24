# 통계 분석 기법을 이용한 가설 검증

# t검정 - 두 집단의 평균 비교.

# compact 자동차과 suv 자동차의 도시 연비 t검증증
mpg <- as.data.frame(ggplot2::mpg)
str(mpg)

library(dplyr)

mpg_diff <- mpg %>% 
  select(class, cty) %>%
  filter(class %in% c("compact", "suv"))

head(mpg_diff)
table(mpg_diff$class)

t.test(data = mpg_diff, cty ~ class, var.equal = T) # 분산이 동일함을 가정.

## Two Sample t-test

## data:  cty by class
## t = 11.917, df = 107, p-value < 2.2e-16
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  5.525180 7.730139
## sample estimates:
##  mean in group compact     mean in group suv 
##               20.12766              13.50000 

# p-value가 .05보다 작으므로 통계적으로 유의
# compact의 평균이 suv보다 크므로 compact의 도시연비가 suv보다 더 높다고 할 수 있음.

# mpg_diff %>% 
#   group_by(class) %>% 
#   summarise(sd = sd(cty), var = var(cty)) # t 검증은 두 집단의 분산이 동일한지에 따라 분석법이 달라지니 분산과 표준편차를 구함.

## class      sd   var
##  <chr>   <dbl> <dbl>
## compact  3.39   11.5 
##  suv     2.42   5.86

# t.test(data = mpg_diff, cty ~ class, var.equal = F) # 분산이 동일하지 않음...

## Welch Two Sample t-test

## data:  cty by class
## t = 11.393, df = 79.558, p-value < 2.2e-16
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##   5.469914 7.785405
## sample estimates:
##   mean in group compact     mean in group suv 
##                20.12766              13.50000 

# t값이 11.393이고 유의확률이 .001보다 작으므로 영가설을 기각하고 연구가설을 채택한다.
# 즉, suv(M = 20.13, SD = 2.42)보다 compact(M = 13.50, SD = 3.39)의 도시 연비가 더 높다고 말할 수 있다(t(79.558) = 11.92, p < .001).


# 일반 휘발유와 고급 휘발유의 도시 연비 t검정
mpg_diff2 <- mpg %>% 
  select(fl, cty) %>%
  filter(fl %in% c("r", "p"))

table(mpg_diff2$fl)

t.test(data = mpg_diff2, cty ~ fl, var.equal = T) # 분산이 동일함을 가정.

## Two Sample t-test

## data:  cty by fl
## t = 1.0662, df = 218, p-value = 0.2875
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.5322946  1.7868733
## sample estimates:
## mean in group p mean in group r 
##        17.36538        16.73810 

# p-value가 0.2875로 유의 수준 .05보다 크므로 통계적으로 유의하지 않음, 우연히 이런 차이가 관찰될 확률이 28.75임을 의미.


# mpg_diff2 %>% 
#   group_by(fl) %>% 
#   summarise(var = var(cty), sd = sd(cty)) # 분산이 다르다...

## fl      var    sd
## <chr> <dbl> <dbl>
## p      9.26   3.04
## r      15.1   3.89

# t.test(data = mpg_diff2, cty ~ fl, var.equal = F)

## Welch Two Sample t-test

## data:  cty by fl
## t = 1.2118, df = 107.23, p-value = 0.2283
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.3989031  1.6534818
## sample estimates:
##  mean in group p mean in group r 
##         17.36538        16.73810 

# t값이 1.2118이고 유의확률이 0.2283으로 유의수준 .05보다 크므로 귀무가설을 채택한다(t(107.33) = 1.2118, p = 0.2283).