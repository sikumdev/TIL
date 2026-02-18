-- 18-join-group.sql

-- VIP 고객들의 구매 내역 조회

SELECT *
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type='VIP';


-- 각 등급별 구매액 평균

SELECT c.customer_type AS 고객등급, COUNT(*) AS 고객수, ROUND(AVG(s.total_amount),2) AS 평균구매액
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;



-- [모든 고객]의 고객 별 구매 현황 분석
-- 고객 이름, 고객 등급, 주문 횟수, 총구매액(없으면 0), 평균주문액(없으면 0.0), 최근 주문일 (없으면 '주문없음')
-- COALESCE(A,B) -> A가 NULL이 아니면 그대로 쓰고 A가 NULL이면 B
-- COALESCE(MAX(order_date),'주문없음') -> 오류 why? -> COALESCE (A,B) A랑 B는 자료형이 같아야함

-- 1. 내가 짠 코드
SELECT 	c.customer_id, c.customer_name, c.customer_type, 
		COUNT(s.id) AS 주문횟수, COALESCE(SUM(s.total_amount),0) AS 총구매액,
		COALESCE(ROUND(AVG(s.total_amount),1), 0.0) AS 평균구매액,
		COALESCE(TO_CHAR(MAX(order_date), 'YYYY-MM-DD'), '주문없음') AS 최근주문일
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;


-- 집계 함수가 아닌 일반컬럼은 GROUP BY에 다쓴다 요런식으로 생각해주면 될 것 같음
-- COUNT(*) -> 안되는 이유는 조인했을 때 NULL 값으로 합쳐진 행이 카운트 됨!
-- SELECT * FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id; <- 확인 해보면 댐

-- 2. 강사님 코드
SELECT 	c.customer_id, c.customer_name, c.customer_type, 
		COUNT(s.id) AS 주문횟수, COALESCE(SUM(s.total_amount),0) AS 총구매액,
		COALESCE(ROUND(AVG(s.total_amount),1), 0.0) AS 평균구매액,
		COALESCE(TO_CHAR(MAX(order_date), 'YYYY-MM-DD'), '주문없음') AS 최근주문일
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY c.customer_id;


-- COALESCE() 대신 CASE END 사용도 가능하나 가독성 생각하면 COALESCE가 더 좋음
-- 3. 이런 방법도 있음
SELECT 	c.customer_id, c.customer_name, c.customer_type, 
	/*	CASE
			WHEN SUM(total_amount) IS NULL THEN 0
			ELSE SUM(total_amount)
		END   */
		COUNT(s.id) AS 주문횟수, COALESCE(SUM(s.total_amount),0) AS 총구매액,
		COALESCE(ROUND(AVG(s.total_amount),1), 0.0) AS 평균구매액,
		COALESCE(TO_CHAR(MAX(order_date), 'YYYY-MM-DD'), '주문없음') AS 최근주문일
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY c.customer_id;


-- 고객 분석 
-- 주문횟수 F / 최근주문일 R / 총구매액 M

SELECT 	c.customer_id, c.customer_name, c.customer_type, 
		COUNT(s.id) AS 주문횟수, COALESCE(SUM(s.total_amount),0) AS 총구매액,
		COALESCE(ROUND(AVG(s.total_amount),1), 0.0) AS 평균구매액,
		COALESCE(TO_CHAR(MAX(order_date), 'YYYY-MM-DD'), '주문없음') AS 최근주문일,
		CASE
			WHEN COUNT(s.id)=0 THEN '잠재고객'
			WHEN COUNT(s.id)>=5 THEN '충성고객'
			WHEN COUNT(s.id)>=2 THEN '일반고객'
			ELSE '신규고객'
		END AS 고객분류
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY c.customer_id;





SELECT * FROM sales;
SELECT * FROM customers;