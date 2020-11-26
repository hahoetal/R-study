# R 내장 함수로 데이터 추출하기

# 행 번호로 행 추출하기
exam <- read.csv("csv_exam.csv")

exam[] # 조건 없이 전체 데이터 출력 그냥 exam한 것이랑 똑같은 결과...
exam[1,] # 첫 번째 행 출력
exam[2,] # 두 번째 행 출력

# 조건을 충족하는 행 추출하기
exam[exam$class == 1,] # class가 1인 행만 출력
exam[exam$math >= 80, ] # 수학 점수가 80점 이상인 행만 출력

exam[exam$class == 1 & exam$math >= 50, ] # 1반 이면서 수학 점수가 50점 이상인 행만 출력
exam[exam$english < 90 | exam$science < 50, ] # 영어 점수가 90점 미만이거나 과학 점수가 50점 미만인 행만 출력

# 열 번호로 변수 추출하기
exam[, 1] # 첫 번째 열 추출
exam[, 2] # 두 번째 열 추출
exam[, c(1,2)]
# 변수를 하나만 추출하는 경우, 추출된 데이터는 데이터 프레임이 아닌 연속 값. dplyr 패키지의 select는 변수가 하나여도 데이터 프레임.

# 변수명으로 변수 추출하기
exam[, "class"] # class 변수 추출
exam[, "math"] # math 변수 추출
exam[, c("class", "math")]

# 행, 변수 동시에 추출하기
exam[1,3]
exam[5, "english"]
exam[exam$math >= 50, "english"]
exam[exam$math >= 50, c("english", "science")]

# dplyr 패키지와 내장 함수의 차이

# 문제) 수학점수 50이상, 영어 점수 80 이상인 학생들을 대상으로 각 반의 전 과목 총평균을 구하라.

# 내장 함수
exam$total <- (exam$math + exam$english + exam$science)/3
aggregate(data = exam[exam$math >= 50 & exam$english >= 80, ], total ~ class, mean) # 범주별 요약 통계량을 구하는 R 내장 함수.

# exam_f <- exam[exam$math >= 50 & exam$english >= 80, ]
# exam1 <- exam_f[exam_f$class == 1,]
# exam2 <- exam_f[exam_f$class == 2,]
# exam3 <- exam_f[exam_f$class == 3,]
# exam4 <- exam_f[exam_f$class == 4,]
# exam5 <- exam_f[exam_f$class == 5,]
# 
# mean(exam1$total)
# mean(exam2$total)
# mean(exam3$total)
# mean(exam4$total)
# mean(exam5$total)

# dplyr 코드
library(dplyr)

exam %>% 
  filter(math >= 50 & english >= 80) %>% 
  mutate(total = (math + english + science)/3) %>% 
  group_by(class) %>% 
  summarise(M = mean(total))

# 혼자서 해보기(p.324)
mpg <- as.data.frame(ggplot2::mpg)

mpg$total <- (mpg$cty + mpg$hwy)/2 # 통합 연비

mpg_suv <- mpg[mpg$class == "suv",] # suv만 
mpg_compact <- mpg[mpg$class == "compact",] # compact만

mean(mpg_suv$total) # suv의 연비 평균
mean(mpg_compact$total) # compact의 연비 평균