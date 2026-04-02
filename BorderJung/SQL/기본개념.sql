/* ============================================================
   SQL 개념 정리
   ============================================================

   [기본 조회]
   - SELECT ... FROM ... WHERE         기본 조회 + 조건 필터
   - ORDER BY col ASC|DESC             정렬 (기본 ASC)
   - LIMIT N                           출력 개수 제한
   - SELECT DISTINCT col1, col2...     행 전체 조합 기준 중복 제거
     → 특정 컬럼 하나가 아닌 SELECT한 컬럼 전체 조합이 같은 행을 제거
     → JOIN으로 1:N 매칭 후 N쪽 컬럼을 SELECT하지 않을 때 중복 발생 → DISTINCT 필요
     → 집계 함수 안에서도 사용 가능: COUNT(DISTINCT col), SUM(DISTINCT col)

   [집계 함수]
   - COUNT(*), COUNT(DISTINCT col)     개수 (중복 제거 가능)
   - AVG(col), SUM(col)               평균, 합계
   - MAX(col), MIN(col)               최대, 최소
   - ROUND(값, 자릿수)                 반올림
   - COUNT(*) vs COUNT(DISTINCT col):
     → COUNT(*)는 행 수(중복 포함), COUNT(DISTINCT col)은 고유값 수
     → "회원수"처럼 중복 제거가 필요하면 반드시 DISTINCT 사용

   [그룹화]
   - GROUP BY col                      동일 값끼리 묶어 집계
     → 집계 함수 외 모든 SELECT 컬럼은 GROUP BY에 포함해야 함
   - HAVING 조건                       그룹에 대한 필터 (WHERE는 행 필터)
   - 집계 함수는 압축 전 원본 행들을 보고 계산 → 결과는 그룹당 1행
     → SUM(A*B): 그룹 내 각 행의 A*B를 모두 더함 (매출액 등)
     → PRICE * SUM(AMOUNT): GROUP BY 키에 종속된 상수는 SUM 바깥으로 뺄 수 있음
       → SUM(PRICE*AMOUNT)과 결과 동일 (PRICE가 그룹 내 동일값일 때)
     → 다중 테이블 JOIN 후 GROUP BY 시 SUM/COUNT 등으로 감싸야 정확
   - 집계 함수 안에 CASE WHEN을 넣어 값을 변환한 뒤 집계 가능
     → AVG(CASE WHEN 조건 THEN 대체값 ELSE 원래값 END)
     → CASE는 표현식이지 서브쿼리가 아님 — SELECT ... FROM 없이 바로 사용

   [조건 / NULL 처리]
   - BETWEEN a AND b                   범위 조건
   - LIKE '패턴%'                      문자열 패턴 매칭
     → LIKE는 패턴 하나만 비교 가능 — LIKE ('%A%', '%B%') ❌ 문법 오류!
     → 여러 패턴 비교: LIKE '%A%' OR col LIKE '%B%' (OR로 각각 써야 함)
     → 컬럼 값이 쉼표 구분 문자열일 때 특정 값 포함 여부: LIKE '%값%'
     → IN은 목록 비교용이지 문자열 내부 검색이 아님!
   - IN (값1, 값2, ...)                목록 포함 여부
   - NOT IN (값1, 값2, ...)            목록에 포함되지 않는 행 필터
     → ⚠️ 서브쿼리 결과에 NULL이 하나라도 있으면 전체 결과가 비어버림!
     → 이유: col != NULL → UNKNOWN, AND UNKNOWN → 모든 행 탈락
     → 반드시 서브쿼리에 WHERE col IS NOT NULL 추가
     → IS NOT IN은 없는 문법! NOT IN으로 써야 함
   - IS NULL / IS NOT NULL             NULL 비교 (= NULL은 안 됨!)
   - IFNULL(col, 대체값)               NULL이면 대체값 출력
   - CASE WHEN 조건 THEN 값 ... END    조건 분기

   [JOIN]
   - JOIN ... ON 조건                  양쪽 다 매칭되는 행만
   - LEFT JOIN ... ON 조건             왼쪽 테이블 전체 유지, 매칭 안 되면 NULL
   - LEFT JOIN + CASE ON: 구간/등급별 동적 매칭
     → ON 절에 CASE를 넣어 계산값에 따라 매칭할 행을 결정
     → 매칭 실패(구간 밖) → NULL → IFNULL로 기본값 처리
     → 예: 대여일수별 할인율 구간 매칭 (7일/30일/90일 이상)
   - LEFT JOIN + WHERE IS NULL         Anti-Join: 다른 테이블에 없는 행만 조회
   - JOIN + WHERE A.col 비교 B.col     두 테이블 간 컬럼 대소 비교

   [서브쿼리]
   - WHERE col = (SELECT ...)          스칼라 서브쿼리
   - WHERE (col1, col2) IN (SELECT ...)  다중 컬럼 서브쿼리
     → 서브쿼리 컬럼 순서 = 바깥 괄호 컬럼 순서 일치해야 함
     → GROUP BY+MAX로 "그룹별 최대값 행 전체"를 가져올 때 사용
     → 바깥 SELECT에는 GROUP BY 불필요 — 원본 행을 그대로 가져옴
   - WHERE col IN (SELECT col ... HAVING 조건)
     → 서브쿼리로 "조건 만족하는 ID 목록"을 구하고, 바깥에서 해당 ID만 필터
     → 서브쿼리 SELECT에는 ID만 반환 (집계값은 HAVING으로만 사용)
     → 바깥과 서브쿼리 양쪽에 기간 조건이 필요할 수 있음 (각각 역할이 다름)
   - WHERE NOT EXISTS (SELECT ...)     존재하지 않는 행 필터

   [합집합]
   - UNION ALL                         중복 포함 합치기 (중복 제거는 UNION)
   - NULL AS col                       없는 컬럼을 NULL로 채워 맞추기

   [윈도우 함수]
   - 함수() OVER (PARTITION BY col)    그룹별 집계값을 새 컬럼으로 추가
     → GROUP BY와 달리 행이 사라지지 않음
   - PERCENT_RANK() OVER (ORDER BY col) 순위 백분율 (0~1)
   - RANK() OVER (ORDER BY col DESC)   동점 허용 순위 (1,1,3,...)
     → LIMIT 1은 동점자 누락 → RANK()=1로 동점 전부 추출
     → GROUP BY + COUNT 결과에 RANK() 붙여 "가장 많은/적은" 패턴
     → 서브쿼리 필수: SELECT에서 만든 RNK를 WHERE에서 못 씀 → 인라인 뷰로 감싸기
   - ROW_NUMBER() OVER (ORDER BY col)   동점이어도 고유 순번 (1,2,3,...)
     → "정확히 N건"이 필요하면 ROW_NUMBER, "동점 전부"면 RANK
     → RANK vs ROW_NUMBER 선택 기준: 문제가 "N마리/N개" → ROW_NUMBER, "가장 ~한" → RANK

   [재귀 CTE]
   - WITH RECURSIVE 이름 AS (          계층/트리 구조 순회
       초기 쿼리
       UNION ALL
       재귀 쿼리
     )
   - 연속 숫자 테이블 생성: SELECT 0 → UNION ALL → SELECT +1 WHERE < N
     → 데이터에 빠진 값(빈 시간대 등)을 채울 때 사용
   - 재귀 CTE + LEFT JOIN 패턴: 빈 구간도 0으로 출력해야 할 때
     → CTE를 기준(왼쪽)으로 LEFT JOIN → COUNT(실제테이블.컬럼)으로 NULL은 0처리

   [비트 연산]
   - SKILL_CODE & CODE > 0            특정 스킬 보유 여부 확인
   - SUM(CODE)로 카테고리 내 여러 스킬 코드를 합산하여 비트 마스크 생성
   - 두 조건을 동시에 확인할 때: & 연달아 쓰지 말고 각각 > 0 비교 후 AND
     → ❌ A & B & C > 0 (세 값의 비트 AND → 항상 0 될 수 있음)
     → ✅ A & B > 0 AND A & C > 0 (독립된 두 비교)

   [서브쿼리를 FROM절에 사용 (인라인 뷰)]
   - SELECT * FROM (서브쿼리) 별칭  → 서브쿼리 결과를 임시 테이블처럼 사용
   - 반드시 별칭(T, SUB 등) 필요 — 없으면 문법 오류
   - WHERE에서 SELECT 별칭을 쓸 수 없을 때 활용 (실행 순서 때문)
   - FROM절 인라인 뷰 → 바깥 SELECT/WHERE/ORDER BY 어디서든 별칭.컬럼 참조 가능
   - WHERE/HAVING절 서브쿼리 → 값만 반환, 바깥에서 별칭 참조 불가
   - CASE+GROUP BY에서 인라인 뷰 활용:
     → 방법1: 인라인 뷰에서 CASE로 변환 후 바깥에서 GROUP BY (CASE 1번만 작성)
     → 방법2: SELECT와 GROUP BY에 동일 CASE를 직접 반복 (서브쿼리 없이)
     → 복잡한 CASE일수록 인라인 뷰가 깔끔 (반복 제거)
   - 인라인 뷰 안에서 SUM 등 집계 결과를 AS로 별칭 붙여야 바깥에서 참조 가능
   - LIMIT 1은 동점자 누락 → WHERE col=(SELECT MAX(col) FROM ...) 패턴이 안전

   [상관 서브쿼리 vs 인라인 뷰]
   - 상관 서브쿼리: (SELECT ... WHERE col = 바깥.col) — 행마다 실행, 느릴 수 있음
   - 같은 서브쿼리를 CASE에서 여러 번 반복하면 → 인라인 뷰 + JOIN으로 리팩토링
     → 집계 1번만 실행, CASE에서는 별칭만 참조 — 깔끔하고 효율적

   [수학 함수 + 구간 묶기]
   - FLOOR(값): 소수점 버림 (내림)
   - TRUNCATE(값, 자릿수): 지정 자릿수까지 잘라냄
   - 구간 묶기 공식: FLOOR(값 / 단위) * 단위
     → 예: FLOOR(15000/10000)*10000 = 10000 (만원 단위 구간)
     → 정수 나눗셈이 보장 안 될 때(실수형) FLOOR 필수

   [CONCAT + ORDER BY 주의]
   - CONCAT으로 단위를 붙이면 문자열이 됨 → ORDER BY에서 사전순 정렬됨
     → ❌ ORDER BY CONCAT(숫자,'km') — 문자열 비교 ('99' > '100')
     → ✅ ORDER BY 숫자식 — CONCAT 전의 원본 숫자로 정렬

   [문자열 / 날짜]
   - CONCAT(값1, 값2, ...)             문자열 이어붙이기
   - LEFT(str, N) / RIGHT(str, N)     왼쪽/오른쪽에서 N자 추출
   - SUBSTR(str, pos, len)            pos부터 len자 추출 (pos는 1부터)
     → ⚠️ SQL 인덱스는 1-based! (C++/Python의 0-based와 다름)
     → SUBSTR('ABCDE', 1, 2) = 'AB' / SUBSTR('ABCDE', 3, 2) = 'CD'
   - LENGTH(str)                      문자열 길이
   - UPPER(str) / LOWER(str)          대소문자 변환
   - REPLACE(str, from, to)           문자열 치환
   - LEFT/SUBSTR은 GROUP BY에도 사용 가능 → 코드 앞자리별 그룹화 등
   - CONCAT + LEFT/SUBSTR/RIGHT 조합으로 전화번호 등 포맷팅
     → CONCAT(LEFT(tel,3), '-', SUBSTR(tel,4,4), '-', RIGHT(tel,4))
   - DATE_FORMAT(날짜, '%Y-%m-%d')     날짜 포맷 변환
   - YEAR(날짜), MONTH(날짜)           연도/월 추출
   - DATEDIFF(끝날짜, 시작날짜)        두 날짜 사이 일수 (끝-시작)
     → ⚠️ 양 끝 포함 대여일수 = DATEDIFF + 1
     → "30일 이상" 대여 = DATEDIFF >= 29 (9/1~9/30 = 29이지만 실제 30일)
   - DATE(datetime컬럼)               DATETIME에서 날짜만 추출
     → ⚠️ DATETIME 컬럼을 날짜 문자열과 비교할 때 반드시 사용!
     → DATE 타입: col = '2022-04-13' ✅ (시간 없으니 바로 비교 가능)
     → DATETIME 타입: col = '2022-04-13' ❌ (시간 때문에 불일치)
       → DATE(col) = '2022-04-13' ✅

   [SQL 실행 순서 + WHERE vs HAVING]
   - 실행 순서: FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
     → WHERE: 원본 행 대상, 집계 함수 못 씀
     → HAVING: 그룹 대상, 집계 함수 쓸 수 있음
     → ORDER BY: SELECT 후 → 별칭 사용 가능
   - WHERE: GROUP BY 전, 개별 행 필터 (집계 함수 사용 불가)
   - HAVING: GROUP BY 후, 그룹 필터 (집계 함수 사용 가능)
   - NULL 제외는 WHERE IS NOT NULL (행 단위), 개수 조건은 HAVING (그룹 단위)

   [GROUP BY + 중첩 CASE + 집계]
   - GROUP BY로 묶으면 개별 행의 값은 보장 안 됨 → 반드시 집계 함수 사용
   - MAX(CASE WHEN 조건 THEN 1 ELSE 0 END)  그룹 내 조건 만족 행 존재 여부 판별
     → "하나라도 만족하면 1" 패턴
   - 날짜 범위 포함 체크: START_DATE <= 날짜 AND END_DATE >= 날짜
   - 기간 겹침(overlap) 판별: START_DATE <= 기간끝 AND END_DATE >= 기간시작
     → 단일 날짜 포함(점): S <= D AND E >= D  /  기간 겹침(구간): S <= E2 AND E >= S2
     → NOT IN 서브쿼리와 결합 → "해당 기간에 예약 없는 항목" 추출
     → 계산식(FLOOR 등)을 SELECT와 WHERE에 모두 써야 할 때: 별칭은 WHERE에서 못 씀(실행 순서)
       → 같은 식을 반복하거나, 인라인 뷰로 감싸서 바깥에서 별칭 필터

   ============================================================ */


