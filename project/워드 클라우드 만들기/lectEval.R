# 파이썬 크롤링으로 가져온 강의평가 가지고 워드 클라우드 생성하기
# install.packages("rJava")
# install.packages("memoise")

library(KoNLP) # 한글 자연어 분석 패키지
library(dplyr)
library(stringr)
library(wordcloud)
library(RColorBrewer)

useNIADic() # 사전 설정

# 데이터 불러오기_제대로 못 읽어오면... R studio를 다시 시작해 보자ㅎㅎ
text <- readLines("C:/Users/yeong/OneDrive/바탕 화면/lectEval.txt",encoding="UTF-8")
head(text)

# 특수문자 제거
text <- str_replace_all(text, "\\W", " ")

# 명사 추출하기
nouns <- extractNoun(text)

# 단어별 빈도표
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변화
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
head(df_word)

# 변수명 변경
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)

# 색상 목록
pal <- brewer.pal(8, "Dark2")

# 난수 고정
set.seed(1234)

# 워드 클라우드 만들기
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = F,
          rot.per = .1,
          scale = c(4, 0.8),
          colors = pal)