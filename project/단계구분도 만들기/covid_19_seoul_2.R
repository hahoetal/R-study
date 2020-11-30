# 서울시 코로나 확진자 수 단계 구분도_ggplot2 이용해서 그리기

library(raster)
library(rgdal)
library(maptools)
library(ggplot2)
library(dplyr)

# fortify() 오류나는 경우 아래 코드 실행
if(!require(gpclib))install.packages("gpclib", type = "source")
gpclibPermit()


# 지도 정보 가져오기
korea <- shapefile("r data/시군구_202005/SIG.shp") # raster 패키지 안에 있음.
head(korea)

# 지도가 제대로 그려지는지 확인
ggplot() +
  geom_polygon(data = korea,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = 'white',
               color = 'black')

# 지도 정보 데이터프레임으로 변환
df_korea <- fortify(korea, region = 'SIG_CD') # ggplot2 패키지 안에 있음, 꼭 fortify()를 이용해 데이터프레임으로 만들어주기!
head(df_korea)

# 서울시 지도 정보만 가져오기
seoul <- df_korea %>% 
  filter(id <= 11740)

# 서울 시 구별 코로나 확진자 데이터 가져오기
data <- read.csv("서울시 코로나19 확진자 현황.csv")
head(data)

# 확진자 거주 지역 정보만 가져오기
covid_19_region <- data %>%
  select('지역')

table(covid_19_region$지역)

# 구 이름이 이상한게 있어서 변경.
covid_19_region$지역 <- ifelse(covid_19_region$지역 == '종랑구', '중랑구', covid_19_region$지역)
table(covid_19_region$지역)

# 지역 별 빈도표 만들고 데이터프레임으로 변환
t <- table(covid_19_region)
t

covid_19_region <- as.data.frame(t, stringsAsFactors = FALSE) # 지역 이름을 factor형이 아닌 character형으로 가져오기..
covid_19_region

# 변수명 변경
covid_19_region <- covid_19_region %>% 
  rename(region = covid_19_region, n = Freq)

# 지역이 서울시 내에 존재하는 구가 아닌 경우 제외
covid_19_region <- covid_19_region %>% 
  filter(!(region == '기타' | region == '경기도' | region == '타시도'))

# 지도에 색칠하기에 앞서 seoul 데이터 프레임과 covid_19_region 데이터 프레임을 합치려고 하는데 기준 변수가 없음. 

# korea에서 법정동 코드(seoul의 id)와 지역명을 데이터 프레임으로 가져오기
code_region <- as.data.frame(korea)
head(code_region)

code_region <- code_region %>%
  filter(SIG_CD <= 11740) %>%
  rename(id = SIG_CD, region = SIG_KOR_NM) %>% 
  select(id, region)
head(code_region)

# 데이터 프레임 합치기
seoul <- left_join(seoul, code_region, by = 'id') # 서울 지도 데이터에 지역명 추가
head(seoul)

seoul <- left_join(seoul, covid_19_region, by = 'region') # 지역별 코로나 확진자 수 추가
head(seoul)

# 지도에 색칠하기!
library(viridis)
library(plotly)

map <- ggplot() +
  geom_polygon(data = seoul,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = n,
                   text = paste("지역: ", region))) +
  scale_fill_viridis() +
  theme_void()

ggplotly(map)
