-- 03-insert.sql

-- 테이블 컬럼에 값 넣기 
-- INSERT INTO members (컬럼명)
-- VALUES (위의 컬럼명과 매치되는 값들);

INSERT INTO members (name, email, age)
VALUES ('김시연','sikumdev@gmail.com', 30);

INSERT INTO members (email) VALUES ('aa@.com');

INSERT INTO members (name) VALUES ('윤찬영');

INSERT INTO members (name,email)
VALUES 	('홍길동', 'hong@example.com'),
  		('김철수', 'kim@example.com'),
    	('이영희', 'lee@example.com');


-- 테이블 조회하기
SELECT * FROM members;


-- DELETE FROM members where id=1;




