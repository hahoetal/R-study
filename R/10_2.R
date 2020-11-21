# 국정원 트윗 텍스트 마이닝

library(rJava) # KoNLP 패키지를 사용하는데 필요. KoNLP이 자바로 작성된 듯... 아마도...
library(memoise)
library(KoNLP) # 한글 자연어 분석

library(dplyr) # 데이터 전처리
library(stringr) # 문자열을 다루기 위함.

library(ggplot2) # 그래프 그리기

library(wordcloud) # 워드 클라우드 그리기
library(RColorBrewer) # R 내장 패키지, 색상

useNIADic() # 사전 설정.

# 분석
twitter <- read.csv("C:/Users/yeong/OneDrive/바탕 화면/R_study/data/twitter.csv",
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8") # 데이터 읽어오기

head(twitter)

twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용) # 변수가 한글이어서.. 영어로 변경

twitter$tw <- str_replace_all(twitter$tw, "\\W", " ") # 특수문자 제거
head(twitter$tw)

nouns <- extractNoun(twitter$tw) # 트윗에서 명사 추출

wordcount <- table(unlist(nouns)) # 추출한 명사 리스트를 문자열 벡터로 전환 후 단어별 빈도표 생성
head(wordcount)

df_word <- as.data.frame(wordcount, stringsAsFactors = F) # 데이터 프레임으로 변환, 오타 주의!
head(df_word)

df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq) # 변수명 변경

df_word <- filter(df_word, nchar(word) >= 2) # 두 글자 이상의 단어만 남기기

top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20) # 빈도수가 제일 높은 20개 단어만 추출

top_20

# 단어 빈도 막대 그래프
order <- arrange(top_20, freq)$word # 빈도 순서 변수 생성

ggplot(data = top_20, aes(x = word, y = freq)) +
  ylim(0, 2500) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order) + # 빈도순 막대 정렬
  geom_text(aes(label = freq), hjust = -0.3) # 빈도 표시

# 워드 클라우드
pal <- brewer.pal(8, "Dark2") # 색상 목록

set.seed(1234) # 난수 고정

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = F,
          rot.per = .1,
          scale = c(6, 0.2),
          colors = pal)
