# 상관분석 - 두 연속변수의 관계성 분석
# 상관계수 - 0과 1 사이의 값을 가짐, 1에 가까울수록 관련성이 크다는 것을 의미, 양수면 정비례 음수면 반비례의 관계를 가짐을 의미, 두 연속변수의 관계의 방향과 크기를 파악할 수 있음.

# 실업자 수와 개인 소비 지출의 상관관계
economics <- as.data.frame(ggplot2::economics)
cor.test(economics$unemploy, economics$pce)

## Pearson's product-moment correlation

## data:  economics$unemploy and economics$pce
## t = 18.63, df = 572, p-value < 2.2e-16
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.5608868 0.6630124
## sample estimates:
##       cor 
## 0.6145176

# p-value가 .001보다 작으므로 통계적으로 유의.
# 상관계수가 0.61이므로 실업자 수가 증가하면 개인 소비 지출이 증가한다고 볼 수 있다.
# 효과 크기도 구해주어야 하는데 생략!


# 상관행렬_여러 변수의 관련성 한 번에 알아보기, R에 내장된 mtcars 데이터 이용.
head(mtcars)

car_cor <- cor(mtcars) # 상관행렬 생성
round(car_cor, 2) # 소수점 셋째 자리에서 반올림해 출력

## mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
## mpg   1.00 -0.85 -0.85 -0.78  0.68 -0.87  0.42  0.66  0.60  0.48 -0.55
## cyl  -0.85  1.00  0.90  0.83 -0.70  0.78 -0.59 -0.81 -0.52 -0.49  0.53
## disp -0.85  0.90  1.00  0.79 -0.71  0.89 -0.43 -0.71 -0.59 -0.56  0.39
## hp   -0.78  0.83  0.79  1.00 -0.45  0.66 -0.71 -0.72 -0.24 -0.13  0.75
## drat  0.68 -0.70 -0.71 -0.45  1.00 -0.71  0.09  0.44  0.71  0.70 -0.09
## wt   -0.87  0.78  0.89  0.66 -0.71  1.00 -0.17 -0.55 -0.69 -0.58  0.43
## qsec  0.42 -0.59 -0.43 -0.71  0.09 -0.17  1.00  0.74 -0.23 -0.21 -0.66
## vs    0.66 -0.81 -0.71 -0.72  0.44 -0.55  0.74  1.00  0.17  0.21 -0.57
## am    0.60 -0.52 -0.59 -0.24  0.71 -0.69 -0.23  0.17  1.00  0.79  0.06
## gear  0.48 -0.49 -0.56 -0.13  0.70 -0.58 -0.21  0.21  0.79  1.00  0.27
## carb -0.55  0.53  0.39  0.75 -0.09  0.43 -0.66 -0.57  0.06  0.27  1.00

# 숫자가 너무 많아서 알아보기 힘듦 => 히트맵을 만들자~

# 히트맵: 값의 크기를 색깔로 표현한 그래프

# 히트맵 만들기
install.packages("corrplot")

library(corrplot)

corrplot(car_cor)

# corrplot()의 파라미터를 이용해 그래프으이 형태 다양하게 바꾸기
corrplot(car_cor, method = "number")

col <- colorRampPalette(c("#bb4444", "#ee9988", "#ffffff", "#77aadd", "#4477aa")) # colorRampPalette()로 색상 코드 목록을 생성하는 col() 함수 생성

corrplot(car_cor,
         method = "color",        # 색깔로 표현
         col = col(200),          # 색상 200개 선정
         type = "lower",          # 왼쪽 아래 행렬만 표시
         order = "hclust",        # 유사한 상관계수끼리 군집화
         addCoef.col = "black",   # 상관계수 색깔
         tl.col = "black",        # 변수명 색깔
         tl.srt = 45,             # 변수명 45도 기울이기
         diag = F)                # 대각행렬 제외, 상관이 1인 것 제외.