-- ============================================================
-- 예제 모음
-- ============================================================


-- [기본 조회 + ROUND + AVG]
SELECT ROUND(AVG(DAILY_FEE)) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE='SUV';

-- ★ 연습: EMPLOYEE 테이블에서 DEPARTMENT='Engineering'인 사원들의
--   평균 SALARY를 소수 첫째 자리에서 반올림하여 AVG_SALARY로 출력하라.
-- 풀이 포인트: ROUND(AVG(SALARY)) + WHERE 조건


-- [ORDER BY 다중 정렬]
SELECT FLAVOR FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID;

-- ★ 연습: STUDENT 테이블에서 GRADE 내림차순, 같은 GRADE면 NAME 오름차순으로 출력하라.
-- 풀이 포인트: ORDER BY GRADE DESC, NAME ASC


-- [GROUP BY + HAVING: 중복 조합 필터]
SELECT USER_ID, PRODUCT_ID FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >= 2
ORDER BY USER_ID, PRODUCT_ID DESC;

-- ★ 연습: ORDER_LOG 테이블에서 같은 CUSTOMER_ID, ITEM_ID 조합이 3번 이상 등장하는
--   것만 출력하라. CUSTOMER_ID 오름차순 정렬.
-- 풀이 포인트: GROUP BY 두 컬럼 + HAVING COUNT(*) >= 3


-- [서브쿼리: 가장 작은/큰 값 찾기 - NOT EXISTS]
SELECT D1.NAME FROM ANIMAL_INS D1
WHERE NOT EXISTS (
    SELECT 1 FROM ANIMAL_INS D2
    WHERE D2.DATETIME < D1.DATETIME
);

-- [서브쿼리: 가장 작은/큰 값 찾기 - LIMIT]
SELECT NAME FROM ANIMAL_INS
ORDER BY DATETIME ASC
LIMIT 1;

-- ★ 연습: PRODUCT 테이블에서 가장 비싼 상품의 NAME을 출력하라.
--   NOT EXISTS 방식과 ORDER BY + LIMIT 방식 두 가지로 풀어보라.
-- 풀이 포인트: NOT EXISTS(SELECT 1 ... WHERE PRICE > P1.PRICE) 또는 ORDER BY PRICE DESC LIMIT 1


-- [DATE_FORMAT + YEAR 필터]
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK
WHERE YEAR(PUBLISHED_DATE)=2021 AND CATEGORY='인문'
ORDER BY PUBLISHED_DATE ASC;

-- ★ 연습: EVENT 테이블에서 2023년에 열린 CATEGORY='음악' 이벤트의
--   EVENT_ID와 EVENT_DATE를 'YYYY-MM-DD' 형식으로 출력하라. 날짜 오름차순.
-- 풀이 포인트: DATE_FORMAT(EVENT_DATE, '%Y-%m-%d') + WHERE YEAR()=2023


-- [IFNULL: NULL 대체]
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT
WHERE GEND_CD='W' AND AGE<=12
ORDER BY AGE DESC, PT_NAME ASC;

-- ★ 연습: MEMBER 테이블에서 NAME, EMAIL을 출력하되,
--   EMAIL이 NULL이면 '미등록'으로 표시하라. NAME 오름차순.
-- 풀이 포인트: IFNULL(EMAIL, '미등록')


-- [JOIN ON]
SELECT F.FLAVOR FROM FIRST_HALF F
JOIN ICECREAM_INFO I ON F.FLAVOR=I.FLAVOR
WHERE F.TOTAL_ORDER>3000 AND I.INGREDIENT_TYPE='fruit_based'
ORDER BY F.TOTAL_ORDER DESC;

-- ★ 연습: ORDER_DETAIL과 PRODUCT 테이블을 PRODUCT_ID로 JOIN하여,
--   PRODUCT.CATEGORY='전자기기'이고 ORDER_DETAIL.QUANTITY>=10인
--   PRODUCT_NAME을 QUANTITY 내림차순으로 출력하라.
-- 풀이 포인트: JOIN ON + WHERE 두 테이블 조건 결합


-- [LIKE: 문자열 패턴 검색]
SELECT FACTORY_ID, FACTORY_NAME, ADDRESS FROM FOOD_FACTORY
WHERE ADDRESS LIKE '강원도%'
ORDER BY FACTORY_ID ASC;

-- ★ 연습: STORE 테이블에서 STORE_NAME에 '카페'가 포함된 매장의
--   STORE_ID, STORE_NAME을 출력하라. STORE_ID 오름차순.
-- 풀이 포인트: WHERE STORE_NAME LIKE '%카페%'


-- [GROUP BY + JOIN + ROUND(AVG)]
SELECT I.REST_ID, I.REST_NAME, I.FOOD_TYPE, I.FAVORITES, I.ADDRESS,
       ROUND(AVG(R.REVIEW_SCORE),2) AS SCORE
FROM REST_INFO I
JOIN REST_REVIEW R ON I.REST_ID=R.REST_ID
WHERE I.ADDRESS LIKE '서울%'
GROUP BY I.REST_ID
ORDER BY SCORE DESC, I.FAVORITES DESC;

-- ★ 연습: COURSE와 COURSE_REVIEW를 COURSE_ID로 JOIN하여,
--   COURSE.CATEGORY='프로그래밍'인 강좌별 평균 RATING을 소수 둘째자리까지 구하라.
--   평균 RATING 내림차순 정렬.
-- 풀이 포인트: JOIN + WHERE + GROUP BY + ROUND(AVG(), 2)


-- [UNION ALL + NULL AS]
SELECT DATE_FORMAT(SALES_DATE,'%Y-%m-%d') AS SALES_DATE,
       PRODUCT_ID, USER_ID, SALES_AMOUNT
FROM ONLINE_SALE
WHERE YEAR(SALES_DATE)=2022 AND MONTH(SALES_DATE)=3

UNION ALL

SELECT DATE_FORMAT(SALES_DATE,'%Y-%m-%d') AS SALES_DATE,
       PRODUCT_ID, NULL AS USER_ID, SALES_AMOUNT
