# 텍스트 마이닝

# 필요한 패키지 설치
install.packages("rJava")
install.packages("memoise")
install.packages("KoNLP") # 이렇게 해서 설치가 안 되면 밑에 코드 이용, KoNLP은 Java 설치 후 사용 가능

install.packages("multilinguer")
library(multilinguer)
install_jdk()

install.packages(c("stringr", "hash", "tau", "Sejong", "RSQLite", "devtools"), type = "binary")

install.packages("remotes")
remotes::install_github("haven-jeon/KoNLP", 
                        upgrade = "never",
                        INSTALL_opts=c("--no-multiarch")) # https://github.com/youngwoos/Doit_R/blob/master/FAQ/install_KoNLP.md

# 필요한 패키지 가져오기
library(KoNLP) # 한글 자연어 분석 패키지
library(dplyr) # 데이터 전처리

# 사전 설정
useNIADic()

# 힙합 가사 텍스트 마이닝

# 데이터 가져오기기
txt <- readLines("hiphop.txt")
head(txt)

# 특수문자 제거하기
# install.packages("stringr")

library(stringr)

txt <- str_replace_all(txt, "\\W", " ") # txt에서 특수문자를 찾아서 공백으로 바꾸어라! \\W 특수문자를 의미하는 정규표현식.

# 가사에서 명사 추출하고, 단어를 리스트로 반환
nouns <- extractNoun(txt)
nouns

# 리스트를 해제하여 문자열 벡터로 만든 후, 테이블(빈도표) 생성.
wordcount <- table(unlist(nouns))
wordcount

# 데이터프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
head(df_word)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

head(df_word)

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)

# 빈도가 상위 20개인 단어 추출
top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

top_20

# 워드 클라우드 만들기
install.packages("wordcloud")

library(wordcloud)
library(RColorBrewer)

pal <- brewer.pal(8, "Dark2") # Dark2 색상 목록에서 8개 색상 추출

set.seed(1234) # 코드를 실행할 때마다 동일한 워드 클라우드가 생성되도록 난수 고정

wordcloud(words = df_word$word, # 단어
          freq = df_word$freq, # 빈도
          min.freq = 2, # 최소 단어 빈도
          max.words = 200, # 표현할 단어 수
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = .1, # 회전 단어 비율
          scale = c(4, 0.3), # 단어 크기 범위
          colors = pal) # 색상 목록록
