# 데이터 분석 프로젝트_'한국인의 삶을 파악하라!'

# 필요한 패키지 가져오기
library(ggplot2)
library(dplyr)
library(foreign)

# 분석 데이터 가져오기
raw_welfare <- read.spss(file="C:/Users/yeong/OneDrive/바탕 화면/R_study/data/Koweps_hpc10_2015_beta1.sav", to.data.frame=T)

# 복사본 만들기
welfare <- raw_welfare

# 변수명 변경
welfare <- rename(welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)

# 연령대에 따른 월급 차이

# 나이 변수
welfare <- welfare %>%
  mutate(age = 2015 - birth + 1)

# 연령대 변수
welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30, "young",
                       ifelse(age <= 59, "middle", "old")))
table(welfare$ageg)

# 월급 변수 이상치 결측 처리
class(welfare$income)
summary(welfare$income)

welfare$income <- ifelse(welfare$income %in% c(0, 9999), NA, welfare$income)

table(is.na(welfare$income))

# 분석
ageg_welfare <- welfare %>%
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(income_mean = mean(income))

# 그래프 그리기
ggplot(data = ageg_welfare, aes(x = ageg, y = income_mean)) +
  geom_col() +
  scale_x_discrete(limits=c("young", "middle", "old")) # 막대 순서 정렬을 위해서!!

# 연령대 및 성별 월급 차이

# 성별 변수 전처리
class(welfare$sex)
table(welfare$sex)

welfare$sex <- ifelse(welfare$sex == 1, "male", "female")

# 분석
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))

# 그래프
ggplot(data=sex_income, aes(x = ageg, y = mean_income, fill = sex)) +
  geom_col(position = "dodge") +
  scale_x_discrete(limits=c("young", "middle", "old"))

# 나이 및 성별 월급 차이

sex_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex, age) %>% 
  summarise(mean_income = mean(income))

ggplot(data = sex_age, aes(x = age, y = mean_income, color=sex)) +
  geom_line()

# 직업별 월급 차이

# 직업 변수 전처리
class(welfare$code_job)
table(welfare$code_job)
table(is.na(welfare$code_job))

library(readxl)

list_job <- read_excel("C:/Users/yeong/OneDrive/바탕 화면/R_study/data/Koweps_Codebook.xlsx", col_names = T, sheet = 2)
head(list_job)

dim(list_job)

welfare <- left_join(welfare, list_job, id = "code_job")

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

# 분석
job_income <- welfare %>% 
  filter(!is.na(code_job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

head(job_income)

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10) # 상위 10개 직업만 추려서...

bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)

bottom10

# 그래프
ggplot(data = top10, aes(x = reorder(job, mean_income), y = mean_income)) + # 가나다 순이 아닌 월급 평균이 큰 순서로~ reorder()
  geom_col() +
  coord_flip() # x축의 값이 너무 길어 서로 겹치기 때문에 막대를 오른쪽으로 90도 회전! 

ggplot(data = bottom10, aes(x = reorder(job, -mean_income), y = mean_income)) +
  geom_col() +
  coord_flip() +
  ylim(0, 850) # 위 그래프와 같이 비교할 때, 똑같이 y축의 범위가 0 ~ 850인 것이 보기에 더 좋음.