FROM OFFLINE_SALE
WHERE YEAR(SALES_DATE)=2022 AND MONTH(SALES_DATE)=3

ORDER BY SALES_DATE ASC, PRODUCT_ID ASC, USER_ID ASC;

-- ★ 연습: APP_SALE(컬럼: SALE_DATE, APP_ID, USER_ID, AMOUNT)과
--   STORE_SALE(컬럼: SALE_DATE, APP_ID, AMOUNT — USER_ID 없음)을
--   2023년 1월 데이터만 UNION ALL로 합쳐라. STORE_SALE에는 NULL AS USER_ID.
--   SALE_DATE 오름차순 정렬.
-- 풀이 포인트: 컬럼 수 맞추기 위해 NULL AS col 사용


-- [COUNT + BETWEEN: 특정 조건 개수]
SELECT COUNT(*) AS USERS FROM USER_INFO
WHERE YEAR(JOINED)=2021 AND AGE BETWEEN 20 AND 29;

-- ★ 연습: RESERVATION 테이블에서 2023년에 예약되었고,
--   PRICE가 50000~100000 사이인 예약 건수를 구하라.
-- 풀이 포인트: WHERE YEAR()=2023 AND PRICE BETWEEN 50000 AND 100000 + COUNT(*)


-- [셀프 JOIN: 부모-자식 관계 탐색]
SELECT I.ITEM_ID, I.ITEM_NAME, I.RARITY FROM ITEM_INFO I
JOIN ITEM_TREE T ON T.ITEM_ID=I.ITEM_ID
JOIN ITEM_INFO P ON T.PARENT_ITEM_ID=P.ITEM_ID
WHERE P.RARITY='RARE'
ORDER BY I.ITEM_ID DESC;

-- ★ 연습: EMPLOYEE 테이블(ID, NAME, MANAGER_ID)에서
--   매니저의 NAME이 '김철수'인 부하직원의 ID, NAME을 출력하라.
--   셀프 JOIN: EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID=M.ID
-- 풀이 포인트: 같은 테이블을 두 번 JOIN하여 부모-자식 관계 탐색


-- [LIMIT: 상위 N개]
SELECT ID, LENGTH FROM FISH_INFO
ORDER BY LENGTH DESC, ID ASC
LIMIT 10;

-- ★ 연습: SCORE 테이블에서 점수가 가장 높은 상위 5명의
--   STUDENT_ID, SCORE를 출력하라. 같은 점수면 STUDENT_ID 오름차순.
-- 풀이 포인트: ORDER BY SCORE DESC, STUDENT_ID ASC + LIMIT 5


-- [COUNT + IN: 특정 값 필터]
SELECT COUNT(*) AS FISH_COUNT FROM FISH_INFO FI
JOIN FISH_NAME_INFO FNI ON FI.FISH_TYPE=FNI.FISH_TYPE
WHERE FNI.FISH_NAME IN ('BASS','SNAPPER');

-- ★ 연습: BOOK 테이블에서 GENRE가 'SF', '판타지', '미스터리' 중 하나인
--   책의 총 개수를 구하라.
-- 풀이 포인트: WHERE GENRE IN ('SF','판타지','미스터리') + COUNT(*)


-- [LEFT JOIN: NULL 포함 전체 유지]
SELECT P.ID, COUNT(C.ID) AS CHILD_COUNT FROM ECOLI_DATA P
LEFT JOIN ECOLI_DATA C ON P.ID=C.PARENT_ID
GROUP BY P.ID
ORDER BY P.ID ASC;

-- ★ 연습: TEACHER 테이블과 CLASS 테이블을 TEACHER_ID로 LEFT JOIN하여,
--   각 선생님이 담당하는 수업 수를 구하라. 수업이 없는 선생님도 0으로 표시.
--   TEACHER_ID 오름차순.
-- 풀이 포인트: LEFT JOIN + COUNT(C.컬럼) (NULL은 카운트 안 됨)


-- [LEFT JOIN + WHERE IS NULL: Anti-Join — 다른 테이블에 없는 행 찾기]
-- LEFT JOIN 후 매칭 안 된 행(NULL)만 필터 → 한쪽에만 존재하는 데이터 조회
-- NOT IN과 같은 역할이지만 NULL 함정 없이 안전
-- 문제: 프로그래머스 Lv.3 '없어진 기록 찾기'
SELECT O.ANIMAL_ID, O.NAME FROM ANIMAL_OUTS O
LEFT JOIN ANIMAL_INS I ON O.ANIMAL_ID=I.ANIMAL_ID
WHERE I.ANIMAL_ID IS NULL
ORDER BY O.ANIMAL_ID;


-- [LEFT JOIN + WHERE IS NULL + LIMIT: 매칭 안 되는 행 중 상위 N개]
-- Anti-Join 패턴에 ORDER BY + LIMIT을 결합하여 "없는 쪽에서 상위 N개" 조회
-- 문제: 프로그래머스 Lv.3 '오랜 기간 보호한 동물(1)'
SELECT I.NAME, I.DATETIME FROM ANIMAL_INS I
LEFT JOIN ANIMAL_OUTS O ON I.ANIMAL_ID=O.ANIMAL_ID
WHERE O.ANIMAL_ID IS NULL
ORDER BY I.DATETIME
LIMIT 3;


-- [JOIN + 날짜 비교: 두 테이블 간 컬럼 대소 비교]
-- JOIN 후 WHERE에서 두 테이블의 컬럼을 직접 비교하여 이상 데이터 탐지
-- 문제: 프로그래머스 Lv.3 '있었는데요 없었습니다'
SELECT I.ANIMAL_ID, I.NAME FROM ANIMAL_INS I
LEFT JOIN ANIMAL_OUTS O ON I.ANIMAL_ID=O.ANIMAL_ID
WHERE O.DATETIME < I.DATETIME
ORDER BY I.DATETIME;


-- [JOIN + LIKE 다중 조건: 두 테이블 간 상태 변화 비교]
-- 들어올 때(INS)와 나갈 때(OUTS) 상태를 각각 LIKE로 비교하여 변화 감지
-- 핵심: 한쪽은 LIKE '%Intact%', 다른 쪽은 LIKE '%Spayed%' OR LIKE '%Neutered%'
-- 문제: 프로그래머스 Lv.4 '보호소에서 중성화한 동물'
SELECT I.ANIMAL_ID, I.ANIMAL_TYPE, I.NAME FROM ANIMAL_INS I
JOIN ANIMAL_OUTS O ON I.ANIMAL_ID=O.ANIMAL_ID
WHERE I.SEX_UPON_INTAKE LIKE '%Intact%'
  AND (O.SEX_UPON_OUTCOME LIKE '%Spayed%' OR O.SEX_UPON_OUTCOME LIKE '%Neutered%')
ORDER BY I.ANIMAL_ID;


-- [JOIN + GROUP BY + SUM: 상품코드별 매출액 집계]
-- PRICE는 GROUP BY 키(PRODUCT_CODE)에 종속 → 집계 없이 사용 가능
-- SUM은 GROUP BY 후 그룹 내 행들을 합산
-- 문제: 프로그래머스 Lv.2 '상품 별 오프라인 매출 구하기'
SELECT P.PRODUCT_CODE, P.PRICE * SUM(S.SALES_AMOUNT) AS SALES FROM PRODUCT P
JOIN OFFLINE_SALE S ON P.PRODUCT_ID=S.PRODUCT_ID
GROUP BY P.PRODUCT_CODE
ORDER BY SALES DESC, P.PRODUCT_CODE;


-- [JOIN + COUNT(DISTINCT) + 스칼라 서브쿼리: 비율 계산]
-- 분자: COUNT(DISTINCT USER_ID) — 월별 구매 고유 회원수
-- 분모: (SELECT COUNT(*) FROM ...) — 전체 기준 회원수 (스칼라 서브쿼리로 고정값)
-- 핵심: 비율 = 분자/분모, ROUND로 소수점 처리
-- 문제: 프로그래머스 Lv.4 '년, 월, 성별 별 상품 구매 회원 수 구하기' 변형
SELECT
    YEAR(S.SALES_DATE) AS YEAR, MONTH(S.SALES_DATE) AS MONTH,
    COUNT(DISTINCT U.USER_ID) AS PURCHASED_USERS,
    ROUND(COUNT(DISTINCT U.USER_ID) / (SELECT COUNT(*) FROM USER_INFO WHERE YEAR(JOINED)=2021), 1) AS PURCHASED_RATIO
FROM ONLINE_SALE S
JOIN USER_INFO U ON S.USER_ID=U.USER_ID
WHERE YEAR(U.JOINED)=2021
GROUP BY YEAR(S.SALES_DATE), MONTH(S.SALES_DATE)
ORDER BY YEAR, MONTH;


-- [JOIN + NOT IN 서브쿼리 + 계산식 필터: 복합 조건 대여 가능 차량 조회]
-- 1) JOIN으로 차량-할인 연결, WHERE IN으로 차종 필터
-- 2) NOT IN 서브쿼리로 해당 기간 대여중인 차량 제외 (날짜 겹침: START<=종료 AND END>=시작)
-- 3) 계산식(30*일일요금*(1-할인율))을 WHERE에서 직접 범위 필터
-- 핵심: SELECT 별칭(FEE)은 WHERE에서 못 씀 → 계산식 반복 or 인라인 뷰 사용
-- 문제: 프로그래머스 Lv.4 '자동차 대여 기록에서 대여중/대여 가능 여부 구분하기' 변형
SELECT C.CAR_ID, C.CAR_TYPE, FLOOR(30*C.DAILY_FEE*((100-P.DISCOUNT_RATE)/100)) AS FEE
FROM CAR_RENTAL_COMPANY_CAR C
JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN P ON C.CAR_TYPE=P.CAR_TYPE
WHERE C.CAR_TYPE IN ('세단','SUV')
    AND P.DURATION_TYPE='30일 이상'
    AND C.CAR_ID NOT IN (
        SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
        WHERE START_DATE <= '2022-11-30' AND END_DATE >= '2022-11-01'
    )
    AND FLOOR(30*C.DAILY_FEE*((100-P.DISCOUNT_RATE)/100)) >= 500000
    AND FLOOR(30*C.DAILY_FEE*((100-P.DISCOUNT_RATE)/100)) < 2000000
