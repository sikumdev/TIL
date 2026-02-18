-- 06-delete.sql

SELECT * FROM members;


-- 테이블에서 특정 데이터 삭제 (이 경우 동명이인 모두가 삭제 되는 현상이 있으니 PK를 조건으로 주는게 올바른 방향)
DELETE FROM members WHERE name ='이영희';




-- 테이블의 모든 데이터 삭제 (쓸일이 없음)
DELETE FROM memebers;


