# 서울시 코로나 확진자 수 단계 구분도.
# 공공데이터포털의 '서울시 코로나19 확진자 현황' 데이터 사용, 11월 26일까지, 지역이 타시도로 구분된 경우 제외

# 사용할 패키지 불러오기
library(mapproj)
library(ggiraphExtra)
library(stringi)
library(kormaps2014)
library(dplyr)
library(ggplot2)

# 서울시 구별 코드 가져오기
str(changeCode(korpop2))

region_code <- korpop2 %>% 
  rename(region = 행정구역별_읍면동) %>% 
  select(region, code) %>% 
  head(25) %>% # 서울시 구 개수는 25개
  arrange(region)

region_code$region <- iconv(region_code$region, "UTF-8", "CP949") # 인코딩을 바꾸지 않으면 한글이 깨짐.

region_code
class(region_code)

# 코로나 확진자 데이터 가져오기
data <- read.csv('covid_19.csv')
head(data)

# 코로나 확진자 지역 정보만 가져오기
covid_19 <- data %>%
  rename(region = 지역) %>% 
  select(region) %>% 
  filter(!(region %in% c("타시도", "기타")))

# 빈도표
covid_19 <- table(covid_19)

# 데이터 프레임으로 변환
covid_19 <- as.data.frame(covid_19)

# 변수명 변경
covid_19 <- covid_19 %>% 
  rename(region = covid_19, freq = Freq)

class(covid_19$region)
covid_19$region <- as.character(covid_19$region)

covid_19
# 코로나 확진자 지역 정보와 서울시 구별 지역 코드 합치기
# final <- left_join(covid_19, region_code, by = "region") # 코드가 먹히지 않음, 자꾸 code 아니면 freq가 NA가 된다

# 알고 보니 region_code에 있는 region에는 공백이 있었다
# str(region_code$region)
# str(covid_19$region)

final <- mutate(covid_19, code = ifelse(covid_19$region == region_code$region, NA, region_code$code))

# 단계구분도
ggChoropleth(data = final,
             aes(fill = freq,
                 map_id = code,
                 tooltip = region),
             map = kormap2,
             interactive = T) # 아주 귀여운 지도가 그려진다...