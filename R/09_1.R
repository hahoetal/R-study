# 데이터 분석 프로젝트_'한국인의 삶을 파악하라!'

install.packages("foreign")

library(foreign) # spss, sas 등과 같은 특정 통계 소프트웨어를 위한 파일을 R에서 열고 불러오기 위해 필요.
library(dplyr) # 데이터 전처리
library(ggplot2) # 그래프 그리기

# 데이터 가져오기
raw_welfare <- read.spss(file="Koweps_hpc10_2015_beta1.sav", to.data.frame=T) # 'to.data.frame=T'이 없으면, 데이터를 리스트로 가져옴

# 복사본 생성
welfare <- raw_welfare

# 데이터 검토하기
head(welfare)
tail(welfare)
View(welfare)
dim(welfare)
str(welfare)
summary(welfare)

# 변수명 변경
welfare <- rename(welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)

# 성별에 따른 월급 차이

# 1) 성별 변수 검토 및 전처리
class(welfare$sex)
table(welfare$sex) # 결측치나 이상치가 발견되지 않았음.

welfare$sex <- ifelse(welfare$sex == 1, "male", "female")
table(welfare$sex)
qplot(welfare$sex)

# 2) 월급 변수 검토 및 전처리
class(welfare$income)
summary(welfare$income)
qplot(welfare$income) + xlim(0, 1000)

welfare$income <- ifelse(welfare$income %in% c(0, 9999), NA, welfare$income) # 월급 범위는 1 ~ 9998이기 때문에 이상치 처리
table(is.na(welfare$income))

# 3) 분석
sex_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(sex) %>% 
  summarise(mean_income = mean(income))

sex_income

ggplot(data = sex_income, aes(x = sex, y = mean_income)) +
  geom_col() # 요약표를 이용해 막대그래프를 그리므로 geom_col()을 사용.


# 나이와 월급의 관계

# 1) 나이 변수 검토 및 전처리
class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)

summary(welfare$birth) # 나이의 범위는 1900 ~ 2014
table(is.na(welfare$birth)) # 이상치와 결측치는 없음.

# 2) 파생변수 만들기_나이
welfare <- welfare %>% 
  mutate(age = 2015 - birth + 1) # welfare$age <- 2015 - welfare$birth + 1

summary(welfare$age)
qplot(welfare$age)

# 3) 분석
age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))

head(age_income)

ggplot(data = age_income, aes(x = age, y = mean_income)) +
  geom_line()