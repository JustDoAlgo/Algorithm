/* ============================================================
   SQL 복습 문제집
   - 기본개념.sql의 연습문제를 개념별·난이도순으로 정리
   - 힌트는 기본개념.sql 참고
   ============================================================ */


-- ============================================================
-- [1] 기본 조회 + 정렬 + 제한
-- ============================================================

-- Q1. EMPLOYEE 테이블에서 DEPARTMENT='Engineering'인 사원들의
--     평균 SALARY를 소수 첫째 자리에서 반올림하여 AVG_SALARY로 출력하라.

SELECT ROUND(AVG(SALARY), 0) AS AVG_SALARY FROM EMPLOYEE
WHERE DEPARTMENT='Engineering'

-- Q2. STUDENT 테이블에서 GRADE 내림차순, 같은 GRADE면 NAME 오름차순으로 출력하라.

SELECT * FROM STUDENT
ORDER BY GRADE DESC, NAME

-- Q3. SCORE 테이블에서 점수가 가장 높은 상위 5명의
--     STUDENT_ID, SCORE를 출력하라. 같은 점수면 STUDENT_ID 오름차순.

SELECT STUDENT_ID, SCORE FROM SCORE
ORDER BY SCORE DESC, STUDENT_ID ASC
LIMIT 5

-- ============================================================
-- [2] 집계 함수 + GROUP BY + HAVING
-- ============================================================

-- Q4. ORDER_LOG 테이블에서 같은 CUSTOMER_ID, ITEM_ID 조합이 3번 이상 등장하는
--     것만 출력하라. CUSTOMER_ID 오름차순 정렬.

SELECT CUSTOMER_ID, ITEM_ID FROM ORDER_LOG
GROUP BY CUSTOMER_ID, ITEM_ID
HAVING COUNT(*) >= 3
ORDER BY CUSTOMER_ID ASC

-- Q5. ORDER_LOG 테이블에서 주문한 적 있는 고유 CUSTOMER_ID의 수를 구하라.

SELECT COUNT(DISTINCT CUSTOMER_ID) FROM ORDER_LOG

-- Q6. PRODUCT 테이블에서 CATEGORY별 상품 수를 구하되,
--     CATEGORY가 NULL인 행은 제외하고, 상품이 5개 이상인 카테고리만 출력하라.
--     결과는 상품 수 내림차순 정렬.

SELECT CATEGORY, COUNT(*) FROM PRODUCT
WHERE CATEGORY IS NOT NULL
GROUP BY CATEGORY
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC

-- Q7. EMPLOYEE 테이블에서 SALARY를 100만원 단위로 묶어
--     구간별 사원 수를 구하라. 결과: SALARY_GROUP, EMP_COUNT. 구간 오름차순.

SELECT FLOOR(SALARY / 1000000) * 1000000 AS SALARY_GROUP, COUNT(*) AS EMP_COUNT FROM EMPLOYEE
GROUP BY FLOOR(SALARY / 1000000) * 1000000
ORDER BY FLOOR(SALARY / 1000000) * 1000000

-- ============================================================
-- [3] NULL 처리 + 조건 분기
-- ============================================================

-- Q8. MEMBER 테이블에서 NAME, EMAIL을 출력하되,
--     EMAIL이 NULL이면 '미등록'으로 표시하라. NAME 오름차순.

SELECT NAME, IFNULL(EMAIL, '미등록') FROM MEMBER
ORDER BY NAME ASC

-- Q9. MEMBER 테이블에서 NAME, PHONE을 출력하되,
--     PHONE이 NULL이면 '번호없음'으로 표시하라. NAME 오름차순.
--     IFNULL 방식과 CASE WHEN 방식 두 가지로 풀어보라.

SELECT NAME, IFNULL(PHONE, '번호없음') FROM MEMBER
ORDER BY NAME

SELECT NAME, CASE
   WHEN PHONE IS NULL THEN '번호없음'
   ELSE PHONE
END AS PHONE FROM MEMBER
ORDER BY NAME

-- Q10. STUDENT 테이블에서 SCORE가 90 이상이면 'A',
--      80 이상이면 'B', 70 이상이면 'C', 나머지는 'F'로 GRADE 컬럼을 만들어 출력하라.

