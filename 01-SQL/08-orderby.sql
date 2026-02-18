-- 08-orderby.sql
-- 특정 컬럼을 기준으로 정렬한다.
-- ASC 오름차순| DESC 내림차순


SELECT * FROM students ORDER BY id DESC; 

-- 이름 정렬 (디폴트가 오름차순)
SELECT * FROM students ORDER BY name;
-- 이름 정렬 (내림차순)
SELECT * FROM students ORDER BY name DESC;


-- 테이블 컬럼 추가 및 데이터 수정
SELECT * FROM students ORDER BY id DESC; -- id 25 까지 있음
ALTER TABLE students ADD COLUMN grade VARCHAR(1) DEFAULT 'B';
UPDATE students SET grade ='A' WHERE id BETWEEN 1 AND 8;
UPDATE students SET grade ='C' WHERE id BETWEEN 15 AND 25;


SELECT * FROM students ORDER BY id;

-- 다중 컬럼 정렬 -> 앞에 오는 컬럼이 먼저 정렬 기준
-- 같은 성적끼리 나이 줄세우기
SELECT * FROM students ORDER BY grade DESC, age ASC;
-- 같은 나이끼리 성적 줄세우기
SELECT * FROM students ORDER BY age ASC, grade DESC;


SELECT * FROM students ORDER BY id LIMIT 5;

-- 나이가 40 미만인 학생들 중에서 학점 높은 사람들중
-- 나이 많은 순으로 상위 5명 뽑기

SELECT * FROM students WHERE age < 40 
ORDER BY grade, age DESC LIMIT 5;


-- 나이가 40 미만인 학생들 중에서 학점 높은 사람들중
-- 나이 많은 순으로 상위 5명 이름만 뽑기

SELECT name FROM students WHERE age < 40
ORDER BY grade, age DESC LIMIT 5;








