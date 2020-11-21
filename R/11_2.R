# 대한민국 시도별 인구 수 단계 구분도 만들기

# 패키지 준비
library(mapproj)
library(ggiraphExtra)
library(ggplot2)

# 대한민국 시도별 인구 데이터를 가져오기 위한 패키지 준비
install.packages("stringi")
install.packages("devtools") # CRAN에 등록되지 않고 공유되는 패키지를 다운받기 위해 설치

devtools::install_github("cardiomoon/kormaps2014")

library(kormaps2014)

# 대한민국 시도별 인구 데이터 준비
# 시도별 인구통계 정보가 담겨있는 korpop1 데이터를 사용.
str(changeCode(korpop1)) # 한글이 깨져보이므로 인코딩 방식을 변환하도록 changeCode()를 사용. 

# 변수명이 한글이면 오류가 발생할 수 있으니 영문자로 변경
library(dplyr)

korpop1 <- rename(korpop1, pop = 총인구_명, name = 행정구역별_읍면동)
korpop1$name <- iconv(korpop1$name, "UTF-8", "CP949")

# 대한민국 시도 지도 데이터 준비
str(changeCode(kormap1))

# 단계 구분도 만들기

ggChoropleth(data = korpop1,
             aes(fill = pop,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)