GROUP BY CAR_ID, CAR_TYPE
ORDER BY FEE DESC, C.CAR_TYPE, C.CAR_ID DESC;


-- [CASE WHEN: 조건 분기]
SELECT ID,
    CASE
        WHEN SIZE_OF_COLONY<=100 THEN 'LOW'
        WHEN SIZE_OF_COLONY<=1000 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS SIZE
FROM ECOLI_DATA
ORDER BY ID;

-- ★ 연습: STUDENT 테이블에서 SCORE가 90 이상이면 'A',
--   80 이상이면 'B', 70 이상이면 'C', 나머지는 'F'로 GRADE 컬럼을 만들어 출력하라.
-- 풀이 포인트: CASE WHEN은 위에서부터 순서대로 평가됨 — 범위 겹침 주의


-- [윈도우 함수: PERCENT_RANK]
SELECT ID,
    CASE
        WHEN PR <= 0.25 THEN 'CRITICAL'
        WHEN PR <= 0.5  THEN 'HIGH'
        WHEN PR <= 0.75 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS COLONY_NAME
FROM (
    SELECT ID, PERCENT_RANK() OVER (ORDER BY SIZE_OF_COLONY DESC) AS PR
    FROM ECOLI_DATA
) T
ORDER BY ID ASC;

-- ★ 연습: EMPLOYEE 테이블에서 SALARY 기준으로 상위 25%는 'S',
--   50%까지 'A', 75%까지 'B', 나머지 'C' 등급을 매겨라. ID 오름차순.
-- 풀이 포인트: PERCENT_RANK() OVER (ORDER BY SALARY DESC) + 서브쿼리에서 계산 후 바깥 CASE


-- [WITH RECURSIVE: 계층 구조 순회]
WITH RECURSIVE GEN AS (
    SELECT ID, 1 AS GENERATION
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NULL

    UNION ALL

    SELECT E.ID, G.GENERATION + 1
    FROM ECOLI_DATA E
    JOIN GEN G ON E.PARENT_ID = G.ID
)
SELECT COUNT(*) AS COUNT, G.GENERATION
FROM GEN G
LEFT JOIN ECOLI_DATA C ON G.ID = C.PARENT_ID
WHERE C.ID IS NULL
GROUP BY G.GENERATION
ORDER BY G.GENERATION ASC;

-- ★ 연습: CATEGORY 테이블(ID, NAME, PARENT_ID)에서 각 카테고리의 depth를 구하라.
--   PARENT_ID가 NULL이면 depth=1. 결과: ID, NAME, DEPTH. DEPTH 오름차순.
-- 풀이 포인트: WITH RECURSIVE + 초기 WHERE PARENT_ID IS NULL → JOIN으로 DEPTH+1 확장


-- [COUNT(DISTINCT): 중복 제거 개수]
SELECT COUNT(DISTINCT NAME) AS COUNT FROM ANIMAL_INS;

-- ★ 연습: ORDER_LOG 테이블에서 주문한 적 있는 고유 CUSTOMER_ID의 수를 구하라.
-- 풀이 포인트: COUNT(DISTINCT CUSTOMER_ID)


-- [서브쿼리: 최대/최소값 행 조회]
SELECT * FROM FOOD_PRODUCT
WHERE PRICE=(SELECT MAX(PRICE) FROM FOOD_PRODUCT);

-- [대안: ORDER BY + LIMIT]
SELECT * FROM FOOD_PRODUCT
ORDER BY PRICE DESC
LIMIT 1;

-- ★ 연습: EMPLOYEE 테이블에서 SALARY가 가장 높은 사원의 전체 정보를 출력하라.
--   서브쿼리 방식과 LIMIT 방식 두 가지로 풀어보라.
-- 풀이 포인트: WHERE SALARY=(SELECT MAX(SALARY)...) 또는 ORDER BY SALARY DESC LIMIT 1


-- [다중 컬럼 서브쿼리: 그룹별 최대값 행]
SELECT F.ID, N.FISH_NAME, F.LENGTH FROM FISH_INFO F
JOIN FISH_NAME_INFO N ON F.FISH_TYPE=N.FISH_TYPE
WHERE (F.FISH_TYPE, F.LENGTH) IN (
    SELECT FISH_TYPE, MAX(LENGTH) FROM FISH_INFO
    GROUP BY FISH_TYPE
)
ORDER BY F.ID ASC;

-- ★ 연습: STUDENT 테이블에서 각 CLASS별로 SCORE가 가장 높은 학생의
--   ID, NAME, CLASS, SCORE를 출력하라. ID 오름차순.
-- 풀이 포인트: WHERE (CLASS, SCORE) IN (SELECT CLASS, MAX(SCORE) ... GROUP BY CLASS)


-- [CONCAT: 문자열 편집]
SELECT CONCAT(MAX(LENGTH), 'cm') AS MAX_LENGTH FROM FISH_INFO;

-- ★ 연습: EMPLOYEE 테이블에서 NAME과 DEPARTMENT를 합쳐
--   'NAME (DEPARTMENT)' 형식으로 INFO 컬럼을 만들어 출력하라.
-- 풀이 포인트: CONCAT(NAME, ' (', DEPARTMENT, ')')


-- [윈도우 함수: PARTITION BY로 그룹별 집계 + 원본 유지]
SELECT YEAR(DIFFERENTIATION_DATE) AS YEAR,
    MAX(SIZE_OF_COLONY) OVER (
        PARTITION BY YEAR(DIFFERENTIATION_DATE)
    ) - SIZE_OF_COLONY AS YEAR_DEV,
    ID
FROM ECOLI_DATA
ORDER BY YEAR ASC, YEAR_DEV ASC;

-- ★ 연습: SALES 테이블에서 각 행에 대해 같은 REGION 내 MAX(AMOUNT)와의 차이를
--   REGION_DIFF 컬럼으로 출력하라. ID, REGION, AMOUNT, REGION_DIFF. ID 오름차순.
-- 풀이 포인트: MAX(AMOUNT) OVER (PARTITION BY REGION) - AMOUNT


-- [GROUP BY + 중첩 CASE + MAX: 그룹 내 조건 존재 여부 판별]
-- 같은 ID에 여러 행이 있을 때, 하나라도 조건을 만족하면 특정 라벨을 부여
-- 핵심: GROUP BY로 묶으면 어떤 행의 값을 쓸지 보장 안 됨 → 집계 함수 필수
-- 문제: 프로그래머스 Lv.2 '자동차 대여 기록에서 대여중/대여 가능 여부 구분하기'
SELECT CAR_ID,
    CASE
        WHEN MAX(
            CASE WHEN START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16'
                 THEN 1 ELSE 0
            END
        ) = 1 THEN '대여중'
        ELSE '대여 가능'
    END AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC;

-- ★ 연습 문제: EMPLOYEE_ATTENDANCE 테이블에 사원별 출근 기록이 여러 행 있다.
--   각 사원이 '2023-07-01'에 출근 기록이 하나라도 있으면 '출근',
--   없으면 '결근'으로 표시하고, EMPLOYEE_ID 오름차순 정렬하라.
--   컬럼: EMPLOYEE_ID, ATTENDANCE_DATE
-- 풀이 포인트: MAX(CASE WHEN ATTENDANCE_DATE = '2023-07-01' THEN 1 ELSE 0 END)


-- [WHERE IS NOT NULL + GROUP BY + HAVING: NULL 제외 후 그룹 필터]
-- 실행 순서: FROM → WHERE(행 필터) → GROUP BY(그룹화) → HAVING(그룹 필터) → SELECT → ORDER BY
-- 문제: 프로그래머스 Lv.2 '동명 동물 수 찾기'
SELECT NAME, COUNT(*) AS COUNT FROM ANIMAL_INS
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING COUNT(*) >= 2
ORDER BY NAME;

-- ★ 연습 문제: PRODUCT 테이블에서 CATEGORY별 상품 수를 구하되,
--   CATEGORY가 NULL인 행은 제외하고, 상품이 5개 이상인 카테고리만 출력하라.
--   결과는 상품 수 내림차순 정렬.
--   컬럼: PRODUCT_ID, CATEGORY
-- 풀이 포인트: WHERE CATEGORY IS NOT NULL → GROUP BY → HAVING COUNT(*) >= 5


-- [JOIN + GROUP BY 다중 컬럼 + COUNT(DISTINCT): 다차원 집계]
-- 같은 회원이 같은 그룹에서 여러 번 등장할 수 있으므로 COUNT(DISTINCT)로 고유 회원수 집계
-- 핵심: COUNT(*)는 "건수", COUNT(DISTINCT col)은 "고유 수" — 문제가 뭘 세라는지 구분!
-- 문제: 프로그래머스 Lv.2 '년, 월, 성별 별 상품 구매 회원 수 구하기'
SELECT
    YEAR(S.SALES_DATE) AS YEAR,
    MONTH(S.SALES_DATE) AS MONTH,
    I.GENDER,
    COUNT(DISTINCT I.USER_ID) AS USERS
FROM USER_INFO I
JOIN ONLINE_SALE S ON I.USER_ID=S.USER_ID
WHERE I.GENDER IS NOT NULL
GROUP BY YEAR(S.SALES_DATE), MONTH(S.SALES_DATE), I.GENDER
ORDER BY YEAR(S.SALES_DATE), MONTH(S.SALES_DATE), I.GENDER;

-- ★ 연습: ENROLLMENT과 STUDENT를 STUDENT_ID로 JOIN하여,
--   년도, 학기, STUDENT.MAJOR별로 수강한 고유 학생 수를 구하라.
--   MAJOR가 NULL인 경우 제외. 년도, 학기, MAJOR 오름차순 정렬.
-- 풀이 포인트: COUNT(DISTINCT S.STUDENT_ID) + WHERE MAJOR IS NOT NULL + GROUP BY 3컬럼


