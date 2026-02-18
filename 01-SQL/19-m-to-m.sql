-- 19-m-to-m.sql


-- 각 학생별 수강 수업 확인

SELECT *
FROM students s INNER JOIN students_courses sc ON s.id = sc.student_id 
INNER JOIN courses c ON sc.course_id = c.id;

-- 교수입장에서 출석부 확인

SELECT *
FROM courses c INNER JOIN students_courses sc ON c.id = sc.course_id 
INNER JOIN students s ON sc.student_id = s.id
ORDER BY c.name;



-- 학생별로 수강과목 갯수 구해보기

SELECT s.id, s.name, COUNT(*) AS 수강과목갯수
FROM students s INNER JOIN students_courses sc ON s.id = sc.student_id 
INNER JOIN courses c ON sc.course_id = c.id
GROUP BY s.id, s.name;


-- 학생별로 수강과목 갯수와 어떤 과목을 듣는지 보기

SELECT s.id, s.name, COUNT(*) AS 수강과목갯수, STRING_AGG(c.name,',') AS 수강과목내역
FROM students s INNER JOIN students_courses sc ON s.id = sc.student_id 
INNER JOIN courses c ON sc.course_id = c.id
GROUP BY s.id, s.name;

-- 과목별 정리 
-- 수업 id, 수업 이름, 강의실, 수강인원, 학생들 이름 (한번에), 이 수업 듣는 학생들의 학점 평균 (A+=4.3, A=4,A-=3.7, B+=3.3, B=3.0,B-=2.7)
-- CASE END 문에서 컬럼명='' 무조건 홀따옴표로 표시해야함

SELECT 	c.id, c.name, c.classroom, COUNT(*) AS 수강인원,
		STRING_AGG(s.name,', ') AS 학생이름,
		ROUND(AVG(CASE
				WHEN sc.grade='A+' THEN 4.3
				WHEN sc.grade='A' THEN 4.0
				WHEN sc.grade='A-' THEN 3.7
				WHEN sc.grade='B+' THEN 3.3
				WHEN sc.grade='B' THEN 3.0
				WHEN sc.grade='B-' THEN 2.7
				ELSE 0
			END),2) AS 학점평균
FROM courses c INNER JOIN students_courses sc ON c.id = sc.course_id 
INNER JOIN students s ON sc.student_id = s.id
GROUP BY c.id, c.name, c.classroom
ORDER BY 학점평균 DESC;


SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM students_courses;