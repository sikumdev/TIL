-- 14-having.sql

/*
SQL 실행 순서
1. FROM
2. WHERE (FROM에 대한 필터)
3. GROUP BY
4. HAVING (GROUP BY에 대한 필터)
5. SELECT <- 여기서 컬럼 alias가 만들어짐 (AS)
6. ORDER BY
*/


-- WHERE total_amount >= 1000000 결과값이 총 21개 인데 처음부터 그 21개 데이터를 가지고 그룹핑을 한 결과임
-- 결론 : WHERE에서 먼저 필터링 한 테이블을 가지고 GROUP BY를 한다

SELECT category, COUNT(*) AS 주문건수, SUM(total_amount) AS 총매출액
FROM sales
WHERE total_amount >= 1000000
GROUP BY category;

-- 원본 데이터에 필터 없이 카테고리 기준으로 그룹핑 조회 결과

SELECT category, COUNT(*) AS 주문건수, SUM(total_amount) AS 총매출액
FROM sales
GROUP BY category;


-- 원본 데이터에 필터 없이 카테고리 기준으로 그룹핑 후 총매출액이 1000만원 이상인 결과를 조회한 결과
-- 즉, GROUP BY로 만들어진 테이블에서 총매출액이 100만원 이상인 결과를 조회한 결과

SELECT category, COUNT(*) AS 주문건수, SUM(total_amount) AS 총매출액
FROM sales
GROUP BY category
HAVING SUM(total_amount) >= POWER(10,7);


-- 원본 데이터에 total_amount 천원 이상인건만 필터링해서 카테고리 기준으로 그룹핑 후 총매출액이 1000만원 이상인 결과를 조회한 결과


SELECT category, COUNT(*) AS 주문건수, SUM(total_amount) AS 총매출액
FROM sales
WHERE total_amount >=1000  -- 전체 원본 테이블에서 먼저 total_amount가 천원 미만인건 필터링해서 없애고 예를 들어 10건이라고 하면
GROUP BY category          -- 전체 - 10건 한 그 데이터를 카테고리로 그룹핑 후
HAVING SUM(total_amount) >= POWER(10,7); -- 그룹핑한 테이블에서 총매출액이 100만원 이상인 결과를 조회한 결과



-- 활성 지역 찾기
-- 지역, 주문건수, 고객수, 총매출액, 평균주문액(고객수 >= 15 AND 전체 주문건수 >= 20)

SELECT 	region AS 지역,
		COUNT(*) AS 주문건수,
		COUNT(DISTINCT(customer_id)) AS 고객수,
		SUM(total_amount) AS 총매출액,
		ROUND(AVG(total_amount),2) AS 평균주문액
FROM sales
GROUP BY region          
HAVING COUNT(DISTINCT(customer_id)) >= 15 AND COUNT(*) >= 20; 



-- 우수 영업사원 => 영업사원 당 달 평균 매출액 50만원 이상인 sales_rep
-- 영업사원, 판매건수, 고객수, 총매출, 활동개월 수, 월평균매출
-- 전체 기간에 대한 월평균인 것 같음

SELECT 	sales_rep AS 영업사원,
		COUNT(*) AS 판매건수,
		COUNT(DISTINCT(customer_id)) AS 고객수,
        SUM(total_amount) AS 총매출액,
		COUNT(DISTINCT TO_CHAR(order_date,'YYYY-MM')) AS 활동개월수,
		ROUND(SUM(total_amount)::DECIMAL/COUNT(DISTINCT TO_CHAR(order_date,'YYYY-MM')),2) AS 월평균매출액
FROM sales
GROUP BY sales_rep
HAVING ROUND(SUM(total_amount)::DECIMAL/COUNT(DISTINCT TO_CHAR(order_date,'YYYY-MM')) ,2) >= 1300000
ORDER BY 월평균매출액 DESC;



SELECT * FROM sales;















