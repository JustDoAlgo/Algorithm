/* ============================================================
   SQL 개념 정리
   ============================================================

   [기본 조회]
   - SELECT ... FROM ... WHERE         기본 조회 + 조건 필터
   - ORDER BY col ASC|DESC             정렬 (기본 ASC)
   - LIMIT N                           출력 개수 제한

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
     → 다중 테이블 JOIN 후 GROUP BY 시 SUM/COUNT 등으로 감싸야 정확
   - 집계 함수 안에 CASE WHEN을 넣어 값을 변환한 뒤 집계 가능
     → AVG(CASE WHEN 조건 THEN 대체값 ELSE 원래값 END)
     → CASE는 표현식이지 서브쿼리가 아님 — SELECT ... FROM 없이 바로 사용

   [조건 / NULL 처리]
   - BETWEEN a AND b                   범위 조건
   - LIKE '패턴%'                      문자열 패턴 매칭
     → 컬럼 값이 쉼표 구분 문자열일 때 특정 값 포함 여부: LIKE '%값%'
     → 여러 값 중 하나라도 포함: LIKE '%A%' OR LIKE '%B%' OR ...
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
   - DATE_FORMAT(날짜, '%Y-%m-%d')     날짜 포맷 변환
   - YEAR(날짜), MONTH(날짜)           연도/월 추출

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
