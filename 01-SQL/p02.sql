-- p02.sql [테이블 수정]

SELECT * FROM userinfo;

-- userinfo 에 email컬럼 추가 40글자 제한, 기본값은 ex@gmail.com
ALTER TABLE userinfo ADD COLUMN email VARCHAR(40) DEFAULT 'ex@gmail.com';

-- nickname 길이 제한 100자로 늘리기
ALTER TABLE userinfo ALTER COLUMN nickname TYPE VARCHAR(100);

-- reg_date 컬럼 삭제
ALTER TABLE userinfo DROP COLUMN reg_date;

-- 실제 아무나 한명의 email 수정하기

UPDATE userinfo
SET email = 'sikumdev@gmail.com'
WHERE id =1;

