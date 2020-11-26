# 변수 타입

# 연속 변수(Continuous Variable): 연속적이고 크기를 의미하는 값으로 구성된 변수.
# 산술 연산이 가능하고 양적 변수(Quantitative Variable)이라고도 함. R에서는 numeric으로 표현.

# 범주 변수(Categorical Variable): 값이 대상을 분류하는 의미를 지니는 변수.
# 숫자가 크기를 의미하지 않기 때문에 산술연산이 불가능. 숫자가 대상을 지칭하는 이름과 같은 역할을 하기 때문에 '명목 변수(Nominal Variable)'이라고도 함. R에서는 factor로 표현.

# 변수 타입 간 차이
var1 <- c(1,2,3,1,2)
var2 <- factor(c(1,2,3,1,2))

var1
## [1] 1 2 3 1 2

var2
## [1] 1 2 3 1 2
## Levels: 1 2 3
# factor 변수는 값을 지니는 동시에 값의 범주를 의미하는 Levels 정보를 가지고 있음.

var1 + 2
## [1] 3 4 5 3 4

var2 + 2
# 연산이 되지 않는다.

class(var1) # 변수의 타입 확인
## [1] "numeric"

class(var2)
## [1] "factor"

levels(var1)
## NULL

levels(var2) # factor 변수의 구성 범주 확인하기
## "1" "2" "3"

var3 <- c("a", "b", "b", "c")
var4 <- factor(c("a", "b", "b", "c"))

var3
## [1] "a" "b" "b" "c"

var4
## [1] a b b c
## Levels: a b c

class(var3)
## [1] "character"

class(var4)
## "factor"

mean(var1)
## [1] 1.8

mean(var2)
## [1] NA
## 경고메시지(들): 
##  In mean.default(var2) :
##  인자가 수치형 또는 논리형이 아니므로 NA를 반환합니다
# 함수마다 적용 가능한 변수 타입이 다르다!!

# 변수의 타입 변경
var2 <- as.numeric(var2)
mean(var2)
## [1] 1.8

class(var2)
## [1] "numeric"

levels(var2)
## NULL

# as.으로 시작하는 함수들을 변수의 타입을 변경.
# as.numeric()
# as.factor()
# as.character()
# as.Date()
# as.data.frame()

# 다양한 변수 타입들
# numeric - 실수 ex) 1, 1.5
# integer - 정수 ex) 1L, 23L
# complex - 복소수 ex) 3 + 2i
# character - 문자
# logical - 논리 ex) TRUE, FALSE, T, F
# factoe - 범주 ex) 1, 2, a, b 
# Date - 날짜 ex) "2020-11-26", " 20/11/26"

# 혼자서 해보기(p.331)
mpg <- as.data.frame(ggplot2::mpg)

class(mpg$drv)
## [1] "character"

mpg$drv <- as.factor(mpg$drv)
class(mpg$drv)
## [1] "factor"

levels(mpg$drv)
## [1] "4" "f" "r"