-- [재귀 CTE + LEFT JOIN: 빈 구간 채우기]
-- 재귀로 0~23 숫자 테이블 생성 → LEFT JOIN으로 데이터 없는 시간도 0으로 출력
-- 핵심: LEFT JOIN 왼쪽이 CTE여야 빈 값이 살아남음 + COUNT(A.컬럼)으로 NULL 제외
-- 문제: 프로그래머스 Lv.4 '입양 시각 구하기(2)'
WITH RECURSIVE HOUR AS (
    SELECT 0 AS H
    UNION ALL
    SELECT H + 1 FROM HOUR
    WHERE H < 23
)
SELECT H.H AS HOUR, COUNT(A.ANIMAL_ID) AS COUNT FROM HOUR H
LEFT JOIN ANIMAL_OUTS A ON H.H = HOUR(A.DATETIME)
GROUP BY H.H
ORDER BY H.H;

-- ★ 연습: 1월~12월까지 월별 주문 건수를 구하되, 주문이 없는 달도 0으로 출력하라.
--   테이블: ORDERS(ORDER_ID, ORDER_DATE). 결과: MONTH, ORDER_COUNT.
-- 풀이 포인트: WITH RECURSIVE로 1~12 생성 → LEFT JOIN ON M = MONTH(ORDER_DATE)
--   → COUNT(O.ORDER_ID)


-- [FLOOR + GROUP BY: 구간별 집계]
-- FLOOR(값/단위)*단위로 연속 값을 구간으로 묶어 GROUP BY
-- 핵심: 실수형 컬럼은 정수 나눗셈이 안 되므로 FLOOR 필수
-- 문제: 프로그래머스 Lv.2 '가격대 별 상품 개수'
SELECT FLOOR(PRICE / 10000) * 10000 AS PRICE_GROUP,
       COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY PRICE_GROUP
ORDER BY PRICE_GROUP;

-- ★ 연습: EMPLOYEE 테이블에서 SALARY를 100만원 단위로 묶어
--   구간별 사원 수를 구하라. 결과: SALARY_GROUP, EMP_COUNT. 구간 오름차순.
-- 풀이 포인트: FLOOR(SALARY / 1000000) * 1000000 AS SALARY_GROUP + GROUP BY


-- [다중 JOIN + GROUP BY + SUM: 그룹별 매출액 집계]
-- 집계 함수는 압축 전 원본 행들로 계산 → SUM(판매량*가격)으로 그룹별 매출 합산
-- 핵심: GROUP BY로 묶이면 개별 행 값 보장 안 됨 → 반드시 SUM()으로 감싸기
-- 문제: 프로그래머스 Lv.4 '저자 별 카테고리 별 매출액 집계하기'
SELECT A.AUTHOR_ID, A.AUTHOR_NAME, B.CATEGORY,
       SUM(BS.SALES * B.PRICE) AS TOTAL_SALES
FROM BOOK B
JOIN AUTHOR A ON B.AUTHOR_ID=A.AUTHOR_ID
JOIN BOOK_SALES BS ON B.BOOK_ID=BS.BOOK_ID
WHERE YEAR(BS.SALES_DATE)=2022 AND MONTH(BS.SALES_DATE)=1
GROUP BY A.AUTHOR_ID, A.AUTHOR_NAME, B.CATEGORY
ORDER BY A.AUTHOR_ID, B.CATEGORY DESC;

-- ★ 연습: STORE, PRODUCT, ORDER_DETAIL을 JOIN하여
--   매장별(STORE_NAME), 카테고리별(CATEGORY) 총 매출(SUM(QUANTITY*PRICE))을 구하라.
--   매출 내림차순 정렬.
-- 풀이 포인트: 3테이블 JOIN + GROUP BY 2컬럼 + SUM(수량*단가)


-- [다중 컬럼 서브쿼리 + IN: 그룹별 최대값의 원본 행 조회]
-- 서브쿼리로 (그룹, MAX값) 세트를 구하고, 바깥에서 원본 행을 매칭
-- 핵심: 바깥 SELECT에는 GROUP BY 없음 — 매칭된 원본 행을 그대로 가져옴
-- 문제: 프로그래머스 Lv.3 '식품분류별 가장 비싼 식품의 정보 조회하기'
SELECT CATEGORY, PRICE AS MAX_PRICE, PRODUCT_NAME
FROM FOOD_PRODUCT
WHERE (CATEGORY, PRICE) IN (
    SELECT CATEGORY, MAX(PRICE)
    FROM FOOD_PRODUCT
    WHERE CATEGORY IN ('과자','국','김치','식용유')
    GROUP BY CATEGORY
)
ORDER BY MAX_PRICE DESC;

-- ★ 연습: EMPLOYEE 테이블에서 각 DEPARTMENT별로 SALARY가 가장 높은 사원의
--   DEPARTMENT, SALARY, NAME을 출력하라. SALARY 내림차순.
-- 풀이 포인트: WHERE (DEPARTMENT, SALARY) IN (SELECT DEPARTMENT, MAX(SALARY) ... GROUP BY)


-- [LIKE + OR: 쉼표 구분 문자열에서 다중 값 포함 검색]
-- OPTIONS 같은 쉼표 구분 컬럼에서 특정 값 포함 여부는 LIKE '%값%'
-- 주의: IN은 "목록 중 하나와 일치"이지, 문자열 내부 검색이 아님!
-- 문제: 프로그래머스 Lv.2 '자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기'
SELECT CAR_TYPE, COUNT(*) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%통풍시트%'
   OR OPTIONS LIKE '%열선시트%'
   OR OPTIONS LIKE '%가죽시트%'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE ASC;

-- ★ 연습: PRODUCT 테이블의 TAGS 컬럼('무선,블루투스,방수' 형태)에서
--   '블루투스' 또는 '방수'가 포함된 상품의 CATEGORY별 개수를 구하라.
--   CATEGORY 오름차순 정렬.
-- 풀이 포인트: WHERE TAGS LIKE '%블루투스%' OR TAGS LIKE '%방수%' + GROUP BY CATEGORY


-- [WHERE + GROUP BY + HAVING: 행 필터 → 그룹화 → 그룹 필터]
-- WHERE로 행을 먼저 거르고, GROUP BY로 묶은 뒤, HAVING으로 집계 조건 필터
-- 핵심: WHERE에는 집계 함수 못 씀(원본 행 대상), HAVING에서 SUM/COUNT 등 사용
-- 문제: 프로그래머스 Lv.3 '조건에 맞는 사용자와 총 거래금액 조회하기'
SELECT U.USER_ID, U.NICKNAME, SUM(B.PRICE) AS TOTAL_SALES
FROM USED_GOODS_BOARD B
JOIN USED_GOODS_USER U ON B.WRITER_ID=U.USER_ID
WHERE B.STATUS='DONE'
GROUP BY U.USER_ID, U.NICKNAME
HAVING SUM(B.PRICE) >= 700000
ORDER BY TOTAL_SALES ASC;

-- ★ 연습: ORDER_LOG와 CUSTOMER를 JOIN하여, 2023년 주문 중
--   고객별 총 주문금액(SUM(AMOUNT))이 100만원 이상인 고객의
--   CUSTOMER_ID, NAME, 총 주문금액을 구하라. 총 주문금액 내림차순.
-- 풀이 포인트: WHERE YEAR()=2023 → GROUP BY → HAVING SUM(AMOUNT) >= 1000000


-- [서브쿼리 ID 필터 + HAVING + 바깥 GROUP BY: 조건 만족 ID로 2차 집계]
-- 서브쿼리: 기간 내 총 횟수 5이상인 ID 목록 추출 (HAVING으로 필터, SELECT에는 ID만)
-- 바깥: 해당 ID만 대상으로 월별 집계 (기간 조건 바깥에도 필요)
-- 문제: 프로그래머스 Lv.3 '대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기'
SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(*) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE CAR_ID IN (
    SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE YEAR(START_DATE)=2022
      AND MONTH(START_DATE) >= 8 AND MONTH(START_DATE) <= 10
    GROUP BY CAR_ID
    HAVING COUNT(*) >= 5
) AND YEAR(START_DATE)=2022
  AND MONTH(START_DATE) >= 8 AND MONTH(START_DATE) <= 10
GROUP BY MONTH(START_DATE), CAR_ID
ORDER BY MONTH(START_DATE), CAR_ID DESC;

-- ★ 연습: ENROLLMENT 테이블에서 2023년 1~2학기 동안 총 수강 과목이 6개 이상인
--   학생에 대해, 해당 기간의 학기별·학생별 수강 과목 수를 구하라.
--   학기 오름차순, 같으면 STUDENT_ID 내림차순.
-- 풀이 포인트: 서브쿼리(HAVING COUNT>=6으로 ID 필터) + 바깥(GROUP BY 학기, ID)


-- [비트 연산 + CASE + 인라인 뷰: 스킬 보유 여부로 등급 분류]
-- 비트 & 로 스킬 보유 확인, SUM(CODE)로 카테고리 전체 마스크 생성
-- 핵심: 두 조건 동시 확인 시 & 연달아 쓰면 안 됨 → 각각 > 0 비교 후 AND
-- 인라인 뷰: WHERE에서 SELECT 별칭 못 쓰므로 서브쿼리로 감싸서 필터
-- 문제: 프로그래머스 Lv.4 'GRADE별 개발자 정보 조회하기' (DEVELOPERS + SKILLCODES)
SELECT * FROM (
    SELECT CASE
        WHEN SKILL_CODE & (SELECT SUM(CODE) FROM SKILLCODES WHERE NAME='Python') > 0
         AND SKILL_CODE & (SELECT SUM(CODE) FROM SKILLCODES WHERE CATEGORY='Front End') > 0 THEN 'A'
        WHEN SKILL_CODE & (SELECT SUM(CODE) FROM SKILLCODES WHERE NAME='C#') > 0 THEN 'B'
        WHEN SKILL_CODE & (SELECT SUM(CODE) FROM SKILLCODES WHERE CATEGORY='Front End') > 0 THEN 'C'
        ELSE NULL
    END AS GRADE, ID, EMAIL FROM DEVELOPERS
) T
WHERE GRADE IS NOT NULL
ORDER BY GRADE, ID;

