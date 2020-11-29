# R로 지도 위에 데이터 표시하기

library(ggmap) # ggmap을 불러오면 ggplot2를 자동으로 가지고 오고 구글지도에서 데이터를 가져오는 방식으로 작동

# 구글 지도 API에 접근하기 위한 인증키(key) 준비
register_google(key = '구글 지도 API 인증')

# 기본 지도
ggmap(
  get_map(location = "south korea", zoom = 7, source = 'google', maptype = 'terrain') # 지도 정보를 가져와 그리기, zoom은 배율을 의미
  ) # ggplot 기능을 활용해 지도 그리기

# 공공와이파이(wifi)

# 흑백 도로 지도
map = get_map(location = 'south korea', zoom = 7, maptype = 'roadmap', color = 'bw')

# wifi 데이터
wifi <- read.csv('wifi.csv', header = T, as.is = T) # 첫 줄에 있는 변수명 가져오고 현재 형태 그대로 가지고 오기

head(wifi)

# 점을 찍자
ggmap(map) +
  geom_point(data = wifi,
             aes(x = lon, y = lat, color = company))

# 밀도
ggmap(map) +
  stat_density_2d(data = wifi,
                  aes(x = lon, y = lat))

p <- ggmap(map) +
  stat_density_2d(data = wifi,
                  aes(x = lon, y = lat,
                      fill = ..level..,
                      alpha = ..level..), # 투명도
                  geom = 'polygon',
                  size = 2, # 선 굵기
                  bins = 30) # 선 간격

p +
  scale_fill_gradient(low = 'yellow', high = 'red', guide = F) + # 색 지정, 범례는 표시하지 않음.
  scale_alpha(range(0.02, 0.8), guide = F) # 투명도 범위 

# 국내 공항 및 국내선 비행노선

# 데이터 가져오기
airport <- read.csv('airport.csv', header = T, as.is = T)
route <- read.csv('route.csv', header = T, as.is = T)

head(airport)
head(route)

# 공항 위치 표시
a <- ggmap(map) +
  geom_point(data = airport,
             aes(x = lon, y = lat))

# 위도 및 경도 값 찾기
# geocode(c('incheon airport', 'gimpo airport'))

# 국내선 비행 노선 그리기
a +
  geom_line(data = route, aes(x = lon, y = lat, group = id))
