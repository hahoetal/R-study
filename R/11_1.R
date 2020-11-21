# 지도 시각화
# 단계 구분도(Choropleth Map): 지역별 통계치를 색깔의 차이로 표현한 지도.

# 미국 주별 강력 범죄율 단계 구분도 만들기

# 필요한 패키지 설치 및 가져오기.
install.packages("mapproj") # 위도와 경도 데이터를 사용하는데 필요...
install.packages("ggiraphExtra") # 단계 구분도를 만들 때 사용하는 패키지

library(ggiraphExtra)

# 미국 주별 범죄 데이터
str(USArrests)
head(USArrests) # 지역명 변수가 따로 없고, 행 이름으로써 존재

# 지역명 변수 만들기
library(tibble) # dplyr 패키지를 설치할 때 자동으로 같이 설치됨.

crime <-rownames_to_column(USArrests, var = "state") # 행 이름을 state라는 변수의 값으로 바꾸기.
crime$state <- tolower(crime$state) # 지역 이름에 있는 대문자를 소문자로 변경.
str(crime)

# 미국 지도 데이터 가져오기.
install.packages("maps") # 위도나 경도 같은 미국 지도 데이터가 담겨있음.

library(ggplot2) # map_data() 함수를 쓰기 위해서!

states_map <- map_data("state") # 데이터 프레임 형태로 미국 주별 위도, 경도 정보 가져오기
str(states_map)

# 단계 구분도 만들기
ggChoropleth(data = crime, # 지도에 표현할 데이터
             aes(fill = Murder, # 색으로 표현할 변수
                 map_id = state), # 지역 기준 변수
             map = states_map) # 지도 데이터, 위도나 경도 같은...

# 인터랙티브 단계 구분도 만들기
ggChoropleth(data = crime,
             aes(fill = Murder,
                 map_id = state),
             map = states_map,
             interactive = T) # 마우스 움직임에 반응하는 단계 구분도 생성.
