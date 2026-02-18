-- p05.sql

-- 주문 거래액이 가장 높은 10건을 높은순으로 [고객명, 상품명, 주문금액]을 보여주자.

SELECT c.customer_id, c.customer_name AS 고객명, s.product_name AS 상품명, s.total_amount AS 주문금액
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.total_amount DESC LIMIT 10;

--2. 고객 유형별 주문 성과 
-- 구매 이력이 있는 고객만을 대상으로,고객 유형별로 주문 건수와 평균 주문금액을 계산하고 평균 주문금액이 높은 순으로 정렬하시오.

SELECT c.customer_type AS 고객등급, COUNT(s.id) AS 주문건수, ROUND(AVG(total_amount),2) AS 평균주문금액
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id
GROUP BY c.customer_type
ORDER BY ROUND(AVG(total_amount),2) DESC;

-- 3. 모든 고객과 구매 상품 조회
-- 모든 고객을 대상으로 각 고객이 구매한 상품명을 조회하시오.구매 이력이 없는 고객의 경우 '없음'으로 표시하시오.
-- GROUP BY 할 필요가 없음 일반 컬럼이 3개라서,,!

SELECT c.customer_id, c.customer_name, COALESCE(s.product_name,'없음') AS 상품명
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id;


-- 4. 고객 + 주문 상세 조회
-- 구매 이력이 있는 모든 고객에 대해 고객 정보와 주문 정보를 함께 조회하시오. 결과는 최근 주문일 순으로 정렬하시오.

SELECT *
FROM customers c INNER JOIN sales s ON c.customer_id = s.customer_id
ORDER BY order_date DESC;

-- 5. VIP 고객 구매 내역
-- 고객 유형이 'VIP' 인 고객들의 구매 상품, 주문 금액, 주문일을 조회하고 주문금액이 큰 순서로 정렬하시오.

SELECT c.customer_type, s.product_name AS 구매상품, s.total_amount AS 주문금액, s.order_date AS 주문일
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP'
ORDER BY s.total_amount DESC;

-- 6. 2024년 하반기 전자제품 구매
-- 2024년 7월~12월 사이에 카테고리가 '전자제품' 인 주문 내역만 조회하시오.
-- 살짝 어려웠음 (만약 데이터가 2024년도 외에 것도 있었으면 yyyy부분도 조건 줬어야 했음)

SELECT *
FROM sales
WHERE category = '전자제품' AND TO_CHAR(order_date,'mm')::INT BETWEEN 7 AND 12;


-- 7.고객별 구매 요약 (구매한 고객만)
-- 구매 이력이 있는 고객을 대상으로 고객별 고객명, 등급, 주문횟수, 총구매금액, 평균구매금액, 최근주문일을 계산하고 평균구매금액이 높은 순으로 정렬하시오.

SELECT 	c.customer_id, c.customer_name, c.customer_type, COUNT(s.id) AS 주문횟수,SUM(s.total_amount) AS 총구매금액,
		ROUND(AVG(s.total_amount),2) AS 평균구매금액, MAX(s.order_date) AS 최근주문일
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY 평균구매금액 DESC;

-- 8. 모든 고객 구매 통계 (주문 없는 고객 포함)
-- 모든 고객에 대해 주문횟수, 총구매금액, 평균구매금액, 최대구매금액을 계산하시오. 구매가 없는 경우 0으로 처리하시오.
-- 어려웠던 건 COALESCE() 함수 사용시 데이터 타입이 같아야 하는데 주문일을 처음엔 int로 변환하려고 했어서 어려웠음 
SELECT  c.customer_id, c.customer_name, c.customer_type, COUNT(s.id) AS 주문횟수, 
		COALESCE(SUM(s.total_amount),0) AS 총구매금액,
		COALESCE(ROUND(AVG(s.total_amount),2),0) AS 평균구매금액, 
		COALESCE(TO_CHAR(MAX(s.order_date)),'0') AS 최근주문일
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;


-- 9. 고객 유형 × 상품 카테고리 분석
-- 고객 유형과 상품 카테고리별로 주문건수와 총매출액을 분석하시오.

SELECT c.customer_type AS 고객유형, s.category, COUNT(*) AS 주문횟수, SUM(s.total_amount) AS 총매출
FROM sales s LEFT JOIN customers c ON c.customer_id = s.customer_id
GROUP BY c.customer_type, s.category;

-- 10. 고객 등급 분류 (활동 + 구매)
-- 각 고객을 대상으로 구매횟수와 총구매금액을 기준으로 활동등급과 구매등급을 분류하시오.
-- 활동등급(구매횟수) : [0(잠재고객) < 브론즈 < 3 <= 실버 < 5 <= 골드 < 10 <= 플래티넘]
-- 구매등급(구매총액) : [0(신규) < 일반 <= 10만 < 우수 <= 20만 < 최우수 < 50만 <= 로얄]

SELECT 	c.customer_id, c.customer_name, 
	COUNT(s.id) AS 구매횟수,
	COALESCE(SUM(s.total_amount),0) AS 총구매금액,
	CASE
		WHEN COUNT(s.id)=0 THEN '잠재고객'
		WHEN COUNT(s.id)>=10 THEN '플래티넘'
		WHEN COUNT(s.id)>=5 THEN '골드'
		WHEN COUNT(s.id)>=3 THEN '실버'
		WHEN COUNT(s.id)>0 THEN '브론즈'
	END AS 활동등급,
	CASE
		WHEN COALESCE(SUM(s.total_amount),0) =0 THEN '신규'
		WHEN COALESCE(SUM(s.total_amount),0) >=500000 THEN '로얄'
		WHEN COALESCE(SUM(s.total_amount),0) >=200000 THEN '최우수'
		WHEN COALESCE(SUM(s.total_amount),0) >=100000 THEN '우수'
		WHEN COALESCE(SUM(s.total_amount),0) >0 THEN '일반'
	END AS 구매등급
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id,c.customer_name;



-- 심화 ㄷㄷ;;
SELECT 
    활동등급, 
    구매등급, 
    COUNT(*) AS 고객수 -- 해당 등급 조합에 속하는 고객 수
FROM (
    -- 여기에 작성하신 원본 쿼리를 넣습니다
    SELECT 	
        c.customer_id, 
        c.customer_name, 
        COUNT(s.id) AS 구매횟수, -- COUNT(*)보다는 PK를 세는 것이 정확합니다
        SUM(s.total_amount) AS 총구매금액,
        CASE
            WHEN COUNT(s.id) = 0 THEN '잠재고객'
            WHEN COUNT(s.id) >= 10 THEN '플래티넘'
            WHEN COUNT(s.id) >= 50 THEN '골드' -- (참고: 숫자가 큰 조건부터 써야 정확합니다)
            WHEN COUNT(s.id) >= 3 THEN '실버'
            ELSE '브론즈'
        END AS 활동등급,
        CASE
            WHEN COALESCE(SUM(s.total_amount), 0) = 0 THEN '신규'
            WHEN SUM(s.total_amount) >= 500000 THEN '로얄'
            WHEN SUM(s.total_amount) >= 200000 THEN '최우수'
            WHEN SUM(s.total_amount) >= 100000 THEN '우수'
            ELSE '일반'
        END AS 구매등급
    FROM customers c 
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS graded_customers -- 서브쿼리에는 반드시 별칭(Alias)이 필요합니다
GROUP BY 활동등급, 구매등급
ORDER BY 활동등급, 구매등급;


COALESCE


SELECT * FROM sales;
SELECT * FROM customers;