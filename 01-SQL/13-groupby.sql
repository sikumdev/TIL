-- 13-groupby.sql

SELECT * FROM sales;

-- 카테고라이징 -> 중복된 값을 묶는 것 

SELECT region, category, COUNT(*) FROM sales
GROUP BY region, category
ORDER BY region, category;


-- 각 지역별 카테고리별 매출 평균

SELECT region, category, COUNT(*), ROUND(AVG(total_amount),2) AS 매출평균
FROM sales
GROUP BY region,category
ORDER BY region, category;

-- 각 지역별 어떤 카테고리가 가장 매출이 큰지 top3 뽑기

SELECT region, category, COUNT(*), ROUND(AVG(total_amount),2) AS 평균매출
FROM sales
GROUP BY region,category
ORDER BY 평균매출 DESC LIMIT 3;

-- 카테고리별 분석
-- 카테고리, 주문건수, 총매출, 평균 매출 -> 총매출 내림차순으로 확인해보기

SELECT 	category, COUNT(*) AS 주문건수, SUM(total_amount) AS 총매출, 
		ROUND(AVG(total_amount),0) AS 평균매출
FROM sales
GROUP BY category
ORDER BY 총매출 DESC;

-- 지역별 매출 분석
-- 지역, 주문건수, 총매출, 고객수, 고객당주문수, 고객당평균매출

SELECT 	region AS 지역, COUNT(*) AS 주문건수, SUM(total_amount) AS 총매출,
		COUNT(DISTINCT(customer_id)) AS 고객수, 
		-- 정수 / 정수 -> 정수 BUT 실수 / 정수 -> 실수   결론 -> 둘중 하나만 실수로 바꿔주면 댐
		ROUND(COUNT(*)::DECIMAL/COUNT(DISTINCT(customer_id)),1) AS 고객당주문수,
		ROUND(SUM(total_amount)::DECIMAL/ COUNT(DISTINCT(customer_id)),1) AS 고객당평균매출
FROM sales
GROUP BY region;


-- 다중 그룹핑
-- 영업 사원별(sales_rep)-지역별 (region) 성과 확인
-- 영업사원, 지역, 주문건수, 총매출액

SELECT 	sales_rep AS 영업사원, region AS 지역 , COUNT(*) AS 주문건수,
		SUM(total_amount) AS 총매출액
FROM sales
GROUP BY sales_rep, region
ORDER BY 총매출액 DESC;


-- 영업사원별-월별 매출 분석
-- 월, 사원, 주문건수, 월매출액, 평균매출액
-- 월, 월매출액 순으로 정렬
-- 조회 시 month라는 가상의 컬럼을 만들고 -> TO_CHAR(order_date, 'YYYY-MM')
-- 힌트 SELECT TO_CHAR(order_date, 'YYYY-MM') FROM sales;

SELECT	TO_CHAR(order_date, 'YYYY-MM') AS month,
		sales_rep AS 사원,
		COUNT(*) AS 주문건수,
		SUM(total_amount) AS 월매출액,
		ROUND(AVG(total_amount),0) AS 평균매출액,
		COUNT(DISTINCT(customer_id)) AS MAU
FROM sales
GROUP BY sales_rep,TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month, 월매출액 DESC;


-- MAU(Monthly Active User) -> 월간 활성 고객
-- 월 주문건수, 월매출액, MAU
SELECT TO_CHAR(order_date, 'yyyy-mm') AS 월,
		COUNT(*) 주문건수,
		SUM(total_amount) AS 월매출액,
		COUNT(DISTINCT(customer_id)) AS MAU
FROM sales
GROUP BY TO_CHAR(order_date, 'yyyy-mm')
ORDER BY 월



-- 추가 요일별 매출 패턴 (날짜 -> 요일 함수)
-- 요일, 주문건수, 총매출, 평균매출
-- 힌트 TO_CHAR(YOUR_DATE_COLUMN, 'Day') 혹은 EXTRACT(DOW FROM order_date) 0(일) ~ 6(토)

SELECT 	TO_CHAR(order_date, 'Day') AS 요일, 
		COUNT(*) AS 주문건수,
		SUM(total_amount)  AS 총매출, 
		ROUND(AVG(total_amount)) AS 평균매출
FROM sales
GROUP BY TO_CHAR(order_date, 'Day')
ORDER BY 총매출 DESC;




SELECT * FROM sales;





