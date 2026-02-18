-- 15-subquery1.sql
-- 단일값 하나가 나오는 스칼라 서브쿼리
-- subquery -> 쿼리 안의 쿼리


-- 금액 500000 보다 더 높은 금액을 주문한 판매데이터(*) 조회

SELECT * FROM sales
WHERE total_amount >= 500000


-- 매출 평균 보다 더 높은 금액을 주문한 판매데이터(*) 조회

-- 1. 평균을 구해서 (결과 612862 )
SELECT AVG(total_amount) FROM sales; 

-- 2. 위의 구한 평균 값으로 WHERE 조건 씀
SELECT * FROM sales
WHERE total_amount >= 612862

-- 3. 불편한점 -> 특정 값을 매번 계산해서 가져와야함

-- 서브 쿼리 사용 시
SELECT * 
FROM sales
WHERE total_amount >= (SELECT AVG(total_amount) FROM sales);


-- 평균 판매액 보다 매출액이 더 큰 상품들 조회
SELECT 	product_name AS 이름,
		total_amount AS 판매액
FROM sales
WHERE total_amount >= (SELECT AVG(total_amount) FROM sales);

-- 평균 판매액 보다 매출액이 더 큰 상품들 + 평균보다 얼마나 더 팔았는지 조회
SELECT 	product_name AS 이름,
		total_amount AS 판매액,
		ROUND(total_amount - (SELECT AVG(total_amount) FROM sales),2) AS 평균차이
FROM sales
WHERE total_amount >= (SELECT AVG(total_amount) FROM sales);

-- sales에서 [가장 비싼 total_amount]를 가진 데이터의 전체 조회하기 
-- 참고) postgreSQL에서는 '==' 대신 '='를 씀

SELECT *
FROM sales
WHERE total_amount = (SELECT MAX(total_amount) FROM sales);

SELECT *
FROM sales
ORDER BY total_amount DESC LIMIT 1;


-- [주문 금액 평균]과 실제 주문액수의 차이가 가장 적은 5개 데이터

SELECT  id,
		order_date,
		total_amount,
		ROUND(ABS(total_amount - (SELECT AVG(total_amount) FROM sales)), 2) AS 평균차이
FROM sales
ORDER BY 평균차이 LIMIT 5;


SELECT * FROM sales;