-- ★ 연습: EMPLOYEES(ID, NAME, PERMISSION_CODE)와 PERMISSIONS(NAME, CODE) 테이블.
--   CODE는 2의 거듭제곱. PERMISSION_CODE는 보유 권한의 비트 합.
--   'READ'와 'WRITE' 권한을 모두 가진 사원의 ID, NAME을 출력하라.
-- 풀이 포인트: PERMISSION_CODE & (SELECT CODE WHERE NAME='READ') > 0
--   AND PERMISSION_CODE & (SELECT CODE WHERE NAME='WRITE') > 0


-- [인라인 뷰 + JOIN + MAX 서브쿼리: 집계 결과의 최대값 행 조회]
-- 인라인 뷰로 사원별 총 점수를 만들고, JOIN으로 정보 붙인 뒤, MAX로 최고점 필터
-- 핵심: LIMIT 1은 동점자 누락 → WHERE=(SELECT MAX ...) 패턴 사용
-- 인라인 뷰의 AS 별칭이 있어야 바깥에서 참조 가능
-- 문제: 프로그래머스 Lv.3 '평균 일일 대여 요금 구하기' (HR 3테이블 JOIN)
SELECT G.SCORE, E.EMP_NO, E.EMP_NAME, E.POSITION, E.EMAIL
FROM (
    SELECT EMP_NO, SUM(SCORE) AS SCORE FROM HR_GRADE
    GROUP BY EMP_NO
) G
JOIN HR_EMPLOYEES E ON E.EMP_NO=G.EMP_NO
JOIN HR_DEPARTMENT D ON D.DEPT_ID=E.DEPT_ID
WHERE G.SCORE=(SELECT MAX(SCORE) FROM (
        SELECT EMP_NO, SUM(SCORE) AS SCORE FROM HR_GRADE
        GROUP BY EMP_NO
    ) T
);

-- ★ 연습: SALES_LOG 테이블에서 사원별 총 매출(SUM(AMOUNT))을 구하고,
--   총 매출이 가장 높은 사원의 EMP_ID, NAME(EMPLOYEE 테이블), 총 매출을 출력하라.
--   동점자도 전부 출력.
-- 풀이 포인트: FROM (SELECT EMP_ID, SUM(AMOUNT) AS TOTAL ...) G
--   JOIN EMPLOYEE → WHERE G.TOTAL=(SELECT MAX(TOTAL) FROM 같은서브쿼리)


-- [인라인 뷰 + 다중 CASE: 집계값 기반 등급·성과금 분류]
-- 상관 서브쿼리를 CASE마다 반복하면 비효율 → 인라인 뷰로 1번만 집계 후 CASE에서 참조
-- 핵심: 같은 집계를 여러 곳에서 쓸 때는 인라인 뷰로 빼서 별칭 참조가 깔끔
-- 문제: 프로그래머스 Lv.3 '사원별 성과금 정보 조회' (HR 3테이블)
SELECT E.EMP_NO, E.EMP_NAME, CASE
    WHEN G.SCORE >= 96 THEN 'S'
    WHEN G.SCORE >= 90 THEN 'A'
    WHEN G.SCORE >= 80 THEN 'B'
    ELSE 'C'
END AS GRADE, CASE
    WHEN G.SCORE >= 96 THEN E.SAL * 0.2
    WHEN G.SCORE >= 90 THEN E.SAL * 0.15
    WHEN G.SCORE >= 80 THEN E.SAL * 0.1
    ELSE 0
END AS BONUS
FROM (
    SELECT EMP_NO, AVG(SCORE) SCORE FROM HR_GRADE GROUP BY EMP_NO
) G
JOIN HR_EMPLOYEES E ON G.EMP_NO=E.EMP_NO
ORDER BY E.EMP_NO;

-- ★ 연습: STUDENT와 EXAM(STUDENT_ID, SCORE) 테이블에서 학생별 평균 점수를 구하고,
--   90이상 'A', 80이상 'B', 나머지 'C' 등급과
--   'A'면 장학금 1000000, 'B'면 500000, 'C'면 0을 출력하라.
--   인라인 뷰로 평균을 한 번만 구하고, CASE 2개로 GRADE와 SCHOLARSHIP을 만들 것.
-- 풀이 포인트: FROM (SELECT STUDENT_ID, AVG(SCORE) AS SCORE ... GROUP BY) G JOIN STUDENT


-- [JOIN + GROUP BY + ROUND(AVG): 부서별 평균 연봉]
-- 문제: 프로그래머스 Lv.3 '부서별 평균 연봉 조회하기'
SELECT D.DEPT_ID, D.DEPT_NAME_EN, ROUND(AVG(E.SAL),0) AS AVG_SAL
FROM HR_DEPARTMENT D
JOIN HR_EMPLOYEES E ON D.DEPT_ID=E.DEPT_ID
GROUP BY D.DEPT_ID, D.DEPT_NAME_EN
ORDER BY AVG(E.SAL) DESC;

-- ★ 연습: STORE와 EMPLOYEE를 STORE_ID로 JOIN하여,
--   매장별 평균 SALARY를 소수점 첫째 자리에서 반올림하여 구하라.
--   STORE_ID, STORE_NAME, AVG_SALARY. 평균 연봉 내림차순.
-- 풀이 포인트: JOIN + GROUP BY + ROUND(AVG(), 0) + ORDER BY DESC


-- [CONCAT + ROUND + ORDER BY 숫자식: 단위 붙여 출력하되 숫자로 정렬]
-- CONCAT으로 'km' 등 단위를 붙이면 문자열 → ORDER BY에는 CONCAT 전 숫자식 사용
-- 핵심: 문자열 별칭으로 정렬하면 사전순 ('99' > '100') → 숫자 계산식으로 정렬해야 정확
-- 문제: 프로그래머스 Lv.3 '노선별 평균 역 사이 거리 조회하기'
SELECT ROUTE,
    CONCAT(ROUND(SUM(D_BETWEEN_DIST),1),'km') AS TOTAL_DISTANCE,
    CONCAT(ROUND(AVG(D_BETWEEN_DIST),2),'km') AS AVERAGE_DISTANCE
FROM SUBWAY_DISTANCE
GROUP BY ROUTE
ORDER BY ROUND(SUM(D_BETWEEN_DIST),1) DESC;

-- ★ 연습: DELIVERY 테이블에서 REGION별 총 배송거리에 'm'을 붙여 출력하되,
--   총 배송거리(숫자) 기준 내림차순 정렬하라. 소수 첫째자리 반올림.
-- 풀이 포인트: CONCAT(ROUND(SUM(DISTANCE),0),'m') + ORDER BY ROUND(SUM(DISTANCE),0) DESC


-- [HAVING + AVG(CASE WHEN): 값 변환 후 집계로 그룹 필터]
-- 집계 함수 안에 CASE를 넣어 특정 값을 대체한 뒤 집계 가능 (서브쿼리 아님!)
-- 핵심: NULL이나 이상치를 CASE로 대체 → 집계 함수에 바로 전달
-- 문제: 프로그래머스 Lv.3 '조건에 맞는 물고기 정보 조회하기' (FISH_INFO)
SELECT COUNT(*) AS FISH_COUNT, MAX(LENGTH) AS MAX_LENGTH, FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING AVG(CASE WHEN LENGTH <= 10 OR LENGTH IS NULL THEN 10 ELSE LENGTH END) >= 33
ORDER BY FISH_TYPE;

-- ★ 연습: SCORE 테이블에서 과목별(SUBJECT) 평균 점수가 70 이상인 과목을 구하되,
--   SCORE가 NULL인 학생은 0점으로 취급하라.
--   결과: SUBJECT, AVG_SCORE(소수 첫째자리 반올림). 평균 내림차순.
-- 풀이 포인트: HAVING AVG(CASE WHEN SCORE IS NULL THEN 0 ELSE SCORE END) >= 70


-- [IFNULL vs CASE WHEN: NULL 대체 사용 구분]
-- 단순 NULL 대체 → IFNULL(col, 대체값) 이 간결
-- 조건이 복잡할 때 (NULL + 범위 등) → CASE WHEN 사용
-- 주의: CASE 쓸 때 END 빠뜨리기 쉬움!
-- 문제: 프로그래머스 Lv.1 '냉동/냉장 창고 구별하기'
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN, 'N') AS FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE ADDRESS LIKE '경기도%'
ORDER BY WAREHOUSE_ID;

-- ★ 연습: MEMBER 테이블에서 NAME, PHONE을 출력하되,
--   PHONE이 NULL이면 '번호없음'으로 표시하라. NAME 오름차순.
--   IFNULL 방식과 CASE WHEN 방식 두 가지로 풀어보라.
-- 풀이 포인트: IFNULL(PHONE, '번호없음') 또는 CASE WHEN PHONE IS NULL THEN '번호없음' ELSE PHONE END


-- [NOT IN + NULL 제거: 다른 테이블에 없는 행 찾기]
-- NOT IN 서브쿼리에 NULL이 포함되면 전체 결과가 비어버림 → WHERE IS NOT NULL 필수
-- 용도: "자식이 없는 노드", "참조되지 않는 행" 찾기
-- 문제: 프로그래머스 Lv.3 '업그레이드 할 수 없는 아이템 구하기' (ITEM_INFO + ITEM_TREE)
SELECT I.ITEM_ID, I.ITEM_NAME, I.RARITY FROM ITEM_INFO I
JOIN ITEM_TREE T ON I.ITEM_ID=T.ITEM_ID
WHERE I.ITEM_ID NOT IN (
    SELECT PARENT_ITEM_ID FROM ITEM_TREE
    WHERE PARENT_ITEM_ID IS NOT NULL
)
ORDER BY I.ITEM_ID DESC;

-- ★ 연습: EMPLOYEE 테이블에서 누구의 매니저도 아닌 사원(MANAGER_ID로 참조되지 않는)의
--   ID, NAME을 출력하라. ID 오름차순.
-- 풀이 포인트: WHERE ID NOT IN (SELECT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL)


