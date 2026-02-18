-- 20-cross-join.sql


-- 카르테시안 곱 / 즉 두 테이블에서 조합할 수 있는 모든 경우의 수를 다 보여줌

SELECT *
FROM students s CROSS JOIN courses c;


-- 예를 들어서 넷플릭스에서 고객이 안본 컨텐츠 추천할 때 쓰는 조합
-- -> 즉, 지금 조회 결과는 학생들 마다 수강하지 않는 과목을 조회하는것 

SELECT s.name, c.name
FROM students s CROSS JOIN courses c
WHERE NOT EXISTS (
	SELECT 1
	FROM students_courses sc
	WHERE sc.student_id = s.id
	AND sc.course_id = c.id
);



SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM students_courses;