SELECT CASE
   WHEN SCORE >= 90 THEN 'A'
   WHEN SCORE >= 80 THEN 'B'
   WHEN SCORE >= 70 THEN 'C'
   ELSE 'F'
END AS GRADE FROM STUDENT

-- ============================================================
-- [4] 날짜 + 문자열 함수
-- ============================================================

-- Q11. EVENT 테이블에서 2023년에 열린 CATEGORY='음악' 이벤트의
--      EVENT_ID와 EVENT_DATE를 'YYYY-MM-DD' 형식으로 출력하라. 날짜 오름차순.

SELECT EVENT_ID, DATE_FORMAT(EVENT_DATE, '%Y-%m-%d') AS EVENT_DATE FROM EVENT
WHERE CATEGORY='음악' AND YEAR(EVENT_DATE)=2023
ORDER BY EVENT_DATE ASC

-- Q12. EMPLOYEE 테이블에서 NAME과 DEPARTMENT를 합쳐
--      'NAME (DEPARTMENT)' 형식으로 INFO 컬럼을 만들어 출력하라.

SELECT CONCAT(NAME, ' (', DEPARTMENT, ')') AS INFO FROM EMPLOYEE

-- Q13. DELIVERY 테이블에서 REGION별 총 배송거리에 'm'을 붙여 출력하되,
--      총 배송거리(숫자) 기준 내림차순 정렬하라. 소수 첫째자리 반올림.

SELECT REGION, CONCAT(ROUND(SUM(배송거리), 0), 'm') FROM DELIVERY
GROUP BY REGION
ORDER BY SUM(배송거리) DESC

-- ============================================================
-- [5] LIKE + IN + BETWEEN
-- ============================================================

-- Q14. STORE 테이블에서 STORE_NAME에 '카페'가 포함된 매장의
--      STORE_ID, STORE_NAME을 출력하라. STORE_ID 오름차순.

SELECT STORE_ID, STORE_NAME FROM STORE
WHERE STORE_NAME LIKE '%카페%'
ORDER BY STORE_ID ASC

-- Q15. BOOK 테이블에서 GENRE가 'SF', '판타지', '미스터리' 중 하나인
--      책의 총 개수를 구하라.

SELECT COUNT(*) FROM BOOK
WHERE GENRE IN ('SF', '판타지', '미스터리')

-- Q16. RESERVATION 테이블에서 2023년에 예약되었고,
--      PRICE가 50000~100000 사이인 예약 건수를 구하라.

SELECT COUNT(*) FROM RESERVATION
WHERE YEAR(DATE)=2023 AND PRICE BETWEEN 50000 AND 100000

-- Q17. PRODUCT 테이블의 TAGS 컬럼('무선,블루투스,방수' 형태)에서
--      '블루투스' 또는 '방수'가 포함된 상품의 CATEGORY별 개수를 구하라.
--      CATEGORY 오름차순 정렬.

SELECT CATEGORY, COUNT(*) FROM PRODUCT
WHERE TAGS LIKE '%블루투스%' OR TAGS LIKE '%방수%'
GROUP BY CATEGORY
ORDER BY CATEGORY ASC

-- ============================================================
-- [6] JOIN
-- ============================================================

-- Q18. ORDER_DETAIL과 PRODUCT 테이블을 PRODUCT_ID로 JOIN하여,
--      PRODUCT.CATEGORY='전자기기'이고 ORDER_DETAIL.QUANTITY>=10인
--      PRODUCT_NAME을 QUANTITY 내림차순으로 출력하라.

SELECT P.PRODUCT_NAME FROM ORDER_DETAIL O
JOIN PRODUCT P ON O.PRODUCT_ID=P.PRODUCT_ID
WHERE P.CATEGORY='전자기기' AND O.QUANTITY>=10
ORDER BY O.QUANTITY DESC

-- Q19. COURSE와 COURSE_REVIEW를 COURSE_ID로 JOIN하여,
--      COURSE.CATEGORY='프로그래밍'인 강좌별 평균 RATING을 소수 둘째자리까지 구하라.
--      평균 RATING 내림차순 정렬.

SELECT C.COURSE_ID, ROUND(AVG(R.RATING),2) FROM COURSE C
JOIN COURSE_REVIEW R ON C.COURSE_ID=R.COURSE_ID
WHERE C.CATEGORY='프로그래밍'
GROUP BY C.COURSE_ID
ORDER BY AVG(R.RATING) DESC

