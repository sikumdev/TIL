-- 10-datatype.sql

-- data type demo 테이블
CREATE TABLE dt_demo (
	id 				INT 			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name 			VARCHAR(20) 	NOT NULL,
	nickname 		VARCHAR(20),
	birth 			DATE,  
	score 			FLOAT,
	salary 			DECIMAL (20, 3),
	description 	TEXT,
	is_active 		BOOL 			DEFAULT TRUE,
	created_at 		TIMESTAMP 		DEFAULT CURRENT_TIMESTAMP  
);


INSERT INTO dt_demo (name, nickname, birth, score, salary, description)
VALUES
('김철수', 'kim', '1995-01-01', 88.75, 3500000, '우수한 학생입니다.'),
('이영희', 'lee', '1990-05-15', 92.30, 4200000.8888, '성실하고 열심히 공부합니다.'),
('박민수', 'park', '1988-09-09', 75.80, 2800000.75, '기타 사항 없음');

SELECT * FROM dt_demo;




