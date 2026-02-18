-- 09-where.sql

CREATE TABLE students(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(10),
	age INT
);


-- DROP TABLE students;


INSERT INTO students(name, age) VALUES 	
('정 민수', 50),
('서 지훈', 30),
('윤 하늘', 20),
('최 도윤', 25),
('강 수빈', 33),
('문 태오', 18),
('백 현우', 45),
('한 유진', 10),
('임 주원', 88),
('송 민재', 67);


INSERT INTO students(name, age) VALUES
('민 현재', 67), ('박 수민', 67);

INSERT INTO students(name, age) VALUES
('박 혁거세', 20);


SELECT * FROM students;

SELECT * FROM students WHERE name ='송 민재';

SELECT * FROM students WHERE id != 1;

SELECT * FROM students WHERE age >= 30;

SELECT * FROM students WHERE age > 30;

-- 범위 (이상 ~ 이하)
SELECT * FROM students WHERE age BETWEEN 20 AND 40;

-- 다중 선택 (서로 다른 컬럼들)
SELECT * FROM students WHERE id=1 or age =30 or id=5;

-- 다중 선택 (같은 컬럼들)
SELECT * FROM students WHERE id IN (1,3,5);
SELECT * FROM students WHERE id=1 or id=3 or id=5;


-- 문자열 패턴 찾기 (% -> 있을 수도, 없을 수도, _ -> 개수만큼 있다)

-- 최씨 찾기
SELECT * FROM students WHERE name LIKE '최%';
-- 이름에 '민'글자가 있으면 모두 (민씨, 민으로 끝나는 사람, 가운데가 민인 사람)
SELECT * FROM students WHERE name LIKE '%민%';
-- 이름이 '훈'으로 끝나는 모든 사람
SELECT * FROM students WHERE name LIKE '%훈';
-- 이름이 '박' 이후 글자가 3개 있어야 한다.
SELECT * FROM students WHERE name LIKE '박 ___';