-- Q20. TEACHER 테이블과 CLASS 테이블을 TEACHER_ID로 LEFT JOIN하여,
--      각 선생님이 담당하는 수업 수를 구하라. 수업이 없는 선생님도 0으로 표시.
--      TEACHER_ID 오름차순.

SELECT T.TEACHER_ID, COUNT(C.CLASS_ID) FROM TEACHER T
LEFT JOIN CLASS C ON T.TEACHER_ID=C.TEACHER_ID
GROUP BY T.TEACHER_ID
ORDER BY T.TEACHER_ID

-- Q21. EMPLOYEE 테이블(ID, NAME, MANAGER_ID)에서
--      매니저의 NAME이 '김철수'인 부하직원의 ID, NAME을 출력하라.

SELECT E.ID, E.NAME FROM EMPLOYEE E
JOIN EMPLOYEE M ON E.MANAGER_ID=M.ID
WHERE M.NAME='김철수'

-- Q22. STORE와 EMPLOYEE를 STORE_ID로 JOIN하여,
--      매장별 평균 SALARY를 소수점 첫째 자리에서 반올림하여 구하라.
--      STORE_ID, STORE_NAME, AVG_SALARY. 평균 연봉 내림차순.

SELECT S.STORE_ID, S.STORE_NAME, ROUND(AVG(E.SALARY),0) FROM STORE S
JOIN EMPLOYEE E ON S.STORE_ID=E.STORE_ID
GROUP BY S.STORE_ID, S.STORE_NAME
ORDER BY AVG(E.SALARY) DESC

-- Q23. STORE, PRODUCT, ORDER_DETAIL을 JOIN하여
--      매장별(STORE_NAME), 카테고리별(CATEGORY) 총 매출(SUM(QUANTITY*PRICE))을 구하라.
--      매출 내림차순 정렬.

SELECT S.STORE_NAME, P.CATEGORY, SUM(O.QUANTITY*P.PRICE) FROM STORE S
JOIN PRODUCT P ON S.ID=P.ID
JOIN ORDER_DETAIL O ON P.ID=O.ID
GROUP BY S.STORE_NAME, P.CATEGORY
ORDER BY SUM(O.QUANTITY*P.PRICE) DESC

-- Q24. ENROLLMENT과 STUDENT를 STUDENT_ID로 JOIN하여,
--      년도, 학기, STUDENT.MAJOR별로 수강한 고유 학생 수를 구하라.
--      MAJOR가 NULL인 경우 제외. 년도, 학기, MAJOR 오름차순 정렬.

SELECT E.년도, E.학기, S.MAJOR, COUNT(DISTINCT S.STUDENT_ID) FROM ENROLLMENT E
JOIN STUDENT S ON E.STUDENT_ID=S.STUDENT_ID
WHERE S.MAJOR IS NOT NULL
GROUP BY E.년도, E.학기, S.MAJOR
ORDER BY E.년도, E.학기, S.MAJOR

-- ============================================================
-- [7] 서브쿼리
-- ============================================================

-- Q25. PRODUCT 테이블에서 가장 비싼 상품의 NAME을 출력하라.
--      NOT EXISTS 방식과 ORDER BY + LIMIT 방식 두 가지로 풀어보라.

SELECT NAME FROM PRODUCT
ORDER BY PRICE DESC
LIMIT 1

-- Q26. EMPLOYEE 테이블에서 SALARY가 가장 높은 사원의 전체 정보를 출력하라.
--      서브쿼리 방식과 LIMIT 방식 두 가지로 풀어보라.



-- Q27. STUDENT 테이블에서 각 CLASS별로 SCORE가 가장 높은 학생의
--      ID, NAME, CLASS, SCORE를 출력하라. ID 오름차순.



-- Q28. EMPLOYEE 테이블에서 각 DEPARTMENT별로 SALARY가 가장 높은 사원의
--      DEPARTMENT, SALARY, NAME을 출력하라. SALARY 내림차순.



-- Q29. EMPLOYEE 테이블에서 누구의 매니저도 아닌 사원(MANAGER_ID로 참조되지 않는)의
--      ID, NAME을 출력하라. ID 오름차순.



