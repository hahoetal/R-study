# 지도 색칠하기

install.packages('raster') # 전 세계 행정구역 데이터베이스인 GADM(Database of Global Administrative Areas)에서 자료를 불러오기 위해 설치
install.packages("rgdal") # shape file 읽어오는데 필요.
install.packages('maptools') # fortify() 함수 사용 시 필요.
install.packages('gpclib') # fortify() 함수 오류 때문에 설치

library(raster)
library(ggplot2)
library(rgdal)
library(maptools)

if(!require(gpclib))install.packages("gpclib", type = "source")
gpclibPermit() # fortify() 오류 시... 실행

# 한국 시군구 단위 지도 데이터
korea <- getData('GADM', country = 'kor', level = 2) # 0은 구분 없이, 1은 광역자치단체(시도), 2는 시군구  

# 지도(미농지) 그리기_1
ggplot() +
  geom_polygon(data = korea,
               aes(x = long,
                   y = lat,
                   group = group), # 무엇이랑 짝지어줄지..
               fill = 'white',
               color = 'black') # 옛날 지도!


# 지도 데이터 가져오기(shapefile 읽어오기)
korea <- shapefile('r data/시군구_202005/SIG.shp')

# 지도(미농지) 그리기_2
ggplot() +
  geom_polygon(data = korea,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = 'white',
               color = 'black')

# 지도에 표현할 데이터
result <- read.csv("r data/result.csv", header = T, as.is = T)

head(result)
class(result)

# 데이터 프레임을 합친 후 서울지도가 이상해서 id(지역 코드)를 살펴보니 현재 존재하지 않는 법정동 코드가 있었음.
# result 데이터에 현재 존재하지 않는 법정동 코드, 28170를 28177로 변경하기.
class(result$id)

result$id <- ifelse(result$id == 28170, 28177, result$id)
table(result$id)

# korea 변수 데이터프레임으로 변환하기
korea <- fortify(korea, region = 'SIG_CD')
head(korea)

# 데이터 합치기
korea <- merge(korea, result, by = 'id')

# 지도 색칠하기_1
p <- ggplot() +
  geom_polygon(data = korea, 
               aes(x = long,
                   y = lat, 
                   group = group, # 지도 그릴 때 어디어디를 서로 연결할지...
                   fill = moon)) # 문 대통령 지지율

# 색 변경_1
p +
  scale_fill_gradient(low = "#ffffff", high = '#004ea2')

# 색 변경_2
install.packages('viridis') # 전문가가 미리 만들어둔 색상 패키지
library(viridis)

p +
  scale_fill_viridis()

# 색 변경_3
p +
  scale_fill_viridis(direction = -1) + # 색깔 반대로
  theme_void() + # 배경으로 보이는 회색 격자 제거
  guides(fill = F) # 범례 제거

# 지도 색칠하기_2
ggplot() +
  geom_polygon(data = korea,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = final)) + # 문 대통령과 홍 후보의 차이 지역별 비교
  scale_fill_viridis(direction = -1) +
  theme_void()


# 서울
seoul <- korea[korea$id <= 11740, ] # 지역 코드 11740 이하는 서울!

# 서울 지도 그리기_1
ggplot() +
  geom_polygon(data = seoul,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = 'white',
               color = 'black')

# 서울 지도 그리기_2
korea_gadm <- getData('GADM', country ='kor', level = 2)
seoul_gadm <- korea_gadm[korea_gadm$NAME_1 %in% 'Seoul',]

ggplot() +
  geom_polygon(data = seoul_gadm,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = 'white',
               color = 'black')

table(result$id)

# 서울 지도만 색칠하기 + 인터랙티브 지도.
install.packages("plotly")
library(plotly)

s <- ggplot() +
  geom_polygon(data = seoul,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = moon,
                   text = paste("지역: ", Sigun))) +
  scale_fill_viridis(direction = -1) +
  theme_void()

ggplotly(s)
