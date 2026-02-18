-- 07-alter-drop.sql

SELECT * FROM members;

-- 컬럼 추가 
ALTER TABLE members ADD COLUMN address VARCHAR(100) NOT NULL DEFAULT '';


-- 컬럼 수정  -> 컬럼명 변경
ALTER TABLE members RENAME COLUMN address TO juso;


-- 컬럼 수정  -> 데이터 타입 변경
ALTER TABLE members ALTER COLUMN juso TYPE VARCHAR(50);


-- 컬럼 삭제
ALTER TABLE members DROP COLUMN address;


ALTER TABLE members ALTER COLUMN age SET DEFAULT 10;