-- ============================================================
-- [8] WHERE + GROUP BY + HAVING 복합
-- ============================================================

-- Q30. ORDER_LOG와 CUSTOMER를 JOIN하여, 2023년 주문 중
--      고객별 총 주문금액(SUM(AMOUNT))이 100만원 이상인 고객의
--      CUSTOMER_ID, NAME, 총 주문금액을 구하라. 총 주문금액 내림차순.



-- Q31. ENROLLMENT 테이블에서 2023년 1~2학기 동안 총 수강 과목이 6개 이상인
--      학생에 대해, 해당 기간의 학기별·학생별 수강 과목 수를 구하라.
--      학기 오름차순, 같으면 STUDENT_ID 내림차순.



-- Q32. SCORE 테이블에서 과목별(SUBJECT) 평균 점수가 70 이상인 과목을 구하되,
--      SCORE가 NULL인 학생은 0점으로 취급하라.
--      결과: SUBJECT, AVG_SCORE(소수 첫째자리 반올림). 평균 내림차순.



-- ============================================================
-- [9] UNION ALL
-- ============================================================

-- Q33. APP_SALE(컬럼: SALE_DATE, APP_ID, USER_ID, AMOUNT)과
--      STORE_SALE(컬럼: SALE_DATE, APP_ID, AMOUNT — USER_ID 없음)을
--      2023년 1월 데이터만 UNION ALL로 합쳐라. STORE_SALE에는 NULL AS USER_ID.
--      SALE_DATE 오름차순 정렬.



-- ============================================================
-- [10] 윈도우 함수
-- ============================================================

-- Q34. SALES 테이블에서 각 행에 대해 같은 REGION 내 MAX(AMOUNT)와의 차이를
--      REGION_DIFF 컬럼으로 출력하라. ID, REGION, AMOUNT, REGION_DIFF. ID 오름차순.



-- Q35. EMPLOYEE 테이블에서 SALARY 기준으로 상위 25%는 'S',
--      50%까지 'A', 75%까지 'B', 나머지 'C' 등급을 매겨라. ID 오름차순.



-- ============================================================
-- [11] 재귀 CTE
-- ============================================================

-- Q36. CATEGORY 테이블(ID, NAME, PARENT_ID)에서 각 카테고리의 depth를 구하라.
--      PARENT_ID가 NULL이면 depth=1. 결과: ID, NAME, DEPTH. DEPTH 오름차순.



-- Q37. 1월~12월까지 월별 주문 건수를 구하되, 주문이 없는 달도 0으로 출력하라.
--      테이블: ORDERS(ORDER_ID, ORDER_DATE). 결과: MONTH, ORDER_COUNT.



-- ============================================================
-- [12] 인라인 뷰 + 고급 패턴
-- ============================================================

-- Q38. EMPLOYEE_ATTENDANCE 테이블에서 각 사원이 '2023-07-01'에
--      출근 기록이 하나라도 있으면 '출근', 없으면 '결근'으로 표시하라.
--      EMPLOYEE_ID 오름차순.



-- Q39. SALES_LOG 테이블에서 사원별 총 매출(SUM(AMOUNT))을 구하고,
--      총 매출이 가장 높은 사원의 EMP_ID, NAME(EMPLOYEE 테이블), 총 매출을 출력하라.
--      동점자도 전부 출력.



-- Q40. STUDENT와 EXAM(STUDENT_ID, SCORE) 테이블에서 학생별 평균 점수를 구하고,
--      90이상 'A', 80이상 'B', 나머지 'C' 등급과
--      'A'면 장학금 1000000, 'B'면 500000, 'C'면 0을 출력하라.
--      인라인 뷰로 평균을 한 번만 구하고, CASE 2개로 GRADE와 SCHOLARSHIP을 만들 것.



-- ============================================================
-- [13] 비트 연산
-- ============================================================

-- Q41. EMPLOYEES(ID, NAME, PERMISSION_CODE)와 PERMISSIONS(NAME, CODE) 테이블.
--      CODE는 2의 거듭제곱. PERMISSION_CODE는 보유 권한의 비트 합.
--      'READ'와 'WRITE' 권한을 모두 가진 사원의 ID, NAME을 출력하라.
