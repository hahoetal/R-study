# 대한민국 시도별 결핵 환자 수 단계 구분도 만들기

# 패키지 준비
library(mapproj)
library(ggiraphExtra)
library(kormaps2014)

# 지역별 결핵 환자 수에 대한 정보는 tbc이고 NewPts는 결핵 환자 수 
str(changeCode(tbc))

tbc$name <- iconv(tbc$name, "UTF-8", "CP949")

ggChoropleth(data = tbc, # 지도에 표현할 데이터
             aes(fill = NewPts, # 색으로 표현할 변수
                 map_id = code, # 지역 기준 변수
                 tooltip = name), # 지도 위에 표시할 지역 이름
             map = kormap1, # 지도 데이터(위도랑 경도..)
             interactive = T) # 인터랙티브브