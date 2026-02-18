-- 17-join.sql
-- join은 좌우 결합임

SELECT customer_name FROM customers WHERE customer_id = 'C001';


SELECT 	customer_id,
		(SELECT customer_name FROM customers WHERE customer_id = 'C001'),
		(SELECT customer_type FROM customers WHERE customer_id = 'C001')
FROM sales;


-- customer_id가 sales테이블인지 아니면 customers테이블인지 컬럼명을 헷갈려함

SELECT 	*,
		(SELECT customer_name FROM customers WHERE customer_id = customer_id),
		(SELECT customer_type FROM customers WHERE customer_id = customer_id)
FROM sales;


-- customer_id가 sales테이블인지 아니면 customers테이블인지 컬럼명을 헷갈려함 -> 명시해주기 (각각 벡터 서브쿼리)

SELECT 	*,
		(SELECT customer_name FROM customers WHERE customers.customer_id = sales.customer_id),
		(SELECT customer_type FROM customers WHERE customers.customer_id = sales.customer_id)
FROM sales;

-- 근데 명시하는게 너무 길어서 줄이기 시작함
-- 그래서 테이블명 뒤에 alias 같은걸 쓰기 시작함

SELECT 	*,
		(SELECT customer_name FROM customers c WHERE c.customer_id = s.customer_id) AS 고객명,
		(SELECT customer_type FROM customers c WHERE c.customer_id = s.customer_id) AS 고객등급
FROM sales s;


-- JOIN
-- INNER JOIN -> 양쪽 다 매칭되는 데이터 값만 합쳐짐 (교집합)  (왼쪽과 오른쪽에 모두 만족시키는 교집합 데이터)

SELECT *
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id;


SELECT COUNT(*)
FROM sales s INNER JOIN customers c ON c.customer_id = s.customer_id;


SELECT COUNT(*)
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id;



-- LEFT JOIN -> FROM 왼쪽 JOIN 오른쪽 테이블 ON 컬럼 같은 조건 (왼쪽의 모든 데이터 + (있을 경우) 매칭되는 오른쪽 데이터)


-- 데이터 값이 125개가 나옴 즉, 고객 중 5명이 아직 구매한 적이 없음 (sales -> 120 , customers -> 50)

SELECT COUNT(*)
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id;

SELECT *
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id;

-- 회원 중 구매한적이 없는 회원 추출해보기 
SELECT *
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.id IS NULL;


-- 데이터 값이 120개가 나옴 -> INNER JOIN 하고 결과값이 같음

SELECT COUNT(*)
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id;

SELECT *
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id;


-- 

SELECT '1. INNER JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT s.customer_id) AS 고객수
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id;

SELECT '1. INNER JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id;


-- 

SELECT '2. LEFT JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT s.customer_id) AS 고객수
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id;

SELECT '2. LEFT JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT s.customer_id) AS 고객수  -- 총 50명의 고객 데이터는 있지만 sales 테이블에서는 45개만 올라왔다 이렇게 생각
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id;

--
SELECT '2. LEFT JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT c.customer_id) AS 고객수
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id;

SELECT '2. LEFT JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id;


-- UNION -> 상하 결합

SELECT '1. INNER JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id
UNION
SELECT '2. LEFT JOIN' AS 구분,
		COUNT(*) AS 줄수,
		COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id;





SELECT * FROM sales;
SELECT * FROM customers; 