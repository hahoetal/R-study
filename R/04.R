# Q1. data.frame()과 c()를 조합해 표의 내용을 데이터 프레임으로 만들어 출력해 보시오.
df_fruit <- data.frame("제품" = c('사과', '딸기', '수박'),
                      "가격" = c(1800, 1500, 3000),
                      "판매량" = c(24, 38, 13))
df_fruit

# Q2. 앞에서 만든 데이터 프레임을 이용해 과일 가격 평균, 판매량 평균을 구해 보세요.
price_m <- mean(df_fruit$가격)
count_m <- mean(df_fruit$판매량)