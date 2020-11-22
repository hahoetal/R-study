# 인터랙티브 그래프(Interactive Graph): 마우스 움직임에 반응하며 실시간으로 형태가 변하는 그래프.

# plotly 패키지 사용해서 인터랙티브 그래프 만들기

# 패키지 설치 및 불러오기
install.packages("plotly")
library(plotly)

# 그래프 그리기
library(ggplot2)
p1 <- ggplot(data = mpg, aes(x = displ, y = hwy, col = drv)) +
  geom_point()

# 인터랙티브 그래프 그리기(산점도)
ggplotly(p1)

# 마우스를 드래그하면 특정 영역을 확대해서 볼 수 있고, 더블 클릭하면 원래대로 되돌아옴.
# Viewer 창에 그래프가 나타남. Expert -> Save as Web Page... 순으로 클릭하면 HTML 포맷으로 저장 됨.

# 인터랙티브 막대 그래프 그리기
p2 <- ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

ggplotly(p2)