-- [JOIN + NOT IN 서브쿼리 + 계산식 WHERE: 다중 조건 필터링]
-- 할인 플랜 JOIN + 기간 겹침으로 대여 불가 차량 제외 + 계산 금액 범위 필터
-- 핵심: 기간 겹침 판별 — START_DATE <= 기간끝 AND END_DATE >= 기간시작
-- 주의: SELECT 별칭(FEE)은 WHERE에서 못 씀 → 계산식을 WHERE에 직접 반복
-- 문제: 프로그래머스 Lv.4 '자동차 대여 기록에서 조건에 맞는 자동차 리스트 구하기'
SELECT C.CAR_ID, C.CAR_TYPE,
    FLOOR(30 * C.DAILY_FEE * (100 - P.DISCOUNT_RATE) / 100) AS FEE
FROM CAR_RENTAL_COMPANY_CAR C
JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN P ON C.CAR_TYPE = P.CAR_TYPE
WHERE C.CAR_TYPE IN ('세단', 'SUV')
    AND C.CAR_ID NOT IN (
        SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
        WHERE START_DATE <= '2022-11-30' AND END_DATE >= '2022-11-01'
    )
    AND P.DURATION_TYPE = '30일 이상'
    AND FLOOR(30 * C.DAILY_FEE * (100 - P.DISCOUNT_RATE) / 100) >= 500000
    AND FLOOR(30 * C.DAILY_FEE * (100 - P.DISCOUNT_RATE) / 100) < 2000000
ORDER BY FEE DESC, C.CAR_TYPE, C.CAR_ID DESC;

-- ★ 연습: HOTEL_ROOM 테이블과 HOTEL_RESERVATION 테이블에서
--   ROOM_TYPE이 '디럭스' 또는 '스위트'이고, 2023년 7월 중 예약이 없으며,
--   7일간 숙박 금액(DAILY_PRICE * 7)이 100만원 이상인 객실의
--   ROOM_ID, ROOM_TYPE, 숙박금액(TOTAL_FEE)을 출력하라. TOTAL_FEE 내림차순.
-- 풀이 포인트: NOT IN + 기간 겹침(CHECK_IN <= '2023-07-31' AND CHECK_OUT >= '2023-07-01')
--   + 계산식을 WHERE에 직접 반복 (별칭 사용 불가)


-- [JOIN + GROUP BY + 상수*SUM: 총매출 계산]
-- GROUP BY 키(PRODUCT_ID)에 종속된 PRICE는 그룹 내 동일값 → SUM 바깥에 곱해도 OK
-- YEAR()/MONTH()로 날짜 필터링
-- 문제: 프로그래머스 Lv.4 '5월 식품들의 총매출 조회하기'
SELECT P.PRODUCT_ID, P.PRODUCT_NAME,
    P.PRICE * SUM(O.AMOUNT) AS TOTAL_SALES
FROM FOOD_PRODUCT P
JOIN FOOD_ORDER O ON P.PRODUCT_ID = O.PRODUCT_ID
WHERE YEAR(O.PRODUCE_DATE) = 2022 AND MONTH(O.PRODUCE_DATE) = 5
GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME
ORDER BY TOTAL_SALES DESC, P.PRODUCT_ID;

-- ★ 연습: BOOK 테이블과 BOOK_SALES 테이블에서 2023년 상반기(1~6월)
--   도서별 총매출(PRICE * 판매수량 합)을 구하고, BOOK_ID, TITLE, TOTAL_SALES를 출력하라.
--   TOTAL_SALES 내림차순, 같으면 BOOK_ID 오름차순.
-- 풀이 포인트: PRICE * SUM(QUANTITY) + WHERE YEAR()=2023 AND MONTH() BETWEEN 1 AND 6


-- [RANK() 윈도우 함수 + 인라인 뷰: LIMIT 1 동점 누락 해결]
-- LIMIT 1은 최다 리뷰 작성자가 여러 명일 때 1명만 반환 → RANK()로 동점 전부 추출
-- GROUP BY+COUNT 결과에 RANK() 붙이고, 인라인 뷰로 감싸서 RNK=1 필터
-- 문제: 프로그래머스 Lv.4 '그룹별 조건에 맞는 식당 목록 출력하기'

-- ▼ 개선 전 (LIMIT 1 — 동점자 누락 위험)
-- SELECT M.MEMBER_NAME, R.REVIEW_TEXT,
--     DATE_FORMAT(R.REVIEW_DATE, '%Y-%m-%d') AS REVIEW_DATE
-- FROM MEMBER_PROFILE M
-- JOIN REST_REVIEW R ON M.MEMBER_ID = R.MEMBER_ID
-- WHERE M.MEMBER_ID = (
--     SELECT MEMBER_ID FROM REST_REVIEW
--     GROUP BY MEMBER_ID ORDER BY COUNT(*) DESC LIMIT 1
-- )
-- ORDER BY R.REVIEW_DATE, R.REVIEW_TEXT;

-- ▼ 개선 후 (RANK — 동점 안전)
SELECT M.MEMBER_NAME, R.REVIEW_TEXT,
    DATE_FORMAT(R.REVIEW_DATE, '%Y-%m-%d') AS REVIEW_DATE
FROM MEMBER_PROFILE M
JOIN REST_REVIEW R ON M.MEMBER_ID = R.MEMBER_ID
WHERE M.MEMBER_ID IN (
    SELECT MEMBER_ID FROM (
        SELECT MEMBER_ID,
            RANK() OVER (ORDER BY COUNT(*) DESC) AS RNK
        FROM REST_REVIEW
        GROUP BY MEMBER_ID
    ) T
    WHERE RNK = 1
)
ORDER BY R.REVIEW_DATE, R.REVIEW_TEXT;

-- ★ 연습: ORDER_DETAIL 테이블과 CUSTOMER 테이블에서 주문 건수가 가장 많은
--   고객(동점 포함)의 CUSTOMER_ID, NAME, 전체 주문 목록(ORDER_ID, ORDER_DATE)을
--   출력하라. ORDER_DATE 오름차순.
-- 풀이 포인트: RANK() OVER (ORDER BY COUNT(*) DESC) + 인라인 뷰 WHERE RNK=1


-- [비트 연산 JOIN + DISTINCT: 1:N JOIN 중복 제거]
-- 비트 AND로 스킬 매칭 시, 한 개발자가 여러 Front End 스킬 보유 → JOIN 결과 중복
-- SELECT에 스킬 컬럼이 없으므로 동일 행 발생 → DISTINCT로 제거
-- 문제: 프로그래머스 Lv.2 '프론트엔드 개발자 찾기'
SELECT DISTINCT D.ID, D.EMAIL, D.FIRST_NAME, D.LAST_NAME
FROM DEVELOPERS D
JOIN SKILLCODES S ON D.SKILL_CODE & S.CODE > 0
WHERE S.CATEGORY = 'Front End'
ORDER BY D.ID;

-- ★ 연습: STUDENT 테이블과 COURSE_ENROLLMENT 테이블에서
--   '수학' 카테고리 과목을 하나라도 수강 중인 학생의 ID, NAME을 출력하라. ID 오름차순.
--   (한 학생이 수학 과목 여러 개 수강 가능 → 중복 주의)
-- 풀이 포인트: JOIN 후 SELECT DISTINCT — 또는 WHERE ID IN (서브쿼리)로 우회 가능


-- [DISTINCT + JOIN: 조건 매칭 후 ID만 추출]
-- 한 차량이 10월에 여러 번 대여 → JOIN 결과 중복 → DISTINCT
-- 문제: 프로그래머스 Lv.1 '자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기' 계열
SELECT DISTINCT C.CAR_ID
FROM CAR_RENTAL_COMPANY_CAR C
JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY H ON C.CAR_ID = H.CAR_ID
WHERE C.CAR_TYPE = '세단' AND MONTH(H.START_DATE) = 10
ORDER BY C.CAR_ID DESC;

-- ★ 연습: 위 쿼리를 JOIN 없이 서브쿼리(IN)로 다시 작성해보라.
-- 풀이 포인트: WHERE CAR_TYPE='세단' AND CAR_ID IN (SELECT CAR_ID FROM ...HISTORY WHERE MONTH(...)=10)


-- [CASE WHEN + LIKE: 문자열 패턴으로 분류]
-- LIKE는 패턴 하나만 비교 가능 → 여러 패턴은 OR로 각각
-- ❌ LIKE ('%Neutered%', '%Spayed%')  ← IN 처럼 묶을 수 없음
-- ✅ LIKE '%Neutered%' OR col LIKE '%Spayed%'
-- 문제: 프로그래머스 Lv.2 '중성화 여부 파악하기'
SELECT ANIMAL_ID, NAME,
    CASE
        WHEN SEX_UPON_INTAKE LIKE '%Neutered%'
          OR SEX_UPON_INTAKE LIKE '%Spayed%' THEN 'O'
        ELSE 'X'
    END AS 중성화
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;

-- ★ 연습: PRODUCT 테이블에서 NAME에 '프리미엄' 또는 '리미티드'가 포함되면 '한정판',
--   아니면 '일반'으로 분류하여 PRODUCT_ID, NAME, TYPE을 출력하라. ID 오름차순.
-- 풀이 포인트: CASE WHEN NAME LIKE '%프리미엄%' OR NAME LIKE '%리미티드%' THEN ...


-- [RANK vs ROW_NUMBER + 인라인 뷰: 상위 N건 추출]
-- RANK(): 동점이면 같은 순위 → RNK<=2가 3건 이상 반환 가능
-- ROW_NUMBER(): 동점이어도 순번 1,2,3... → 정확히 N건 보장
-- "두 마리"처럼 정확한 건수가 필요하면 ROW_NUMBER가 안전
-- 날짜 차이: O.DATETIME - I.DATETIME → 보호 기간 계산 (큰 값 = 오래 보호)
-- 문제: 프로그래머스 Lv.3 '오랜 기간 보호한 동물(2)'
SELECT ANIMAL_ID, NAME FROM (
    SELECT I.ANIMAL_ID, I.NAME,
        RANK() OVER (ORDER BY O.DATETIME - I.DATETIME DESC) AS RNK
    FROM ANIMAL_INS I
    JOIN ANIMAL_OUTS O ON I.ANIMAL_ID = O.ANIMAL_ID
) T
WHERE RNK <= 2;

