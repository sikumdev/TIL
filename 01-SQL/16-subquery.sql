-- 16-subquery2.sql

/*
Scala  -> 데이터 1개    | 14.2435
Vector -> 데이터 1줄    | ("인천", "대구", "부산", "광주", "서울")
Matrix / Tensor -> 행*열 
*/

-- Scala
SELECT AVG(tota_amount) FROM sales;

-- Vector
SELECT DISTINCT region from sales;

-- 식품 결제 내역 고르기
SELECT id FROM sales WHERE category ='식품';


-- customers 테이블과 sales 테이블의 공통점은 customer_id임!

-- 회원 정보
SELECT * FROM customers;

-- 판매 정보
SELECT * FROM sales;


-- VIP들의 주문내역만 확인하기

-- 1. VIP인 고객만 찾기
SELECT customer_id FROM customers WHERE customer_type ='VIP';

-- 2. 주문내역 찾기
SELECT * FROM sales 
WHERE customer_id IN (SELECT customer_id FROM customers WHERE customer_type ='VIP');


-- [전자제품을 구매한 고객들]의 모든 주문

-- 1. 전자제품을 구매한 고객들 (customer_id) 추출 
SELECT DISTINCT customer_id
FROM sales
WHERE category ='전자제품';

-- 2. 그 고객들의 주문 내역
SELECT *
FROM sales
WHERE customer_id IN (SELECT DISTINCT customer_id FROM sales WHERE category ='전자제품');



SELECT * FROM sales;














