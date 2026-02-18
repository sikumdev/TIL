-- 04-select.sql


-- * -> 모든 컬럼
SELECT * FROM members;


-- 컬럼 지정
SELECT name, email FROM members;


-- 조건 지정
SELECT * FROM members WHERE id=3;


SELECT * FROM members WHERE age=20;

-- 컬럼 + 조건 -> 성인인 사람들의 나이와 이름만 조회
SELECT name,age FROM members WHERE age>=20;

