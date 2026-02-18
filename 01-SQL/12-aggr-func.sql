-- 12-aggr-func.sql (집계 함수 -> 가상의 컬럼 보여줌)

SELECT * FROM sales;


-- COUNT (어떤 컬럼명을 쓰든 상관 없기에 보통 * 사용)
SELECT COUNT(id) AS 매출건수 FROM sales;
SELECT COUNT(*) AS 매출건수 FROM sales;

-- DISTINCT (중복 뺴기)

SELECT 	COUNT(*) AS 총주문건수, 
		COUNT(DISTINCT customer_id) AS 고객수,
		COUNT(DISTINCT product_name) AS 상품수 
FROM sales;

-- SUM (합계)

SELECT 	SUM(total_amount) AS 총매출, 
		SUM(quantity) AS 총판매수량,
		TO_CHAR(SUM(total_amount), 'FM999,999,999') || '원' AS 총매출 -- 천단위, 찍기
FROM sales;

-- !! 총매출 데이터 개수는 1개인데 total_amount는 데이터가 여러개여서 불가!!
SELECT SUM(total_amount) AS 총매출, total_amount  
FROM sales;


-- 서울에서 발생한 매출 총합 구하기

SELECT SUM(total_amount) AS 서울총매출,
       TO_CHAR(SUM(total_amount),'FM999,999,999') || '원' AS 서울총매출액,
	   COUNT (*) AS 주문건수
FROM sales
WHERE region ='서울';


-- AVG (평균)
SELECT
	ROUND(AVG(total_amount)) AS 회당평균주문액,
	ROUND(AVG(quantity)) AS 회당평균구매수량,
	ROUND(AVG(unit_price)) AS 평균단가
FROM sales;

-- MIN/MAX (최대/최소)

SELECT
	MIN (total_amount) AS 최소매출액,
	MAX (total_amount) AS 최대매출액,
	MIN (order_date) AS 첫주문일,
	MAX (order_date) AS 마지막주문일
FROM sales;


-- 매출 대시보드 만들기

SELECT
	COUNT(*) AS 주문건수,
	SUM(total_amount) AS 총매출,
	ROUND(AVG(total_amount)) AS 평균매출,
	MIN (total_amount) AS 최소매출액,
	MAX (total_amount) AS 최대매출액,
	ROUND(AVG(quantity),2) AS 평균수량 --ROUND(x,1) -> 소숫점 1자리 반올림
FROM sales;

