-- ★ 연습: 위 쿼리에서 RANK()를 ROW_NUMBER()로 바꿔보라.
--   동점 동물이 있을 때 결과가 어떻게 달라지는지 생각해보라.
-- 풀이 포인트: RANK — 동점 전부(2건 이상 가능) / ROW_NUMBER — 정확히 N건


-- [LEFT + GROUP BY: 코드 앞자리별 그룹화]
-- LEFT(str, N)으로 문자열 앞부분 추출 → GROUP BY에 바로 사용 가능
-- 문제: 프로그래머스 Lv.2 '카테고리 별 상품 개수 구하기'
SELECT LEFT(PRODUCT_CODE, 2) AS CATEGORY, COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY LEFT(PRODUCT_CODE, 2)
ORDER BY CATEGORY;

-- ★ 연습: LOG 테이블에서 ERROR_CODE(예: 'ERR-404-001')의 앞 7자리(예: 'ERR-404')별
--   발생 건수를 구하고, CODE_GROUP, CNT를 출력하라. CNT 내림차순.
-- 풀이 포인트: LEFT(ERROR_CODE, 7) 또는 SUBSTR(ERROR_CODE, 1, 7) + GROUP BY


-- [CONCAT + SUBSTR 조합: 문자열 포맷팅 + HAVING 건수 필터]
-- LEFT/SUBSTR/RIGHT로 전화번호를 xxx-xxxx-xxxx 형태로 변환
-- CONCAT으로 주소 컬럼 여러 개를 공백과 합쳐 전체주소 생성
-- GROUP BY + HAVING COUNT(*) >= N 으로 게시물 N건 이상 사용자 필터
-- 문제: 프로그래머스 Lv.3 '조건에 맞는 사용자 정보 조회하기'
SELECT U.USER_ID, U.NICKNAME,
    CONCAT(U.CITY, ' ', U.STREET_ADDRESS1, ' ', U.STREET_ADDRESS2) AS 전체주소,
    CONCAT(LEFT(U.TLNO, 3), '-', SUBSTR(TLNO, 4, 4), '-', RIGHT(TLNO, 4)) AS 전화번호
FROM USED_GOODS_BOARD B
JOIN USED_GOODS_USER U ON B.WRITER_ID = U.USER_ID
GROUP BY U.USER_ID, U.NICKNAME
HAVING COUNT(*) >= 3
ORDER BY U.USER_ID DESC;

-- ★ 연습: MEMBER 테이블에서 주민번호(JUMIN, 13자리 숫자)를
--   'XXXXXX-XXXXXXX' 형태로 포맷팅하여 NAME, JUMIN_FMT를 출력하라.
-- 풀이 포인트: CONCAT(LEFT(JUMIN, 6), '-', SUBSTR(JUMIN, 7, 7))
--   (SUBSTR의 pos는 1부터 시작!)


-- [DATEDIFF + CASE WHEN: 날짜 차이로 분류]
-- DATEDIFF(END, START) = 끝-시작 → 양 끝 포함 일수는 +1
-- "30일 이상" → DATEDIFF >= 29 (경계값 주의!)
-- 문제: 프로그래머스 Lv.1 '자동차 대여 기록에서 장기/단기 대여 구분하기'
SELECT HISTORY_ID, CAR_ID,
    DATE_FORMAT(START_DATE, '%Y-%m-%d') AS START_DATE,
    DATE_FORMAT(END_DATE, '%Y-%m-%d') AS END_DATE,
    CASE
        WHEN DATEDIFF(END_DATE, START_DATE) >= 29 THEN '장기 대여'
        ELSE '단기 대여'
    END AS RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE YEAR(START_DATE) = 2022 AND MONTH(START_DATE) = 9
ORDER BY HISTORY_ID DESC;

-- ★ 연습: SUBSCRIPTION 테이블에서 가입일(JOIN_DATE)과 해지일(CANCEL_DATE) 차이가
--   365일 이상이면 '장기회원', 아니면 '단기회원'으로 분류하여
--   USER_ID, MEMBER_TYPE을 출력하라. (양 끝 포함 기준)
-- 풀이 포인트: DATEDIFF(CANCEL_DATE, JOIN_DATE) >= 364


-- [LEFT JOIN + CASE ON + IFNULL: 구간별 동적 할인율 매칭]
-- 핵심: ON 절에 CASE를 넣어 대여일수에 따라 할인 구간을 동적으로 매칭
-- LEFT JOIN인 이유: 7일 미만은 할인 없음 → CASE가 NULL 반환 → 매칭 실패 → NULL
-- IFNULL(DISCOUNT_RATE, 0): 매칭 실패(할인 없음)일 때 0%로 처리
-- DATEDIFF+1: 양 끝 포함 대여일수 (이전 문제에서 학습)
-- 문제: 프로그래머스 Lv.4 '자동차 대여 기록 별 대여 금액 구하기'
SELECT H.HISTORY_ID,
    FLOOR((DATEDIFF(H.END_DATE, H.START_DATE) + 1) * C.DAILY_FEE
        * (100 - IFNULL(P.DISCOUNT_RATE, 0)) / 100) AS FEE
FROM CAR_RENTAL_COMPANY_CAR C
JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY H ON C.CAR_ID = H.CAR_ID
LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN P ON C.CAR_TYPE = P.CAR_TYPE
    AND P.DURATION_TYPE = CASE
        WHEN DATEDIFF(H.END_DATE, H.START_DATE) + 1 >= 90 THEN '90일 이상'
        WHEN DATEDIFF(H.END_DATE, H.START_DATE) + 1 >= 30 THEN '30일 이상'
        WHEN DATEDIFF(H.END_DATE, H.START_DATE) + 1 >= 7  THEN '7일 이상'
    END
WHERE C.CAR_TYPE = '트럭'
ORDER BY FEE DESC, HISTORY_ID DESC;

-- ★ 연습: PRODUCT 테이블과 DISCOUNT_POLICY 테이블에서 상품 가격에 따라
--   할인율을 동적 매칭하라 (10만 이상 → 'A등급', 5만 이상 → 'B등급', 그 외 할인 없음).
--   PRODUCT_ID, FLOOR(PRICE * (100-할인율)/100) AS FINAL_PRICE 출력. FINAL_PRICE DESC.
-- 풀이 포인트: LEFT JOIN + ON CASE WHEN PRICE>=100000 THEN 'A등급' ... END
--   + IFNULL(DISCOUNT_RATE, 0)


-- [다중 JOIN + DATE(): DATETIME 컬럼 날짜 비교]
-- DATETIME 컬럼('2022-04-13 09:30:00')을 날짜만으로 비교 → DATE() 필수
-- 3개 테이블 JOIN: APPOINTMENT ↔ PATIENT(환자명), APPOINTMENT ↔ DOCTOR(의사명)
-- 문제: 프로그래머스 Lv.1 '진료과별 예약 내역 조회하기' 계열
SELECT A.APNT_NO, P.PT_NAME, P.PT_NO, D.MCDP_CD, D.DR_NAME, A.APNT_YMD
FROM APPOINTMENT A
JOIN PATIENT P ON A.PT_NO = P.PT_NO
JOIN DOCTOR D ON A.MDDR_ID = D.DR_ID
WHERE A.MCDP_CD = 'CS'
    AND A.APNT_CNCL_YN = 'N'
    AND DATE(A.APNT_YMD) = '2022-04-13'
ORDER BY A.APNT_YMD;

-- ★ 연습: EVENT 테이블에서 EVENT_DATETIME(DATETIME 타입)이 2023년 12월 25일인
--   행의 EVENT_ID, EVENT_NAME을 출력하라. EVENT_DATETIME 오름차순.
-- 풀이 포인트: WHERE DATE(EVENT_DATETIME) = '2023-12-25'
--   (DATE() 없이 비교하면 시간 부분 때문에 매칭 실패!)


-- [인라인 뷰 + CASE + GROUP BY: 구간 분류 후 집계]
-- 인라인 뷰에서 CASE로 분기 변환 → 바깥에서 GROUP BY (CASE를 1번만 작성)
-- 서브쿼리 없이도 가능하지만, CASE가 복잡할수록 인라인 뷰가 깔끔
-- 문제: 프로그래머스 Lv.2 '분기별 분화된 대장균의 개체 수 구하기'

-- ▼ 인라인 뷰 방식 (CASE 1번만 작성 — 깔끔)
SELECT QUARTER, COUNT(*) AS ECOLI_COUNT FROM (
    SELECT CASE
        WHEN MONTH(DIFFERENTIATION_DATE) <= 3 THEN '1Q'
        WHEN MONTH(DIFFERENTIATION_DATE) <= 6 THEN '2Q'
        WHEN MONTH(DIFFERENTIATION_DATE) <= 9 THEN '3Q'
        ELSE '4Q'
    END AS QUARTER
    FROM ECOLI_DATA
) T
GROUP BY QUARTER
ORDER BY QUARTER;

-- ▼ 서브쿼리 없는 방식 (CASE를 SELECT + GROUP BY에 반복)
-- SELECT CASE WHEN MONTH(...) <= 3 THEN '1Q' ... END AS QUARTER, COUNT(*)
-- FROM ECOLI_DATA
-- GROUP BY CASE WHEN MONTH(...) <= 3 THEN '1Q' ... END
-- ORDER BY QUARTER;

-- ★ 연습: SALES 테이블에서 AMOUNT 기준으로
--   1만 미만 → '소액', 1만~10만 → '중액', 10만 이상 → '고액' 분류 후
--   각 구간별 건수(CNT)를 출력하라. 두 가지 방식(인라인 뷰 / 직접 반복)으로 풀어보라.
-- 풀이 포인트: 인라인 뷰 → CASE 1번 / 직접 → SELECT와 GROUP BY에 동일 CASE 반복
