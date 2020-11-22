# dygraphs 패키지로 인터랙티브 시계열 그래프 만들기

# 시계열: 일정 시간 간격으로 배치된 데이터들의 수열.
# 시계열 데이터: 순차적으로 관측한 값들의 집합...

# 패키지 설치 및 불러오기
library(ggplot2)

install.packages("dygraphs")
library(dygraphs)

# 사용할 데이터
economics <- ggplot2::economics
head(economics)

# economics 데이터를 시간 순서 속성을 가지는 xts 타입으로 변경.
library(xts)

eco <- xts(economics$unemploy, order.by = economics$date) # dygraphs 패키지의 dygraph() 함수를 사용하기 위해!!
head(eco)

# 인터랙티브 시계열 그래프 만들기
dygraph(eco)

# 날짜 범위 선택 기능 추가
dygraph(eco) %>% dyRangeSelector()

# 여러 값 표현하기
eco_a <- xts(economics$psavert, order.by = economics$date) # 저축률
eco_b <- xts(economics$unemploy/1000, order.by = economics$date) # 실업자 수

# cbind() 이용해서 데이터 결합
eco2 <- cbind(eco_a, eco_b) # 가로로 데이터 결합
colnames(eco2) <- c("psavert", "unemploy") # eco2는 xts 타입으로 데이터 프레임이 아니기 때문에 rename으로 변수 변경이 불가능.
head(eco2)

# 인터랙티브 시계열 그래프 그리기
dygraph(eco2) %>% dyRangeSelector()