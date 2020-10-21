# 혼자서 해보기
# Q1. ggplpt2() 패키지의 mpg 데이터를 사용할 수 있도록 불어온 후 복사본을 만드시오.
library(ggplot2)

df_mpg <- as.data.frame(ggplot2::mpg) 
mpg_copy <- df_mpg

# Q2. 복사본 데이터를 이용해 cty는 city로, hwy는 highway로 수정하시오.
library(dplyr)

mpg_copy <- rename(mpg_copy, city = cty)
mpg_copy <- rename(mpg_copy, highway = hwy)

# Q3. 데이터 일부를 출력해 변수명이 바뀌었는지 확인해 보시오.
head(df_mpg)
head(mpg_copy)