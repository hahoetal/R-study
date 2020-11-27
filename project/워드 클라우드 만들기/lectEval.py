# 에브리타임 강의평가 가져오기
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from bs4 import BeautifulSoup

# 변수 설정
username = input('아이디를 입력하세요: ')
pw = input('비밀번호를 입력하세요: ')
lect = input('가져올 강의명을 입력하세요: ')

driver = webdriver.Chrome('웹 드라이버 경로')

# 로그인 페이지
driver.get('https://everytime.kr/login')
driver.implicitly_wait(5)

# 로그인
driver.find_element_by_name('userid').send_keys(username)
driver.find_element_by_name('password').send_keys(pw)
driver.find_element_by_xpath('//*[@id="container"]/form/p[3]/input').click()
driver.implicitly_wait(5)

# 강의 평가 페이지
driver.find_element_by_xpath('//*[@id="menu"]/li[3]/a').click()
driver.implicitly_wait(7)

# 검색
search = driver.find_element_by_xpath('//*[@id="container"]/form/input[1]')
search.send_keys(lect)
search.submit()
driver.implicitly_wait(5)

# 검색 결과 상단에 있는 강의 선택
driver.find_element_by_xpath('//*[@id="container"]/div/a[1]').click()
driver.implicitly_wait(10)

# 스크롤 내리기_이 동작이 빠지면 강의 평가 글을 가져올 수 없음.
element = driver.find_element_by_xpath('//*[@id="bottom"]/ul')
actions = ActionChains(driver).move_to_element(element)
actions.perform()

html = driver.page_source
# print(html)
soup = BeautifulSoup(html, 'html.parser')

# 가지고 온 강의 정보 가져오기
div1 = soup.find('div', {'class': 'side head'})
name = div1.find('h2').text
professor = div1.find('p').find('span').text

# 강의 평가 가져오기
div2 = soup.find('div', {'class':'articles'})
lectEval = [] # 강의 평가 내용을 담을 리스트

for article in div2.find_all('article'):
    t = article.find('p', {'class':'text'}).text
    lectEval.append(t)

with open('lectEval.txt', 'w', encoding='utf-8') as file:
    file.write(f'{name}_{professor}\n')
    for l in lectEval:
        file.write(f'{l}\n')

print('완료')