-- 02-create-table.sql

-- 테이블 생성

CREATE TABLE sample (
	name VARCHAR(30), -- 30글자 이하 (character)
	age INT           -- 정수 (integer)
);


-- 테이블 삭제

DROP TABLE sample;



-- 실습) members 테이블 생성

CREATE TABLE members(
	-- 자동으로 1씩 증가하게! -> (mysql, mariaDB는 AUTO_INCREMENT)
	-- 해당 테이블의 PK 
	id 			INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	-- 비어있지 않게 (NULL)
	name 		VARCHAR(30) NOT NULL,
	-- 중복 허용하지 않게
	email 		VARCHAR(100) UNIQUE,
	-- 기본값 20
	age			INT DEFAULT 20,
	-- 자동으로 오늘 날짜
	join_date 	DATE DEFAULT CURRENT_DATE
);


-- 실습) members 테이블 삭제

DROP TABLE members;


CREATE TABLE members (
	-- 자동으로 1씩 올라가고, 해당 테이블의 PK 
	id 			INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	-- 비어있지 않게 (Null)
	name 		VARCHAR(30) NOT NULL,
	-- 중복 허용하지 않게
	email 		VARCHAR(100) UNIQUE,
	-- 기본값 20
	age			INT DEFAULT 20,
	-- 자동으로 오늘 날짜
	join_date 	DATE DEFAULT CURRENT_DATE
);









