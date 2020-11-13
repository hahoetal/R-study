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

# 나이 변수 전처리
welfare <- welfare %>%
  mutate(age = 2015 - birth + 1)

# 연령대 변수 전처리
welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30, "young",
                       ifelse(age <= 59, "middle", "old")))

# 월급 변수 전처리
welfare$income <- ifelse(welfare$income %in% c(0, 9999), NA, welfare$income)

# 성별 변수 전처리
welfare$sex <- ifelse(welfare$sex == 1, "male", "female")

# 직업 변수 전처리
library(readxl)

list_job <- read_excel("C:/Users/yeong/OneDrive/바탕 화면/R_study/data/Koweps_Codebook.xlsx", col_names = T, sheet = 2)
welfare <- left_join(welfare, list_job, id = "code_job")

# 성별 직업 빈도

# 분석_남성 직업 빈도 상위 10개
job_male <- welfare %>% 
  filter(sex == 'male' & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(n = n()) %>%
  arrange(desc(n)) %>% 
  head(10)

# 분석_여성 직업 빈도 상위 10개
job_female <- welfare %>% 
  filter(!is.na(job) & sex == 'female') %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

# 그래프_남성 직업 빈도 상위 10개
ggplot(data = job_male, aes(x = reorder(job, n), y = n)) + # geom_col()은 x축과 y축 모두 필요.
  geom_col() +
  coord_flip()
       
# 그래프_여성 직업 빈도 상위 10개
ggplot(data = job_female, aes(x = reorder(job, n), y = n)) +
  geom_col() +
  coord_flip()

# 종교 유무에 따른 이혼율

# 종교 변수 전처리
class(welfare$religion)
table(welfare$religion)

welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")
qplot(welfare$religion)

# 혼인 상태 변수 검토
class(welfare$marriage)
table(welfare$marriage)

# 이혼 여부 변수 만들기
welfare$group_marriage <- ifelse(welfare$marriage == 1, "marriage",
                                 ifelse(welfare$marriage == 3, "divorce", NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))
qplot(welfare$group_marriage)

# 분석
religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% # 먼저 종교 여부로 나누고, 이혼 여부로 또 나누어 줌. 
  summarise(n = n()) %>% # 4개 집단의 수 구하기
  mutate(group_total = sum(n)) %>%  # 종교가 있는 사람, 종교가 없는 사람의 수
  mutate(pct = round((n/group_total) * 100, 1)) # 이혼율율

religion_marriage

# count(): dplyr 패키지에 있는 집단별 빈도를 구하는 함수.
# religion_marriage <- welfare %>% 
#   filter(!is.na(group_marriage)) %>% 
#   count(religion, group_marriage) %>%
#   group_by(religion) %>%
#   mutate(pct = round(n/sum(n)*100, 1))

# 이혼만 추출
divorce <- religion_marriage %>% 
  filter(group_marriage == 'divorce') %>% 
  select(religion, pct)

divorce

# 이혼율 그래프
ggplot(data = divorce, aes(x = religion, y = pct)) +
  geom_col()

# 연령대 및 종교 유무에 따른 이혼율 분석하기

# 연령대별 결혼 상태
ageg_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(n =n()) %>% 
  mutate(group_total = sum(n)) %>% 
  mutate(pct = round((n/group_total)*100, 1))

ageg_marriage

# count() 이용해서 구하기!
# ageg_marriage <- welfare %>% 
#   filter(!is.na(group_marriage)) %>% 
#   count(ageg, group_marriage) %>%
#   group_by(ageg) %>% 
#   mutate(pct = round((n/sum(n))*100, 1))

# 초년(young)은 사례수가 적어 중년 또는 노년과 비교하기에 적합하지 않으로 초년을 제외하고 그래프를 그리기

# 그래프 그리기
ageg_divorce <- ageg_marriage %>% 
  filter(ageg != "young" & group_marriage == "divorce") %>% 
  select(ageg, pct)

ggplot(data = ageg_divorce, aes(x = ageg, y = pct)) +
  geom_col()

# 연령대 및 종교 유무에 따른 이혼율 분석하기

# 연령대 및 종교에 따른 결혼 상태
ageg_religion_marrige <- welfare %>% 
  filter(!is.na(group_marriage) & ageg != "young") %>% 
  group_by(ageg, religion, group_marriage) %>% 
  summarise(n = n()) %>% 
  mutate(group_total = sum(n)) %>% 
  mutate(pct = round((n/group_total)*100, 1))

ageg_religion_marrige

# count() 이용해서 코드 작성
# ageg_religion_marrige <- welfare %>% 
#   filter(!is.na(group_marriage) & ageg != "young") %>% 
#   count(ageg, religion, group_marriage) %>% 
#   group_by(ageg, religion) %>% 
#   mutate(pct = round((n/sum(n))*100, 1))

# 연령대 및 종교에 따른 이혼율
df_divorce <- ageg_religion_marrige %>% 
  filter(group_marriage == "divorce") %>% 
  select(ageg, religion, pct)

df_divorce

# 연령대 및 종교에 따른 이혼율 그래프
ggplot(data = df_divorce, aes(x = ageg, y = pct, fill = religion)) +
  geom_col(position = "dodge")


# 지역별 연령대 비율

# 지역 변수 검토
class(welfare$code_region)
table(welfare$code_region)

# 지역 코드와 지역명으로 구성된 데이터프레임 생성
list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북, 제주도"))

# 지역명 변수 추가
welfare <- left_join(welfare, list_region)

welfare %>% 
  select(code_region, region) %>% 
  head

# 지역별 연령대 비율표 만들기
region_ageg <- welfare %>% 
  group_by(region, ageg) %>% 
  summarise(n = n()) %>% 
  mutate(region_total = sum(n)) %>% 
  mutate(pct = round((n/region_total)*100, 1))

region_ageg

# count() 이용해서~
# region_ageg <- welfare %>% 
#   count(region, ageg) %>% 
#   group_by(region) %>% 
#   mutate(pct = round((n/sum(n))*100, 1))

# 지역별 연령대 비율그래프 그리기
ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip()

# 노년층 비율 높은 순으로 그래프 그리기

# 노년층 비율 내림차순 정렬
list_order_old <- region_ageg %>% 
  filter(ageg == "old") %>% 
  arrange(pct)

list_order_old

# 지역명 순서 변수
order <- list_order_old$region
order

# 그래프
ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip()+
  scale_x_discrete(limits = order)

# 연령대 순으로 막대 색깔 나열하기

# 연령대 변수 검토
class(region_ageg$ageg)
levels(region_ageg$ageg) # 현재 character형이기 때문에 levels(범주)가 없음.

# 연령대 변수 factor로 만들어 주기
region_ageg$ageg <- factor(region_ageg$ageg,
                           levels = c("old", "middle", "young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)

# 그래프
ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)
