-- 05-update.sql

-- 데이터 추가 (name='익명')
INSERT INTO members (name)
VALUES('익명');


SELECT * FROM members;

-- 데이터 수정
UPDATE members
SET name='홍길동'
WHERE name='익명';

-- 마지막 사람의 email과 나이를 수정

UPDATE members
SET email = 'gildong@example.com', age=28
WHERE id = 8;


-- 나이가 20인 사람들 모두 나이를 21로 수정
UPDATE members
SET age = 21
WHERE age =20;



